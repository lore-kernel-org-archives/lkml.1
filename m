Return-Path: <linux-kernel-owner+w=401wt.eu-S1765728AbXHGU7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765728AbXHGU7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964834AbXHGUuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:50:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56257 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964805AbXHGUuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:50:15 -0400
Date: Tue, 7 Aug 2007 13:45:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [2.6.22.2 review 27/84] V4L: Add check for valid control ID to
	v4l2_ctrl_next
Message-ID: <20070807204503.GB23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-add-check-for-valid-control-id-to-v4l2_ctrl_next.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Hans Verkuil <hverkuil@xs4all.nl>

If v4l2_ctrl_next is called without the V4L2_CTRL_FLAG_NEXT_CTRL then it
should check whether the passed control ID is valid and return 0 if it
isn't. Otherwise a for-loop over the control IDs will never end.

(cherry picked from commit a46c5fbc6912c4e34cb7ded314249b639dc244a6)

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/v4l2-common.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -939,16 +939,25 @@ int v4l2_ctrl_query_menu(struct v4l2_que
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
