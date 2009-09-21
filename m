Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbZIUM4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbZIUM4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZIUM4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:56:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58115 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbZIUM4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:56:17 -0400
Date: Mon, 21 Sep 2009 14:56:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, jack@suse.cz,
       fengguang.wu@intel.com
Subject: [GIT PULL] a few writeback fixes
Message-ID: <20090921125620.GV23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This fixes a problem with NFS killing its bdi without being initialized,
and also contains a fix for a busy loop (where we forgot to set the
task state before sleeping). Since these are a bit critical for -rc1,
I'm pushing them out before leaving for Portland.

Jan, since we're not really sure on the inode wait yet, I dropped that
patch. It's definitely something to look into, as are the congestion
bits.

I plan on adding some writeback tracing code while on the plane for
further analysis when I get back.

  git://git.kernel.dk/linux-2.6-block.git writeback

Jens Axboe (4):
      nfs: nfs_kill_super() should call bdi_unregister() after killing super
      writeback: don't use schedule_timeout() without setting runstate
      writeback: make balance_dirty_pages() gradually back more off
      nfs: initialize the backing_dev_info when creating the server

 fs/nfs/client.c     |   10 ++++++----
 fs/nfs/super.c      |    2 +-
 mm/page-writeback.c |   11 ++++++++++-
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index e350bd6..a7ce15d 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -933,10 +933,6 @@ static int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh, str
 		goto out_error;
 
 	nfs_server_set_fsinfo(server, &fsinfo);
-	error = bdi_init(&server->backing_dev_info);
-	if (error)
-		goto out_error;
-
 
 	/* Get some general file system info */
 	if (server->namelen == 0) {
@@ -995,6 +991,12 @@ static struct nfs_server *nfs_alloc_server(void)
 		return NULL;
 	}
 
+	if (bdi_init(&server->backing_dev_info)) {
+		nfs_free_iostats(server->io_stats);
+		kfree(server);
+		return NULL;
+	}
+
 	return server;
 }
 
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index de93569..f1cc058 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2190,8 +2190,8 @@ static void nfs_kill_super(struct super_block *s)
 {
 	struct nfs_server *server = NFS_SB(s);
 
-	bdi_unregister(&server->backing_dev_info);
 	kill_anon_super(s);
+	bdi_unregister(&server->backing_dev_info);
 	nfs_fscache_release_super_cookie(s);
 	nfs_free_server(server);
 }
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 1eea4fa..6bb510b 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -485,6 +485,7 @@ static void balance_dirty_pages(struct address_space *mapping)
 	unsigned long bdi_thresh;
 	unsigned long pages_written = 0;
 	unsigned long write_chunk = sync_writeback_pages();
+	unsigned long pause = 1;
 
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
@@ -561,7 +562,15 @@ static void balance_dirty_pages(struct address_space *mapping)
 		if (pages_written >= write_chunk)
 			break;		/* We've done our duty */
 
-		schedule_timeout(1);
+		schedule_timeout_interruptible(pause);
+
+		/*
+		 * Increase the delay for each loop, up to our previous
+		 * default of taking a 100ms nap.
+		 */
+		pause <<= 1;
+		if (pause < HZ / 10)
+			pause = HZ / 10;
 	}
 
 	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&

-- 
Jens Axboe

