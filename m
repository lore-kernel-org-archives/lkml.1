Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbYIEBSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbYIEBSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 21:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYIEBRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 21:17:53 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:42159 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751775AbYIEBRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 21:17:52 -0400
Message-ID: <48C088B6.5020406@euromail.se>
Date: Fri, 05 Sep 2008 03:17:42 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: akpm@osdl.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] input: mousedev: Distinguish a moving finger from a tapping
 finger
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.39.57
X-Scan-Result: No virus found in message 1KbPxO-0008DJ-8G.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KbPxO-0008DJ-8G 31d48987639fbf9e72a95fe784568230
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tap functionality of mousedev does not distinguish between a tap
(on/off localized in time and space) and a quick move (on/off localized
in time only). This patch improves the tap detection by testing also
for space locality.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mousedev.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index 8137e50..27e1d73 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -49,6 +49,10 @@ static unsigned tap_time = 200;
 module_param(tap_time, uint, 0644);
 MODULE_PARM_DESC(tap_time, "Tap time for touchpads in absolute mode (msecs)");

+static unsigned tap_move = 20;
+module_param(tap_move, uint, 0644);
+MODULE_PARM_DESC(tap_move, "Tap distance for touchpads in absolute mode (res)");
+
 struct mousedev_hw_data {
 	int dx, dy, dz;
 	int x, y;
@@ -76,6 +80,7 @@ struct mousedev {
 	int old_x[4], old_y[4];
 	int frac_dx, frac_dy;
 	unsigned long touch;
+	int touch_dx, touch_dy;
 };

 enum mousedev_emul {
@@ -143,6 +148,7 @@ static void mousedev_touchpad_event(struct input_dev *dev,
 			tmp = ((value - fx(2)) * 256 * FRACTION_DENOM) / size;
 			tmp += mousedev->frac_dx;
 			mousedev->packet.dx = tmp / FRACTION_DENOM;
+			mousedev->touch_dx += mousedev->packet.dx;
 			mousedev->frac_dx =
 				tmp - mousedev->packet.dx * FRACTION_DENOM;
 		}
@@ -158,6 +164,7 @@ static void mousedev_touchpad_event(struct input_dev *dev,
 			tmp = -((value - fy(2)) * 256 * FRACTION_DENOM) / size;
 			tmp += mousedev->frac_dy;
 			mousedev->packet.dy = tmp / FRACTION_DENOM;
+			mousedev->touch_dy += mousedev->packet.dy;
 			mousedev->frac_dy = tmp -
 				mousedev->packet.dy * FRACTION_DENOM;
 		}
@@ -320,6 +327,8 @@ static void mousedev_touchpad_touch(struct mousedev *mousedev, int value)
 {
 	if (!value) {
 		if (mousedev->touch &&
+		    abs(mousedev->touch_dx) < tap_move &&
+		    abs(mousedev->touch_dy) < tap_move &&
 		    time_before(jiffies,
 				mousedev->touch + msecs_to_jiffies(tap_time))) {
 			/*
@@ -336,6 +345,7 @@ static void mousedev_touchpad_touch(struct mousedev *mousedev, int value)
 			clear_bit(0, &mousedev_mix->packet.buttons);
 		}
 		mousedev->touch = mousedev->pkt_count = 0;
+		mousedev->touch_dx = mousedev->touch_dy = 0;
 		mousedev->frac_dx = 0;
 		mousedev->frac_dy = 0;

-- 
1.5.4.3

