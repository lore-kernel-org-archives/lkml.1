Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbXHVI5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbXHVI5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbXHVIwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:55 -0400
Received: from 1wt.eu ([62.212.114.60]:1957 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758070AbXHVIww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:52 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822083954.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:00 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 16/58] V4L: Add check for valid control ID to v4l2_ctrl_next
Content-Disposition: inline; filename=0016-V4L-Add-check-for-valid-control-ID-to-v4l2_ctrl_nex.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If v4l2_ctrl_next is called without the V4L2_CTRL_FLAG_NEXT_CTRL then it
should check whether the passed control ID is valid and return 0 if it
isn't. Otherwise a for-loop over the control IDs will never end.

(cherry picked from commit a46c5fbc6912c4e34cb7ded314249b639dc244a6)

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/media/video/v4l2-common.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index b87d571..31807ba 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -1499,16 +1499,25 @@ int v4l2_ctrl_query_menu(struct v4l2_querymenu *qmenu, struct v4l2_queryctrl *qc
    When no more controls are available 0 is returned. */
 u32 v4l2_ctrl_next(const u32 * const * ctrl_classes, u32 id)
 {
-	u32 ctrl_class;
+	u32 ctrl_class = V4L2_CTRL_ID2CLASS(id);
 	const u32 *pctrl;
 
-	/* if no query is desired, then just return the control ID */
-	if ((id & V4L2_CTRL_FLAG_NEXT_CTRL) == 0)
-		return id;
 	if (ctrl_classes == NULL)
 		return 0;
+
+	/* if no query is desired, then check if the ID is part of ctrl_classes */
+	if ((id & V4L2_CTRL_FLAG_NEXT_CTRL) == 0) {
+		/* find class */
+		while (*ctrl_classes && V4L2_CTRL_ID2CLASS(**ctrl_classes) != ctrl_class)
+			ctrl_classes++;
+		if (*ctrl_classes == NULL)
+			return 0;
+		pctrl = *ctrl_classes;
+		/* find control ID */
+		while (*pctrl && *pctrl != id) pctrl++;
+		return *pctrl ? id : 0;
+	}
 	id &= V4L2_CTRL_ID_MASK;
-	ctrl_class = V4L2_CTRL_ID2CLASS(id);
 	id++;	/* select next control */
 	/* find first class that matches (or is greater than) the class of
 	   the ID */
-- 
1.5.2.5

-- 
