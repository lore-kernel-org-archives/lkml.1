Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbXB0XVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbXB0XVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXB0XVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:21:08 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:54946 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbXB0XSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:18:07 -0500
Message-Id: <20070227231728.136914197@szeredi.hu>
References: <20070227231442.627972152@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 28 Feb 2007 00:15:01 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 19/22] export sync_sb() to modules
Content-Disposition: inline; filename=sync_sb.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Create a function sync_sb() and export it to modules.  This is the
generic interface for writing back dirty data from a single
superblock.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fs-writeback.c
===================================================================
--- linux.orig/fs/fs-writeback.c	2007-02-27 14:40:54.000000000 +0100
+++ linux/fs/fs-writeback.c	2007-02-27 14:41:12.000000000 +0100
@@ -400,6 +400,14 @@ sync_sb_inodes(struct super_block *sb, s
 	return;		/* Leave any unwritten inodes on s_io */
 }
 
+void sync_sb(struct super_block *sb, struct writeback_control *wbc)
+{
+	spin_lock(&inode_lock);
+	sync_sb_inodes(sb, wbc);
+	spin_unlock(&inode_lock);
+}
+EXPORT_SYMBOL(sync_sb);
+
 /*
  * Start writeback of dirty pagecache data against all unlocked inodes.
  *
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-02-27 14:41:09.000000000 +0100
+++ linux/include/linux/fs.h	2007-02-27 14:41:12.000000000 +0100
@@ -1240,6 +1240,7 @@ static inline void file_accessed(struct 
 }
 
 int sync_inode(struct inode *inode, struct writeback_control *wbc);
+void sync_sb(struct super_block *sb, struct writeback_control *wbc);
 
 /**
  * struct export_operations - for nfsd to communicate with file systems

--
