Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbXJBSni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbXJBSni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbXJBSn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:43:26 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:13812 "EHLO
	mk-filter-2-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754989AbXJBSnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:43:25 -0400
X-Trace: 618823932-mk-filter-2.mail.uk.tiscali.com-B2C-$THROTTLED-DYNAMIC-CUSTOMER-DYNAMIC-IP
X-SBRS: None
X-RemoteIP: 81.1.76.66
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAIQsAkdRAUxC/2dsb2JhbACBWQ
Subject: [PATCH] Fix up SH DMAC code to correctly handle PVR DMA
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>,
       linux-sh <linuxsh-dev@lists.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 19:42:51 +0100
Message-Id: <1191350571.17654.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes up SH DMAC code to correctly handle channel 2 DMA on
the Dreamcast.

Points to note:

* Currently the comments say that dar must be set - this appears to be
incorrect
* Currently the code uses calc_xmit_shift(chan) though that fuction does
not appear to work - this code relies on a division by 32 before the
xfer function is called
* Currently the code supports reading and writing, but the hardware only
supports writing

Signed-off by Adrian McMenamin <adrian@mcmen.demon.co.uk>

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
