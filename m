Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbZJEWBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbZJEWBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 18:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbZJEWBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 18:01:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:46674 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbZJEWBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 18:01:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,508,1249282800"; 
   d="scan'208";a="733284664"
Subject: Re: 2.6.32-rc2: Intel(R) I/OAT DMA Engine init failed
From: Dan Williams <dan.j.williams@intel.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
In-Reply-To: <a4423d670910020246n1e82644bud8b7a01d49b93e26@mail.gmail.com>
References: <a4423d670910020246n1e82644bud8b7a01d49b93e26@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 05 Oct 2009 15:00:56 -0700
Message-Id: <1254780056.8066.6.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-02 at 02:46 -0700, Alexander Beregalov wrote:
> Hi
> The kerneil is 2.6.32-rc2-00196-g0efe5e3.
> Should I bisect?
> 
> ioatdma: Intel(R) QuickData Technology Driver 4.00
> ioatdma 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> ioatdma 0000:00:08.0: setting latency timer to 64
>   alloc irq_desc for 33 on node -1
>   alloc kstat_irqs on node -1
> ioatdma 0000:00:08.0: irq 33 for MSI/MSI-X
> ioatdma 0000:00:08.0: Self-test copy timed out, disabling
> ioatdma 0000:00:08.0: Intel(R) I/OAT DMA Engine init failed

I may ask for a bisect later, but for now let's try and see why it is
failing.  It is something platform specific as 2.6.32-rc3 loads fine on
my v1.2 platform.  Please reproduce this with the patch below.

Thanks,
Dan

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index c524d36..8f807b4 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -24,6 +24,7 @@
  * This driver supports an Intel I/OAT DMA engine, which does asynchronous
  * copy operations.
  */
+#define DEBUG
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -815,6 +816,7 @@ int __devinit ioat_dma_self_test(struct ioatdma_device *device)
 	struct completion cmp;
 	unsigned long tmo;
 	unsigned long flags;
+	enum dma_status stat;
 
 	src = kzalloc(sizeof(u8) * IOAT_TEST_SIZE, GFP_KERNEL);
 	if (!src)
@@ -864,10 +866,10 @@ int __devinit ioat_dma_self_test(struct ioatdma_device *device)
 
 	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
 
-	if (tmo == 0 ||
-	    dma->device_is_tx_complete(dma_chan, cookie, NULL, NULL)
-					!= DMA_SUCCESS) {
-		dev_err(dev, "Self-test copy timed out, disabling\n");
+	stat = dma->device_is_tx_complete(dma_chan, cookie, NULL, NULL);
+	if (tmo == 0 || stat != DMA_SUCCESS) {
+		dev_err(dev, "Self-test copy timed out, disabling %ld:%d\n",
+			tmo, stat);
 		err = -ENODEV;
 		goto free_resources;
 	}


