Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYF0Hnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYF0Hnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 03:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYF0HnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 03:43:21 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:56875 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbYF0HnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 03:43:20 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [PATCH 001/001] linux-input:  Support for BCM5974 multitouch trackpad
Date: Fri, 27 Jun 2008 09:43:46 +0200
User-Agent: KMail/1.9.9
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       dmitry.torokhov@gmail.com, robfitz@273k.net, jikos@jikos.cz,
       vojtech@suse.cz, dmonakhov@openvz.org
References: <1214521639.20365.1.camel@alnilam>
In-Reply-To: <1214521639.20365.1.camel@alnilam>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806270943.48634.oliver@neukum.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 27 Juni 2008 01:07:19 schrieb Henrik Rydberg:
> From: Henrik Rydberg <rydberg@euromail.se>
> 
> BCM5974: This driver adds support for the multitouch trackpad on the new
> Apple Macbook Air and Macbook Pro Penryn laptops. It replaces the
> appletouch driver on those computers, and integrates well with the
> synaptics driver of the Xorg system. 

Some comments on the driver.

	Regards
		Oliver

> +
> +static int atp_wellspring_init(struct usb_device *udev)
> +{
> +  const struct atp_config_t *cfg = atp_product_config(udev);
> +  char data[8];

DMA on the stack. You must kmalloc that buffer.
> +  int size;
> +
> +  /* reset button endpoint */
> +  if (usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> +		      USB_REQ_CLEAR_FEATURE, USB_RECIP_ENDPOINT,
> +		      0, cfg->bt_ep, NULL, 0, 5000)) {
> +    err("Could not reset button endpoint");
> +    return -EIO;
> +  }
> +
> +  /* reset trackpad endpoint */
> +  if (usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> +		      USB_REQ_CLEAR_FEATURE, USB_RECIP_ENDPOINT,
> +		      0, cfg->tp_ep, NULL, 0, 5000)) {
> +    err("Could not reset trackpad endpoint");
> +    return -EIO;
> +  }
> +
> +  /* read configuration */
> +  size = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> +			 ATP_WELLSPRING_MODE_READ_REQUEST_ID,
> +			 USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> +			 ATP_WELLSPRING_MODE_REQUEST_VALUE,
> +			 ATP_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);
> +
> +  if (size != 8) {
> +    err("Could not do mode read request from device (Wellspring Raw mode)");
> +    return -EIO;
> +  }
> +
> +  /* apply the mode switch */
> +  data[0] = ATP_WELLSPRING_MODE_VENDOR_VALUE_1;
> +  data[1] = ATP_WELLSPRING_MODE_VENDOR_VALUE_2;
> +
> +  /* write configuration */
> +  size = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
> +			 ATP_WELLSPRING_MODE_WRITE_REQUEST_ID,
> +			 USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> +			 ATP_WELLSPRING_MODE_REQUEST_VALUE,
> +			 ATP_WELLSPRING_MODE_REQUEST_INDEX, data, 8, 5000);
> +
> +  if (size != 8) {
> +    err("Could not do mode write request to device (Wellspring Raw mode)");
> +    return -EIO;
> +  }
> +
> +  return 0;
> +}
[..]
> +static inline int raw2int(unsigned char hi, unsigned char lo)
> +{
> +  return (short)(hi<<8)+lo;
> +}

Use the standard function.

[..]
> +static int atp_open(struct input_dev *input)
> +{
> +  struct atp *dev = input_get_drvdata(input);
> +
> +  if (usb_submit_urb(dev->bt_urb, GFP_ATOMIC))
> +    return -EIO;
> +
> +  if (usb_submit_urb(dev->tp_urb, GFP_ATOMIC))
> +    return -EIO;

Resource leak. You must kill the first urb if you bail out here.
> +
> +  dev->open = 1;
> +  return 0;
> +}
> +
> +static void atp_close(struct input_dev *input)
> +{
> +  struct atp *dev = input_get_drvdata(input);
> +
> +  usb_kill_urb(dev->tp_urb);
> +  usb_kill_urb(dev->bt_urb);
> +  cancel_work_sync(&dev->work);

I can't see where you use that work struct. Anyway, this is a race.
As the work handler can submit urbs, you must first cancel the work,
then kill the urbs.

> +  dev->open = 0;
> +}
> +
[..]
> +static void atp_disconnect(struct usb_interface *iface)
> +{
> +  struct atp *dev = usb_get_intfdata(iface);
> +
> +  usb_set_intfdata(iface, NULL);
> +  if (dev) {
> +    usb_kill_urb(dev->tp_urb);
> +    usb_kill_urb(dev->bt_urb);

close will do that. no need to kill here.
> +    input_unregister_device(dev->input);
> +    usb_buffer_free(dev->udev, dev->cfg.tp_datalen,
> +		    dev->tp_data, dev->tp_urb->transfer_dma);
> +    usb_buffer_free(dev->udev, dev->cfg.bt_datalen,
> +		    dev->bt_data, dev->bt_urb->transfer_dma);
> +    usb_free_urb(dev->tp_urb);
> +    usb_free_urb(dev->bt_urb);
> +    kfree(dev);
> +  }
> +  printk(KERN_INFO "input: bcm5974 disconnected\n");
> +}
> +
> +static int atp_suspend(struct usb_interface *iface, pm_message_t message)
> +{
> +  struct atp *dev = usb_get_intfdata(iface);
> +
> +  usb_kill_urb(dev->tp_urb);
> +  dev->tp_valid = 0;
> +
> +  usb_kill_urb(dev->bt_urb);
> +  dev->bt_valid = 0;

Why don't you cancel the work here?
