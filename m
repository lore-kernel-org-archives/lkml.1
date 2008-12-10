Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbYLJQnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbYLJQnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbYLJQnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:43:03 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:52590 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758209AbYLJQnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:43:01 -0500
Date: Wed, 10 Dec 2008 17:42:58 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, vt8231@hiddenengine.co.uk,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 27/28] drivers/hwmon/vt8231.c: Drop return value from
 platform_driver remove functions
Message-ID: <Pine.LNX.4.64.0812101742380.21998@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The return value of the remove function of a driver structure, and thus of
a platform_driver structure, is ultimately ignored, and is thus
unnecessary.  This patch removes the return value for the remove function
stored in a platform_driver structure.  For the files in this patch, the
return values are always 0.

A simplified version of the semantic patch that makes this change is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r@
struct platform_driver I;
identifier a,f;
position p;
@@
I.remove = \(f@p\|a(f@p)\);

@void_called@
identifier r.f;
position p;
@@
f@p(...);

@called@
identifier r.f;
position p1 != void_called.p;
@@
f@p1(...)

@localfn@
identifier r.f;
@@
static int f(...) { ... }

@depends on !called && localfn@
struct platform_driver I;
identifier a,f;
position r.p;
@@

I.
- remove
+ remove_new
   = \(f@p\|a(f@p)\);

@depends on !called && localfn@
identifier r.f,i;
constant C;
expression E;
@@

- int
+ void
       f(...) {
  <...
(
-  return \(C\|i\);
+  return;
|
-  return E;
+  E;
+  return;
)
  ...>
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/hwmon/vt8231.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/vt8231.c b/drivers/hwmon/vt8231.c
index 5bc5727..39cb37b 100644
--- a/drivers/hwmon/vt8231.c
+++ b/drivers/hwmon/vt8231.c
@@ -167,7 +167,7 @@ struct vt8231_data {
 
 static struct pci_dev *s_bridge;
 static int vt8231_probe(struct platform_device *pdev);
-static int __devexit vt8231_remove(struct platform_device *pdev);
+static void __devexit vt8231_remove(struct platform_device *pdev);
 static struct vt8231_data *vt8231_update_device(struct device *dev);
 static void vt8231_init_device(struct vt8231_data *data);
 
@@ -693,7 +693,7 @@ static struct platform_driver vt8231_driver = {
 		.name	= "vt8231",
 	},
 	.probe	= vt8231_probe,
-	.remove	= __devexit_p(vt8231_remove),
+	.remove_new = __devexit_p(vt8231_remove),
 };
 
 static struct pci_device_id vt8231_pci_ids[] = {
@@ -787,7 +787,7 @@ exit_release:
 	return err;
 }
 
-static int __devexit vt8231_remove(struct platform_device *pdev)
+static void __devexit vt8231_remove(struct platform_device *pdev)
 {
 	struct vt8231_data *data = platform_get_drvdata(pdev);
 	int i;
@@ -805,7 +805,6 @@ static int __devexit vt8231_remove(struct platform_device *pdev)
 	release_region(data->addr, VT8231_EXTENT);
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
-	return 0;
 }
 
 static void vt8231_init_device(struct vt8231_data *data)
