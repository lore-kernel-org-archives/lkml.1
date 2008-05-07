Return-Path: <linux-kernel-owner+w=401wt.eu-S1764357AbYEGLPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764357AbYEGLPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbYEGLPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:15:44 -0400
Received: from smtp.nokia.com ([192.100.122.230]:28289 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbYEGLPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:15:42 -0400
Message-ID: <48218F21.4090304@yandex.ru>
Date: Wed, 07 May 2008 14:14:41 +0300
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
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>	<1210070159-22794-2-git-send-email-Artem.Bityutskiy@nokia.com> <20080507002345.831bc379.akpm@linux-foundation.org>
In-Reply-To: <20080507002345.831bc379.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------030300030705010500000706"
X-OriginalArrivalTime: 07 May 2008 11:14:51.0383 (UTC) FILETIME=[91ABB870:01C8B033]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030300030705010500000706
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Andrew,

Andrew Morton wrote:
> This looks rather similar to
> http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-sb_sync_inodes.patch
> 
> Which is best?

Well, this reiser4 patch is basically doing 3 things at once:
1. Introduce ->sync_inodes()
2. Move spin_lock(&inode_lock);
3. Export generic_sync_sb_inodes()

As Christoph suggested, I've attached a patch which just moves the
spinlock. Could you please consider sending it to Linus or taking into your tree?
Should I amend the reiser4 patch correspondingly for you?

Also, what do you think about taking UBIFS into your tree?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

--------------030300030705010500000706
Content-Type: text/x-patch;
 name="0001-VFS-move-inode_lock-into-sync_sb_inodes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-VFS-move-inode_lock-into-sync_sb_inodes.patch"

>From d6caf6c109cc21e88bbe165f144574c736e85c2b Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
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


--------------030300030705010500000706--
