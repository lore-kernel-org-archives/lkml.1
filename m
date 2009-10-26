Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZJZFwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZJZFwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 01:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZJZFwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 01:52:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:57323 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbZJZFwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 01:52:34 -0400
Date: Sun, 25 Oct 2009 22:53:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
Subject: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091025225342.007138f5@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b894af8a33bec621dd1a4126603a3ca372bf0643 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 25 Oct 2009 15:37:04 -0700
Subject: [PATCH] vfs: Add a trace point in the mark_inode_dirty function

PowerTOP would like to be able to show who is keeping the disk
busy by dirtying data. The most logical spot for this is in the vfs
in the mark_inode_dirty() function. Doing this on the block level
is not possible because by the time the IO hits the block layer the
guilty party can no longer be found ("kjournald" and "pdflush" are not
useful answers to "who caused this file to be dirty).

The trace point follows the same logic/style as the block_dump code
and pretty much dumps the same data, just not to dmesg (and thus to
/var/log/messages) but via the trace events streams.

Signed-of-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/fs-writeback.c          |    3 ++
 fs/inode.c                 |    4 +++
 include/trace/events/vfs.h |   53 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/vfs.h

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 9d5360c..4102f20 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -25,6 +25,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
+#include <trace/events/vfs.h>
 #include "internal.h"
 
 #define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
@@ -1071,6 +1072,8 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	if ((inode->i_state & flags) == flags)
 		return;
 
+	trace_dirty_inode(inode, current);
+
 	if (unlikely(block_dump))
 		block_dump___mark_inode_dirty(inode);
 
diff --git a/fs/inode.c b/fs/inode.c
index 4d8e3be..a61e8ba 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1624,3 +1624,7 @@ void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
 				  inode->i_ino);
 }
 EXPORT_SYMBOL(init_special_inode);
+
+#define CREATE_TRACE_POINTS  
+#include <trace/events/vfs.h>
+
diff --git a/include/trace/events/vfs.h b/include/trace/events/vfs.h
new file mode 100644
index 0000000..21cf9fb
--- /dev/null
+++ b/include/trace/events/vfs.h
@@ -0,0 +1,53 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM vfs
+
+#if !defined(_TRACE_VFS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_VFS_H
+
+/*
+ * Tracepoint for dirtying an inode:
+ */
+TRACE_EVENT(dirty_inode,
+
+	TP_PROTO(struct inode *inode, struct task_struct *task),
+
+	TP_ARGS(inode, task),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__array( char,  dev,    16		)
+		__array( char,  file,   32		)
+	),
+
+	TP_fast_assign(
+		if (inode->i_ino || strcmp(inode->i_sb->s_id, "bdev")) {
+                	struct dentry *dentry;
+                	const char *name = "?";
+
+			dentry = d_find_alias(inode);
+			if (dentry) {
+				spin_lock(&dentry->d_lock);
+				name = (const char *) dentry->d_name.name;
+			}
+
+			memcpy(__entry->comm, task->comm, TASK_COMM_LEN);
+			__entry->pid = task->pid;
+			strlcpy(__entry->file, name, 32);
+			strlcpy(__entry->dev, inode->i_sb->s_id, 16);
+
+			if (dentry) {
+				spin_unlock(&dentry->d_lock);
+				dput(dentry);
+			}
+		}
+	),
+
+	TP_printk("task=%i (%s) file=%s dev=%s",
+		__entry->pid, __entry->comm, __entry->file, __entry->dev)
+);
+
+#endif /* _TRACE_VFS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.6.2.5



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
