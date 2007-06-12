Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbXFLHGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbXFLHGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758497AbXFLHAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:45 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13574 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbXFLHAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:32 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 11/18] splice: divorce the splice structure/function definitions from the pipe header
Date: Tue, 12 Jun 2007 08:58:07 +0200
Message-Id: <1181631495909-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We need to move even more stuff into the header so that folks can use
the splice_to_pipe() implementation instead of open-coding a lot of
pipe knowledge (see relay implementation), so move to our own header
file finally.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/block/loop.c      |    2 +-
 drivers/char/mem.c        |    2 +-
 fs/nfsd/vfs.c             |    2 +-
 fs/ocfs2/file.c           |    2 +-
 fs/read_write.c           |    2 +-
 fs/splice.c               |   26 +++-------------
 include/linux/pipe_fs_i.h |   41 -------------------------
 include/linux/splice.h    |   72 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/relay.c            |    2 +-
 9 files changed, 83 insertions(+), 68 deletions(-)
 create mode 100644 include/linux/splice.h

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 562d329..8ffbac3 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -74,7 +74,7 @@
 #include <linux/highmem.h>
 #include <linux/gfp.h>
 #include <linux/kthread.h>
-#include <linux/pipe_fs_i.h>
+#include <linux/splice.h>
 
 #include <asm/uaccess.h>
 
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index cc9a9d0..d2e4cfd 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -24,7 +24,7 @@
 #include <linux/crash_dump.h>
 #include <linux/backing-dev.h>
 #include <linux/bootmem.h>
-#include <linux/pipe_fs_i.h>
+#include <linux/splice.h>
 #include <linux/pfn.h>
 
 #include <asm/uaccess.h>
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 96f76e2..0b42580 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -23,7 +23,7 @@
 #include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/major.h>
-#include <linux/pipe_fs_i.h>
+#include <linux/splice.h>
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 4f6033a..c549332 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -31,7 +31,7 @@
 #include <linux/pagemap.h>
 #include <linux/uio.h>
 #include <linux/sched.h>
-#include <linux/pipe_fs_i.h>
+#include <linux/splice.h>
 #include <linux/mount.h>
 #include <linux/writeback.h>
 
diff --git a/fs/read_write.c b/fs/read_write.c
index 47da8a4..2527cf0 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -15,7 +15,7 @@
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
-#include <linux/pipe_fs_i.h>
+#include <linux/splice.h>
 #include "read_write.h"
 
 #include <asm/uaccess.h>
diff --git a/fs/splice.c b/fs/splice.c
index 837be82..15d3f4b 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -20,7 +20,7 @@
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/pagemap.h>
-#include <linux/pipe_fs_i.h>
+#include <linux/splice.h>
 #include <linux/mm_inline.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
@@ -29,22 +29,6 @@
 #include <linux/syscalls.h>
 #include <linux/uio.h>
 
-struct partial_page {
-	unsigned int offset;
-	unsigned int len;
-};
-
-/*
- * Passed to splice_to_pipe
- */
-struct splice_pipe_desc {
-	struct page **pages;		/* page map */
-	struct partial_page *partial;	/* pages[] may not be contig */
-	int nr_pages;			/* number of pages in map */
-	unsigned int flags;		/* splice flags */
-	const struct pipe_buf_operations *ops;/* ops associated with output pipe */
-};
-
 /*
  * Attempt to steal a page from a pipe buffer. This should perhaps go into
  * a vm helper function, it's already simplified quite a bit by the
@@ -170,11 +154,11 @@ static const struct pipe_buf_operations user_page_pipe_buf_ops = {
 };
 
 /*
- * Pipe output worker. This sets up our pipe format with the page cache
- * pipe buffer operations. Otherwise very similar to the regular pipe_writev().
+ * Pipe output worker. This fills a pipe with the information contained
+ * from splice_pipe_desc().
  */
