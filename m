Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954Ab0A2Uyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab0A2Uyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917Ab0A2Uxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:53:48 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42687 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab0A2UvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:51:14 -0500
Message-Id: <20100129205007.832823807@quilx.com>
References: <20100129204931.789743493@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jan 2010 14:49:48 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
Subject: dentries: dentry defragmentation
Content-Disposition: inline; filename=defrag_dentry
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dentry pruning for unused entries works in a straightforward way. It
could be made more aggressive if one would actually move dentries instead
of just reclaiming them.

Cc: Alexander Viro <viro@ftp.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 fs/dcache.c |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2009-12-18 13:13:24.000000000 -0600
+++ linux-2.6/fs/dcache.c	2010-01-29 12:10:37.000000000 -0600
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 #include <linux/fs_struct.h>
 #include <linux/hardirq.h>
+#include <linux/backing-dev.h>
 #include "internal.h"
 
 int sysctl_vfs_cache_pressure __read_mostly = 100;
@@ -173,7 +174,10 @@ static struct dentry *d_kill(struct dent
 
 	list_del(&dentry->d_u.d_child);
 	dentry_stat.nr_dentry--;	/* For d_free, below */
-	/*drops the locks, at that point nobody can reach this dentry */
+	/*
+	 * drops the locks, at that point nobody (aside from defrag)
+	 * can reach this dentry
+	 */
 	dentry_iput(dentry);
 	if (IS_ROOT(dentry))
 		parent = NULL;
@@ -2263,6 +2267,100 @@ static void __init dcache_init_early(voi
 		INIT_HLIST_HEAD(&dentry_hashtable[loop]);
 }
 
+/*
+ * The slab allocator is holding off frees. We can safely examine
+ * the object without the danger of it vanishing from under us.
+ */
+static void *get_dentries(struct kmem_cache *s, int nr, void **v)
+{
+	struct dentry *dentry;
+	int i;
+
+	spin_lock(&dcache_lock);
+	for (i = 0; i < nr; i++) {
+		dentry = v[i];
+
+		/*
+		 * Three sorts of dentries cannot be reclaimed:
+		 *
+		 * 1. dentries that are in the process of being allocated
+		 *    or being freed. In that case the dentry is neither
+		 *    on the LRU nor hashed.
+		 *
+		 * 2. Fake hashed entries as used for anonymous dentries
+		 *    and pipe I/O. The fake hashed entries have d_flags
+		 *    set to indicate a hashed entry. However, the
+		 *    d_hash field indicates that the entry is not hashed.
+		 *
+		 * 3. dentries that have a backing store that is not
+		 *    writable. This is true for tmpsfs and other in
+		 *    memory filesystems. Removing dentries from them
+		 *    would loose dentries for good.
+		 */
+		if ((d_unhashed(dentry) && list_empty(&dentry->d_lru)) ||
+		   (!d_unhashed(dentry) && hlist_unhashed(&dentry->d_hash)) ||
+		   (dentry->d_inode &&
+		   !mapping_cap_writeback_dirty(dentry->d_inode->i_mapping)))
+			/* Ignore this dentry */
+			v[i] = NULL;
+		else
+			/* dget_locked will remove the dentry from the LRU */
+			dget_locked(dentry);
+	}
+	spin_unlock(&dcache_lock);
+	return NULL;
+}
+
+/*
+ * Slab has dropped all the locks. Get rid of the refcount obtained
+ * earlier and also free the object.
+ */
+static void kick_dentries(struct kmem_cache *s,
+				int nr, void **v, void *private)
+{
+	struct dentry *dentry;
+	int i;
+
+	/*
+	 * First invalidate the dentries without holding the dcache lock
+	 */
+	for (i = 0; i < nr; i++) {
+		dentry = v[i];
+
+		if (dentry)
+			d_invalidate(dentry);
+	}
+
+	/*
+	 * If we are the last one holding a reference then the dentries can
+	 * be freed. We need the dcache_lock.
+	 */
+	spin_lock(&dcache_lock);
+	for (i = 0; i < nr; i++) {
+		dentry = v[i];
+		if (!dentry)
+			continue;
+
+		spin_lock(&dentry->d_lock);
+		if (atomic_read(&dentry->d_count) > 1) {
+			spin_unlock(&dentry->d_lock);
+			spin_unlock(&dcache_lock);
+			dput(dentry);
+			spin_lock(&dcache_lock);
+			continue;
+		}
+
+		prune_one_dentry(dentry);
+	}
+	spin_unlock(&dcache_lock);
+
+	/*
+	 * dentries are freed using RCU so we need to wait until RCU
+	 * operations are complete.
+	 */
+	synchronize_rcu();
+}
+
 static void __init dcache_init(void)
 {
 	int loop;
@@ -2276,6 +2374,7 @@ static void __init dcache_init(void)
 		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
 	
 	register_shrinker(&dcache_shrinker);
+	kmem_cache_setup_defrag(dentry_cache, get_dentries, kick_dentries);
 
 	/* Hash may have been set up in dcache_init_early */
 	if (!hashdist)

-- 
