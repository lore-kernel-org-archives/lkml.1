Return-Path: <linux-kernel-owner+w=401wt.eu-S932997AbYBMQHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbYBMQHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757977AbYBMQHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:07:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:55549 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760800AbYBMQHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:07:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,347,1199692800"; 
   d="scan'208";a="517907356"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/4] async_tx: kill ->device_dependency_added
Date: Wed, 13 Feb 2008 08:05:50 -0800
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C0401018E@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20080213070308.793.70810.stgit@dwillia2-linux.ch.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4] async_tx: kill ->device_dependency_added
Thread-Index: AchuDrr4/Og2xR0mQMG8lwrWDC+KQQAS0Hpw
References: <20080213065944.793.23537.stgit@dwillia2-linux.ch.intel.com> <20080213070308.793.70810.stgit@dwillia2-linux.ch.intel.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>,
       <linux-kernel@vger.kernel.org>
Cc: <hskinnemoen@atmel.com>, <olof@lixom.net>, <yur@emcraft.com>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
X-OriginalArrivalTime: 13 Feb 2008 16:05:51.0212 (UTC) FILETIME=[4DD732C0:01C86E5A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Williams, Dan J 
>Sent: Tuesday, February 12, 2008 11:03 PM
>To: linux-kernel@vger.kernel.org
>Cc: hskinnemoen@atmel.com; Nelson, Shannon; olof@lixom.net; 
>yur@emcraft.com
>Subject: [PATCH 3/4] async_tx: kill ->device_dependency_added
>
>DMA drivers no longer need to be notified of depdency 
>submission events as
>async_tx_run_dependencies and async_tx_channel_switch will handle the
>scheduling and execution of dependent operations.
>
>Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>---
>
> drivers/dma/dmaengine.c   |    1 -
> drivers/dma/ioat_dma.c    |   12 ------------
> drivers/dma/iop-adma.c    |    7 -------
> include/linux/dmaengine.h |    2 --
> 4 files changed, 0 insertions(+), 22 deletions(-)
>
>
>diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
>index 9369781..5ca0d94 100644
>--- a/drivers/dma/dmaengine.c
>+++ b/drivers/dma/dmaengine.c
>@@ -362,7 +362,6 @@ int dma_async_device_register(struct 
>dma_device *device)
> 
> 	BUG_ON(!device->device_alloc_chan_resources);
> 	BUG_ON(!device->device_free_chan_resources);
>-	BUG_ON(!device->device_dependency_added);
> 	BUG_ON(!device->device_is_tx_complete);
> 	BUG_ON(!device->device_issue_pending);
> 	BUG_ON(!device->dev);
>diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
>index dff38ac..05ace54 100644
>--- a/drivers/dma/ioat_dma.c
>+++ b/drivers/dma/ioat_dma.c
>@@ -922,17 +922,6 @@ static void 
>ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan)
> 	spin_unlock_bh(&ioat_chan->cleanup_lock);
> }
> 
>-static void ioat_dma_dependency_added(struct dma_chan *chan)
>-{
>-	struct ioat_dma_chan *ioat_chan = to_ioat_chan(chan);
>-	spin_lock_bh(&ioat_chan->desc_lock);
>-	if (ioat_chan->pending == 0) {
>-		spin_unlock_bh(&ioat_chan->desc_lock);
>-		ioat_dma_memcpy_cleanup(ioat_chan);
>-	} else
>-		spin_unlock_bh(&ioat_chan->desc_lock);
>-}
>-
> /**
>  * ioat_dma_is_complete - poll the status of a IOAT DMA transaction
>  * @chan: IOAT DMA channel handle
>@@ -1314,7 +1303,6 @@ struct ioatdma_device 
>*ioat_dma_probe(struct pci_dev *pdev,
> 
> 	dma_cap_set(DMA_MEMCPY, device->common.cap_mask);
> 	device->common.device_is_tx_complete = ioat_dma_is_complete;
>-	device->common.device_dependency_added = 
>ioat_dma_dependency_added;
> 	switch (device->version) {
> 	case IOAT_VER_1_2:
> 		device->common.device_prep_dma_memcpy = 
>ioat1_dma_prep_memcpy;
>diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
>index a6171da..1cb4284 100644
>--- a/drivers/dma/iop-adma.c
>+++ b/drivers/dma/iop-adma.c
>@@ -672,12 +672,6 @@ iop_adma_prep_dma_zero_sum(struct 
>dma_chan *chan, dma_addr_t *dma_src,
> 	return sw_desc ? &sw_desc->async_tx : NULL;
> }
> 
>-static void iop_adma_dependency_added(struct dma_chan *chan)
>-{
>-	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
>-	tasklet_schedule(&iop_chan->irq_tasklet);
>-}
>-
> static void iop_adma_free_chan_resources(struct dma_chan *chan)
> {
> 	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
>@@ -1178,7 +1172,6 @@ static int __devinit 
>iop_adma_probe(struct platform_device *pdev)
> 	dma_dev->device_free_chan_resources = 
>iop_adma_free_chan_resources;
> 	dma_dev->device_is_tx_complete = iop_adma_is_complete;
> 	dma_dev->device_issue_pending = iop_adma_issue_pending;
>-	dma_dev->device_dependency_added = iop_adma_dependency_added;
> 	dma_dev->dev = &pdev->dev;
> 
> 	/* set prep routines based on capability */
>diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
>index d04b169..e2538b4 100644
>--- a/include/linux/dmaengine.h
>+++ b/include/linux/dmaengine.h
>@@ -258,7 +258,6 @@ struct dma_async_tx_descriptor {
>  * @device_prep_dma_zero_sum: prepares a zero_sum operation
>  * @device_prep_dma_memset: prepares a memset operation
>  * @device_prep_dma_interrupt: prepares an end of chain 
>interrupt operation
>- * @device_dependency_added: async_tx notifies the channel 
>about new deps
>  * @device_issue_pending: push pending transactions to hardware
>  */
> struct dma_device {
>@@ -293,7 +292,6 @@ struct dma_device {
> 	struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
> 		struct dma_chan *chan);
> 
>-	void (*device_dependency_added)(struct dma_chan *chan);
> 	enum dma_status (*device_is_tx_complete)(struct dma_chan *chan,
> 			dma_cookie_t cookie, dma_cookie_t *last,
> 			dma_cookie_t *used);
>
>

Acked-by: Shannon Nelson <shannon.nelson@intel.com>
