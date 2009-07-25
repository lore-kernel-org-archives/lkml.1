Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbZGYToV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbZGYToV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 15:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZGYToV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 15:44:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:59480 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752263AbZGYToU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 15:44:20 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+iF3Q9zmOix/MJfSXoH8Q662iVBo5vyA4sppRtVL
	rD9HVEbgYkW/e8
Date: Sat, 25 Jul 2009 21:44:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefani Seibold <stefani@seibold.net>
cc: linux-kernel@vger.kernel.org, leoli@freescale.com,
       tanya.jiang@freescale.com
Subject: Re: [PATCH]: fsl usb gadget driver pullup fix
In-Reply-To: <1248465623.30437.24.camel@wall-e>
Message-ID: <Pine.LNX.4.64.0907252141100.7825@axis700.grange>
References: <1248465623.30437.24.camel@wall-e>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefani

On Fri, 24 Jul 2009, Stefani Seibold wrote:

> Attached is a small fix for the fsl usb gadget driver. This fix the
> driver in a way that the usb device will be only "pulled up" on request,
> like other usb gadget drivers do. 
> 
> This is necessary, because the device information is not always
> available until an application is up and running which provides this
> datas.

I can confirm (as well as some others), that there indeed is a problem 
with the fsl_usb2_udc driver pullup control. If this patch fixes it - 
great! I cannot verify its correctness by just looking at it, but I might 
be able to test it on an i.MX31. On which hardware did you test it?

Thanks
Guennadi

> 
> Hope you like it.
> 
>  fsl_udc_core.c |   41 ++++++++++++++++++++---------------------
>  1 file changed, 20 insertions(+), 21 deletions(-)
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> 
> --- linux-2.6.31-rc4.orig/drivers/usb/gadget/fsl_udc_core.c	2009-07-24
> 20:35:29.000000000 +0200
> +++ linux-2.6.31-rc4/drivers/usb/gadget/fsl_udc_core.c	2009-07-24
> 21:44:10.000000000 +0200
> @@ -171,6 +171,21 @@
>  	}
>  }
>  
> +static int can_pullup(struct fsl_udc *udc)
> +{
> +	return udc->driver && udc->softconnect && udc->vbus_active;
> +}
> +
> +static void set_pullup(struct fsl_udc *udc)
> +{
> +	if (can_pullup(udc))
> +		fsl_writel((fsl_readl(&dr_regs->usbcmd) | USB_CMD_RUN_STOP),
> +				&dr_regs->usbcmd);
> +	else
> +		fsl_writel((fsl_readl(&dr_regs->usbcmd) & ~USB_CMD_RUN_STOP),
> +				&dr_regs->usbcmd);
> +}
> +
>  /*------------------------------------------------------------------
>  	Internal Hardware related function
>   ------------------------------------------------------------------*/
> @@ -283,10 +298,7 @@
>  	temp |= USB_MODE_CTRL_MODE_DEVICE;
>  	fsl_writel(temp, &dr_regs->usbmode);
>  
> -	/* Set controller to Run */
> -	temp = fsl_readl(&dr_regs->usbcmd);
> -	temp |= USB_CMD_RUN_STOP;
> -	fsl_writel(temp, &dr_regs->usbcmd);
> +	set_pullup(udc);
>  
>  	return;
>  }
> @@ -1059,11 +1071,6 @@
>  	return 0;
>  }
>  
> -static int can_pullup(struct fsl_udc *udc)
> -{
> -	return udc->driver && udc->softconnect && udc->vbus_active;
> -}
> -
>  /* Notify controller that VBUS is powered, Called by whatever
>     detects VBUS sessions */
>  static int fsl_vbus_session(struct usb_gadget *gadget, int is_active)
> @@ -1075,12 +1082,7 @@
>  	spin_lock_irqsave(&udc->lock, flags);
>  	VDBG("VBUS %s", is_active ? "on" : "off");
>  	udc->vbus_active = (is_active != 0);
> -	if (can_pullup(udc))
> -		fsl_writel((fsl_readl(&dr_regs->usbcmd) | USB_CMD_RUN_STOP),
> -				&dr_regs->usbcmd);
> -	else
> -		fsl_writel((fsl_readl(&dr_regs->usbcmd) & ~USB_CMD_RUN_STOP),
> -				&dr_regs->usbcmd);
> +	set_pullup(udc);
>  	spin_unlock_irqrestore(&udc->lock, flags);
>  	return 0;
>  }
> @@ -1111,12 +1113,7 @@
>  
>  	udc = container_of(gadget, struct fsl_udc, gadget);
>  	udc->softconnect = (is_on != 0);
> -	if (can_pullup(udc))
> -		fsl_writel((fsl_readl(&dr_regs->usbcmd) | USB_CMD_RUN_STOP),
> -				&dr_regs->usbcmd);
> -	else
> -		fsl_writel((fsl_readl(&dr_regs->usbcmd) & ~USB_CMD_RUN_STOP),
> -				&dr_regs->usbcmd);
> +	set_pullup(udc);
>  
>  	return 0;
>  }
> @@ -2194,6 +2191,8 @@
>  
>  	udc->resume_state = USB_STATE_NOTATTACHED;
>  	udc->usb_state = USB_STATE_POWERED;
> +	udc->vbus_active = 1;
> +	udc->softconnect = 1;
>  	udc->ep0_dir = 0;
>  	udc->remote_wakeup = 0;	/* default to 0 on reset */
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
