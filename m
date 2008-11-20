Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYKTAY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYKTAY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 19:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYKTAYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 19:24:48 -0500
Received: from ipx-119-252-190-80.ipxserver.de ([80.190.252.119]:54756 "EHLO
	ipx10616.ipxserver.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752193AbYKTAYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 19:24:47 -0500
Date: Thu, 20 Nov 2008 10:23:27 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] Input: synaptics - Only report double/triple tap if
	supported by the device.
Message-ID: <20081120002319.GA10883@dingo.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Section 2.4.4 of the Synaptics TouchPad Interfacing Guide, bit 2
specifies if multi-finger detection is provided by the touchpad. Thus, only
set BTN_TOOL_DOUBLETAP and BTN_TOOL_TRIPLETAP if the device actually supports
it.

Signed-off-by: Peter Hutterer <peter.hutterer@redhat.com>
---
 drivers/input/mouse/synaptics.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index d349c4a..865fc69 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -445,12 +445,14 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 
 	input_report_abs(dev, ABS_TOOL_WIDTH, finger_width);
 	input_report_key(dev, BTN_TOOL_FINGER, num_fingers == 1);
-	input_report_key(dev, BTN_TOOL_DOUBLETAP, num_fingers == 2);
-	input_report_key(dev, BTN_TOOL_TRIPLETAP, num_fingers == 3);
-
 	input_report_key(dev, BTN_LEFT, hw.left);
 	input_report_key(dev, BTN_RIGHT, hw.right);
 
+	if (SYN_CAP_MULTIFINGER(priv->capabilities)) {
+		input_report_key(dev, BTN_TOOL_DOUBLETAP, num_fingers == 2);
+		input_report_key(dev, BTN_TOOL_TRIPLETAP, num_fingers == 3);
+	}
+
 	if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities))
 		input_report_key(dev, BTN_MIDDLE, hw.middle);
 
@@ -543,12 +545,14 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	set_bit(EV_KEY, dev->evbit);
 	set_bit(BTN_TOUCH, dev->keybit);
 	set_bit(BTN_TOOL_FINGER, dev->keybit);
-	set_bit(BTN_TOOL_DOUBLETAP, dev->keybit);
-	set_bit(BTN_TOOL_TRIPLETAP, dev->keybit);
-
 	set_bit(BTN_LEFT, dev->keybit);
 	set_bit(BTN_RIGHT, dev->keybit);
 
+	if (SYN_CAP_MULTIFINGER(priv->capabilities)) {
+		set_bit(BTN_TOOL_DOUBLETAP, dev->keybit);
+		set_bit(BTN_TOOL_TRIPLETAP, dev->keybit);
+	}
+
 	if (SYN_CAP_MIDDLE_BUTTON(priv->capabilities))
 		set_bit(BTN_MIDDLE, dev->keybit);
 
-- 
1.6.0.3
