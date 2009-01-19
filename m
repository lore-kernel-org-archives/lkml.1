Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbZASSU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbZASSU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbZASSUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:20:13 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35026 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZASSUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:20:11 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 19 Jan 2009 19:19:55 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: support for speeds greater than S800
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.33819bde6ef264d0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hard-wired configuration of the top speed (until now S800) was
unnecessary, remove it.

If the local link layer controller supports S1600 or S3200, we now
assume this speed for all present 1394b PHYs (except if they are
behind 1394a repeaters) until nodemgr figured out the actual speed
while fetching the config ROM.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Side note: drivers/firewire is already S3200 capable.

 drivers/ieee1394/ieee1394.h      |    4 +---
 drivers/ieee1394/ieee1394_core.c |   16 ++++++++--------
 2 files changed, 9 insertions(+), 11 deletions(-)

Index: linux/drivers/ieee1394/ieee1394.h
===================================================================
--- linux.orig/drivers/ieee1394/ieee1394.h
+++ linux/drivers/ieee1394/ieee1394.h
@@ -54,9 +54,7 @@
 #define IEEE1394_SPEED_800	0x03
 #define IEEE1394_SPEED_1600	0x04
 #define IEEE1394_SPEED_3200	0x05
-
-/* The current highest tested speed supported by the subsystem */
-#define IEEE1394_SPEED_MAX	IEEE1394_SPEED_800
+#define IEEE1394_SPEED_MAX	IEEE1394_SPEED_3200
 
 /* Maps speed values above to a string representation */
 extern const char *hpsb_speedto_str[];
Index: linux/drivers/ieee1394/ieee1394_core.c
===================================================================
--- linux.orig/drivers/ieee1394/ieee1394_core.c
+++ linux/drivers/ieee1394/ieee1394_core.c
@@ -338,6 +338,7 @@ static void build_speed_map(struct hpsb_
 	u8 cldcnt[nodecount];
 	u8 *map = host->speed_map;
 	u8 *speedcap = host->speed;
+	u8 local_link_speed = host->csr.lnk_spd;
 	struct selfid *sid;
 	struct ext_selfid *esid;
 	int i, j, n;
@@ -373,8 +374,8 @@ static void build_speed_map(struct hpsb_
 			if (sid->port2 == SELFID_PORT_CHILD) cldcnt[n]++;
 
 			speedcap[n] = sid->speed;
-			if (speedcap[n] > host->csr.lnk_spd)
-				speedcap[n] = host->csr.lnk_spd;
+			if (speedcap[n] > local_link_speed)
+				speedcap[n] = local_link_speed;
 			n--;
 		}
 	}
@@ -407,12 +408,11 @@ static void build_speed_map(struct hpsb_
 		}
 	}
 
-#if SELFID_SPEED_UNKNOWN != IEEE1394_SPEED_MAX
-	/* assume maximum speed for 1394b PHYs, nodemgr will correct it */
-	for (n = 0; n < nodecount; n++)
-		if (speedcap[n] == SELFID_SPEED_UNKNOWN)
-			speedcap[n] = IEEE1394_SPEED_MAX;
-#endif
+	/* assume a maximum speed for 1394b PHYs, nodemgr will correct it */
+	if (local_link_speed > SELFID_SPEED_UNKNOWN)
+		for (i = 0; i < nodecount; i++)
+			if (speedcap[i] == SELFID_SPEED_UNKNOWN)
+				speedcap[i] = local_link_speed;
 }
 
 

-- 
Stefan Richter
-=====-==--= ---= =--==
http://arcgraph.de/sr/

