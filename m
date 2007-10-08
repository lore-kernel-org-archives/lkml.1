Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbXJHXya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbXJHXya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbXJHXyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:54:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35590
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752346AbXJHXyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:54:21 -0400
Date: Mon, 08 Oct 2007 16:54:20 -0700 (PDT)
Message-Id: <20071008.165420.42793456.davem@davemloft.net>
To: david-b@pacbell.net
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071007.005156.85395415.davem@davemloft.net>
References: <20071006.235358.104048815.davem@davemloft.net>
	<20071007073141.A88DD2393E2@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20071007.005156.85395415.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sun, 07 Oct 2007 00:51:56 -0700 (PDT)

> From: David Brownell <david-b@pacbell.net>
> Date: Sun, 07 Oct 2007 00:31:41 -0700
> 
> > Are the other ports still behaving?  Is EHCI maybe trying to switch
> > ownership of that port?  Is maybe the (newish) autosuspend stuff
> > kicking in?
> 
> I wouldn't know, the machine hangs and doesn't get any further.

To add some more information here, I think the EHCI idea might
hold some water.

What I have here are two NEC OHCI USB interfaces and one NEC EHCI
USB interface on PCI.  Aparently they all go through a shared
USB hub, mapped like this:

HUB Port 1: OHCI #1, EHCI
HUB Port 2: OHCI #2, EHCI
HUB Port 3: OHCI #1, EHCI
HUB Port 4: OHCI #2, EHCI
HUB Port 5: OHCI #1, EHCI

The OHCI ports go out to external USB connectors on the back panel of
the machine, whereas the EHCI is connected up to an internal USB
storage CDROM device and what appears to be another USB hub.

The problem seems to be very strongly tied to timing.  For example
simply adding "ignore_loglevel" to the kernel boot command line can
make the problem go away.

This got me thinking about your EHCI comment.

If these controllers are going through the same HUB, things might go
south if OHCI initialized first, then khubd et al. are asynchronously
accessing the segments behind OHCI at the same time that the EHCI
driver is initializing.  Perhaps, this is the kind of sequence of
events which makes one of the root ports reset in such a way that the
the reset bit never clears.

Given that this machine has 64 cpus, the likelyhood for such parallel
accesses is very likely :-)

Does this make any sense?

Regardless, here is a patch that hardens the OHCI reset handling
loops so that they break out instead of hanging the entire system
should this condition occur.  It's at least better than what the
code does to a user right now which is hang the box completely:

[USB] ohci: Do not hang the system if port reset does not complete.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/usb/host/ohci-hub.c b/drivers/usb/host/ohci-hub.c
index bb9cc59..77ae5b4 100644
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
+		limit_2 = PORT_RESET_MSEC * 2;
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
