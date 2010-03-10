Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab0CJPnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:43:01 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:27705 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab0CJPm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:42:58 -0500
X-IronPort-AV: E=Sophos;i="4.49,614,1262563200"; 
   d="scan'208";a="9880202"
Date: Wed, 10 Mar 2010 15:47:05 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3 of 5] pv clocksource
Message-ID: <alpine.DEB.2.00.1003101502120.28412@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this adds a PV clocksource that can provide a reliable clocksource for
Linux running as an HVM guest on Xen.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>

---

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 42135e8..6292cc6 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1253,6 +1253,20 @@ static void __init init_shared_info(void)
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
 }
 
+static void __init init_pv_clocksource(void)
+{
+	if (!xen_hvm_domain())
+		return;
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
@@ -1262,5 +1276,6 @@ void __init xen_guest_init(void)
 		return;
 
 	init_shared_info();
+	init_pv_clocksource();
 }
 
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 0a5aa44..d1c1c50 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -474,11 +474,21 @@ void xen_timer_resume(void)
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
index 355fa6b..2aeaf51 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -46,6 +46,7 @@ cycle_t xen_clocksource_read(void);
 void xen_setup_cpu_clockevents(void);
 unsigned long xen_tsc_khz(void);
 void __init xen_time_init(void);
+void xen_register_clocksource(void);
 unsigned long xen_get_wallclock(void);
 int xen_set_wallclock(unsigned long time);
 unsigned long long xen_sched_clock(void);
