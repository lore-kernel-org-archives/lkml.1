Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbXGGMa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbXGGMa6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 08:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXGGMat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 08:30:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbXGGMas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 08:30:48 -0400
Date: Sat, 7 Jul 2007 08:30:04 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Rik van Riel <riel@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Kratochvil <honza@jikos.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Ernie Petrides <petrides@redhat.com>
Subject: Re: [PATCH][RESEND] PIE randomization
Message-ID: <20070707123004.GZ7012@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <Pine.LNX.4.64.0705120048230.11493@jikos.suse.cz> <Pine.LNX.4.64.0705161851120.25986@twin.jikos.cz> <alpine.LRH.0.98.0705172221440.22353@twin.jikos.cz> <20070522161642.b71ddacb.akpm@linux-foundation.org> <Pine.LNX.4.64.0705231044540.22906@jikos.suse.cz> <20070704082554.GQ7012@devserv.devel.redhat.com> <Pine.LNX.4.64.0707041927090.11634@jikos.suse.cz> <468D5A3A.1010306@redhat.com> <468D5B28.8080308@redhat.com> <Pine.LNX.4.64.0707070205460.11634@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707070205460.11634@jikos.suse.cz>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 02:13:01AM +0200, Jiri Kosina wrote:
> On Thu, 5 Jul 2007, Rik van Riel wrote:
> 
> > So the original patch has:
> > #define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
> > For some reason(?) it got changed to the clearly buggy:
> > #define BAD_ADDR(x) ((unsigned long)(x) >= PAGE_MASK)
> > Jiri's patch undoes that second buggy define, which is very
> > different from the original that was sent in by you and Ernie.
> 
> This is a part of execshield patch, fthe pie-compiled binary executable 
> memory layout randomization was extracted from - see 
> http://people.redhat.com/~mingo/exec-shield/exec-shield-nx-2.6.19.patch
> 
> Note that load_elf_interp() in vanilla kernel differs from the 
> execshield's (and pie-randomization.patch) version.
> 
> The fix makes the BAD_ADDR check whether the address belongs to the 
> ERR_PTR range, which seems valid for all uses of BAD_ADDR in the patched 
> binfmt_elf.c (do_brk(), elf_map(), do_mmap() etc return valid address or 
> err ptr) ... am I missing something obvious here?

I believe BAD_ADDR macro was changes from ((unsigned long)(x) >= TASK_SIZE)
(which is the right test for invalid user addresses, stronger check than
>= PAGE_MASK) to >= PAGE_MASK only because of the one check of the return
value of load_elf_interp.  All other uses of BAD_ADDR macro are either on
userland addresses (what do_mmap, elf_map, do_brk etc. return;
where TASK_SIZE or more is certainly wrong) or in one case still on unbiased
ELF p_vaddr:
if (BAD_ADDR(k) || elf_ppnt->p_filesz > elf_ppnt->p_memsz ||
in load_elf_binary (where >= TASK_SIZE check is ok too).

So perhaps doing this instead of changing BAD_ADDR to IS_ERR_VAL
might be better:

Signed-off-by: Jakub Jelinek <jakub@redhat.com>

--- linux/fs/binfmt_elf.c	2007-06-08 21:53:45.000000000 +0200
+++ linux/fs/binfmt_elf.c	2007-07-07 14:19:14.000000000 +0200
@@ -80,7 +80,7 @@ static struct linux_binfmt elf_format = 
 		.hasvdso	= 1
 };
 
-#define BAD_ADDR(x) ((unsigned long)(x) >= PAGE_MASK)
+#define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
 
 static int set_brk(unsigned long start, unsigned long end)
 {
@@ -1015,7 +1015,7 @@ static int load_elf_binary(struct linux_
 						    interpreter,
 						    &interp_map_addr,
 						    load_bias);
-			if (!BAD_ADDR(elf_entry)) {
+			if (!IS_ERR((void *)elf_entry)) {
 				/* load_elf_interp() returns relocation adjustment */
 				interp_load_addr = elf_entry;
 				elf_entry += loc->interp_elf_ex.e_entry;


	Jakub
