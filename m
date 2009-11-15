Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbZKOGUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbZKOGUi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 01:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZKOGUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 01:20:37 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:36232 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZKOGUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 01:20:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m/Rq6575Lf5q3nN/GQuDW+wLc55b3yIlF5nAoLZRk1edsilusrZpaJJ/Hmx/LnMdPZ
         5maLY5yGocipWHawF075LUMDiVCcTwjCT4UDk1RkfZC2HN0jYmi/7c6v6E1c+bvWk5UD
         GD1CyQktkPhNWyiTH/G9wM1fJ0s8/fO4gRI+g=
Date: Sat, 14 Nov 2009 22:20:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Three buttons reported on two-button touchpad
Message-ID: <20091115062036.GA9844@core.coreip.homeip.net>
References: <200911141551.14263.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911141551.14263.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

On Sat, Nov 14, 2009 at 03:51:10PM +0300, Andrey Borzenkov wrote:
> Kernel 2.6.31.x
> 
> dmesg:
> Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1c0b1, caps: 0xa04751/0x0
> 
> but /proc/bus/input/devices:
> 
> I: Bus=0011 Vendor=0002 Product=0007 Version=01b1
> N: Name="SynPS/2 Synaptics TouchPad"
> P: Phys=isa0060/serio1/input0
> S: Sysfs=/devices/platform/i8042/serio1/input/input15
> U: Uniq=
> H: Handlers=mouse1 event2
> B: EV=b
> B: KEY=420 70000 0 0 0 0
> B: ABS=11000003
> 
> So even when capabilities clear say only 2 buttons, driver claims there 
> are 3 of them.
> 
> The reason most likely is initialization sequence. 
> psmouse_switch_protocol() unconditionally sets supported buttons:
> 
>         input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
>         input_dev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
>                 BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
>         input_dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
> 
> before even starting hardware detection and knowing real capabilities. 
> Detection for specific hardware won't change it (possibly only extend).

Some of them do.

> 
> Is it OK to move button bits setting into ps2bare_detect()? This seems 
> to agree with comments in psmouse_extensions() as well:
> 
> /*
>  * Okay, all failed, we have a standard mouse here. The number of the 
> buttons
>  * is still a question, though. We assume 3.
>  */
> 
> All other detection routines seem to be setting those bits already.

Not all of them but yes, I think we should to this. DOes th patch below
work for you?

-- 
Dmitry

Input: psmouse - rework setting up BTN_MIDDLE capability

Do not start protocol detection assuming that middle mouse is present,
instead let individual protocols explicitely set this capability.
This fixes issue with Synaptics Touchpads pretending that they have
middle button when hardware clearly reports otherwise.

Reported-by: Andrey Borzenkov <arvidjaar@mail.ru>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/mouse/hgpk.c         |   13 ------------
 drivers/input/mouse/logips2pp.c    |    4 ++--
 drivers/input/mouse/psmouse-base.c |   38 ++++++++++++++++++++++++++----------
 drivers/input/mouse/sentelic.c     |    1 +
 drivers/input/mouse/trackpoint.c   |   13 ++++++++----
 5 files changed, 38 insertions(+), 31 deletions(-)


diff --git a/drivers/input/mouse/hgpk.c b/drivers/input/mouse/hgpk.c
index de1e553..b146237 100644
--- a/drivers/input/mouse/hgpk.c
+++ b/drivers/input/mouse/hgpk.c
@@ -430,19 +430,6 @@ static int hgpk_register(struct psmouse *psmouse)
 	struct input_dev *dev = psmouse->dev;
 	int err;
 
-	/* unset the things that psmouse-base sets which we don't have */
-	__clear_bit(BTN_MIDDLE, dev->keybit);
-
-	/* set the things we do have */
-	__set_bit(EV_KEY, dev->evbit);
-	__set_bit(EV_REL, dev->evbit);
-
-	__set_bit(REL_X, dev->relbit);
-	__set_bit(REL_Y, dev->relbit);
-
-	__set_bit(BTN_LEFT, dev->keybit);
-	__set_bit(BTN_RIGHT, dev->keybit);
-
 	/* register handlers */
 	psmouse->protocol_handler = hgpk_process_byte;
 	psmouse->poll = hgpk_poll;
