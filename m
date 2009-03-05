Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbZCER7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbZCER7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 12:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbZCER7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 12:59:37 -0500
Received: from mga14.intel.com ([143.182.124.37]:4965 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827AbZCER7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 12:59:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,308,1233561600"; 
   d="scan'208";a="117182487"
Subject: [git pull] dmaengine fixes for 2.6.29-rc
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 10:59:32 -0700
Message-Id: <1236275972.20418.10.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

...to receive:

Dan Williams (3):
      I/OAT: fail self-test if callback test reaches timeout
      fsldma: fix off by one in dma_halt
      dmatest: fix use after free in dmatest_exit

Eric Sesterhenn (1):
      I/OAT: list usage cleanup

Johannes Weiner (1):
      dmaengine: update kerneldoc

Luotao Fu (1):
      ipu_idmac: fix spinlock type

Maciej Sosnowski (6):
      I/OAT: add verification for proper APICID_TAG_MAP setting by BIOS
      I/OAT: do not set DCACTRL_CMPL_WRITE_ENABLE for I/OAT ver.3
      I/OAT: fail initialization on zero channels detection
      I/OAT: cancel watchdog before dma remove
      I/OAT: set tcp_dma_copybreak to 256k for I/OAT ver.3
      I/OAT: update driver version and copyright dates

Roel Kluin (1):
      iop-adma, mv_xor: fix mem leak on self-test setup failure

 drivers/dca/dca-core.c          |    2 +-
 drivers/dma/dmatest.c           |    6 ++++--
 drivers/dma/fsldma.c            |    8 ++++++--
 drivers/dma/ioat.c              |    2 +-
 drivers/dma/ioat_dca.c          |   26 +++++++++++++++++++++++++-
 drivers/dma/ioat_dma.c          |   39 ++++++++++++++++++++++++---------------
 drivers/dma/ioatdma.h           |    8 +++++---
 drivers/dma/ioatdma_hw.h        |    2 +-
 drivers/dma/ioatdma_registers.h |    2 +-
 drivers/dma/iop-adma.c          |   16 ++++++++--------
 drivers/dma/ipu/ipu_idmac.c     |    2 +-
 drivers/dma/mv_xor.c            |   16 ++++++++--------
 include/linux/dmaengine.h       |    7 +------
 13 files changed, 86 insertions(+), 50 deletions(-)

1/ A collection of fixes for the I/OAT driver
2/ A fix for dmatest fallout from the merge window identified by Thierry
3/ Some code inspection fixes from Roel, Eric, Johannes, and Luotao

Thanks,
Dan

---
commit 7cbd4877e5b167b56a3d6033b926a9f925186e12
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 4 16:06:03 2009 -0700

    dmatest: fix use after free in dmatest_exit
    
    dmatest_cleanup_chanel will free dtc, so grab ->chan before it goes away
    and use it to do the release.
    
    Reported-by: Thierry Reding <thierry.reding@avionic-design.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 732fa1e..e190d8b 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -430,13 +430,15 @@ late_initcall(dmatest_init);
 static void __exit dmatest_exit(void)
 {
 	struct dmatest_chan *dtc, *_dtc;
+	struct dma_chan *chan;
 
 	list_for_each_entry_safe(dtc, _dtc, &dmatest_channels, node) {
 		list_del(&dtc->node);
+		chan = dtc->chan;
 		dmatest_cleanup_channel(dtc);
 		pr_debug("dmatest: dropped channel %s\n",
-			 dma_chan_name(dtc->chan));
-		dma_release_channel(dtc->chan);
+			 dma_chan_name(chan));
+		dma_release_channel(chan);
 	}
 }
 module_exit(dmatest_exit);

