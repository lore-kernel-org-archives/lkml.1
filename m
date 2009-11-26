Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbZKZIpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbZKZIpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759979AbZKZIpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:45:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:58808 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760055AbZKZIpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:45:04 -0500
Date: Thu, 26 Nov 2009 08:44:14 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, tytso@mit.edu, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, tytso@mit.edu, mingo@elte.hu
In-Reply-To: <4B0E2938.2040708@cn.fujitsu.com>
References: <4B0E2938.2040708@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Convert some ext4 events to DEFINE_TRACE
Message-ID: <tip-b5eb34c3592545c756e50d882c08417eb60740a7@git.kernel.org>
Git-Commit-ID: b5eb34c3592545c756e50d882c08417eb60740a7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5eb34c3592545c756e50d882c08417eb60740a7
Gitweb:     http://git.kernel.org/tip/b5eb34c3592545c756e50d882c08417eb60740a7
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 26 Nov 2009 15:07:36 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 09:14:05 +0100

tracing: Convert some ext4 events to DEFINE_TRACE

Use DECLARE_EVENT_CLASS to remove duplicate code:

   text    data     bss     dec     hex filename
 294695    6104     340  301139   49853 fs/ext4/ext4.o.old
 289983    6104     324  296411   485db fs/ext4/ext4.o

5 events are convertd:

  ext4__write_begin: ext4_write_begin, ext4_da_write_begin
  ext4__write_end: ext4_{ordered, writeback, journalled}_write_end

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B0E2938.2040708@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/ext4.h |  129 ++++++++++++-------------------------------
 1 files changed, 35 insertions(+), 94 deletions(-)

diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index d09550b..318f765 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -90,7 +90,7 @@ TRACE_EVENT(ext4_allocate_inode,
 		  (unsigned long) __entry->dir, __entry->mode)
 );
 
-TRACE_EVENT(ext4_write_begin,
+DECLARE_EVENT_CLASS(ext4__write_begin,
 
 	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
 		 unsigned int flags),
@@ -118,7 +118,23 @@ TRACE_EVENT(ext4_write_begin,
 		  __entry->pos, __entry->len, __entry->flags)
 );
 
-TRACE_EVENT(ext4_ordered_write_end,
+DEFINE_EVENT(ext4__write_begin, ext4_write_begin,
+
+	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
+		 unsigned int flags),
+
+	TP_ARGS(inode, pos, len, flags)
+);
+
+DEFINE_EVENT(ext4__write_begin, ext4_da_write_begin,
+
+	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
+		 unsigned int flags),
+
+	TP_ARGS(inode, pos, len, flags)
+);
+
+DECLARE_EVENT_CLASS(ext4__write_end,
 	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
 			unsigned int copied),
 
@@ -145,57 +161,36 @@ TRACE_EVENT(ext4_ordered_write_end,
 		  __entry->pos, __entry->len, __entry->copied)
 );
 
-TRACE_EVENT(ext4_writeback_write_end,
+DEFINE_EVENT(ext4__write_end, ext4_ordered_write_end,
+
 	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
 		 unsigned int copied),
 
-	TP_ARGS(inode, pos, len, copied),
+	TP_ARGS(inode, pos, len, copied)
+);
 
-	TP_STRUCT__entry(
-		__field(	dev_t,	dev			)
-		__field(	ino_t,	ino			)
-		__field(	loff_t,	pos			)
-		__field(	unsigned int, len		)
-		__field(	unsigned int, copied		)
-	),
+DEFINE_EVENT(ext4__write_end, ext4_writeback_write_end,
 
-	TP_fast_assign(
-		__entry->dev	= inode->i_sb->s_dev;
-		__entry->ino	= inode->i_ino;
-		__entry->pos	= pos;
-		__entry->len	= len;
-		__entry->copied	= copied;
-	),
+	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
+		 unsigned int copied),
 
-	TP_printk("dev %s ino %lu pos %llu len %u copied %u",
-		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
-		  __entry->pos, __entry->len, __entry->copied)
+	TP_ARGS(inode, pos, len, copied)
 );
 
-TRACE_EVENT(ext4_journalled_write_end,
+DEFINE_EVENT(ext4__write_end, ext4_journalled_write_end,
+
 	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
 		 unsigned int copied),
-	TP_ARGS(inode, pos, len, copied),
 
-	TP_STRUCT__entry(
-		__field(	dev_t,	dev			)
-		__field(	ino_t,	ino			)
-		__field(	loff_t,	pos			)
-		__field(	unsigned int, len		)
-		__field(	unsigned int, copied		)
-	),
+	TP_ARGS(inode, pos, len, copied)
+);
 
-	TP_fast_assign(
-		__entry->dev	= inode->i_sb->s_dev;
-		__entry->ino	= inode->i_ino;
-		__entry->pos	= pos;
-		__entry->len	= len;
-		__entry->copied	= copied;
-	),
+DEFINE_EVENT(ext4__write_end, ext4_da_write_end,
 
-	TP_printk("dev %s ino %lu pos %llu len %u copied %u",
-		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
-		  __entry->pos, __entry->len, __entry->copied)
+	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
+		 unsigned int copied),
+
+	TP_ARGS(inode, pos, len, copied)
 );
 
 TRACE_EVENT(ext4_writepage,
@@ -337,60 +332,6 @@ TRACE_EVENT(ext4_da_writepages_result,
 		  (unsigned long) __entry->writeback_index)
 );
 
-TRACE_EVENT(ext4_da_write_begin,
-	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
-			unsigned int flags),
-
-	TP_ARGS(inode, pos, len, flags),
-
-	TP_STRUCT__entry(
-		__field(	dev_t,	dev			)
-		__field(	ino_t,	ino			)
-		__field(	loff_t,	pos			)
-		__field(	unsigned int, len		)
-		__field(	unsigned int, flags		)
-	),
-
-	TP_fast_assign(
-		__entry->dev	= inode->i_sb->s_dev;
-		__entry->ino	= inode->i_ino;
-		__entry->pos	= pos;
-		__entry->len	= len;
-		__entry->flags	= flags;
-	),
-
-	TP_printk("dev %s ino %lu pos %llu len %u flags %u",
-		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
-		  __entry->pos, __entry->len, __entry->flags)
-);
-
-TRACE_EVENT(ext4_da_write_end,
-	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
-			unsigned int copied),
-
-	TP_ARGS(inode, pos, len, copied),
-
-	TP_STRUCT__entry(
-		__field(	dev_t,	dev			)
-		__field(	ino_t,	ino			)
-		__field(	loff_t,	pos			)
-		__field(	unsigned int, len		)
-		__field(	unsigned int, copied		)
-	),
-
-	TP_fast_assign(
-		__entry->dev	= inode->i_sb->s_dev;
-		__entry->ino	= inode->i_ino;
-		__entry->pos	= pos;
-		__entry->len	= len;
-		__entry->copied	= copied;
-	),
-
-	TP_printk("dev %s ino %lu pos %llu len %u copied %u",
-		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
-		  __entry->pos, __entry->len, __entry->copied)
-);
-
 TRACE_EVENT(ext4_discard_blocks,
 	TP_PROTO(struct super_block *sb, unsigned long long blk,
 			unsigned long long count),
