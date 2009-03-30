Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbZC3SR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbZC3SR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbZC3SPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:15:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:56598 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbZC3SPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:15:16 -0400
Message-Id: <20090330181009.704590533@suse.com>
User-Agent: quilt/0.47-14.9
Date: Mon, 30 Mar 2009 14:02:19 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 04/35 error-handling] reiserfs: use more consistent printk formatting
References: <20090330180215.951354436@suse.com>
Content-Disposition: inline; filename=patches.suse/reiserfs-consistent-messages.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The output format between a warning/error/panic/info/etc changes with
 which one is used.

 The following patch makes the messages more internally consistent, but also
 more consistent with other Linux filesystems.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

--
 fs/reiserfs/prints.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/fs/reiserfs/prints.c
+++ b/fs/reiserfs/prints.c
@@ -268,10 +268,10 @@ void reiserfs_warning(struct super_block
 {
 	do_reiserfs_warning(fmt);
 	if (sb)
-		printk(KERN_WARNING "ReiserFS: %s: warning: %s\n",
-		       reiserfs_bdevname(sb), error_buf);
+		printk(KERN_WARNING "REISERFS warning (device %s): %s\n",
+		       sb->s_id, error_buf);
 	else
-		printk(KERN_WARNING "ReiserFS: warning: %s\n", error_buf);
+		printk(KERN_WARNING "REISERFS warning: %s\n", error_buf);
 }
 
 /* No newline.. reiserfs_info calls can be followed by printk's */
@@ -279,10 +279,10 @@ void reiserfs_info(struct super_block *s
 {
 	do_reiserfs_warning(fmt);
 	if (sb)
-		printk(KERN_NOTICE "ReiserFS: %s: %s",
-		       reiserfs_bdevname(sb), error_buf);
+		printk(KERN_NOTICE "REISERFS (device %s): %s",
+		       sb->s_id, error_buf);
 	else
-		printk(KERN_NOTICE "ReiserFS: %s", error_buf);
+		printk(KERN_NOTICE "REISERFS %s:", error_buf);
 }
 
 /* No newline.. reiserfs_printk calls can be followed by printk's */
@@ -297,10 +297,10 @@ void reiserfs_debug(struct super_block *
 #ifdef CONFIG_REISERFS_CHECK
 	do_reiserfs_warning(fmt);
 	if (s)
-		printk(KERN_DEBUG "ReiserFS: %s: %s\n",
-		       reiserfs_bdevname(s), error_buf);
+		printk(KERN_DEBUG "REISERFS debug (device %s): %s\n",
+		       s->s_id, error_buf);
 	else
-		printk(KERN_DEBUG "ReiserFS: %s\n", error_buf);
+		printk(KERN_DEBUG "REISERFS debug: %s\n", error_buf);
 #endif
 }
 
@@ -368,15 +368,15 @@ void reiserfs_abort(struct super_block *
 	do_reiserfs_warning(fmt);
 
 	if (reiserfs_error_panic(sb)) {
-		panic(KERN_CRIT "REISERFS: panic (device %s): %s\n",
-		      reiserfs_bdevname(sb), error_buf);
+		panic(KERN_CRIT "REISERFS panic (device %s): %s\n", sb->s_id,
+		      error_buf);
 	}
 
-	if (sb->s_flags & MS_RDONLY)
+	if (reiserfs_is_journal_aborted(SB_JOURNAL(sb)))
 		return;
 
-	printk(KERN_CRIT "REISERFS: abort (device %s): %s\n",
-	       reiserfs_bdevname(sb), error_buf);
+	printk(KERN_CRIT "REISERFS abort (device %s): %s\n", sb->s_id,
+	       error_buf);
 
 	sb->s_flags |= MS_RDONLY;
 	reiserfs_journal_abort(sb, errno);


