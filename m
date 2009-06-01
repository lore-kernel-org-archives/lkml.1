Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbZFAUDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbZFAUDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbZFAUDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:03:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49307 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbZFAUDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:03:16 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/4] fsnotify: move events should indicate the event was on a
	child
To: linux-kernel@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, hch@lst.de, eparis@redhat.com
Date: Mon, 01 Jun 2009 16:03:14 -0400
Message-ID: <20090601200314.16582.70992.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsnotify tells its listeners explicitly when an event happened on the given
inode verses on the child of the given inode.  (see __fsnotify_parent)
However, the semantics of fsnotify_move() are such that we deliver events
directly to the two parent directories in question (old_dir and new_dir)
directly without using the __fsnotify_parent() call.  fsnotify should be
adding FS_EVENT_ON_CHILD for the notifications to these parents.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/fsnotify.h |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index bdf626b..c2e8066 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -83,12 +83,11 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 	struct inode *source = moved->d_inode;
 	u32 in_cookie = inotify_get_cookie();
 	u32 fs_cookie = fsnotify_get_cookie();
-	__u32 old_dir_mask = 0;
-	__u32 new_dir_mask = 0;
+	__u32 old_dir_mask = (FS_EVENT_ON_CHILD | FS_MOVED_FROM);
+	__u32 new_dir_mask = (FS_EVENT_ON_CHILD | FS_MOVED_TO);
 
-	if (old_dir == new_dir) {
-		old_dir_mask = FS_DN_RENAME;
-	}
+	if (old_dir == new_dir)
+		old_dir_mask |= FS_DN_RENAME;
 
 	if (isdir) {
 		isdir = IN_ISDIR;
@@ -96,9 +95,6 @@ static inline void fsnotify_move(struct inode *old_dir, struct inode *new_dir,
 		new_dir_mask |= FS_IN_ISDIR;
 	}
 
-	old_dir_mask |= FS_MOVED_FROM;
-	new_dir_mask |= FS_MOVED_TO;
-
 	inotify_inode_queue_event(old_dir, IN_MOVED_FROM|isdir, in_cookie, old_name,
 				  source);
 	inotify_inode_queue_event(new_dir, IN_MOVED_TO|isdir, in_cookie, new_name,

