Return-Path: <linux-kernel-owner+w=401wt.eu-S1751090AbXFCSDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbXFCSDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbXFCSDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:03:05 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60373 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbXFCSDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:03:04 -0400
Date: Sun, 3 Jun 2007 20:02:57 +0200 (CEST)
From: Jan Kratochvil <honza@jikos.cz>
To: Richard Purdie <rpurdie@rpsys.net>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support for controlling leds on xbox 360 pad.
In-Reply-To: <alpine.LRH.0.98.0705302334580.22353@twin.jikos.cz>
Message-ID: <alpine.LRH.0.98.0706031959170.22353@twin.jikos.cz>
References: <alpine.LRH.0.98.0705292250430.22353@twin.jikos.cz> 
 <alpine.LRH.0.98.0705292312150.22353@twin.jikos.cz> 
 <1180474885.5822.94.camel@localhost.localdomain> 
 <d120d5000705300756t24d4a58ey1f4130bef22f8309@mail.gmail.com>
 <1180542740.5835.135.camel@localhost.localdomain>
 <alpine.LRH.0.98.0705302334580.22353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Jan Kratochvil wrote:
> Hi,
>> In ideal world having the code in drivers/leds would be preferred but if
>> you want to add the LED code directly to the input driver in this case I
>> have no objection and it probably makes sense. The LED code is already
>> spread about a bit anyway...
>
> I wasn't happy about having this splited in two subsystems either. So I'll 
> rewrite it to use led functionality directly from 
> drivers/input/joystick/xpad.c.
>
Hello,
  so I integrated this patch into xpad.c itself.

Xbox360 pad has four leds, which forms a circle. Unfortunately the leds 
itself are not independent, and we can't control them directle, but 
rather through sending commands which have predefined meaning (like turn 
first on, others off) This patch allows us to send these commands via 
leds subsystem. Commands itself are described here: 
http://www.free60.org/wiki/Gamepad.

Led subsystem allows us to set brightness, but there is nothing like brightness
on this device. So brightness is actually interpreted as the command (only
values between 0 and 14 are accepted).

So this patch uses led subystem in such way that it makes led in
/sys/class/leds/xpad[0-9][0-9]/ for each attached xbox 360 pad.

Signed-off-by: Jan Kratochvil <honza@jikos.cz>
---
  drivers/input/joystick/Kconfig |    7 ++
  drivers/input/joystick/xpad.c  |  134 ++++++++++++++++++++++++++++++++++++++-
  2 files changed, 137 insertions(+), 4 deletions(-)

diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index a15a923..2098ab6 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -274,4 +274,11 @@ config JOYSTICK_XPAD_FF
  	---help---
  	  Say Y here if you want to take advantage of xbox 360 rumble features.

