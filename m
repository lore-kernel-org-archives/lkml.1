Return-Path: <linux-kernel-owner+w=401wt.eu-S933624AbZJFWT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624AbZJFWT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933596AbZJFWT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:19:27 -0400
Received: from mail.pxnet.com ([195.227.45.7]:41023 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933593AbZJFWTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:19:24 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 03/11] gigaset: handle isoc frame errors more gracefully
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <isdn@linux-pingi.de>,
       Karsten Keil <keil@b1-systems.de>, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de
Message-ID: <20091006-patch-gigaset-03.tilman@imap.cc>
In-Reply-To: <20091006-patch-gigaset-00.tilman@imap.cc>
References: <20091006-patch-gigaset-00.tilman@imap.cc>
Date: Wed,  7 Oct 2009 00:18:36 +0200 (CEST)
X-Spam-Score: -2.126 () AWL,BAYES_00,RDNS_NONE
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

