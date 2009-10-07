Return-Path: <linux-kernel-owner+w=401wt.eu-S933926AbZJGIBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933926AbZJGIBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933908AbZJGIBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:01:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:50747 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758720AbZJGIB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:01:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195971273"
Message-Id: <20091007074903.749770316@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li Shaohua" <shaohua.li@intel.com>,
       "Myklebust Trond" <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       <linux-fsdevel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/45] NFS: introduce writeback wait queue
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=writeback-nfs-request-queue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic writeback routines are departing from congestion_wait()
in preferance of get_request_wait(), aka. waiting on the block queues.

Introduce the missing writeback wait queue for NFS, otherwise its
writeback pages may grow out of control.

In perticular, balance_dirty_pages() will exit after it pushes
write_chunk pages into the PG_writeback page pool, _OR_ when the
background writeback work quits. The latter is new behavior, and could
not only quit (normally) after below background threshold, but also
quit when it finds _zero_ dirty pages to write. The latter case gives
rise to the number of PG_writeback pages if it is not explicitly limited.

CC: Jens Axboe <jens.axboe@oracle.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---

The wait time and network throughput varies a lot! this is a major problem.
This means nfs_end_page_writeback() is not called smoothly over time,
even when there are plenty of PG_writeback pages on the client side.

[  397.828509] write_bandwidth: comm=nfsiod pages=192 time=16ms
[  397.850976] write_bandwidth: comm=nfsiod pages=192 time=20ms
[  403.065244] write_bandwidth: comm=nfsiod pages=192 time=5212ms
[  403.549134] write_bandwidth: comm=nfsiod pages=1536 time=144ms
[  403.570717] write_bandwidth: comm=nfsiod pages=192 time=20ms
[  403.595749] write_bandwidth: comm=nfsiod pages=192 time=20ms
[  403.622171] write_bandwidth: comm=nfsiod pages=192 time=24ms
[  403.651779] write_bandwidth: comm=nfsiod pages=192 time=28ms
[  403.680543] write_bandwidth: comm=nfsiod pages=192 time=24ms
[  403.712572] write_bandwidth: comm=nfsiod pages=192 time=28ms
[  403.751552] write_bandwidth: comm=nfsiod pages=192 time=36ms
[  403.785979] write_bandwidth: comm=nfsiod pages=192 time=28ms
[  403.823995] write_bandwidth: comm=nfsiod pages=192 time=36ms
[  403.858970] write_bandwidth: comm=nfsiod pages=192 time=32ms
[  403.880786] write_bandwidth: comm=nfsiod pages=192 time=16ms
[  403.902732] write_bandwidth: comm=nfsiod pages=192 time=20ms
[  403.925925] write_bandwidth: comm=nfsiod pages=192 time=20ms
[  403.952044] write_bandwidth: comm=nfsiod pages=258 time=24ms
[  403.974006] write_bandwidth: comm=nfsiod pages=192 time=16ms
[  403.995989] write_bandwidth: comm=nfsiod pages=192 time=20ms
[  405.031049] write_bandwidth: comm=nfsiod pages=192 time=1032ms
[  405.257635] write_bandwidth: comm=nfsiod pages=1536 time=192ms
[  405.279069] write_bandwidth: comm=nfsiod pages=192 time=20ms
[  405.300843] write_bandwidth: comm=nfsiod pages=192 time=16ms
[  405.326031] write_bandwidth: comm=nfsiod pages=192 time=20ms
[  405.350843] write_bandwidth: comm=nfsiod pages=192 time=24ms
[  405.375160] write_bandwidth: comm=nfsiod pages=192 time=20ms
[  409.331015] write_bandwidth: comm=nfsiod pages=192 time=3952ms
[  409.587928] write_bandwidth: comm=nfsiod pages=1536 time=152ms
[  409.610068] write_bandwidth: comm=nfsiod pages=192 time=20ms
[  409.635736] write_bandwidth: comm=nfsiod pages=192 time=24ms

# vmmon -d 1 nr_writeback nr_dirty nr_unstable

     nr_writeback         nr_dirty      nr_unstable
            11227            41463            38044
            11227            41463            38044
            11227            41463            38044
            11227            41463            38044
            11045            53987             6490
            11033            53120             8145
            11195            52143            10886
            11211            52144            10913
            11211            52144            10913
            11211            52144            10913
            11056            56887             3876
            11062            55298             8155
            11214            54485             9838
            11225            54461             9852
            11225            54461             9852
            11225            54461             4582
            22342            35535             7823