commit c74ef1f867d18171c8617519ee5fe40b02903934
Author: Luotao Fu <l.fu@pengutronix.de>
Date:   Thu Feb 26 12:29:20 2009 +0100

    ipu_idmac: fix spinlock type
    
    fix a probably accidently dropped reference operator while calling
    spin_unlock_restore to an ipu lock.
    
    Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
    Cc: Guennadi Liakhovetski <lg@denx.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 1f154d0..ae50a9d 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -729,7 +729,7 @@ static int ipu_init_channel_buffer(struct idmac_channel *ichan,
 
 	ichan->status = IPU_CHANNEL_READY;
 
-	spin_unlock_irqrestore(ipu->lock, flags);
+	spin_unlock_irqrestore(&ipu->lock, flags);
 
 	return 0;
 }

commit a09b09ae51ace43d28cd9bc1c8bb97986f2b55a6
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Wed Feb 25 13:56:21 2009 +0100

    iop-adma, mv_xor: fix mem leak on self-test setup failure
    
    iop_adma_zero_sum_self_test has the brackets in the wrong place for the
    setup failure deallocation path.  This error was duplicated in
    mv_xor_xor_self_test.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index ea5440d..4131ab8 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -928,19 +928,19 @@ iop_adma_xor_zero_sum_self_test(struct iop_adma_device *device)
 
 	for (src_idx = 0; src_idx < IOP_ADMA_NUM_SRC_TEST; src_idx++) {
 		xor_srcs[src_idx] = alloc_page(GFP_KERNEL);
-		if (!xor_srcs[src_idx])
-			while (src_idx--) {
+		if (!xor_srcs[src_idx]) {
+			while (src_idx--)
 				__free_page(xor_srcs[src_idx]);
-				return -ENOMEM;
-			}
+			return -ENOMEM;
+		}
 	}
 
 	dest = alloc_page(GFP_KERNEL);
-	if (!dest)
-		while (src_idx--) {
+	if (!dest) {
+		while (src_idx--)
 			__free_page(xor_srcs[src_idx]);
-			return -ENOMEM;
-		}
+		return -ENOMEM;
+	}
 
 	/* Fill in src buffers */
 	for (src_idx = 0; src_idx < IOP_ADMA_NUM_SRC_TEST; src_idx++) {
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index d35cbd1..2a4e3e3 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1019,19 +1019,19 @@ mv_xor_xor_self_test(struct mv_xor_device *device)
 
 	for (src_idx = 0; src_idx < MV_XOR_NUM_SRC_TEST; src_idx++) {
 		xor_srcs[src_idx] = alloc_page(GFP_KERNEL);
-		if (!xor_srcs[src_idx])
-			while (src_idx--) {
+		if (!xor_srcs[src_idx]) {
+			while (src_idx--)
 				__free_page(xor_srcs[src_idx]);
-				return -ENOMEM;
-			}
+			return -ENOMEM;
+		}
 	}
 
 	dest = alloc_page(GFP_KERNEL);
-	if (!dest)
-		while (src_idx--) {
+	if (!dest) {
+		while (src_idx--)
 			__free_page(xor_srcs[src_idx]);
-			return -ENOMEM;
-		}
+		return -ENOMEM;
+	}
 
 	/* Fill in src buffers */
 	for (src_idx = 0; src_idx < MV_XOR_NUM_SRC_TEST; src_idx++) {

commit 900325a6ce33995688b7a680a34e7698f16f4d72
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Mar 2 15:33:46 2009 -0700

    fsldma: fix off by one in dma_halt
    
    Prevent dev_err from firing even if we successfully detected 'dma-idle'
    before the full 1ms timeout has elapsed.
    
    Acked-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 70126a6..86d6da4 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -158,7 +158,8 @@ static void dma_start(struct fsl_dma_chan *fsl_chan)
 
 static void dma_halt(struct fsl_dma_chan *fsl_chan)
 {
-	int i = 0;
+	int i;
+
 	DMA_OUT(fsl_chan, &fsl_chan->reg_base->mr,
 		DMA_IN(fsl_chan, &fsl_chan->reg_base->mr, 32) | FSL_DMA_MR_CA,
 		32);
@@ -166,8 +167,11 @@ static void dma_halt(struct fsl_dma_chan *fsl_chan)
 		DMA_IN(fsl_chan, &fsl_chan->reg_base->mr, 32) & ~(FSL_DMA_MR_CS
 		| FSL_DMA_MR_EMS_EN | FSL_DMA_MR_CA), 32);
 
-	while (!dma_is_idle(fsl_chan) && (i++ < 100))
+	for (i = 0; i < 100; i++) {
+		if (dma_is_idle(fsl_chan))
+			break;
 		udelay(10);
+	}
 	if (i >= 100 && !dma_is_idle(fsl_chan))
 		dev_err(fsl_chan->dev, "DMA halt timeout!\n");
 }

commit 0c33e1ca3d80647f2e72e44524fd21e79214da20
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Mar 2 13:31:35 2009 -0700

    I/OAT: fail self-test if callback test reaches timeout
    
    If we miss interrupts in the self test then fail registration of this
    channel as it is unsuitable for use as a public channel.
    
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 068b635..5905cd3 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -1363,6 +1363,7 @@ static int ioat_dma_self_test(struct ioatdma_device *device)
 	dma_cookie_t cookie;
 	int err = 0;
 	struct completion cmp;
+	unsigned long tmo;
 
 	src = kzalloc(sizeof(u8) * IOAT_TEST_SIZE, GFP_KERNEL);
 	if (!src)
@@ -1414,9 +1415,10 @@ static int ioat_dma_self_test(struct ioatdma_device *device)
 	}
 	device->common.device_issue_pending(dma_chan);
 
