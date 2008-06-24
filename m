Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbYFXVP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbYFXVP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYFXVPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:15:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58191 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752683AbYFXVPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:15:50 -0400
Date: Tue, 24 Jun 2008 17:15:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Becker <Stefan.Becker@nokia.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: [REGRESSION] 2.6.24/25: random lockups when accessing external
 USB harddrive
In-Reply-To: <48613FEF.8020004@nokia.com>
Message-ID: <Pine.LNX.4.44L0.0806241702490.2166-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008, Stefan Becker wrote:

> I played around with printk a little bit more. With the following change 
> to uhci_giveback_urb():
> 
> --- a/drivers/usb/host/uhci-q.c
> +++ b/drivers/usb/host/uhci-q.c
> @@ -1526,11 +1530,17 @@ __acquires(uhci->lock)
>          }
> 
>          uhci_free_urb_priv(uhci, urbp);
> +       printk(KERN_CRIT "UHCI UNLINK ENTER %08x %08x\n",
> +              (unsigned int) uhci, (unsigned int) urb);
>          usb_hcd_unlink_urb_from_ep(uhci_to_hcd(uhci), urb);
> +       printk(KERN_CRIT "UHCI UNLINK LEAVE %08x %08x\n",
> +              (unsigned int) uhci, (unsigned int) urb);
> 
>          spin_unlock(&uhci->lock);
> 
> I see
> 
>   UHCI UNLINK ENTER xxxxxxxx yyyyyyyy
>   UHCI UNLINK LEAVE xxxxxxxx yyyyyyyy
>   UHCI UNLINK ENTER xxxxxxxx yyyyyyyy
> 
> on the console at the time of the lockup. Then I added the following change:
> 
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -1107,7 +1107,13 @@ EXPORT_SYMBOL_GPL(usb_hcd_check_unlink_urb);
>   void usb_hcd_unlink_urb_from_ep(struct usb_hcd *hcd, struct urb *urb)
>   {
>          /* clear all state linking urb to this dev (and hcd) */
> +#if 0
>          spin_lock(&hcd_urb_list_lock);
> +#else
> +       if (!spin_trylock(&hcd_urb_list_lock)) {
> +         printk(KERN_CRIT "HCD URB LIST ALREADY LOCKED!\n");
> +       }
> +#endif
>          list_del_init(&urb->urb_list);
>          spin_unlock(&hcd_urb_list_lock);
>   }
> 
> and get this at the time of the lockup:
> 
>   UHCI UNLINK ENTER xxxxxxxx yyyyyyyy
>   UHCI UNLINK LEAVE xxxxxxxx yyyyyyyy
>   UHCI UNLINK ENTER xxxxxxxx yyyyyyyy
>   HCD URB LIST ALREADY LOCKED!
>              <---- here the original code would lockup
>   UHCI UNLINK LEAVE xxxxxxxx yyyyyyyy
>   HCD URB LIST ALREADY LOCKED!
>   HCD URB LIST ALREADY LOCKED!
>   HCD URB LIST ALREADY LOCKED!
> 
> So the lockup is caused by an already locked hcd_urb_list_lock. Is there 
> a way to see the lock holder? Or any other suggestions how to proceed?

Good work!

There isn't any way to see the lock holder except by adding more 
printk's.  Fortunately that lock is private to hcd.c, so you know it's 
not used anywhere else.  And it's not used in very many places in that 
file, so you can add printk's around each one.  While you're at it, you 
ought to enable CONFIG_USB_DEBUG so that more of the context will be 
visible in the log.

The usage in usb_hcd_link_urb_to_ep() appears benign; the code doesn't 
do anything that might hang while holding the lock.  All it does is 
manipulate a linked list.

You have already instrumented the usage in 
usb_hcd_unlink_urb_from_ep().

That leaves only usb_hcd_flush_endpoint().  And once again, the code 
isn't doing anything while holding the lock except following 
linked-list pointers.  

Taken together, these facts suggest that somehow the linked list has
been corrupted.  So you might also want to add some printk's around the
linked-list activities in flush_endpoint, just to see if the pointer
values look reasonable.

Alan Stern

