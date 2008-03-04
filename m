Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbYCDU1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbYCDU1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760056AbYCDU1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:27:07 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53146 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759704AbYCDU1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:27:06 -0500
Date: Tue, 4 Mar 2008 15:27:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Christian Kujau <lists@nerdbynature.de>
cc: David Brownell <david-b@pacbell.net>, LKML <linux-kernel@vger.kernel.org>,
       <0x0007@gmail.com>, USB list <linux-usb@vger.kernel.org>
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
In-Reply-To: <alpine.DEB.1.00.0803041948230.5974@sheep.housecafe.de>
Message-ID: <Pine.LNX.4.44L0.0803041525570.15190-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, Christian Kujau wrote:

> I'm not sure, but do you mean:
> 
> --- linux-2.6/drivers/usb/host/ehci-hcd.c	2008-02-24 22:25:54.000000000 +0100
> +++ linux-2.6/drivers/usb/host/ehci-hcd.c.edited	2008-03-04 19:46:13.000000000 +0100
> @@ -284,7 +284,10 @@ static void ehci_iaa_watchdog(unsigned l
>   	u32			status, cmd;
> 
>   	spin_lock_irqsave (&ehci->lock, flags);
> -	WARN_ON(!ehci->reclaim);
> +	if (unlikely(!ehci->reclaim ||
> +			!HC_IS_RUNNING(ehci_to_hcd(ehci)->state) ||
> +			timer_pending(&ehci->iaa_watchdog))
> +	goto done;
> 
>   	status = ehci_readl(ehci, &ehci->regs->status);
>   	cmd = ehci_readl(ehci, &ehci->regs->command);

Almost.  I meant:

Index: usb-2.6/drivers/usb/host/ehci-hcd.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-hcd.c
+++ usb-2.6/drivers/usb/host/ehci-hcd.c
@@ -260,7 +260,10 @@ static void ehci_iaa_watchdog(unsigned l
 	u32			status, cmd;
 
 	spin_lock_irqsave (&ehci->lock, flags);
-	WARN_ON(!ehci->reclaim);
+	if (unlikely(!ehci->reclaim ||
+			!HC_IS_RUNNING(ehci_to_hcd(ehci)->state) ||
+			timer_pending(&ehci->iaa_watchdog))
+		goto done;
 
 	status = ehci_readl(ehci, &ehci->regs->status);
 	cmd = ehci_readl(ehci, &ehci->regs->command);
@@ -276,7 +279,7 @@ static void ehci_iaa_watchdog(unsigned l
 		ehci_writel(ehci, cmd & ~CMD_IAAD, &ehci->regs->command);
 		end_unlink_async(ehci);
 	}
-
+ done:
 	spin_unlock_irqrestore(&ehci->lock, flags);
 }
 

