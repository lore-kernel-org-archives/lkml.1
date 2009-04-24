Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbZDXSf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbZDXSf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 14:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZDXSfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 14:35:20 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:56799 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZDXSfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 14:35:19 -0400
Date: Fri, 24 Apr 2009 11:35:18 -0700
From: Ira Snyder <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: Li Yang <leoli@freescale.com>, Zhang Wei <wei.zhang@freescale.com>,
       Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@ozlabs.org
Subject: [PATCH] fsldma: use PCI Read Multiple command
Message-ID: <20090424183517.GB23140@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 24 Apr 2009 11:35:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/dma/fsldma.c |    5 +++--
 drivers/dma/fsldma.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index da8a8ed..638d00e 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -49,9 +49,10 @@ static void dma_init(struct fsl_dma_chan *fsl_chan)
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

