Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZLCFxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZLCFxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 00:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZLCFxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 00:53:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbZLCFxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 00:53:37 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 4/5] fanotify: should_send_event needs to handle vfsmounts
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Thu, 03 Dec 2009 00:53:35 -0500
Message-ID: <20091203055334.21918.92393.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091203055315.21918.83562.stgit@paris.rdu.redhat.com>
References: <20091203055315.21918.83562.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

currently should_send_event in fanotify only cares about marks on inodes.
This patch extends that interface to indicate that it cares about events
that happened on vfsmounts.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify.c    |   56 +++++++++++++++++++++++++++++++-------
 include/linux/fsnotify_backend.h |    2 +
 2 files changed, 47 insertions(+), 11 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index aa5e926..202be8a 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -2,6 +2,7 @@
 #include <linux/fsnotify_backend.h>
 #include <linux/init.h>
 #include <linux/kernel.h> /* UINT_MAX */
+#include <linux/mount.h>
 #include <linux/types.h>
 
 #include "fanotify.h"
@@ -99,24 +100,35 @@ static int fanotify_handle_event(struct fsnotify_group *group, struct fsnotify_e
 	return ret;
 }
 
-static bool fanotify_should_send_event(struct fsnotify_group *group, struct inode *inode,
-				       struct vfsmount *mnt, __u32 mask, void *data,
-				       int data_type)
+static bool should_send_vfsmount_event(struct fsnotify_group *group, struct vfsmount *mnt,
+				       __u32 mask)
 {
 	struct fsnotify_mark *fsn_mark;
 	bool send;
 
-	pr_debug("%s: group=%p inode=%p mask=%x data=%p data_type=%d\n",
-		 __func__, group, inode, mask, data, data_type);
+	pr_debug("%s: group=%p vfsmount=%p mask=%x\n",
+		 __func__, group, mnt, mask);
 
-	/* sorry, fanotify only gives a damn about files and dirs */
-	if (!S_ISREG(inode->i_mode) &&
-	    !S_ISDIR(inode->i_mode))
+	fsn_mark = fsnotify_find_vfsmount_mark(group, mnt);
+	if (!fsn_mark)
 		return false;
 
-	/* if we don't have enough info to send an event to userspace say no */
-	if (data_type != FSNOTIFY_EVENT_PATH)
-		return false;
+	send = (mask & fsn_mark->mask);
+
+	/* find took a reference */
+	fsnotify_put_mark(fsn_mark);
+
+	return send;
+}
+
+static bool should_send_inode_event(struct fsnotify_group *group, struct inode *inode,
+				    __u32 mask)
+{
+	struct fsnotify_mark *fsn_mark;
+	bool send;
+
+	pr_debug("%s: group=%p inode=%p mask=%x\n",
+		 __func__, group, inode, mask);
 
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark)
@@ -142,6 +154,28 @@ static bool fanotify_should_send_event(struct fsnotify_group *group, struct inod
 	return send;
 }
 
+static bool fanotify_should_send_event(struct fsnotify_group *group, struct inode *to_tell,
+				       struct vfsmount *mnt, __u32 mask, void *data,
+				       int data_type)
+{
+	pr_debug("%s: group=%p to_tell=%p mnt=%p mask=%x data=%p data_type=%d\n",
+		 __func__, group, to_tell, mnt, mask, data, data_type);
+
+	/* sorry, fanotify only gives a damn about files and dirs */
+	if (!S_ISREG(to_tell->i_mode) &&
+	    !S_ISDIR(to_tell->i_mode))
+		return false;
+
+	/* if we don't have enough info to send an event to userspace say no */
+	if (data_type != FSNOTIFY_EVENT_PATH)
+		return false;
+
+	if (mnt)
+		return should_send_vfsmount_event(group, mnt, mask);
+	else
+		return should_send_inode_event(group, to_tell, mask);
+}
+
 const struct fsnotify_ops fanotify_fsnotify_ops = {
 	.handle_event = fanotify_handle_event,
 	.should_send_event = fanotify_should_send_event,
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 1af42cb..2d2f015 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -368,6 +368,8 @@ extern void fsnotify_recalc_inode_mask(struct inode *inode);
 extern void fsnotify_init_mark(struct fsnotify_mark *mark, void (*free_mark)(struct fsnotify_mark *mark));
 /* find (and take a reference) to a mark associated with group and inode */
 extern struct fsnotify_mark *fsnotify_find_inode_mark(struct fsnotify_group *group, struct inode *inode);
+/* find (and take a reference) to a mark associated with group and vfsmount */
+extern struct fsnotify_mark *fsnotify_find_vfsmount_mark(struct fsnotify_group *group, struct vfsmount *mnt);
 /* copy the values from old into new */
 extern void fsnotify_duplicate_mark(struct fsnotify_mark *new, struct fsnotify_mark *old);
 /* attach the mark to both the group and the inode */

