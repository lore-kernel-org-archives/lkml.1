Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbXJBVKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbXJBVKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 17:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbXJBVJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 17:09:52 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:27693 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751451AbXJBVJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 17:09:52 -0400
X-Trace: 629825498-mk-filter-3.mail.uk.tiscali.com-B2C-$THROTTLED-DYNAMIC-CUSTOMER-DYNAMIC-IP
X-SBRS: None
X-RemoteIP: 81.1.76.66
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAPpIAkdRAUxC/2dsb2JhbACBWQ
Subject: [PATCH] Fix SH DMAC code to handle PVR2 cascade
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>,
       linux-sh <linuxsh-dev@lists.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 22:09:27 +0100
Message-Id: <1191359367.17654.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix SH DMAC code to correctly handle PVR2 cascade DMA.

This updates http://lkml.org/lkml/2007/10/2/276

(I decided it was better to have the true size of the transfer put in
via the API and refactor this here. And calc_xmit_shift(chan) should
return 5 but only returns 3 so I've not used it here)


--- arch/sh/drivers/dma/dma-sh.c	2007/09/22 18:34:42	1.1
+++ arch/sh/drivers/dma/dma-sh.c	2007/10/02 20:53:49	1.3
@@ -150,6 +150,13 @@ static void sh_dmac_disable_dma(struct d
 
 static int sh_dmac_xfer_dma(struct dma_channel *chan)
 {
+	/* Handle Dreamcast PVR cascade */
+	if (mach_is_dreamcast() && chan->chan == PVR2_CASCADE_CHAN) {
+		ctrl_outl(chan->sar, SAR[chan->chan]);
+		/* Transfer in 32 byte blocks */
+		ctrl_outl((chan->count) >> 5, DMATCR[chan->chan]);
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
