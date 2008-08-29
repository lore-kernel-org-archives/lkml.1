Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbYH2QCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbYH2QCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYH2QCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:02:25 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2368 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752546AbYH2QCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:02:24 -0400
Date: Fri, 29 Aug 2008 12:02:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: greg@kroah.com
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
       Brian Merrell <bgmerrell@novell.com>,
       Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>, <gregkh@suse.de>
Subject: Re: [patch 02/03] USB: USB/IP: add client driver
In-Reply-To: <20080828230035.GC15014@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0808291126130.4447-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
> +			    gfp_t mem_flags)
> +{
> +	struct device *dev = &urb->dev->dev;
> +	int ret = 0;
> +	unsigned long flags;
> +
> +	dbg_vhci_hc("enter, usb_hcd %p urb %p mem_flags %d\n",
> +		    hcd, urb, mem_flags);
> +
> +	/* patch to usb_sg_init() is in 2.5.60 */
> +	BUG_ON(!urb->transfer_buffer && urb->transfer_buffer_length);
> +
> +	spin_lock_irqsave(&the_controller->lock, flags);
> +
> +	/* check HC is active or not */
> +	if (!HC_IS_RUNNING(hcd->state)) {
> +		dev_err(dev, "HC is not running\n");
> +		spin_unlock_irqrestore(&the_controller->lock, flags);
> +		return -ENODEV;
> +	}
> +
> +	if (urb->status != -EINPROGRESS) {
> +		dev_err(dev, "URB already unlinked!, status %d\n", urb->status);
> +		spin_unlock_irqrestore(&the_controller->lock, flags);
> +		return urb->status;
> +	}

Neither of these two tests is necessary.  They are both carried out by
usb_hcd_link_urb_to_ep().

> +
> +	ret = usb_hcd_link_urb_to_ep(hcd, urb);
> +	if (ret)
> +		goto no_need_unlink;

This is wrong.  The driver should simply return ret; it should not
giveback the URB.

> +
> +	/*
> +	 * The enumelation process is as follows;

It would be nice to avoid Japanese-isms in the comments.

> +	 *
> +	 *  1. Get_Descriptor request to DevAddrs(0) EndPoint(0)
> +	 *     to get max packet length of default pipe
> +	 *
> +	 *  2. Set_Address request to DevAddr(0) EndPoint(0)
> +	 *
> +	 */

Rather than deal with simulating initialization commands in difficult
contexts, it would be better to change usbcore.  We should recognize
the existence of "virtual" USB devices which don't need address
assignment or re-enumeration following reset.  Then much of the
following code wouldn't be needed.

> +
> +	if (usb_pipedevice(urb->pipe) == 0) {
> +		__u8 type = usb_pipetype(urb->pipe);
> +		struct usb_ctrlrequest *ctrlreq =
> +				(struct usb_ctrlrequest *) urb->setup_packet;
> +		struct vhci_device *vdev =
> +				port_to_vdev(the_controller->pending_port);
> +
> +		if (type != PIPE_CONTROL || !ctrlreq) {
> +			dev_err(dev, "invalid request to devnum 0\n");
> +			ret = EINVAL;
> +			goto no_need_xmit;
> +		}
> +
> +		switch (ctrlreq->bRequest) {
> +		case USB_REQ_SET_ADDRESS:
> +			/* set_address may come when a device is reset */
> +			dev_info(dev, "SetAddress Request (%d) to port %d\n",
> +				 ctrlreq->wValue, vdev->rhport);
> +
> +			vdev->udev = urb->dev;
> +
> +			spin_lock(&vdev->ud.lock);
> +			vdev->ud.status = VDEV_ST_USED;
> +			spin_unlock(&vdev->ud.lock);
> +
> +			if (urb->status == -EINPROGRESS) {
> +				/* This request is successfully completed. */
> +				/* If not -EINPROGRESS, possibly unlinked. */
> +				urb->status = 0;
> +			}
> +
> +			goto no_need_xmit;
> +
> +		case USB_REQ_GET_DESCRIPTOR:
> +			if (ctrlreq->wValue == (USB_DT_DEVICE << 8))
> +				dbg_vhci_hc("Not yet?: "
> +						"Get_Descriptor to device 0 "
> +						"(get max pipe size)\n");
> +
> +			/* FIXME: reference count? (usb_get_dev()) */
> +			vdev->udev = urb->dev;
> +			goto out;
> +
> +		default:
> +			/* NOT REACHED */
> +			dev_err(dev, "invalid request to devnum 0 bRequest %u, "
> +				"wValue %u\n", ctrlreq->bRequest,
> +				ctrlreq->wValue);
> +			ret =  -EINVAL;
> +			goto no_need_xmit;
> +		}
> +
> +	}
> +
> +out:
> +	vhci_tx_urb(urb);
> +
> +	spin_unlock_irqrestore(&the_controller->lock, flags);
> +
> +	return 0;
> +
> +no_need_xmit:
> +	usb_hcd_unlink_urb_from_ep(hcd, urb);
> +no_need_unlink:
> +	spin_unlock_irqrestore(&the_controller->lock, flags);
> +
> +	usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
> +
> +	return 0;
> +}
> +
> +/*
> + * vhci_rx gives back the urb after receiving the reply of the urb.  If an
> + * unlink pdu is sent or not, vhci_rx receives a normal return pdu and gives
> + * back its urb. For the driver unlinking the urb, the content of the urb is
> + * not important, but the calling to its completion handler is important; the
> + * completion of unlinking is notified by the completion handler.
> + *
> + *
> + * CLIENT SIDE
> + *
> + * - When vhci_hcd receives RET_SUBMIT,
> + *
> + *	- case 1a). the urb of the pdu is not unlinking.
> + *		- normal case
> + *		=> just give back the urb
> + *
> + *	- case 1b). the urb of the pdu is unlinking.
> + *		- usbip.ko will return a reply of the unlinking request.
> + *		=> give back the urb now and go to case 2b).
> + *
> + * - When vhci_hcd receives RET_UNLINK,
> + *
> + *	- case 2a). a submit request is still pending in vhci_hcd.
> + *		- urb was really pending in usbip.ko and urb_unlink_urb() was
> + *		  completed there.
> + *		=> free a pending submit request
> + *		=> notify unlink completeness by giving back the urb
> + *
> + *	- case 2b). a submit request is *not* pending in vhci_hcd.
> + *		- urb was already given back to the core driver.
> + *		=> do not give back the urb
> + *
> + *
> + * SERVER SIDE
> + *
> + * - When usbip receives CMD_UNLINK,
> + *
> + *	- case 3a). the urb of the unlink request is now in submission.
> + *		=> do usb_unlink_urb().
> + *		=> after the unlink is completed, send RET_UNLINK.
> + *
> + *	- case 3b). the urb of the unlink request is not in submission.
> + *		- may be already completed or never be received
> + *		=> send RET_UNLINK
> + *
> + */

