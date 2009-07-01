Return-Path: <linux-kernel-owner+w=401wt.eu-S932172AbZGABQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbZGABQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761603AbZGAAfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:54 -0400
Received: from kroah.org ([198.145.64.141]:60709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761587AbZGAAfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:43 2009
Message-Id: <20090701002442.919795661@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 099/108] dm: use i_size_read
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=dm-use-i_size_read.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 5657e8fa45cf230df278040c420fb80e06309d8f upstream.

Use i_size_read() instead of reading i_size.

If someone changes the size of the device simultaneously, i_size_read
is guaranteed to return a valid value (either the old one or the new one).

i_size can return some intermediate invalid value (on 32-bit computers
with 64-bit i_size, the reads to both halves of i_size can be interleaved
with updates to i_size, resulting in garbage being returned).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-exception-store.h |    2 +-
 drivers/md/dm-log.c             |    2 +-
 drivers/md/dm-table.c           |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -156,7 +156,7 @@ static inline void dm_consecutive_chunk_
  */
 static inline sector_t get_dev_size(struct block_device *bdev)
 {
-	return bdev->bd_inode->i_size >> SECTOR_SHIFT;
+	return i_size_read(bdev->bd_inode) >> SECTOR_SHIFT;
 }
 
 static inline chunk_t sector_to_chunk(struct dm_exception_store *store,
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -415,7 +415,7 @@ static int create_log_context(struct dm_
 		buf_size = dm_round_up((LOG_OFFSET << SECTOR_SHIFT) +
 				       bitset_size, ti->limits.hardsect_size);
 
-		if (buf_size > dev->bdev->bd_inode->i_size) {
+		if (buf_size > i_size_read(dev->bdev->bd_inode)) {
 			DMWARN("log device %s too small: need %llu bytes",
 				dev->name, (unsigned long long)buf_size);
 			kfree(lc);
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -387,7 +387,8 @@ static void close_dev(struct dm_dev_inte
 static int check_device_area(struct dm_dev_internal *dd, sector_t start,
 			     sector_t len)
 {
-	sector_t dev_size = dd->dm_dev.bdev->bd_inode->i_size >> SECTOR_SHIFT;
+	sector_t dev_size = i_size_read(dd->dm_dev.bdev->bd_inode) >>
+			    SECTOR_SHIFT;
 
 	if (!dev_size)
 		return 1;