+config JOYSTICK_XPAD_LEDS
+	bool "LED Support for Xbox360 controller 'BigX' LED"
+	depends on LEDS_CLASS && JOYSTICK_XPAD_FF
+	---help---
+	  This option enables support for the LED which surrounds the Big X on
+	  XBox 360 controller.
+
  endif
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index f3f2ade..4a51d6f 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -198,6 +198,7 @@ struct usb_xpad {
  	struct urb *irq_out;		/* urb for interrupt out report */
  	unsigned char *odata;		/* output data */
  	dma_addr_t odata_dma;
+	struct mutex odata_mutex;
  #endif

  	char phys[65];			/* physical device path */
@@ -418,6 +419,8 @@ static int xpad_init_ff(struct usb_inter
  	if (!xpad->odata)
  		goto fail1;

+	mutex_init(&xpad->odata_mutex);
+
  	xpad->irq_out = usb_alloc_urb(0, GFP_KERNEL);
  	if (!xpad->irq_out)
  		goto fail2;
@@ -463,6 +466,123 @@ static void xpad_stop_ff(struct usb_xpad
  static void xpad_deinit_ff(struct usb_xpad *xpad) { }
  #endif

+#if defined(CONFIG_JOYSTICK_XPAD_LEDS) 
+#include <linux/leds.h>
+
+struct xpad_led {
+	struct led_classdev     cdev;
+
+	unsigned int            id;
+	struct usb_xpad *       xpad;
+	struct list_head        node;
+};
+
+static LIST_HEAD(xpad_led_list);
+
+static void xpad_send_command(int command, struct usb_xpad *xpad)
+{
+	if (command >= 0 && command < 14) {
+		mutex_lock(&xpad->odata_mutex);
+		xpad->odata[0] = 0x01;
+		xpad->odata[1] = 0x03;
+		xpad->odata[2] = command;
+		usb_submit_urb(xpad->irq_out, GFP_KERNEL);
+		mutex_unlock(&xpad->odata_mutex);
+	}
+}
+
+static void xpad_led_set(struct led_classdev *led_cdev,
+	enum led_brightness value)
+{
+	struct xpad_led *led_dev =
+	container_of(led_cdev, struct xpad_led, cdev);
+
+	xpad_send_command(value, led_dev->xpad);
+}
+
+int xpad_led_probe(struct usb_xpad *xpad)
+{
+	int i = 0;
+	struct xpad_led *pos_led;
+	struct xpad_led *new_led;
+	int error = -ENOMEM;
+	char *name;
+
+	if (xpad->xtype != XTYPE_XBOX360)
+		return 0;
+
+	list_for_each_entry(pos_led, &xpad_led_list, node) {
+		if (pos_led->id == i)
+			i++;
+		else
+			break;
+	}
+
+	if (i > 99)
+		goto fail1;
+
+	new_led = kzalloc(sizeof(struct xpad_led), GFP_KERNEL);
+	if (!new_led)
+		goto fail1;
+
+	new_led->id = i;
+
+	name = kzalloc(sizeof(char)*7, GFP_KERNEL);
+	if (!name)
+		goto fail2;
+
+	strcpy(name, "xpad");
+	name[4] = '0' + i / 10;
+	name[5] = '0' + i % 10;
+	name[6] = 0;
+
+	new_led->cdev.name = name;
+	new_led->cdev.brightness_set = xpad_led_set;
+	new_led->xpad = xpad;
+
+	list_add_tail(&new_led->node, &pos_led->node);
+
+	if (led_classdev_register(&xpad->udev->dev, &new_led->cdev))
+		goto fail3;
+
+	xpad_send_command( (i % 4) + 2, xpad);
+
+	return 0;
+
+fail3:
+	kfree(new_led->cdev.name);
+fail2:
+	kfree(new_led);
+fail1:
+	return error;
+}
+
+int xpad_led_disconnect(struct usb_xpad *xpad)
+{
+	struct xpad_led *led;
+	struct list_head *pos, *tmp;
+
+	if (xpad->xtype != XTYPE_XBOX360)
+		return 0;
+
+	list_for_each_safe(pos, tmp, &xpad_led_list) {
+		led = list_entry(pos, struct xpad_led, node);
+		if (led->xpad == xpad) {
+			led_classdev_unregister(&led->cdev);
+			list_del(pos);
+			kfree(led->cdev.name);
+			kfree(led);
+			break;
+		}
+	}
+	return 0;
+}
+#else
+static int xpad_led_probe(struct usb_xpad *xpad) { return 0; }
+static int xpad_led_disconnect(struct usb_xpad *xpad) { return 0; }
+#endif
+
+
  static int xpad_open(struct input_dev *dev)
  {
  	struct usb_xpad *xpad = input_get_drvdata(dev);
@@ -575,6 +695,10 @@ static int xpad_probe(struct usb_interfa
  	if (error)
  		goto fail2;

+	error = xpad_led_probe(xpad);
+	if (error)
+		goto fail3;
+
  	ep_irq_in = &intf->cur_altsetting->endpoint[0].desc;
  	usb_fill_int_urb(xpad->irq_in, udev,
  			 usb_rcvintpipe(udev, ep_irq_in->bEndpointAddress),
@@ -585,14 +709,15 @@ static int xpad_probe(struct usb_interfa

  	error = input_register_device(xpad->dev);
  	if (error)
-		goto fail3;
+		goto fail4;

  	usb_set_intfdata(intf, xpad);
  	return 0;

- fail3:	usb_free_urb(xpad->irq_in);
- fail2:	usb_buffer_free(udev, XPAD_PKT_LEN, xpad->idata, xpad->idata_dma);
- fail1:	input_free_device(input_dev);
+fail4:	usb_free_urb(xpad->irq_in);
+fail3:	xpad_deinit_ff(xpad);
+fail2:	usb_buffer_free(udev, XPAD_PKT_LEN, xpad->idata, xpad->idata_dma);
+fail1:	input_free_device(input_dev);
  	kfree(xpad);
  	return error;

@@ -604,6 +729,7 @@ static void xpad_disconnect(struct usb_i

  	usb_set_intfdata(intf, NULL);
  	if (xpad) {
+		xpad_led_disconnect(xpad);
  		input_unregister_device(xpad->dev);
  		xpad_deinit_ff(xpad);
  		usb_free_urb(xpad->irq_in);
-- 
1.4.3.4

