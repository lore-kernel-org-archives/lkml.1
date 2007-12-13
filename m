Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbXLMOmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbXLMOmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbXLMOmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:42:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889AbXLMOmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:42:31 -0500
Date: Thu, 13 Dec 2007 14:42:08 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, stable@kernel.org
Subject: [2.6.24 PATCH 01/06] dm: table detect io beyond device
Message-ID: <20071213144208.GT24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, stable@kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

This patch fixes a panic on shrinking a DM device if there is
outstanding I/O to the part of the device that is being removed.
(Normally this doesn't happen - a filesystem would be resized first,
for example.)

The bug is that __clone_and_map() assumes dm_table_find_target()
always returns a valid pointer.  It may fail if a bio arrives from the
block layer but its target sector is no longer included in the DM
btree.

This patch appends an empty entry to table->targets[] which will
be returned by a lookup beyond the end of the device.

After calling dm_table_find_target(), __clone_and_map() and target_message()
check for this condition using 
dm_target_is_valid().

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

Cc: stable@kernel.org
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-ioctl.c |   10 +++-------
 drivers/md/dm-table.c |    7 ++++++-
 drivers/md/dm.c       |   24 ++++++++++++++++++------
 drivers/md/dm.h       |    5 +++++
 4 files changed, 32 insertions(+), 14 deletions(-)

Index: linux-2.6.24-rc5/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/dm-ioctl.c	2007-12-12 15:40:33.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/dm-ioctl.c	2007-12-12 15:43:06.000000000 +0000
@@ -1250,21 +1250,17 @@ static int target_message(struct dm_ioct
 	if (!table)
 		goto out_argv;
 
-	if (tmsg->sector >= dm_table_get_size(table)) {
+	ti = dm_table_find_target(table, tmsg->sector);
+	if (!dm_target_is_valid(ti)) {
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
Index: linux-2.6.24-rc5/drivers/md/dm-table.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/dm-table.c	2007-12-12 15:40:33.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/dm-table.c	2007-12-12 15:43:06.000000000 +0000
@@ -189,8 +189,10 @@ static int alloc_targets(struct dm_table
 
 	/*
 	 * Allocate both the target array and offset array at once.
+	 * Append an empty entry to catch sectors beyond the end of
+	 * the device.
 	 */
-	n_highs = (sector_t *) dm_vcalloc(num, sizeof(struct dm_target) +
+	n_highs = (sector_t *) dm_vcalloc(num + 1, sizeof(struct dm_target) +
 					  sizeof(sector_t));
 	if (!n_highs)
 		return -ENOMEM;
@@ -867,6 +869,9 @@ struct dm_target *dm_table_get_target(st
 
 /*
  * Search the btree for the correct target.
+ *
+ * Caller should check returned pointer with dm_target_is_valid()
+ * to trap I/O beyond end of device.
  */
 struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
 {
Index: linux-2.6.24-rc5/drivers/md/dm.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/dm.c	2007-12-12 15:40:33.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/dm.c	2007-12-12 15:43:06.000000000 +0000
@@ -672,13 +672,19 @@ static struct bio *clone_bio(struct bio 
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
+	if (!dm_target_is_valid(ti))
+		return -EIO;
+
+	max = max_io_len(ci->md, ci->sector, ti);
+
 	/*
 	 * Allocate a target io object.
 	 */
@@ -736,6 +742,9 @@ static void __clone_and_map(struct clone
 		do {
 			if (offset) {
 				ti = dm_table_find_target(ci->map, ci->sector);
+				if (!dm_target_is_valid(ti))
+					return -EIO;
+
 				max = max_io_len(ci->md, ci->sector, ti);
 
 				tio = alloc_tio(ci->md);
@@ -759,6 +768,8 @@ static void __clone_and_map(struct clone
 
 		ci->idx++;
 	}
+
+	return 0;
 }
 
 /*
@@ -767,6 +778,7 @@ static void __clone_and_map(struct clone
 static int __split_bio(struct mapped_device *md, struct bio *bio)
 {
 	struct clone_info ci;
+	int error = 0;
 
 	ci.map = dm_get_table(md);
 	if (unlikely(!ci.map))
@@ -784,11 +796,11 @@ static int __split_bio(struct mapped_dev
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
 
 	return 0;
Index: linux-2.6.24-rc5/drivers/md/dm.h
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/dm.h	2007-12-12 15:40:33.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/dm.h	2007-12-12 15:43:06.000000000 +0000
@@ -112,6 +112,11 @@ int dm_table_resume_targets(struct dm_ta
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
 void dm_table_unplug_all(struct dm_table *t);
 
+/*
+ * To check the return value from dm_table_find_target().
+ */
+#define dm_target_is_valid(t) ((t)->table)
+
 /*-----------------------------------------------------------------
  * A registry of target types.
  *---------------------------------------------------------------*/
