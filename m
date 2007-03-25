Return-Path: <linux-kernel-owner+w=401wt.eu-S1751612AbXCYTZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbXCYTZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbXCYTZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:25:55 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42853 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbXCYTZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:25:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 25 Mar 2007 21:24:43 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.20.4] ieee1394: dv1394: fix CardBus card ejection
To: stable@kernel.org
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.7af9edf7b7c51abd@s5r6.in-berlin.de>
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
Picked from 2.6.21-rc1.

 drivers/ieee1394/dv1394.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: linux-2.6.20.4/drivers/ieee1394/dv1394.c
===================================================================
--- linux-2.6.20.4.orig/drivers/ieee1394/dv1394.c
+++ linux-2.6.20.4/drivers/ieee1394/dv1394.c
@@ -2267,11 +2267,7 @@ static void dv1394_remove_host (struct h
 {
 	struct video_card *video;
 	unsigned long flags;
-	int id = host->id;
-
-	/* We only work with the OHCI-1394 driver */
-	if (strcmp(host->driver->name, OHCI1394_DRIVER_NAME))
-		return;
+	int id = host->id, found_ohci_card = 0;
 
 	/* find the corresponding video_cards */
 	do {
@@ -2284,6 +2280,7 @@ static void dv1394_remove_host (struct h
 			if ((tmp_vid->id >> 2) == id) {
 				list_del(&tmp_vid->list);
 				video = tmp_vid;
+				found_ohci_card = 1;
 				break;
 			}
 		}
@@ -2293,8 +2290,9 @@ static void dv1394_remove_host (struct h
 			dv1394_un_init(video);
 	} while (video != NULL);
 
-	class_device_destroy(hpsb_protocol_class,
-		MKDEV(IEEE1394_MAJOR, IEEE1394_MINOR_BLOCK_DV1394 * 16 + (id<<2)));
+	if (found_ohci_card)
+		class_device_destroy(hpsb_protocol_class, MKDEV(IEEE1394_MAJOR,
+				IEEE1394_MINOR_BLOCK_DV1394 * 16 + (id << 2)));
 }
 
 static void dv1394_add_host (struct hpsb_host *host)

-- 
Stefan Richter
-=====-=-=== --== ==--=
http://arcgraph.de/sr/

