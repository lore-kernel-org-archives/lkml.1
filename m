Return-Path: <linux-kernel-owner+w=401wt.eu-S934364AbYBUQCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934364AbYBUQCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932440AbYBUP47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:56:59 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35016 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933361AbYBUP46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:56:58 -0500
Date: Thu, 21 Feb 2008 10:56:55 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Andre Tomt <andre@tomt.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB OOPS 2.6.25-rc2-git1
In-Reply-To: <200802201356.28723.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0802211054550.4528-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008, David Brownell wrote:

> ========= CUT HERE
> Modify EHCI irq handling on the theory that at least some of the
> "lost" IRQs are caused by goofage between multiple lowlevel IRQ
> acking mechanisms:  try rescanning before we exit the handler, in
> case the EHCI-internal ack (by clearing the irq status) doesn't
> always suffice for IRQs triggered nearly back-to-back.
> 
> ---
>  drivers/usb/host/ehci-hcd.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> --- g26.orig/drivers/usb/host/ehci-hcd.c	2008-02-20 13:26:00.000000000 -0800
> +++ g26/drivers/usb/host/ehci-hcd.c	2008-02-20 13:54:37.000000000 -0800
> @@ -638,6 +638,8 @@ static irqreturn_t ehci_irq (struct usb_
>  		return IRQ_NONE;
>  	}
>  
> +retrigger:
> +
>  	/* clear (just) interrupts */
>  	ehci_writel(ehci, status, &ehci->regs->status);
>  	cmd = ehci_readl(ehci, &ehci->regs->command);
> @@ -725,6 +727,12 @@ dead:
>  
>  	if (bh)
>  		ehci_work (ehci);
> +
> +	status = ehci_readl(ehci, &ehci->regs->status);
> +	status &= INTR_MASK;
> +	if (status)
> +		goto retrigger;
> +
>  	spin_unlock (&ehci->lock);
>  	if (pcd_status & STS_PCD)
>  		usb_hcd_poll_rh_status(hcd);

There's one little problem here.  As a result of this change, the line 
where pcd_status gets set (not shown in this patch) needs to be changed 
to:

		pcd_status |= (status & STS_PCD);

Then the test shown above can be simplified to:

	if (pcd_status)

Alan Stern

