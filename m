Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0BMJOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 04:14:36 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:59868 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab0BMJOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 04:14:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=RtkLRh5iuxYo8CZ9gfUBs3IF9RuDQcWa1UPeaPZ8lPE2Gtu6JxTreJ4eM+qc6hba1z
         UiBhII4krwA6v1xDF/osT90rHgfJrWH09jUZhV/a1i8rwXIQJpt4a7Ifr3YJ42gbuF4D
         UjHuK2Fs7mX/ffOUqjlVW2EhJIpPEv2ofNibk=
Date: Sat, 13 Feb 2010 10:08:21 +0100
From: Joris Dolderer <vorstadtkind@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: eparis@redhat.com
Subject: [PATCH 3/3] inotify: tree-watching support
Message-Id: <20100213100821.bf7e84ce.vorstadtkind@googlemail.com>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tree-watching support to inotify.

In userspace, you have to add an IN_TREE flag to mask.
Signed-off-by: Joris Dolderer <vorstadtkind@googlemail.com>
---
 fs/notify/inotify/inotify_fsnotify.c |    6 ++++--
 fs/notify/inotify/inotify_user.c     |   11 ++++++++---
 include/linux/inotify.h              |    2 +-
 3 files changed, 13 insertions(+), 6 deletions(-)
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 1afb0a1..d42a8cd 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -89,6 +89,7 @@ static bool inotify_should_send_event(struct fsnotify_group *group, struct inode
 {
 	struct fsnotify_mark_entry *entry;
 	bool send;
+	__u32 test_mask;
 
 	spin_lock(&inode->i_lock);
 	entry = fsnotify_find_mark_entry(group, inode);
@@ -96,8 +97,9 @@ static bool inotify_should_send_event(struct fsnotify_group *group, struct inode
 	if (!entry)
 		return false;
 
-	mask = (mask & ~FS_EVENT_ON_CHILD);
-	send = (entry->mask & mask);
+	test_mask = mask & ~FS_EVENT_ON_TREE;
+	send = entry->mask & test_mask;
+	send = send && ((mask & FS_EVENT_ON_TREE) ? ((entry->mask & mask) & FS_EVENT_ON_TREE) : true);
 
 	/* find took a reference */
 	fsnotify_put_mark(entry);
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index a94e8bd..575bbf8 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -11,6 +11,8 @@
  * Copyright (C) 2009 Eric Paris <Red Hat Inc>
  * inotify was largely rewriten to make use of the fsnotify infrastructure
  *
+ * Tree-watching support (C) 2010 Joris Dolderer <vorstadtkind@googlemail.com>
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
  * Free Software Foundation; either version 2, or (at your option) any
@@ -100,12 +102,15 @@ static inline __u32 inotify_arg_to_mask(u32 arg)
 {
 	__u32 mask;
 
-	/* everything should accept their own ignored and cares about children */
-	mask = (FS_IN_IGNORED | FS_EVENT_ON_CHILD);
+	/* everything should accept their own ignored*/
+	mask = FS_IN_IGNORED;
 
 	/* mask off the flags used to open the fd */
 	mask |= (arg & (IN_ALL_EVENTS | IN_ONESHOT));
 
+	/* care about children or descents */
+	mask |= (arg & IN_TREE) ? FS_EVENT_ON_DESCENT : FS_EVENT_ON_CHILD;
+
 	return mask;
 }
 
@@ -505,7 +510,7 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 
 		/* update the inode with this new entry */
 		if (dropped || do_inode)
-			fsnotify_recalc_inode_mask(inode);
+			fsnotify_recalc_inode_mask(inode, (old_mask ^ new_mask) & IN_TREE);
 
 		/* update the group mask with the new mask */
 		if (dropped || do_group)
diff --git a/include/linux/inotify.h b/include/linux/inotify.h
index 37ea289..b5bef0b 100644
--- a/include/linux/inotify.h
+++ b/include/linux/inotify.h
@@ -49,12 +49,12 @@ struct inotify_event {
 #define IN_MOVE			(IN_MOVED_FROM | IN_MOVED_TO) /* moves */
 
 /* special flags */
+#define IN_TREE			0x00800000	/* watch the whole directory tree */
 #define IN_ONLYDIR		0x01000000	/* only watch the path if it is a directory */
 #define IN_DONT_FOLLOW		0x02000000	/* don't follow a sym link */
 #define IN_MASK_ADD		0x20000000	/* add to the mask of an already existing watch */
 #define IN_ISDIR		0x40000000	/* event occurred against dir */
 #define IN_ONESHOT		0x80000000	/* only send event once */
-
 /*
  * All of the events - we build the list by hand so that we can add flags in
  * the future and not break backward compatibility.  Apps will get only the