diff --git a/drivers/input/mouse/logips2pp.c b/drivers/input/mouse/logips2pp.c
index ab5dc5f..543c240 100644
--- a/drivers/input/mouse/logips2pp.c
+++ b/drivers/input/mouse/logips2pp.c
@@ -404,8 +404,8 @@ int ps2pp_init(struct psmouse *psmouse, bool set_properties)
 			}
 		}
 
-		if (buttons < 3)
-			__clear_bit(BTN_MIDDLE, psmouse->dev->keybit);
+		if (buttons >= 3)
+			__set_bit(BTN_MIDDLE, psmouse->dev->keybit);
 
 		if (model_info)
 			ps2pp_set_model_properties(psmouse, model_info, use_ps2pp);
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 5bd6484..560d647 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -425,6 +425,7 @@ static int genius_detect(struct psmouse *psmouse, bool set_properties)
 		return -1;
 
 	if (set_properties) {
+		__set_bit(BTN_MIDDLE, psmouse->dev->keybit);
 		__set_bit(BTN_EXTRA, psmouse->dev->keybit);
 		__set_bit(BTN_SIDE, psmouse->dev->keybit);
 		__set_bit(REL_WHEEL, psmouse->dev->relbit);
@@ -460,8 +461,10 @@ static int intellimouse_detect(struct psmouse *psmouse, bool set_properties)
 		__set_bit(BTN_MIDDLE, psmouse->dev->keybit);
 		__set_bit(REL_WHEEL, psmouse->dev->relbit);
 
-		if (!psmouse->vendor) psmouse->vendor = "Generic";
-		if (!psmouse->name) psmouse->name = "Wheel Mouse";
+		if (!psmouse->vendor)
+			psmouse->vendor = "Generic";
+		if (!psmouse->name)
+			psmouse->name = "Wheel Mouse";
 		psmouse->pktsize = 4;
 	}
 
@@ -504,8 +507,10 @@ static int im_explorer_detect(struct psmouse *psmouse, bool set_properties)
 		__set_bit(BTN_SIDE, psmouse->dev->keybit);
 		__set_bit(BTN_EXTRA, psmouse->dev->keybit);
 
-		if (!psmouse->vendor) psmouse->vendor = "Generic";
-		if (!psmouse->name) psmouse->name = "Explorer Mouse";
+		if (!psmouse->vendor)
+			psmouse->vendor = "Generic";
+		if (!psmouse->name)
+			psmouse->name = "Explorer Mouse";
 		psmouse->pktsize = 4;
 	}
 
