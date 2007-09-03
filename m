Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbXICKDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbXICKDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbXICKDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:03:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:48419 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751650AbXICKDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:03:01 -0400
Date: Mon, 3 Sep 2007 12:03:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 and x86_64: randomize brk()
In-Reply-To: <Pine.LNX.4.64.0709031130000.16753@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0709031201380.16753@jikos.suse.cz>
References: <Pine.LNX.4.64.0708301545100.4135@jikos.suse.cz>
 <8bd0f97a0708300701r1f36bc0anc45b9cad4a11f2ef@mail.gmail.com>
 <Pine.LNX.4.64.0708301620010.4135@jikos.suse.cz>
 <8bd0f97a0708300726h563808a6j2b2ef9adf805c109@mail.gmail.com>
 <Pine.LNX.4.64.0708301708590.4135@jikos.suse.cz>
 <20070830180538.b52b802d.akpm@linux-foundation.org> <46D9C935.3000701@gmail.com>
 <20070902132847.5fc968b1.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0709031130000.16753@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Sep 2007, Jiri Kosina wrote:

> the problem I am seeing with __weak functions is that as far as I can 
> see, gcc 4.1.0 optimizes the empty __weak function away with -O2, so it 
> is not later properly overridden by the other non-weak function, as the 
> callsite already doesn't have the corresponding call. (when I stick a 
> printk() into the __weak function, everything works fine - it is not 
> optimized away and non-weak version of the function gets called). I 
> persume this is a bug in gcc (4.1.1 doesn't seem to expose this 
> behavior). I will look at it a little bit more.

OK, the problem was crappy 4.1.1 gcc on my side (that has been a known bug 
and already fixed in later update). Updated patch below, thanks for your 
suggestions Franck.


From: Jiri Kosina <jkosina@suse.cz>

i386 and x86_64: randomize brk()

This patch randomizes the location of the heap (brk) for i386 and x86_64. 
The range is randomized in the range starting at current brk location up 
to 0x02000000 offset for both architectures. This, together with 
pie-executable-randomization.patch and 
pie-executable-randomization-fix.patch, should make the address space 
randomization on i386 and x86_64 complete.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/arch/i386/kernel/process.c b/arch/i386/kernel/process.c
index 8466471..fb3d407 100644
--- a/arch/i386/kernel/process.c
+++ b/arch/i386/kernel/process.c
@@ -949,3 +949,17 @@ unsigned long arch_align_stack(unsigned long sp)
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+void arch_randomize_brk(struct mm_struct *mm)
+{
+	unsigned long new_brk;
+	unsigned long range_start;
+	unsigned long range_end;
+
+	range_start = mm->brk;
+	range_end = range_start + 0x02000000;
+	new_brk = randomize_range(range_start, range_end, 0);
+	if (new_brk)
+		mm->brk = mm->start_brk = new_brk;
+}
+
diff --git a/arch/x86_64/kernel/process.c b/arch/x86_64/kernel/process.c
index 2842f50..de40057 100644
--- a/arch/x86_64/kernel/process.c
+++ b/arch/x86_64/kernel/process.c
@@ -902,3 +902,17 @@ unsigned long arch_align_stack(unsigned long sp)
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+void arch_randomize_brk(struct mm_struct *mm)
+{
+	unsigned long new_brk;
+	unsigned long range_start;
+	unsigned long range_end;
+
+	range_start = mm->brk;
+	range_end = range_start + 0x02000000;
+	new_brk = randomize_range(range_start, range_end, 0);
+	if (new_brk)
+		mm->brk = mm->start_brk = new_brk;
+}
+
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d65f1d9..4bf0ca1 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -47,6 +47,9 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
 static int load_elf_library(struct file *);
 static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);
 
+/* overriden by architectures supporting brk randomization */
+void __weak arch_randomize_brk(struct mm_struct *mm) { }
+
 /*
  * If we don't support core dumping, then supply a NULL so we
  * don't even try.
@@ -1073,6 +1076,9 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->end_data = end_data;
 	current->mm->start_stack = bprm->p;
 
+	if (current->flags & PF_RANDOMIZE)
+		arch_randomize_brk(current->mm);
+
 	if (current->personality & MMAP_PAGE_ZERO) {
 		/* Why this, you ask???  Well SVr4 maps page 0 as read-only,
 		   and some applications "depend" upon this behavior.

