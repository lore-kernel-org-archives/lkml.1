Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbXJBSnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbXJBSnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbXJBSnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:43:18 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:37311 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbXJBSnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:43:17 -0400
X-Trace: 612600199-mk-filter-4.mail.uk.tiscali.com-B2C-$THROTTLED-DYNAMIC-CUSTOMER-DYNAMIC-IP
X-SBRS: None
X-RemoteIP: 81.1.76.66
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAIQsAkdRAUxC/2dsb2JhbACBWQ
Subject: [PATCH] Fix SH DMA API so it works with PVR cascade
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>,
       linux-sh <linuxsh-dev@lists.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 19:15:42 +0100
Message-Id: <1191348942.12347.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch - hope it is not too late for 2.6.24 queue - gets the SH DMA
API to work properly for the PVR2 DMA cascade.

Currently the comment suggests that dar should not be set for the write
DMA but the API forces a set. This code fixes that. Furthermore there is
no read on the PVR2 CASCADE DMA (at least for the PVR) so that code is
removed.

Submitted-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

--- arch/sh/drivers/dma/dma-sh.c	2007/09/22 18:34:42	1.1
+++ arch/sh/drivers/dma/dma-sh.c	2007/09/22 18:37:28	1.2
@@ -150,6 +150,13 @@ static void sh_dmac_disable_dma(struct d
 
 static int sh_dmac_xfer_dma(struct dma_channel *chan)
 {
+	/* Handle Dreamcast PVR cascade */
+	if (mach_is_dreamcast() && chan->chan == PVR2_CASCADE_CHAN)
+	{
+		ctrl_outl(chan->sar, SAR[chan->chan]);
+		ctrl_outl(chan->count, DMATCR[chan->chan]);
+		return 0;
+	}
 	/*
 	 * If we haven't pre-configured the channel with special flags, use
 	 * the defaults.
@@ -159,26 +166,9 @@ static int sh_dmac_xfer_dma(struct dma_c
 
 	sh_dmac_disable_dma(chan);
 
-	/*
-	 * Single-address mode usage note!
-	 *
-	 * It's important that we don't accidentally write any value to SAR/DAR
-	 * (this includes 0) that hasn't been directly specified by the user if
-	 * we're in single-address mode.
-	 *
-	 * In this case, only one address can be defined, anything else will
-	 * result in a DMA address error interrupt (at least on the SH-4),
-	 * which will subsequently halt the transfer.
-	 *
-	 * Channel 2 on the Dreamcast is a special case, as this is used for
-	 * cascading to the PVR2 DMAC. In this case, we still need to write
-	 * SAR and DAR, regardless of value, in order for cascading to work.
-	 */
-	if (chan->sar || (mach_is_dreamcast() &&
-			  chan->chan == PVR2_CASCADE_CHAN))
+	if (chan->sar)
 		ctrl_outl(chan->sar, SAR[chan->chan]);
-	if (chan->dar || (mach_is_dreamcast() &&
-			  chan->chan == PVR2_CASCADE_CHAN))
+	if (chan->dar)
 		ctrl_outl(chan->dar, DAR[chan->chan]);
 
 	ctrl_outl(chan->count >> calc_xmit_shift(chan), DMATCR[chan->chan]);
