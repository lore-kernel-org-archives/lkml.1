Return-Path: <linux-kernel-owner+w=401wt.eu-S1760678AbXHVQFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678AbXHVQFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758856AbXHVQFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:05:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:56264 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753183AbXHVQFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:05:03 -0400
Date: Wed, 22 Aug 2007 18:05:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Jakub Jelinek <jakub@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, Kees Cook <kees@outflux.net>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH] i386 and x86_64: randomize brk()
Message-ID: <Pine.LNX.4.64.0708221750340.7792@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

i386 and x86_64: randomize brk()

This patch randomizes the location of the heap (brk) for i386 and x86_64. 
The range is randomized in the range starting at current brk location up 
to 0x02000000 offset on both architectures. This, together with 
pie-executable-randomization.patch and 
pie-executable-randomization-fix.patch, should make the address space 
randomization on i386 and x86_64 complete (modulo vDSO randomization).

The code is based on execshield code written by Ingo Molnar.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Kees Cook <kees@outflux.net>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/arch/i386/kernel/process.c b/arch/i386/kernel/process.c
index 8466471..21edde5 100644
--- a/arch/i386/kernel/process.c
+++ b/arch/i386/kernel/process.c
@@ -949,3 +949,15 @@ unsigned long arch_align_stack(unsigned long sp)
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+void arch_randomize_brk(void)
+{
+	unsigned long new_brk, range_start, range_end;
+
+	range_start = current->mm->brk;
+	range_end = range_start + 0x02000000;
+	new_brk = randomize_range(range_start, range_end, 0);
+	if (new_brk)
+		current->mm->brk = current->mm->start_brk = new_brk;
+}
+
diff --git a/arch/x86_64/kernel/process.c b/arch/x86_64/kernel/process.c
index 2842f50..37613f3 100644
--- a/arch/x86_64/kernel/process.c
+++ b/arch/x86_64/kernel/process.c
@@ -902,3 +902,15 @@ unsigned long arch_align_stack(unsigned long sp)
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+void arch_randomize_brk(void)
+{
+	unsigned long new_brk, range_start, range_end;
+
+	range_start = current->mm->brk;
+	range_end = range_start + 0x02000000;
+	new_brk = randomize_range(range_start, range_end, 0);
+	if (new_brk)
+		current->mm->brk = current->mm->start_brk = new_brk;
+}
+
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d65f1d9..790b09e 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1073,6 +1073,11 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->end_data = end_data;
 	current->mm->start_stack = bprm->p;
 
+#ifdef ARCH_HAS_RANDOMIZE_BRK
+	if (current->flags & PF_RANDOMIZE)
+		arch_randomize_brk();
+#endif
+
 	if (current->personality & MMAP_PAGE_ZERO) {
 		/* Why this, you ask???  Well SVr4 maps page 0 as read-only,
 		   and some applications "depend" upon this behavior.
diff --git a/include/asm-i386/elf.h b/include/asm-i386/elf.h
index b32df3a..34752bc 100644
--- a/include/asm-i386/elf.h
+++ b/include/asm-i386/elf.h
@@ -160,4 +160,7 @@ do if (vdso_enabled) {							\
 
 #endif
 
+#define ARCH_HAS_RANDOMIZE_BRK
+extern void arch_randomize_brk(void);
+
 #endif
diff --git a/include/asm-x86_64/elf.h b/include/asm-x86_64/elf.h
index b4fbe47..ec56e67 100644
--- a/include/asm-x86_64/elf.h
+++ b/include/asm-x86_64/elf.h
@@ -177,4 +177,7 @@ do if (vdso_enabled) {						\
 
 #endif
 
+#define ARCH_HAS_RANDOMIZE_BRK
+extern void arch_randomize_brk(void);
+
 #endif
