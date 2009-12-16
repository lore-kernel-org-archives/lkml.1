Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbZLPC7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbZLPC7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbZLPC7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:59:41 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:54818 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbZLPC7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:59:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oVXSXyUjnaxdE1b78sMlQUhpYstT3XmjrJjUGtYFuZK2r+DG+NEgSmIaD1rg1EbjXf
         05jQp267Q8YITXIXYNdf3C1O7cDSqn3XFi39dNTAgQ3NZkwv74dV7kND+DYg4LDbWesF
         AyphTFT9q6gs57fuRVwTCNCpnTTN8tnfn83dw=
Date: Tue, 15 Dec 2009 18:59:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: synaptics touchpad doesn't click
Message-ID: <20091216025934.GA2699@core.coreip.homeip.net>
References: <20091214014828.GA28402@ldl.fc.hp.com> <20091214173450.GB2373@core.coreip.homeip.net> <20091215034127.GC587@ldl.fc.hp.com> <20091215062628.GA12669@core.coreip.homeip.net> <s5h1viwn3ig.wl%tiwai@suse.de> <20091215073358.GC12669@core.coreip.homeip.net> <s5hvdg8lm5q.wl%tiwai@suse.de> <20091215082518.GD12669@core.coreip.homeip.net> <20091216010506.GA26367@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216010506.GA26367@ldl.fc.hp.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 06:05:06PM -0700, Alex Chiang wrote:
> * Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> >
> > The updated patch is below.
> > 
> > -- 
> > Dmitry
> 
> Should I test this one or wait one more iteration to address
> Takashi's last comments?
> 

Actually I think we took the wrong direction with the original patch and
we should do what other buttonless devices (bcm5974) do: report touchpad
click as left button and have Synaptics X driver provide enhanced
support. This way we can have both modes (ClickZones and ClickButtons)
and users will get to chose (provided that someone takes time to add
that support to Synaptics driver of course ;) ).

Could you tell me if the below works for you?

-- 
Dmitry


Input: synaptics - add support for ClickPad devices

From: Takashi Iwai <tiwai@suse.de>

The new device is a button-less "clickable" touchpad, it does not have
physical left, right nor middle buttons. Instead the entire touchpad
area can be "clicked" and such click is signalled the same way middle
button state is signalled on touchpads that have SYN_CAP_MIDDLE_BUTTON
capability.

The driver will reporting touchpad clicks as primary button (BTN_LEFT)
events, the same way driver for bcm5974 handles buttonless touchpads on
MacBooks, allowing limited support for legacy software. Enhanced support,
including "ClickButtons" and "ClickZone" modes to emulate right and
middle nuttons, is left to userspace components.

The device will not signal BTN_RIGHT event and will remove it from the
capability list. Since all Synaptics devices up until now had both left
and right buttons present the absence of BTN_RIGHT capability can be
used to identify ClickPad devices.

Due to the fact that there is no known capability bits for ClickPads we
are forced to match on product ID.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/mouse/synaptics.c |   21 ++++++++++++++++-----
 drivers/input/mouse/synaptics.h |    2 ++
 2 files changed, 18 insertions(+), 5 deletions(-)


diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 7047558..633b975 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -338,12 +338,16 @@ static void synaptics_parse_new_hw(unsigned char buf[],
 		((buf[0] & 0x04) >> 1) |
 		((buf[3] & 0x04) >> 2);
 
-	hw->left  = buf[0] & 0x01;
-	hw->right = buf[0] & 0x02;
+	if (SYN_CAP_CLICKPAD(priv->ext_cap)) {
+		hw->left = (buf[0] ^ buf[3]) & 0x01;
+	} else {
+		hw->left  = buf[0] & 0x01;
+		hw->right = buf[0] & 0x02;
 
-	if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities)) {
-		hw->middle = (buf[0] ^ buf[3]) & 0x01;
-		hw->scroll = hw->w == 2 ? (signed char)buf[1] : 0;
+		if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities)) {
+			hw->middle = (buf[0] ^ buf[3]) & 0x01;
+			hw->scroll = hw->w == 2 ? (signed char)buf[1] : 0;
+		}
 	}
 
 	if (SYN_CAP_FOUR_BUTTON(priv->capabilities)) {
@@ -592,6 +596,13 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	__clear_bit(REL_X, dev->relbit);
 	__clear_bit(REL_Y, dev->relbit);
 
+	/*
+	 * ClickPads are buttonless devices. We report the touchpad clicks
+	 * as BTN_LEFT but there is no BTN_RIGHT or BTN_MIDDLE.
+	 */
+	if (SYN_CAP_CLICKPAD(priv->ext_cap))
+		__clear_bit(BTN_RIGHT, dev->keybit);
+
 	dev->absres[ABS_X] = priv->x_res;
 	dev->absres[ABS_Y] = priv->y_res;
 }
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
index 838e7f2..343dfc0 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -48,6 +48,8 @@
 #define SYN_CAP_VALID(c)		((((c) & 0x00ff00) >> 8) == 0x47)
 #define SYN_EXT_CAP_REQUESTS(c)		(((c) & 0x700000) >> 20)
 #define SYN_CAP_MULTI_BUTTON_NO(ec)	(((ec) & 0x00f000) >> 12)
+#define SYN_CAP_PRODUCT_ID(ec)          (((ec) & 0xff0000) >> 16)
+#define SYN_CAP_CLICKPAD(ec)            (SYN_CAP_PRODUCT_ID(ec) == 0xe4)
 
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
