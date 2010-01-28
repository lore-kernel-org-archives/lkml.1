Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302Ab0A1SEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab0A1SEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 13:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890Ab0A1SEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 13:04:13 -0500
Received: from kroah.org ([198.145.64.141]:44994 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab0A1SEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 13:04:11 -0500
Date: Thu, 28 Jan 2010 09:45:46 -0800
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial
 writes" causes gobi_loader to hang
Message-ID: <20100128174546.GC19871@kroah.com>
References: <20100117025535.GB7045@srcf.ucam.org>
 <201001181825.39823.oliver@neukum.org>
 <20100118201416.GA26511@srcf.ucam.org>
 <201001191420.29652.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001191420.29652.oliver@neukum.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 02:20:29PM +0100, Oliver Neukum wrote:
> Am Montag, 18. Januar 2010 21:14:16 schrieb Matthew Garrett:
> 
> > drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 1565 
> > bytes
> > drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes 
> > into fifo
> > drivers/usb/serial/generic.c: usb_serial_generic_read_bulk_callback - 
> > port 0
> 
> If the FIFO is full we can do nothing. Please try the attached patch.

Did we ever determine if the patch below is needed or not?

thanks,

greg k-h

> From d7317bae0772b794a1cc9b832bc3d3e1b3642a13 Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oliver@neukum.org>
> Date: Tue, 19 Jan 2010 14:16:41 +0100
> Subject: [PATCH] usb:serial:Deal with filled FIFO
> 
> Bail out if the FIFO is filled
> 
> Signed-off-by: Oliver Neukum <oliver@neukum.org>
> ---
>  drivers/usb/serial/generic.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
> index 76e5514..053f7f1 100644
> --- a/drivers/usb/serial/generic.c
> +++ b/drivers/usb/serial/generic.c
> @@ -349,6 +349,10 @@ int usb_serial_generic_write(struct tty_struct *tty,
>  
>  	count = kfifo_in_locked(&port->write_fifo, buf, count, &port->lock);
>  	dbg("%s - put %d bytes into fifo", __func__, count);
> +	if (!count) {
> +		dbg("%s - FIFO is full", __func__);
> +		return 0;
> +	}
>  	result = usb_serial_generic_write_start(port);
>  
>  	if (result >= 0)
> -- 
> 1.6.4.2
> 

