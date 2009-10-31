Return-Path: <linux-kernel-owner+w=401wt.eu-S933114AbZJaSr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbZJaSr2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 14:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbZJaSr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 14:47:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932890AbZJaSr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 14:47:27 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 01/10] vfs: introduce FMODE_NONOTIFY
To: linux-kernel@vger.kernel.org, linus-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Sat, 31 Oct 2009 14:47:21 -0400
Message-ID: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new f_mode which can only be set by the kernel.  It indicates
that the fd was opened by fanotify and should not cause future fanotify
events.  This is needed to prevent fanotify livelock.  An example of
obvious livelock is from fanotify close events.

Process A closes file1
This creates a close event for file1.
fanotify opens file1 for Listener X
Listener X deals with the event and closes its fd for file1.
This creates a close event for file1.
fanotify opens file1 for Listener X
Listener X deals with the event and closes its fd for file1.
This creates a close event for file1.
fanotify opens file1 for Listener X
Listener X deals with the event and closes its fd for file1.
notice a pattern?

The fix is to add the FMODE_NONOTIFY bit to the open filp done by the kernel
for fanotify.  Thus when that file is used it will not generate future
events.

This patch simply defines the bit.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/open.c                   |    7 ++++---
 include/asm-generic/fcntl.h |    8 ++++++++
 include/linux/fs.h          |    3 +++
 include/linux/fsnotify.h    |   24 ++++++++++++++++--------
 4 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index ce737b3..7347eef 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -831,9 +831,10 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 	struct inode *inode;
 	int error;
 
-	f->f_flags = flags;
-	f->f_mode = (__force fmode_t)((flags+1) & O_ACCMODE) | FMODE_LSEEK |
-				FMODE_PREAD | FMODE_PWRITE;
+	f->f_flags = (flags & ~(FMODE_EXEC | FMODE_NONOTIFY));
+	f->f_mode = (__force fmode_t)((flags+1) & O_ACCMODE) | (flags & FMODE_NONOTIFY) |
+				FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
+
 	inode = dentry->d_inode;
 	if (f->f_mode & FMODE_WRITE) {
 		error = __get_file_write_access(inode, mnt);
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index 104fce8..30bece2 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -3,6 +3,14 @@
 
 #include <linux/types.h>
 
+/*
+ * FMODE_EXEC is 0x20
+ * FMODE_NONOTIFY is 0x800000
+ * These cannot be used by userspace O_* until internal and external open
+ * flags are split.
+ * -Eric Paris
+ */
+
 #define O_ACCMODE	00000003
 #define O_RDONLY	00000000
 #define O_WRONLY	00000001
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ab92f13..752056f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -87,6 +87,9 @@ struct inodes_stat_t {
  */
 #define FMODE_NOCMTIME		((__force fmode_t)2048)
 
+/* File was opened by fanotify and shouldn't generate fanotify events */
+#define FMODE_NONOTIFY		((__force fmode_t)8388608)
+
 /*
  * The below are the various read and write types that we support. Some of
  * them include behavioral modifiers that send information down to the
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 294f488..cc4dead 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -197,8 +197,10 @@ static inline void fsnotify_access(struct file *file)
 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(path, NULL, mask);
-	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
+	if (!(file->f_mode & FMODE_NONOTIFY)) {
+		fsnotify_parent(path, NULL, mask);
+		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
+	}
 }
 
 /*
@@ -215,8 +217,10 @@ static inline void fsnotify_modify(struct file *file)
 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(path, NULL, mask);
-	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
+	if (!(file->f_mode & FMODE_NONOTIFY)) {
+		fsnotify_parent(path, NULL, mask);
+		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
+	}
 }
 
 /*
@@ -233,8 +237,10 @@ static inline void fsnotify_open(struct file *file)
 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(path, NULL, mask);
-	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
+	if (!(file->f_mode & FMODE_NONOTIFY)) {
+		fsnotify_parent(path, NULL, mask);
+		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
+	}
 }
 
 /*
@@ -252,8 +258,10 @@ static inline void fsnotify_close(struct file *file)
 
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
 
-	fsnotify_parent(path, NULL, mask);
-	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
+	if (!(file->f_mode & FMODE_NONOTIFY)) {
+		fsnotify_parent(path, NULL, mask);
+		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
+	}
 }
 
 /*

