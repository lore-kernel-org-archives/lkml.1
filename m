Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbZIPIod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbZIPIod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757787AbZIPIoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:44:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:5499 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757950AbZIPIm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:42:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,396,1249282800"; 
   d="scan'208";a="493936863"
From: Sheng Yang <sheng@linux.intel.com>
To: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jun Nakajima <jun.nakajima@intel.com>, Eddie Dong <eddie.dong@intel.com>,
       linux-kernel@vger.kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: [RFC][PATCH 10/10] xen/hybrid: Enable grant table and xenbus
Date: Wed, 16 Sep 2009 16:42:31 +0800
Message-Id: <1253090551-7969-11-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now vnif and vbd drivers can work.

Notice one memory region(0xfbfe0000ul - 0xfc000000ul) would be reserved in the
bios E820 table. This memory region would be used as grant table.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/include/asm/xen/hypervisor.h |    3 +
 arch/x86/xen/enlighten.c              |    1 +
 drivers/block/xen-blkfront.c          |    3 +
 drivers/input/xen-kbdfront.c          |    4 ++
 drivers/net/xen-netfront.c            |    3 +
 drivers/video/xen-fbfront.c           |    4 ++
 drivers/xen/grant-table.c             |   67 ++++++++++++++++++++++++++++++++-
 drivers/xen/xenbus/xenbus_probe.c     |   23 ++++++++++-
 8 files changed, 103 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index 7eee836..267fa43 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -41,6 +41,7 @@ enum xen_domain_type {
 	XEN_NATIVE,		/* running on bare hardware    */
 	XEN_PV_DOMAIN,		/* running in a PV domain      */
 	XEN_HVM_DOMAIN,		/* running in a Xen hvm domain */
+	XEN_HYBRID_DOMAIN,
 };
 
 #ifdef CONFIG_XEN
@@ -55,6 +56,8 @@ extern void xen_start_hybrid(void);
 				 xen_domain_type == XEN_PV_DOMAIN)
 #define xen_hvm_domain()	(xen_domain() &&			\
 				 xen_domain_type == XEN_HVM_DOMAIN)
+#define xen_hybrid_domain()	(xen_domain() &&			\
+				 xen_domain_type == XEN_HYBRID_DOMAIN)
 
 #define XEN_HYBRID_ENABLED	    (1u << 0)
 #define XEN_HYBRID_TIMER_ENABLED    (1u << 1)
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index f515584..6c4f0c1 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1129,6 +1129,7 @@ static int init_hybrid_info(void)
 	pv_info = xen_info;
 	pv_info.kernel_rpl = 0;
 
+	xen_domain_type = XEN_HYBRID_DOMAIN;
 	return 0;
 }
 
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index a6cbf7b..14188ed 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1072,6 +1072,9 @@ static int __init xlblk_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
+	if (xen_hybrid_domain() && !xen_hybrid_evtchn_enabled())
+		return -ENODEV;
+
 	if (register_blkdev(XENVBD_MAJOR, DEV_NAME)) {
 		printk(KERN_WARNING "xen_blk: can't get major %d with name %s\n",
 		       XENVBD_MAJOR, DEV_NAME);
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index 928d2ed..a82b6aa 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -338,6 +338,10 @@ static int __init xenkbd_init(void)
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
index f673253..3ad2c45 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1806,6 +1806,9 @@ static int __init netif_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
+	if (xen_hybrid_domain() && !xen_hybrid_evtchn_enabled())
+		return -ENODEV;
+
 	if (xen_initial_domain())
 		return 0;
 
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 2493f05..b423248 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -683,6 +683,10 @@ static int __init xenfb_init(void)
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
index 7d8f531..3e4ac4a 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -45,6 +45,9 @@
 #include <asm/pgtable.h>
 #include <asm/sync_bitops.h>
 
+#include <xen/interface/memory.h>
+#include <linux/io.h>
+#include <asm/e820.h>
 
 /* External tools reserve first few grant table entries. */
 #define NR_RESERVED_ENTRIES 8
@@ -440,12 +443,33 @@ static inline unsigned int max_nr_grant_frames(void)
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
@@ -472,11 +496,47 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
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
@@ -512,6 +572,9 @@ static int __devinit gnttab_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
+	if (xen_hybrid_domain() && !xen_hybrid_evtchn_enabled())
+		return -ENODEV;
+
 	nr_grant_frames = 1;
 	boot_max_nr_grant_frames = __max_nr_grant_frames();
 
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 773d1cf..4b87605 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -53,6 +53,8 @@
 #include <xen/events.h>
 #include <xen/page.h>
 
+#include <xen/hvm.h>
+
 #include "xenbus_comms.h"
 #include "xenbus_probe.h"
 
@@ -828,6 +830,9 @@ static int __init xenbus_probe_init(void)
 	if (!xen_domain())
 		goto out_error;
 
+	if (xen_hybrid_domain() && !xen_hybrid_evtchn_enabled())
+		goto out_error;
+
 	/* Register ourselves with the kernel bus subsystem */
 	err = bus_register(&xenbus_frontend.bus);
 	if (err)
@@ -844,10 +849,19 @@ static int __init xenbus_probe_init(void)
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
@@ -959,6 +973,9 @@ static void wait_for_devices(struct xenbus_driver *xendrv)
 	if (!ready_to_wait_for_devices || !xen_domain())
 		return;
 
+	if (xen_hybrid_domain() && !xen_hybrid_evtchn_enabled())
+		return;
+
 	while (exists_disconnected_device(drv)) {
 		if (time_after(jiffies, timeout))
 			break;
-- 
1.5.4.5

