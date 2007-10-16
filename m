Return-Path: <linux-kernel-owner+w=401wt.eu-S934139AbXJPPYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139AbXJPPYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932739AbXJPPYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:24:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51308 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932600AbXJPPYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:24:00 -0400
Date: Tue, 16 Oct 2007 11:23:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Miller <davem@davemloft.net>
cc: david-b@pacbell.net, <linux-usb-users@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <greg@kroah.com>
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
In-Reply-To: <20071015.165828.59656315.davem@davemloft.net>
Message-ID: <Pine.LNX.4.44L0.0710161107510.4418-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, David Miller wrote:

> I want to help with this, but if I even breath on the kernel the bug
> goes away.  The race just gets harder to trigger, and if we just keep
> adding things it'll make the problem go away but for the absolutely
> wrong reasons.
> 
> The only way we will provably fix this is to make sure EHCI initialize
> fully, first, regardless of kernel config or what userland does.

Unfortunately that simply isn't possible.  No matter what you do, the 
user can always unload ehci-hcd and then load it back in again.

Do you have any idea _where_ in ohci_hub_control the hang still occurs?  
Is it the same unbounded reset loop?

Does the patch below satisfy both Davids?

Alan Stern



Index: usb-2.6/drivers/usb/host/ohci-hub.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ohci-hub.c
+++ usb-2.6/drivers/usb/host/ohci-hub.c
@@ -560,10 +560,10 @@ static void start_hnp(struct ohci_hcd *o
 /* called from some task, normally khubd */
 static inline int root_port_reset (struct ohci_hcd *ohci, unsigned port)
 {
-	__hc32 __iomem *portstat = &ohci->regs->roothub.portstatus [port];
-	u32	temp;
-	u16	now = ohci_readl(ohci, &ohci->regs->fmnumber);
-	u16	reset_done = now + PORT_RESET_MSEC;
+	__hc32 __iomem	*portstat = &ohci->regs->roothub.portstatus[port];
+	u32		temp;
+	unsigned long	reset_done = jiffies +
+				msecs_to_jiffies(PORT_RESET_MSEC);
 
 	/* build a "continuous enough" reset signal, with up to
 	 * 3msec gap between pulses.  scheduler HZ==100 must work;
@@ -578,6 +578,8 @@ static inline int root_port_reset (struc
 				return -ESHUTDOWN;
 			if (!(temp & RH_PS_PRS))
 				break;
+			if (time_after(jiffies, reset_done))
+				break;
 			udelay (500);
 		}
 
@@ -589,8 +591,7 @@ static inline int root_port_reset (struc
 		/* start the next reset, sleep till it's probably done */
 		ohci_writel (ohci, RH_PS_PRS, portstat);
 		msleep(PORT_RESET_HW_MSEC);
-		now = ohci_readl(ohci, &ohci->regs->fmnumber);
-	} while (tick_before(now, reset_done));
+	} while (time_before_eq(jiffies, reset_done));
 	/* caller synchronizes using PRSC */
 
 	return 0;

