Return-Path: <linux-kernel-owner+w=401wt.eu-S1752211AbXCYT0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbXCYT0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbXCYT0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:26:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42880 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbXCYT0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:26:19 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 25 Mar 2007 21:26:05 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.16.44] ieee1394: dv1394: fix CardBus card ejection
To: Adrian Bunk <bunk@stusta.de>
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.7af9edf7b7c51abd@s5r6.in-berlin.de>
Message-ID: <tkrat.24b1704ea6395e8c@s5r6.in-berlin.de>
References: <tkrat.7af9edf7b7c51abd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix NULL pointer dereference on hot ejection of a FireWire card while
dv1394 was loaded.  http://bugzilla.kernel.org/show_bug.cgi?id=7121
I did not test card ejection with open /dev/dv1394 files yet.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Backport from 2.6.21-rc1.

 drivers/ieee1394/dv1394.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

Index: linux-2.6.16.44/drivers/ieee1394/dv1394.c
===================================================================
--- linux-2.6.16.44.orig/drivers/ieee1394/dv1394.c
+++ linux-2.6.16.44/drivers/ieee1394/dv1394.c
@@ -2303,18 +2303,11 @@ static void dv1394_un_init(struct video_
 
 static void dv1394_remove_host (struct hpsb_host *host)
 {
-	struct video_card *video;
+	struct video_card *video, *tmp_vid;
 	unsigned long flags;
-	int id = host->id;
-
-	/* We only work with the OHCI-1394 driver */
-	if (strcmp(host->driver->name, OHCI1394_DRIVER_NAME))
-		return;
+	int id = host->id, found_ohci_card = 0;
 
-	/* find the corresponding video_cards */
 	do {
-		struct video_card *tmp_vid;
-
 		video = NULL;
 
 		spin_lock_irqsave(&dv1394_cards_lock, flags);
@@ -2322,6 +2315,7 @@ static void dv1394_remove_host (struct h
 			if ((tmp_vid->id >> 2) == id) {
 				list_del(&tmp_vid->list);
 				video = tmp_vid;
+				found_ohci_card = 1;
 				break;
 			}
 		}
@@ -2329,7 +2323,10 @@ static void dv1394_remove_host (struct h
 
 		if (video)
 			dv1394_un_init(video);
-	} while (video != NULL);
+	} while (video);
+
+	if (!found_ohci_card)
+		return;
 
 	class_device_destroy(hpsb_protocol_class,
 		MKDEV(IEEE1394_MAJOR, IEEE1394_MINOR_BLOCK_DV1394 * 16 + (id<<2)));

-- 
Stefan Richter
-=====-=-=== --== ==--=
http://arcgraph.de/sr/

