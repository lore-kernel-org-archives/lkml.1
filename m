Return-Path: <linux-kernel-owner+w=401wt.eu-S1761008AbZD1H7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761008AbZD1H7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759530AbZD1H7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:59:39 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:36357 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756226AbZD1H7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:59:38 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: Add a detailed multi-touch finger data report protocol (rev3)
Date: Tue, 28 Apr 2009 09:58:46 +0200
Message-Id: <1240905526-15845-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.5.6.3
X-Originating-IP: 83.248.194.102
X-Scan-Result: No virus found in message 1LyiDH-0001sB-5m.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1LyiDH-0001sB-5m 858a205e9298748910ca7c2b189156f3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to utilize the full power of the new multi-touch devices, a
way to report detailed finger data to user space is needed. This patch
adds a multi-touch (MT) protocol which allows drivers to report details
for an arbitrary number of fingers.

The driver sends a SYN_MT_REPORT event via the input_mt_sync() function
when a complete finger has been reported.

In order to stay compatible with existing applications, the data
reported in a finger packet must not be recognized as single-touch
events. In addition, all finger data must bypass input filtering,
since subsequent events of the same type refer to different fingers.

A set of ABS_MT events with the desired properties are defined. The
events are divided into categories, to allow for partial implementation.
The minimum set consists of ABS_MT_TOUCH_MAJOR, ABS_MT_POSITION_X and
ABS_MT_POSITION_Y, which allows for multiple fingers to be tracked.
If the device supports it, the ABS_MT_WIDTH_MAJOR may be used to provide
the size of the approaching finger. Anisotropy and direction may be
specified with ABS_MT_TOUCH_MINOR, ABS_MT_WIDTH_MINOR and
ABS_MT_ORIENTATION. Devices with more granular information may specify
general shapes as blobs, i.e., as a sequence of rectangular shapes
grouped together by a ABS_MT_BLOB_ID. Finally, the ABS_MT_TOOL_TYPE
may be used to specify whether the touching tool is a finger or a pen.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input.c |   13 +++++++++++++
 include/linux/input.h |   23 +++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 1e42619..1e7f8a3 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -33,6 +33,15 @@ MODULE_LICENSE("GPL");
  * EV_ABS events which should not be cached are listed here.
  */
 static __initdata unsigned int input_abs_bypass_init_data[] = {
+	ABS_MT_TOUCH_MAJOR,
+	ABS_MT_TOUCH_MINOR,
+	ABS_MT_WIDTH_MAJOR,
+	ABS_MT_WIDTH_MINOR,
+	ABS_MT_ORIENTATION,
+	ABS_MT_POSITION_X,
+	ABS_MT_POSITION_Y,
+	ABS_MT_TOOL_TYPE,
+	ABS_MT_BLOB_ID,
 	0
 };
 
@@ -170,6 +179,10 @@ static void input_handle_event(struct input_dev *dev,
 				disposition = INPUT_PASS_TO_HANDLERS;
 			}
 			break;
+		case SYN_MT_REPORT:
+			dev->sync = 0;
+			disposition = INPUT_PASS_TO_HANDLERS;
+			break;
 		}
 		break;
 
diff --git a/include/linux/input.h b/include/linux/input.h
index 32cb825..0e6ff5d 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -106,6 +106,7 @@ struct input_absinfo {
 
 #define SYN_REPORT		0
 #define SYN_CONFIG		1
+#define SYN_MT_REPORT		2
 
 /*
  * Keys and buttons
@@ -645,6 +646,17 @@ struct input_absinfo {
 #define ABS_TOOL_WIDTH		0x1c
 #define ABS_VOLUME		0x20
 #define ABS_MISC		0x28
+
+#define ABS_MT_TOUCH_MAJOR	0x30	/* Major axis of touching ellipse */
+#define ABS_MT_TOUCH_MINOR	0x31	/* Minor axis (omit if circular) */
+#define ABS_MT_WIDTH_MAJOR	0x32	/* Major axis of approaching ellipse */
+#define ABS_MT_WIDTH_MINOR	0x33	/* Minor axis (omit if circular) */
+#define ABS_MT_ORIENTATION	0x34	/* Ellipse orientation */
+#define ABS_MT_POSITION_X	0x35	/* Center X ellipse position */
+#define ABS_MT_POSITION_Y	0x36	/* Center Y ellipse position */
+#define ABS_MT_TOOL_TYPE	0x37	/* Type of touching device */
+#define ABS_MT_BLOB_ID		0x38	/* Group a set of packets as a blob */
+
 #define ABS_MAX			0x3f
 #define ABS_CNT			(ABS_MAX+1)
 
@@ -744,6 +756,12 @@ struct input_absinfo {
 #define BUS_ATARI		0x1B
 
 /*
+ * MT_TOOL types
+ */
+#define MT_TOOL_FINGER		0
+#define MT_TOOL_PEN		1
+
+/*
  * Values describing the status of a force-feedback effect
  */
 #define FF_STATUS_STOPPED	0x00
@@ -1312,6 +1330,11 @@ static inline void input_sync(struct input_dev *dev)
 	input_event(dev, EV_SYN, SYN_REPORT, 0);
 }
 
+static inline void input_mt_sync(struct input_dev *dev)
+{
+	input_event(dev, EV_SYN, SYN_MT_REPORT, 0);
+}
+
 void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code);
 
 static inline void input_set_abs_params(struct input_dev *dev, int axis, int min, int max, int fuzz, int flat)
-- 
1.5.6.3

