Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYH3OES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYH3OES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 10:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYH3OEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 10:04:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:58672 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbYH3OEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 10:04:07 -0400
Message-ID: <48B95307.8040902@kernel.org>
Date: Sat, 30 Aug 2008 16:02:47 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH] block: restore original behavior of /proc/partition when
 there's no partition
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 30 Aug 2008 14:03:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/partitions didn't use to write out the header if there was no
partition.  However, recent commit 66c64afe changed the behavior.
This is nothing major but there's no reason to change user visible
behavior without a good rationale.  Restore the original behavior.

Note that 2.6.28 has clean up changes scheduled which will replace
this rather hacky implementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 block/genhd.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)
diff --git a/block/genhd.c b/block/genhd.c
index 656c2c7..e86b312 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -309,7 +309,7 @@ static void *part_start(struct seq_file *part, loff_t *pos)
 	loff_t k = *pos;
 
 	if (!k)
-		seq_puts(part, "major minor  #blocks  name\n\n");
+		part->private = (void *)1LU;	/* tell show to print header */
 
 	mutex_lock(&block_class_lock);
 	dev = class_find_device(&block_class, NULL, &k, find_start);
@@ -351,6 +351,17 @@ static int show_partition(struct seq_file *part, void *v)
 	int n;
 	char buf[BDEVNAME_SIZE];
 
+	/*
+	 * Print header if start told us to do.  This is to preserve
+	 * the original behavior of not printing header if no
+	 * partition exists.  This hackery will be removed later with
+	 * class iteration clean up.
+	 */
+	if (part->private) {
+		seq_puts(part, "major minor  #blocks  name\n\n");
+		part->private = NULL;
+	}
+
 	/* Don't show non-partitionable removeable devices or empty devices */
 	if (!get_capacity(sgp) ||
 			(sgp->minors == 1 && (sgp->flags & GENHD_FL_REMOVABLE)))