While I don't fully grasp these comments, they don't seem entirely
right.  Maybe my understanding is just weak, though.

For example, there's never any need to notify that an unlink has 
completed.  In fact, unlinks don't complete at all -- URBs complete but 
unlinks don't.

Perhaps the trickiest part is what happens when you try to unlink 
before the submit request has been accepted by the server.  This could 
be handled in a couple of ways: The server could refuse the submit 
request, or the client could send the unlink message after the submit 
response is received.

But I don't see why the client would ever want to call 
usb_hcd_giveback_urb() from within the dequeue method.  Unless perhaps 
the URB is still on a submit queue, waiting to be sent to the server.

> +static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
> +{
> +	unsigned long flags;
> +	struct vhci_priv *priv;
> +	struct vhci_device *vdev;
> +
> +	uinfo("vhci_hcd: dequeue a urb %p\n", urb);
> +
> +
> +	spin_lock_irqsave(&the_controller->lock, flags);
> +
> +	priv = urb->hcpriv;
> +	if (!priv) {
> +		/* URB was never linked! or will be soon given back by
> +		 * vhci_rx. */
> +		spin_unlock_irqrestore(&the_controller->lock, flags);
> +		return 0;
> +	}

This test shouldn't be needed; the spinlock should prevent it from ever 
succeeding.

> +
> +	{
> +		int ret = 0;
> +		ret = usb_hcd_check_unlink_urb(hcd, urb, status);
> +		if (ret) {
> +			spin_unlock_irqrestore(&the_controller->lock, flags);
> +			return 0;

Don't return 0, return ret.

> +		}
> +	}
> +
> +	 /* send unlink request here? */
> +	vdev = priv->vdev;
> +
> +	if (!vdev->ud.tcp_socket) {
> +		/* tcp connection is closed */
> +		unsigned long flags2;
> +
> +		spin_lock_irqsave(&vdev->priv_lock, flags2);
> +
> +		uinfo("vhci_hcd: device %p seems to be disconnected\n", vdev);
> +		list_del(&priv->list);
> +		kfree(priv);
> +		urb->hcpriv = NULL;
> +
> +		spin_unlock_irqrestore(&vdev->priv_lock, flags2);
> +
> +	} else {
> +		/* tcp connection is alive */
> +		unsigned long flags2;
> +		struct vhci_unlink *unlink;
> +
> +		spin_lock_irqsave(&vdev->priv_lock, flags2);
> +
> +		/* setup CMD_UNLINK pdu */
> +		unlink = kzalloc(sizeof(struct vhci_unlink), GFP_ATOMIC);
> +		if (!unlink) {
> +			uerr("malloc vhci_unlink\n");
> +			spin_unlock_irqrestore(&vdev->priv_lock, flags2);
> +			spin_unlock_irqrestore(&the_controller->lock, flags);
> +			usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_MALLOC);
> +			return -ENOMEM;
> +		}
> +
> +		unlink->seqnum = atomic_inc_return(&the_controller->seqnum);
> +		if (unlink->seqnum == 0xffff)
> +			uinfo("seqnum max\n");
> +
> +		unlink->unlink_seqnum = priv->seqnum;
> +
> +		uinfo("vhci_hcd: device %p seems to be still connected\n",
> +									vdev);
> +
> +		/* send cmd_unlink and try to cancel the pending URB in the
> +		 * peer */
> +		list_add_tail(&unlink->list, &vdev->unlink_tx);
> +		wake_up(&vdev->waitq_tx);
> +
> +		spin_unlock_irqrestore(&vdev->priv_lock, flags2);
> +	}
> +
> +
> +	/*
> +	 * If tcp connection is alive, we have sent CMD_UNLINK.
> +	 * vhci_rx will receive RET_UNLINK and give back the URB.
> +	 * Otherwise, we give back it here.
> +	 */
> +	if (!vdev->ud.tcp_socket) {

Why is this test repeated?  Couldn't the code be moved up into the 
previous test?

> +		/* tcp connection is closed */
> +		uinfo("vhci_hcd: vhci_urb_dequeue() gives back urb %p\n", urb);
> +
> +		usb_hcd_unlink_urb_from_ep(hcd, urb);
> +
> +		spin_unlock_irqrestore(&the_controller->lock, flags);
> +		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
> +								urb->status);
> +		spin_lock_irqsave(&the_controller->lock, flags);
> +	}
> +
> +	spin_unlock_irqrestore(&the_controller->lock, flags);
> +
> +	dbg_vhci_hc("leave\n");
> +	return 0;
> +}

WHy is there special code for unlinking URBs after the TCP connection 
has gone down?  Shouldn't all outstanding URBs immediately complete 
with -ESHUTDOWN status?

Alan Stern

