Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbZA2X4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbZA2X4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbZA2Xz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:55:57 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:58778 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751850AbZA2Xz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:55:56 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: bcm5974: Declare alignment usage
Date: Fri, 30 Jan 2009 00:55:44 +0100
Message-Id: <1233273344-6225-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.5.6.3
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1LSgjh-0002Tl-4r.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1LSgjh-0002Tl-4r 212ab9c8c16ef1a60e0a8ed2aec92fd9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds struct alignment information and adds comments to
ensure all access of finger data is two-byte aligned.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 874ae11..37f2341 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -110,17 +110,17 @@ enum tp_type {
 	TYPE2			/* button integrated in trackpad */
 };
 
-/* trackpad finger data offsets */
-#define FINGER_TYPE1		26
-#define FINGER_TYPE2		30
+/* trackpad finger data offsets, le16-aligned */
+#define FINGER_TYPE1		(13 * sizeof(__le16))
+#define FINGER_TYPE2		(15 * sizeof(__le16))
 
-/* trackpad button data offsets */
+/* trackpad button data offsets, u8-aligned */
 #define BUTTON_TYPE2		15
 
 /* integrated button capability by configuration */
 #define HAS_INTEGRATED_BUTTON(c)	(c->tp_type == TYPE2)
 
-/* trackpad finger structure */
+/* trackpad finger structure, le16-aligned */
 struct tp_finger {
 	__le16 origin;		/* zero when switching track finger */
 	__le16 abs_x;		/* absolute x coodinate */
@@ -134,7 +134,7 @@ struct tp_finger {
 	__le16 force_minor;	/* trackpad force, minor axis? */
 	__le16 unused[3];	/* zeros */
 	__le16 multi;		/* one finger: varies, more fingers: constant */
-};
+} __attribute__((packed,aligned(2)));
 
 /* trackpad finger data size, empirically at least ten fingers */
 #define SIZEOF_FINGER		sizeof(struct tp_finger)
@@ -321,6 +321,7 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	if (size < c->tp_offset || (size - c->tp_offset) % SIZEOF_FINGER != 0)
 		return -EIO;
 
+	/* finger data, le16-aligned */
 	f = (const struct tp_finger *)(dev->tp_data + c->tp_offset);
 	raw_n = (size - c->tp_offset) / SIZEOF_FINGER;
 
-- 
1.5.6.3

