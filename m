Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab0CDJhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:37:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:24271 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360Ab0CDJgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:36:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,580,1262592000"; 
   d="scan'208";a="497682291"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 6/7] xen: Enable PV clocksource for HVM
Date: Thu,  4 Mar 2010 17:36:55 +0800
Message-Id: <1267695416-14988-7-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267695416-14988-1-git-send-email-sheng@linux.intel.com>
References: <1267695416-14988-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And enable it by default in PV extended HVM guest.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/xen/hvmpv.c |   20 ++++++++++++++++++++
 arch/x86/xen/time.c  |    4 +++-
 2 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/hvmpv.c b/arch/x86/xen/hvmpv.c
index 7a741ed..284e021 100644
--- a/arch/x86/xen/hvmpv.c
+++ b/arch/x86/xen/hvmpv.c
@@ -43,6 +43,7 @@ static void __init xen_hvm_pv_banner(void)
 		pv_info.name);
 	printk(KERN_INFO "Xen version: %d.%d%s\n",
 		version >> 16, version & 0xffff, extra.extraversion);
+	printk(KERN_INFO "PV feature: PV clocksource enabled\n");
 }
 
 static int __init xen_para_available(void)
@@ -117,6 +118,22 @@ static void __init init_shared_info(void)
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
 }
 
+extern struct clocksource xen_clocksource;
+
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
+	clocksource_register(&xen_clocksource);
+}
+
 void __init xen_guest_init(void)
 {
 	int r;
@@ -130,4 +147,7 @@ void __init xen_guest_init(void)
 		return;
 
 	init_shared_info();
+
+	/* PV clocksource would be enabled by default */
+	init_pv_clocksource();
 }
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 0d3f07c..c80eacb 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -13,6 +13,7 @@
 #include <linux/clockchips.h>
 #include <linux/kernel_stat.h>
 #include <linux/math64.h>
+#include <linux/module.h>
 
 #include <asm/pvclock.h>
 #include <asm/xen/hypervisor.h>
@@ -243,7 +244,7 @@ int xen_set_wallclock(unsigned long now)
 	return -1;
 }
 
-static struct clocksource xen_clocksource __read_mostly = {
+struct clocksource xen_clocksource __read_mostly = {
 	.name = "xen",
 	.rating = 400,
 	.read = xen_clocksource_get_cycles,
@@ -252,6 +253,7 @@ static struct clocksource xen_clocksource __read_mostly = {
 	.shift = XEN_SHIFT,
 	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
 };
+EXPORT_SYMBOL_GPL(xen_clocksource);
 
 /*
    Xen clockevent implementation
-- 
1.5.4.5

