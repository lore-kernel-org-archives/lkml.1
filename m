Return-Path: <linux-kernel-owner+w=401wt.eu-S1763941AbZAWGat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763941AbZAWGat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761260AbZAWGRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:17:03 -0500
Received: from kroah.org ([198.145.64.141]:36444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761271AbZAWGQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:58 -0500
Date: Thu, 22 Jan 2009 22:14:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Nick Piggin <npiggin@suse.de>
Subject: [patch 38/40] fs: remove WB_SYNC_HOLD
Message-ID: <20090123061456.GL2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fs-remove-wb_sync_hold.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit 4f5a99d64c17470a784a6c68064207d82e3e74a5 upstream.

Remove WB_SYNC_HOLD.  The primary motiviation is the design of my
anti-starvation code for fsync.  It requires taking an inode lock over the
sync operation, so we could run into lock ordering problems with multiple
inodes.  It is possible to take a single global lock to solve the ordering
problem, but then that would prevent a future nice implementation of "sync
multiple inodes" based on lock order via inode address.

Seems like a backward step to remove this, but actually it is busted
anyway: we can't use the inode lists for data integrity wait: an inode can
be taken off the dirty lists but still be under writeback.  In order to
satisfy data integrity semantics, we should wait for it to finish
writeback, but if we only search the dirty lists, we'll miss it.

It would be possible to have a "writeback" list, for sys_sync, I suppose.
But why complicate things by prematurely optimise?  For unmounting, we
could avoid the "livelock avoidance" code, which would be easier, but
again premature IMO.

Fixing the existing data integrity problem will come next.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fs-writeback.c         |   12 ++----------
 include/linux/writeback.h |    1 -
 2 files changed, 2 insertions(+), 11 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -421,9 +421,6 @@ __writeback_single_inode(struct inode *i
  * If we're a pdlfush thread, then implement pdflush collision avoidance
  * against the entire list.
  *
- * WB_SYNC_HOLD is a hack for sys_sync(): reattach the inode to sb->s_dirty so
- * that it can be located for waiting on in __writeback_single_inode().
- *
  * If `bdi' is non-zero then we're being asked to writeback a specific queue.
  * This function assumes that the blockdev superblock's inodes are backed by
  * a variety of queues, so all inodes are searched.  For other superblocks,
@@ -499,10 +496,6 @@ void generic_sync_sb_inodes(struct super
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
 		__writeback_single_inode(inode, wbc);
-		if (wbc->sync_mode == WB_SYNC_HOLD) {
-			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &sb->s_dirty);
-		}
 		if (current_is_pdflush())
 			writeback_release(bdi);
 		if (wbc->pages_skipped != pages_skipped) {
@@ -588,8 +581,7 @@ restart:
 
 /*
  * writeback and wait upon the filesystem's dirty inodes.  The caller will
- * do this in two passes - one to write, and one to wait.  WB_SYNC_HOLD is
- * used to park the written inodes on sb->s_dirty for the wait pass.
+ * do this in two passes - one to write, and one to wait.
  *
  * A finite limit is set on the number of pages which will be written.
  * To prevent infinite livelock of sys_sync().
@@ -600,7 +592,7 @@ restart:
 void sync_inodes_sb(struct super_block *sb, int wait)
 {
 	struct writeback_control wbc = {
-		.sync_mode	= wait ? WB_SYNC_ALL : WB_SYNC_HOLD,
+		.sync_mode	= wait ? WB_SYNC_ALL : WB_SYNC_NONE,
 		.range_start	= 0,
 		.range_end	= LLONG_MAX,
 	};
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -30,7 +30,6 @@ static inline int task_is_pdflush(struct
 enum writeback_sync_modes {
 	WB_SYNC_NONE,	/* Don't wait on anything */
 	WB_SYNC_ALL,	/* Wait on every mapping */
-	WB_SYNC_HOLD,	/* Hold the inode on sb_dirty for sys_sync() */
 };
 
 /*

