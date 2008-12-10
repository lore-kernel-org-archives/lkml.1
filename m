Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYLJQgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYLJQgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbYLJQfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:35:52 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:38123 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbYLJQfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:35:51 -0500
Date: Wed, 10 Dec 2008 17:35:48 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, axboe@kernel.dk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 11/28] drivers/cdrom: Drop return value from platform_driver
 remove functions
Message-ID: <Pine.LNX.4.64.0812101735260.21998@ask.diku.dk>
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
 drivers/cdrom/gdrom.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 2eecb77..9aaec3c 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -826,7 +826,7 @@ probe_fail_no_mem:
 	return err;
 }
 
-static int __devexit remove_gdrom(struct platform_device *devptr)
+static void __devexit remove_gdrom(struct platform_device *devptr)
 {
 	flush_scheduled_work();
 	blk_cleanup_queue(gd.gdrom_rq);
@@ -836,13 +836,11 @@ static int __devexit remove_gdrom(struct platform_device *devptr)
 	if (gdrom_major)
 		unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
 	unregister_cdrom(gd.cd_info);
-
-	return 0;
 }
 
 static struct platform_driver gdrom_driver = {
 	.probe = probe_gdrom,
-	.remove = __devexit_p(remove_gdrom),
+	.remove_new = __devexit_p(remove_gdrom),
 	.driver = {
 			.name = GDROM_DEV_NAME,
 	},
