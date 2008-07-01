Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbYGAOLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbYGAOLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbYGAOLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:11:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51650 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754566AbYGAOLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:11:07 -0400
Date: Tue, 1 Jul 2008 10:11:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Becker <Stefan.Becker@nokia.com>
cc: ext David Brownell <david-b@pacbell.net>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] USB: fix interrupt disabling for HCDs with shared
 interrupt handlers
In-Reply-To: <48694F9A.4010008@nokia.com>
Message-ID: <Pine.LNX.4.44L0.0807011005430.2780-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008, Stefan Becker wrote:

> It is, put the rain pouring down on my house is keeping me awake :-)
> 
> Looks like you posted the same changes though...

A few minor problems...  You should post a revised patch with CC: to
Greg KH.  It makes things a little easier if you can put the patch in
the body of the email message instead of attaching it.

> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -1683,20 +1683,27 @@ EXPORT_SYMBOL_GPL(usb_bus_start_enum);
>   */
>  irqreturn_t usb_hcd_irq (int irq, void *__hcd)
>  {
> -	struct usb_hcd		*hcd = __hcd;
> -	int			start = hcd->state;
> +	struct usb_hcd		*hcd  = __hcd;
> +	unsigned int            flags = 0;

flags must be unsigned long.  You don't have to initialize it to 0.

> +	irqreturn_t             rc;
>  
> -	if (unlikely(start == HC_STATE_HALT ||
> -	    !test_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags)))
> -		return IRQ_NONE;
> -	if (hcd->driver->irq (hcd) == IRQ_NONE)
> -		return IRQ_NONE;
> +	local_irq_save(flags);
>  
> -	set_bit(HCD_FLAG_SAW_IRQ, &hcd->flags);
> +	if (unlikely(hcd->state == HC_STATE_HALT ||
> +		     !test_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags))) {
> +		rc = IRQ_NONE;
> +	} else if (hcd->driver->irq (hcd) == IRQ_NONE) {

The space after "irq" should be removed.

> +		rc = IRQ_NONE;
> +	} else {
> +		set_bit(HCD_FLAG_SAW_IRQ, &hcd->flags);
> +
> +		if (unlikely(hcd->state == HC_STATE_HALT))
> +			usb_hc_died (hcd);

The space after "died" should be removed.

Alan Stern