-static ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
-			      struct splice_pipe_desc *spd)
+ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
+		       struct splice_pipe_desc *spd)
 {
 	int ret, do_wakeup, page_nr;
 
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 1789ec7..7ba228d 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -71,45 +71,4 @@ void generic_pipe_buf_get(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_pin(struct pipe_inode_info *, struct pipe_buffer *);
 int generic_pipe_buf_steal(struct pipe_inode_info *, struct pipe_buffer *);
 
-/*
- * splice is tied to pipes as a transport (at least for now), so we'll just
- * add the splice flags here.
- */
-#define SPLICE_F_MOVE	(0x01)	/* move pages instead of copying */
-#define SPLICE_F_NONBLOCK (0x02) /* don't block on the pipe splicing (but */
-				 /* we may still block on the fd we splice */
-				 /* from/to, of course */
-#define SPLICE_F_MORE	(0x04)	/* expect more data */
-#define SPLICE_F_GIFT	(0x08)	/* pages passed in are a gift */
-
-/*
- * Passed to the actors
- */
-struct splice_desc {
-	unsigned int len, total_len;	/* current and remaining length */
-	unsigned int flags;		/* splice flags */
-	/*
-	 * actor() private data
-	 */
-	union {
-		void __user *userptr;	/* memory to write to */
-		struct file *file;	/* file to read/write */
-		void *data;		/* cookie */
-	};
-	loff_t pos;			/* file position */
-};
-
-typedef int (splice_actor)(struct pipe_inode_info *, struct pipe_buffer *,
-			   struct splice_desc *);
-typedef int (splice_direct_actor)(struct pipe_inode_info *,
-				  struct splice_desc *);
-
-extern ssize_t splice_from_pipe(struct pipe_inode_info *, struct file *,
-				loff_t *, size_t, unsigned int,
-				splice_actor *);
-extern ssize_t __splice_from_pipe(struct pipe_inode_info *,
-				  struct splice_desc *, splice_actor *);
-extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
-				      splice_direct_actor *);
-
 #endif
diff --git a/include/linux/splice.h b/include/linux/splice.h
new file mode 100644
index 0000000..b3f1528
--- /dev/null
+++ b/include/linux/splice.h
@@ -0,0 +1,72 @@
+/*
+ * Function declerations and data structures related to the splice
+ * implementation.
+ *
+ * Copyright (C) 2007 Jens Axboe <jens.axboe@oracle.com>
+ *
+ */
+#ifndef SPLICE_H
+#define SPLICE_H
+
+#include <linux/pipe_fs_i.h>
+
+/*
+ * splice is tied to pipes as a transport (at least for now), so we'll just
+ * add the splice flags here.
+ */
+#define SPLICE_F_MOVE	(0x01)	/* move pages instead of copying */
+#define SPLICE_F_NONBLOCK (0x02) /* don't block on the pipe splicing (but */
+				 /* we may still block on the fd we splice */
+				 /* from/to, of course */
+#define SPLICE_F_MORE	(0x04)	/* expect more data */
+#define SPLICE_F_GIFT	(0x08)	/* pages passed in are a gift */
+
+/*
+ * Passed to the actors
+ */
+struct splice_desc {
+	unsigned int len, total_len;	/* current and remaining length */
+	unsigned int flags;		/* splice flags */
+	/*
+	 * actor() private data
+	 */
+	union {
+		void __user *userptr;	/* memory to write to */
+		struct file *file;	/* file to read/write */
+		void *data;		/* cookie */
+	};
+	loff_t pos;			/* file position */
+};
+
+struct partial_page {
+	unsigned int offset;
+	unsigned int len;
+};
+
+/*
+ * Passed to splice_to_pipe
+ */
+struct splice_pipe_desc {
+	struct page **pages;		/* page map */
+	struct partial_page *partial;	/* pages[] may not be contig */
+	int nr_pages;			/* number of pages in map */
+	unsigned int flags;		/* splice flags */
+	const struct pipe_buf_operations *ops;/* ops associated with output pipe */
+};
+
+typedef int (splice_actor)(struct pipe_inode_info *, struct pipe_buffer *,
+			   struct splice_desc *);
+typedef int (splice_direct_actor)(struct pipe_inode_info *,
+				  struct splice_desc *);
+
+extern ssize_t splice_from_pipe(struct pipe_inode_info *, struct file *,
+				loff_t *, size_t, unsigned int,
+				splice_actor *);
+extern ssize_t __splice_from_pipe(struct pipe_inode_info *,
+				  struct splice_desc *, splice_actor *);
+extern ssize_t splice_to_pipe(struct pipe_inode_info *,
+			      struct splice_pipe_desc *);
+extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
+				      splice_direct_actor *);
+
+#endif
diff --git a/kernel/relay.c b/kernel/relay.c
index 3950c1b..ae13040 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -21,7 +21,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/cpu.h>
-#include <linux/pipe_fs_i.h>
+#include <linux/splice.h>
 
 /* list of open channels, for cpu hotplug */
 static DEFINE_MUTEX(relay_channels_mutex);
-- 
1.5.2.1.174.gcd03

