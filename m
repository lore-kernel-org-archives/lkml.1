Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZAXGAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZAXGAi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 01:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbZAXGA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 01:00:29 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:47693 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750806AbZAXGA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 01:00:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1BGw/HK9JWNUyoNnNZlq95d7wXhn0gBQZPdWO2sdWaMFCk/osxrJQg9VQhekSVEkV+15lp5+SP1BPW24uTdUaRfqVWmK7i7L8z599wpgs87Gm97LS3NZr+7g3FCqZJjuStGQIslyPGDGaIeqcZQhNSZ/f5KjiQcE2GYsryrj4/o=  ;
X-YMail-OSG: CcppmecVM1nO5BCZynZDJeI4YGg4PYnUS1CHdvu22UuDCAm_i4PxQyVvm6adLBltTN0XuVUJCdHKrIWZqfM_py8KG3msLxRwFNvxq0oiAYqeFgb868Vv4jz4o9Q.ex8CwhXDLddFabDxljtZYnaRaFpOZoOBlhUOQT9S7ZbXlxdNXZvcKqZcEnu37xxpvgDrbfY.kwAgEPan1R.rjGO.wVfK4y3RmQgJ1b_iRg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 2/2] usb: composite: Fix bug: low byte of w_index is the usb interface number not the whole 2 bytes of w_index
Date: Fri, 23 Jan 2009 22:00:26 -0800
User-Agent: KMail/1.9.10
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1231345279-26618-1-git-send-email-cooloney@kernel.org> <1231345279-26618-3-git-send-email-cooloney@kernel.org>
In-Reply-To: <1231345279-26618-3-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901232200.26655.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2009, Bryan Wu wrote:
> In some usb gadget driver, for example usb audio class device, the high
> byte of w_index is the entity id and low byte is the interface number.
> If we use the 2 bytes of w_index as the array number, we will get a
> wrong pointer or NULL pointer.
> 
> This patch fixes this issue.
> 
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
>  drivers/usb/gadget/composite.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index 363951e..5d11c29 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -683,6 +683,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
>  	struct usb_request		*req = cdev->req;
>  	int				value = -EOPNOTSUPP;
>  	u16				w_index = le16_to_cpu(ctrl->wIndex);
> +	u8				intf = w_index & 0xFF;
>  	u16				w_value = le16_to_cpu(ctrl->wValue);
>  	u16				w_length = le16_to_cpu(ctrl->wLength);
>  	struct usb_function		*f = NULL;
> @@ -769,7 +770,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
>  			goto unknown;
>  		if (!cdev->config || w_index >= MAX_CONFIG_INTERFACES)
>  			break;
> -		f = cdev->config->interface[w_index];
> +		f = cdev->config->interface[intf];
>  		if (!f)
>  			break;
>  		if (w_value && !f->set_alt)
> @@ -781,7 +782,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
>  			goto unknown;
>  		if (!cdev->config || w_index >= MAX_CONFIG_INTERFACES)
>  			break;
> -		f = cdev->config->interface[w_index];
> +		f = cdev->config->interface[intf];
>  		if (!f)
>  			break;
>  		/* lots of interfaces only need altsetting zero... */
> @@ -808,7 +809,7 @@ unknown:
>  		 */
>  		if ((ctrl->bRequestType & USB_RECIP_MASK)
>  				== USB_RECIP_INTERFACE) {
> -			f = cdev->config->interface[w_index];
> +			f = cdev->config->interface[intf];
>  			if (f && f->setup)
>  				value = f->setup(f, ctrl);
>  			else
> -- 
> 1.5.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


