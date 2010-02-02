Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0BBIUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:20:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:14680 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab0BBIUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:20:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,389,1262592000"; 
   d="scan'208";a="769295339"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Cc: xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 6/6] xen/hybrid: Enable grant table and xenbus
Date: Tue,  2 Feb 2010 16:19:07 +0800
Message-Id: <1265098747-10117-7-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265098747-10117-1-git-send-email-sheng@linux.intel.com>
References: <1265098747-10117-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now vnif and vbd drivers can work.

Notice one memory region(0xfbfe0000ul - 0xfc000000ul) would be reserved in the
bios E820 table. This memory region would be used as grant table.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/xen/enlighten.c          |    1 +
 drivers/block/xen-blkfront.c      |    3 ++
 drivers/input/xen-kbdfront.c      |    4 ++
 drivers/net/xen-netfront.c        |    3 ++
 drivers/video/xen-fbfront.c       |    4 ++
 drivers/xen/grant-table.c         |   67 +++++++++++++++++++++++++++++++++++-
 drivers/xen/xenbus/xenbus_probe.c |   23 +++++++++++--
 include/xen/xen.h                 |    3 ++
 8 files changed, 103 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 369b250..5a2a73b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1278,6 +1278,7 @@ static int init_hybrid_info(void)
 	pv_info = xen_info;
 	pv_info.kernel_rpl = 0;
 
+	xen_domain_type = XEN_HYBRID_DOMAIN;
 	return 0;
 }
 
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 05a31e5..d7dfba9 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1071,6 +1071,9 @@ static int __init xlblk_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
+	if (xen_hybrid_domain() && !xen_hybrid_evtchn_enabled())
+		return -ENODEV;
+
 	if (register_blkdev(XENVBD_MAJOR, DEV_NAME)) {
 		printk(KERN_WARNING "xen_blk: can't get major %d with name %s\n",
 		       XENVBD_MAJOR, DEV_NAME);
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index c721c0a..74cbb25 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -341,6 +341,10 @@ static int __init xenkbd_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
+	/* Xen Hybrid domain don't need vkbd */
+	if (xen_hybrid_domain())
+		return -ENODEV;
+
 	/* Nothing to do if running in dom0. */
 	if (xen_initial_domain())
 		return -ENODEV;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index a869b45..568324a 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1807,6 +1807,9 @@ static int __init netif_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
+	if (xen_hybrid_domain() && !xen_hybrid_evtchn_enabled())
+		return -ENODEV;
+
 	if (xen_initial_domain())
 		return 0;
 
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 603598f..2ba569a 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -686,6 +686,10 @@ static int __init xenfb_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
+	/* Don't enable vfb in Xen hybrid domain */
+	if (xen_hybrid_domain())
+		return -ENODEV;
+
 	/* Nothing to do if running in dom0. */
 	if (xen_initial_domain())
 		return -ENODEV;
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 4c6c0bd..29f2155 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -46,6 +46,9 @@
 #include <asm/pgtable.h>
 #include <asm/sync_bitops.h>
 
+#include <xen/interface/memory.h>
+#include <linux/io.h>
+#include <asm/e820.h>
 
 /* External tools reserve first few grant table entries. */
 #define NR_RESERVED_ENTRIES 8
@@ -441,12 +444,33 @@ static inline unsigned int max_nr_grant_frames(void)
 	return xen_max;
 }
 
+static unsigned long hybrid_resume_frames;
+
 static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 {
 	struct gnttab_setup_table setup;
 	unsigned long *frames;
 	unsigned int nr_gframes = end_idx + 1;
 	int rc;
+	struct xen_add_to_physmap xatp;
+	unsigned int i = end_idx;
+
+	if (xen_hybrid_domain() && xen_hybrid_evtchn_enabled()) {
+		/*
+		 * Loop backwards, so that the first hypercall has the largest
+		 * index, ensuring that the table will grow only once.
+		 */
+		do {
+			xatp.domid = DOMID_SELF;
+			xatp.idx = i;
+			xatp.space = XENMAPSPACE_grant_table;
+			xatp.gpfn = (hybrid_resume_frames >> PAGE_SHIFT) + i;
+			if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
+				BUG();
+		} while (i-- > start_idx);
+
+		return 0;
+	}
 
 	frames = kmalloc(nr_gframes * sizeof(unsigned long), GFP_ATOMIC);
 	if (!frames)
@@ -473,11 +497,47 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 	return 0;
 }
 
