Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbZDUJqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbZDUJqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbZDUJq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:46:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:35106 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844AbZDUJqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:46:24 -0400
Date: Tue, 21 Apr 2009 09:45:34 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240303167.771.69.camel@penberg-laptop>
References: <1240303167.771.69.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: unify noexec handling
Message-ID: <tip-89388913f2c88a2cd15d24abab571b17a2596127@git.kernel.org>
Git-Commit-ID: 89388913f2c88a2cd15d24abab571b17a2596127
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 09:45:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89388913f2c88a2cd15d24abab571b17a2596127
Gitweb:     http://git.kernel.org/tip/89388913f2c88a2cd15d24abab571b17a2596127
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Tue, 21 Apr 2009 11:39:27 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Apr 2009 10:48:08 +0200

x86: unify noexec handling

This patch unifies noexec handling on 32-bit and 64-bit.

[ Impact: cleanup ]

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
[ mingo@elte.hu: build fix ]
LKML-Reference: <1240303167.771.69.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/pgtable_types.h |    1 -
 arch/x86/mm/init.c                   |   67 ++++++++++++++++++++++++++++++++--
 arch/x86/mm/init_32.c                |   52 --------------------------
 arch/x86/mm/init_64.c                |   33 -----------------
 4 files changed, 63 insertions(+), 90 deletions(-)

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
index fd3da1d..fedde53 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -22,6 +22,69 @@ int direct_gbpages
 #endif
 ;
 
+int nx_enabled;
+
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+static int disable_nx __cpuinitdata;
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
@@ -158,12 +221,9 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	use_gbpages = direct_gbpages;
 #endif
 
-#ifdef CONFIG_X86_32
-#ifdef CONFIG_X86_PAE
 	set_nx();
 	if (nx_enabled)
 		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
-#endif
 
 	/* Enable PSE if available */
 	if (cpu_has_pse)
@@ -174,7 +234,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		set_in_cr4(X86_CR4_PGE);
 		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
-#endif
 
 	if (use_gbpages)
 		page_size_mask |= 1 << PG_LEVEL_1G;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 749559e..2b27120 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -587,61 +587,9 @@ void zap_low_mappings(void)
 	flush_tlb_all();
 }
 
-int nx_enabled;
-
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
index 1753e80..a4e7846 100644
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
