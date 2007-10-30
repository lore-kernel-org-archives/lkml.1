Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbXJ3Uen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbXJ3Uen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbXJ3Ueg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:34:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbXJ3Uef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:34:35 -0400
Message-ID: <47279551.1020609@ce.jp.nec.com>
Date: Tue, 30 Oct 2007 16:34:25 -0400
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] dm: Fix panic on shrinking device size
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixes a panic on shrinking DM device, due to reference
outside of the DM table.

The problem occurs only if there is outstanding I/O to the removed
part of the device.

The bug is in that __clone_and_map() assumes dm_table_find_target()
always returns a valid pointer.
It may fail if a BIO is sent from the block layer but its target
sector is already not in the DM table.

This patch tidies up dm_table_find_target() to return NULL
instead of bogus pointer for failure case.
Then __clone_and_map() can check the return value of it
and make the BIO return with -EIO.
target_message() in dm-ioctl.c, the only other user of
dm_table_find_target(), is modified to use the return value of it, too.

Sample test script to trigger oops:
--------------------------------------------------------------------------
#!/bin/bash

FILE=$(mktemp)
LODEV=$(losetup -f)
MAP=$(basename ${FILE})
SIZE=4M

dd if=/dev/zero of=${FILE} bs=${SIZE} count=1
losetup ${LODEV} ${FILE}

echo "0 $(blockdev --getsz ${LODEV}) linear ${LODEV} 0" |dmsetup create ${MAP}
dmsetup suspend ${MAP}
echo "0 1 linear ${LODEV} 0" |dmsetup load ${MAP}
dd if=/dev/zero of=/dev/mapper/${MAP} bs=${SIZE} count=1 &
echo "Wait til dd push some I/O"
sleep 5
dmsetup resume ${MAP}
--------------------------------------------------------------------------

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

---
 dm-ioctl.c |   10 +++-------
 dm-table.c |    3 +++
 dm.c       |   24 ++++++++++++++++++------
 3 files changed, 24 insertions(+), 13 deletions(-)

Index: linux-2.6.23.work/drivers/md/dm.c
===================================================================
--- linux-2.6.23.work.orig/drivers/md/dm.c
+++ linux-2.6.23.work/drivers/md/dm.c
@@ -663,13 +663,19 @@ static struct bio *clone_bio(struct bio 
 	return clone;
 }
 
-static void __clone_and_map(struct clone_info *ci)
+static int __clone_and_map(struct clone_info *ci)
 {
 	struct bio *clone, *bio = ci->bio;
-	struct dm_target *ti = dm_table_find_target(ci->map, ci->sector);
-	sector_t len = 0, max = max_io_len(ci->md, ci->sector, ti);
+	struct dm_target *ti;
+	sector_t len = 0, max;
 	struct dm_target_io *tio;
 
+	ti = dm_table_find_target(ci->map, ci->sector);
+	if (!ti)
+		return -EIO;
+
+	max = max_io_len(ci->md, ci->sector, ti);
+
 	/*
 	 * Allocate a target io object.
 	 */
@@ -727,6 +733,9 @@ static void __clone_and_map(struct clone
 		do {
 			if (offset) {
 				ti = dm_table_find_target(ci->map, ci->sector);
+				if (!ti)
+					return -EIO;
+
 				max = max_io_len(ci->md, ci->sector, ti);
 
 				tio = alloc_tio(ci->md);
@@ -750,6 +759,8 @@ static void __clone_and_map(struct clone
 
 		ci->idx++;
 	}
+
+	return 0;
 }
 
 /*
@@ -758,6 +769,7 @@ static void __clone_and_map(struct clone
 static void __split_bio(struct mapped_device *md, struct bio *bio)
 {
 	struct clone_info ci;
+	int error = 0;
 
 	ci.map = dm_get_table(md);
 	if (!ci.map) {
@@ -777,11 +789,11 @@ static void __split_bio(struct mapped_de
 	ci.idx = bio->bi_idx;
 
 	start_io_acct(ci.io);
-	while (ci.sector_count)
-		__clone_and_map(&ci);
+	while (ci.sector_count && !error)
+		error = __clone_and_map(&ci);
 
 	/* drop the extra reference count */
-	dec_pending(ci.io, 0);
+	dec_pending(ci.io, error);
 	dm_table_put(ci.map);
 }
 /*-----------------------------------------------------------------
Index: linux-2.6.23.work/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.23.work.orig/drivers/md/dm-ioctl.c
+++ linux-2.6.23.work/drivers/md/dm-ioctl.c
@@ -1250,21 +1250,17 @@ static int target_message(struct dm_ioct
 	if (!table)
 		goto out_argv;
 
-	if (tmsg->sector >= dm_table_get_size(table)) {
+	ti = dm_table_find_target(table, tmsg->sector);
+	if (!ti) {
 		DMWARN("Target message sector outside device.");
 		r = -EINVAL;
-		goto out_table;
-	}
-
-	ti = dm_table_find_target(table, tmsg->sector);
-	if (ti->type->message)
+	} else if (ti->type->message)
 		r = ti->type->message(ti, argc, argv);
 	else {
 		DMWARN("Target type does not support messages");
 		r = -EINVAL;
 	}
 
- out_table:
 	dm_table_put(table);
  out_argv:
 	kfree(argv);
Index: linux-2.6.23.work/drivers/md/dm-table.c
===================================================================
--- linux-2.6.23.work.orig/drivers/md/dm-table.c
+++ linux-2.6.23.work/drivers/md/dm-table.c
@@ -868,6 +868,9 @@ struct dm_target *dm_table_find_target(s
 	unsigned int l, n = 0, k = 0;
 	sector_t *node;
 
+	if (sector >= dm_table_get_size(t))
+		return NULL;
+
 	for (l = 0; l < t->depth; l++) {
 		n = get_child(n, k);
 		node = get_node(t, l, n);
