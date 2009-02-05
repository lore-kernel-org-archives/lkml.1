Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZBEXbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZBEXbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZBEXbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:31:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33119 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbZBEXbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:31:13 -0500
Date: Fri, 6 Feb 2009 00:30:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: gregkh@suse.de, ak@linux.intel.com, hpa@zytor.com, stable@kernel.org,
       stable-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: patch x86-use-early-clobbers-in-usercopy-.c.patch added to
	2.6.28-stable tree
Message-ID: <20090205233057.GA19561@elte.hu>
References: <20090202235713.C64BD4901A@coco.kroah.org> <20090203103330.GE14832@one.firstfloor.org> <20090203173753.GA8684@elte.hu> <20090205180944.GA1091@elte.hu> <20090205201558.GH14832@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205201558.GH14832@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Thu, Feb 05, 2009 at 07:09:44PM +0100, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Andi Kleen <andi@firstfloor.org> wrote:
> > > 
> > > > Just a quick comment.
> > > > > 
> > > > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > > > > Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> > > > > [ since this API is rarely used and no in-kernel user relies on a 'len'
> > > > >   return value (they only rely on negative return values) this miscompile
> > > > >   was never noticed in the field. But it's worth fixing it nevertheless. ]
> > > > 
> > > > This comment is not correct, the problem caused really non booting kernels 
> > > > for Hugh (although in somewhat exotic configurations). do_mount relies on 
> > > > it.
> > > 
> > > Where's the URL for the crash and the config? Why wasnt that info in the 
> > > patch? There's no public discussion that i can find either.
> > 
> > Ping? You complained about something but you didnt reply to my question.
> 
> Sorry I was travelling and behind on mail.
> 
> The report was in private mail which I'm not comfortable to forward.

Nobody asked you to forward private emails. All that was needed was the 
impact information which you already shared above, that the bug caused a 
non-booting kernel for Hugh.

As a contributor of a Linux kernel patch it is one of your duties to 
describe practical impact. You decided to not come forward with that 
information in your submission, and then you complain that your vague 
changelog was misinterpreted by us - fully knowing that changing a git 
commit message in hindsight is not possible.

So given that the fix is upstream already and that it is queued up in 
-stable (and rightly so) the only purpose of your complaint about the log 
message can be that you wanted to create some petty controversy about the 
log message.

Doing so is your full right but you should know that actions like that
makes me trust you less every day. And in case you didnt notice, regarding
your whining in your re-submission [attached below]:

>   x86@kernel.org seems to be the usual blackhole and ignored it.

The delay we have in processing your patches (5 days in this case) is
caused by your unwillingness to communicate and work efficiently with
the x86 maintainers.

You have the track record of a high-cost contributor: you frequently argue 
about nonsensical, backwards looking issues (like here), you frequently 
resist requests for changes to patches, you withhold information and you 
stubbornly refuse to follow established contribution practices.

All in one, you expect to be treated in a special way, but in reality you 
are not special, and the high cost and difficulty of communicating and 
working with you makes us put you to the end of our TODO list.

	Ingo

--------------------------------------->

Date: Wed, 21 Jan 2009 06:31:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, akpm@osdl.org
Subject: [RESEND] [PATCH] Use early clobbers in usercopy_64.c
Cc: hugh@veritas.com

Andrew, can you please merge this patch? 
x86@kernel.org seems to be the usual blackhole and ignored it.
It's a critical bugfix for both 2.6.29 and 2.6.28-stable

-Andi

commit 229689f6f129334446e48e777d12cbf365745283
Author: Andi Kleen <ak@linux.intel.com>
Date:   Wed Jan 14 07:50:57 2009 +0100

    Use early clobbers in usercopy_*.c
    
    Hugh Dickins noticed that strncpy_from_user() was miscompiled
    in some circumstances with gcc 4.3.
    
    Thanks to Hugh's excellent analysis it was easy to track down.
    
    Hugh writes:
    
    Try building an x86_64 defconfig 2.6.29-rc1 kernel tree,
    except not quite defconfig, switch CONFIG_PREEMPT_NONE=y
    and CONFIG_PREEMPT_VOLUNTARY off (because it expands a
    might_fault() there, which hides the issue): using a
    gcc 4.3.2 (I've checked both openSUSE 11.1 and Fedora 10).
    
    It generates the following:
    
    0000000000000000 <__strncpy_from_user>:
       0:   48 89 d1                mov    %rdx,%rcx
       3:   48 85 c9                test   %rcx,%rcx
       6:   74 0e                   je     16 <__strncpy_from_user+0x16>
       8:   ac                      lods   %ds:(%rsi),%al
       9:   aa                      stos   %al,%es:(%rdi)
       a:   84 c0                   test   %al,%al
       c:   74 05                   je     13 <__strncpy_from_user+0x13>
       e:   48 ff c9                dec    %rcx
      11:   75 f5                   jne    8 <__strncpy_from_user+0x8>
      13:   48 29 c9                sub    %rcx,%rcx
      16:   48 89 c8                mov    %rcx,%rax
      19:   c3                      retq
    
    Observe that "sub %rcx,%rcx; mov %rcx,%rax", whereas gcc 4.2.1
    (and many other configs) say "sub %rcx,%rdx; mov %rdx,%rax".
    Isn't it returning 0 when it ought to be returning strlen?
    
    AK:
    
    The asm constraints for the strncpy_from_user() result were missing an
    early clobber, which tells gcc that the last output arguments
    are written before all input arguments are read.
    
    I also added some more early clobbers in the rest of the file.
    
    And indeed 32bit usercopy.c had the same problem in some places.
    Fixed there too.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 4a20b2f..7c8ca91 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -56,7 +56,7 @@ do {									   \
 		"	jmp 2b\n"					   \
 		".previous\n"						   \
 		_ASM_EXTABLE(0b,3b)					   \
-		: "=d"(res), "=c"(count), "=&a" (__d0), "=&S" (__d1),	   \
+		: "=&d"(res), "=&c"(count), "=&a" (__d0), "=&S" (__d1),	   \
 		  "=&D" (__d2)						   \
 		: "i"(-EFAULT), "0"(count), "1"(count), "3"(src), "4"(dst) \
 		: "memory");						   \
@@ -218,7 +218,7 @@ long strnlen_user(const char __user *s, long n)
 		"	.align 4\n"
 		"	.long 0b,2b\n"
 		".previous"
-		:"=r" (n), "=D" (s), "=a" (res), "=c" (tmp)
+		:"=&r" (n), "=&D" (s), "=&a" (res), "=&c" (tmp)
 		:"0" (n), "1" (s), "2" (0), "3" (mask)
 		:"cc");
 	return res & mask;
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 64d6c84..ec13cb5 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -32,7 +32,7 @@ do {									   \
 		"	jmp 2b\n"					   \
 		".previous\n"						   \
 		_ASM_EXTABLE(0b,3b)					   \
-		: "=r"(res), "=c"(count), "=&a" (__d0), "=&S" (__d1),	   \
+		: "=&r"(res), "=&c"(count), "=&a" (__d0), "=&S" (__d1),	   \
 		  "=&D" (__d2)						   \
 		: "i"(-EFAULT), "0"(count), "1"(count), "3"(src), "4"(dst) \
 		: "memory");						   \
@@ -86,7 +86,7 @@ unsigned long __clear_user(void __user *addr, unsigned long size)
 		".previous\n"
 		_ASM_EXTABLE(0b,3b)
 		_ASM_EXTABLE(1b,2b)
-		: [size8] "=c"(size), [dst] "=&D" (__d0)
+		: [size8] "=&c"(size), [dst] "=&D" (__d0)
 		: [size1] "r"(size & 7), "[size8]" (size / 8), "[dst]"(addr),
 		  [zero] "r" (0UL), [eight] "r" (8UL));
 	return size;
