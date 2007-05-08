Return-Path: <linux-kernel-owner+w=401wt.eu-S1031682AbXEHTrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031682AbXEHTrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031664AbXEHTrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:47:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031641AbXEHTrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:47:11 -0400
Date: Tue, 8 May 2007 20:46:10 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Mike Anderson <andmike@us.ibm.com>
Subject: [2.6.22 PATCH 10/26] dm: allow offline devices
Message-ID: <20070508194610.GQ24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Mike Anderson <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Anderson <andmike@us.ibm.com>

Allow check_device_area to succeed if a device has an i_size of zero. This
addresses an issue seen on DASD devices setting up a multipath table for
paths in online and offline state.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-table.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6.21/drivers/md/dm-table.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-table.c	2007-05-01 17:40:45.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-table.c	2007-05-01 17:40:50.000000000 +0100
@@ -428,13 +428,15 @@ static void close_dev(struct dm_dev *d, 
 }
 
 /*
- * If possible (ie. blk_size[major] is set), this checks an area
- * of a destination device is valid.
+ * If possible, this checks an area of a destination device is valid.
  */
 static int check_device_area(struct dm_dev *dd, sector_t start, sector_t len)
 {
-	sector_t dev_size;
-	dev_size = dd->bdev->bd_inode->i_size >> SECTOR_SHIFT;
+	sector_t dev_size = dd->bdev->bd_inode->i_size >> SECTOR_SHIFT;
+
+	if (!dev_size)
+		return 1;
+
 	return ((start < dev_size) && (len <= (dev_size - start)));
 }
 
