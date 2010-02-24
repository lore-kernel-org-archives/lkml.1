Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab0BXIJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:09:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:58705 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab0BXIJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:09:50 -0500
Date: Wed, 24 Feb 2010 08:09:23 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F0755A318D2D4@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F0755A318D2D4@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, mrst: Platform clock setup code
Message-ID: <tip-6f19f32a4a30fb40a1a8132f76205400c764196a@git.kernel.org>
Git-Commit-ID: 6f19f32a4a30fb40a1a8132f76205400c764196a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Feb 2010 08:09:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f19f32a4a30fb40a1a8132f76205400c764196a
Gitweb:     http://git.kernel.org/tip/6f19f32a4a30fb40a1a8132f76205400c764196a
Author:     Jacob Pan <jacob.jun.pan@intel.com>
AuthorDate: Fri, 12 Feb 2010 05:01:12 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 23 Feb 2010 23:15:20 -0800

x86, mrst: Platform clock setup code

Add Moorestown platform clock setup code to the x86_init abstraction.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
LKML-Reference: <43F901BD926A4E43B106BF17856F0755A318D2D4@orsmsx508.amr.corp.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/mrst.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index b7fa049..0aad867 100644
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
+static void __init mrst_setup_boot_clock(void)
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
 
