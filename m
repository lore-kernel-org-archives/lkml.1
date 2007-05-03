Return-Path: <linux-kernel-owner+w=401wt.eu-S2992478AbXECVlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992478AbXECVlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993187AbXECVli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:41:38 -0400
Received: from twin.jikos.cz ([213.151.79.26]:52666 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992478AbXECVlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:41:37 -0400
Date: Thu, 3 May 2007 23:41:16 +0200 (CEST)
From: Jan Kratochvil <honza@jikos.cz>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3/3] xpad.c: Added Xbox360 gamepad rumble support.
In-Reply-To: <alpine.LRH.0.98.0705031504280.22353@twin.jikos.cz>
Message-ID: <alpine.LRH.0.98.0705032326440.22353@twin.jikos.cz>
References: <Pine.LNX.4.64.0705021704180.13550@twin.jikos.cz>
 <alpine.LRH.0.98.0705031504280.22353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,
   what do you think about this? (This patch will work only against last 
gamepad rumble support patch)

Thanks for your time
 	Jan Kratochvil

BigX button on xbox360 gamepad is surrounded by 4 green leds. This
patch adds support to control them.

This device understand to 14 messages (described at 
http://www.free60.org/wiki/Gamepad#LED_Control).

Control is done through event interface, message type EV_LED. EV_LED isn't 
perfect match because you are actualy not turning some led on or off but 
more likely you are telling the gamepad what "flash effect" it should 
play.

Signed-off-by: Jan Kratochvil <honza@jikos.cz>
---
  drivers/usb/input/xpad.c |   31 ++++++++++++++++++++++++++++---
  1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/input/xpad.c b/drivers/usb/input/xpad.c
index d117e71..8b38990 100644
--- a/drivers/usb/input/xpad.c
+++ b/drivers/usb/input/xpad.c
@@ -397,13 +397,33 @@ int xpad_play_effect(struct input_dev *d
  	return 0;
  }

+int xpad_input_event(struct input_dev *dev, unsigned int type,
+		     unsigned int code, int value)
+{
+	switch (type) {
+	case EV_FF:
+		return input_ff_event(dev,type,code,value);
+	case EV_LED: {
+		struct usb_xpad *xpad = dev->private;
+		change_bit(code,dev->led);
+		xpad->odata[0] = 0x01;
+		xpad->odata[1] = 0x03;
+		xpad->odata[2] = code;
+		usb_submit_urb(xpad->irq_out, GFP_KERNEL);
+		return 0;
+	}
+	default:
+		return -EINVAL;
+	}
+}
+
  static int xpad_init_ff(struct usb_interface *intf, struct usb_xpad *xpad)
  {
  	if (xpad->xtype == TYPE_XBOX360) {
  		struct usb_endpoint_descriptor *ep_irq_out;
-		int rv;
+		int i;

-		xpad->dev->evbit[0] |= BIT(EV_FF);
+		xpad->dev->evbit[0] |= BIT(EV_FF) | BIT(EV_LED);

  		xpad->odata = usb_buffer_alloc(xpad->udev, XPAD_PKT_LEN,
  					       GFP_ATOMIC, &xpad->odata_dma );
@@ -422,11 +442,16 @@ static int xpad_init_ff(struct usb_inter
  		xpad->irq_out->transfer_dma = xpad->odata_dma;
  		xpad->irq_out->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;

-		set_bit( FF_RUMBLE, xpad->dev->ffbit );
+		set_bit(FF_RUMBLE, xpad->dev->ffbit);
+		for (i=0;i<16;++i)
+			set_bit(i, xpad->dev->ledbit);
+
  		if (input_ff_create_memless(xpad->dev, NULL, xpad_play_effect)) {
  			goto fail2;
  		}

+		xpad->dev->event = xpad_input_event;
+
  		return 0;

  fail2:		usb_buffer_free(xpad->udev, XPAD_PKT_LEN, xpad->odata, xpad->odata_dma);
-- 
1.4.3.4



