Return-Path: <linux-kernel-owner+w=401wt.eu-S1759167AbZJPM5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167AbZJPM5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 08:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbZJPM5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 08:57:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:50614 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563AbZJPM5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 08:57:02 -0400
Date: Fri, 16 Oct 2009 12:55:34 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, tglx@linutronix.de, mingo@elte.hu,
       borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, tglx@linutronix.de, borislav.petkov@amd.com,
       mingo@elte.hu
In-Reply-To: <1255689093-26921-1-git-send-email-borislav.petkov@amd.com>
References: <1255689093-26921-1-git-send-email-borislav.petkov@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/mce] x86, mce: Fix up MCE naming nomenclature
Message-ID: <tip-5e09954a9acc3b435ffe318b95afd3c02fae069f@git.kernel.org>
Git-Commit-ID: 5e09954a9acc3b435ffe318b95afd3c02fae069f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 16 Oct 2009 12:55:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e09954a9acc3b435ffe318b95afd3c02fae069f
Gitweb:     http://git.kernel.org/tip/5e09954a9acc3b435ffe318b95afd3c02fae069f
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 16 Oct 2009 12:31:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 16 Oct 2009 14:46:49 +0200

x86, mce: Fix up MCE naming nomenclature

Prefix global/setup routines with "mcheck_" thus differentiating
from the internal facilities prefixed with "mce_". Also, prefix
the per cpu calls with mcheck_cpu and rename them to reflect the
MCE setup hierarchy of calls better.

There should be no functionality change resulting from this
patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>
LKML-Reference: <1255689093-26921-1-git-send-email-borislav.petkov@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mce.h       |    4 +-
 arch/x86/kernel/cpu/common.c     |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c |   52 +++++++++++++++++++-------------------
 3 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 227a72d..161485d 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -120,9 +120,9 @@ extern int mce_disabled;
 extern int mce_p5_enabled;
 
 #ifdef CONFIG_X86_MCE
-void mcheck_init(struct cpuinfo_x86 *c);
+void mcheck_cpu_init(struct cpuinfo_x86 *c);
 #else
-static inline void mcheck_init(struct cpuinfo_x86 *c) {}
+static inline void mcheck_cpu_init(struct cpuinfo_x86 *c) {}
 #endif
 
 #ifdef CONFIG_X86_ANCIENT_MCE
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cc25c2b..4df69a3 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -839,7 +839,7 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 
 #ifdef CONFIG_X86_MCE
 	/* Init Machine Check Exception if available. */
-	mcheck_init(c);
+	mcheck_cpu_init(c);
 #endif
 
 	select_idle_routine(c);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 0fb9dc5..68d968e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1136,7 +1136,7 @@ static int check_interval = 5 * 60; /* 5 minutes */
 static DEFINE_PER_CPU(int, mce_next_interval); /* in jiffies */
 static DEFINE_PER_CPU(struct timer_list, mce_timer);
 
-static void mcheck_timer(unsigned long data)
+static void mce_start_timer(unsigned long data)
 {
 	struct timer_list *t = &per_cpu(mce_timer, data);
 	int *n;
@@ -1220,7 +1220,7 @@ static int mce_banks_init(void)
 /*
  * Initialize Machine Checks for a CPU.
  */
-static int __cpuinit mce_cap_init(void)
+static int __cpuinit __mcheck_cpu_cap_init(void)
 {
 	unsigned b;
 	u64 cap;
@@ -1258,7 +1258,7 @@ static int __cpuinit mce_cap_init(void)
 	return 0;
 }
 
-static void mce_init(void)
+static void __mcheck_cpu_init_generic(void)
 {
 	mce_banks_t all_banks;
 	u64 cap;
@@ -1287,7 +1287,7 @@ static void mce_init(void)
 }
 
 /* Add per CPU specific workarounds here */
-static int __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
+static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 {
 	if (c->x86_vendor == X86_VENDOR_UNKNOWN) {
 		pr_info("MCE: unknown CPU type - not enabling MCE support.\n");
@@ -1355,7 +1355,7 @@ static int __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
 	return 0;
 }
 
-static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
+static void __cpuinit __mcheck_cpu_ancient_init(struct cpuinfo_x86 *c)
 {
 	if (c->x86 != 5)
 		return;
@@ -1369,7 +1369,7 @@ static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
 	}
 }
 
-static void mce_cpu_features(struct cpuinfo_x86 *c)
+static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
 {
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
@@ -1383,7 +1383,7 @@ static void mce_cpu_features(struct cpuinfo_x86 *c)
 	}
 }
 
