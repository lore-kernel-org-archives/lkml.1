Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbZDWHkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbZDWHkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbZDWHaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:30:13 -0400
Received: from sous-sol.org ([216.99.217.87]:50344 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756329AbZDWHaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:30:07 -0400
Message-Id: <20090423072442.586401775@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:55 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Wu Fengguang <fengguang.wu@intel.com>
Subject: [patch 035/100] vfs: skip I_CLEAR state inodes
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=vfs-skip-i_clear-state-inodes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Wu Fengguang <fengguang.wu@intel.com>

upstream commit: b6fac63cc1f52ec27f29fe6c6c8494a2ffac33fd

clear_inode() will switch inode state from I_FREEING to I_CLEAR, and do so
_outside_ of inode_lock.  So any I_FREEING testing is incomplete without a
coupled testing of I_CLEAR.

So add I_CLEAR tests to drop_pagecache_sb(), generic_sync_sb_inodes() and
add_dquot_ref().

Masayoshi MIZUMA discovered the bug in drop_pagecache_sb() and Jan Kara
reminds fixing the other two cases.

Masayoshi MIZUMA has a nice panic flow:

=====================================================================
            [process A]               |        [process B]
 |                                    |
 |    prune_icache()                  | drop_pagecache()
 |      spin_lock(&inode_lock)        |   drop_pagecache_sb()
 |      inode->i_state |= I_FREEING;  |       |
 |      spin_unlock(&inode_lock)      |       V
 |          |                         |     spin_lock(&inode_lock)
 |          V                         |         |
 |      dispose_list()                |         |
 |        list_del()                  |         |
 |        clear_inode()               |         |
 |          inode->i_state = I_CLEAR  |         |
 |            |                       |         V
 |            |                       |      if (inode->i_state & (I_FREEING|I_WILL_FREE))
 |            |                       |              continue;           <==== NOT MATCH
 |            |                       |
 |            |                       | (DANGER from here on! Accessing disposing inode!)
 |            |                       |
 |            |                       |      __iget()
 |            |                       |        list_move() <===== PANIC on poisoned list !!
 V            V                       |
(time)
=====================================================================

Reported-by: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[chrisw: backport to 2.6.29]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/dquot.c        |    2 +-
 fs/drop_caches.c  |    2 +-
 fs/fs-writeback.c |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -18,7 +18,7 @@ static void drop_pagecache_sb(struct sup
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE))
+		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
 			continue;
 		if (inode->i_mapping->nrpages == 0)
 			continue;
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -538,7 +538,8 @@ void generic_sync_sb_inodes(struct super
 		list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 			struct address_space *mapping;
 
-			if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+			if (inode->i_state &
+					(I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
 				continue;
 			mapping = inode->i_mapping;
 			if (mapping->nrpages == 0)
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -793,7 +793,7 @@ static void add_dquot_ref(struct super_b
 			continue;
 		if (!dqinit_needed(inode, type))
 			continue;
-		if (inode->i_state & (I_FREEING|I_WILL_FREE))
+		if (inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE))
 			continue;
 
 		__iget(inode);

