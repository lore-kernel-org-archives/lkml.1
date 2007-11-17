Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbXKQOji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbXKQOji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 09:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbXKQOj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 09:39:29 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:12111 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbXKQOj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 09:39:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=LNTSBAIeIIx8zPYPh5Ep4o/a62ZFaMqKZGLGVcxTqRIoGBMg6H5OtbDPVXyALuRpIUdsA64MzqcbhOkVy7k3anKkwe4/kFdJbMfl6IoKEwNTihto4M1LoY7op7DVhvvrpZTYIdSpl0hzbbDYBmUPMVopL9W34Yq3d38YkUEJXgU=
Date: Sat, 17 Nov 2007 23:33:31 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fs: use list_for_each_entry_reverse and kill sb_entry
Message-ID: <20071117142731.GA28607@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_for_each_entry_reverse for super_blocks list and remove
unused sb_entry macro.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 fs/fs-writeback.c  |    7 ++-----
 include/linux/fs.h |    1 -
 2 files changed, 2 insertions(+), 6 deletions(-)

Index: 2.6-mm/fs/fs-writeback.c
===================================================================
--- 2.6-mm.orig/fs/fs-writeback.c
+++ 2.6-mm/fs/fs-writeback.c
@@ -528,8 +528,7 @@ int writeback_inodes(struct writeback_co
 	might_sleep();
 	spin_lock(&sb_lock);
 restart:
-	sb = sb_entry(super_blocks.prev);
-	for (; sb != sb_entry(&super_blocks); sb = sb_entry(sb->s_list.prev)) {
+	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
 		if (sb_has_dirty_inodes(sb)) {
 			/* we're making our own get_super here */
 			sb->s_count++;
@@ -593,10 +592,8 @@ static void set_sb_syncing(int val)
 {
 	struct super_block *sb;
 	spin_lock(&sb_lock);
-	sb = sb_entry(super_blocks.prev);
-	for (; sb != sb_entry(&super_blocks); sb = sb_entry(sb->s_list.prev)) {
+	list_for_each_entry_reverse(sb, &super_blocks, s_list)
 		sb->s_syncing = val;
-	}
 	spin_unlock(&sb_lock);
 }
 
Index: 2.6-mm/include/linux/fs.h
===================================================================
--- 2.6-mm.orig/include/linux/fs.h
+++ 2.6-mm/include/linux/fs.h
@@ -984,7 +984,6 @@ extern int send_sigurg(struct fown_struc
 extern struct list_head super_blocks;
 extern spinlock_t sb_lock;
 
-#define sb_entry(list)	list_entry((list), struct super_block, s_list)
 #define S_BIAS (1<<30)
 struct super_block {
 	struct list_head	s_list;		/* Keep this first */