-static void mce_init_timer(void)
+static void __mcheck_cpu_init_timer(void)
 {
 	struct timer_list *t = &__get_cpu_var(mce_timer);
 	int *n = &__get_cpu_var(mce_next_interval);
@@ -1394,7 +1394,7 @@ static void mce_init_timer(void)
 	*n = check_interval * HZ;
 	if (!*n)
 		return;
-	setup_timer(t, mcheck_timer, smp_processor_id());
+	setup_timer(t, mce_start_timer, smp_processor_id());
 	t->expires = round_jiffies(jiffies + *n);
 	add_timer_on(t, smp_processor_id());
 }
@@ -1414,26 +1414,26 @@ void (*machine_check_vector)(struct pt_regs *, long error_code) =
  * Called for each booted CPU to set up machine checks.
  * Must be called with preempt off:
  */
-void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
+void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 {
 	if (mce_disabled)
 		return;
 
-	mce_ancient_init(c);
+	__mcheck_cpu_ancient_init(c);
 
 	if (!mce_available(c))
 		return;
 
-	if (mce_cap_init() < 0 || mce_cpu_quirks(c) < 0) {
+	if (__mcheck_cpu_cap_init() < 0 || __mcheck_cpu_apply_quirks(c) < 0) {
 		mce_disabled = 1;
 		return;
 	}
 
 	machine_check_vector = do_machine_check;
 
-	mce_init();
-	mce_cpu_features(c);
-	mce_init_timer();
+	__mcheck_cpu_init_generic();
+	__mcheck_cpu_init_vendor(c);
+	__mcheck_cpu_init_timer();
 	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
 
 	if (raw_smp_processor_id() == 0)
@@ -1665,7 +1665,7 @@ __setup("mce", mcheck_enable);
  * Disable machine checks on suspend and shutdown. We can't really handle
  * them later.
  */
-static int mce_disable(void)
+static int mce_disable_error_reporting(void)
 {
 	int i;
 
@@ -1680,12 +1680,12 @@ static int mce_disable(void)
 
 static int mce_suspend(struct sys_device *dev, pm_message_t state)
 {
-	return mce_disable();
+	return mce_disable_error_reporting();
 }
 
 static int mce_shutdown(struct sys_device *dev)
 {
-	return mce_disable();
+	return mce_disable_error_reporting();
 }
 
 /*
@@ -1695,8 +1695,8 @@ static int mce_shutdown(struct sys_device *dev)
  */
 static int mce_resume(struct sys_device *dev)
 {
-	mce_init();
-	mce_cpu_features(&current_cpu_data);
+	__mcheck_cpu_init_generic();
+	__mcheck_cpu_init_vendor(&current_cpu_data);
 
 	return 0;
 }
@@ -1706,8 +1706,8 @@ static void mce_cpu_restart(void *data)
 	del_timer_sync(&__get_cpu_var(mce_timer));
 	if (!mce_available(&current_cpu_data))
 		return;
-	mce_init();
-	mce_init_timer();
+	__mcheck_cpu_init_generic();
+	__mcheck_cpu_init_timer();
 }
 
 /* Reinit MCEs after user configuration changes */
@@ -1733,7 +1733,7 @@ static void mce_enable_ce(void *all)
 	cmci_reenable();
 	cmci_recheck();
 	if (all)
-		mce_init_timer();
+		__mcheck_cpu_init_timer();
 }
 
 static struct sysdev_class mce_sysclass = {
@@ -2042,7 +2042,7 @@ static __init void mce_init_banks(void)
 	}
 }
 
-static __init int mce_init_device(void)
+static __init int mcheck_init_device(void)
 {
 	int err;
 	int i = 0;
@@ -2070,7 +2070,7 @@ static __init int mce_init_device(void)
 	return err;
 }
 
-device_initcall(mce_init_device);
+device_initcall(mcheck_init_device);
 
 /*
  * Old style boot options parsing. Only for compatibility.
@@ -2118,7 +2118,7 @@ static int fake_panic_set(void *data, u64 val)
 DEFINE_SIMPLE_ATTRIBUTE(fake_panic_fops, fake_panic_get,
 			fake_panic_set, "%llu\n");
 
-static int __init mce_debugfs_init(void)
+static int __init mcheck_debugfs_init(void)
 {
 	struct dentry *dmce, *ffake_panic;
 
@@ -2132,5 +2132,5 @@ static int __init mce_debugfs_init(void)
 
 	return 0;
 }
-late_initcall(mce_debugfs_init);
+late_initcall(mcheck_debugfs_init);
 #endif
