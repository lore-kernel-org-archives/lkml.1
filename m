Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbZLOIZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbZLOIZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZLOIZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:25:24 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:53605 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbZLOIZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:25:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j+dbP77bX32TiQmciqNg+N7ODgpu54Qc+0RcqHITKYZaDhmUMiA/1ASFYUce/rW3Bm
         HGGPaqwzoWzHon/H+ALSSvxvOScJSfraGD8kBgdXrCxKH5hy1qkjAfHuknWABHjh4kXA
         zv6giZJEPbApOEkAOiUJg8Y0JiOrq/Z7wtcKE=
Date: Tue, 15 Dec 2009 00:25:18 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Alex Chiang <achiang@hp.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: synaptics touchpad doesn't click
Message-ID: <20091215082518.GD12669@core.coreip.homeip.net>
References: <20091214014828.GA28402@ldl.fc.hp.com> <20091214173450.GB2373@core.coreip.homeip.net> <20091215034127.GC587@ldl.fc.hp.com> <20091215062628.GA12669@core.coreip.homeip.net> <s5h1viwn3ig.wl%tiwai@suse.de> <20091215073358.GC12669@core.coreip.homeip.net> <s5hvdg8lm5q.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hvdg8lm5q.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 08:41:05AM +0100, Takashi Iwai wrote:
> At Mon, 14 Dec 2009 23:33:58 -0800,
> Dmitry Torokhov wrote:
> > 
> > On Tue, Dec 15, 2009 at 07:40:55AM +0100, Takashi Iwai wrote:
> > > At Mon, 14 Dec 2009 22:26:28 -0800,
> > > Dmitry Torokhov wrote:
> > > > 
> > > > [1  <text/plain; us-ascii (7bit)>]
> > > > Hi Alex,
> > > > 
> > > > On Mon, Dec 14, 2009 at 08:41:27PM -0700, Alex Chiang wrote:
> > > > > 
> > > > > Thanks, I did grab Takashi's patches and verify that they work
> > > > > for me. I tested the separated patches, not the v2 combined
> > > > > patch, although it doesn't make any difference based on visual
> > > > > inspection of v2.
> > > > > 
> > > > > If you want, you can add my:
> > > > > 
> > > > > Tested-by: Alex Chiang <achiang@hp.com>
> > > > 
> > > > Thank you very much for testing, however could you please try a slightly
> > > > different patch below (I did not quite like that the original patch
> > > > mangled device's capability field and how it was reusing 'middle' field
> > > > for different things)? It should apply on top of patch that
> > > > I am attaching. I hope I did not screw it up too much,
> > > 
> > > I can't test the patch right now since I'm at home, but I'm afraid
> > > it's a bit different behavior.  Namely,
> > > 
> > > > @@ -330,20 +339,52 @@ static void synaptics_parse_new_hw(unsigned char buf[],
> > > >  				   struct synaptics_data *priv,
> > > >  				   struct synaptics_hw_state *hw)
> > > >  {
> > > > -	hw->x = (((buf[3] & 0x10) << 8) | ((buf[1] & 0x0f) << 8) | buf[4]);
> > > > -	hw->y = (((buf[3] & 0x20) << 7) | ((buf[1] & 0xf0) << 4) | buf[5]);
> > > > +	int x = (((buf[3] & 0x10) << 8) | ((buf[1] & 0x0f) << 8) | buf[4]);
> > > > +	int y = (((buf[3] & 0x20) << 7) | ((buf[1] & 0xf0) << 4) | buf[5]);
> > > >  
> > > >  	hw->z = buf[2];
> > > >  	hw->w = (((buf[0] & 0x30) >> 2) |
> > > >  		 ((buf[0] & 0x04) >> 1) |
> > > >  		 ((buf[3] & 0x04) >> 2));
> > > >  
> > > > -	hw->left  = buf[0] & 0x01;
> > > > -	hw->right = buf[0] & 0x02;
> > > > +	if (SYN_CAP_CLICKPAD(priv->ext_cap)) {
> > > > +		int click = (buf[0] ^ buf[3]) & 0x01;
> > > > +
> > > > +		if (click && y < YMIN_NOMINAL) {
> > > > +			/*
> > > > +			 * User pressed in ClickZone; report new button
> > > > +			 * state but use old coordinates and don't report
> > > > +			 * any pressure to prevent pointer movement.
> > > > +			 */
> > > > +			hw->left = x < CLICKPAD_LEFT_BTN_X;
> > > > +			hw->right = x > CLICKPAD_RIGHT_BTN_X;
> > > > +			hw->middle = x >= CLICKPAD_LEFT_BTN_X &&
> > > > +				     x <= CLICKPAD_RIGHT_BTN_X;
> > > > +			hw->z = 0;
> > > > +
> > > > +		} else {
> > > > +			/*
> > > > +			 * Finger is outside of the ClickZone - report
> > > > +			 * current coordinates.
> > > > +			 */
> > > > +			hw->x = x;
> > > > +			hw->y = y;
> > > > +
> > > > +			if (!click)
> > > > +				hw->left = hw->right = hw->middle = 0;
> > > > +		}
> > > 
> > > Here, when you touch outside the button area, left/right/middle are
> > > always zero because hw was initialized.  So the above code gives the
> > > click "released" state outside the button area.
> > > 
> > 
> > No, I got rid of resetting hw state to 0.
> 
> Ah, it's in the second patch.
> 
> But looking at that one, hw is a local variable and still doesn't
> inherit from the previous state, no?  If so, the button state will be
> just a random value.
> 

Indeed, we need to keep the state in synaptics now, thanks for noticing.
The updated patch is below.

-- 
Dmitry


Input: synaptics - add support for ClickPad devices

From: Takashi Iwai <tiwai@suse.de>

The new device is a button-less "clickable" touchpad, the touchpad click
is signaled the same way middle button click is signalled on touchpads
that have SYN_CAP_MIDDLE_BUTTON capability.

The touchpad will be working in what Synaptics calls "ClickZone" mode
where left, right and middle buttons are emulated as clicks in the
bottom button zone, depending on the touch position.  Dragging can be
done by keeping the button down and touching the main area again.
Unfortunately the device does not signal clicks when main area is
touched first.

Due to the fact that there is no known capability bits for ClickPads we
are forced to match on product ID.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/mouse/synaptics.c |  119 +++++++++++++++++++++++++++------------
 drivers/input/mouse/synaptics.h |    5 +-
 2 files changed, 86 insertions(+), 38 deletions(-)


diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 7047558..34df70f 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -41,6 +41,15 @@
 #define YMIN_NOMINAL 1408
 #define YMAX_NOMINAL 4448
 
+/*
+ * Left and right ClickPad button ranges; the gap between them is reserved
+ * for middle button.
+ */
+#define CLICKPAD_LEFT_BTN_X \
+	((XMAX_NOMINAL - XMIN_NOMINAL) * 2 / 5 + XMIN_NOMINAL)
+#define CLICKPAD_RIGHT_BTN_X \
+	((XMAX_NOMINAL - XMIN_NOMINAL) * 3 / 5 + XMIN_NOMINAL)
+
 
 /*****************************************************************************
  *	Stuff we need even when we do not want native Synaptics support
@@ -327,23 +336,56 @@ static void synaptics_pt_create(struct psmouse *psmouse)
  *	Functions to interpret the absolute mode packets
  ****************************************************************************/
 static void synaptics_parse_new_hw(unsigned char buf[],
-				   struct synaptics_data *priv,
-				   struct synaptics_hw_state *hw)
+				   struct synaptics_data *priv)
 {
-	hw->x = ((buf[3] & 0x10) << 8) | ((buf[1] & 0x0f) << 8) | buf[4];
-	hw->y = ((buf[3] & 0x20) << 7) | ((buf[1] & 0xf0) << 4) | buf[5];
+	struct synaptics_hw_state *hw = &priv->hw;
+	int x = ((buf[3] & 0x10) << 8) | ((buf[1] & 0x0f) << 8) | buf[4];
+	int y = ((buf[3] & 0x20) << 7) | ((buf[1] & 0xf0) << 4) | buf[5];
 
 	hw->z = buf[2];
 	hw->w = ((buf[0] & 0x30) >> 2) |
 		((buf[0] & 0x04) >> 1) |
 		((buf[3] & 0x04) >> 2);
 
-	hw->left  = buf[0] & 0x01;
-	hw->right = buf[0] & 0x02;
+	if (SYN_CAP_CLICKPAD(priv->ext_cap)) {
+		int click = (buf[0] ^ buf[3]) & 0x01;
 
-	if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities)) {
-		hw->middle = (buf[0] ^ buf[3]) & 0x01;
-		hw->scroll = hw->w == 2 ? (signed char)buf[1] : 0;
+		if (click && y < YMIN_NOMINAL) {
+			/*
+			 * User pressed in ClickZone; report new button
+			 * state but use :w
+			 * old coordinates and don't report
+			 * any pressure to prevent pointer movement.
+			 */
+			hw->left = x < CLICKPAD_LEFT_BTN_X;
+			hw->right = x > CLICKPAD_RIGHT_BTN_X;
+			hw->middle = x >= CLICKPAD_LEFT_BTN_X &&
+				     x <= CLICKPAD_RIGHT_BTN_X;
+			hw->z = 0;
+
+		} else {
+			/*
+			 * Finger is outside of the ClickZone - report
+			 * current coordinates.
+			 */
+			hw->x = x;
+			hw->y = y;
+
+			if (!click)
+				hw->left = hw->right = hw->middle = 0;
+		}
+
+	} else {
+		hw->x = x;
+		hw->y = y;
+
+		hw->left  = buf[0] & 0x01;
+		hw->right = buf[0] & 0x02;
+
+		if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities)) {
+			hw->middle = (buf[0] ^ buf[3]) & 0x01;
+			hw->scroll = hw->w == 2 ? (signed char)buf[1] : 0;
+		}
 	}
 
 	if (SYN_CAP_FOUR_BUTTON(priv->capabilities)) {
@@ -379,9 +421,10 @@ static void synaptics_parse_new_hw(unsigned char buf[],
 }
 
 static void synaptics_parse_old_hw(unsigned char buf[],
-				   struct synaptics_data *priv,
-				   struct synaptics_hw_state *hw)
+				   struct synaptics_data *priv)
 {
+	struct synaptics_hw_state *hw = &priv->hw;
+
 	hw->x = ((buf[1] & 0x1f) << 8) | buf[2];
 	hw->y = ((buf[4] & 0x1f) << 8) | buf[5];
 
@@ -399,44 +442,44 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 {
 	struct input_dev *dev = psmouse->dev;
 	struct synaptics_data *priv = psmouse->private;
-	struct synaptics_hw_state hw;
+	struct synaptics_hw_state *hw = &priv->hw;
 	int num_fingers;
 	int finger_width;
 	int i;
 
 	if (SYN_MODEL_NEWABS(priv->model_id))
-		synaptics_parse_new_hw(psmouse->packet, priv, &hw);
+		synaptics_parse_new_hw(psmouse->packet, priv);
 	else
-		synaptics_parse_old_hw(psmouse->packet, priv, &hw);
+		synaptics_parse_old_hw(psmouse->packet, priv);
 
-	if (hw.scroll) {
-		priv->scroll += hw.scroll;
+	if (hw->scroll) {
+		priv->scroll += hw->scroll;
 
 		while (priv->scroll >= 4) {
-			input_report_key(dev, BTN_BACK, !hw.down);
+			input_report_key(dev, BTN_BACK, !hw->down);
 			input_sync(dev);
-			input_report_key(dev, BTN_BACK, hw.down);
+			input_report_key(dev, BTN_BACK, hw->down);
 			input_sync(dev);
 			priv->scroll -= 4;
 		}
 		while (priv->scroll <= -4) {
-			input_report_key(dev, BTN_FORWARD, !hw.up);
+			input_report_key(dev, BTN_FORWARD, !hw->up);
 			input_sync(dev);
-			input_report_key(dev, BTN_FORWARD, hw.up);
+			input_report_key(dev, BTN_FORWARD, hw->up);
 			input_sync(dev);
 			priv->scroll += 4;
 		}
 		return;
 	}
 
-	if (hw.z > 0) {
+	if (hw->z > 0) {
 		num_fingers = 1;
 		finger_width = 5;
 		if (SYN_CAP_EXTENDED(priv->capabilities)) {
-			switch (hw.w) {
+			switch (hw->w) {
 			case 0 ... 1:
 				if (SYN_CAP_MULTIFINGER(priv->capabilities))
-					num_fingers = hw.w + 2;
+					num_fingers = hw->w + 2;
 				break;
 			case 2:
 				if (SYN_MODEL_PEN(priv->model_id))
@@ -444,7 +487,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 				break;
 			case 4 ... 15:
 				if (SYN_CAP_PALMDETECT(priv->capabilities))
-					finger_width = hw.w;
+					finger_width = hw->w;
 				break;
 			}
 		}
@@ -457,35 +500,37 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	 * BTN_TOUCH has to be first as mousedev relies on it when doing
 	 * absolute -> relative conversion
 	 */
-	if (hw.z > 30) input_report_key(dev, BTN_TOUCH, 1);
-	if (hw.z < 25) input_report_key(dev, BTN_TOUCH, 0);
+	if (hw->z > 30) input_report_key(dev, BTN_TOUCH, 1);
+	if (hw->z < 25) input_report_key(dev, BTN_TOUCH, 0);
 
-	if (hw.z > 0) {
-		input_report_abs(dev, ABS_X, hw.x);
-		input_report_abs(dev, ABS_Y, YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
+	if (hw->z > 0) {
+		input_report_abs(dev, ABS_X, hw->x);
+		input_report_abs(dev, ABS_Y, YMAX_NOMINAL + YMIN_NOMINAL - hw->y);
 	}
-	input_report_abs(dev, ABS_PRESSURE, hw.z);
+	input_report_abs(dev, ABS_PRESSURE, hw->z);
 
 	input_report_abs(dev, ABS_TOOL_WIDTH, finger_width);
 	input_report_key(dev, BTN_TOOL_FINGER, num_fingers == 1);
-	input_report_key(dev, BTN_LEFT, hw.left);
-	input_report_key(dev, BTN_RIGHT, hw.right);
+	input_report_key(dev, BTN_LEFT, hw->left);
+	input_report_key(dev, BTN_RIGHT, hw->right);
 
 	if (SYN_CAP_MULTIFINGER(priv->capabilities)) {
 		input_report_key(dev, BTN_TOOL_DOUBLETAP, num_fingers == 2);
 		input_report_key(dev, BTN_TOOL_TRIPLETAP, num_fingers == 3);
 	}
 
-	if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities))
-		input_report_key(dev, BTN_MIDDLE, hw.middle);
+	if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities) ||
+	    SYN_CAP_CLICKPAD(priv->ext_cap)) {
+		input_report_key(dev, BTN_MIDDLE, hw->middle);
+	}
 
 	if (SYN_CAP_FOUR_BUTTON(priv->capabilities)) {
-		input_report_key(dev, BTN_FORWARD, hw.up);
-		input_report_key(dev, BTN_BACK, hw.down);
+		input_report_key(dev, BTN_FORWARD, hw->up);
+		input_report_key(dev, BTN_BACK, hw->down);
 	}
 
 	for (i = 0; i < SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap); i++)
-		input_report_key(dev, BTN_0 + i, hw.ext_buttons & (1 << i));
+		input_report_key(dev, BTN_0 + i, hw->ext_buttons & (1 << i));
 
 	input_sync(dev);
 }
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 838e7f2..e00c53d 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -48,6 +48,8 @@
 #define SYN_CAP_VALID(c)		((((c) & 0x00ff00) >> 8) == 0x47)
 #define SYN_EXT_CAP_REQUESTS(c)		(((c) & 0x700000) >> 20)
 #define SYN_CAP_MULTI_BUTTON_NO(ec)	(((ec) & 0x00f000) >> 12)
+#define SYN_CAP_PRODUCT_ID(ec)		(((ec) & 0xff0000) >> 16)
+#define SYN_CAP_CLICKPAD(ec)		(SYN_CAP_PRODUCT_ID(ec) == 0xe4)
 
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
@@ -100,9 +102,10 @@ struct synaptics_data {
 	int x_res;				/* X resolution in units/mm */
 	int y_res;				/* Y resolution in units/mm */
 
+	struct synaptics_hw_state hw;
+	int scroll;
 	unsigned char pkt_type;			/* packet type - old, new, etc */
 	unsigned char mode;			/* current mode byte */
-	int scroll;
 };
 
 void synaptics_module_init(void);
