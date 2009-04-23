Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbZDWHoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbZDWHoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756567AbZDWHbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:31:05 -0400
Received: from sous-sol.org ([216.99.217.87]:50547 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756547AbZDWHbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:31:01 -0400
Message-Id: <20090423072525.268394684@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alasdair G Kergon <agk@redhat.com>,
       Neil Brown <neilb@suse.de>
Subject: [patch 043/100] dm table: fix upgrade mode race
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=dm-table-fix-upgrade-mode-race.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Alasdair G Kergon <agk@redhat.com>

upstream commit: 570b9d968bf9b16974252ef7cbce73fa6dac34f3

upgrade_mode() sets bdev to NULL temporarily, and does not have any
locking to exclude anything from seeing that NULL.

In dm_table_any_congested() bdev_get_queue() can dereference that NULL and
cause a reported oops.

Fix this by not changing that field during the mode upgrade.

Cc: stable@kernel.org
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/dm-table.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -399,28 +399,30 @@ static int check_device_area(struct dm_d
 }
 
 /*
- * This upgrades the mode on an already open dm_dev.  Being
+ * This upgrades the mode on an already open dm_dev, being
  * careful to leave things as they were if we fail to reopen the
- * device.
+ * device and not to touch the existing bdev field in case
+ * it is accessed concurrently inside dm_table_any_congested().
  */
 static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
 			struct mapped_device *md)
 {
 	int r;
-	struct dm_dev_internal dd_copy;
-	dev_t dev = dd->dm_dev.bdev->bd_dev;
+	struct dm_dev_internal dd_new, dd_old;
 
-	dd_copy = *dd;
+	dd_new = dd_old = *dd;
+
+	dd_new.dm_dev.mode |= new_mode;
+	dd_new.dm_dev.bdev = NULL;
+
+	r = open_dev(&dd_new, dd->dm_dev.bdev->bd_dev, md);
+	if (r)
+		return r;
 
 	dd->dm_dev.mode |= new_mode;
-	dd->dm_dev.bdev = NULL;
-	r = open_dev(dd, dev, md);
-	if (!r)
-		close_dev(&dd_copy, md);
-	else
-		*dd = dd_copy;
+	close_dev(&dd_old, md);
 
-	return r;
+	return 0;
 }
 
 /*

