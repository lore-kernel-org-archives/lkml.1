Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZGLSYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZGLSYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZGLSYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:24:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155AbZGLSYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:24:45 -0400
Date: Sun, 12 Jul 2009 11:24:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frans Pop <elendil@planet.nl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       barryn@pobox.com, bugme-daemon@bugzilla.kernel.org,
       Ian Lance Taylor <iant@google.com>
Subject: Re: [Bug 13012] 2.6.28.9 causes init to segfault on Debian etch;
 2.6.28.8 OK
In-Reply-To: <alpine.LFD.2.01.0907121058040.3552@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0907121106530.3552@localhost.localdomain>
References: <200907100928.07369.elendil@planet.nl> <200907101659.31813.elendil@planet.nl> <alpine.LFD.2.01.0907121058040.3552@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 12 Jul 2009, Linus Torvalds wrote:
> 
> From everything I have been able to find, I really prefer the second 
> version. Not only is the patch cleaner, but it looks like code generation 
> is better too (for some inexplicable reason, but I suspect it's because 
> -fno-strict-overflow is just saner).

Hmm. I just checked. The file that caused us to do this thing in the first 
place (fs/open.c, around like 415, which does:

	/* Check for wrap through zero too */
	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
		goto out_fput;

to check that the resulting 'loffset_t' type is all good) has interesting 
behaviour with my version of gcc (gcc version 4.4.0 20090506 (Red Hat 
4.4.0-4) (GCC)).

 - Without any options:
        leaq    (%rcx,%rdx), %rdi       #, tmp73
        movq    256(%rbx), %rsi # <variable>.i_sb, <variable>.i_sb
        movl    $-27, %eax      #, D.29131
        cmpq    40(%rsi), %rdi  # <variable>.s_maxbytes, tmp73
        ja      .L148   #,

 - With -fno-strict-overflow:
        leaq    (%rcx,%rdx), %rax       #, D.29157
        movq    256(%rbx), %rsi # <variable>.i_sb, <variable>.i_sb
        cmpq    40(%rsi), %rax  # <variable>.s_maxbytes, D.29157
        ja      .L154   #,
        testq   %rax, %rax      # D.29157
        js      .L154   #,

 - With -fwrapv:
        leaq    (%rcx,%rdx), %rax       #, D.29158
        movq    256(%rbx), %rsi # <variable>.i_sb, <variable>.i_sb
        cmpq    40(%rsi), %rax  # <variable>.s_maxbytes, D.29158
        ja      .L154   #,
        testq   %rax, %rax      # D.29158
        js      .L154   #,

and from this it would look like:

 - gcc on its own is actually the best version (the first comparison is 
   unsigned because s_maxbytes is actually 'unsigned long long', so it 
   actually does the right thing!)

   In other words, the whole '< 0' was unnecessary, but does make the 
   source code way more readable, and makes the source code _correct_ 
   regardless of any type issues!

 - From a cursory inspection, -fno-strict-overflow  and -fwrapv are both 
   equivalent in this code, and both do the stupid thing (but for good 
   reason - gcc doesn't know that 's_maxbytes' might not be 'negative in a 
   loffset_t', so technically speaking the extraneous 'js' is not 
   extraneous, because it can actually trigger some "more negative" 
   entries than s_maxbyes is.

 - HOWEVER:

	[torvalds@nehalem ~]$ git diff --stat open.s open.s-fno-strict-overflow 
	 open.s => open.s-fno-strict-overflow |   22 +++++++++++++---------
	 1 files changed, 13 insertions(+), 9 deletions(-)
	[torvalds@nehalem ~]$ git diff --stat open.s open.s-fwrapv
	 open.s => open.s-fwrapv |  296 ++++++++++++++++++++++++-----------------------
	 1 files changed, 150 insertions(+), 146 deletions(-)

  where the _only_ difference that '-fno-strict-overflow' introduces is 
  that one small area (it's saying 22 lines changed, but that's because 
  there's also the compiler option listing at the top of the file etc)

  In contrast, -fwrapv has done a lot of other changes too. Now, in both 
  cases, it really only added the same four instructions (testq + js +
  branchtarget + jumparound).

It looks like 'fwrapv' generates more temporaries (possibly for the code 
that treies to enforce the exact twos-complement behavior) that then all 
get optimized back out again. The differences seem to be in the temporary 
variable numbers etc, not in the actual code.

So fwrapv really _is_ different from fno-strict-pverflow, and disturbs the 
code generation more.

IOW, I'm convinced we should never use fwrapv. It's clearly a buggy piece 
of sh*t, as shown by our 4.1.x experiences. We should use 
-fno-strict-overflow.

Will commit the following (which also fits naming-wise with our use of 
'-fno-strict-aliasing').

		Linus

---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 0aeec59..bbe8453 100644
--- a/Makefile
+++ b/Makefile
@@ -565,7 +565,7 @@ KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 
 # disable invalid "can't wrap" optimizations for signed / pointers
-KBUILD_CFLAGS	+= $(call cc-option,-fwrapv)
+KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
 
 # revert to pre-gcc-4.4 behaviour of .eh_frame
 KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
