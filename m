Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbZC3SYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbZC3SYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbZC3SQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:16:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbZC3SPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:15:19 -0400
Message-Id: <20090330181010.817164616@suse.com>
User-Agent: quilt/0.47-14.9
Date: Mon, 30 Mar 2009 14:02:27 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 12/35 error-handling] reiserfs: introduce reiserfs_error()
References: <20090330180215.951354436@suse.com>
Content-Disposition: inline; filename=patches.suse/reiserfs-add-reiserfs_error.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Although reiserfs can currently handle severe errors such as journal failure,
 it cannot handle less severe errors like metadata i/o failure. The following
 patch adds a reiserfs_error() function akin to the one in ext3.

 Subsequent patches will use this new error handler to handle errors more
 gracefully in general.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

--
 fs/reiserfs/prints.c        |   25 +++++++++++++++++++++++++
 include/linux/reiserfs_fs.h |    4 ++++
 2 files changed, 29 insertions(+)

--- a/fs/reiserfs/prints.c
+++ b/fs/reiserfs/prints.c
@@ -373,6 +373,31 @@ void __reiserfs_panic(struct super_block
 		      id ? id : "", id ? " " : "", function, error_buf);
 }
 
+void __reiserfs_error(struct super_block *sb, const char *id,
+		      const char *function, const char *fmt, ...)
+{
+	do_reiserfs_warning(fmt);
+
+	BUG_ON(sb == NULL);
+
+	if (reiserfs_error_panic(sb))
+		__reiserfs_panic(sb, id, function, error_buf);
+
+	if (id && id[0])
+		printk(KERN_CRIT "REISERFS error (device %s): %s %s: %s\n",
+		       sb->s_id, id, function, error_buf);
+	else
+		printk(KERN_CRIT "REISERFS error (device %s): %s: %s\n",
+		       sb->s_id, function, error_buf);
+
+	if (sb->s_flags & MS_RDONLY)
+		return;
+
+	reiserfs_info(sb, "Remounting filesystem read-only\n");
+	sb->s_flags |= MS_RDONLY;
+	reiserfs_abort_journal(sb, -EIO);
+}
+
 void reiserfs_abort(struct super_block *sb, int errno, const char *fmt, ...)
 {
 	do_reiserfs_warning(fmt);
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -2006,6 +2006,10 @@ void __reiserfs_panic(struct super_block
     __attribute__ ((noreturn));
 #define reiserfs_panic(s, id, fmt, args...) \
 	__reiserfs_panic(s, id, __func__, fmt, ##args)
+void __reiserfs_error(struct super_block *s, const char *id,
+		      const char *function, const char *fmt, ...);
+#define reiserfs_error(s, id, fmt, args...) \
+	 __reiserfs_error(s, id, __func__, fmt, ##args)
 void reiserfs_info(struct super_block *s, const char *fmt, ...);
 void reiserfs_debug(struct super_block *s, int level, const char *fmt, ...);
 void print_indirect_item(struct buffer_head *bh, int item_num);


