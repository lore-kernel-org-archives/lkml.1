Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbYCXSLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbYCXSLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761023AbYCXSKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:10:55 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:43774 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbYCXSKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:10:54 -0400
Date: Mon, 24 Mar 2008 19:10:51 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: rubini@vision.unipv.it, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/5] drivers/misc: elide a non-zero test on a result that is
 never 0
Message-ID: <Pine.LNX.4.64.0803241910080.32740@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The function thermal_cooling_device_register always returns either a valid
pointer or a value made with ERR_PTR, so a test for non-zero on the result
will always succeed.


The problem was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

//<smpl>
@a@
expression E, E1;
statement S,S1;
position p;
@@

E = thermal_cooling_device_register(...)
... when != E = E1
if@p (E) S else S1

@n@
position a.p;
expression E,E1;
statement S,S1;
@@

E = NULL
... when != E = E1
if@p (E) S else S1

@depends on !n@
expression E;
statement S,S1;
position a.p;
@@

* if@p (E)
  S else S1
//</smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/misc/intel_menlow.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff -u -p a/drivers/misc/intel_menlow.c b/drivers/misc/intel_menlow.c
--- a/drivers/misc/intel_menlow.c	2008-03-12 14:13:13.000000000 +0100
+++ b/drivers/misc/intel_menlow.c	2008-03-24 16:18:06.000000000 +0100
@@ -175,19 +175,17 @@ static int intel_menlow_memory_add(struc
 		goto end;
 	}
 
-	if (cdev) {
-		acpi_driver_data(device) = cdev;
-		result = sysfs_create_link(&device->dev.kobj,
-					&cdev->device.kobj, "thermal_cooling");
-		if (result)
-			goto unregister;
-
-		result = sysfs_create_link(&cdev->device.kobj,
-					&device->dev.kobj, "device");
-		if (result) {
-			sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
-			goto unregister;
-		}
+	acpi_driver_data(device) = cdev;
+	result = sysfs_create_link(&device->dev.kobj,
+				&cdev->device.kobj, "thermal_cooling");
+	if (result)
+		goto unregister;
+
+	result = sysfs_create_link(&cdev->device.kobj,
+				&device->dev.kobj, "device");
+	if (result) {
+		sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
+		goto unregister;
 	}
 
  end:
