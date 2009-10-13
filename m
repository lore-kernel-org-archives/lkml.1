Return-Path: <linux-kernel-owner+w=401wt.eu-S1760380AbZJMPnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760380AbZJMPnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760341AbZJMPnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:43:41 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:25712
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760370AbZJMPnj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:43:39 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz655Nzz1202hzzz32i2a8I6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KRGMBB-03-4EI-02
X-M-MSG: 
Date: Tue, 13 Oct 2009 17:43:34 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 1/2] x86, mce: fixup mce naming nomenclature
Message-ID: <20091013154334.GA14900@aftab>
References: <20091012103333.GB20051@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20091012103333.GB20051@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 13 Oct 2009 15:42:46.0594 (UTC) FILETIME=[CFB34220:01CA4C1B]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9459278f4cb5b108a4b648d4f079057be203ffee Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Tue, 13 Oct 2009 15:40:17 +0200
Subject: [PATCH 1/2] x86, mce: fixup mce naming nomenclature

Prefix global/setup routines called from outside with "mcheck_" thus
differentiating from the internal/facilities-related "mce_" prefixed
counterparts. Also, prefix the per-cpu calls with mcheck_cpu along with
changing their names to reflect the setup hierarchy of calls better.

There should be no functionality change resulting from this patch.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
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
index 15ba9c9..b4a5eca 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1130,7 +1130,7 @@ static int check_interval = 5 * 60; /* 5 minutes */
 static DEFINE_PER_CPU(int, mce_next_interval); /* in jiffies */
 static DEFINE_PER_CPU(struct timer_list, mce_timer);
 
-static void mcheck_timer(unsigned long data)
+static void mce_start_timer(unsigned long data)
 {
 	struct timer_list *t = &per_cpu(mce_timer, data);
 	int *n;
@@ -1214,7 +1214,7 @@ static int mce_banks_init(void)
 /*
  * Initialize Machine Checks for a CPU.
  */
-static int __cpuinit mce_cap_init(void)
+static int __cpuinit __mcheck_cpu_cap_init(void)
 {
 	unsigned b;
 	u64 cap;
@@ -1251,7 +1251,7 @@ static int __cpuinit mce_cap_init(void)
 	return 0;
 }
 
-static void mce_init(void)
+static void __mcheck_cpu_init_generic(void)
 {
 	mce_banks_t all_banks;
 	u64 cap;
@@ -1280,7 +1280,7 @@ static void mce_init(void)
 }
 
 /* Add per CPU specific workarounds here */
-static int __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
+static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 {
 	if (c->x86_vendor == X86_VENDOR_UNKNOWN) {
 		pr_info("MCE: unknown CPU type - not enabling MCE support.\n");
@@ -1348,7 +1348,7 @@ static int __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
 	return 0;
 }
 
-static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
+static void __cpuinit __mcheck_cpu_ancient_init(struct cpuinfo_x86 *c)
 {
 	if (c->x86 != 5)
 		return;
@@ -1362,7 +1362,7 @@ static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
 	}
 }
 
-static void mce_cpu_features(struct cpuinfo_x86 *c)
+static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
 {
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
@@ -1376,7 +1376,7 @@ static void mce_cpu_features(struct cpuinfo_x86 *c)
 	}
 }
 
-static void mce_init_timer(void)
+static void __mcheck_cpu_init_timer(void)
 {
 	struct timer_list *t = &__get_cpu_var(mce_timer);
 	int *n = &__get_cpu_var(mce_next_interval);
@@ -1387,7 +1387,7 @@ static void mce_init_timer(void)
 	*n = check_interval * HZ;
 	if (!*n)
 		return;
-	setup_timer(t, mcheck_timer, smp_processor_id());
+	setup_timer(t, mce_start_timer, smp_processor_id());
 	t->expires = round_jiffies(jiffies + *n);
 	add_timer_on(t, smp_processor_id());
 }
@@ -1407,26 +1407,26 @@ void (*machine_check_vector)(struct pt_regs *, long error_code) =
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
@@ -1658,7 +1658,7 @@ __setup("mce", mcheck_enable);
  * Disable machine checks on suspend and shutdown. We can't really handle
  * them later.
  */
-static int mce_disable(void)
+static int mce_disable_error_reporting(void)
 {
 	int i;
 
@@ -1673,12 +1673,12 @@ static int mce_disable(void)
 
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
@@ -1688,8 +1688,8 @@ static int mce_shutdown(struct sys_device *dev)
  */
 static int mce_resume(struct sys_device *dev)
 {
-	mce_init();
-	mce_cpu_features(&current_cpu_data);
+	__mcheck_cpu_init_generic();
+	__mcheck_cpu_init_vendor(&current_cpu_data);
 
 	return 0;
 }
@@ -1699,8 +1699,8 @@ static void mce_cpu_restart(void *data)
 	del_timer_sync(&__get_cpu_var(mce_timer));
 	if (!mce_available(&current_cpu_data))
 		return;
-	mce_init();
-	mce_init_timer();
+	__mcheck_cpu_init_generic();
+	__mcheck_cpu_init_timer();
 }
 
 /* Reinit MCEs after user configuration changes */
@@ -1726,7 +1726,7 @@ static void mce_enable_ce(void *all)
 	cmci_reenable();
 	cmci_recheck();
 	if (all)
-		mce_init_timer();
+		__mcheck_cpu_init_timer();
 }
 
 static struct sysdev_class mce_sysclass = {
@@ -2035,7 +2035,7 @@ static __init void mce_init_banks(void)
 	}
 }
 
-static __init int mce_init_device(void)
+static __init int mcheck_init_device(void)
 {
 	int err;
 	int i = 0;
@@ -2063,7 +2063,7 @@ static __init int mce_init_device(void)
 	return err;
 }
 
-device_initcall(mce_init_device);
+device_initcall(mcheck_init_device);
 
 /*
  * Old style boot options parsing. Only for compatibility.
@@ -2111,7 +2111,7 @@ static int fake_panic_set(void *data, u64 val)
 DEFINE_SIMPLE_ATTRIBUTE(fake_panic_fops, fake_panic_get,
 			fake_panic_set, "%llu\n");
 
-static int __init mce_debugfs_init(void)
+static int __init mcheck_debugfs_init(void)
 {
 	struct dentry *dmce, *ffake_panic;
 
@@ -2125,5 +2125,5 @@ static int __init mce_debugfs_init(void)
 
 	return 0;
 }
-late_initcall(mce_debugfs_init);
+late_initcall(mcheck_debugfs_init);
 #endif
-- 
1.6.4.3

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

