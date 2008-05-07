Return-Path: <linux-kernel-owner+w=401wt.eu-S1763365AbYEGQ4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763365AbYEGQ4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYEGQ4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:56:32 -0400
Received: from smtp.nokia.com ([192.100.105.134]:46768 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbYEGQ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:56:28 -0400
Message-ID: <4821DF13.2010207@yandex.ru>
Date: Wed, 07 May 2008 19:55:47 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH take 2 01/28] VFS: introduce writeback_inodes_sb()
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>	<1210070159-22794-2-git-send-email-Artem.Bityutskiy@nokia.com>	<20080507002345.831bc379.akpm@linux-foundation.org>	<48218F21.4090304@yandex.ru> <20080507083835.6ba126e6.akpm@linux-foundation.org>
In-Reply-To: <20080507083835.6ba126e6.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------070308070101000608010006"
X-OriginalArrivalTime: 07 May 2008 16:56:01.0084 (UTC) FILETIME=[3A9037C0:01C8B063]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070308070101000608010006
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Andrew Morton wrote:
> I already added gti-ubifs.patch to the -mm lineup.  I haven't yet tried
> pulling, merging or compiling it.

Cool.

> I'd suggest that you just retain this patch in your tree.
> 
>> Should I amend the reiser4 patch correspondingly for you?
> 
> That would be nice, if you have time, thanks.

I've split the original patch on 3 pieces:
1. VFS: move inode_lock into sync_sb_inodes
2. VFS: export sync_sb_inodes
3. VFS: introduce sync_inodes superblock operation

The first 2 are exactly what UBIFS also needs. The third one is only
needed for Reiser4. The patches are attached.

I am not sure this is the best way to split. The second patch could
just export sync_sb_inodes() without renaming it to
generic_sync_sb_inodes(). But in this case we would have more complex
third patch and more dependencies between reiser4 and ubifs. What is
better?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

--------------070308070101000608010006
Content-Type: text/x-patch;
 name="0001-VFS-move-inode_lock-into-sync_sb_inodes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-VFS-move-inode_lock-into-sync_sb_inodes.patch"

>From 8b8614f78c3d97ac1980ca4205d8d9f52599ac14 Mon Sep 17 00:00:00 2001
From: Hans Reiser <reiser@namesys.com>
Date: Wed, 7 May 2008 15:48:57 +0300
Subject: [PATCH] VFS: move inode_lock into sync_sb_inodes

This patch makes 'sync_sb_inodes()' lock 'inode_lock', rather
than expect that the caller will do this.

This change was previously done by Hans Reiser <reiser@namesys.com>
and sat in the -mm tree.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ae45f77..16519fe 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -424,8 +424,6 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
  * WB_SYNC_HOLD is a hack for sys_sync(): reattach the inode to sb->s_dirty so
  * that it can be located for waiting on in __writeback_single_inode().
  *