-	wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
+	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
 
-	if (device->common.device_is_tx_complete(dma_chan, cookie, NULL, NULL)
+	if (tmo == 0 ||
+	    device->common.device_is_tx_complete(dma_chan, cookie, NULL, NULL)
 					!= DMA_SUCCESS) {
 		dev_err(&device->pdev->dev,
 			"Self-test copy timed out, disabling\n");

commit 211a22ce08dbb27eb1a66df8a4bdae5e96092bc8
Author: Maciej Sosnowski <maciej.sosnowski@intel.com>
Date:   Thu Feb 26 11:05:43 2009 +0100

    I/OAT: update driver version and copyright dates
    
    Together with new fixes update driver version
    and extend copyright dates ranges.
    
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
    Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
index 33bd753..25b743a 100644
--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2007 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff --git a/drivers/dma/ioat.c b/drivers/dma/ioat.c
index 4105d65..ed83dd9 100644
--- a/drivers/dma/ioat.c
+++ b/drivers/dma/ioat.c
@@ -1,6 +1,6 @@
 /*
  * Intel I/OAT DMA Linux driver
- * Copyright(c) 2007 Intel Corporation.
+ * Copyright(c) 2007 - 2009 Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
diff --git a/drivers/dma/ioat_dca.c b/drivers/dma/ioat_dca.c
index 78705ca..c012a1e 100644
--- a/drivers/dma/ioat_dca.c
+++ b/drivers/dma/ioat_dca.c
@@ -1,6 +1,6 @@
 /*
  * Intel I/OAT DMA Linux driver
- * Copyright(c) 2007 Intel Corporation.
+ * Copyright(c) 2007 - 2009 Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index ae8c0ce..068b635 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -1,6 +1,6 @@
 /*
  * Intel I/OAT DMA Linux driver
- * Copyright(c) 2004 - 2007 Intel Corporation.
+ * Copyright(c) 2004 - 2009 Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
diff --git a/drivers/dma/ioatdma.h b/drivers/dma/ioatdma.h
index dcf8db5..a52ff4b 100644
--- a/drivers/dma/ioatdma.h
+++ b/drivers/dma/ioatdma.h
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2004 - 2007 Intel Corporation. All rights reserved.
+ * Copyright(c) 2004 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -29,7 +29,7 @@
 #include <linux/pci_ids.h>
 #include <net/tcp.h>
 
-#define IOAT_DMA_VERSION  "3.30"
+#define IOAT_DMA_VERSION  "3.64"
 
 enum ioat_interrupt {
 	none = 0,
diff --git a/drivers/dma/ioatdma_hw.h b/drivers/dma/ioatdma_hw.h
index f1ae2c7..afa57ee 100644
--- a/drivers/dma/ioatdma_hw.h
+++ b/drivers/dma/ioatdma_hw.h
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2004 - 2007 Intel Corporation. All rights reserved.
+ * Copyright(c) 2004 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff --git a/drivers/dma/ioatdma_registers.h b/drivers/dma/ioatdma_registers.h
index 827cb50..49bc277 100644
--- a/drivers/dma/ioatdma_registers.h
+++ b/drivers/dma/ioatdma_registers.h
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2004 - 2007 Intel Corporation. All rights reserved.
+ * Copyright(c) 2004 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free

commit aa2d0b8b97efa1033609ca89b9faa5d3a1232959
Author: Eric Sesterhenn <snakebyte@gmx.de>
Date:   Thu Feb 26 11:05:30 2009 +0100

    I/OAT: list usage cleanup
    
    Trivial cleanup, list_del(); list_add_tail() is equivalent
    to list_move_tail(). Semantic patch for coccinelle can be
    found at www.cccmz.de/~snakebyte/list_move_tail.spatch
    
    Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
    Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index fc9b845..ae8c0ce 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -1171,9 +1171,8 @@ static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan)
 				 * up if the client is done with the descriptor
 				 */
 				if (async_tx_test_ack(&desc->async_tx)) {
-					list_del(&desc->node);
-					list_add_tail(&desc->node,
-						      &ioat_chan->free_desc);
+					list_move_tail(&desc->node,
+						       &ioat_chan->free_desc);
 				} else
 					desc->async_tx.cookie = 0;
 			} else {

commit 5de22343b2303b278ab562e5d166ffe306566d30
Author: Maciej Sosnowski <maciej.sosnowski@intel.com>
Date:   Thu Feb 26 11:05:17 2009 +0100

    I/OAT: set tcp_dma_copybreak to 256k for I/OAT ver.3
    
    Upcoming server platforms from Intel based on the Nehalem performance
    have significantly improved CPU based copy performance.
    However, the DMA engine can still be effective at higher I/O sizes
    for TCP traffic and at this time copybreak
    should be set to 256k for TCP traffic only.
    
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
    Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/ioatdma.h b/drivers/dma/ioatdma.h
index a3306d0..dcf8db5 100644
--- a/drivers/dma/ioatdma.h
+++ b/drivers/dma/ioatdma.h
@@ -135,12 +135,14 @@ static inline void ioat_set_tcp_copy_break(struct ioatdma_device *dev)
 	#ifdef CONFIG_NET_DMA
 	switch (dev->version) {
 	case IOAT_VER_1_2:
-	case IOAT_VER_3_0:
 		sysctl_tcp_dma_copybreak = 4096;
 		break;
 	case IOAT_VER_2_0:
 		sysctl_tcp_dma_copybreak = 2048;
 		break;
+	case IOAT_VER_3_0:
+		sysctl_tcp_dma_copybreak = 262144;
+		break;
 	}
 	#endif
 }

commit 2b8a6bf896ef47cc7d84c503079cc7b99789f9fa
Author: Maciej Sosnowski <maciej.sosnowski@intel.com>
Date:   Thu Feb 26 11:05:07 2009 +0100

    I/OAT: cancel watchdog before dma remove
    
    Channel watchdog should be canceled before the rest of dma remove stuff.
    
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
    Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 9012da7..fc9b845 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -1705,6 +1705,9 @@ void ioat_dma_remove(struct ioatdma_device *device)
 	struct dma_chan *chan, *_chan;
 	struct ioat_dma_chan *ioat_chan;
 
+	if (device->version != IOAT_VER_3_0)
+		cancel_delayed_work(&device->work);
+
 	ioat_dma_remove_interrupts(device);
 
 	dma_async_device_unregister(&device->common);
@@ -1716,10 +1719,6 @@ void ioat_dma_remove(struct ioatdma_device *device)
 	pci_release_regions(device->pdev);
 	pci_disable_device(device->pdev);
 
-	if (device->version != IOAT_VER_3_0) {
-		cancel_delayed_work(&device->work);
-	}
-
 	list_for_each_entry_safe(chan, _chan,
 				 &device->common.channels, device_node) {
 		ioat_chan = to_ioat_chan(chan);

commit 8b794b141c633083408d0bfb2229b3406d0ebf99
Author: Maciej Sosnowski <maciej.sosnowski@intel.com>
Date:   Thu Feb 26 11:04:54 2009 +0100

    I/OAT: fail initialization on zero channels detection
    
    On some systems with I/OAT ver.2 when DCA is disabled in BIOS
    situations have been observed
    that zero DMA channels are detected instead of four.
    To avoid kernel panic driver should fail gracefully with appropriate message.
    
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
    Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 879f4a0..9012da7 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -1659,6 +1659,13 @@ struct ioatdma_device *ioat_dma_probe(struct pci_dev *pdev,
 		" %d channels, device version 0x%02x, driver version %s\n",
 		device->common.chancnt, device->version, IOAT_DMA_VERSION);
 
+	if (!device->common.chancnt) {
+		dev_err(&device->pdev->dev,
+			"Intel(R) I/OAT DMA Engine problem found: "
+			"zero channels detected\n");
+		goto err_setup_interrupts;
+	}
+
 	err = ioat_dma_setup_interrupts(device);
 	if (err)
 		goto err_setup_interrupts;

commit ea9c717d0148d4194f9bd04ecfa6b59b20fc0a08
Author: Maciej Sosnowski <maciej.sosnowski@intel.com>
Date:   Thu Feb 26 11:04:38 2009 +0100

    I/OAT: do not set DCACTRL_CMPL_WRITE_ENABLE for I/OAT ver.3
    
    Flag DCACTRL_CMPL_WRITE_ENABLE is valid only for I/OAT ver.2
    so it should not be set for I/OAT ver.3.
    
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
    Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index b3759c4..879f4a0 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -189,11 +189,13 @@ static int ioat_dma_enumerate_channels(struct ioatdma_device *device)
 		ioat_chan->xfercap = xfercap;
 		ioat_chan->desccount = 0;
 		INIT_DELAYED_WORK(&ioat_chan->work, ioat_dma_chan_reset_part2);
-		if (ioat_chan->device->version != IOAT_VER_1_2) {
-			writel(IOAT_DCACTRL_CMPL_WRITE_ENABLE
-					| IOAT_DMA_DCA_ANY_CPU,
-				ioat_chan->reg_base + IOAT_DCACTRL_OFFSET);
-		}
+		if (ioat_chan->device->version == IOAT_VER_2_0)
+			writel(IOAT_DCACTRL_CMPL_WRITE_ENABLE |
+			       IOAT_DMA_DCA_ANY_CPU,
+			       ioat_chan->reg_base + IOAT_DCACTRL_OFFSET);
+		else if (ioat_chan->device->version == IOAT_VER_3_0)
+			writel(IOAT_DMA_DCA_ANY_CPU,
+			       ioat_chan->reg_base + IOAT_DCACTRL_OFFSET);
 		spin_lock_init(&ioat_chan->cleanup_lock);
 		spin_lock_init(&ioat_chan->desc_lock);
 		INIT_LIST_HEAD(&ioat_chan->free_desc);

commit 49bc46360d68156ce82b2b1a12badb80078453a0
Author: Maciej Sosnowski <maciej.sosnowski@intel.com>
Date:   Thu Feb 26 11:04:23 2009 +0100

    I/OAT: add verification for proper APICID_TAG_MAP setting by BIOS
    
    BIOS versions for systems with I/OAT ver.2 have been found
    which fail to program APICID_TAG_MAP for DCA.
    The ioatdma driver should recognize incorrectly set APICID_TAG_MAP
    and disable DCA in that case.
    
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
    Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/ioat_dca.c b/drivers/dma/ioat_dca.c
index 6cf622d..78705ca 100644
--- a/drivers/dma/ioat_dca.c
+++ b/drivers/dma/ioat_dca.c
@@ -49,6 +49,23 @@
 
 #define DCA_TAG_MAP_MASK 0xDF
 
+/* expected tag map bytes for I/OAT ver.2 */
+#define DCA2_TAG_MAP_BYTE0 0x80
+#define DCA2_TAG_MAP_BYTE1 0x0
+#define DCA2_TAG_MAP_BYTE2 0x81
+#define DCA2_TAG_MAP_BYTE3 0x82
+#define DCA2_TAG_MAP_BYTE4 0x82
+
+/* verify if tag map matches expected values */
+static inline int dca2_tag_map_valid(u8 *tag_map)
+{
+	return ((tag_map[0] == DCA2_TAG_MAP_BYTE0) &&
+		(tag_map[1] == DCA2_TAG_MAP_BYTE1) &&
+		(tag_map[2] == DCA2_TAG_MAP_BYTE2) &&
+		(tag_map[3] == DCA2_TAG_MAP_BYTE3) &&
+		(tag_map[4] == DCA2_TAG_MAP_BYTE4));
+}
+
 /*
  * "Legacy" DCA systems do not implement the DCA register set in the
  * I/OAT device.  Software needs direct support for their tag mappings.
@@ -452,6 +469,13 @@ struct dca_provider *ioat2_dca_init(struct pci_dev *pdev, void __iomem *iobase)
 			ioatdca->tag_map[i] = 0;
 	}
 
+	if (!dca2_tag_map_valid(ioatdca->tag_map)) {
+		dev_err(&pdev->dev, "APICID_TAG_MAP set incorrectly by BIOS, "
+			"disabling DCA\n");
+		free_dca_provider(dca);
+		return NULL;
+	}
+
 	err = register_dca_provider(dca, &pdev->dev);
 	if (err) {
 		free_dca_provider(dca);

commit 1d93e52eb48df986a3c4d5ad8a520bf1f6837367
Author: Johannes Weiner <jw@emlix.com>
Date:   Wed Feb 11 08:47:19 2009 -0700

    dmaengine: update kerneldoc
    
    Some of the kerneldoc comments in the dmaengine header describe
    already removed structure members.  Remove them.
    
    Also add a short description for dma_device->device_is_tx_complete.
    
    Signed-off-by: Johannes Weiner <jw@emlix.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 3e68469..087e79a 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -97,7 +97,6 @@ typedef struct { DECLARE_BITMAP(bits, DMA_TX_TYPE_END); } dma_cap_mask_t;
 
 /**
  * struct dma_chan_percpu - the per-CPU part of struct dma_chan
- * @refcount: local_t used for open-coded "bigref" counting
  * @memcpy_count: transaction counter
  * @bytes_transferred: byte counter
  */
@@ -114,9 +113,6 @@ struct dma_chan_percpu {
  * @cookie: last cookie value returned to client
  * @chan_id: channel ID for sysfs
  * @dev: class device for sysfs
- * @refcount: kref, used in "bigref" slow-mode
- * @slow_ref: indicates that the DMA channel is free
- * @rcu: the DMA channel's RCU head
  * @device_node: used to add this to the device chan list
  * @local: per-cpu pointer to a struct dma_chan_percpu
  * @client-count: how many clients are using this channel
@@ -211,8 +207,6 @@ struct dma_async_tx_descriptor {
  * @global_node: list_head for global dma_device_list
  * @cap_mask: one or more dma_capability flags
  * @max_xor: maximum number of xor sources, 0 if no capability
- * @refcount: reference count
- * @done: IO completion struct
  * @dev_id: unique device ID
  * @dev: struct device reference for dma mapping api
  * @device_alloc_chan_resources: allocate resources and return the
@@ -225,6 +219,7 @@ struct dma_async_tx_descriptor {
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
  * @device_prep_slave_sg: prepares a slave dma operation
  * @device_terminate_all: terminate all pending operations
+ * @device_is_tx_complete: poll for transaction completion
  * @device_issue_pending: push pending transactions to hardware
  */
 struct dma_device {


