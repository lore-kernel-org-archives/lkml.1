Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbYH2IWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbYH2IWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbYH2IWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:22:16 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:53413 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbYH2IWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:22:13 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: greg@kroah.com
Subject: Re: [patch 02/03] USB: USB/IP: add client driver
Date: Fri, 29 Aug 2008 10:23:26 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Brian Merrell <bgmerrell@novell.com>,
       Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>, gregkh@suse.de
References: <20080828225248.758800945@mini.kroah.org> <20080828230035.GC15014@kroah.com>
In-Reply-To: <20080828230035.GC15014@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291023.27132.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 29 August 2008 01:00:35 schrieb greg@kroah.com:
> From: Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>

> +			dum->port_status[rhport] |=
> +					(1 << USB_PORT_FEAT_C_SUSPEND);
> +			dum->port_status[rhport] &=
> +					~(1 << USB_PORT_FEAT_SUSPEND);
> +			dum->resuming = 0;
> +			dum->re_timeout = 0;
> +			/* if (dum->driver && dum->driver->resume) {
> +			 *	spin_unlock (&dum->lock);

I realise it is commented out, but still.

The resume method may sleep. It is documented as such. Thus it can
reenable interrupts. Therefore you can deadlock if you don't use irqrestore.


> +static void vhci_tx_urb(struct urb *urb)
> +{
> +	struct vhci_device *vdev = get_vdev(urb->dev);
> +	struct vhci_priv *priv;
> +	unsigned long flag;
> +
> +	if (!vdev) {
> +		err("could not get virtual device");
> +		/* BUG(); */
> +		return;
> +	}
> +
> +	spin_lock_irqsave(&vdev->priv_lock, flag);
> +
> +	priv = kzalloc(sizeof(struct vhci_priv), GFP_ATOMIC);

There's no reason to hold the lock longer than necessary by
allocating memory in the lock section.

[..]
> +	wake_up(&vdev->waitq_tx);
> +	spin_unlock_irqrestore(&vdev->priv_lock, flag);

again

> +static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
> +			    gfp_t mem_flags)
> +{

This is called in the context of usb_submit_urb()

[..]
> +	ret = usb_hcd_link_urb_to_ep(hcd, urb);

This can fail for any urb due to urb->reject

> +	if (ret)
> +		goto no_need_unlink;

The branch would be taken

[..]
> +no_need_unlink:
> +	spin_unlock_irqrestore(&the_controller->lock, flags);
> +
> +	usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);

This calls urb->complete. If the completion handler takes a spinlock
which is held when usb_submit_urb() was called, you deadlock.

> +static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)

[..]
> +		spin_unlock_irqrestore(&the_controller->lock, flags);
> +		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
> +								urb->status);

This must be called with interrupts disabled.

> +		spin_lock_irqsave(&the_controller->lock, flags);
> +	}
> +
> +	spin_unlock_irqrestore(&the_controller->lock, flags);
> +
> +	dbg_vhci_hc("leave\n");
> +	return 0;
> +}

	Regards
		Oliver
