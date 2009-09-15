Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZIOSRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZIOSRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758106AbZIOSRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:17:23 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59540 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850AbZIOSQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:16:52 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 02/11] writeback: get rid of wbc->for_writepages
Date: Tue, 15 Sep 2009 20:16:48 +0200
Message-Id: <1253038617-30204-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com>
References: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's only set, it's never checked. Kill it.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/afs/write.c              |    1 -
 fs/btrfs/ordered-data.c     |    1 -
 fs/jbd2/commit.c            |    1 -
 fs/nfs/write.c              |    1 -
 include/linux/writeback.h   |    1 -
 include/trace/events/ext4.h |    6 ++----
 mm/page-writeback.c         |    2 --
 7 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index c2e7a7f..c63a3c8 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -712,7 +712,6 @@ int afs_writeback_all(struct afs_vnode *vnode)
 		.bdi		= mapping->backing_dev_info,
 		.sync_mode	= WB_SYNC_ALL,
 		.nr_to_write	= LONG_MAX,
-		.for_writepages = 1,
 		.range_cyclic	= 1,
 	};
 	int ret;
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index d6f0806..7b2f401 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -740,7 +740,6 @@ int btrfs_fdatawrite_range(struct address_space *mapping, loff_t start,
 		.nr_to_write = mapping->nrpages * 2,
 		.range_start = start,
 		.range_end = end,
-		.for_writepages = 1,
 	};
 	return btrfs_writepages(mapping, &wbc);
 }
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 7b4088b..0df600e 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -220,7 +220,6 @@ static int journal_submit_inode_data_buffers(struct address_space *mapping)
 		.nr_to_write = mapping->nrpages * 2,
 		.range_start = 0,
 		.range_end = i_size_read(mapping->host),
-		.for_writepages = 1,
 	};
 
 	ret = generic_writepages(mapping, &wbc);
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 120acad..53eb26c 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1490,7 +1490,6 @@ static int nfs_write_mapping(struct address_space *mapping, int how)
 		.nr_to_write = LONG_MAX,
 		.range_start = 0,
 		.range_end = LLONG_MAX,
-		.for_writepages = 1,
 	};
 
 	return __nfs_write_mapping(mapping, &wbc, how);
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index d347632..48a054e 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -50,7 +50,6 @@ struct writeback_control {
 	unsigned encountered_congestion:1; /* An output: a queue is full */
 	unsigned for_kupdate:1;		/* A kupdate writeback */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
-	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
 	/*
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 7d8b5bc..8d433c4 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -227,7 +227,6 @@ TRACE_EVENT(ext4_da_writepages,
 		__field(	char,	nonblocking		)
 		__field(	char,	for_kupdate		)
 		__field(	char,	for_reclaim		)
-		__field(	char,	for_writepages		)
 		__field(	char,	range_cyclic		)
 	),
 
@@ -241,16 +240,15 @@ TRACE_EVENT(ext4_da_writepages,
 		__entry->nonblocking	= wbc->nonblocking;
 		__entry->for_kupdate	= wbc->for_kupdate;
 		__entry->for_reclaim	= wbc->for_reclaim;
-		__entry->for_writepages	= wbc->for_writepages;
 		__entry->range_cyclic	= wbc->range_cyclic;
 	),
 
-	TP_printk("dev %s ino %lu nr_t_write %ld pages_skipped %ld range_start %llu range_end %llu nonblocking %d for_kupdate %d for_reclaim %d for_writepages %d range_cyclic %d",
+	TP_printk("dev %s ino %lu nr_t_write %ld pages_skipped %ld range_start %llu range_end %llu nonblocking %d for_kupdate %d for_reclaim %d range_cyclic %d",
 		  jbd2_dev_to_name(__entry->dev), __entry->ino, __entry->nr_to_write,
 		  __entry->pages_skipped, __entry->range_start,
 		  __entry->range_end, __entry->nonblocking,
 		  __entry->for_kupdate, __entry->for_reclaim,
-		  __entry->for_writepages, __entry->range_cyclic)
+		  __entry->range_cyclic)
 );
 
 TRACE_EVENT(ext4_da_writepages_result,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 25e7770..64c01d0 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1019,12 +1019,10 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 
 	if (wbc->nr_to_write <= 0)
 		return 0;
-	wbc->for_writepages = 1;
 	if (mapping->a_ops->writepages)
 		ret = mapping->a_ops->writepages(mapping, wbc);
 	else
 		ret = generic_writepages(mapping, wbc);
-	wbc->for_writepages = 0;
 	return ret;
 }
 
-- 
1.6.4.1.207.g68ea

