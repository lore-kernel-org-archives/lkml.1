Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZCFO3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZCFO3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbZCFO2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:28:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:42121 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbZCFO2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:28:33 -0500
Date: Fri, 6 Mar 2009 14:27:53 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236265498.31324.12.camel@penberg-laptop>
References: <1236265498.31324.12.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: unify noexec handling
Message-ID: <tip-ffc442a919c8b714383e7464e905485bafc22039@git.kernel.org>
Git-Commit-ID: ffc442a919c8b714383e7464e905485bafc22039
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 14:27:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffc442a919c8b714383e7464e905485bafc22039
Gitweb:     http://git.kernel.org/tip/ffc442a919c8b714383e7464e905485bafc22039
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 17:04:58 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 15:25:53 +0100

x86: unify noexec handling

Impact: cleanup

This patch unifies noexec handling on 32-bit and 64-bit.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1236265498.31324.12.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/pgtable_types.h |    1 -
 arch/x86/mm/init.c                   |   65 ++++++++++++++++++++++++++++++++--
 arch/x86/mm/init_32.c                |   50 --------------------------
 arch/x86/mm/init_64.c                |   33 -----------------
 4 files changed, 62 insertions(+), 87 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index b8238dc..4d258ad 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -273,7 +273,6 @@ typedef struct page *pgtable_t;
 
 extern pteval_t __supported_pte_mask;
 extern int nx_enabled;
-extern void set_nx(void);
 
 #define pgprot_writecombine	pgprot_writecombine
 extern pgprot_t pgprot_writecombine(pgprot_t prot);
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 15219e0..5d06d25 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -22,6 +22,67 @@ int direct_gbpages
 #endif
 ;
 
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+static int disable_nx __initdata;
+
+/*
+ * noexec = on|off
+ *
+ * Control non-executable mappings for processes.
+ *
+ * on      Enable
+ * off     Disable
+ */
+static int __init noexec_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+	if (!strncmp(str, "on", 2)) {
+		__supported_pte_mask |= _PAGE_NX;
+		disable_nx = 0;
+	} else if (!strncmp(str, "off", 3)) {
+		disable_nx = 1;
+		__supported_pte_mask &= ~_PAGE_NX;
+	}
+	return 0;
+}
+early_param("noexec", noexec_setup);
+#endif
+
+#ifdef CONFIG_X86_PAE
+static void __init set_nx(void)
+{
+	unsigned int v[4], l, h;
+
+	if (cpu_has_pae && (cpuid_eax(0x80000000) > 0x80000001)) {
+		cpuid(0x80000001, &v[0], &v[1], &v[2], &v[3]);
+
+		if ((v[3] & (1 << 20)) && !disable_nx) {
+			rdmsr(MSR_EFER, l, h);
+			l |= EFER_NX;
+			wrmsr(MSR_EFER, l, h);
+			nx_enabled = 1;
+			__supported_pte_mask |= _PAGE_NX;
+		}
+	}
+}
+#else
+static inline void set_nx(void)
+{
+}
+#endif
+
+#ifdef CONFIG_X86_64
+void __cpuinit check_efer(void)
+{
+	unsigned long efer;
+
+	rdmsrl(MSR_EFER, efer);
+	if (!(efer & EFER_NX) || disable_nx)
+		__supported_pte_mask &= ~_PAGE_NX;
+}
+#endif
+
 static void __init find_early_table_space(unsigned long end, int use_pse,
 					  int use_gbpages)
 {
@@ -158,13 +219,11 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	use_gbpages = direct_gbpages;
 #endif
 
-#ifdef CONFIG_X86_32
-#ifdef CONFIG_X86_PAE
 	set_nx();
 	if (nx_enabled)
 		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
-#endif
 
+#ifdef CONFIG_X86_32
 	/* Enable PSE if available */
 	if (cpu_has_pse)
 		set_in_cr4(X86_CR4_PSE);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 2966c6b..8ff1173 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -592,56 +592,6 @@ int nx_enabled;
 pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL | _PAGE_IOMAP);
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
-#ifdef CONFIG_X86_PAE
-
-static int disable_nx __initdata;
-
-/*
- * noexec = on|off
- *
- * Control non executable mappings.
- *
- * on      Enable
- * off     Disable
- */
-static int __init noexec_setup(char *str)
-{
-	if (!str || !strcmp(str, "on")) {
-		if (cpu_has_nx) {
-			__supported_pte_mask |= _PAGE_NX;
-			disable_nx = 0;
-		}
-	} else {
-		if (!strcmp(str, "off")) {
-			disable_nx = 1;
-			__supported_pte_mask &= ~_PAGE_NX;
-		} else {
-			return -EINVAL;
-		}
-	}
-
-	return 0;
-}
-early_param("noexec", noexec_setup);
-
-void __init set_nx(void)
-{
-	unsigned int v[4], l, h;
-
-	if (cpu_has_pae && (cpuid_eax(0x80000000) > 0x80000001)) {
-		cpuid(0x80000001, &v[0], &v[1], &v[2], &v[3]);
-
-		if ((v[3] & (1 << 20)) && !disable_nx) {
-			rdmsr(MSR_EFER, l, h);
-			l |= EFER_NX;
-			wrmsr(MSR_EFER, l, h);
-			nx_enabled = 1;
-			__supported_pte_mask |= _PAGE_NX;
-		}
-	}
-}
-#endif
-
 /* user-defined highmem size */
 static unsigned int highmem_pages = -1;
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 54efa57..3073d10 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -85,39 +85,6 @@ early_param("gbpages", parse_direct_gbpages_on);
 pteval_t __supported_pte_mask __read_mostly = ~_PAGE_IOMAP;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
-static int disable_nx __cpuinitdata;
-
-/*
- * noexec=on|off
- * Control non-executable mappings for 64-bit processes.
- *
- * on	Enable (default)
- * off	Disable
- */
-static int __init nonx_setup(char *str)
-{
-	if (!str)
-		return -EINVAL;
-	if (!strncmp(str, "on", 2)) {
-		__supported_pte_mask |= _PAGE_NX;
-		disable_nx = 0;
-	} else if (!strncmp(str, "off", 3)) {
-		disable_nx = 1;
-		__supported_pte_mask &= ~_PAGE_NX;
-	}
-	return 0;
-}
-early_param("noexec", nonx_setup);
-
-void __cpuinit check_efer(void)
-{
-	unsigned long efer;
-
-	rdmsrl(MSR_EFER, efer);
-	if (!(efer & EFER_NX) || disable_nx)
-		__supported_pte_mask &= ~_PAGE_NX;
-}
-
 int force_personality32;
 
 /*
