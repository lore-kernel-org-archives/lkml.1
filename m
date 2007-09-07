Return-Path: <linux-kernel-owner+w=401wt.eu-S965676AbXIGQAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965676AbXIGQAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 12:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964864AbXIGQAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 12:00:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:62887 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964857AbXIGQAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 12:00:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,221,1186383600"; 
   d="scan'208";a="296564476"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
Date: Fri, 7 Sep 2007 09:00:17 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02FF08A1@orsmsx418.amr.corp.intel.com>
In-Reply-To: <11891624582950-git-send-email-wei.zhang@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx processors.
thread-index: AcfxPC/wGi09hKt4R6O5xlS4AldUsgAJWZkg
References: <11891624582950-git-send-email-wei.zhang@freescale.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Zhang Wei" <wei.zhang@freescale.com>, <paulus@samba.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       <galak@kernel.crashing.org>, "Ebony Zhu" <ebony.zhu@freescale.com>
X-OriginalArrivalTime: 07 Sep 2007 16:00:18.0323 (UTC) FILETIME=[2FBE1E30:01C7F168]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Zhang Wei [mailto:wei.zhang@freescale.com] 
>Sent: Friday, September 07, 2007 3:54 AM
>To: paulus@samba.org; Nelson, Shannon
>Cc: linux-kernel@vger.kernel.org; linuxppc-dev@ozlabs.org; 
>galak@kernel.crashing.org; Zhang Wei; Ebony Zhu
>Subject: [PATCH 5/5] Add DMA engine driver for Freescale 
>MPC85xx processors.
>
>The driver implements DMA engine API for Freescale MPC85xx DMA
>controller, which could be used for MEM<-->MEM, IO_ADDR<-->MEM
>and IO_ADDR<-->IO_ADDR data transfer.
>The driver supports the Basic mode of Freescale MPC85xx DMA controller.
>The MPC85xx processors supported include MPC8540/60, MPC8555, MPC8548,
>MPC8641 and so on.
>The support for MPC83xx(MPC8349, MPC8360) is experimental.
>
>Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
>Signed-off-by: Ebony Zhu <ebony.zhu@freescale.com>
>---
> drivers/dma/Kconfig  |    8 +
> drivers/dma/Makefile |    1 +
> drivers/dma/fsldma.c |  995 
>++++++++++++++++++++++++++++++++++++++++++++++++++
> drivers/dma/fsldma.h |  188 ++++++++++
> 4 files changed, 1192 insertions(+), 0 deletions(-)
> create mode 100644 drivers/dma/fsldma.c
> create mode 100644 drivers/dma/fsldma.h
>
>diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
>index 8f670da..a99e925 100644
>--- a/drivers/dma/Kconfig
>+++ b/drivers/dma/Kconfig
>@@ -40,4 +40,12 @@ config INTEL_IOP_ADMA
>         ---help---
>           Enable support for the Intel(R) IOP Series RAID engines.
> 
>+config FSL_DMA
>+	bool "Freescale MPC85xx/MPC83xx DMA support"
>+	depends on DMA_ENGINE && PPC
>+	---help---
>+	  Enable support for the Freescale DMA engine. Now, it support
>+	  MPC8560/40, MPC8555, MPC8548 and MPC8641 processors.
>+	  The MPC8349, MPC8360 support is experimental.
>+
> endmenu

If this is experimental, perhaps you should mark the depends line as
such
	depends on on DMA_ENGINE && PPC && EXPERIMENTAL

[...]

