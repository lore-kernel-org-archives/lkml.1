Return-Path: <linux-kernel-owner+w=401wt.eu-S932546AbYEVGza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbYEVGza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 02:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757766AbYEVGzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 02:55:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757516AbYEVGzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 02:55:17 -0400
Date: Wed, 21 May 2008 23:55:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kentaro Makita <k-makita@np.css.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dgc@sgi.com,
       viro@ZenIV.linux.org.uk
Subject: Re: [PATCH][RFC]fix soft lock up at NFS mount by per-SB LRU-list of
 unused dentries
Message-Id: <20080521235510.22bff69f.akpm@linux-foundation.org>
In-Reply-To: <4834D8DA.30907@np.css.fujitsu.com>
References: <4834D8DA.30907@np.css.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 11:22:18 +0900 Kentaro Makita <k-makita@np.css.fujitsu.com> wrote:

> [Summary]
>   Split LRU-list of unused dentries to each superblocks to avoid soft lock up
>  at NFS mounts and remounting any filesystem.
> 
>  Previosly I posted are:
>  http://lkml.org/lkml/2008/3/5/590
> 
> [Descriptions]
> - background
>  dentry_unused is a list of dentries which is not in use. This works
>  as a cache against not-exisiting files. dentry_unused grows up when
>  directories or files are removed. This list can be very long if
>  there is huge free memory.

The dentry_unused inodes are not actually not-existing files.  They are
dentries which refer to live files (and, iirc, negative dentries) but
which nobody is actually using - for example, regular files which
nobody currently has open.

I changed the changelog text to reflect that.

> - what's problem
>  When shrink_dcache_sb() is called, it scans all dentry_unused linearly
>  under spin_lock(), and if dentry->d_sb is differnt from given superblock,
>  scan next dentry. This scan costs very much if there are many entries,
>  and very ineffective if there are many superblocks.
>  IOW, When we need to shrink unused dentries on one dentry, but scans
>  unused dentries on all superblocks in the system.
>  For example, we scan 500 dentries to unmount a filesystem, but scans
>  1,000,000 or more unused dentries on other superblocks.
>  In our case , At mounting NFS*, shrink_dcache_sb() is called to shrink
>  unused dentries on NFS, but scans  100,000,000 unused dentries on
>  superblocks in the system such as local ext3 filesystems.
>  I hear NFS mounting took 1 min on some system in use.
>   * : NFS uses virtual filesystem in rpc layer, so NFS is affected from
>       this problem.
> 
>   100,000,000 is possible number on large systems.
> 
>  Per-superblock LRU of unused dentried can reduce the cost in reasonable
>  manner.
> 
> - How to fix
>  I found this problem is solved by David Chinner's "Per-superblock
>  unused dentry LRU lists V3"(1), so I rebase it and add some fix to
>  reclaim with fairness, which is in Andrew Morton's comments(2).
>   1) http://lkml.org/lkml/2006/5/25/318
>   2) http://lkml.org/lkml/2006/5/25/320
> 
>  Split LRU-list of unused dentries to each superblocks. Then, NFS
>  mounting will check dentries under a superblock instead of all.
>  But this spliting will break LRU of dentry-unused.
>  So, I've attempted to make reclaim unused dentrins with fairness by
>  calculate number of dentries to scan on this sb based on following way
> 
>   number of dentries to scan on this sb =
>   count * (number of dentries on this sb / number of dentries in the machine)
> 
>  This patch is against linux-2.6.26-rc3. Tested on x86_64.

Looks good to me, thanks.  And no, the loss of the strict global LRU
handling of the dentry LRU is unlikely to be an issue.

> Based on David Chinner's "Per-superblock unused dentry LRU lists V3".
> ...
> Signed-off-by: Kentaro Makita <k-makita@np.css.fujitsu.com>

I guess we should ask David for his signed-off-by: on this.


I fiddled with the comments somewhat:

