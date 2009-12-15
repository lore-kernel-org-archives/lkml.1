Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbZLOG0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbZLOG0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 01:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbZLOG0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 01:26:36 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:38474 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbZLOG0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 01:26:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PmP/CtAtyYL70HmCnnVL479gyP9Kf0DbYnDOBybjPQ1nZibHTN00Mbv0lFclySYrJf
         pHO90Xzhabfy+6GfHnepGbXM4iQog/aX15xF95bOxO8zPnTx9P25qvVCwbPEYLZA5isI
         I+gdpPkrMg52gwegvWekkemYAqH0PXP9udnqI=
Date: Mon, 14 Dec 2009 22:26:28 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: tiwai@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: synaptics touchpad doesn't click
Message-ID: <20091215062628.GA12669@core.coreip.homeip.net>
References: <20091214014828.GA28402@ldl.fc.hp.com> <20091214173450.GB2373@core.coreip.homeip.net> <20091215034127.GC587@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline
In-Reply-To: <20091215034127.GC587@ldl.fc.hp.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Alex,

On Mon, Dec 14, 2009 at 08:41:27PM -0700, Alex Chiang wrote:
> 
> Thanks, I did grab Takashi's patches and verify that they work
> for me. I tested the separated patches, not the v2 combined
> patch, although it doesn't make any difference based on visual
> inspection of v2.
> 
> If you want, you can add my:
> 
> Tested-by: Alex Chiang <achiang@hp.com>

Thank you very much for testing, however could you please try a slightly
different patch below (I did not quite like that the original patch
mangled device's capability field and how it was reusing 'middle' field
for different things)? It should apply on top of patch that
I am attaching. I hope I did not screw it up too much,

Thanks a lot.

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

 drivers/input/mouse/synaptics.c |   59 ++++++++++++++++++++++++++++++++++-----
 drivers/input/mouse/synaptics.h |    2 +
 2 files changed, 53 insertions(+), 8 deletions(-)


diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 0d60cb7..d11a673 100644
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
@@ -330,20 +339,52 @@ static void synaptics_parse_new_hw(unsigned char buf[],
 				   struct synaptics_data *priv,
 				   struct synaptics_hw_state *hw)
 {
-	hw->x = (((buf[3] & 0x10) << 8) | ((buf[1] & 0x0f) << 8) | buf[4]);
-	hw->y = (((buf[3] & 0x20) << 7) | ((buf[1] & 0xf0) << 4) | buf[5]);
+	int x = (((buf[3] & 0x10) << 8) | ((buf[1] & 0x0f) << 8) | buf[4]);
+	int y = (((buf[3] & 0x20) << 7) | ((buf[1] & 0xf0) << 4) | buf[5]);
 
 	hw->z = buf[2];
 	hw->w = (((buf[0] & 0x30) >> 2) |
 		 ((buf[0] & 0x04) >> 1) |
 		 ((buf[3] & 0x04) >> 2));
 
-	hw->left  = buf[0] & 0x01;
-	hw->right = buf[0] & 0x02;
+	if (SYN_CAP_CLICKPAD(priv->ext_cap)) {
+		int click = (buf[0] ^ buf[3]) & 0x01;
+
+		if (click && y < YMIN_NOMINAL) {
+			/*
+			 * User pressed in ClickZone; report new button
+			 * state but use old coordinates and don't report
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
 
-	if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities)) {
-		hw->middle = (buf[0] ^ buf[3]) & 0x01;
-		hw->scroll = hw->w == 2 ? (signed char)(buf[1]) : 0;
+		if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities)) {
+			hw->middle = (buf[0] ^ buf[3]) & 0x01;
+			hw->scroll = hw->w == 2 ? (signed char)(buf[1]) : 0;
+		}
 	}
 
 	if (SYN_CAP_FOUR_BUTTON(priv->capabilities)) {
@@ -476,8 +517,10 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 		input_report_key(dev, BTN_TOOL_TRIPLETAP, num_fingers == 3);
 	}
 
-	if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities))
+	if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities) ||
+	    SYN_CAP_CLICKPAD(priv->ext_cap)) {
 		input_report_key(dev, BTN_MIDDLE, hw.middle);
+	}
 
 	if (SYN_CAP_FOUR_BUTTON(priv->capabilities)) {
 		input_report_key(dev, BTN_FORWARD, hw.up);
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 838e7f2..35360a6 100644
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

--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="synaptics-split-protocols.patch"

Input: synaptics - separate old and new protocol parsing

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Split synaptics_parse_hw_state into 2 separate functions in preparation
for CLickPad support.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/mouse/synaptics.c |   98 ++++++++++++++++++++-------------------
 1 files changed, 50 insertions(+), 48 deletions(-)


diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 05689e7..0d60cb7 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -326,40 +326,34 @@ static void synaptics_pt_create(struct psmouse *psmouse)
 /*****************************************************************************
  *	Functions to interpret the absolute mode packets
  ****************************************************************************/
-
-static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data *priv, struct synaptics_hw_state *hw)
+static void synaptics_parse_new_hw(unsigned char buf[],
+				   struct synaptics_data *priv,
+				   struct synaptics_hw_state *hw)
 {
-	memset(hw, 0, sizeof(struct synaptics_hw_state));
-
-	if (SYN_MODEL_NEWABS(priv->model_id)) {
-		hw->x = (((buf[3] & 0x10) << 8) |
-			 ((buf[1] & 0x0f) << 8) |
-			 buf[4]);
-		hw->y = (((buf[3] & 0x20) << 7) |
-			 ((buf[1] & 0xf0) << 4) |
-			 buf[5]);
-
-		hw->z = buf[2];
-		hw->w = (((buf[0] & 0x30) >> 2) |
-			 ((buf[0] & 0x04) >> 1) |
-			 ((buf[3] & 0x04) >> 2));
-
-		hw->left  = (buf[0] & 0x01) ? 1 : 0;
-		hw->right = (buf[0] & 0x02) ? 1 : 0;
-
-		if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities)) {
-			hw->middle = ((buf[0] ^ buf[3]) & 0x01) ? 1 : 0;
-			if (hw->w == 2)
-				hw->scroll = (signed char)(buf[1]);
-		}
+	hw->x = (((buf[3] & 0x10) << 8) | ((buf[1] & 0x0f) << 8) | buf[4]);
+	hw->y = (((buf[3] & 0x20) << 7) | ((buf[1] & 0xf0) << 4) | buf[5]);
 
-		if (SYN_CAP_FOUR_BUTTON(priv->capabilities)) {
-			hw->up   = ((buf[0] ^ buf[3]) & 0x01) ? 1 : 0;
-			hw->down = ((buf[0] ^ buf[3]) & 0x02) ? 1 : 0;
-		}
+	hw->z = buf[2];
+	hw->w = (((buf[0] & 0x30) >> 2) |
+		 ((buf[0] & 0x04) >> 1) |
+		 ((buf[3] & 0x04) >> 2));
+
+	hw->left  = buf[0] & 0x01;
+	hw->right = buf[0] & 0x02;
 
-		if (SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap) &&
-		    ((buf[0] ^ buf[3]) & 0x02)) {
+	if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities)) {
+		hw->middle = (buf[0] ^ buf[3]) & 0x01;
+		hw->scroll = hw->w == 2 ? (signed char)(buf[1]) : 0;
+	}
+
+	if (SYN_CAP_FOUR_BUTTON(priv->capabilities)) {
+		hw->up   = (buf[0] ^ buf[3]) & 0x01;
+		hw->down = (buf[0] ^ buf[3]) & 0x02;
+	}
+
+	if (SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap)) {
+		hw->ext_buttons = 0;
+		if ((buf[0] ^ buf[3]) & 0x02) {
 			switch (SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap) & ~0x01) {
 			default:
 				/*
@@ -368,29 +362,34 @@ static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data
 				 */
 				break;
 			case 8:
-				hw->ext_buttons |= ((buf[5] & 0x08)) ? 0x80 : 0;
-				hw->ext_buttons |= ((buf[4] & 0x08)) ? 0x40 : 0;
+				hw->ext_buttons |= (buf[5] & 0x08) << 4;
+				hw->ext_buttons |= (buf[4] & 0x08) << 3;
 			case 6:
-				hw->ext_buttons |= ((buf[5] & 0x04)) ? 0x20 : 0;
-				hw->ext_buttons |= ((buf[4] & 0x04)) ? 0x10 : 0;
+				hw->ext_buttons |= (buf[5] & 0x04) << 3;
+				hw->ext_buttons |= (buf[4] & 0x04) << 2;
 			case 4:
-				hw->ext_buttons |= ((buf[5] & 0x02)) ? 0x08 : 0;
-				hw->ext_buttons |= ((buf[4] & 0x02)) ? 0x04 : 0;
+				hw->ext_buttons |= (buf[5] & 0x02) << 2;
+				hw->ext_buttons |= (buf[4] & 0x02) << 1;
 			case 2:
-				hw->ext_buttons |= ((buf[5] & 0x01)) ? 0x02 : 0;
-				hw->ext_buttons |= ((buf[4] & 0x01)) ? 0x01 : 0;
+				hw->ext_buttons |= (buf[5] & 0x01) << 1;
+				hw->ext_buttons |= (buf[4] & 0x01) << 0;
 			}
 		}
-	} else {
-		hw->x = (((buf[1] & 0x1f) << 8) | buf[2]);
-		hw->y = (((buf[4] & 0x1f) << 8) | buf[5]);
+	}
+}
 
-		hw->z = (((buf[0] & 0x30) << 2) | (buf[3] & 0x3F));
-		hw->w = (((buf[1] & 0x80) >> 4) | ((buf[0] & 0x04) >> 1));
+static void synaptics_parse_old_hw(unsigned char buf[],
+				   struct synaptics_data *priv,
+				   struct synaptics_hw_state *hw)
+{
+	hw->x = (((buf[1] & 0x1f) << 8) | buf[2]);
+	hw->y = (((buf[4] & 0x1f) << 8) | buf[5]);
 
-		hw->left  = (buf[0] & 0x01) ? 1 : 0;
-		hw->right = (buf[0] & 0x02) ? 1 : 0;
-	}
+	hw->z = (((buf[0] & 0x30) << 2) | (buf[3] & 0x3F));
+	hw->w = (((buf[1] & 0x80) >> 4) | ((buf[0] & 0x04) >> 1));
+
+	hw->left  = buf[0] & 0x01;
+	hw->right = buf[0] & 0x02;
 }
 
 /*
@@ -405,7 +404,10 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	int finger_width;
 	int i;
 
-	synaptics_parse_hw_state(psmouse->packet, priv, &hw);
+	if (SYN_MODEL_NEWABS(priv->model_id))
+		synaptics_parse_new_hw(psmouse->packet, priv, &hw);
+	else
+		synaptics_parse_old_hw(psmouse->packet, priv, &hw);
 
 	if (hw.scroll) {
 		priv->scroll += hw.scroll;

--3uo+9/B/ebqu+fSQ--