@@ -536,6 +541,7 @@ static int thinking_detect(struct psmouse *psmouse, bool set_properties)
 		return -1;
 
 	if (set_properties) {
+		__set_bit(BTN_MIDDLE, psmouse->dev->keybit);
 		__set_bit(BTN_EXTRA, psmouse->dev->keybit);
 
 		psmouse->vendor = "Kensington";
@@ -551,8 +557,16 @@ static int thinking_detect(struct psmouse *psmouse, bool set_properties)
 static int ps2bare_detect(struct psmouse *psmouse, bool set_properties)
 {
 	if (set_properties) {
-		if (!psmouse->vendor) psmouse->vendor = "Generic";
-		if (!psmouse->name) psmouse->name = "Mouse";
+		if (!psmouse->vendor)
+			psmouse->vendor = "Generic";
+		if (!psmouse->name)
+			psmouse->name = "Mouse";
+
+/*
+ * We have no way of figuring true number of buttons so let's
+ * assume that the device has 3.
+ */
+		__set_bit(BTN_MIDDLE, psmouse->dev->keybit);
 	}
 
 	return 0;
@@ -567,6 +581,8 @@ static int cortron_detect(struct psmouse *psmouse, bool set_properties)
 	if (set_properties) {
 		psmouse->vendor = "Cortron";
 		psmouse->name = "PS/2 Trackball";
+
+		__set_bit(BTN_MIDDLE, psmouse->dev->keybit);
 		__set_bit(BTN_SIDE, psmouse->dev->keybit);
 	}
 
@@ -1184,15 +1200,16 @@ static void psmouse_disconnect(struct serio *serio)
 	mutex_unlock(&psmouse_mutex);
 }
 
-static int psmouse_switch_protocol(struct psmouse *psmouse, const struct psmouse_protocol *proto)
+static int psmouse_switch_protocol(struct psmouse *psmouse,
+				   const struct psmouse_protocol *proto)
 {
 	struct input_dev *input_dev = psmouse->dev;
 
 	input_dev->dev.parent = &psmouse->ps2dev.serio->dev;
 
 	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
-	input_dev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
-		BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
+	input_dev->keybit[BIT_WORD(BTN_MOUSE)] =
+				BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_RIGHT);
 	input_dev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
 
 	psmouse->set_rate = psmouse_set_rate;
@@ -1209,8 +1226,7 @@ static int psmouse_switch_protocol(struct psmouse *psmouse, const struct psmouse
 			return -1;
 
 		psmouse->type = proto->type;
-	}
-	else
+	} else
 		psmouse->type = psmouse_extensions(psmouse,
 						   psmouse_max_proto, true);
 
diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index f84cbd9..77b9fd0 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -836,6 +836,7 @@ int fsp_init(struct psmouse *psmouse)
 	priv->flags |= FSPDRV_FLAG_EN_OPC;
 
 	/* Set up various supported input event bits */
+	__set_bit(BTN_MIDDLE, psmouse->dev->keybit);
 	__set_bit(BTN_BACK, psmouse->dev->keybit);
 	__set_bit(BTN_FORWARD, psmouse->dev->keybit);
 	__set_bit(REL_WHEEL, psmouse->dev->relbit);
diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
index e354362..63d4a67 100644
--- a/drivers/input/mouse/trackpoint.c
+++ b/drivers/input/mouse/trackpoint.c
@@ -284,7 +284,6 @@ static int trackpoint_reconnect(struct psmouse *psmouse)
 
 int trackpoint_detect(struct psmouse *psmouse, bool set_properties)
 {
-	struct trackpoint_data *priv;
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
 	unsigned char firmware_id;
 	unsigned char button_info;
@@ -301,8 +300,8 @@ int trackpoint_detect(struct psmouse *psmouse, bool set_properties)
 		button_info = 0;
 	}
 
-	psmouse->private = priv = kzalloc(sizeof(struct trackpoint_data), GFP_KERNEL);
-	if (!priv)
+	psmouse->private = kzalloc(sizeof(struct trackpoint_data), GFP_KERNEL);
+	if (!psmouse->private)
 		return -1;
 
 	psmouse->vendor = "IBM";
@@ -311,7 +310,10 @@ int trackpoint_detect(struct psmouse *psmouse, bool set_properties)
 	psmouse->reconnect = trackpoint_reconnect;
 	psmouse->disconnect = trackpoint_disconnect;
 
-	trackpoint_defaults(priv);
+	if ((button_info & 0x0f) >= 3)
+		__set_bit(BTN_MIDDLE, psmouse->dev->keybit);
+
+	trackpoint_defaults(psmouse->private);
 	trackpoint_sync(psmouse);
 
 	error = sysfs_create_group(&ps2dev->serio->dev.kobj, &trackpoint_attr_group);
@@ -319,7 +321,8 @@ int trackpoint_detect(struct psmouse *psmouse, bool set_properties)
 		printk(KERN_ERR
 			"trackpoint.c: failed to create sysfs attributes, error: %d\n",
 			error);
-		kfree(priv);
+		kfree(psmouse->private);
+		psmouse->private = NULL;
 		return -1;
 	}
 
