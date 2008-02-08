Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbYBHWUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbYBHWUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbYBHWUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:20:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59407 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbYBHWUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:20:12 -0500
Date: Fri, 8 Feb 2008 14:18:13 -0800
From: Greg KH <greg@kroah.com>
To: Andy Shevchenko <andy@smile.org.ua>, sgosne@sequans.com
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] Possible bug fix in the ehci-hcd
Message-ID: <20080208221813.GB6827@kroah.com>
References: <20080207164832.GL20508@serv.smile.org.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207164832.GL20508@serv.smile.org.ua>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 06:48:32PM +0200, Andy Shevchenko wrote:
> Hi!
> 
> The Sequans company who produce WiMAX chips provides the USB driver and kthp
> addon driver. However the USB device doesn't work correctly.
> 
> Here is more true hack for Sequans SQN11x0 based modem.
> 
> P.S. For more details, please, ask Sequans staff (see Signed-off-by lines).
> 
> Signed-off-by: Andy Shevchenko <andy@smile.org.ua>
> Signed-off-by: Gosne Stephane <sgosne@sequans.com>
> 
> --- a/drivers/usb/host/ehci-q.c.orig	2008-02-07 16:53:18.000000000 +0200
> +++ b/drivers/usb/host/ehci-q.c	2008-02-07 16:53:18.000000000 +0200
> @@ -750,8 +750,14 @@
>  			info1 |= 1 << 14;	/* toggle from qtd */
>  			info2 |= (EHCI_TUNE_MULT_HS << 30);
>  		} else if (type == PIPE_BULK) {
> +			struct usb_device_descriptor *desc = &urb->dev->descriptor;
>  			info1 |= (EHCI_TUNE_RL_HS << 28);
> -			info1 |= 512 << 16;	/* usb2 fixed maxpacket */
> +			/* Special hook for SQN11x0 */
> +			if (desc->idVendor == 0x148e && desc->idProduct == 0x0900) {
> +				info1 |= max_packet (maxp) << 16;
> +			} else {
> +				info1 |= 512 << 16;	/* usb2 fixed maxpacket */
> +			}

We should not be adding hacks for a specific USB device to the host
driver, that's just wrong.

The driver for the device itself should be fixed.

Do you, or anyone else have a pointer to the driver that is causing this
problem?

Andrew, please drop this from your queue.

thanks,

greg k-h