- * Called under inode_lock.
- *
  * If `bdi' is non-zero then we're being asked to writeback a specific queue.
  * This function assumes that the blockdev superblock's inodes are backed by
  * a variety of queues, so all inodes are searched.  For other superblocks,
@@ -446,6 +444,7 @@ sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 {
 	const unsigned long start = jiffies;	/* livelock avoidance */
 
+	spin_lock(&inode_lock);
 	if (!wbc->for_kupdate || list_empty(&sb->s_io))
 		queue_io(sb, wbc->older_than_this);
 
@@ -524,6 +523,7 @@ sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 		if (!list_empty(&sb->s_more_io))
 			wbc->more_io = 1;
 	}
+	spin_unlock(&inode_lock);
 	return;		/* Leave any unwritten inodes on s_io */
 }
 
@@ -565,11 +565,8 @@ restart:
 			 * be unmounted by the time it is released.
 			 */
 			if (down_read_trylock(&sb->s_umount)) {
-				if (sb->s_root) {
-					spin_lock(&inode_lock);
+				if (sb->s_root)
 					sync_sb_inodes(sb, wbc);
-					spin_unlock(&inode_lock);
-				}
 				up_read(&sb->s_umount);
 			}
 			spin_lock(&sb_lock);
@@ -607,9 +604,7 @@ void sync_inodes_sb(struct super_block *sb, int wait)
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused) +
 			nr_dirty + nr_unstable;
 	wbc.nr_to_write += wbc.nr_to_write / 2;		/* Bit more for luck */
-	spin_lock(&inode_lock);
 	sync_sb_inodes(sb, &wbc);
-	spin_unlock(&inode_lock);
 }
 
 /*
-- 
1.5.4.1


--------------070308070101000608010006
Content-Type: text/x-patch;
 name="0002-VFS-export-sync_sb_inodes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-VFS-export-sync_sb_inodes.patch"

>From 42ccbfa209e4799e5f60b5ec6878da1c447d29b2 Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 7 May 2008 21:01:30 +0300
Subject: [PATCH] VFS: export sync_sb_inodes

This patch exports the 'sync_sb_inodes()' which is needed for
UBIFS because it have to force write-back from time to time.
Namely, the UBIFS budgeting subsystem forces write-back when
its pessimistic callculations show that there is not free
space on the media.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c  |   11 +++++++++--
 include/linux/fs.h |    2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 16519fe..25adfc3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -439,8 +439,8 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
  * on the writer throttling path, and we get decent balancing between many
  * throttled threads: we don't want them all piling up on inode_sync_wait.
  */
-static void
-sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
+void generic_sync_sb_inodes(struct super_block *sb,
+				struct writeback_control *wbc)
 {
 	const unsigned long start = jiffies;	/* livelock avoidance */
 
@@ -526,6 +526,13 @@ sync_sb_inodes(struct super_block *sb, struct writeback_control *wbc)
 	spin_unlock(&inode_lock);
 	return;		/* Leave any unwritten inodes on s_io */
 }
+EXPORT_SYMBOL_GPL(generic_sync_sb_inodes);
+
+static void sync_sb_inodes(struct super_block *sb,
+				struct writeback_control *wbc)
+{
+	generic_sync_sb_inodes(sb, wbc);
+}
 
 /*
  * Start writeback of dirty pagecache data against all unlocked inodes.
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7e0fa9e..85ee6cf 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1730,6 +1730,8 @@ static inline void invalidate_remote_inode(struct inode *inode)
 extern int invalidate_inode_pages2(struct address_space *mapping);
 extern int invalidate_inode_pages2_range(struct address_space *mapping,
 					 pgoff_t start, pgoff_t end);
+extern void generic_sync_sb_inodes(struct super_block *sb,
+				struct writeback_control *wbc);
 extern int write_inode_now(struct inode *, int);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
-- 
1.5.4.1


--------------070308070101000608010006
Content-Type: text/x-patch;
 name="0003-VFS-introduce-sync_inodes-superblock-operation.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0003-VFS-introduce-sync_inodes-superblock-operation.patch"

>From 3627f07f280e519db66056f39a23abd267400218 Mon Sep 17 00:00:00 2001
From: Hans Reiser <reiser@namesys.com>
Date: Wed, 7 May 2008 21:04:39 +0300
Subject: [PATCH] VFS: introduce sync_inodes superblock operation

This patch adds new operation to struct super_operations - sync_inodes,
generic implementaion and changes fs-writeback.c:sync_sb_inodes() to call
filesystem's sync_inodes if it is defined or generic implementaion otherwise.
This new operation allows filesystem to decide itself what to flush.

Reiser4 flushes dirty pages on basic of atoms, not of inodes.  sync_sb_inodes
used to call address space flushing method (writepages) for every dirty inode.
 For reiser4 it caused having to commit atoms unnecessarily often.  This
turned into substantial slowdown.  Having this method helped to fix that
problem.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c  |    5 ++++-
 include/linux/fs.h |    2 ++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 25adfc3..495214d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -531,7 +531,10 @@ EXPORT_SYMBOL_GPL(generic_sync_sb_inodes);
 static void sync_sb_inodes(struct super_block *sb,
 				struct writeback_control *wbc)
 {
-	generic_sync_sb_inodes(sb, wbc);
+	if (sb->s_op->sync_inodes)
+		sb->s_op->sync_inodes(sb, wbc);
+	else
+		generic_sync_sb_inodes(sb, wbc);
 }
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 85ee6cf..777494b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1307,6 +1307,8 @@ struct super_operations {
 	void (*clear_inode) (struct inode *);
 	void (*umount_begin) (struct super_block *);
 
+	void (*sync_inodes)(struct super_block *sb,
+				struct writeback_control *wbc);
 	int (*show_options)(struct seq_file *, struct vfsmount *);
 	int (*show_stats)(struct seq_file *, struct vfsmount *);
 #ifdef CONFIG_QUOTA
-- 
1.5.4.1


--------------070308070101000608010006--
