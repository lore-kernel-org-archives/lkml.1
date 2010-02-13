Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab0BMBl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:41:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:47168 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab0BMBlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:41:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,464,1262592000"; 
   d="scan'208,223";a="492151529"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Du, Alek" <alek.du@intel.com>, "Tang, Feng" <feng.tang@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Feb 2010 17:41:03 -0800
Subject: [PATCH 8/8] x86/mrst: platform clock setup code
Thread-Topic: [PATCH 8/8] x86/mrst: platform clock setup code
Thread-Index: AcqsTZphCOzYuyvaSseLx9DjAYCfAQ==
Message-ID: <43F901BD926A4E43B106BF17856F07559FB80D0F@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7010894891c0838b150fee70235bd4bef9066fda Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Fri, 12 Feb 2010 05:01:12 -0800
Subject: [PATCH 8/8] x86/mrst: platform clock setup code

add moorestwon platform clock setup code to the x86_init abstraction

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/kernel/mrst.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index b7fa049..0f1fa6f 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -23,6 +23,7 @@
 #include <asm/mrst.h>
 #include <asm/io.h>
 #include <asm/i8259.h>
+#include <asm/apb_timer.h>
 
 static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
 static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
@@ -166,12 +167,56 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 	return 0;
 }
 
+/*
+ * the secondary clock in Moorestown can be APBT or LAPIC clock, default to
+ * APBT but cmdline option can also override it.
+ */
+static void __cpuinit mrst_setup_secondary_clock(void)
+{
+	/* restore default lapic clock if disabled by cmdline */
+	if (disable_apbt_percpu)
+		return setup_secondary_APIC_clock();
+	apbt_setup_secondary_clock();
+}
+
+static unsigned long __init mrst_calibrate_tsc(void)
+{
+	unsigned long flags, fast_calibrate;
+
+	local_irq_save(flags);
+	fast_calibrate = apbt_quick_calibrate();
+	local_irq_restore(flags);
+
+	if (fast_calibrate)
+		return fast_calibrate;
+
+	return 0;
+}
+
+void __init mrst_time_init(void)
+{
+	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
+	pre_init_apic_IRQ0();
+	apbt_time_init();
+}
+
 void __init mrst_rtc_init(void)
 {
 	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
 }
 
 /*
+ * if we use per cpu apb timer, the bootclock already setup. if we use lapic
+ * timer and one apbt timer for broadcast, we need to set up lapic boot clock.
+ */
+static void mrst_setup_boot_clock(void)
+{
+	pr_info("%s: per cpu apbt flag %d \n", __func__, disable_apbt_percpu);
+	if (disable_apbt_percpu)
+		setup_boot_APIC_clock();
+};
+
+/*
  * Moorestown specific x86_init function overrides and early setup
  * calls.
  */
@@ -180,6 +225,14 @@ void __init x86_mrst_early_setup(void)
 	x86_init.resources.probe_roms = x86_init_noop;
 	x86_init.resources.reserve_resources = x86_init_noop;
 
+	x86_init.timers.timer_init = mrst_time_init;
+	x86_init.timers.setup_percpu_clockev = mrst_setup_boot_clock;
+
+	x86_init.irqs.pre_vector_init = x86_init_noop;
+
+	x86_cpuinit.setup_percpu_clockev = mrst_setup_secondary_clock;
+
+	x86_platform.calibrate_tsc = mrst_calibrate_tsc;
 	x86_init.pci.init = pci_mrst_init;
 	x86_init.pci.fixup_irqs = x86_init_noop;
 
-- 
1.6.5.3

