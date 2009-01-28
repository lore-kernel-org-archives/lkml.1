Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZA1Wna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZA1Wna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbZA1Wmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:42:39 -0500
Received: from gw.goop.org ([64.81.55.164]:52551 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751702AbZA1Wmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:42:37 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 7] x86/pvops: add a paravirt_ident functions to allow
	special patching
X-Mercurial-Node: 79ff4280c71ffeba69d2b54756ae8ce7c8dcf295
Message-Id: <79ff4280c71ffeba69d2.1233182102@abulafia.goop.org>
In-Reply-To: <patchbomb.1233182100@abulafia.goop.org>
References: <patchbomb.1233182100@abulafia.goop.org>
Date: Wed, 28 Jan 2009 14:35:02 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several paravirt ops implementations simply return their arguments,
the most obvious being the make_pte/pte_val class of operations on
native.

On 32-bit, the identity function is literally a no-op, as the calling
convention uses the same registers for the first argument and return.
On 64-bit, it can be implemented with a single "mov".

This patch adds special identity functions for 32 and 64 bit argument,
and machinery to recognize them and replace them with either nops or a
mov as appropriate.

At the moment, the only users for the identity functions are the
pagetable entry conversion functions.

The result is a measureable improvement on pagetable-heavy benchmarks
(2-3%, reducing the pvops overhead from 5 to 2%).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h     |    5 ++
 arch/x86/kernel/paravirt.c          |   75 ++++++++++++++++++++++++++++++-----
 arch/x86/kernel/paravirt_patch_32.c |   12 +++++
 arch/x86/kernel/paravirt_patch_64.c |   15 +++++++
 4 files changed, 98 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -388,6 +388,8 @@
 	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
 
 unsigned paravirt_patch_nop(void);
+unsigned paravirt_patch_ident_32(void *insnbuf, unsigned len);
+unsigned paravirt_patch_ident_64(void *insnbuf, unsigned len);
 unsigned paravirt_patch_ignore(unsigned len);
 unsigned paravirt_patch_call(void *insnbuf,
 			     const void *target, u16 tgt_clobbers,
@@ -1371,6 +1373,9 @@
 }
 
 void _paravirt_nop(void);
+u32 _paravirt_ident_32(u32);
+u64 _paravirt_ident_64(u64);
+
 #define paravirt_nop	((void *)_paravirt_nop)
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -44,6 +44,17 @@
 {
 }
 
