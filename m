Return-Path: <linux-kernel-owner+w=401wt.eu-S965437AbXBFBU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965437AbXBFBU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 20:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965435AbXBFBU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 20:20:27 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53711 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965437AbXBFBU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 20:20:26 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 6 Feb 2007 02:20:06 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] ieee1394: fix host device registering when nodemgr
 disabled
To: Robert Crocombe <rcrocomb@gmail.com>
cc: linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <tkrat.064c609db01a3918@s5r6.in-berlin.de>
Message-ID: <tkrat.e12859f4e3703b6b@s5r6.in-berlin.de>
References: <e6babb600702051521l4a08eb2dw2a7f423fd0d7edd7@mail.gmail.com>
 <tkrat.c39467d7194502c4@s5r6.in-berlin.de>
 <tkrat.f2510ec744e6b5c8@s5r6.in-berlin.de>
 <tkrat.064c609db01a3918@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since my commit 8252bbb1363b7fe963a3eb6f8a36da619a6f5a65 in 2.6.20-rc1,
host devices have a dummy driver attached.  Alas the driver was not
registered before use if ieee1394 was loaded with disable_nodemgr=1.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Update:  - work without extern variables,
         - better error checks,
	 - add missing driver_unregister.

 drivers/ieee1394/nodemgr.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

Index: linux-2.6.20-rc5/drivers/ieee1394/nodemgr.c
===================================================================
--- linux-2.6.20-rc5.orig/drivers/ieee1394/nodemgr.c
+++ linux-2.6.20-rc5/drivers/ieee1394/nodemgr.c
@@ -258,7 +258,6 @@ static struct device_driver nodemgr_mid_
 struct device nodemgr_dev_template_host = {
 	.bus		= &ieee1394_bus_type,
 	.release	= nodemgr_release_host,
-	.driver		= &nodemgr_mid_layer_driver,
 };
 
 
@@ -1850,22 +1849,33 @@ int init_ieee1394_nodemgr(void)
 
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
+
+	/* don't show this driver if nodemgr is off (disable_nodmgr=1) */
+	nodemgr_dev_template_host.driver = &nodemgr_mid_layer_driver;
+
 	error = driver_register(&nodemgr_mid_layer_driver);
+	if (error)
+		goto fail_ml;
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
-=====-=-=== --=- --==-
http://arcgraph.de/sr/

