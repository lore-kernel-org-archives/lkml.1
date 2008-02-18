Return-Path: <linux-kernel-owner+w=401wt.eu-S1760877AbYBRULt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbYBRULt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYBRULl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:11:41 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39062 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbYBRULk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:11:40 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 18 Feb 2008 21:11:07 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: prevent device binding of raw1394, video1394,
 dv1394
To: linux1394-devel@lists.sourceforge.net
cc: Ben Backx <ben@bbackx.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47B9DD08.5000206@s5r6.in-berlin.de>
Message-ID: <tkrat.5595a80fa6bc4dfa@s5r6.in-berlin.de>
References: <005901c84e54$20382930$60a87b90$@com>
 <477D690B.8040509@s5r6.in-berlin.de> <004801c84ed4$6dbec030$493c4090$@com>
 <477E4F2F.4020804@s5r6.in-berlin.de> <009601c84f1a$386b9de0$a942d9a0$@com>
 <477EB3C5.4030004@s5r6.in-berlin.de> <006501c8529e$3ce721f0$b6b565d0$@com>
 <47852FF0.1070609@s5r6.in-berlin.de> <002201c86f26$b4e6e3d0$1eb4ab70$@com>
 <47B57A6A.8020902@s5r6.in-berlin.de> <000f01c8720f$18430360$48c90a20$@com>
 <47B968D3.7090002@s5r6.in-berlin.de> <003d01c8723f$7bff63a0$73fe2ae0$@com>
 <47B9C141.1070108@s5r6.in-berlin.de> <000601c87260$41507d40$c3f177c0$@com>
 <47B9DD08.5000206@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These drivers don't need to match any unit_directory type device.
They just need the id_table for module autoloading per module alias.

Not binding any of these drivers allows special-purpose drivers with
similar or same IDs to bind to devices.  This currently only benefits
out-of-tree drivers; on the other hand it is in no way detrimental to
in-tree drivers.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/dv1394.c    |    3 +--
 drivers/ieee1394/nodemgr.c   |    6 +++++-
 drivers/ieee1394/raw1394.c   |    1 -
 drivers/ieee1394/video1394.c |    3 +--
 4 files changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6.25-rc2/drivers/ieee1394/raw1394.c
===================================================================
--- linux-2.6.25-rc2.orig/drivers/ieee1394/raw1394.c
+++ linux-2.6.25-rc2/drivers/ieee1394/raw1394.c
@@ -2959,7 +2959,6 @@ MODULE_DEVICE_TABLE(ieee1394, raw1394_id
 
 static struct hpsb_protocol_driver raw1394_driver = {
 	.name = "raw1394",
-	.id_table = raw1394_id_table,
 };
 
 /******************************************************************************/
Index: linux-2.6.25-rc2/drivers/ieee1394/video1394.c
===================================================================
--- linux-2.6.25-rc2.orig/drivers/ieee1394/video1394.c
+++ linux-2.6.25-rc2/drivers/ieee1394/video1394.c
@@ -1315,8 +1315,7 @@ static struct ieee1394_device_id video13
 MODULE_DEVICE_TABLE(ieee1394, video1394_id_table);
 
 static struct hpsb_protocol_driver video1394_driver = {
-	.name		= VIDEO1394_DRIVER_NAME,
-	.id_table	= video1394_id_table,
+	.name = VIDEO1394_DRIVER_NAME,
 };
 
 
Index: linux-2.6.25-rc2/drivers/ieee1394/dv1394.c
===================================================================
--- linux-2.6.25-rc2.orig/drivers/ieee1394/dv1394.c
+++ linux-2.6.25-rc2/drivers/ieee1394/dv1394.c
@@ -2179,8 +2179,7 @@ static struct ieee1394_device_id dv1394_
 MODULE_DEVICE_TABLE(ieee1394, dv1394_id_table);
 
 static struct hpsb_protocol_driver dv1394_driver = {
-	.name		= "dv1394",
-	.id_table	= dv1394_id_table,
+	.name = "dv1394",
 };
 
 
Index: linux-2.6.25-rc2/drivers/ieee1394/nodemgr.c
===================================================================
--- linux-2.6.25-rc2.orig/drivers/ieee1394/nodemgr.c
+++ linux-2.6.25-rc2/drivers/ieee1394/nodemgr.c
@@ -701,7 +701,11 @@ static int nodemgr_bus_match(struct devi
 		return 0;
 
 	driver = container_of(drv, struct hpsb_protocol_driver, driver);
-	for (id = driver->id_table; id->match_flags != 0; id++) {
+	id = driver->id_table;
+	if (!id)
+		return 0;
+
+	for (; id->match_flags != 0; id++) {
 		if ((id->match_flags & IEEE1394_MATCH_VENDOR_ID) &&
 		    id->vendor_id != ud->vendor_id)
 			continue;

-- 
Stefan Richter
-=====-==--- --=- =--=-
http://arcgraph.de/sr/

