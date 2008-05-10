Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbYEJR7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbYEJR7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 13:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbYEJR7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 13:59:30 -0400
Received: from lx1.pxnet.com ([195.227.45.3]:42309 "EHLO lx1.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491AbYEJR73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 13:59:29 -0400
From: Tilman Schmidt <tilman@imap.cc>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ISDN4Linux Developer Mailing List 
	<i4ldeveloper@listserv.isdn4linux.de>
CC: Hansjoerg Lipp <hjlipp@web.de>, Roel Kluin <12o3l@tiscali.nl>
Subject: [PATCH] gigaset: gigaset_isowbuf_getbytes() may return signed unnoticed
Message-Id: <20080510175234.6927811006C@xenon.ts.pxnet.com>
Date: Sat, 10 May 2008 19:52:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ifd->offset is unsigned. gigaset_isowbuf_getbytes() may return signed unnoticed.
Revised version of patch originally submitted by Roel Kluin <12o3l@tiscali.nl>.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/bas-gigaset.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
index 5255b5e..3f11910 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -1050,10 +1050,9 @@ static int submit_iso_write_urb(struct isow_urbctx_t *ucx)
 		}
 
 		/* retrieve block of data to send */
-		ifd->offset = gigaset_isowbuf_getbytes(ubc->isooutbuf,
-						       ifd->length);
-		if (ifd->offset < 0) {
-			if (ifd->offset == -EBUSY) {
+		rc = gigaset_isowbuf_getbytes(ubc->isooutbuf, ifd->length);
+		if (rc < 0) {
+			if (rc == -EBUSY) {
 				gig_dbg(DEBUG_ISO,
 					"%s: buffer busy at frame %d",
 					__func__, nframe);
@@ -1062,11 +1061,12 @@ static int submit_iso_write_urb(struct isow_urbctx_t *ucx)
 			} else {
 				dev_err(ucx->bcs->cs->dev,
 					"%s: buffer error %d at frame %d\n",
-					__func__, ifd->offset, nframe);
-				return ifd->offset;
+					__func__, rc, nframe);
+				return rc;
 			}
 			break;
 		}
+		ifd->offset = rc;
 		ucx->limit = ubc->isooutbuf->nextread;
 		ifd->status = 0;
 		ifd->actual_length = 0;
-- 
1.5.4.7.gd8534-dirty

