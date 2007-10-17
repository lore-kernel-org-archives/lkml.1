Return-Path: <linux-kernel-owner+w=401wt.eu-S1762075AbXJQPwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762075AbXJQPwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762806AbXJQPwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:52:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55786 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762759AbXJQPv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:51:59 -0400
Date: Wed, 17 Oct 2007 11:51:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Miller <davem@davemloft.net>
cc: david-b@pacbell.net, <linux-usb-users@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <greg@kroah.com>
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
In-Reply-To: <20071016.150834.23011861.davem@davemloft.net>
Message-ID: <Pine.LNX.4.44L0.0710171050010.4468-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, David Miller wrote:

> From: Alan Stern <stern@rowland.harvard.edu>
> Date: Tue, 16 Oct 2007 11:23:58 -0400 (EDT)
> 
> > Do you have any idea _where_ in ohci_hub_control the hang still occurs?  
> > Is it the same unbounded reset loop?
> 
> Yes, with post status stuck at 0x111
> 
> > Does the patch below satisfy both Davids?
> 
> No, there are no warning messages that trigger

Okay, below is my patch with a warning message.

> My last patch was just fine, it timed out appropriately and warned the
> user telling them exactly what event timed out.

It isn't just fine.  See below for comments. 

> I'm reposting it here for reference, this is getting silly:
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/drivers/usb/host/ohci-hub.c b/drivers/usb/host/ohci-hub.c
> index bb9cc59..9149593 100644
> --- a/drivers/usb/host/ohci-hub.c
> +++ b/drivers/usb/host/ohci-hub.c
> @@ -563,14 +563,19 @@ static inline int root_port_reset (struct ohci_hcd *ohci, unsigned port)
>  	u32	temp;
>  	u16	now = ohci_readl(ohci, &ohci->regs->fmnumber);
>  	u16	reset_done = now + PORT_RESET_MSEC;
> +	int	limit_1;
>  
>  	/* build a "continuous enough" reset signal, with up to
>  	 * 3msec gap between pulses.  scheduler HZ==100 must work;
>  	 * this might need to be deadline-scheduled.
>  	 */
> -	do {
> +	limit_1 = 100;

Where did 100 come from?  Why not rely on the reset_done criterion,
which clearly is what you want?  Why have two tests for end-of-loop?

> +	while (--limit_1 >= 0) {
> +		int limit_2;
> +
>  		/* spin until any current reset finishes */
> -		for (;;) {
> +		limit_2 = PORT_RESET_HW_MSEC * 2;

This also is a somewhat arbitrary limit.  There's no obvious reason why
PORT_RESET_HW_MSEC should be both the limit for this loop and the
length of the msleep below.

> +		while (--limit_2 >= 0) {
>  			temp = ohci_readl (ohci, portstat);
>  			/* handle e.g. CardBus eject */
>  			if (temp == ~(u32)0)
> @@ -579,6 +584,10 @@ static inline int root_port_reset (struct ohci_hcd *ohci, unsigned port)
>  				break;
>  			udelay (500);
>  		}
> +		if (limit_2 < 0) {
> +			ohci_warn(ohci, "Root port inner-loop reset timeout, "
> +				  "portstat[%08x]\n", temp);
> +		}
>  
>  		if (!(temp & RH_PS_CCS))
>  			break;
> @@ -589,7 +598,14 @@ static inline int root_port_reset (struct ohci_hcd *ohci, unsigned port)
>  		ohci_writel (ohci, RH_PS_PRS, portstat);
>  		msleep(PORT_RESET_HW_MSEC);
>  		now = ohci_readl(ohci, &ohci->regs->fmnumber);
> -	} while (tick_before(now, reset_done));
> +		if (!tick_before(now, reset_done))

I realize that you are copying existing code here, but this makes the 
same kind of mistake you are trying to fix.  If a broken controller 
fails to increment its framenumber register, this termination condition 
will never be satisfied.  Better to compare against a jiffies value.

> +			break;
> +	}
> +	if (limit_1 < 0) {
> +		ohci_warn(ohci, "Root port outer-loop reset timeout, "
> +			  "now[%04x] reset_done[%04x]\n",
> +			  now, reset_done);
> +	}

What reason is there for having two warning messages?  One ought to be 
enough.

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
@@ -578,6 +578,12 @@ static inline int root_port_reset (struc
 				return -ESHUTDOWN;
 			if (!(temp & RH_PS_PRS))
 				break;
+			if (time_after(jiffies, reset_done)) {
+				ohci_warn(ohci, "Port %d reset timeout, "
+						"status %x\n",
+						port + 1, temp);
+				break;
+			}
 			udelay (500);
 		}
 
@@ -589,8 +595,7 @@ static inline int root_port_reset (struc
 		/* start the next reset, sleep till it's probably done */
 		ohci_writel (ohci, RH_PS_PRS, portstat);
 		msleep(PORT_RESET_HW_MSEC);
-		now = ohci_readl(ohci, &ohci->regs->fmnumber);
-	} while (tick_before(now, reset_done));
+	} while (time_before_eq(jiffies, reset_done));
 	/* caller synchronizes using PRSC */
 
 	return 0;

