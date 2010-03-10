Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab0CJKhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:37:04 -0500
Received: from mail18.bluewin.ch ([195.186.19.64]:56925 "EHLO
	mail18.bluewin.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab0CJKg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:36:57 -0500
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 05:36:57 EST
X-FXIT-IP: IPv4[83.77.41.159] Epoch[1268216992]
Date: Wed, 10 Mar 2010 11:29:50 +0100
From: Martin Buck <mb-tmp-yvahk-vachg@gromit.dyndns.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ulrich Dangel <uli@spamt.net>
Subject: [PATCH] input: Fix stuck buttons on some Alps touchpads
Message-ID: <20100310102950.GA2534@gromit.at.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Buck <mb-tmp-yvahk-vachg@gromit.dyndns.org>

Enable button release event redirection to the device that got the button
press not only for touchpads with interleaved protocols, but unconditionally
for all Alps touchpads. This is required at least for the touchpad in a Dell
Inspiron 8200, because it sometimes sends the release event for the touchpad
buttons in such a way that it looks like a release event for the trackpoint
buttons (which didn't matter so far because everything ended up in one
device anyway, but it broke when support for sending button events to 2
different devices for touchpad and trackpoint was added in commit
d7ed5d883c09c5474f842dcb148515dfaef2a567).

Signed-off-by: Martin Buck <mb-tmp-yvahk-vachg@gromit.dyndns.org>
---
Another option would have been to add an additional #define just for the
Dell Inspiron 8200 touchpad that enables the redirection only when it is set
(and of course in case of ALPS_PS2_INTERLEAVED as it's done at the moment).
But I fail to see why enabling it unconditionally could cause problems for
anybody, so this is what my patch does. If somebody sees a problem with
this, I'll happily rewrite the patch to do the redirection only when it
knows that it's required for a specific model.


--- linux-2.6.32.8/drivers/input/mouse/alps.c.orig	2010-03-10 00:00:50.000000000 +0100
+++ linux-2.6.32.8/drivers/input/mouse/alps.c	2010-03-10 00:12:11.000000000 +0100
@@ -117,40 +117,27 @@ static void alps_report_buttons(struct p
 				struct input_dev *dev1, struct input_dev *dev2,
 				int left, int right, int middle)
 {
-	struct alps_data *priv = psmouse->private;
-	const struct alps_model_info *model = priv->i;
-
-	if (model->flags & ALPS_PS2_INTERLEAVED) {
-		struct input_dev *dev;
+	struct input_dev *dev;
 
-		/*
-		 * If shared button has already been reported on the
-		 * other device (dev2) then this event should be also
-		 * sent through that device.
-		 */
-		dev = test_bit(BTN_LEFT, dev2->key) ? dev2 : dev1;
-		input_report_key(dev, BTN_LEFT, left);
+	/*
+	 * If shared button has already been reported on the
+	 * other device (dev2) then this event should be also
+	 * sent through that device.
+	 */
+	dev = test_bit(BTN_LEFT, dev2->key) ? dev2 : dev1;
+	input_report_key(dev, BTN_LEFT, left);
 
-		dev = test_bit(BTN_RIGHT, dev2->key) ? dev2 : dev1;
-		input_report_key(dev, BTN_RIGHT, right);
+	dev = test_bit(BTN_RIGHT, dev2->key) ? dev2 : dev1;
+	input_report_key(dev, BTN_RIGHT, right);
 
-		dev = test_bit(BTN_MIDDLE, dev2->key) ? dev2 : dev1;
-		input_report_key(dev, BTN_MIDDLE, middle);
+	dev = test_bit(BTN_MIDDLE, dev2->key) ? dev2 : dev1;
+	input_report_key(dev, BTN_MIDDLE, middle);
 
-		/*
-		 * Sync the _other_ device now, we'll do the first
-		 * device later once we report the rest of the events.
-		 */
-		input_sync(dev2);
-	} else {
-		/*
-		 * For devices with non-interleaved packets we know what
-		 * device buttons belong to so we can simply report them.
-		 */
-		input_report_key(dev1, BTN_LEFT, left);
-		input_report_key(dev1, BTN_RIGHT, right);
-		input_report_key(dev1, BTN_MIDDLE, middle);
-	}
+	/*
+	 * Sync the _other_ device now, we'll do the first
+	 * device later once we report the rest of the events.
+	 */
+	input_sync(dev2);
 }
 
 static void alps_process_packet(struct psmouse *psmouse)
