Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbZKRPZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbZKRPZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 10:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbZKRPZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 10:25:45 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:56534 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbZKRPZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 10:25:43 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v2] [RFC] NEXIO (or iNexio) support for usbtouchscreen
Date: Wed, 18 Nov 2009 16:25:46 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: linux-usb@vger.kernel.org, daniel.ritz@gmx.ch,
       linux-kernel@vger.kernel.org
References: <200911161515.00907.linux@rainbow-software.org> <200911171625.34696.oliver@neukum.org> <200911181318.45208.linux@rainbow-software.org>
In-Reply-To: <200911181318.45208.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181625.46983.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 18. November 2009 13:18:43 schrieb Ondrej Zary:

> > > +	/* send init command */
> > > +	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, NEXIO_OUTPUT_EP), init,
> > > +			   sizeof(init), &actual_len, NEXIO_TIMEOUT);
> >
> > DMA on the kernel stack
> 
> I don't know any details about this - what's the correct way to do this?

You must kmalloc the buffer.

> I tried moving the init[] array outside the function but that didn't work
>  at all - compiled fine but device was not reporting the name firmware
>  version. I ended up with copying it to that kmalloced buf.

That's correct.

> 
> I'm worried about nexio_ack - that shouldn't work too then. Maybe it really
> does not and the device does not care.

It works on some architectures. But it is still buggy.

> I also found another problem: when I disconnect the USB cable, kernel
>  oopses: BUG: unable to handle kernel NULL pointer dereference
> IP: [<f7c794fa>] start_unlink_async+0x63/0xfc
> 
> Call Trace:
> ehci_urb_dequeue+0x7c/0x11a [ehci_hcd]
> unlink1+0xaa/0xc7 [usbcore]
> usb_hcd_unlink_urb+0x57/0x84 [usbcore]
> usb_kill_urb+0x40/0xbe [usbcore]
> default_wake_function+0x0/0x2b
> usb_start_wait_urb+0x6e/0xb0 [usbcore]
> usb_control_msg+0x10a/0x136 [usbcore]
> hub_port_status+0x77/0xf7 [usbcore]
> hub_thread+0x56d/0xe14 [usbcore]
> autoremove_wake_function+0x0/0x4f
> hub_thread+0x0/0xe14 [usbcore]
> kthread+0x7a/0x7f
> kthread+0x0/0x7f
> 
> Are there any other problems with my code that can cause this oops?

Odd.

> +	/* read firmware version */
> +	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
> +			   NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
> +	if (ret < 0)
> +		goto err_out;
> +	buf[buf[1]] = 0;	/* second byte is data(string) length */

You'd better check buf[1] for sanity.

> +	firmware_ver = kstrdup(&buf[2], GFP_KERNEL);

Are you sure this is safe?