----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw 
  0   0   9  92   0   0|   0     0 |  66B  306B|   0     0 |1003   377 
  0   1  39  60   0   1|   0     0 |  90k 1361k|   0     0 |1765  1599 
  0  15  12  43   0  31|   0     0 |2292k   34M|   0     0 |  12k   16k
  0   0  16  84   0   0|   0     0 | 132B  306B|   0     0 |1003   376 
  0   0  43  57   0   0|   0     0 |  66B  306B|   0     0 |1004   376 
  0   7  25  55   0  13|   0     0 |1202k   18M|   0     0 |7331  8921 
  0   8  21  55   0  15|   0     0 |1195k   18M|   0     0 |5382  6579 
  0   0  38  62   0   0|   0     0 |  66B  306B|   0     0 |1002   371 
  0   0  33  67   0   0|   0     0 |  66B  306B|   0     0 |1003   376 
  0  14  20  41   0  24|   0     0 |1621k   24M|   0     0 |8549    10k
  0   5  31  55   0   9|   0     0 | 769k   11M|   0     0 |4444  5180 
  0   0  18  82   0   0|   0     0 |  66B  568B|   0     0 |1004   377 
  0   1  41  54   0   3|   0     0 | 184k 2777k|   0     0 |2609  2619 
  1  13  22  43   0  22|   0     0 |1572k   23M|   0     0 |8138    10k
  0  11   9  59   0  20|   0     0 |1861k   27M|   0     0 |9576    13k
  0   5  23  66   0   5|   0     0 | 540k 8122k|   0     0 |2816  2885 


 fs/nfs/client.c           |    2 
 fs/nfs/write.c            |   81 +++++++++++++++++++++++++++++++-----
 include/linux/nfs_fs_sb.h |    1 
 3 files changed, 73 insertions(+), 11 deletions(-)

