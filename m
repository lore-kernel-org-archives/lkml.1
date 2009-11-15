Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbZKOIxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbZKOIxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 03:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZKOIxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 03:53:15 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:40321 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZKOIxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 03:53:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V+UNoOnlmDAxgdHAskXG3LahwnXsWo2LKhbjDQ+CKcNjxh0/wJdoiUzDs7pB3gxgBW
         S3s+49sZDC8IIyB8CZZPz+Xv8kHJM3CYN8SAxC1HNK4eV/y0m8lavTEMM5ooXk0dJkix
         eNNRKbt44AbCHrgWZadu/KrTcBJmmNNELuigE=
Date: Sun, 15 Nov 2009 00:53:14 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: [PATCH v2] ALPS: Add support for 4 directions button on Acer
	Aspire 5720
Message-ID: <20091115085314.GB9844@core.coreip.homeip.net>
References: <1256955018.9681.23.camel@maxim-laptop> <1257846940.4921.11.camel@maxim-laptop> <1257847427.4921.13.camel@maxim-laptop> <20091110173047.GC15263@core.coreip.homeip.net> <1257930590.3601.2.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257930590.3601.2.camel@maxim-laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxim,

On Wed, Nov 11, 2009 at 11:09:50AM +0200, Maxim Levitsky wrote:
> >From 6b263982ffd62ae4621a5202f0084983af8dc093 Mon Sep 17 00:00:00 2001
> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Date: Wed, 11 Nov 2009 11:03:35 +0200
> Subject: [PATCH] ALPS: Add support for 4 directions button on Acer Aspire 5720
>  Implemented using DMI due to uncertainty about systems that have
>  only the middle button
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

I don't think that we need to do DMI checking. I looked through my mails
and it looks like all Acers with that signature have 4-directional
button while Volstro 1400 only has left and right button and so won't be
affected. Also Synaptics driver treats BTN_0 as BTN_FORWARD and BTN_1
as BTN_BACK by default so we should still be compatible.

Could you please try the patch below? It assumes that psmosue core does
not set up BTN_MIDDLE capability ahead of time though (see a patch
posted earlier today).

-- 
Dmitry

Input: ALPS - add support for 4 directions button on Acer Aspire 5720

From: Maxim Levitsky <maximlevitsky@gmail.com>

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/mouse/alps.c |   61 ++++++++++++++++++++++++++++++--------------
 1 files changed, 42 insertions(+), 19 deletions(-)


diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index f361106..01d354f 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -28,13 +28,16 @@
 #define dbg(format, arg...) do {} while (0)
 #endif
 
