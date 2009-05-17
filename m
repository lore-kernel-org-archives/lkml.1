Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZEQNxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZEQNxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 09:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZEQNxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 09:53:33 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43691 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZEQNxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 09:53:32 -0400
Date: Sun, 17 May 2009 14:52:32 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: [PATCH mmotm] fsnotify: don't slow everything down
Message-ID: <Pine.LNX.4.64.0905171445290.18657@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two little fixes to mmotm's fsnotify-parent-event-notification.patch:

Why is copying or building a kernel tree using twice as much system time
as before?  Lots of time spent in __fsnotify_update_child_dentry_flags()
when it shouldn't even get called.  Fix | to & in __fsnotify_parent().

And it's probably a bad idea to have DCACHE_FSNOTIFY_PARENT_WATCHED
sharing the same d_flags bit as DCACHE_COOKIE: though the COOKIE bit has
prior claim, change it to keep the NOTIFY_PARENT_WATCHED bits together.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 fs/notify/fsnotify.c   |    2 +-
 include/linux/dcache.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- mmotm/fs/notify/fsnotify.c	2009-05-14 11:27:38.000000000 +0100
+++ linux/fs/notify/fsnotify.c	2009-05-17 13:31:23.000000000 +0100
@@ -84,7 +84,7 @@ void __fsnotify_parent(struct dentry *de
 	bool send = false;
 	bool should_update_children = false;
 
-	if (!(dentry->d_flags | DCACHE_FSNOTIFY_PARENT_WATCHED))
+	if (!(dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED))
 		return;
 
 	spin_lock(&dentry->d_lock);
--- mmotm/include/linux/dcache.h	2009-05-14 11:27:39.000000000 +0100
+++ linux/include/linux/dcache.h	2009-05-17 13:31:23.000000000 +0100
@@ -183,7 +183,7 @@ d_iput:		no		no		no       yes
 #define DCACHE_INOTIFY_PARENT_WATCHED	0x0020 /* Parent inode is watched by inotify */
 #define DCACHE_FSNOTIFY_PARENT_WATCHED	0x0040 /* Parent inode is watched by some fsnotify listener */
 
-#define DCACHE_COOKIE		0x0040	/* For use by dcookie subsystem */
+#define DCACHE_COOKIE		0x0080	/* For use by dcookie subsystem */
 
 extern spinlock_t dcache_lock;
 extern seqlock_t rename_lock;