>+static int fsl_dma_self_test(struct fsl_dma_chan *fsl_chan)
>+{
>+	struct dma_chan *chan;
>+	int err = 0;
>+	dma_addr_t addr;
>+	dma_cookie_t cookie;
>+	u8 *src, *dest;
>+	int i;
>+	size_t test_size;
>+	struct dma_async_tx_descriptor *tx1, *tx2, *tx3;
>+	struct fsl_dma_device *fdev;
>+
>+	BUG_ON(!fsl_chan);
>+
>+	fdev = fsl_chan->device;
>+	test_size = 4096;
>+
>+	src = kmalloc(test_size * 2, GFP_KERNEL);
>+	if (!src) {
>+		dev_err(fdev->dev,
>+				"selftest: Can not alloc memory 
>for test!\n");
>+		err = -ENOMEM;
>+		goto out;
>+	}
>+
>+	dest = src + test_size;
>+
>+	for (i = 0; i < test_size; i++)
>+		src[i] = (u8) i;
>+
>+	chan = &fsl_chan->common;
>+
>+	if (fsl_dma_alloc_chan_resources(chan) < 1) {
>+		dev_err(fdev->dev,
>+				"selftest: Can not alloc 
>resources for DMA\n");
>+		err = -ENODEV;
>+		goto out;
>+	}
>+
>+	/* TX 1 */
>+	tx1 = fsl_dma_prep_memcpy(chan, test_size / 2, 0);
>+	async_tx_ack(tx1);
>+	addr = dma_map_single(chan->device->dev, src, test_size / 2,
>+							DMA_TO_DEVICE);
>+	fsl_dma_set_src(addr, tx1, 0);
>+	addr = dma_map_single(chan->device->dev, dest, test_size / 2,
>+							
>DMA_FROM_DEVICE);
>+	fsl_dma_set_dest(addr, tx1, 0);
>+
>+	cookie = fsl_dma_tx_submit(tx1);
>+	fsl_dma_memcpy_issue_pending(chan);
>+
>+	while (fsl_dma_is_complete(chan, cookie, NULL, NULL)
>+			!= DMA_SUCCESS);

Is this guaranteed to finish?  If there's something wrong and the DMA
never completes, you've now hung this thread.  This is why the ioat_dma
engine does an msleep() and then checks once for completion.  You might
think about this...

>+
>+	/* Test free and re-alloc channel resources */
>+	fsl_dma_free_chan_resources(chan);
>+
>+	if (fsl_dma_alloc_chan_resources(chan) < 1) {
>+		dev_err(fdev->dev,
>+				"selftest: Can not alloc 
>resources for DMA\n");
>+		err = -ENODEV;
>+		goto out;
>+	}
>+
>+	/* Continue to test
>+	 * TX 2
>+	 */
>+	tx2 = fsl_dma_prep_memcpy(chan, test_size / 4, 0);
>+	async_tx_ack(tx2);
>+	addr = dma_map_single(chan->device->dev, src + test_size / 2,
>+					test_size / 4, DMA_TO_DEVICE);
>+	fsl_dma_set_src(addr, tx2, 0);
>+	addr = dma_map_single(chan->device->dev, dest + test_size / 2,
>+					test_size / 4, DMA_FROM_DEVICE);
>+	fsl_dma_set_dest(addr, tx2, 0);
>+
>+	/* TX 3 */
>+	tx3 = fsl_dma_prep_memcpy(chan, test_size / 4, 0);
>+	async_tx_ack(tx3);
>+	addr = dma_map_single(chan->device->dev, src + 
>test_size * 3 / 4,
>+					test_size / 4, DMA_TO_DEVICE);
>+	fsl_dma_set_src(addr, tx3, 0);
>+	addr = dma_map_single(chan->device->dev, dest + 
>test_size * 3 / 4,
>+					test_size / 4, DMA_FROM_DEVICE);
>+	fsl_dma_set_dest(addr, tx3, 0);
>+
>+	/* Test exchanging the prepared tx sort */
>+	cookie = fsl_dma_tx_submit(tx3);
>+	cookie = fsl_dma_tx_submit(tx2);
>+
>+	fsl_dma_memcpy_issue_pending(chan);
>+	while (fsl_dma_is_complete(chan, cookie, NULL, NULL)
>+			!= DMA_SUCCESS);

Again, is it possible to hang your thread here?

[...]

sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
