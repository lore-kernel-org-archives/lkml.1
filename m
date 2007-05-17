Return-Path: <linux-kernel-owner+w=401wt.eu-S1763176AbXEQFTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763176AbXEQFTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 01:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759025AbXEQFT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 01:19:27 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38968 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752277AbXEQFTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 01:19:25 -0400
Message-Id: <20070517051924.844519813@sgi.com>
References: <20070517051659.055631233@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 May 2007 22:17:02 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, dgc@sgi.com
Subject: [patch 3/3] Support removal of unused dentry entries via SLUB defrag interface
Content-Disposition: inline; filename=dentry_targeted_reclaim
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the removal of unused dentry entries in a partial
populated slab page. Very limited (yet) in what it can do for reclaim
but this catches bad cases in which we have a long list of partial
slabs with a few entries in each of them. We can free up the slabs
that have only unused dentry entries in them.

get_dentry() uses the dcache lock and then works with dget_locked
to obtain a reference to the dentry. An additional complication is that
the dentry may be in process of being freed or it may just have been
allocated. In that case d_inode is NULL. If we discover this then we
simply stay away from the object and return 1 to indicate to the
defrag logic that this object will be free. Otherwise we increment
the refcount and return success.

kick_dentry() is called after get_dentry_reference() has
been used and after the slab has dropped all of its own locks. The dentry
pruning for unused entries works in a straighforward way.

Note: The code here could be significantly improved. If we could
get to a point where all used dentries could be moved then full
dentry slab defragmentation and vacating of dentry slab pages would
become possible.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/dcache.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 81 insertions(+), 8 deletions(-)

Index: slub/fs/dcache.c
===================================================================
--- slub.orig/fs/dcache.c	2007-05-16 20:58:02.000000000 -0700
+++ slub/fs/dcache.c	2007-05-16 20:59:27.000000000 -0700
@@ -2114,18 +2114,91 @@ static void __init dcache_init_early(voi
 		INIT_HLIST_HEAD(&dentry_hashtable[loop]);
 }
 
+/*
+ * The slab is holding off frees. Thus we can safely examine
+ * the object without the danger of it vanishing from under us.
+ */
+static int get_dentry(struct kmem_cache *s, void *private)
+{
+	struct dentry *dentry = private;
+	int result = 0;
+
+	spin_lock(&dcache_lock);
+	/*
+	 * dentry->d_inode is set to NULL when the dentry
+	 * is freed. Use that as an indicator that we should
+	 * not interfere with the freeing process.
+	 */
+	if (dentry->d_inode) {
+		dget_locked(dentry);
+		if (atomic_read(&dentry->d_count) > 2)
+			/*
+			 * Moving of dentries in use not
+			 * implemented yet.
+			 */
+			result = -EINVAL;
+	} else
+		result = 1;
+	spin_unlock(&dcache_lock);
+	return result;
+}
+
+static void put_dentry(struct kmem_cache *s, void *private)
+{
+	struct dentry *dentry = private;
+
+	dput(dentry);
+}
+
+/*
+ * Slab has dropped all the locks. Get rid of the
+ * refcount we obtained earlier and also rid of the
+ * object.
+ */
+static int kick_dentry(struct kmem_cache *s, void *private)
+{
+	struct dentry *dentry = private;
+
+	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
+	if (atomic_read(&dentry->d_count) > 1) {
+		/*
+		 * Reference count was increased.
+		 * We need to abandon the freeing of
+		 * objects.
+		 */
+		spin_unlock(&dentry->d_lock);
+		spin_unlock(&dcache_lock);
+		dput(dentry);
+		return -EBUSY;
+	}
+
+	/* Remove from LRU */
+	if (!list_empty(&dentry->d_lru)) {
+		dentry_stat.nr_unused--;
+		list_del_init(&dentry->d_lru);
+	}
+	/* Drop the entry */
+	prune_one_dentry(dentry, 1);
+	spin_unlock(&dcache_lock);
+	return 0;
+}
+
+static struct kmem_cache_ops dentry_kmem_cache_ops = {
+	.get = get_dentry,
+	.put = put_dentry,
+	.kick = kick_dentry,
+	.sync = synchronize_rcu
+};
+
 static void __init dcache_init(unsigned long mempages)
 {
 	int loop;
 
-	/* 
-	 * A constructor could be added for stable state like the lists,
-	 * but it is probably not worth it because of the cache nature
-	 * of the dcache. 
-	 */
-	dentry_cache = KMEM_CACHE(dentry,
-		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
-	
+	dentry_cache = KMEM_CACHE_OPS(dentry,
+		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD,
+		&dentry_kmem_cache_ops);
+
 	register_shrinker(&dcache_shrinker);
 
 	/* Hash may have been set up in dcache_init_early */

-- 
