Return-Path: <linux-kernel-owner+w=401wt.eu-S1765833AbXHGVAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765833AbXHGVAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbXHGUu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:50:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56275 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964891AbXHGUuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:50:25 -0400
Date: Tue, 7 Aug 2007 13:45:07 -0700
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
Subject: [2.6.22.2 review 28/84] V4L: ivtv: fix broken VBI output support
Message-ID: <20070807204506.GC23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-ivtv-fix-broken-vbi-output-support.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Hans Verkuil <hverkuil@xs4all.nl>

The old service_set_out setting was still tested, even though it no longer
was ever set and was in fact obsolete. This meant that everything that was
written to /dev/vbi16 was ignored. Removed the service_set_out variable
altogether and now it works again.

(cherry picked from commit 47fd3ba9fc62d23a985f4969719c3091438d21c5)

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/ivtv/ivtv-driver.h |    1 -
 drivers/media/video/ivtv/ivtv-vbi.c    |   31 +++++++++++--------------------
 2 files changed, 11 insertions(+), 21 deletions(-)

--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -650,7 +650,6 @@ struct vbi_info {
 	/* convenience pointer to sliced struct in vbi_in union */
 	struct v4l2_sliced_vbi_format *sliced_in;
 	u32 service_set_in;
-	u32 service_set_out;
 	int insert_mpeg;
 
 	/* Buffer for the maximum of 2 * 18 * packet_size sliced VBI lines.
--- a/drivers/media/video/ivtv/ivtv-vbi.c
+++ b/drivers/media/video/ivtv/ivtv-vbi.c
@@ -219,31 +219,23 @@ ssize_t ivtv_write_vbi(struct ivtv *itv,
 	int found_cc = 0;
 	int cc_pos = itv->vbi.cc_pos;
 
-	if (itv->vbi.service_set_out == 0)
-		return -EPERM;
-
 	while (count >= sizeof(struct v4l2_sliced_vbi_data)) {
 		switch (p->id) {
 		case V4L2_SLICED_CAPTION_525:
-			if (p->id == V4L2_SLICED_CAPTION_525 &&
-			    p->line == 21 &&
-			    (itv->vbi.service_set_out &
-				V4L2_SLICED_CAPTION_525) == 0) {
-				break;
-			}
-			found_cc = 1;
-			if (p->field) {
-				cc[2] = p->data[0];
-				cc[3] = p->data[1];
-			} else {
-				cc[0] = p->data[0];
-				cc[1] = p->data[1];
+			if (p->line == 21) {
+				found_cc = 1;
+				if (p->field) {
+					cc[2] = p->data[0];
+					cc[3] = p->data[1];
+				} else {
+					cc[0] = p->data[0];
+					cc[1] = p->data[1];
+				}
 			}
 			break;
 
 		case V4L2_SLICED_VPS:
-			if (p->line == 16 && p->field == 0 &&
-			    (itv->vbi.service_set_out & V4L2_SLICED_VPS)) {
+			if (p->line == 16 && p->field == 0) {
 				itv->vbi.vps[0] = p->data[2];
 				itv->vbi.vps[1] = p->data[8];
 				itv->vbi.vps[2] = p->data[9];
@@ -255,8 +247,7 @@ ssize_t ivtv_write_vbi(struct ivtv *itv,
 			break;
 
 		case V4L2_SLICED_WSS_625:
-			if (p->line == 23 && p->field == 0 &&
-			    (itv->vbi.service_set_out & V4L2_SLICED_WSS_625)) {
+			if (p->line == 23 && p->field == 0) {
 				/* No lock needed for WSS */
 				itv->vbi.wss = p->data[0] | (p->data[1] << 8);
 				itv->vbi.wss_found = 1;

-- 