> +	/* read device name */
> +	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP), buf,
> +			   NEXIO_BUFSIZE, &actual_len, NEXIO_TIMEOUT);
> +	if (ret < 0) {
> +		kfree(firmware_ver);
> +		goto err_out;
> +	}
> +	buf[buf[1]] = 0;
> +	printk(KERN_INFO "Nexio device: %s, firmware version %s\n",
> +	       &buf[2], firmware_ver);
> +	kfree(firmware_ver);
> +
> +	/* prepare ACK URB */
> +	usbtouch->ack = usb_alloc_urb(0, GFP_KERNEL);
> +	if (!usbtouch->ack) {
> +		dbg("%s - usb_alloc_urb failed: ack_urb", __func__);
> +		return 0;

Are you sure this shouldn't error out?

> +	}
> +	usb_fill_bulk_urb(usbtouch->ack, usbtouch->udev,
> +			  usb_sndbulkpipe(usbtouch->udev, NEXIO_OUTPUT_EP),
> +			  nexio_ack_pkt, sizeof(nexio_ack_pkt), NULL,

DMA on the heap.

> +			  usbtouch);
> +	/* submit first IRQ URB */
> +	ret = usb_submit_urb(usbtouch->irq, GFP_KERNEL);
> +err_out:
> +	kfree(buf);
> +err_nobuf:
> +	return ret;
> +}
> +
> +static int nexio_read_data(struct usbtouch_usb *usbtouch, unsigned char
>  *pkt) +{
> +	int x, y, begin_x, begin_y, end_x, end_y, w, h, ret;
> +	struct nexio_touch_packet *packet = (void *) pkt;
> +
> +	/* got touch data? */
> +	if ((pkt[0] & 0xe0) != 0xe0)
> +		return 0;
> +
> +	/* send ACK */
> +	ret = usb_submit_urb(usbtouch->ack, GFP_KERNEL);

In interrupt context. You must use GFP_ATOMIC.

> +
> +	if (!usbtouch->type->max_xc) {
> +		usbtouch->type->max_xc = 2 * be16_to_cpu(packet->x_len);
> +		input_set_abs_params(usbtouch->input, ABS_X, 0,
> +				     2 * be16_to_cpu(packet->x_len), 0, 0);
> +		usbtouch->type->max_yc = 2 * be16_to_cpu(packet->y_len);
> +		input_set_abs_params(usbtouch->input, ABS_Y, 0,
> +				     2 * be16_to_cpu(packet->y_len), 0, 0);
> +	}
> +	/* The device reports state of IR sensors on X and Y axes.
> +	 * Each byte represents "darkness" percentage (0-100) of one element.
> +	 * 17" touchscreen reports only 64 x 52 bytes so the resolution is low.
> +	 * This also means that there's a limited multi-touch capability but
> +	 * it's disabled (and untested) here as there's no X driver for that.
> +	 */
> +	begin_x = end_x = begin_y = end_y = -1;
> +	for (x = 0; x < be16_to_cpu(packet->x_len); x++) {
> +		if (begin_x == -1 && packet->data[x] > NEXIO_THRESHOLD) {
> +			begin_x = x;
> +			continue;
> +		}
> +		if (end_x == -1 && begin_x != -1 && packet->data[x] < NEXIO_THRESHOLD) {
> +			end_x = x - 1;
> +			for (y = be16_to_cpu(packet->x_len);
> +			     y < be16_to_cpu(packet->data_len); y++) {
> +				if (begin_y == -1 && packet->data[y] > NEXIO_THRESHOLD) {
> +					begin_y = y - be16_to_cpu(packet->x_len);
> +					continue;
> +				}
> +				if (end_y == -1 &&
> +				    begin_y != -1 && packet->data[y] < NEXIO_THRESHOLD) {
> +					end_y = y - 1 - be16_to_cpu(packet->x_len);
> +					w = end_x - begin_x;
> +					h = end_y - begin_y;
> +					/* multi-touch */
> +/*					input_report_abs(usbtouch->input,
> +						    ABS_MT_TOUCH_MAJOR, max(w,h));
> +					input_report_abs(usbtouch->input,
> +						    ABS_MT_TOUCH_MINOR, min(x,h));
> +					input_report_abs(usbtouch->input,
> +						    ABS_MT_POSITION_X, 2*begin_x+w);
> +					input_report_abs(usbtouch->input,
> +						    ABS_MT_POSITION_Y, 2*begin_y+h);
> +					input_report_abs(usbtouch->input,
> +						    ABS_MT_ORIENTATION, w > h);
> +					input_mt_sync(usbtouch->input);*/
> +					/* single touch */
> +					usbtouch->x = 2 * begin_x + w;
> +					usbtouch->y = 2 * begin_y + h;
> +					usbtouch->touch = packet->flags & 0x01;
> +					begin_y = end_y = -1;
> +					return 1;
> +				}
> +			}
> +			begin_x = end_x = -1;
> +		}
> +
> +	}
> +	return 0;
> +}
> +#endif
> +

> @@ -1007,8 +1198,10 @@ static void usbtouch_disconnect(struct u
>  	dbg("%s - usbtouch is initialized, cleaning up", __func__);
>  	usb_set_intfdata(intf, NULL);
>  	usb_kill_urb(usbtouch->irq);
> +	usb_kill_urb(usbtouch->ack);

Have you checked the order is correct?

>  	input_unregister_device(usbtouch->input);
>  	usb_free_urb(usbtouch->irq);
> +	usb_free_urb(usbtouch->ack);
>  	usbtouch_free_buffers(interface_to_usbdev(intf), usbtouch);
>  	kfree(usbtouch);
>  }
> 

	Regards
		Oliver

