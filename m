Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYLJJkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYLJJkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 04:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbYLJJkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 04:40:09 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:32817 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567AbYLJJkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 04:40:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYEAHsdP0nCTsYx/2dsb2JhbACBbM5Lgwc
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] USB: use stack allocation for struct usb_ctrlrequest
Date: Wed, 10 Dec 2008 10:40:09 +0100
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org
References: <20081210073247.GA18630@localhost>
In-Reply-To: <20081210073247.GA18630@localhost>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812101040.09886.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wu,

On Wednesday 10 December 2008, Wu Fengguang wrote:
> sizeof(struct usb_ctrlrequest) = 8, which is as small as the *dt pointer
> in a 64bit system.

The usb_ctrlrequest pointer is passed down to the hardware and must point to 
DMA-able memory. For this reason you can't use the stack and must kmalloc() 
the structure.

Best regards,

Laurent Pinchart

> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  drivers/usb/core/message.c |   27 ++++++++-------------------
>  1 file changed, 8 insertions(+), 19 deletions(-)
>
> --- linux-2.6.orig/drivers/usb/core/message.c
> +++ linux-2.6/drivers/usb/core/message.c
> @@ -130,26 +130,15 @@ int usb_control_msg(struct usb_device *d
>  		    __u8 requesttype, __u16 value, __u16 index, void *data,
>  		    __u16 size, int timeout)
>  {
> -	struct usb_ctrlrequest *dr;
> -	int ret;
> -
> -	dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
> -	if (!dr)
> -		return -ENOMEM;
> -
> -	dr->bRequestType = requesttype;
> -	dr->bRequest = request;
> -	dr->wValue = cpu_to_le16p(&value);
> -	dr->wIndex = cpu_to_le16p(&index);
> -	dr->wLength = cpu_to_le16p(&size);
> +	struct usb_ctrlrequest dr = {
> +		.bRequestType = requesttype,
> +		.bRequest = request,
> +		.wValue = cpu_to_le16p(&value),
> +		.wIndex = cpu_to_le16p(&index),
> +		.wLength = cpu_to_le16p(&size),
> +	};
>
> -	/* dbg("usb_control_msg"); */
> -
> -	ret = usb_internal_control_msg(dev, pipe, dr, data, size, timeout);
> -
> -	kfree(dr);
> -
> -	return ret;
> +	return usb_internal_control_msg(dev, pipe, &dr, data, size, timeout);
>  }
>  EXPORT_SYMBOL_GPL(usb_control_msg);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