--- linux.orig/fs/nfs/write.c	2009-10-06 23:37:46.000000000 +0800
+++ linux/fs/nfs/write.c	2009-10-07 10:44:42.000000000 +0800
@@ -187,11 +187,54 @@ static int wb_priority(struct writeback_
  * NFS congestion control
  */
 
+#define NFS_WAIT_PAGES	(1024L >> (PAGE_CACHE_SHIFT - 10))
 int nfs_congestion_kb;
 
-#define NFS_CONGESTION_ON_THRESH 	(nfs_congestion_kb >> (PAGE_SHIFT-10))
-#define NFS_CONGESTION_OFF_THRESH	\
-	(NFS_CONGESTION_ON_THRESH - (NFS_CONGESTION_ON_THRESH >> 2))
+/*
+ * SYNC requests will block on (2*limit) and wakeup on (2*limit-NFS_WAIT_PAGES)
+ * ASYNC requests will block on (limit) and wakeup on (limit - NFS_WAIT_PAGES)
+ * In this way SYNC writes will never be blocked by ASYNC ones.
+ */
+
+static void nfs_set_congested(long nr, long limit,
+			      struct backing_dev_info *bdi)
+{
+	if (nr > limit && !test_bit(BDI_async_congested, &bdi->state))
+		set_bdi_congested(bdi, BLK_RW_ASYNC);
+	else if (nr > 2 * limit && !test_bit(BDI_sync_congested, &bdi->state))
+		set_bdi_congested(bdi, BLK_RW_SYNC);
+}
+
+static void nfs_wait_contested(int is_sync,
+			       struct backing_dev_info *bdi,
+			       wait_queue_head_t *wqh)
+{
+	int waitbit = is_sync ? BDI_sync_congested : BDI_async_congested;
+
+	wait_event(wqh[is_sync], !test_bit(waitbit, &bdi->state));
+}
+
+static void nfs_wakeup_congested(long nr, long limit,
+				 struct backing_dev_info *bdi,
+				 wait_queue_head_t *wqh)
+{
+	if (nr < 2*limit - min(limit/8, NFS_WAIT_PAGES)) {
+		if (test_bit(BDI_sync_congested, &bdi->state))
+			clear_bdi_congested(bdi, BLK_RW_SYNC);
+		if (waitqueue_active(&wqh[BLK_RW_SYNC])) {
+			smp_mb__after_clear_bit();
+			wake_up(&wqh[BLK_RW_SYNC]);
+		}
+	}
+	if (nr < limit - min(limit/8, NFS_WAIT_PAGES)) {
+		if (test_bit(BDI_async_congested, &bdi->state))
+			clear_bdi_congested(bdi, BLK_RW_ASYNC);
+		if (waitqueue_active(&wqh[BLK_RW_ASYNC])) {
+			smp_mb__after_clear_bit();
+			wake_up(&wqh[BLK_RW_ASYNC]);
+		}
+	}
+}
 
 static int nfs_set_page_writeback(struct page *page)
 {
@@ -201,11 +244,9 @@ static int nfs_set_page_writeback(struct
 		struct inode *inode = page->mapping->host;
 		struct nfs_server *nfss = NFS_SERVER(inode);
 
-		if (atomic_long_inc_return(&nfss->writeback) >
-				NFS_CONGESTION_ON_THRESH) {
-			set_bdi_congested(&nfss->backing_dev_info,
-						BLK_RW_ASYNC);
-		}
+		nfs_set_congested(atomic_long_inc_return(&nfss->writeback),
+				  nfs_congestion_kb >> (PAGE_SHIFT-10),
+				  &nfss->backing_dev_info);
 	}
 	return ret;
 }
@@ -216,8 +257,11 @@ static void nfs_end_page_writeback(struc
 	struct nfs_server *nfss = NFS_SERVER(inode);
 
 	end_page_writeback(page);
-	if (atomic_long_dec_return(&nfss->writeback) < NFS_CONGESTION_OFF_THRESH)
-		clear_bdi_congested(&nfss->backing_dev_info, BLK_RW_ASYNC);
+
+	nfs_wakeup_congested(atomic_long_dec_return(&nfss->writeback),
+			     nfs_congestion_kb >> (PAGE_SHIFT-10),
+			     &nfss->backing_dev_info,
+			     nfss->writeback_wait);
 }
 
 static struct nfs_page *nfs_find_and_lock_request(struct page *page)
@@ -309,19 +353,34 @@ static int nfs_writepage_locked(struct p
 
 int nfs_writepage(struct page *page, struct writeback_control *wbc)
 {
+	struct inode *inode = page->mapping->host;
+	struct nfs_server *nfss = NFS_SERVER(inode);
 	int ret;
 
 	ret = nfs_writepage_locked(page, wbc);
 	unlock_page(page);
+
+	nfs_wait_contested(wbc->sync_mode == WB_SYNC_ALL,
+			   &nfss->backing_dev_info,
+			   nfss->writeback_wait);
+
 	return ret;
 }
 
-static int nfs_writepages_callback(struct page *page, struct writeback_control *wbc, void *data)
+static int nfs_writepages_callback(struct page *page,
+				   struct writeback_control *wbc, void *data)
 {
+	struct inode *inode = page->mapping->host;
+	struct nfs_server *nfss = NFS_SERVER(inode);
 	int ret;
 
 	ret = nfs_do_writepage(page, wbc, data);
 	unlock_page(page);
+
+	nfs_wait_contested(wbc->sync_mode == WB_SYNC_ALL,
+			   &nfss->backing_dev_info,
+			   nfss->writeback_wait);
+
 	return ret;
 }
 
--- linux.orig/include/linux/nfs_fs_sb.h	2009-10-06 23:37:46.000000000 +0800
+++ linux/include/linux/nfs_fs_sb.h	2009-10-06 23:38:44.000000000 +0800
@@ -108,6 +108,7 @@ struct nfs_server {
 	struct nfs_iostats *	io_stats;	/* I/O statistics */
 	struct backing_dev_info	backing_dev_info;
 	atomic_long_t		writeback;	/* number of writeback pages */
+	wait_queue_head_t	writeback_wait[2];
 	int			flags;		/* various flags */
 	unsigned int		caps;		/* server capabilities */
 	unsigned int		rsize;		/* read size */
--- linux.orig/fs/nfs/client.c	2009-10-06 23:37:46.000000000 +0800
+++ linux/fs/nfs/client.c	2009-10-06 23:38:44.000000000 +0800
@@ -991,6 +991,8 @@ static struct nfs_server *nfs_alloc_serv
 	INIT_LIST_HEAD(&server->master_link);
 
 	atomic_set(&server->active, 0);
+	init_waitqueue_head(&server->writeback_wait[BLK_RW_SYNC]);
+	init_waitqueue_head(&server->writeback_wait[BLK_RW_ASYNC]);
 
 	server->io_stats = nfs_alloc_iostats();
 	if (!server->io_stats) {


