Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbYEWNqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbYEWNqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbYEWNoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:44:24 -0400
Received: from gw.goop.org ([64.81.55.164]:53237 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbYEWNoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:44:20 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 11 of 12] xen: maintain clock offset over save/restore
X-Mercurial-Node: d67b372f709f658274b68a1c7affe5140a937358
Message-Id: <d67b372f709f658274b6.1211550078@localhost>
In-Reply-To: <patchbomb.1211550067@localhost>
Date: Fri, 23 May 2008 14:41:18 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hook into the device model to make sure that timekeeping's resume handler
is called.  This deals with our clocksource's non-monotonicity over the
save/restore.  Explicitly call clock_has_changed() to make sure that
all the timers get retriggered properly.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/time.c   |    8 --------
 drivers/xen/manage.c  |   15 ++++++++++++---
 include/xen/xen-ops.h |    3 ---
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -565,14 +565,6 @@
 	clockevents_register_device(&__get_cpu_var(xen_clock_events));
 }
 
-void xen_time_suspend(void)
-{
-}
-
-void xen_time_resume(void)
-{
-}
-
 __init void xen_time_init(void)
 {
 	int cpu = smp_processor_id();
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -34,14 +34,21 @@
 static int xen_suspend(void *data)
 {
 	int *cancelled = data;
+	int err;
 
 	BUG_ON(!irqs_disabled());
 
 	load_cr3(swapper_pg_dir);
 
+	err = device_power_down(PMSG_SUSPEND);
+	if (err) {
+		printk(KERN_ERR "xen_suspend: device_power_down failed: %d\n",
+		       err);
+		return err;
+	}
+
 	xen_mm_pin_all();
 	gnttab_suspend();
-	xen_time_suspend();
 	xen_pre_suspend();
 
 	/*
@@ -52,9 +59,10 @@
 	*cancelled = HYPERVISOR_suspend(virt_to_mfn(xen_start_info));
 
 	xen_post_suspend(*cancelled);
-	xen_time_resume();
 	gnttab_resume();
 	xen_mm_unpin_all();
+
+	device_power_up();
 
 	if (!*cancelled) {
 		xen_irq_resume();
@@ -105,7 +113,8 @@
 
 	device_resume();
 
-
+	/* Make sure timer events get retriggered on all CPUs */
+	clock_was_set();
 out:
 #ifdef CONFIG_PREEMPT
 	thaw_processes();
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -11,7 +11,4 @@
 void xen_mm_pin_all(void);
 void xen_mm_unpin_all(void);
 
-void xen_time_suspend(void);
-void xen_time_resume(void);
-
 #endif /* INCLUDE_XEN_OPS_H */


