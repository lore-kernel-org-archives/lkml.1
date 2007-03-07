Return-Path: <linux-kernel-owner+w=401wt.eu-S1422867AbXCGRsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422867AbXCGRsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422806AbXCGROx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:14:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422783AbXCGROP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:15 -0500
Message-Id: <20070307171235.995885617@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 024/101] ieee1394: fix host device registering when nodemgr disabled
Content-Disposition: inline; filename=ieee1394-fix-host-device-registering-when-nodemgr-disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Since my commit 8252bbb1363b7fe963a3eb6f8a36da619a6f5a65 in 2.6.20-rc1,
host devices have a dummy driver attached.  Alas the driver was not
registered before use if ieee1394 was loaded with disable_nodemgr=1.

This resulted in non-functional FireWire drivers or kernel lockup.
http://bugzilla.kernel.org/show_bug.cgi?id=7942

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ieee1394/nodemgr.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- linux-2.6.20.1.orig/drivers/ieee1394/nodemgr.c
+++ linux-2.6.20.1/drivers/ieee1394/nodemgr.c
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
