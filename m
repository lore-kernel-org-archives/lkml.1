Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab0CEULA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:11:00 -0500
Received: from mamba.crocodile.org ([216.218.215.112]:57625 "EHLO
	periplum.crocodile.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755743Ab0CEUK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:10:59 -0500
X-Greylist: delayed 1410 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Mar 2010 15:10:58 EST
From: Vadim Zaliva <lord@crocodile.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 1/1] integer overflow issue in 'appletouch' driver
Date: Fri, 5 Mar 2010 11:47:14 -0800
Message-Id: <E64899AA-23A5-49D7-8C91-B94A095290E0@crocodile.org>
Cc: linux-kernel@vger.kernel.org
To: Johannes Berg <johannes@sipsolutions.net>
Mime-Version: 1.0 (Apple Message framework v1077)
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patch is fixing an integer overflow issue in 'appletouch' driver.

In particular, reading data from Geyser 2 touchpads used on post Oct
2005 Apple PowerBooks the driver was casting X and Y coordinates
values to 'signed char'. Testing on one of such PowerBooks I have
noticed that touchpad always generates positive values, but some of
them are greater that 127, and thus, when cast to 'signed char' being
interpreted as a negative.

Such bigger values have been observed infrequently, closer to the
edges of a touchpad, so the problem was not very visible. 
Nevertheless, the patch would potentially improve touchpad
driver accuracy.


diff -uNr linux-source-2.6.31.orig/drivers/input/mouse/appletouch.c linux-source-2.6.31/drivers/input/mouse/appletouch.c
--- linux-source-2.6.31.orig/drivers/input/mouse/appletouch.c	2009-09-09 15:13:59.000000000 -0700
+++ linux-source-2.6.31/drivers/input/mouse/appletouch.c	2010-03-05 11:05:11.921394055 -0800
@@ -205,8 +205,8 @@
 	bool			overflow_warned;
 	int			x_old;		/* last reported x/y, */
 	int			y_old;		/* used for smoothing */
-	signed char		xy_cur[ATP_XSENSORS + ATP_YSENSORS];
-	signed char		xy_old[ATP_XSENSORS + ATP_YSENSORS];
+	u8		    xy_cur[ATP_XSENSORS + ATP_YSENSORS];
+	u8		    xy_old[ATP_XSENSORS + ATP_YSENSORS];
 	int			xy_acc[ATP_XSENSORS + ATP_YSENSORS];
 	int			idlecount;	/* number of empty packets */
 	struct work_struct	work;
@@ -531,7 +531,7 @@
 
 	for (i = 0; i < ATP_XSENSORS + ATP_YSENSORS; i++) {
 		/* accumulate the change */
-		signed char change = dev->xy_old[i] - dev->xy_cur[i];
+		int change = dev->xy_old[i] - dev->xy_cur[i];
 		dev->xy_acc[i] -= change;
 
 		/* prevent down drifting */


