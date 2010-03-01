Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab0CAJhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:37:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:39235 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab0CAJhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:37:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,559,1262592000"; 
   d="scan'208";a="544840237"
From: Sheng Yang <sheng@linux.intel.com>
To: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 7/7] xen: Enable grant table and xenbus for PV extension of HVM
Date: Mon,  1 Mar 2010 17:38:35 +0800
Message-Id: <1267436315-24486-8-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now pv drivers(vnif, vbd) can work.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/xen/enlighten.c          |    1 +
 drivers/input/xen-kbdfront.c      |    3 ++
 drivers/video/xen-fbfront.c       |    3 ++
 drivers/xen/grant-table.c         |   59 +++++++++++++++++++++++++++++++++++--
 drivers/xen/xenbus/xenbus_probe.c |   22 ++++++++++---
 include/xen/xen.h                 |    2 +
 include/xen/xenbus.h              |    2 +-
 7 files changed, 83 insertions(+), 9 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index f617639..3bc9ff0 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1277,6 +1277,7 @@ static int init_hvm_pv_info(void)
 	pv_info = xen_info;
 	pv_info.kernel_rpl = 0;
 
+	xen_domain_type = XEN_HVM_DOMAIN;
 	return 0;
 }
 
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index febffc3..8e58812 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -342,6 +342,9 @@ static int __init xenkbd_init(void)
 	if (xen_initial_domain())
 		return -ENODEV;
 
+	if (xen_hvm_domain())
+		return -ENODEV;
+
 	return xenbus_register_frontend(&xenkbd_driver);
 }
 
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index daff72f..b173474 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -687,6 +687,9 @@ static int __init xenfb_init(void)
 	if (xen_initial_domain())
 		return -ENODEV;
 
+	if (xen_hvm_domain())
+		return -ENODEV;
+
 	return xenbus_register_frontend(&xenfb_driver);
 }
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 4c6c0bd..abffda5 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -46,6 +46,8 @@
 #include <asm/pgtable.h>
 #include <asm/sync_bitops.h>
 
+#include <xen/interface/memory.h>
+#include <linux/io.h>
 
 /* External tools reserve first few grant table entries. */
 #define NR_RESERVED_ENTRIES 8
@@ -441,12 +443,33 @@ static inline unsigned int max_nr_grant_frames(void)
 	return xen_max;
 }
 
+static unsigned long hvm_pv_resume_frames;
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
+	if (xen_hvm_pv_evtchn_enabled()) {
+		/*
+		 * Loop backwards, so that the first hypercall has the largest
+		 * index, ensuring that the table will grow only once.
+		 */
+		do {
+			xatp.domid = DOMID_SELF;
+			xatp.idx = i;
+			xatp.space = XENMAPSPACE_grant_table;
+			xatp.gpfn = (hvm_pv_resume_frames >> PAGE_SHIFT) + i;
+			if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
+				BUG();
+		} while (i-- > start_idx);
+
+		return 0;
+	}
 
 	frames = kmalloc(nr_gframes * sizeof(unsigned long), GFP_ATOMIC);
 	if (!frames)
@@ -473,11 +496,41 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 	return 0;
 }
 
+/* The region reserved by QEmu for Xen platform device */
+#define GNTTAB_START	    0xf2000000ul
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
+	if (xen_pv_domain())
+		return gnttab_map(0, nr_grant_frames - 1);
+
+	/* Xen PV featured HVM */
+	if (!hvm_pv_resume_frames) {
+		if (PAGE_SIZE * max_nr_gframes > GNTTAB_SIZE) {
+			printk(KERN_WARNING
+				"Grant table size exceed the limit!\n");
+			return -EINVAL;
+		}
+		hvm_pv_resume_frames = GNTTAB_START;
+		shared = ioremap(hvm_pv_resume_frames,
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
@@ -510,7 +563,7 @@ static int __devinit gnttab_init(void)
 	unsigned int max_nr_glist_frames, nr_glist_frames;
 	unsigned int nr_init_grefs;
 
-	if (!xen_domain())
+	if (!xen_evtchn_enabled())
 		return -ENODEV;
 
 	nr_grant_frames = 1;
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 2f7aaa9..2704f0c 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -55,6 +55,8 @@
 #include <xen/events.h>
 #include <xen/page.h>
 
+#include <xen/hvm.h>
+
 #include "xenbus_comms.h"
 #include "xenbus_probe.h"
 
@@ -786,7 +788,8 @@ static int __init xenbus_probe_init(void)
 	DPRINTK("");
 
 	err = -ENODEV;
-	if (!xen_domain())
+
+	if (!xen_evtchn_enabled())
 		goto out_error;
 
 	/* Register ourselves with the kernel bus subsystem */
@@ -805,10 +808,19 @@ static int __init xenbus_probe_init(void)
 		/* dom0 not yet supported */
 	} else {
 		xenstored_ready = 1;
-		xen_store_evtchn = xen_start_info->store_evtchn;
-		xen_store_mfn = xen_start_info->store_mfn;
+		if (xen_hvm_pv_evtchn_enabled()) {
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
@@ -922,7 +934,7 @@ static void wait_for_devices(struct xenbus_driver *xendrv)
 	struct device_driver *drv = xendrv ? &xendrv->driver : NULL;
 	unsigned int seconds_waited = 0;
 
-	if (!ready_to_wait_for_devices || !xen_domain())
+	if (!ready_to_wait_for_devices || !xen_evtchn_enabled())
 		return;
 
 	while (exists_connecting_device(drv)) {
diff --git a/include/xen/xen.h b/include/xen/xen.h
index 9bb92e5..f949aee 100644
--- a/include/xen/xen.h
+++ b/include/xen/xen.h
@@ -28,6 +28,8 @@ extern u32 xen_hvm_pv_status;
 #define xen_hvm_pv_evtchn_enabled() (xen_hvm_pv_enabled() && \
 		(xen_hvm_pv_status & XEN_HVM_PV_EVTCHN_ENABLED))
 
+#define xen_evtchn_enabled() (xen_pv_domain() || xen_hvm_pv_evtchn_enabled())
+
 #ifdef CONFIG_XEN_DOM0
 #include <xen/interface/xen.h>
 #include <asm/xen/hypervisor.h>
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index 9f68cf5..0e79644 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -113,7 +113,7 @@ static inline int __must_check
 xenbus_register_frontend(struct xenbus_driver *drv)
 {
 	WARN_ON(drv->owner != THIS_MODULE);
-	if (!xen_domain())
+	if (!xen_evtchn_enabled())
 		return -ENODEV;
 	return __xenbus_register_frontend(drv, THIS_MODULE, KBUILD_MODNAME);
 }
-- 
1.5.4.5

