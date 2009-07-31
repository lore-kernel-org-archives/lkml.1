Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbZGaPlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbZGaPlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 11:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZGaPlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 11:41:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44678 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751368AbZGaPli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 11:41:38 -0400
Date: Fri, 31 Jul 2009 11:41:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <dbrownell@users.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 07/10] ehci-dbgp,ehci: Allow early or late use of the
 dbgp device
In-Reply-To: <1249052833-9655-8-git-send-email-jason.wessel@windriver.com>
Message-ID: <Pine.LNX.4.44L0.0907311135030.3152-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009, Jason Wessel wrote:

> If the EHCI debug port is initialized and in use, the EHCI host
> controller driver must follow two rules.
> 
> 1) If the EHCI host driver issues a controller reset, the debug
>    controller driver re-initialization must get called after the reset
>    is completed.
> 
> 2) The EHCI host driver should ignore any requests to the physical
>    EHCI debug port when the EHCI debug port is in use.
> 
> The code to check for the debug port was moved from ehci_pci_reinit()
> to ehci_pci_setup because it must get called prior to ehci_reset()
> which will clear the debug port registers.

> --- a/drivers/usb/host/ehci-hub.c
> +++ b/drivers/usb/host/ehci-hub.c
> @@ -816,6 +816,15 @@ static int ehci_hub_control (
>  	case SetPortFeature:
>  		selector = wIndex >> 8;
>  		wIndex &= 0xff;
> +		if (unlikely(ehci->debug)) {

Don't you need a similar test for ClearPortFeature?  Or does that not
matter?

> +			/* If the debug port is active any port
> +			 * feature requests should get denied */
> +			if ((readl(&ehci->debug->control) & DBGP_ENABLED) &&
> +			    wIndex == HCS_DEBUG_PORT(ehci->hcs_params)) {

The order of the two tests here should be reversed, to avoid an 
unnecessary I/O access in the common case.

> +				retval = -ENODEV;
> +				goto error_exit;

This is the wrong return value.  You should return -EPIPE, i.e., goto
error instead of error_exit.

> +			}
> +		}
>  		if (!wIndex || wIndex > ports)
>  			goto error;
>  		wIndex--;
> @@ -894,6 +903,7 @@ error:
>  		/* "stall" on error */
>  		retval = -EPIPE;
>  	}
> +error_exit:

And then this new label isn't needed.

>  	spin_unlock_irqrestore (&ehci->lock, flags);
>  	return retval;
>  }

Alan Stern