+#define GNTTAB_START	    0xfbfe0000ul
+#define GNTTAB_SIZE	    0x20000ul
+
 int gnttab_resume(void)
 {
-	if (max_nr_grant_frames() < nr_grant_frames)
+	unsigned int max_nr_gframes;
+
+	max_nr_gframes = max_nr_grant_frames();
+	if (max_nr_gframes < nr_grant_frames)
 		return -ENOSYS;
-	return gnttab_map(0, nr_grant_frames - 1);
+
+	if (!(xen_hybrid_domain() && xen_hybrid_evtchn_enabled()))
+		return gnttab_map(0, nr_grant_frames - 1);
+
+	if (!hybrid_resume_frames) {
+		/* Check if e820 reserved the related region */
+		if (!e820_all_mapped(GNTTAB_START,
+					GNTTAB_START + GNTTAB_SIZE, 2)) {
+			printk(KERN_WARNING
+				"Fail to found grant table region in e820!\n");
+			return -ENODEV;
+		}
+		if (PAGE_SIZE * max_nr_gframes > GNTTAB_SIZE) {
+			printk(KERN_WARNING
+				"Grant table size exceed the limit!\n");
+			return -EINVAL;
+		}
+
+		hybrid_resume_frames = GNTTAB_START;
+		shared = ioremap(hybrid_resume_frames,
+				 PAGE_SIZE * max_nr_gframes);
+		if (shared == NULL) {
+			printk(KERN_WARNING
+				"Fail to ioremap gnttab share frames\n");
+			return -ENOMEM;
+		}
+	}
+
+	gnttab_map(0, nr_grant_frames - 1);
+
+	return 0;
 }
 
 int gnttab_suspend(void)
@@ -513,6 +573,9 @@ static int __devinit gnttab_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
+	if (xen_hybrid_domain() && !xen_hybrid_evtchn_enabled())
+		return -ENODEV;
+
 	nr_grant_frames = 1;
 	boot_max_nr_grant_frames = __max_nr_grant_frames();
 
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 2f7aaa9..83964b9 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -55,6 +55,8 @@
 #include <xen/events.h>
 #include <xen/page.h>
 
+#include <xen/hvm.h>
+
 #include "xenbus_comms.h"
 #include "xenbus_probe.h"
 
@@ -789,6 +791,9 @@ static int __init xenbus_probe_init(void)
 	if (!xen_domain())
 		goto out_error;
 
+	if (xen_hybrid_domain() && !xen_hybrid_evtchn_enabled())
+		goto out_error;
+
 	/* Register ourselves with the kernel bus subsystem */
 	err = bus_register(&xenbus_frontend.bus);
 	if (err)
@@ -805,10 +810,19 @@ static int __init xenbus_probe_init(void)
 		/* dom0 not yet supported */
 	} else {
 		xenstored_ready = 1;
-		xen_store_evtchn = xen_start_info->store_evtchn;
-		xen_store_mfn = xen_start_info->store_mfn;
+		if (xen_hybrid_domain()) {
+			xen_store_evtchn =
+				hvm_get_parameter(HVM_PARAM_STORE_EVTCHN);
+			xen_store_mfn =
+				hvm_get_parameter(HVM_PARAM_STORE_PFN);
+			xen_store_interface =
+				ioremap(xen_store_mfn << PAGE_SHIFT, PAGE_SIZE);
+		} else {
+			xen_store_evtchn = xen_start_info->store_evtchn;
+			xen_store_mfn = xen_start_info->store_mfn;
+			xen_store_interface = mfn_to_virt(xen_store_mfn);
+		}
 	}
-	xen_store_interface = mfn_to_virt(xen_store_mfn);
 
 	/* Initialize the interface to xenstore. */
 	err = xs_init();
@@ -925,6 +939,9 @@ static void wait_for_devices(struct xenbus_driver *xendrv)
 	if (!ready_to_wait_for_devices || !xen_domain())
 		return;
 
+	if (xen_hybrid_domain() && !xen_hybrid_evtchn_enabled())
+		return;
+
 	while (exists_connecting_device(drv)) {
 		if (time_after(jiffies, start + (seconds_waited+5)*HZ)) {
 			if (!seconds_waited)
diff --git a/include/xen/xen.h b/include/xen/xen.h
index aace9cc..632e76f 100644
--- a/include/xen/xen.h
+++ b/include/xen/xen.h
@@ -5,6 +5,7 @@ enum xen_domain_type {
 	XEN_NATIVE,		/* running on bare hardware    */
 	XEN_PV_DOMAIN,		/* running in a PV domain      */
 	XEN_HVM_DOMAIN,		/* running in a Xen hvm domain */
+	XEN_HYBRID_DOMAIN,	/* running in a Xen hybrid hvm domain */
 };
 
 #ifdef CONFIG_XEN
@@ -19,6 +20,8 @@ extern void xen_hybrid_init(void);
 				 xen_domain_type == XEN_PV_DOMAIN)
 #define xen_hvm_domain()	(xen_domain() &&			\
 				 xen_domain_type == XEN_HVM_DOMAIN)
+#define xen_hybrid_domain()	(xen_domain() &&			\
+				 xen_domain_type == XEN_HYBRID_DOMAIN)
 
 #define XEN_HYBRID_ENABLED	    (1u << 0)
 #define XEN_HYBRID_EVTCHN_ENABLED   (1u << 1)
-- 
1.5.4.5

