Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbZJEGpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbZJEGpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 02:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZJEGpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 02:45:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40413 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbZJEGpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 02:45:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC995EA.9030103@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 15:44:58 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/10] x86, mce: move mce_log_init() into mce_cap_init()
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com> <4AC990E1.7030708@jp.fujitsu.com>
In-Reply-To: <4AC990E1.7030708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mce_log_init() should be able to return -ENOMEM, to abort all following
initialization in mce.c.  It can be done in same style with mce_banks_init()
so I moved mce_log_init() into mce_cap_init() too.

And put __cpuinit to mce_banks_init().

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   48 +++++++++++++++++++++++--------------
 1 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 63a7820..fad3daa 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1194,19 +1194,40 @@ int mce_notify_irq(void)
 }
 EXPORT_SYMBOL_GPL(mce_notify_irq);
 
-static int mce_banks_init(void)
+static __cpuinit int mce_banks_init(void)
 {
 	int i;
 
 	mce_banks = kzalloc(banks * sizeof(struct mce_bank), GFP_KERNEL);
 	if (!mce_banks)
 		return -ENOMEM;
+
 	for (i = 0; i < banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
 
 		b->ctl = -1ULL;
 		b->init = 1;
 	}
+
+	return 0;
+}
+
+/*
+ * Initialize MCE per-CPU log buffer
+ */
+static __cpuinit int mce_log_init(void)
+{
+	int cpu;
+
+	mcelog.nr_mcelog_cpus = num_possible_cpus();
+	mcelog.mcelog_cpus = kzalloc(sizeof(void *) * num_possible_cpus(),
+				     GFP_KERNEL);
+	if (!mcelog.mcelog_cpus)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu)
+		mcelog.mcelog_cpus[cpu] = &per_cpu(mce_log_cpus, cpu);
+
 	return 0;
 }
 
@@ -1233,6 +1254,7 @@ static int __cpuinit mce_cap_init(void)
 	/* Don't support asymmetric configurations today */
 	WARN_ON(banks != 0 && b != banks);
 	banks = b;
+
 	if (!mce_banks) {
 		int err = mce_banks_init();
 
@@ -1240,6 +1262,13 @@ static int __cpuinit mce_cap_init(void)
 			return err;
 	}
 
+	if (!mcelog.mcelog_cpus) {
+		int err = mce_log_init();
+
+		if (err)
+			return err;
+	}
+
 	/* Use accurate RIP reporting if available. */
 	if ((cap & MCG_EXT_P) && MCG_EXT_CNT(cap) >= 9)
 		rip_msr = MSR_IA32_MCG_EIP;
@@ -1250,22 +1279,6 @@ static int __cpuinit mce_cap_init(void)
 	return 0;
 }
 
-/*
- * Initialize MCE per-CPU log buffer
- */
-static __cpuinit void mce_log_init(void)
-{
-	int cpu;
-
-	if (mcelog.mcelog_cpus)
-		return;
-	mcelog.nr_mcelog_cpus = num_possible_cpus();
-	mcelog.mcelog_cpus = kzalloc(sizeof(void *) * num_possible_cpus(),
-				     GFP_KERNEL);
-	for_each_possible_cpu(cpu)
-		mcelog.mcelog_cpus[cpu] = &per_cpu(mce_log_cpus, cpu);
-}
-
 static void mce_init(void)
 {
 	mce_banks_t all_banks;
@@ -1436,7 +1449,6 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 		mce_disabled = 1;
 		return;
 	}
-	mce_log_init();
 
 	machine_check_vector = do_machine_check;
 
-- 
1.6.4.3


