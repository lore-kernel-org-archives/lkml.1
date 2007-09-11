Return-Path: <linux-kernel-owner+w=401wt.eu-S1763812AbXIKMVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763812AbXIKMVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 08:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757936AbXIKMV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 08:21:28 -0400
Received: from styx.suse.cz ([82.119.242.94]:47307 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757526AbXIKMV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 08:21:28 -0400
Date: Tue, 11 Sep 2007 14:17:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [RESEND] i386 and x86_64: randomize brk()
Message-ID: <Pine.LNX.4.64.0709111416390.7343@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 8466471..8e0624d 100644
--- a/arch/i386/kernel/process.c
+++ b/arch/i386/kernel/process.c
@@ -949,3 +949,17 @@ unsigned long arch_align_stack(unsigned long sp)
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+unsigned long arch_randomize_brk(unsigned long brk)
+{
+	unsigned long new_brk;
+	unsigned long range_end;
+
+	range_end = brk + 0x02000000;
+	new_brk = randomize_range(brk, range_end, 0);
+	if (new_brk)
+		return new_brk;
+	else
+		return brk;
+}
+
diff --git a/arch/x86_64/kernel/process.c b/arch/x86_64/kernel/process.c
index 2842f50..b20f0eb 100644
--- a/arch/x86_64/kernel/process.c
+++ b/arch/x86_64/kernel/process.c
@@ -902,3 +902,17 @@ unsigned long arch_align_stack(unsigned long sp)
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+unsigned long arch_randomize_brk(unsigned long brk)
+{
+	unsigned long new_brk;
+	unsigned long range_end;
+
+	range_end = brk + 0x02000000;
+	new_brk = randomize_range(brk, range_end, 0);
+	if (new_brk)
+		return new_brk;
+	else
+		return brk;
+}
+
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d65f1d9..7afec71 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -47,6 +47,9 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
 static int load_elf_library(struct file *);
 static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);
 
+/* overriden by architectures supporting brk randomization */
+unsigned long __weak arch_randomize_brk(unsigned long brk) { return brk; }
+
 /*
  * If we don't support core dumping, then supply a NULL so we
  * don't even try.
@@ -1073,6 +1076,10 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->end_data = end_data;
 	current->mm->start_stack = bprm->p;
 
+	if (current->flags & PF_RANDOMIZE)
+		current->mm->brk = current->mm->start_brk = 
+			arch_randomize_brk(current->mm->brk);
+
 	if (current->personality & MMAP_PAGE_ZERO) {
 		/* Why this, you ask???  Well SVr4 maps page 0 as read-only,
 		   and some applications "depend" upon this behavior.

