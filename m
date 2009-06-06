Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZFFDHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZFFDHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 23:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZFFDHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 23:07:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:34564 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575AbZFFDHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 23:07:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,314,1241420400"; 
   d="scan'208";a="151294342"
Date: Sat, 6 Jun 2009 11:07:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Eric Sandeen <sandeen@sandeen.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Nick Piggin <npiggin@suse.de>, Jeff Layton <jlayton@redhat.com>
Subject: [PATCH] writeback: skip new or to-be-freed inodes
Message-ID: <20090606030725.GA12852@localhost>
References: <20090324155655.2684.61FB500B@jp.fujitsu.com> <20090324074457.GA7745@localhost> <20090324120502.GC23439@duck.suse.cz> <20090324124001.GA25326@localhost> <4A244A5B.7070605@sandeen.net> <20090602085523.GC7161@localhost> <20090602113736.GB15010@duck.suse.cz> <20090603141021.GB5738@localhost> <20090603141636.GC5650@duck.suse.cz> <20090603144711.GC5738@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603144711.GC5738@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) I_FREEING tests should be coupled with I_CLEAR

The two I_FREEING tests are racy because clear_inode() can set i_state to
I_CLEAR between the clear of I_SYNC and the test of I_FREEING.

2) skip I_WILL_FREE inodes in generic_sync_sb_inodes() to avoid possible
   races with generic_forget_inode()

generic_forget_inode() sets I_WILL_FREE call writeback on its own, so
generic_sync_sb_inodes() shall not try to step in and create possible races:

  generic_forget_inode
    inode->i_state |= I_WILL_FREE;
    spin_unlock(&inode_lock);
                                       generic_sync_sb_inodes()
                                         spin_lock(&inode_lock);
                                         __iget(inode);
                                         __writeback_single_inode
                                           // see non zero i_count
 may WARN here ==>                         WARN_ON(inode->i_state & I_WILL_FREE);
                                         spin_unlock(&inode_lock);
 may call generic_forget_inode again ==> iput(inode);

The above race and warning didn't turn up because writeback_inodes() holds
the s_umount lock, so generic_forget_inode() finds MS_ACTIVE and returns
early. But we are not sure the UBIFS calls and future callers will guarantee
that. So skip I_WILL_FREE inodes for the sake of safety.

CC: Jan Kara <jack@suse.cz>
CC: Eric Sandeen <sandeen@sandeen.net>
Acked-by: Jeff Layton <jlayton@redhat.com>
CC: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux.orig/fs/fs-writeback.c
+++ linux/fs/fs-writeback.c
@@ -316,7 +316,7 @@ __sync_single_inode(struct inode *inode,
 	spin_lock(&inode_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state &= ~I_SYNC;
-	if (!(inode->i_state & I_FREEING)) {
+	if (!(inode->i_state & (I_FREEING | I_CLEAR))) {
 		if (!(inode->i_state & I_DIRTY) &&
 		    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
@@ -487,7 +487,7 @@ void generic_sync_sb_inodes(struct super
 			break;
 		}
 
-		if (inode->i_state & I_NEW) {
+		if (inode->i_state & (I_NEW | I_WILL_FREE)) {
 			requeue_io(inode);
 			continue;
 		}
@@ -518,7 +518,7 @@ void generic_sync_sb_inodes(struct super
 		if (current_is_pdflush() && !writeback_acquire(bdi))
 			break;
 
-		BUG_ON(inode->i_state & I_FREEING);
+		BUG_ON(inode->i_state & (I_FREEING | I_CLEAR));
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
 		__writeback_single_inode(inode, wbc);
