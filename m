Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbZKZHIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbZKZHIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758897AbZKZHH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:07:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57862 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758813AbZKZHH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:07:58 -0500
Message-ID: <4B0E2938.2040708@cn.fujitsu.com>
Date: Thu, 26 Nov 2009 15:07:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Theodore Ts'o" <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/9] tracing: Convert some ext4 events to DEFINE_TRACE
References: <4B0E2807.4060102@cn.fujitsu.com>
In-Reply-To: <4B0E2807.4060102@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use TRACE_EVENT_TEMPLATE to remove duplicate code:

   text    data     bss     dec     hex filename
 294695    6104     340  301139   49853 fs/ext4/ext4.o.old
 289983    6104     324  296411   485db fs/ext4/ext4.o

5 events are convertd:

  ext4__write_begin: ext4_write_begin, ext4_da_write_begin
  ext4__write_end: ext4_{ordered, writeback, journalled}_write_end

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/events/ext4.h |  129 ++++++++++++-------------------------------
 1 files changed, 35 insertions(+), 94 deletions(-)

diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index d09550b..b5bbd3b 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -90,7 +90,7 @@ TRACE_EVENT(ext4_allocate_inode,
 		  (unsigned long) __entry->dir, __entry->mode)
 );
 
-TRACE_EVENT(ext4_write_begin,
+TRACE_EVENT_TEMPLATE(ext4__write_begin,
 
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
+TRACE_EVENT_TEMPLATE(ext4__write_end,
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
-- 
1.6.3

