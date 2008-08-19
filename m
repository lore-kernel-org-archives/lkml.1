Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbYHSUQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbYHSUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbYHSUQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:16:20 -0400
Received: from gw.goop.org ([64.81.55.164]:40795 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279AbYHSUQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:16:18 -0400
Message-ID: <48AB2A11.4020307@goop.org>
Date: Tue, 19 Aug 2008 13:16:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH] xen: clean up domain mode predicates
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are four operating modes Xen code may find itself running in:
 - native
 - hvm domain
 - pv dom0
 - pv domU

Clean up predicates for testing for these states to make them more consistent.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c          |    9 +++++++--
 drivers/block/xen-blkfront.c      |    2 +-
 drivers/char/hvc_xen.c            |    6 +++---
 drivers/input/xen-kbdfront.c      |    4 ++--
 drivers/net/xen-netfront.c        |    6 +++---
 drivers/video/xen-fbfront.c       |    4 ++--
 drivers/xen/balloon.c             |    2 +-
 drivers/xen/grant-table.c         |    2 +-
 drivers/xen/xenbus/xenbus_probe.c |    8 ++++----
 include/asm-x86/xen/hypervisor.h  |   14 ++++++++++++--
 10 files changed, 36 insertions(+), 21 deletions(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -56,6 +56,9 @@
 
 DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
 DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
+
+enum xen_domain_type xen_domain_type = XEN_NATIVE;
+EXPORT_SYMBOL_GPL(xen_domain_type);
 
 /*
  * Identity map, in addition to plain kernel map.  This needs to be
@@ -1665,6 +1668,8 @@
 	if (!xen_start_info)
 		return;
 
+	xen_domain_type = XEN_PV_DOMAIN;
+
 	BUG_ON(memcmp(xen_start_info->magic, "xen-3", 5) != 0);
 
 	xen_setup_features();
@@ -1701,7 +1706,7 @@
 
 	/* Prevent unwanted bits from being set in PTEs. */
 	__supported_pte_mask &= ~_PAGE_GLOBAL;
-	if (!is_initial_xendomain())
+	if (!xen_initial_domain())
 		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
 
 	/* Don't do the full vcpu_info placement stuff until we have a
@@ -1736,7 +1741,7 @@
 	boot_params.hdr.ramdisk_size = xen_start_info->mod_len;
 	boot_params.hdr.cmd_line_ptr = __pa(xen_start_info->cmd_line);
 
-	if (!is_initial_xendomain()) {
+	if (!xen_initial_domain()) {
 		add_preferred_console("xenboot", 0, NULL);
 		add_preferred_console("tty", 0, NULL);
 		add_preferred_console("hvc", 0, NULL);
===================================================================
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1032,7 +1032,7 @@
 
 static int __init xlblk_init(void)
 {
-	if (!is_running_on_xen())
+	if (!xen_domain())
 		return -ENODEV;
 
 	if (register_blkdev(XENVBD_MAJOR, DEV_NAME)) {
===================================================================
--- a/drivers/char/hvc_xen.c
+++ b/drivers/char/hvc_xen.c
@@ -106,8 +106,8 @@
 {
 	struct hvc_struct *hp;
 
-	if (!is_running_on_xen() ||
-	    is_initial_xendomain() ||
+	if (!xen_pv_domain() ||
+	    xen_initial_domain() ||
 	    !xen_start_info->console.domU.evtchn)
 		return -ENODEV;
 
@@ -140,7 +140,7 @@
 
 static int xen_cons_init(void)
 {
-	if (!is_running_on_xen())
+	if (!xen_pv_domain())
 		return 0;
 
 	hvc_instantiate(HVC_COOKIE, 0, &hvc_ops);
===================================================================
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -335,11 +335,11 @@
 
 static int __init xenkbd_init(void)
 {
-	if (!is_running_on_xen())
+	if (!xen_domain())
 		return -ENODEV;
 
 	/* Nothing to do if running in dom0. */
-	if (is_initial_xendomain())
+	if (xen_initial_domain())
 		return -ENODEV;
 
 	return xenbus_register_frontend(&xenkbd);
===================================================================
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1794,10 +1794,10 @@
 
 static int __init netif_init(void)
 {
-	if (!is_running_on_xen())
+	if (!xen_domain())
 		return -ENODEV;
 
-	if (is_initial_xendomain())
+	if (xen_initial_domain())
 		return 0;
 
 	printk(KERN_INFO "Initialising Xen virtual ethernet driver.\n");
@@ -1809,7 +1809,7 @@
 
 static void __exit netif_exit(void)
 {
-	if (is_initial_xendomain())
+	if (xen_initial_domain())
 		return;
 
 	xenbus_unregister_driver(&netfront);
===================================================================
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -680,11 +680,11 @@
 
 static int __init xenfb_init(void)
 {
-	if (!is_running_on_xen())
+	if (!xen_domain())
 		return -ENODEV;
 
 	/* Nothing to do if running in dom0. */
-	if (is_initial_xendomain())
+	if (xen_initial_domain())
 		return -ENODEV;
 
 	return xenbus_register_frontend(&xenfb);
===================================================================
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -420,7 +420,7 @@
 	unsigned long pfn;
 	struct page *page;
 
-	if (!is_running_on_xen())
+	if (!xen_pv_domain())
 		return -ENODEV;
 
 	pr_info("xen_balloon: Initialising balloon driver.\n");
===================================================================
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -508,7 +508,7 @@
 	unsigned int max_nr_glist_frames, nr_glist_frames;
 	unsigned int nr_init_grefs;
 
-	if (!is_running_on_xen())
+	if (!xen_domain())
 		return -ENODEV;
 
 	nr_grant_frames = 1;
===================================================================
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -814,7 +814,7 @@
 	DPRINTK("");
 
 	err = -ENODEV;
-	if (!is_running_on_xen())
+	if (!xen_domain())
 		goto out_error;
 
 	/* Register ourselves with the kernel bus subsystem */
@@ -829,7 +829,7 @@
 	/*
 	 * Domain0 doesn't have a store_evtchn or store_mfn yet.
 	 */
-	if (is_initial_xendomain()) {
+	if (xen_initial_domain()) {
 		/* dom0 not yet supported */
 	} else {
 		xenstored_ready = 1;
@@ -846,7 +846,7 @@
 		goto out_unreg_back;
 	}
 
-	if (!is_initial_xendomain())
+	if (!xen_initial_domain())
 		xenbus_probe(NULL);
 
 	return 0;
@@ -937,7 +937,7 @@
 	unsigned long timeout = jiffies + 10*HZ;
 	struct device_driver *drv = xendrv ? &xendrv->driver : NULL;
 
-	if (!ready_to_wait_for_devices || !is_running_on_xen())
+	if (!ready_to_wait_for_devices || !xen_domain())
 		return;
 
 	while (exists_disconnected_device(drv)) {
===================================================================
--- a/include/asm-x86/xen/hypervisor.h
+++ b/include/asm-x86/xen/hypervisor.h
@@ -55,7 +55,6 @@
 /* arch/i386/kernel/setup.c */
 extern struct shared_info *HYPERVISOR_shared_info;
 extern struct start_info *xen_start_info;
-#define is_initial_xendomain() (xen_start_info->flags & SIF_INITDOMAIN)
 
 /* arch/i386/mach-xen/evtchn.c */
 /* Force a proper event-channel callback from Xen. */
@@ -68,6 +67,17 @@
 #define MULTI_UVMFLAGS_INDEX 3
 #define MULTI_UVMDOMID_INDEX 4
 
-#define is_running_on_xen()	(xen_start_info ? 1 : 0)
+enum xen_domain_type {
+	XEN_NATIVE,
+	XEN_PV_DOMAIN,
+	XEN_HVM_DOMAIN,
+};
+
+extern enum xen_domain_type xen_domain_type;
+
+#define xen_domain()		(xen_domain_type != XEN_NATIVE)
+#define xen_pv_domain()		(xen_domain_type == XEN_PV_DOMAIN)
+#define xen_initial_domain()	(xen_pv_domain() && xen_start_info->flags & SIF_INITDOMAIN)
+#define xen_hvm_domain()	(xen_domain_type == XEN_HVM_DOMAIN)
 
 #endif /* __HYPERVISOR_H__ */


