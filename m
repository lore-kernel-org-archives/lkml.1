Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbZGKHoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbZGKHoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 03:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZGKHoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 03:44:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56724 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbZGKHoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 03:44:14 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090711944.448667020@firstfloor.org>
In-Reply-To: <20090711944.448667020@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/3] x86: mce: Move most mce subsystem internal declarations into mce-internal.h
Message-Id: <20090711074409.915701D0261@basil.firstfloor.org>
Date: Sat, 11 Jul 2009 09:44:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move MCE subsystem internal prototypes and externs into mce-internal.h
This way they don't pollute the global include name space (but
are still global on the linker level).

I didn't move all, especially not prototypes that are logically 
not internal (like thermal setup)

No code behaviour changes.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/mce.h                |   48 +++++-------------------------
 arch/x86/kernel/cpu/mcheck/mce-inject.c   |    2 +
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   42 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce_amd.c      |    2 +
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |    1 
 5 files changed, 56 insertions(+), 39 deletions(-)

Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h
+++ linux/arch/x86/include/asm/mce.h
@@ -106,9 +106,6 @@ struct mce_log {
 #include <linux/init.h>
 #include <asm/atomic.h>
 
-extern int mce_disabled;
-extern int mce_p5_enabled;
-
 #ifdef CONFIG_X86_MCE
 void mcheck_init(struct cpuinfo_x86 *c);
 #else
@@ -127,7 +124,6 @@ static inline void enable_p5_mce(void) {
 
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
-DECLARE_PER_CPU(struct sys_device, mce_dev);
 
 /*
  * Maximum banks number.
@@ -136,28 +132,6 @@ DECLARE_PER_CPU(struct sys_device, mce_d
  */
 #define MAX_NR_BANKS 32
 
-#ifdef CONFIG_X86_MCE_INTEL
-extern int mce_cmci_disabled;
-extern int mce_ignore_ce;
-void mce_intel_feature_init(struct cpuinfo_x86 *c);
-void cmci_clear(void);
-void cmci_reenable(void);
-void cmci_rediscover(int dying);
-void cmci_recheck(void);
-#else
-static inline void mce_intel_feature_init(struct cpuinfo_x86 *c) { }
-static inline void cmci_clear(void) {}
-static inline void cmci_reenable(void) {}
-static inline void cmci_rediscover(int dying) {}
-static inline void cmci_recheck(void) {}
-#endif
-
-#ifdef CONFIG_X86_MCE_AMD
-void mce_amd_feature_init(struct cpuinfo_x86 *c);
-#else
-static inline void mce_amd_feature_init(struct cpuinfo_x86 *c) { }
-#endif
-
 int mce_available(struct cpuinfo_x86 *c);
 
 DECLARE_PER_CPU(unsigned, mce_exception_count);
@@ -165,22 +139,9 @@ DECLARE_PER_CPU(unsigned, mce_poll_count
 
 extern atomic_t mce_entry;
 
-typedef DECLARE_BITMAP(mce_banks_t, MAX_NR_BANKS);
-DECLARE_PER_CPU(mce_banks_t, mce_poll_banks);
-
-enum mcp_flags {
-	MCP_TIMESTAMP = (1 << 0),	/* log time stamp */
-	MCP_UC = (1 << 1),		/* log uncorrected errors */
-	MCP_DONTLOG = (1 << 2),		/* only clear, don't log */
-};
-void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
-
 int mce_notify_irq(void);
 void mce_notify_process(void);
 
-DECLARE_PER_CPU(struct mce, injectm);
-extern struct file_operations mce_chrdev_ops;
-
 /*
  * Exception handler
  */
@@ -204,5 +165,14 @@ void intel_init_thermal(struct cpuinfo_x
 
 void mce_log_therm_throt_event(__u64 status);
 
+/*
+ * Intel CMCI
+ */
+#ifdef CONFIG_X86_MCE_INTEL
+void cmci_recheck(void);
+#else
+static inline void cmci_recheck(void) {}
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_MCE_H */
Index: linux/arch/x86/kernel/cpu/mcheck/mce-inject.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -20,6 +20,8 @@
 #include <linux/smp.h>
 #include <asm/mce.h>
 
+#include "mce-internal.h"
+
 /* Update fake mce registers on current CPU. */
 static void inject_mce(struct mce *m)
 {
Index: linux/arch/x86/kernel/cpu/mcheck/mce-internal.h
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ linux/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -1,4 +1,5 @@
 #include <linux/sysdev.h>
+#include <linux/percpu.h>
 #include <asm/mce.h>
 
 enum severity_level {
@@ -24,6 +25,47 @@ struct mce_bank {
 int mce_severity(struct mce *a, int tolerant, char **msg);
 
 extern int mce_ser;
+extern int mce_ignore_ce;
 
 extern struct mce_bank *mce_banks;
 
+extern int mce_disabled;
+extern int mce_p5_enabled;
+
+DECLARE_PER_CPU(struct sys_device, mce_dev);
+
+/*
+ * MCE corrected error support
+ */
+
+typedef DECLARE_BITMAP(mce_banks_t, MAX_NR_BANKS);
+DECLARE_PER_CPU(mce_banks_t, mce_poll_banks);
+
+enum mcp_flags {
+	MCP_TIMESTAMP = (1 << 0),	/* log time stamp */
+	MCP_UC = (1 << 1),		/* log uncorrected errors */
+	MCP_DONTLOG = (1 << 2),		/* only clear, don't log */
+};
+void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
+
+#ifdef CONFIG_X86_MCE_INTEL
+extern int mce_cmci_disabled;
+void mce_intel_feature_init(struct cpuinfo_x86 *c);
+void cmci_clear(void);
+void cmci_reenable(void);
+void cmci_rediscover(int dying);
+#else
+static inline void mce_intel_feature_init(struct cpuinfo_x86 *c) { }
+static inline void cmci_clear(void) {}
+static inline void cmci_reenable(void) {}
+static inline void cmci_rediscover(int dying) {}
+#endif
+
+#ifdef CONFIG_X86_MCE_AMD
+void mce_amd_feature_init(struct cpuinfo_x86 *c);
+#else
+static inline void mce_amd_feature_init(struct cpuinfo_x86 *c) { }
+#endif
+
+DECLARE_PER_CPU(struct mce, injectm);
+extern struct file_operations mce_chrdev_ops;
Index: linux/arch/x86/kernel/cpu/mcheck/mce_amd.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -30,6 +30,8 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 
+#include "mce-internal.h"
+
 #define PFX               "mce_threshold: "
 #define VERSION           "version 1.1.1"
 #define NR_BANKS          6
Index: linux/arch/x86/kernel/cpu/mcheck/mce_intel.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -12,6 +12,7 @@
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include <asm/mce.h>
+#include "mce-internal.h"
 
 /*
  * Support for Intel Correct Machine Check Interrupts. This allows
