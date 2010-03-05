Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0CEGIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 01:08:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:55701 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab0CEGGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 01:06:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,585,1262592000"; 
   d="scan'208";a="778157727"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ingo Molnar <mingo@elte.hu>
Cc: Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 6/7] xen: Enable PV clocksource for HVM
Date: Fri,  5 Mar 2010 14:07:56 +0800
Message-Id: <1267769277-20522-7-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267769277-20522-1-git-send-email-sheng@linux.intel.com>
References: <1267769277-20522-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And enable it by default in PV extended HVM guest.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/xen/hvmpv.c   |   18 ++++++++++++++++++
 arch/x86/xen/time.c    |   12 +++++++++++-
 arch/x86/xen/xen-ops.h |    1 +
 3 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/hvmpv.c b/arch/x86/xen/hvmpv.c
index 540eef4..305dcca 100644
--- a/arch/x86/xen/hvmpv.c
+++ b/arch/x86/xen/hvmpv.c
@@ -43,6 +43,7 @@ static void __init xen_hvm_pv_banner(void)
 		pv_info.name);
 	printk(KERN_INFO "Xen version: %d.%d%s\n",
 		version >> 16, version & 0xffff, extra.extraversion);
+	printk(KERN_INFO "PV feature: PV clocksource enabled\n");
 }
 
 static int __init xen_para_available(void)
@@ -112,6 +113,20 @@ static int __init init_shared_info(void)
 	return 0;
 }
 
+static void __init init_pv_clocksource(void)
+{
+	if (enable_hvm_pv(HVM_PV_CLOCK))
+		BUG();
+
+	pv_time_ops.sched_clock = xen_sched_clock;
+
+	x86_platform.calibrate_tsc = xen_tsc_khz;
+	x86_platform.get_wallclock = xen_get_wallclock;
+	x86_platform.set_wallclock = xen_set_wallclock;
+
+	xen_register_clocksource();
+}
+
 void __init xen_guest_init(void)
 {
 	int r;
@@ -133,5 +148,8 @@ void __init xen_guest_init(void)
 	x86_init.oem.banner = xen_hvm_pv_banner;
 	pv_info = xen_hvm_pv_info;
 
+	/* PV clocksource would be enabled by default */
+	init_pv_clocksource();
+
 	xen_domain_type = XEN_HVM_DOMAIN;
 }
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 0d3f07c..06b3e72 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -472,11 +472,21 @@ void xen_timer_resume(void)
 	}
 }
 
+static bool xen_clocksource_enabled;
+
+void xen_register_clocksource(void)
+{
+	if (!xen_clocksource_enabled) {
+		clocksource_register(&xen_clocksource);
+		xen_clocksource_enabled = 1;
+	}
+}
+
 __init void xen_time_init(void)
 {
 	int cpu = smp_processor_id();
 
-	clocksource_register(&xen_clocksource);
+	xen_register_clocksource();
 
 	if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL) == 0) {
 		/* Successfully turned off 100Hz tick, so we have the
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index f9153a3..d56b660 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -48,6 +48,7 @@ cycle_t xen_clocksource_read(void);
 void xen_setup_cpu_clockevents(void);
 unsigned long xen_tsc_khz(void);
 void __init xen_time_init(void);
+void xen_register_clocksource(void);
 unsigned long xen_get_wallclock(void);
 int xen_set_wallclock(unsigned long time);
 unsigned long long xen_sched_clock(void);
-- 
1.5.4.5

