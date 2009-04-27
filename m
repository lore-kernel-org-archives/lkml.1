Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbZD0Um2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbZD0Um2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbZD0UmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:42:16 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:45603 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304AbZD0UmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:42:15 -0400
Date: Mon, 27 Apr 2009 13:42:13 -0700
From: Ira Snyder <iws@ovro.caltech.edu>
To: Timur Tabi <timur@freescale.com>
Cc: David Hawkins <dwh@ovro.caltech.edu>,
       Liu Dave-R63238 <DaveLiu@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
Message-ID: <20090427204213.GA4960@ovro.caltech.edu>
References: <20090424183517.GB23140@ovro.caltech.edu> <D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net> <ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com> <49F608B7.9080409@ovro.caltech.edu> <49F60A3A.4060402@freescale.com> <49F61416.8040501@ovro.caltech.edu> <49F614FC.70000@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F614FC.70000@freescale.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 27 Apr 2009 13:42:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 03:26:36PM -0500, Timur Tabi wrote:
> David Hawkins wrote:
> 
> > PRC_RM - PCI read multiple
> >    The default PCI read command used by the DMA controller is
> >    PCI Read (PCI command 6h). When the burst length is 32-bytes
> >    or longer, PCI Read Line (PCI command Eh) is used (undocumented
> >    feature of the controller). Using PCI read multiple
> >    (PCI command Ch) results in high-performance across PCI
> >    bridges. DMA transfers to non-prefetchable PCI registers
> >    should not result in prefetched reads, even when using
> >    the PCI read multiple command.
> 
> I was thinking more along the lines of:
> 
> "This driver tells the DMA controller to use the PCI Read Multiple
> command, instead of the PCI Read Line command, for PCI read operations.
>  Please be aware that this setting may result in read pre-fetching on
> some platforms."
> 

How about the following revised patch? Is it ok to inline it this way,
or should I send another email to the list containing just this patch?

>From 73e42fa58c93de8d4d429ba8e069b60c42037b58 Mon Sep 17 00:00:00 2001
From: Ira W. Snyder <iws@ovro.caltech.edu>
Date: Thu, 23 Apr 2009 16:17:54 -0700
Subject: [PATCH] fsldma: use PCI Read Multiple command

By default, the Freescale 83xx DMA controller uses the PCI Read Line
command when reading data over the PCI bus. Setting the controller to use
the PCI Read Multiple command instead allows the controller to read much
larger bursts of data, which provides a drastic speed increase.

The slowdown due to using PCI Read Line was only observed when a PCI-to-PCI
bridge was between the devices trying to communicate.

A simple test driver showed an increase from 4MB/sec to 116MB/sec when
performing DMA over the PCI bus. Using DMA to transfer between blocks of
local SDRAM showed no change in performance with this patch. The dmatest
driver was also used to verify the correctness of the transfers, and showed
no errors.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---

v1 -> v2:
* Added comment warning about possible prefetching

 drivers/dma/fsldma.c |   10 ++++++++--
 drivers/dma/fsldma.h |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index da8a8ed..5943ca8 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -12,6 +12,11 @@
  *   also fit for MPC8560, MPC8555, MPC8548, MPC8641, and etc.
  *   The support for MPC8349 DMA contorller is also added.
  *
+ * This driver instructs the DMA controller to issue the PCI Read Multiple
+ * command for PCI read operations, instead of using the default PCI Read Line
+ * command. Please be aware that this setting may result in read pre-fetching
+ * on some platforms.
+ *
  * This is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -49,9 +54,10 @@ static void dma_init(struct fsl_dma_chan *fsl_chan)
 	case FSL_DMA_IP_83XX:
 		/* Set the channel to below modes:
 		 * EOTIE - End-of-transfer interrupt enable
+		 * PRC_RM - PCI read multiple
 		 */
-		DMA_OUT(fsl_chan, &fsl_chan->reg_base->mr, FSL_DMA_MR_EOTIE,
-				32);
+		DMA_OUT(fsl_chan, &fsl_chan->reg_base->mr, FSL_DMA_MR_EOTIE
+				| FSL_DMA_MR_PRC_RM, 32);
 		break;
 	}
 
diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
index 4f21a51..dc7f268 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -38,6 +38,7 @@
 
 /* Special MR definition for MPC8349 */
 #define FSL_DMA_MR_EOTIE	0x00000080
+#define FSL_DMA_MR_PRC_RM	0x00000800
 
 #define FSL_DMA_SR_CH		0x00000020
 #define FSL_DMA_SR_PE		0x00000010
-- 
1.5.4.3

