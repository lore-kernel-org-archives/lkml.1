Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZA1K0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZA1K0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbZA1KYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:24:14 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:45704 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753740AbZA1KYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:24:12 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 6/6] input: Add a detailed multi-touch finger data report protocol (rev2)
Date: Wed, 28 Jan 2009 11:23:49 +0100
Message-Id: <1233138229-12489-7-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233138229-12489-6-git-send-email-rydberg@euromail.se>
References: <1233138229-12489-1-git-send-email-rydberg@euromail.se>
 <1233138229-12489-2-git-send-email-rydberg@euromail.se>
 <1233138229-12489-3-git-send-email-rydberg@euromail.se>
 <1233138229-12489-4-git-send-email-rydberg@euromail.se>
 <1233138229-12489-5-git-send-email-rydberg@euromail.se>
 <1233138229-12489-6-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1LS7aa-00016a-95.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1LS7aa-00016a-95 433bce43d24e564bae80c45eb23a0d30
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
 include/linux/input.h |   27 +++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 7f9180c..ccf1756 100644
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
 
@@ -165,6 +174,10 @@ static void input_handle_event(struct input_dev *dev,
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
index ccc8a9b..4799aba 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -106,6 +106,7 @@ struct input_absinfo {
 
 #define SYN_REPORT		0
 #define SYN_CONFIG		1
+#define SYN_MT_REPORT		2
 
 /*
  * Keys and buttons
@@ -646,6 +647,19 @@ struct input_absinfo {
 #define ABS_TOOL_WIDTH		0x1c
 #define ABS_VOLUME		0x20
 #define ABS_MISC		0x28
+
+#define ABS_MT_TOUCH		0x30	/* Diameter of touching circle */
+#define ABS_MT_TOUCH_MAJOR	0x30	/* Major axis of touching ellipse */
+#define ABS_MT_TOUCH_MINOR	0x31	/* Minor axis of touching ellipse */
+#define ABS_MT_WIDTH		0x32	/* Diameter of approaching circle */
+#define ABS_MT_WIDTH_MAJOR	0x32	/* Major axis of approaching ellipse */
+#define ABS_MT_WIDTH_MINOR	0x33	/* Minor axis of approaching ellipse */
+#define ABS_MT_ORIENTATION	0x34	/* Ellipse orientation */
+#define ABS_MT_POSITION_X	0x35	/* Center X ellipse position */
+#define ABS_MT_POSITION_Y	0x36	/* Center Y ellipse position */
+#define ABS_MT_TOOL_TYPE	0x37	/* Type of touching device */
+#define ABS_MT_BLOB_ID		0x38	/* Group a set of packets as a blob */
+
 #define ABS_MAX			0x3f
 #define ABS_CNT			(ABS_MAX+1)
 
@@ -744,6 +758,14 @@ struct input_absinfo {
 #define BUS_ATARI		0x1B
 
 /*
+ * MT_TOOL types
+ */
+#define MT_TOOL_FINGER		0
+#define MT_TOOL_PEN		1
+#define MT_TOOL_MAX		9
+#define MT_TOOL_CNT		(MT_TOOL_MAX + 1)
+
+/*
  * Values describing the status of a force-feedback effect
  */
 #define FF_STATUS_STOPPED	0x00
@@ -1312,6 +1334,11 @@ static inline void input_sync(struct input_dev *dev)
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