-#define ALPS_DUALPOINT	0x01
-#define ALPS_WHEEL	0x02
-#define ALPS_FW_BK_1	0x04
-#define ALPS_4BTN	0x08
-#define ALPS_OLDPROTO	0x10
-#define ALPS_PASS	0x20
-#define ALPS_FW_BK_2	0x40
+
+#define ALPS_OLDPROTO		0x01	/* old style input */
+#define ALPS_DUALPOINT		0x02	/* touchpad has trackstick */
+#define ALPS_PASS		0x04	/* device has a pass-through port */
+
+#define ALPS_WHEEL		0x08	/* hardware wheel present */
+#define ALPS_FW_BK_1		0x10	/* front & back buttons present */
+#define ALPS_FW_BK_2		0x20	/* front & back buttons present */
+#define ALPS_FOUR_BUTTONS	0x40	/* 4 direction button present */
+
 
 static const struct alps_model_info alps_model_data[] = {
 	{ { 0x32, 0x02, 0x14 },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* Toshiba Salellite Pro M10 */
@@ -56,7 +59,7 @@ static const struct alps_model_info alps_model_data[] = {
 	{ { 0x22, 0x02, 0x0a },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT },
 	{ { 0x22, 0x02, 0x14 }, 0xff, 0xff, ALPS_PASS | ALPS_DUALPOINT }, /* Dell Latitude D600 */
 	{ { 0x62, 0x02, 0x14 }, 0xcf, 0xcf, ALPS_PASS | ALPS_DUALPOINT }, /* Dell Latitude E6500 */
-	{ { 0x73, 0x02, 0x50 }, 0xcf, 0xcf, ALPS_FW_BK_1 },		  /* Dell Vostro 1400 */
+	{ { 0x73, 0x02, 0x50 }, 0xcf, 0xcf, ALPS_FOUR_BUTTONS },	  /* Dell Vostro 1400 */
 };
 
 /*
@@ -83,6 +86,7 @@ static const struct alps_model_info alps_model_data[] = {
 static void alps_process_packet(struct psmouse *psmouse)
 {
 	struct alps_data *priv = psmouse->private;
+	const struct alps_model_info *model = priv->i;
 	unsigned char *packet = psmouse->packet;
 	struct input_dev *dev = psmouse->dev;
 	struct input_dev *dev2 = priv->dev2;
@@ -101,7 +105,7 @@ static void alps_process_packet(struct psmouse *psmouse)
 		return;
 	}
 
-	if (priv->i->flags & ALPS_OLDPROTO) {
+	if (model->flags & ALPS_OLDPROTO) {
 		left = packet[2] & 0x10;
 		right = packet[2] & 0x08;
 		middle = 0;
@@ -117,12 +121,12 @@ static void alps_process_packet(struct psmouse *psmouse)
 		z = packet[5];
 	}
 
-	if (priv->i->flags & ALPS_FW_BK_1) {
+	if (model->flags & ALPS_FW_BK_1) {
 		back = packet[0] & 0x10;
 		forward = packet[2] & 4;
 	}
 
-	if (priv->i->flags & ALPS_FW_BK_2) {
+	if (model->flags & ALPS_FW_BK_2) {
 		back = packet[3] & 4;
 		forward = packet[2] & 4;
 		if ((middle = forward && back))
@@ -132,7 +136,7 @@ static void alps_process_packet(struct psmouse *psmouse)
 	ges = packet[2] & 1;
 	fin = packet[2] & 2;
 
-	if ((priv->i->flags & ALPS_DUALPOINT) && z == 127) {
+	if ((model->flags & ALPS_DUALPOINT) && z == 127) {
 		input_report_rel(dev2, REL_X,  (x > 383 ? (x - 768) : x));
 		input_report_rel(dev2, REL_Y, -(y > 255 ? (y - 512) : y));
 
@@ -150,7 +154,8 @@ static void alps_process_packet(struct psmouse *psmouse)
 	input_report_key(dev, BTN_MIDDLE, middle);
 
 	/* Convert hardware tap to a reasonable Z value */
-	if (ges && !fin) z = 40;
+	if (ges && !fin)
+		z = 40;
 
 	/*
 	 * A "tap and drag" operation is reported by the hardware as a transition
@@ -166,8 +171,10 @@ static void alps_process_packet(struct psmouse *psmouse)
 	}
 	priv->prev_fin = fin;
 
-	if (z > 30) input_report_key(dev, BTN_TOUCH, 1);
-	if (z < 25) input_report_key(dev, BTN_TOUCH, 0);
+	if (z > 30)
+		input_report_key(dev, BTN_TOUCH, 1);
+	if (z < 25)
+		input_report_key(dev, BTN_TOUCH, 0);
 
 	if (z > 0) {
 		input_report_abs(dev, ABS_X, x);
@@ -177,14 +184,21 @@ static void alps_process_packet(struct psmouse *psmouse)
 	input_report_abs(dev, ABS_PRESSURE, z);
 	input_report_key(dev, BTN_TOOL_FINGER, z > 0);
 
-	if (priv->i->flags & ALPS_WHEEL)
+	if (model->flags & ALPS_WHEEL)
 		input_report_rel(dev, REL_WHEEL, ((packet[2] << 1) & 0x08) - ((packet[0] >> 4) & 0x07));
 
-	if (priv->i->flags & (ALPS_FW_BK_1 | ALPS_FW_BK_2)) {
+	if (model->flags & (ALPS_FW_BK_1 | ALPS_FW_BK_2)) {
 		input_report_key(dev, BTN_FORWARD, forward);
 		input_report_key(dev, BTN_BACK, back);
 	}
 
+	if (model->flags & ALPS_FOUR_BUTTONS) {
+		input_report_key(dev, BTN_0, packet[2] & 4);
+		input_report_key(dev, BTN_1, packet[0] & 0x10);
+		input_report_key(dev, BTN_2, packet[3] & 4);
+		input_report_key(dev, BTN_3, packet[0] & 0x20);
+	}
+
 	input_sync(dev);
 }
 
@@ -469,8 +483,8 @@ int alps_init(struct psmouse *psmouse)
 	dev1->evbit[BIT_WORD(EV_KEY)] |= BIT_MASK(EV_KEY);
 	dev1->keybit[BIT_WORD(BTN_TOUCH)] |= BIT_MASK(BTN_TOUCH);
 	dev1->keybit[BIT_WORD(BTN_TOOL_FINGER)] |= BIT_MASK(BTN_TOOL_FINGER);
-	dev1->keybit[BIT_WORD(BTN_LEFT)] |= BIT_MASK(BTN_LEFT) |
-		BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
+	dev1->keybit[BIT_WORD(BTN_LEFT)] |=
+		BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_RIGHT);
 
 	dev1->evbit[BIT_WORD(EV_ABS)] |= BIT_MASK(EV_ABS);
 	input_set_abs_params(dev1, ABS_X, 0, 1023, 0, 0);
@@ -487,6 +501,15 @@ int alps_init(struct psmouse *psmouse)
 		dev1->keybit[BIT_WORD(BTN_BACK)] |= BIT_MASK(BTN_BACK);
 	}
 
+	if (priv->i->flags & ALPS_FOUR_BUTTONS) {
+		dev1->keybit[BIT_WORD(BTN_0)] |= BIT_MASK(BTN_0);
+		dev1->keybit[BIT_WORD(BTN_1)] |= BIT_MASK(BTN_1);
+		dev1->keybit[BIT_WORD(BTN_2)] |= BIT_MASK(BTN_2);
+		dev1->keybit[BIT_WORD(BTN_3)] |= BIT_MASK(BTN_3);
+	} else {
+		dev1->keybit[BIT_WORD(BTN_MIDDLE)] |= BIT_MASK(BTN_MIDDLE);
+	}
+
 	snprintf(priv->phys, sizeof(priv->phys), "%s/input1", psmouse->ps2dev.serio->phys);
 	dev2->phys = priv->phys;
 	dev2->name = (priv->i->flags & ALPS_DUALPOINT) ? "DualPoint Stick" : "PS/2 Mouse";
