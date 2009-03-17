Return-Path: <linux-kernel-owner+w=401wt.eu-S1762467AbZCQCVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762467AbZCQCVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 22:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbZCQCVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 22:21:25 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:59414 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbZCQCVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 22:21:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DUhW3hXRjxo6bbHidmYCJs/vmA1+ingktFj53R5HEn+kac6vb/TTSg6ZveUWI9T1iL
         NK6jftlahz23z08K2OxHpqWG/UtACNQtIe/nnHTYnz72yMmzTfqQ/Y+iHviAP+tWUNNn
         1+FDzcy1bvUJ+Imt7s7GydTTOtxTU8iXUyh0U=
MIME-Version: 1.0
Date: Tue, 17 Mar 2009 03:21:18 +0100
Message-ID: <739e73230903161921u426f2c65gddbc089d25ba5d50@mail.gmail.com>
Subject: [PATCH] input/joystick: add driver fortius 1942
From: Peta Blaha <blahapeta@gmail.com>
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for Fortius 1942 device.

Signed-off-by: Petr Blaha <blahapeta@gmail.com>
---

--- a/drivers/input/joystick/fortius_1942.c.orig 1970-01-01
01:00:00.000000000 +0100
+++ b/drivers/input/joystick/fortius_1942.c 2009-03-17 03:17:01.000000000 +0100
@@ -0,0 +1,394 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ *
+ *
+ * Info.
+ * First unimpemented feature Heart Sensor.
+ * Use bit 12 and 14(beginning 0), maybe 13 also.Emmisions
+ * from computer affect measuring.
+ *
+ * Second is Active Brake
+ * Can be maybe used as force feedback. Problem is slowness in
+ * switching from state to state, its electric motor, it has delay can
+ * be fragile.
+ * Try it by changing BRAKE_POS from 0 to 10.
+ *
+ * Thirth unimpemented is sending 0x01, when pedal magnet meets frame sensor.
+ *
+ * Pedalling works fine. Your wheel can have other size tan mime. Feel free
+ * to change constant in usb_tfor_irq, when counting value of gasolina.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/usb/input.h>
+#include <linux/time.h>
+
+
+#define DRIVER_VERSION "v0.0.2"
+#define DRIVER_DESC    "USB Tacx Fortius 1942 driver"
+#define DRIVER_LICENSE "GPL"
+#define DRIVER_AUTHOR  "Petr Blaha <blahapeta@gmail.com>"
+
+
+/*Don't put here lesser values*/
+/*read*/
+#define BIT_IN_DEVICE_1942 64
+/*write*/
+#define BIT_OUT_DEVICE_1942 12
+/*read*/
+#define BULK_IN_INTERFACE_1942 82
+/*write*/
+#define BULK_OUT_INTERFACE_1942 02
+
+
+#define BRAKE_POS 2
+
+
+/*11 states of brake,in beginning active brake helps, later add
+difficulty to cycling.0x00 0x00 is neutral*/
+#define ARRAYINT { {0x4d, 0xf3}, {0xa7, 0xf9}, {0x00, 0x00}, {0x59, 0x06}, \
+{0xb3, 0x0c}, {0x0c, 0x13}, {0x66, 0x19}, {0xbf, 0x1f}, {0x18, 0x26}, {0x72, \
+0x2c}, {0xcb, 0x32} }
+
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE(DRIVER_LICENSE);
+
+ unsigned long difference = 0;
+ /*time measure*/
+ struct timeval time, time_before;
+ /*guessed fastest speed a man can possibly ride-incitating full
+ throttle*/
+ unsigned int fastest_wheel_rotate = 1000;
+ /*actual state of path reached in one cycle*/
+ unsigned int ride = 0, old_ride = 0;
+
+struct usb_tfor {
+ char name[128];
+ char phys[64];
+ struct usb_device *usbdev;
+ struct input_dev *input;
+
+ struct urb *irq;
+ unsigned char *data;
+ dma_addr_t idata_dma;
+
+ struct urb *out;
+ unsigned char *data_device;
+ dma_addr_t odata_dma;
+ /*brake position*/
+ unsigned int brake_pos;
+};
+
+static void tfor_disconnect(struct usb_interface *intf)
+{
+ struct usb_tfor *tfor = usb_get_intfdata(intf);
+
+ usb_set_intfdata(intf, NULL);
+ if (tfor) {
+  /*urb*/
+  usb_kill_urb(tfor->out);
+  usb_kill_urb(tfor->irq);
+  /*device*/
+  input_unregister_device(tfor->input);
+  /*urb*/
+  usb_free_urb(tfor->out);
+  usb_free_urb(tfor->irq);
+  /*buffer free*/
+  usb_buffer_free(interface_to_usbdev(intf), 10, tfor->data_device, \
+  tfor->odata_dma);
+  usb_buffer_free(interface_to_usbdev(intf), 10, tfor->data, \
+  tfor->idata_dma);
+  /*free memory*/
+  kfree(tfor);
+   }
+}
+
+static int usb_tfor_open(struct input_dev *dev)
+{
+ struct usb_tfor *tfor = input_get_drvdata(dev);
+ tfor->irq->dev = tfor->usbdev;
+ usb_submit_urb(tfor->irq, GFP_KERNEL);
+ tfor->out->dev = tfor->usbdev;
+ usb_submit_urb(tfor->out, GFP_KERNEL);
+
+ return 0;
+}
+
+static void usb_tfor_close(struct input_dev *dev)
+{
+ struct usb_tfor *tfor = input_get_drvdata(dev);
+ usb_kill_urb(tfor->irq);
+ usb_kill_urb(tfor->out);
+}
+
+static struct usb_device_id tfor_ids[] = {
+ { USB_DEVICE(0x3561, 0x1942), .driver_info = 0 },
+ { }
+};
+
+static void usb_tfor_out(struct urb *urb)
+{ struct usb_tfor *tfor = urb->context;
+ unsigned int brake_bits[11][2] = ARRAYINT;
+ int retval;
+ tfor->brake_pos = BRAKE_POS;
+ /*URB to device*/
+ /*constant*/
+ tfor->data_device[0] = 0x01;
+ /*constant*/
+ tfor->data_device[1] = 0x08;
+ /*constant*/
+ tfor->data_device[2] = 0x01;
+ /*constant*/
+ tfor->data_device[3] = 0x00;
+ /*brake_bits*/
+ tfor->data_device[4] = brake_bits[tfor->brake_pos][0];
+ /*brake_bits*/
+ tfor->data_device[5] = brake_bits[tfor->brake_pos][1];
+ /*0x01 is turn,when frame sensor meets pedal magnet,
+ i don't see reason for implementation, nor know how device knows it*/
+ tfor->data_device[6] = 0x00;
+ /*constant*/
+ tfor->data_device[7] = 0x00;
+ /*constant*/
+ tfor->data_device[8] = 0x02;
+ /*constant*/
+ tfor->data_device[9] = 0x52;
+ /*constant*/
+ tfor->data_device[10] = 0x10;
+ /*constant*/
+ tfor->data_device[11] = 0x04;
+
+
+ switch (urb->status) {
+ case 0:
+ /* success */
+ break;
+ case -ECONNRESET:
+ case -ENOENT:
+ case -ESHUTDOWN:
+ /* this urb is terminated, clean up */
+ dbg("%s - urb shutting down with status: %d", __func__, urb->status);
+ break;
+ default:
+    dbg("%s - nonzero urb status received: %d", __func__, urb->status);
+ }
+ retval = usb_submit_urb(urb, GFP_ATOMIC);
+ if (retval)
+ err("%s - usb_submit_urb failed with result %d",
+    __func__, retval);
+}
+
+static void usb_tfor_irq(struct urb *urb)
+{
+ struct usb_tfor *tfor = urb->context;
+ unsigned char *data = tfor->data;
+ struct input_dev *dev = tfor->input;
+ int status;
+ int gasolina;
+
+ switch (urb->status) {
+ case 0:
+ /* success */
+   break;
+ case -ECONNRESET:
+ case -ENOENT:
+ case -ESHUTDOWN:
+ /* ±this urb is terminated, clean up */
+ dbg("%s - urb shutting down with status: %d", __func__, \
+ urb->status);
+ return;
+ default:
+ dbg("%s - nonzero urb status received: %d", __func__, \
+ urb->status);
+ goto resubmit;
+ }
+
+ /*Get actual time*/
+ do_gettimeofday(&time);
+ /*Ride counter in velociped is small,avoid mistake here*/
+ if ((data[28]*255+data[29]) < ride)
+ ride = 0;
+ /*We get new data, set new val. of ride counter &time counter*/
+ if ((data[28]*255+data[29]) > ride) {
+ old_ride = ride;
+ ride = (data[28]*255+data[29]);
+ difference = \
+ ((time.tv_usec-time_before.tv_usec)\
+ +(time.tv_sec-time_before.tv_sec)*1000000);
+ do_gettimeofday(&time_before);
+ if (difference == 0)
+ dbg("Something is not good \n");
+ }
+ /*Prevent division by 0*/
+ if (difference != 0)
+ /*"speed=path/time",change constant 1000
+   to naturalize it for your speed*/
+ gasolina = (ride-old_ride)/(difference/1000);
+ else
+ gasolina = 0;
+ input_report_abs(dev, ABS_GAS, gasolina);
+ input_report_key(dev, BTN_RIGHT,   data[13] & 0x01);
+ input_report_key(dev, BTN_BACK, data[13] & 0x02);
+ input_report_key(dev, BTN_FORWARD, data[13] & 0x04);
+ input_report_key(dev, BTN_LEFT, data[13] & 0x08);
+ input_report_abs(dev, ABS_WHEEL, (((data[18]+((data[19] & 0x0f)*225))-\
+ (689+170))*-1));
+
+ /* event termination */
+ input_sync(dev);
+
+resubmit:
+ status = usb_submit_urb(urb, GFP_ATOMIC);
+ if (status)
+ err("can't resubmit intr, %s-%s/input0, status %d",
+ tfor->usbdev->bus->bus_name, tfor->usbdev->devpath, status);
+
+}
+
+static int tfor_probe(struct usb_interface *intf, const struct
usb_device_id *id)
+{
+ struct usb_device *dev = interface_to_usbdev(intf);
+ struct usb_tfor *tfor;
+ struct input_dev *input_dev;
+ unsigned int err = -ENOMEM;
+
+
+ tfor = kzalloc(sizeof(struct usb_tfor), GFP_KERNEL);
+
+ input_dev = input_allocate_device();
+ if (!tfor || !input_dev) {
+ err = -ENOMEM;
+ goto fail1;
+ }
+ /*initilization of time counter*/
+ do_gettimeofday(&time);
+ time_before.tv_usec = time.tv_usec;
+ time_before.tv_sec = time.tv_sec;
+
+ tfor->data = usb_buffer_alloc(dev, BIT_IN_DEVICE_1942, GFP_KERNEL, \
+ &tfor->idata_dma);
+ if (!tfor->data) {
+ err = -ENOMEM;
+ goto fail1;
+ }
+
+ tfor->data_device = usb_buffer_alloc(dev, BIT_OUT_DEVICE_1942, \
+ GFP_KERNEL, &tfor->odata_dma);
+ if (!tfor->data_device) {
+ err = -ENOMEM;
+ goto fail1;
+ }
+
+ tfor->irq = usb_alloc_urb(0, GFP_KERNEL);
+ if (!tfor->irq) {
+ err = -ENOMEM;
+ goto fail2;
+ }
+
+ tfor->out = usb_alloc_urb(0, GFP_KERNEL);
+ if (!tfor->irq) {
+ err = -ENOMEM;
+ goto fail3;
+ }
+
+ tfor->usbdev = dev;
+ tfor->input = input_dev;
+
+ usb_make_path(dev, tfor->phys, sizeof(tfor->phys));
+ strlcat(tfor->phys, "/input0", sizeof(tfor->phys));
+
+ input_dev->name = "Tacx Fortius 1942";
+ input_dev->phys = tfor->phys;
+ usb_to_input_id(dev, &input_dev->id);
+ input_dev->dev.parent = &intf->dev;
+ input_set_drvdata(input_dev, tfor);
+ input_dev->open = usb_tfor_open;
+ input_dev->close = usb_tfor_close;
+ input_dev->evbit[0] = BIT_MASK(EV_ABS) | BIT_MASK(EV_KEY);
+ /*handlebar*/
+ input_set_abs_params(input_dev, ABS_WHEEL, -170, 170, 0, 20);
+ /*plyn*/
+ input_set_abs_params(input_dev, ABS_GAS, 0, 40, 2, 0);
+ /*buttons*/
+ set_bit(BTN_LEFT, input_dev->keybit);
+ set_bit(BTN_RIGHT, input_dev->keybit);
+ set_bit(BTN_FORWARD, input_dev->keybit);
+ set_bit(BTN_BACK, input_dev->keybit);
+
+ usb_fill_bulk_urb(tfor->irq, dev, usb_rcvbulkpipe(dev, \
+ BULK_IN_INTERFACE_1942), tfor->data, BIT_IN_DEVICE_1942, \
+ usb_tfor_irq, tfor);
+ tfor->irq->transfer_dma = tfor->idata_dma;
+ tfor->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+ /*
+ * urb sends data to machine
+ */
+
+ usb_fill_bulk_urb(tfor->out, dev, usb_sndbulkpipe(dev, \
+ BULK_OUT_INTERFACE_1942), tfor->data_device, BIT_OUT_DEVICE_1942, \
+ usb_tfor_out, tfor);
+ tfor->out->transfer_dma = tfor->odata_dma;
+ tfor->out->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+ err = input_register_device(tfor->input);
+ if (err)
+ goto fail2;
+
+ usb_set_intfdata(intf, tfor);
+
+ return 0;
+
+ fail3: usb_buffer_free(dev, BIT_OUT_DEVICE_1942, tfor->data_device, \
+ tfor->odata_dma);
+ fail2: usb_buffer_free(dev, BIT_IN_DEVICE_1942, tfor->data, tfor->idata_dma);
+ fail1: input_free_device(input_dev);
+ kfree(tfor);
+ return err;
+}
+
+static struct usb_driver tfor_driver = {
+ .name = "fortius_1942",
+ .probe = tfor_probe,
+ .disconnect = tfor_disconnect,
+ .id_table = tfor_ids,
+};
+
+static int __init tfor_init(void)
+{
+ int retval;
+ retval = usb_register(&tfor_driver);
+ if (retval)
+ goto out;
+ printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":" \
+ DRIVER_DESC "\n");
+out:
+ return retval;
+}
+
+static void __exit tfor_exit(void)
+{
+ usb_deregister(&tfor_driver);
+}
+
+module_init(tfor_init);
+module_exit(tfor_exit);
