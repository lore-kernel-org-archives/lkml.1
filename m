Return-Path: <linux-kernel-owner+w=401wt.eu-S966257AbXJPWIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966257AbXJPWIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935392AbXJPWIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:08:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39534
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935389AbXJPWI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:08:29 -0400
Date: Tue, 16 Oct 2007 15:08:34 -0700 (PDT)
Message-Id: <20071016.150834.23011861.davem@davemloft.net>
To: stern@rowland.harvard.edu
Cc: david-b@pacbell.net, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.44L0.0710161107510.4418-100000@iolanthe.rowland.org>
References: <20071015.165828.59656315.davem@davemloft.net>
	<Pine.LNX.4.44L0.0710161107510.4418-100000@iolanthe.rowland.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>
Date: Tue, 16 Oct 2007 11:23:58 -0400 (EDT)

> Do you have any idea _where_ in ohci_hub_control the hang still occurs?  
> Is it the same unbounded reset loop?

Yes, with post status stuck at 0x111

> Does the patch below satisfy both Davids?

No, there are no warning messages that trigger

My last patch was just fine, it timed out appropriately and warned the
user telling them exactly what event timed out.

I'm reposting it here for reference, this is getting silly:

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/usb/host/ohci-hub.c b/drivers/usb/host/ohci-hub.c
index bb9cc59..9149593 100644
--- a/drivers/usb/host/ohci-hub.c
+++ b/drivers/usb/host/ohci-hub.c
@@ -563,14 +563,19 @@ static inline int root_port_reset (struct ohci_hcd *ohci, unsigned port)
 	u32	temp;
 	u16	now = ohci_readl(ohci, &ohci->regs->fmnumber);
 	u16	reset_done = now + PORT_RESET_MSEC;
+	int	limit_1;
 
 	/* build a "continuous enough" reset signal, with up to
 	 * 3msec gap between pulses.  scheduler HZ==100 must work;
 	 * this might need to be deadline-scheduled.
 	 */
-	do {
+	limit_1 = 100;
+	while (--limit_1 >= 0) {
+		int limit_2;
+
 		/* spin until any current reset finishes */
-		for (;;) {
+		limit_2 = PORT_RESET_HW_MSEC * 2;
+		while (--limit_2 >= 0) {
 			temp = ohci_readl (ohci, portstat);
 			/* handle e.g. CardBus eject */
 			if (temp == ~(u32)0)
@@ -579,6 +584,10 @@ static inline int root_port_reset (struct ohci_hcd *ohci, unsigned port)
 				break;
 			udelay (500);
 		}
+		if (limit_2 < 0) {
+			ohci_warn(ohci, "Root port inner-loop reset timeout, "
+				  "portstat[%08x]\n", temp);
+		}
 
 		if (!(temp & RH_PS_CCS))
 			break;
@@ -589,7 +598,14 @@ static inline int root_port_reset (struct ohci_hcd *ohci, unsigned port)
 		ohci_writel (ohci, RH_PS_PRS, portstat);
 		msleep(PORT_RESET_HW_MSEC);
 		now = ohci_readl(ohci, &ohci->regs->fmnumber);
-	} while (tick_before(now, reset_done));
+		if (!tick_before(now, reset_done))
+			break;
+	}
+	if (limit_1 < 0) {
+		ohci_warn(ohci, "Root port outer-loop reset timeout, "
+			  "now[%04x] reset_done[%04x]\n",
+			  now, reset_done);
+	}
 	/* caller synchronizes using PRSC */
 
 	return 0;
