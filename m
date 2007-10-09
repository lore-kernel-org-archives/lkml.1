Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbXJIEob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbXJIEob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 00:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbXJIEoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 00:44:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40251
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754736AbXJIEoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 00:44:09 -0400
Date: Mon, 08 Oct 2007 21:44:08 -0700 (PDT)
Message-Id: <20071008.214408.98397070.davem@davemloft.net>
To: david-b@pacbell.net
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071009043643.773CC23715F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20071007.005156.85395415.davem@davemloft.net>
	<20071008.165420.42793456.davem@davemloft.net>
	<20071009043643.773CC23715F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>
Date: Mon, 08 Oct 2007 21:36:43 -0700

> Don't need this "limit_1" timeout; "reset_done" handles all
> the timeout needed there.  The regs->fmnumber is essentially
> a millisecond counter.

If the hardware hangs and the register stops incrementing,
the entire kernel will hang.  That is unacceptable.

We do need it.

> 
> > +		int limit_2;
> > +
> >  		/* spin until any current reset finishes */
> > -		for (;;) {
> > +		limit_2 = PORT_RESET_MSEC * 2;
> 
> This is the loop that didn't terminate for you, right?
> PORT_RESET_HW_MSEC is the ceiling you should use here,
> not PORT_RESET_MSEC.

Ok, fixed.

> What values do you see for "portstat"?

0x111

> I suspect there will be some flag set which would allow a more
> immediate exit from that loop.  RH_PS_CCS might clear, for example.

Absolutely nothing clears in the register from it's initial value.

Here is the patch with the limit_2 initial value fixed.

I kept loop_1 in there, it is necessary.  No kernel code should
hang in an endless loop because of malfunctioning hardware.

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
