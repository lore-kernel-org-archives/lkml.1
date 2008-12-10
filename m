Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbYLJQ3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbYLJQ3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbYLJQ3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:29:42 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:54171 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbYLJQ3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:29:41 -0500
Date: Wed, 10 Dec 2008 17:29:38 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, Douglas_Warzecha@dell.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 7/28] drivers/firmware/dcdbas.c: Drop return value from
 platform_driver remove functions
Message-ID: <Pine.LNX.4.64.0812101729160.21998@ask.diku.dk>
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
 drivers/firmware/dcdbas.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 50a071f..097e685 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -567,7 +567,7 @@ static int __devinit dcdbas_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int __devexit dcdbas_remove(struct platform_device *dev)
+static void __devexit dcdbas_remove(struct platform_device *dev)
 {
 	int i;
 
@@ -575,8 +575,6 @@ static int __devexit dcdbas_remove(struct platform_device *dev)
 	for (i = 0; dcdbas_bin_attrs[i]; i++)
 		sysfs_remove_bin_file(&dev->dev.kobj, dcdbas_bin_attrs[i]);
 	sysfs_remove_group(&dev->dev.kobj, &dcdbas_attr_group);
-
-	return 0;
 }
 
 static struct platform_driver dcdbas_driver = {
@@ -585,7 +583,7 @@ static struct platform_driver dcdbas_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= dcdbas_probe,
-	.remove		= __devexit_p(dcdbas_remove),
+	.remove_new	= __devexit_p(dcdbas_remove),
 };
 
 /**
