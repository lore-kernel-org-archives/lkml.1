Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0CIPII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 10:08:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35804 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753800Ab0CIPIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 10:08:05 -0500
Date: Tue, 9 Mar 2010 10:08:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, Alan Cox <alan@linux.intel.com>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 5/6] usb-hcd,usb-console: poll hcd device to force usb
 console writes
In-Reply-To: <1268116151-1448-6-git-send-email-jason.wessel@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1003091005080.1693-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010, Jason Wessel wrote:

> This patch tries to solve the problem that data is lost because there
> are too many outstanding transmit urb's while trying to execute
> printk's to a console.  The same is true if you try something like
> "echo t > /proc/sysrq-trigger".
> 
> This patch takes the route of forcibly polling the hcd device to drain
> the urb queue in order to initiate the bulk write call backs.  This
> only happens if the device is a usb serial console device that sets
> the max_in_flight_urbs to a non zero value in the serial device
> structure.
> 
> A few millisecond penalty will get incurred to allow the hcd controller
> to complete a write urb, else the console data is thrown away.
> 
> The max_in_flight_urbs was reduced in the usb_debug driver because it
> is highly desired to push things out to the console in a timely
> fashion and there is no need to have a queue that large for the
> interrupt driven mode of operation when used through the tty
> interface.

> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -1973,6 +1973,7 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
>  	local_irq_restore(flags);
>  	return rc;
>  }
> +EXPORT_SYMBOL_GPL(usb_hcd_irq);

Is there any reason for EXPORTing this?  It doesn't get used anywhere 
else.

> index a3cdb09..703f407 100644
> --- a/drivers/usb/core/hcd.h
> +++ b/drivers/usb/core/hcd.h
> @@ -318,6 +318,7 @@ extern void usb_put_hcd(struct usb_hcd *hcd);
>  extern int usb_add_hcd(struct usb_hcd *hcd,
>  		unsigned int irqnum, unsigned long irqflags);
>  extern void usb_remove_hcd(struct usb_hcd *hcd);
> +extern void usb_hcd_poll_irq(struct usb_device *udev);
>  
>  struct platform_device;
>  extern void usb_hcd_platform_shutdown(struct platform_device *dev);

It might be better to put this in a "public" header file; that is, 
something under include/linux/usb or include/linux/usb.h.  You could 
even take the "_hcd" part out of the name, because the interface uses 
only a struct usb_device, not a struct usb_hcd.

Alan Stern

