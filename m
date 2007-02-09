Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbXBIXqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbXBIXqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXBIXqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:46:13 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44634 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbXBIXqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:46:13 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 10 Feb 2007 00:44:44 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [stable patch 2.6.20 3/3] ieee1394: fix host device registering when
 nodemgr disabled
To: stable@kernel.org
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.c5f99af899e152d1@s5r6.in-berlin.de>
Message-ID: <tkrat.46b3d35bbcfb07d9@s5r6.in-berlin.de>
References: <tkrat.3758c666718465a8@s5r6.in-berlin.de>
 <tkrat.c5f99af899e152d1@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Tue, 6 Feb 2007 02:34:45 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Since my commit 8252bbb1363b7fe963a3eb6f8a36da619a6f5a65 in 2.6.20-rc1,
host devices have a dummy driver attached.  Alas the driver was not
registered before use if ieee1394 was loaded with disable_nodemgr=1.

This resulted in non-functional FireWire drivers or kernel lockup.
http://bugzilla.kernel.org/show_bug.cgi?id=7942

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/nodemgr.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

same as commit 91efa462054d44ae52b0c6c8325ed5e899f2cd17 in linux-2.6.20-git#

(Side note:  The parameter disable_nodemgr=1 is merely an optional
tuning parameter for people who know what they are doing and who don't
need device discovery and bus management.)

Index: linux-2.6.20/drivers/ieee1394/nodemgr.c
===================================================================
--- linux-2.6.20.orig/drivers/ieee1394/nodemgr.c
+++ linux-2.6.20/drivers/ieee1394/nodemgr.c
@@ -274,7 +274,6 @@ static struct device_driver nodemgr_mid_
 struct device nodemgr_dev_template_host = {
 	.bus		= &ieee1394_bus_type,
 	.release	= nodemgr_release_host,
-	.driver		= &nodemgr_mid_layer_driver,
 };
 
 
@@ -1889,22 +1888,31 @@ int init_ieee1394_nodemgr(void)
 
 	error = class_register(&nodemgr_ne_class);
 	if (error)
-		return error;
-
+		goto fail_ne;
 	error = class_register(&nodemgr_ud_class);
-	if (error) {
-		class_unregister(&nodemgr_ne_class);
-		return error;
-	}
+	if (error)
+		goto fail_ud;
 	error = driver_register(&nodemgr_mid_layer_driver);
+	if (error)
+		goto fail_ml;
+	/* This driver is not used if nodemgr is off (disable_nodemgr=1). */
+	nodemgr_dev_template_host.driver = &nodemgr_mid_layer_driver;
+
 	hpsb_register_highlevel(&nodemgr_highlevel);
 	return 0;
+
+fail_ml:
+	class_unregister(&nodemgr_ud_class);
+fail_ud:
+	class_unregister(&nodemgr_ne_class);
+fail_ne:
+	return error;
 }
 
 void cleanup_ieee1394_nodemgr(void)
 {
 	hpsb_unregister_highlevel(&nodemgr_highlevel);
-
+	driver_unregister(&nodemgr_mid_layer_driver);
 	class_unregister(&nodemgr_ud_class);
 	class_unregister(&nodemgr_ne_class);
 }


-- 
Stefan Richter
-=====-=-=== --=- -=-=-
http://arcgraph.de/sr/

