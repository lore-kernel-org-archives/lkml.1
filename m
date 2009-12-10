Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbZLJUia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbZLJUia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 15:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757616AbZLJUia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 15:38:30 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45108 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757041AbZLJUi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 15:38:29 -0500
Date: Thu, 10 Dec 2009 15:38:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
In-Reply-To: <200912101640.02897.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.0912101525230.2680-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009, Ondrej Zary wrote:

> Narrowed down the code to this 170-line module which reproduces my
> "rmmod usbtouchscreen" problem. Loading this module causes EHCI to fail.
> Looks like it fails after calling usb_kill_urb(). Can a buggy device cause
> this?

I don't think so.  But I am getting an idea of what the problem might 
be.  Try applying the patch below and see if it makes any difference 
(make sure that CONFIG_USB_DEBUG is enabled).

If the module stops messing up EHCI, try changing the source code:

> static int crashnexio_probe(struct usb_interface *intf,
> 			  const struct usb_device_id *id)
> {

...

> 	interface = intf->cur_altsetting;
> 	/* find first input endpoint */
> 	for (i = 0; i < interface->desc.bNumEndpoints; i++)
> 		if (usb_endpoint_dir_in(&interface->endpoint[i].desc)) {
> 			endpoint = &interface->endpoint[i].desc;
> 			break;
> 		}

Does the interface have more than one input endpoint?  (What does
"lsusb -v" show for the Nexio?)  If it does, how do you know the 
endpoint you want is the first one?

...

> 	usb_fill_bulk_urb(crashnexio->irq, udev,
> 			 usb_rcvintpipe(udev, endpoint->bEndpointAddress),

Either change this to usb_fill_int_urb() or else use usb_rcvbulkpipe().

...

> static int __init crashnexio_init(void)
> {
> 	return usb_register(&crashnexio_driver);
> }

You should also have an __exit routine.

Alan Stern




Index: 2.6.31/Documentation/usb/error-codes.txt
===================================================================
--- 2.6.31.orig/Documentation/usb/error-codes.txt
+++ 2.6.31/Documentation/usb/error-codes.txt
@@ -41,8 +41,8 @@ USB-specific:
 
 -EFBIG		Host controller driver can't schedule that many ISO frames.
 
--EPIPE		Specified endpoint is stalled.  For non-control endpoints,
-		reset this status with usb_clear_halt().
+-EPIPE		The pipe type specified in the URB doesn't match the
+		endpoint's actual type.
 
 -EMSGSIZE	(a) endpoint maxpacket size is zero; it is not usable
 		    in the current interface altsetting.
@@ -60,6 +60,8 @@ USB-specific:
 
 -EHOSTUNREACH	URB was rejected because the device is suspended.
 
+-ENOEXEC	A control URB doesn't contain a Setup packet.
+
 
 **************************************************************************
 *                   Error codes returned by in urb->status               *
Index: 2.6.31/drivers/usb/core/devio.c
===================================================================
--- 2.6.31.orig/drivers/usb/core/devio.c
+++ 2.6.31/drivers/usb/core/devio.c
@@ -1065,7 +1065,10 @@ static int proc_do_submiturb(struct dev_
 		case USB_ENDPOINT_XFER_CONTROL:
 		case USB_ENDPOINT_XFER_ISOC:
 			return -EINVAL;
-		/* allow single-shot interrupt transfers, at bogus rates */
+		case USB_ENDPOINT_XFER_INT:
+			/* allow single-shot interrupt transfers */
+			uurb->type = USBDEVFS_URB_TYPE_INTERRUPT;
+			goto interrupt_urb;
 		}
 		uurb->number_of_packets = 0;
 		if (uurb->buffer_length > MAX_USBFS_BUFFER_SIZE)
@@ -1073,6 +1076,16 @@ static int proc_do_submiturb(struct dev_
 		snoop(&ps->dev->dev, "bulk urb\n");
 		break;
 
+	case USBDEVFS_URB_TYPE_INTERRUPT:
+		if (!usb_endpoint_xfer_int(&ep->desc))
+			return -EINVAL;
+ interrupt_urb:
+		uurb->number_of_packets = 0;
+		if (uurb->buffer_length > MAX_USBFS_BUFFER_SIZE)
+			return -EINVAL;
+		snoop(&ps->dev->dev, "interrupt urb\n");
+		break;
+
 	case USBDEVFS_URB_TYPE_ISO:
 		/* arbitrary limit */
 		if (uurb->number_of_packets < 1 ||
@@ -1105,15 +1118,6 @@ static int proc_do_submiturb(struct dev_
 		snoop(&ps->dev->dev, "iso urb\n");
 		break;
 
-	case USBDEVFS_URB_TYPE_INTERRUPT:
-		uurb->number_of_packets = 0;
-		if (!usb_endpoint_xfer_int(&ep->desc))
-			return -EINVAL;
-		if (uurb->buffer_length > MAX_USBFS_BUFFER_SIZE)
-			return -EINVAL;
-		snoop(&ps->dev->dev, "interrupt urb\n");
-		break;
-
 	default:
 		return -EINVAL;
 	}
Index: 2.6.31/drivers/usb/core/urb.c
===================================================================
--- 2.6.31.orig/drivers/usb/core/urb.c
+++ 2.6.31/drivers/usb/core/urb.c
@@ -387,6 +387,13 @@ int usb_submit_urb(struct urb *urb, gfp_
 	{
 	unsigned int	orig_flags = urb->transfer_flags;
 	unsigned int	allowed;
+	static int pipetypes[4] = {
+		PIPE_CONTROL, PIPE_ISOCHRONOUS, PIPE_BULK, PIPE_INTERRUPT
+	};
+
+	/* Check that pipe's type matches the endpoint's type */
+	if (usb_pipetype(urb->pipe) != pipetypes[xfertype])
+		return -EPIPE;
 
 	/* enforce simple/standard policy */
 	allowed = (URB_NO_TRANSFER_DMA_MAP | URB_NO_SETUP_DMA_MAP |

