Return-Path: <linux-kernel-owner+w=401wt.eu-S1756936AbXHNVXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbXHNVXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbXHNVWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:22:05 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38392 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753474AbXHNVWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:22:03 -0400
Date: Tue, 14 Aug 2007 23:21:52 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Edward Shishkin <edward@namesys.com>
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: [-mm patch] fs/reiser4/plugin/: make 3 functions static
Message-ID: <20070814212152.GT18945@stusta.de>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 11:09:32PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc1-mm1:
>...
> +reiser4-cryptcompress-misc-fixups.patch
>...
>  reiser4 updates
>...

This patch makes the following needlessly global functions static:
- file/cryptcompress.c: __put_page_cluster()
- file/cryptcompress.c: put_hint_cluster()
- item/ctail.c: ctail_read_disk_cluster()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/reiser4/plugin/cluster.h            |    4 ----
 fs/reiser4/plugin/file/cryptcompress.c |    8 ++++----
 fs/reiser4/plugin/file/cryptcompress.h |    2 --
 fs/reiser4/plugin/item/ctail.c         |    5 +++--
 4 files changed, 7 insertions(+), 12 deletions(-)

dcbd29fcda0d6143ab0ec5f91e347d6e540f27bd 
diff --git a/fs/reiser4/plugin/cluster.h b/fs/reiser4/plugin/cluster.h
index 7856074..af7a305 100644
--- a/fs/reiser4/plugin/cluster.h
+++ b/fs/reiser4/plugin/cluster.h
@@ -326,8 +326,6 @@ int reiser4_deflate_cluster(struct cluster_handle *, struct inode *);
 void truncate_complete_page_cluster(struct inode *inode, cloff_t start,
 					 int even_cows);
 void invalidate_hint_cluster(struct cluster_handle * clust);
-void put_hint_cluster(struct cluster_handle * clust, struct inode *inode,
-		      znode_lock_mode mode);
 int get_disk_cluster_locked(struct cluster_handle * clust, struct inode * inode,
 			    znode_lock_mode lock_mode);
 void reset_cluster_params(struct cluster_handle * clust);
@@ -335,8 +333,6 @@ int set_cluster_by_page(struct cluster_handle * clust, struct page * page,
 			int count);
 int prepare_page_cluster(struct inode *inode, struct cluster_handle * clust,
 			 rw_op rw);
-void __put_page_cluster(int from, int to, struct page ** pages,
-			struct inode * inode);
 void put_page_cluster(struct cluster_handle * clust,
 		      struct inode  * inode, rw_op rw);
 void put_cluster_handle(struct cluster_handle * clust);
diff --git a/fs/reiser4/plugin/file/cryptcompress.c b/fs/reiser4/plugin/file/cryptcompress.c
index f0f0bee..9724d64 100644
--- a/fs/reiser4/plugin/file/cryptcompress.c
+++ b/fs/reiser4/plugin/file/cryptcompress.c
@@ -1378,8 +1378,8 @@ static void truncate_page_cluster_range(struct inode * inode,
 }
 
 /* Put @count pages starting from @from offset */
-void __put_page_cluster(int from, int count,
-			struct page ** pages, struct inode  * inode)
+static void __put_page_cluster(int from, int count,
+			       struct page ** pages, struct inode  * inode)
 {
 	int i;
 	assert("edward-1468", pages != NULL);
@@ -1975,8 +1975,8 @@ void invalidate_hint_cluster(struct cluster_handle * clust)
 	hint_clr_valid(clust->hint);
 }
 
-void put_hint_cluster(struct cluster_handle * clust, struct inode *inode,
-		      znode_lock_mode mode)
+static void put_hint_cluster(struct cluster_handle * clust,
+			     struct inode *inode, znode_lock_mode mode)
 {
 	assert("edward-1286", clust != NULL);
 	assert("edward-1287", clust->hint != NULL);
diff --git a/fs/reiser4/plugin/file/cryptcompress.h b/fs/reiser4/plugin/file/cryptcompress.h
index 5984e3c..117d377 100644
--- a/fs/reiser4/plugin/file/cryptcompress.h
+++ b/fs/reiser4/plugin/file/cryptcompress.h
@@ -530,8 +530,6 @@ int equal_to_rdk(znode *, const reiser4_key *);
 int goto_right_neighbor(coord_t *, lock_handle *);
 int cryptcompress_inode_ok(struct inode *inode);
 int coord_is_unprepped_ctail(const coord_t * coord);
-extern int ctail_read_disk_cluster (struct cluster_handle *, struct inode *,
-				    struct page *, znode_lock_mode mode);
 extern int do_readpage_ctail(struct inode *, struct cluster_handle *,
 			     struct page * page, znode_lock_mode mode);
 extern int ctail_insert_unprepped_cluster(struct cluster_handle * clust,
diff --git a/fs/reiser4/plugin/item/ctail.c b/fs/reiser4/plugin/item/ctail.c
index a931392..33ab44a 100644
--- a/fs/reiser4/plugin/item/ctail.c
+++ b/fs/reiser4/plugin/item/ctail.c
@@ -551,8 +551,9 @@ int read_ctail(struct file *file UNUSED_ARG, flow_t * f, hint_t * hint)
  * Prepare transform stream with plain text for page
  * @page taking into account synchronization issues.
  */
-int ctail_read_disk_cluster(struct cluster_handle * clust, struct inode * inode,
-			    struct page * page, znode_lock_mode mode)
+static int ctail_read_disk_cluster(struct cluster_handle * clust,
+				   struct inode * inode, struct page * page,
+				   znode_lock_mode mode)
 {
 	int result;
 

