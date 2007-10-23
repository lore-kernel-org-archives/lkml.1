Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbXJWWNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbXJWWNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXJWWNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:13:14 -0400
Received: from styx.suse.cz ([82.119.242.94]:39658 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752344AbXJWWNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:13:13 -0400
Date: Wed, 24 Oct 2007 00:13:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] i386 and x86_64: randomize brk()
In-Reply-To: <Pine.LNX.4.64.0710200005350.12935@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0710240009250.12935@jikos.suse.cz>
References: <Pine.LNX.4.64.0709111416390.7343@jikos.suse.cz>
 <20071011011800.0c051792.akpm@linux-foundation.org>
 <20071011015553.cdf05128.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0710200005350.12935@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Oct 2007, Jiri Kosina wrote:

> > And on s390
> > In file included from arch/s390/kernel/binfmt_elf32.c:202:
> > arch/s390/kernel/../../../fs/binfmt_elf.c: In function 'load_elf_binary':
> > arch/s390/kernel/../../../fs/binfmt_elf.c:1088: error: implicit declaration of function 'arch_randomize_brk'
> > I'll drop the patch.
> > Really we should fix the elf mess before we try and change it any more.
> ... back to this a week old thread about already dropped patch.
> I am thinking about going back to the original idea of just simply 
> defining ARCH_HAS_RANDOMIZE_BRK and not caring for the ELF crap any more 
> for now. This way the patch is as small as possible, and doesn't interfere 
> with the ELF cross-arch craziness at all.
> Here I posted such version of the patch: 
> http://lkml.org/lkml/2007/8/22/254 and here you asked me to put empty 
> stubs into elf.h, which turned out to be too headache for some archs: 
> http://lkml.org/lkml/2007/8/22/492

And here it goes, rebased on top of current Linus' -git, please consider 
queuing in -mm for 2.6.25.


From: Jiri Kosina <jkosina@suse.cz>

x86: randomize brk()

Randomize the location of the heap (brk) for i386 and x86_64.  The range is
randomized in the range starting at current brk location up to 0x02000000
offset for both architectures.  This, together with
pie-executable-randomization.patch and
pie-executable-randomization-fix.patch, should make the address space
randomization on i386 and x86_64 complete.

Arjan says:

This is known to break older versions of some emacs variants, whose dumper
code assumed that the last variable declared in the program is equal to the
start of the dynamically allocated memory region.

(The dumper is the code where emacs effectively dumps core at the end of it's
compilation stage; this coredump is then loaded as the main program during
normal use)

iirc this was 5 years or so; we found this way back when I was at RH and we
first did the security stuff there (including this brk randomization).  It
wasn't all variants of emacs, and it got fixed as a result (I vaguely remember
that emacs already had code to deal with it for other archs/oses, just
ifdeffed wrongly).

It's a rare and wrong assumption as a general thing, just on x86 it mostly
happened to be true (but to be honest, it'll break too if gcc does something
fancy or if the linker does a non-standard order).  Still its something we
should at least document.

Note 2: afaik it only broke the emacs *build*.  I'm not 100% sure about that
(it IS 5 years ago) though.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7b89958..b6578c7 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -971,3 +971,10 @@ unsigned long arch_align_stack(unsigned long sp)
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+unsigned long arch_randomize_brk(struct mm_struct *mm)
+{
+	unsigned long range_end = mm->brk + 0x02000000;
+	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+}
+
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6309b27..347cd06 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -903,3 +903,10 @@ unsigned long arch_align_stack(unsigned long sp)
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+unsigned long arch_randomize_brk(struct mm_struct *mm)
+{
+	unsigned long range_end = mm->brk + 0x02000000;
+	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+}
+
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 12c3179..2d48a69 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1084,6 +1084,12 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->end_data = end_data;
 	current->mm->start_stack = bprm->p;
 
+#ifdef ARCH_HAS_RANDOMIZE_BRK
+	if (current->flags & PF_RANDOMIZE)
+		current->mm->brk = current->mm->start_brk =
+			arch_randomize_brk(current->mm);
+#endif
+
 	if (current->personality & MMAP_PAGE_ZERO) {
 		/* Why this, you ask???  Well SVr4 maps page 0 as read-only,
 		   and some applications "depend" upon this behavior.
diff --git a/include/asm-x86/elf_32.h b/include/asm-x86/elf_32.h
index b3f694e..58949e7 100644
--- a/include/asm-x86/elf_32.h
+++ b/include/asm-x86/elf_32.h
@@ -153,6 +153,9 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 
 extern unsigned int vdso_enabled;
 
+#define ARCH_HAS_RANDOMIZE_BRK
+extern unsigned long arch_randomize_brk(struct mm_struct *mm);
+
 /* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 #define ARCH_DLINFO							\
 do if (vdso_enabled) {							\
diff --git a/include/asm-x86/elf_64.h b/include/asm-x86/elf_64.h
index b4fbe47..177afa3 100644
--- a/include/asm-x86/elf_64.h
+++ b/include/asm-x86/elf_64.h
@@ -170,6 +170,9 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 
 extern int vdso_enabled;
 
+#define ARCH_HAS_RANDOMIZE_BRK
+extern unsigned long arch_randomize_brk(struct mm_struct *mm);
+
 #define ARCH_DLINFO						\
 do if (vdso_enabled) {						\
 	NEW_AUX_ENT(AT_SYSINFO_EHDR,(unsigned long)current->mm->context.vdso);\
