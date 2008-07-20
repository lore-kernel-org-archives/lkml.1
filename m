Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbYGTFKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbYGTFKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 01:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYGTFK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 01:10:28 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:16531 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYGTFK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 01:10:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xfwe4xa0BsCPjKAQfjGk2/grEJLtrU9ur2qn6Ky1rvaJqCNIrcLeFWWhBLWg6WlcfQ
         Yx2o4vwS09Y0PFLstjuSZr6fix/IwwwdUXZWM2MhkawOV5alzVoYsdIecWxV5FuGGMq5
         p6+a4+joo1hgY5IDm+OFJh3BcGuS1ZXsAGc0E=
Date: Sun, 20 Jul 2008 01:10:16 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       robfitz@273k.net, akpm@osdl.org, jikos@jikos.cz, vojtech@suse.cz,
       dmonakhov@openvz.org, johannes@sipsolutions.net
Subject: Re: [PATCH] linux-input: bcm5974-0.57: mode-switch to atp_open,
	cleanup bug fixed
Message-ID: <20080720051016.GA7853@anvil.corenet.prv>
References: <1216466049.6238.0.camel@alnilam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216466049.6238.0.camel@alnilam>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Sat, Jul 19, 2008 at 01:03:28PM +0200, Henrik Rydberg wrote:
> From: Henrik Rydberg <rydberg@euromail.se>
> 
> BCM5974: This driver adds support for the multitouch trackpad on the new
> Apple Macbook Air and Macbook Pro Penryn laptops. It replaces the
> appletouch driver on those computers, and integrates well with the
> synaptics driver of the Xorg system. 
> 

The driver looks pretty good by now, just a few comments from me...

> +
> +	if (report_tp_state(dev, dev->tp_urb->actual_length)) {
> +		dprintk(1, "bcm5974: bad trackpad package, length: %d\n",
> +			dev->tp_urb->actual_length);
> +		goto exit;
> +	}
> +
> +	input_sync(dev->input);

I'd rather had input_sync right in the report_tp_state, where the event
set is generated.

> +
> +exit:
> +	error = usb_submit_urb(dev->tp_urb, GFP_ATOMIC);
> +	if (error)
> +		err("bcm5974: trackpad urb failed: %d", error);
> +}
> +
> +/*
> + * The Wellspring trackpad, like many recent Apple trackpads, share
> + * the usb device with the keyboard. Since keyboards are usually
> + * handled by the HID system, the device ends up being handled by two
> + * modules. Setting up the device therefore becomes slightly
> + * complicated. To enable multitouch features, a mode switch is
> + * required, which is usually applied via the control interface of the
> + * device.  It can be argued where this switch should take place. In
> + * some drivers, like appletouch, the switch is made during
> + * probe. However, the hid module may also alter the state of the
> + * device, resulting in trackpad malfunction under certain
> + * circumstances. To get around this problem, there is at least one
> + * example that utilizes the USB_QUIRK_RESET_RESUME quirk in order to
> + * recieve a reset_resume request rather than the normal resume. Since
> + * the implementation of reset_resume is equal to mode switch plus
> + * open, it seems easier to always do the switch while opening the
> + * device.
> + */

What will happen if bcm driver is attached first, before HID had a
chance to do its part?

> +static int atp_open(struct input_dev *input)
> +{
> +	struct atp *dev = input_get_drvdata(input);
> +
> +	if (!dev->open) {
> +		if (atp_wellspring_mode(dev)) {
> +			dprintk(1, "bcm5974: mode switch failed\n");
> +			goto error;
> +		}
> +		if (usb_submit_urb(dev->bt_urb, GFP_KERNEL))
> +			goto error;
> +		if (usb_submit_urb(dev->tp_urb, GFP_KERNEL))
> +			goto err_kill_bt;
> +	}
> +
> +	dev->open = 1;
> +	dev->suspended = 0;
> +	return 0;
> +
> +err_kill_bt:
> +	usb_kill_urb(dev->bt_urb);
> +error:
> +	return -EIO;
> +}
> +
> +static void atp_close(struct input_dev *input)
> +{
> +	struct atp *dev = input_get_drvdata(input);
> +
> +	usb_kill_urb(dev->tp_urb);
> +	usb_kill_urb(dev->bt_urb);
> +
> +	dev->open = 0;
> +	dev->suspended = 0;
> +}
> +

[...skipped...]

> +
> +static void atp_disconnect(struct usb_interface *iface)
> +{
> +	struct atp *dev = usb_get_intfdata(iface);
> +
> +	usb_set_intfdata(iface, NULL);
> +
> +	if (dev) {

Is this check needed? How can intfdata be NULL and we still get into
this function?

> +		input_unregister_device(dev->input);
> +		usb_buffer_free(dev->udev, dev->cfg.tp_datalen,
> +			dev->tp_data, dev->tp_urb->transfer_dma);
> +		usb_buffer_free(dev->udev, dev->cfg.bt_datalen,
> +			dev->bt_data, dev->bt_urb->transfer_dma);
> +		usb_free_urb(dev->tp_urb);
> +		usb_free_urb(dev->bt_urb);
> +		kfree(dev);
> +	}
> +
> +	printk(KERN_INFO "bcm5974: disconnected\n");
> +}
> +
> +static int atp_suspend(struct usb_interface *iface, pm_message_t message)
> +{
> +	struct atp *dev = usb_get_intfdata(iface);
> +
> +	if (dev) {
> +		if (!dev->suspended)
> +			atp_close(dev->input);
> +		dev->suspended++;
> +	}
> +
> +	return 0;
> +}
> +
> +static int atp_resume(struct usb_interface *iface)
> +{
> +	struct atp *dev = usb_get_intfdata(iface);
> +	int error = 0;
> +
> +	if (dev && dev->suspended) {
> +		if (!--dev->suspended)
> +			error = atp_open(dev->input);

This will cause us to sumit URBs and start reporting events even though
there may be no users of the device (if it was not opened by anyone)
which defeats the purpose of implementing open and close methods of the
input device. You may want to implent start/pause_traffic function and
use them in open/close and suspend/resume.

Also, you need to have a locking that would serialize suspend/resume
with regard to open/close.

And the last request - could we do s/atp_/bcm5974/g so we don't get
confused with the original atp driver?

-- 
Dmitry
