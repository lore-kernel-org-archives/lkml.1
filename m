Return-Path: <linux-kernel-owner+w=401wt.eu-S1751738AbXA0M5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbXA0M5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 07:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbXA0M5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 07:57:22 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42228 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbXA0M5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 07:57:22 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 27 Jan 2007 13:52:52 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/2] ieee1394: dv1394: fix CardBus card ejection
To: Pieter Palmers <pieterp@joow.be>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <45BB1F42.4000404@s5r6.in-berlin.de>
Message-ID: <tkrat.dbcf96797342e52f@s5r6.in-berlin.de>
References: <45BA743B.2080401@joow.be> <45BA85A1.1030707@s5r6.in-berlin.de>
 <45BB106E.706@joow.be> <45BB14A7.6040400@s5r6.in-berlin.de>
 <45BB18DE.1090802@joow.be> <45BB1F42.4000404@s5r6.in-berlin.de>
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
 drivers/ieee1394/dv1394.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

Index: linux-2.6.20-rc6/drivers/ieee1394/dv1394.c
===================================================================
--- linux-2.6.20-rc6.orig/drivers/ieee1394/dv1394.c	2007-01-27 13:28:39.000000000 +0100
+++ linux-2.6.20-rc6/drivers/ieee1394/dv1394.c	2007-01-27 13:30:05.000000000 +0100
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
+			   IEEE1394_MINOR_BLOCK_DV1394 * 16 + (host->id << 2)));
 }
 
 static void dv1394_add_host (struct hpsb_host *host)


-- 
Stefan Richter
-=====-=-=== ---= ==-==
http://arcgraph.de/sr/