--- a/fs/dcache.c~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix
+++ a/fs/dcache.c
@@ -120,8 +120,7 @@ static void dentry_iput(struct dentry * 
 }
 
 /*
- * Following dentry_lru_(add|add_tail|del|del_init) is must
- * called with dcache_lock held.
+ * dentry_lru_(add|add_tail|del|del_init) must be called with dcache_lock held.
  */
 static void dentry_lru_add(struct dentry *dentry)
 {
@@ -245,7 +244,7 @@ repeat:
 unhash_it:
 	__d_drop(dentry);
 kill_it:
-	/* if dentry was on d_lru list delete it from there */
+	/* if dentry was on the d_lru list delete it from there */
 	dentry_lru_del(dentry);
 	dentry = d_kill(dentry);
 	if (dentry)
@@ -468,11 +467,11 @@ restart:
 			BUG_ON(dentry->d_sb != sb);
 
 			spin_lock(&dentry->d_lock);
-		/*
-		 * If we are honouring the DCACHE_REFERENCED flag and the
-		 * dentry has this flag set, don't free it. Clear the flag
-		 * and put it back on the LRU
-		 */
+			/*
+			 * If we are honouring the DCACHE_REFERENCED flag and
+			 * the dentry has this flag set, don't free it. Clear
+			 * the flag and put it back on the LRU.
+		 	 */
 			if ((flags & DCACHE_REFERENCED)
 				&& (dentry->d_flags & DCACHE_REFERENCED)) {
 				dentry->d_flags &= ~DCACHE_REFERENCED;
@@ -501,10 +500,10 @@ restart:
 			continue;
 		}
 		prune_one_dentry(dentry);
-		/* dentry->d_lock is dropped in prune_one_dentry() */
+		/* dentry->d_lock was dropped in prune_one_dentry() */
 		cond_resched_lock(&dcache_lock);
 	}
-	if ((count == NULL) && (!list_empty(&sb->s_dentry_lru)))
+	if (count == NULL && !list_empty(&sb->s_dentry_lru))
 		goto restart;
 	if (count != NULL)
 		*count = cnt;
@@ -515,17 +514,13 @@ restart:
 
 /**
  * prune_dcache - shrink the dcache
- * @count: number of entries to try and free
+ * @count: number of entries to try to free
  *
- * Shrink the dcache. This is done when we need
- * more memory, or simply when we need to unmount
- * something (at which point we need to unuse
- * all dentries).
+ * Shrink the dcache. This is done when we need more memory, or simply when we
+ * need to unmount something (at which point we need to unuse all dentries).
  *
- * This function may fail to free any resources if
- * all the dentries are in use.
+ * This function may fail to free any resources if all the dentries are in use.
  */
- 
 static void prune_dcache(int count)
 {
 	struct super_block *sb;
@@ -548,10 +543,10 @@ restart:
 			continue;
 		sb->s_count++;
 		/* Now, we reclaim unused dentrins with fairness.
-		 * we reclaim them same percentage on each superblocks.
-		 * we calculate number of dentries to scan on this sb
-		 * based on following way, but impelementation is arranged
-		 * to avoid overflow.
+		 * We reclaim them same percentage from each superblock.
+		 * We calculate number of dentries to scan on this sb
+		 * as follows, but the implementation is arranged to avoid
+		 * overflows:
 		 * number of dentries to scan on this sb =
 		 * count * (number of dentries on this sb /
 		 * number of dentries in the machine)
diff -puN fs/super.c~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix fs/super.c
diff -puN include/linux/fs.h~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix include/linux/fs.h
--- a/include/linux/fs.h~fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix
+++ a/include/linux/fs.h
@@ -1063,6 +1063,7 @@ struct super_block {
 	struct list_head	s_more_io;	/* parked for more writeback */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_files;
+	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	int			s_nr_dentry_unused;	/* # of dentry on lru */
 
_

