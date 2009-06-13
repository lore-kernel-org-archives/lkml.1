Return-Path: <linux-kernel-owner+w=401wt.eu-S1763457AbZFMNZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763457AbZFMNZY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760918AbZFMNZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:25:03 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:39740 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762888AbZFMNY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:24:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=u67unBCZDYOEiINujEWCTVR3LLM1mnT7Uc03cRY6XWKGwoscM9zvbREduWrAgYlOKq
         n27EEfTqB53+gwYNlfRreNKPpwrdZGJ4v79z/IT2iYFVbRgWpc27dS5yuquiDmPa7l6+
         MS3Rc2zjRUobkNm9IUsEUAe21VPUnuWBRxIcM=
Message-ID: <4A33A7BC.1020703@gmail.com>
Date: Sat, 13 Jun 2009 15:21:00 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: [PATCH 02/14] Pramfs: File operations for directories
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

File operations for directories.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff -uprN linux-2.6.30-orig/fs/pramfs/dir.c linux-2.6.30/fs/pramfs/dir.c
--- linux-2.6.30-orig/fs/pramfs/dir.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30/fs/pramfs/dir.c	2009-06-13 12:51:46.000000000 +0200
@@ -0,0 +1,220 @@
+/*
+ * FILE NAME fs/pramfs/dir.c
+ *
+ * BRIEF DESCRIPTION
+ *
+ * File operations for directories.
+ *
+ * Copyright 2009 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/fs.h>
+#include <linux/pagemap.h>
+#include "pram_fs.h"
+
+/*
+ *	Parent is locked.
+ */
+int pram_add_link(struct dentry *dentry, struct inode *inode)
+{
+	struct inode *dir = dentry->d_parent->d_inode;
+	struct pram_inode *pidir, *pi, *pitail = NULL;
+	off_t tail_ino, prev_ino;
+	unsigned long flags;
+
+	const char *name = dentry->d_name.name;
+	int namelen = dentry->d_name.len > PRAM_NAME_LEN ?
+		PRAM_NAME_LEN : dentry->d_name.len;
+
+	flags = 0;
+
+	pidir = pram_get_inode(dir->i_sb, dir->i_ino);
+	pi = pram_get_inode(dir->i_sb, inode->i_ino);
+
+	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+
+	tail_ino = pidir->i_type.dir.tail;
+	if (tail_ino != 0) {
+		pitail = pram_get_inode(dir->i_sb, tail_ino);
+		pram_lock_inode(pitail, flags);
+		pitail->i_d.d_next = inode->i_ino;
+		pram_unlock_inode(pitail, flags);
+
+		prev_ino = tail_ino;
+
+		pram_lock_inode(pidir, flags);
+		pidir->i_type.dir.tail = inode->i_ino;
+		pidir->i_mtime = dir->i_mtime.tv_sec;
+		pidir->i_ctime = dir->i_ctime.tv_sec;
+		pram_unlock_inode(pidir, flags);
+	} else {
+		/* the directory is empty */
+		prev_ino = 0;
+
+		pram_lock_inode(pidir, flags);
+		pidir->i_type.dir.head = pidir->i_type.dir.tail = inode->i_ino;
+		pidir->i_mtime = dir->i_mtime.tv_sec;
+		pidir->i_ctime = dir->i_ctime.tv_sec;
+		pram_unlock_inode(pidir, flags);
+	}
+
+
+	pram_lock_inode(pi, flags);
+	pi->i_d.d_prev = prev_ino;
+	pi->i_d.d_parent = dir->i_ino;
+	memcpy(pi->i_d.d_name, name, namelen);
+	pi->i_d.d_name[namelen] = '\0';
+	pram_unlock_inode(pi, flags);
+	return 0;
+}
+
+int pram_remove_link(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct pram_inode *prev = NULL;
+	struct pram_inode *next = NULL;
+	struct pram_inode *pidir, *pi;
+	unsigned long flags;
+
+	flags = 0;
+
+	pi = pram_get_inode(sb, inode->i_ino);
+	pidir = pram_get_inode(sb, pi->i_d.d_parent);
+	if (!pidir)
+		return -EACCES;
+
+	if (inode->i_ino == pidir->i_type.dir.head) {
+		/* first inode in directory */
+		next = pram_get_inode(sb, pi->i_d.d_next);
+
+		if (next) {
+			pram_lock_inode(next, flags);
+			next->i_d.d_prev = 0;
+			pram_unlock_inode(next, flags);
+
+			pram_lock_inode(pidir, flags);
+			pidir->i_type.dir.head = pi->i_d.d_next;
+		} else {
+			pram_lock_inode(pidir, flags);
+			pidir->i_type.dir.head = pidir->i_type.dir.tail = 0;
+		}
+		pram_unlock_inode(pidir, flags);
+	} else if (inode->i_ino == pidir->i_type.dir.tail) {
+		/* last inode in directory */
+		prev = pram_get_inode(sb, pi->i_d.d_prev);
+
+		pram_lock_inode(prev, flags);
+		prev->i_d.d_next = 0;
+		pram_unlock_inode(prev, flags);
+
+		pram_lock_inode(pidir, flags);
+		pidir->i_type.dir.tail = pi->i_d.d_prev;
+		pram_unlock_inode(pidir, flags);
+	} else {
+		/* somewhere in the middle */
+		prev = pram_get_inode(sb, pi->i_d.d_prev);
+		next = pram_get_inode(sb, pi->i_d.d_next);
+
+		if (prev && next) {
+			pram_lock_inode(prev, flags);
+			prev->i_d.d_next = pi->i_d.d_next;
+			pram_unlock_inode(prev, flags);
+
+			pram_lock_inode(next, flags);
+			next->i_d.d_prev = pi->i_d.d_prev;
+			pram_unlock_inode(next, flags);
+		}
+	}
+
+	pram_lock_inode(pi, flags);
+	pi->i_d.d_next = pi->i_d.d_prev = pi->i_d.d_parent = 0;
+	pram_unlock_inode(pi, flags);
+
+	return 0;
+}
+
+#define S_SHIFT 12
+static unsigned int dtype_by_mode[S_IFMT >> S_SHIFT] = {
+	[S_IFREG >> S_SHIFT]    DT_REG,
+	[S_IFDIR >> S_SHIFT]    DT_DIR,
+	[S_IFCHR >> S_SHIFT]    DT_CHR,
+	[S_IFBLK >> S_SHIFT]    DT_BLK,
+	[S_IFIFO >> S_SHIFT]    DT_FIFO,
+	[S_IFSOCK >> S_SHIFT]   DT_SOCK,
+	[S_IFLNK >> S_SHIFT]    DT_LNK,
+};
+
+static int
+pram_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	struct inode *inode = filp->f_dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	struct pram_inode *pi;
+	int namelen, ret = 0;
+	char *name;
+	ino_t ino;
+
+	if (filp->f_pos >> 32)
+		return 0;
+
+	pi = pram_get_inode(sb, inode->i_ino);
+
+	switch ((unsigned long)filp->f_pos) {
+	case 0:
+		ret = filldir(dirent, ".", 1, 0, inode->i_ino, DT_DIR);
+		filp->f_pos++;
+		return ret;
+	case 1:
+		ret = filldir(dirent, "..", 2, 1, pi->i_d.d_parent, DT_DIR);
+		ino = pi->i_type.dir.head;
+		filp->f_pos = ino ? ino : 2;
+		return ret;
+	case 2:
+		ino = pi->i_type.dir.head;
+		if (ino) {
+			filp->f_pos = ino;
+			pi = pram_get_inode(sb, ino);
+			break;
+		} else {
+			/* the directory is empty */
+			filp->f_pos = 2;
+			return 0;
+		}
+	case 3:
+		return 0;
+	default:
+		ino = filp->f_pos;
+		pi = pram_get_inode(sb, ino);
+		break;
+	}
+
+	while (pi && !pi->i_links_count) {
+		ino = filp->f_pos = pi->i_d.d_next;
+		pi = pram_get_inode(sb, ino);
+	}
+
+	if (pi) {
+		name = pi->i_d.d_name;
+		namelen = strlen(name);
+
+		ret = filldir(dirent, name, namelen,
+			      filp->f_pos, ino,
+			      dtype_by_mode[(pi->i_mode & S_IFMT)>>S_SHIFT]);
+		filp->f_pos = pi->i_d.d_next ? pi->i_d.d_next : 3;
+	} else
+		filp->f_pos = 3;
+
+	return ret;
+}
+
+struct file_operations pram_dir_operations = {
+	.read 		= generic_read_dir,
+	.readdir	= pram_readdir,
+	.fsync		= simple_sync_file,	
+};

