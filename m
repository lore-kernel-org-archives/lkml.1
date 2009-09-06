Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbZIFTB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbZIFTB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 15:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758238AbZIFTBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 15:01:55 -0400
Received: from mail.pxnet.com ([195.227.45.7]:42884 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758213AbZIFS7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 14:59:38 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 04/12] gigaset: handle isoc frame errors more gracefully
To: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       i4ldeveloper@listserv.isdn4linux.de
CC: Hansjoerg Lipp <hjlipp@web.de>
Message-ID: <20090906-patch-gigaset-04.tilman@imap.cc>
In-Reply-To: <20090906-patch-gigaset-00.tilman@imap.cc>
References: <20090906-patch-gigaset-00.tilman@imap.cc>
Date: Sun,  6 Sep 2009 20:58:52 +0200 (CEST)
X-Spam-Score: -1.653 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't drop the remainder of an URB if an isochronous frame has an error.

Impact: error handling improvement
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/bas-gigaset.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
index 781c404..9e7108a 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -1331,28 +1331,24 @@ static void read_iso_tasklet(unsigned long data)
 		rcvbuf = urb->transfer_buffer;
 		totleft = urb->actual_length;
 		for (frame = 0; totleft > 0 && frame < BAS_NUMFRAMES; frame++) {
-			if (unlikely(urb->iso_frame_desc[frame].status)) {
+			numbytes = urb->iso_frame_desc[frame].actual_length;
+			if (unlikely(urb->iso_frame_desc[frame].status))
 				dev_warn(cs->dev,
-					 "isochronous read: frame %d: %s\n",
-					 frame,
+					 "isochronous read: frame %d[%d]: %s\n",
+					 frame, numbytes,
 					 get_usb_statmsg(
 					    urb->iso_frame_desc[frame].status));
-				break;
-			}
-			numbytes = urb->iso_frame_desc[frame].actual_length;
-			if (unlikely(numbytes > BAS_MAXFRAME)) {
+			if (unlikely(numbytes > BAS_MAXFRAME))
 				dev_warn(cs->dev,
 					 "isochronous read: frame %d: "
 					 "numbytes (%d) > BAS_MAXFRAME\n",
 					 frame, numbytes);
-				break;
-			}
 			if (unlikely(numbytes > totleft)) {
 				dev_warn(cs->dev,
 					 "isochronous read: frame %d: "
 					 "numbytes (%d) > totleft (%d)\n",
 					 frame, numbytes, totleft);
-				break;
+				numbytes = totleft;
 			}
 			offset = urb->iso_frame_desc[frame].offset;
 			if (unlikely(offset + numbytes > BAS_INBUFSIZE)) {
@@ -1361,7 +1357,7 @@ static void read_iso_tasklet(unsigned long data)
 					 "offset (%d) + numbytes (%d) "
 					 "> BAS_INBUFSIZE\n",
 					 frame, offset, numbytes);
-				break;
+				numbytes = BAS_INBUFSIZE - offset;
 			}
 			gigaset_isoc_receive(rcvbuf + offset, numbytes, bcs);
 			totleft -= numbytes;
-- 
1.6.2.1.214.ge986c