+/* identity function, which can be inlined */
+u32 _paravirt_ident_32(u32 x)
+{
+	return x;
+}
+
+u64 _paravirt_ident_64(u64 x)
+{
+	return x;
+}
+
 static void __init default_banner(void)
 {
 	printk(KERN_INFO "Booting paravirtualized kernel on %s\n",
@@ -138,9 +149,16 @@
 	if (opfunc == NULL)
 		/* If there's no function, patch it with a ud2a (BUG) */
 		ret = paravirt_patch_insns(insnbuf, len, ud2a, ud2a+sizeof(ud2a));
-	else if (opfunc == paravirt_nop)
+	else if (opfunc == _paravirt_nop)
 		/* If the operation is a nop, then nop the callsite */
 		ret = paravirt_patch_nop();
+
+	/* identity functions just return their single argument */
+	else if (opfunc == _paravirt_ident_32)
+		ret = paravirt_patch_ident_32(insnbuf, len);
+	else if (opfunc == _paravirt_ident_64)
+		ret = paravirt_patch_ident_64(insnbuf, len);
+
 	else if (type == PARAVIRT_PATCH(pv_cpu_ops.iret) ||
 		 type == PARAVIRT_PATCH(pv_cpu_ops.irq_enable_sysexit) ||
 		 type == PARAVIRT_PATCH(pv_cpu_ops.usergs_sysret32) ||
@@ -373,6 +391,45 @@
 #endif
 };
 
+typedef pte_t make_pte_t(pteval_t);
+typedef pmd_t make_pmd_t(pmdval_t);
+typedef pud_t make_pud_t(pudval_t);
+typedef pgd_t make_pgd_t(pgdval_t);
+
+typedef pteval_t pte_val_t(pte_t);
+typedef pmdval_t pmd_val_t(pmd_t);
+typedef pudval_t pud_val_t(pud_t);
+typedef pgdval_t pgd_val_t(pgd_t);
+
+
+#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_PAE)
+/* 32-bit pagetable entries */
+#define paravirt_native_make_pte	(make_pte_t *)_paravirt_ident_32
+#define paravirt_native_pte_val		(pte_val_t *)_paravirt_ident_32
+
+#define paravirt_native_make_pmd	(make_pmd_t *)_paravirt_ident_32
+#define paravirt_native_pmd_val		(pmd_val_t *)_paravirt_ident_32
+
+#define paravirt_native_make_pud	(make_pud_t *)_paravirt_ident_32
+#define paravirt_native_pud_val		(pud_val_t *)_paravirt_ident_32
+
+#define paravirt_native_make_pgd	(make_pgd_t *)_paravirt_ident_32
+#define paravirt_native_pgd_val		(pgd_val_t *)_paravirt_ident_32
+#else
+/* 64-bit pagetable entries */
+#define paravirt_native_make_pte	(make_pte_t *)_paravirt_ident_64
+#define paravirt_native_pte_val		(pte_val_t *)_paravirt_ident_64
+
+#define paravirt_native_make_pmd	(make_pmd_t *)_paravirt_ident_64
+#define paravirt_native_pmd_val		(pmd_val_t *)_paravirt_ident_64
+
+#define paravirt_native_make_pud	(make_pud_t *)_paravirt_ident_64
+#define paravirt_native_pud_val		(pud_val_t *)_paravirt_ident_64
+
+#define paravirt_native_make_pgd	(make_pgd_t *)_paravirt_ident_64
+#define paravirt_native_pgd_val		(pgd_val_t *)_paravirt_ident_64
+#endif
+
 struct pv_mmu_ops pv_mmu_ops = {
 #ifndef CONFIG_X86_64
 	.pagetable_setup_start = native_pagetable_setup_start,
@@ -424,21 +481,21 @@
 	.pmd_clear = native_pmd_clear,
 #endif
 	.set_pud = native_set_pud,
-	.pmd_val = native_pmd_val,
-	.make_pmd = native_make_pmd,
+	.pmd_val = paravirt_native_pmd_val,
+	.make_pmd = paravirt_native_make_pmd,
 
 #if PAGETABLE_LEVELS == 4
-	.pud_val = native_pud_val,
-	.make_pud = native_make_pud,
+	.pud_val = paravirt_native_pud_val,
+	.make_pud = paravirt_native_make_pud,
 	.set_pgd = native_set_pgd,
 #endif
 #endif /* PAGETABLE_LEVELS >= 3 */
 
-	.pte_val = native_pte_val,
-	.pgd_val = native_pgd_val,
+	.pte_val = paravirt_native_pte_val,
+	.pgd_val = paravirt_native_pgd_val,
 
-	.make_pte = native_make_pte,
-	.make_pgd = native_make_pgd,
+	.make_pte = paravirt_native_make_pte,
+	.make_pgd = paravirt_native_make_pgd,
 
 	.dup_mmap = paravirt_nop,
 	.exit_mmap = paravirt_nop,
diff --git a/arch/x86/kernel/paravirt_patch_32.c b/arch/x86/kernel/paravirt_patch_32.c
--- a/arch/x86/kernel/paravirt_patch_32.c
+++ b/arch/x86/kernel/paravirt_patch_32.c
@@ -12,6 +12,18 @@
 DEF_NATIVE(pv_cpu_ops, clts, "clts");
 DEF_NATIVE(pv_cpu_ops, read_tsc, "rdtsc");
 
+unsigned paravirt_patch_ident_32(void *insnbuf, unsigned len)
+{
+	/* arg in %eax, return in %eax */
+	return 0;
+}
+
+unsigned paravirt_patch_ident_64(void *insnbuf, unsigned len)
+{
+	/* arg in %edx:%eax, return in %edx:%eax */
+	return 0;
+}
+
 unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
 		      unsigned long addr, unsigned len)
 {
diff --git a/arch/x86/kernel/paravirt_patch_64.c b/arch/x86/kernel/paravirt_patch_64.c
--- a/arch/x86/kernel/paravirt_patch_64.c
+++ b/arch/x86/kernel/paravirt_patch_64.c
@@ -19,6 +19,21 @@
 DEF_NATIVE(pv_cpu_ops, usergs_sysret32, "swapgs; sysretl");
 DEF_NATIVE(pv_cpu_ops, swapgs, "swapgs");
 
+DEF_NATIVE(, mov32, "mov %edi, %eax");
+DEF_NATIVE(, mov64, "mov %rdi, %rax");
+
+unsigned paravirt_patch_ident_32(void *insnbuf, unsigned len)
+{
+	return paravirt_patch_insns(insnbuf, len,
+				    start__mov32, end__mov32);
+}
+
+unsigned paravirt_patch_ident_64(void *insnbuf, unsigned len)
+{
+	return paravirt_patch_insns(insnbuf, len,
+				    start__mov64, end__mov64);
+}
+
 unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
 		      unsigned long addr, unsigned len)
 {


