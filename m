Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbZCJNlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbZCJNlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbZCJNlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:41:11 -0400
Received: from mail.suse.de ([195.135.220.2]:43629 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbZCJNlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:41:10 -0400
Date: Tue, 10 Mar 2009 14:41:06 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Jorge Boncompte [DTI2]" <jorge@dti2.net>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>, stable@kernel.org
Subject: [patch] fs: avoid I_NEW inodes
Message-ID: <20090310134106.GA15977@wotan.suse.de>
References: <20090305064554.GA11916@wotan.suse.de> <20090305100000.GA29177@duck.suse.cz> <20090305101637.GB17815@wotan.suse.de> <20090305111226.GB29531@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305111226.GB29531@duck.suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 12:12:26PM +0100, Jan Kara wrote:
> On Thu 05-03-09 11:16:37, Nick Piggin wrote:
> > On Thu, Mar 05, 2009 at 11:00:01AM +0100, Jan Kara wrote:
> > > On Thu 05-03-09 07:45:54, Nick Piggin wrote:
> > > > after ~1hour of running. Previously, the new warnings would start immediately
> > > > and hang would happen in under 5 minutes.
> > >   A quick grep seems to indicate that you've still missed a few cases,
> > > haven't you? I still see the same problem in
> > > drop_caches.c:drop_pagecache_sb() scanning, inode.c:invalidate_inodes()
> > > scanning, and dquot.c:add_dquot_ref() scanning.
> > >   Otherwise the patch looks fine.
> > 
> > I thought they should be OK; drop_pagecache_sb doesn't play with flags,
> > invalidate_inodes won't if refcount is elevated, and I think add_dquot_ref
> > won't if writecount is not elevated...
>   Ah, ok, you are probably right.
> 
> > But maybe that's  abit fragile and it would be better policy to always
> > skip I_NEW in these traverals?
>   Yes, it seems too fragile to me. I'm not saying we have to forbid
> everything for I_NEW inodes but I think we should set clear simple rules
> what is protected by I_NEW and then verify that all sites which can come
> across such inodes obey them.

OK, sorry for the delay, what do you think of the following patch on top
of the last?

---

To be on the safe side, it should be less fragile to exclude I_NEW inodes
from inode list scans by default (unless there is an important reason to
have them).

Normally they will get excluded (eg. by zero refcount or writecount etc),
however it is a bit fragile for list walkers to know exactly what parts of
the inode state is set up and valid to test when in I_NEW. So along these
lines, move I_NEW checks upward as well (sometimes taking I_FREEING etc
checks with them too -- this shouldn't be a problem should it?)

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
 fs/dquot.c                  |    6 ++++--
 fs/drop_caches.c            |    2 +-
 fs/inode.c                  |    2 ++
 fs/notify/inotify/inotify.c |   16 ++++++++--------
 4 files changed, 15 insertions(+), 11 deletions(-)

Index: linux-2.6/fs/dquot.c
===================================================================
--- linux-2.6.orig/fs/dquot.c
+++ linux-2.6/fs/dquot.c
@@ -789,12 +789,12 @@ static void add_dquot_ref(struct super_b
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
+			continue;
 		if (!atomic_read(&inode->i_writecount))
 			continue;
 		if (!dqinit_needed(inode, type))
 			continue;
-		if (inode->i_state & (I_FREEING|I_WILL_FREE))
-			continue;
 
 		__iget(inode);
 		spin_unlock(&inode_lock);
@@ -870,6 +870,8 @@ static void remove_dquot_ref(struct supe
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		if (inode->i_state & I_NEW)
+			continue;
 		if (!IS_NOQUOTA(inode))
 			remove_inode_dquot_ref(inode, type, tofree_head);
 	}
Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c
+++ linux-2.6/fs/drop_caches.c
@@ -18,7 +18,7 @@ static void drop_pagecache_sb(struct sup
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (inode->i_state & (I_FREEING|I_WILL_FREE))
+		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
 			continue;
 		if (inode->i_mapping->nrpages == 0)
 			continue;
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c
+++ linux-2.6/fs/inode.c
@@ -356,6 +356,8 @@ static int invalidate_list(struct list_h
 		if (tmp == head)
 			break;
 		inode = list_entry(tmp, struct inode, i_sb_list);
+		if (inode->i_state & I_NEW)
+			continue;
 		invalidate_inode_buffers(inode);
 		if (!atomic_read(&inode->i_count)) {
 			list_move(&inode->i_list, dispose);
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -380,6 +380,14 @@ void inotify_unmount_inodes(struct list_
 		struct list_head *watches;
 
 		/*
+		 * We cannot __iget() an inode in state I_CLEAR, I_FREEING, or
+		 * I_WILL_FREE which is fine because by that point the inode
+		 * cannot have any associated watches.
+		 */
+		if (inode->i_state & (I_CLEAR|I_FREEING|I_WILL_FREE|I_NEW))
+			continue;
+
+		/*
 		 * If i_count is zero, the inode cannot have any watches and
 		 * doing an __iget/iput with MS_ACTIVE clear would actually
 		 * evict all inodes with zero i_count from icache which is
@@ -388,14 +396,6 @@ void inotify_unmount_inodes(struct list_
 		if (!atomic_read(&inode->i_count))
 			continue;
 
-		/*
-		 * We cannot __iget() an inode in state I_CLEAR, I_FREEING, or
-		 * I_WILL_FREE which is fine because by that point the inode
-		 * cannot have any associated watches.
-		 */
-		if (inode->i_state & (I_CLEAR | I_FREEING | I_WILL_FREE))
-			continue;
-
 		need_iput_tmp = need_iput;
 		need_iput = NULL;
 		/* In case inotify_remove_watch_locked() drops a reference. */
