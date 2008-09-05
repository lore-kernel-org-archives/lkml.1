Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYIEBUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYIEBUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 21:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYIEBUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 21:20:08 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:39345 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbYIEBUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 21:20:07 -0400
Message-ID: <48C0893C.6060901@euromail.se>
Date: Fri, 05 Sep 2008 03:19:56 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: akpm@osdl.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] input: mousedev: Emulate right and middle buttons for
 single-button touchpads
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.39.57
X-Scan-Result: No virus found in message 1KbPzZ-0000Pc-4I.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1KbPzZ-0000Pc-4I 633a2b7179301e54bfb8d6cada86a31d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On most linux-based systems, the right and middle buttons are used
extensively. On computers lacking either of those buttons, such as
the Apple Macbooks, emulation is needed. This patch adds emulation
of the missing buttons via two-fingers-and-click and three-fingers-
and-click operations, which has recently become standard, both in
MacOS and in the Xorg synaptics driver.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mousedev.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index 27e1d73..a1e929f 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -53,6 +53,14 @@ static unsigned tap_move = 20;
 module_param(tap_move, uint, 0644);
 MODULE_PARM_DESC(tap_move, "Tap distance for touchpads in absolute mode (res)");

+static unsigned two_finger_code = BTN_RIGHT;
+module_param(two_finger_code, uint, 0644);
+MODULE_PARM_DESC(two_finger_code, "Button code of two-finger click");
+
+static unsigned three_finger_code = BTN_MIDDLE;
+module_param(three_finger_code, uint, 0644);
+MODULE_PARM_DESC(three_finger_code, "Button code of three-finger click");
+
 struct mousedev_hw_data {
 	int dx, dy, dz;
 	int x, y;
@@ -81,6 +89,7 @@ struct mousedev {
 	int frac_dx, frac_dy;
 	unsigned long touch;
 	int touch_dx, touch_dy;
+	int double_tap, triple_tap;
 };

 enum mousedev_emul {
@@ -225,11 +234,31 @@ static void mousedev_rel_event(struct mousedev *mousedev,
 	}
 }

+/* multi-finger emulation of non-existing buttons */
+static unsigned int get_button_code(const struct mousedev *mousedev)
+{
+	unsigned int code = BTN_LEFT;
+	if (mousedev->double_tap)
+		code = two_finger_code;
+	if (mousedev->triple_tap)
+		code = three_finger_code;
+	if (test_bit(code, mousedev->handle.dev->keybit))
+		code = BTN_LEFT;
+	return code;
+}
+
 static void mousedev_key_event(struct mousedev *mousedev,
 				unsigned int code, int value)
 {
 	int index;

+	if (code == BTN_TOOL_DOUBLETAP)
+		mousedev->double_tap = value;
+	if (code == BTN_TOOL_TRIPLETAP)
+		mousedev->triple_tap = value;
+	if (code == BTN_LEFT)
+		code = get_button_code(mousedev);
+
 	switch (code) {

 	case BTN_TOUCH:
@@ -327,6 +356,8 @@ static void mousedev_touchpad_touch(struct mousedev *mousedev, int value)
 {
 	if (!value) {
 		if (mousedev->touch &&
+		    !mousedev->double_tap &&
+		    !mousedev->triple_tap &&
 		    abs(mousedev->touch_dx) < tap_move &&
 		    abs(mousedev->touch_dy) < tap_move &&
 		    time_before(jiffies,
-- 
1.5.4.3

