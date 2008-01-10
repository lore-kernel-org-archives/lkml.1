Return-Path: <linux-kernel-owner+w=401wt.eu-S1761447AbYAJPJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447AbYAJPJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759567AbYAJPBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:01:44 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57097 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759048AbYAJPBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:01:10 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, viro@ftp.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 13/29] Unionfs: directory reading file operations
Date: Thu, 10 Jan 2008 09:59:32 -0500
Message-Id: <1199977195977-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
References: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dirfops.c |  290 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 290 insertions(+), 0 deletions(-)
 create mode 100644 fs/unionfs/dirfops.c

diff --git a/fs/unionfs/dirfops.c b/fs/unionfs/dirfops.c
new file mode 100644
index 0000000..a613862
--- /dev/null
+++ b/fs/unionfs/dirfops.c
@@ -0,0 +1,290 @@
+/*
+ * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2006 Charles P. Wright
+ * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2005-2006 Junjiro Okajima
+ * Copyright (c) 2005      Arun M. Krishnakumar
+ * Copyright (c) 2004-2006 David P. Quigley
+ * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
+ * Copyright (c) 2003      Puja Gupta
+ * Copyright (c) 2003      Harikesavan Krishnan
+ * Copyright (c) 2003-2007 Stony Brook University
+ * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "union.h"
+
+/* Make sure our rdstate is playing by the rules. */
+static void verify_rdstate_offset(struct unionfs_dir_state *rdstate)
+{
+	BUG_ON(rdstate->offset >= DIREOF);
+	BUG_ON(rdstate->cookie >= MAXRDCOOKIE);
+}
+
+struct unionfs_getdents_callback {
+	struct unionfs_dir_state *rdstate;
+	void *dirent;
+	int entries_written;
+	int filldir_called;
+	int filldir_error;
+	filldir_t filldir;
+	struct super_block *sb;
+};
+
+/* based on generic filldir in fs/readir.c */
+static int unionfs_filldir(void *dirent, const char *name, int namelen,
+			   loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct unionfs_getdents_callback *buf = dirent;
+	struct filldir_node *found = NULL;
+	int err = 0;
+	int is_wh_entry = 0;
+
+	buf->filldir_called++;
+
+	if ((namelen > UNIONFS_WHLEN) &&
+	    !strncmp(name, UNIONFS_WHPFX, UNIONFS_WHLEN)) {
+		name += UNIONFS_WHLEN;
+		namelen -= UNIONFS_WHLEN;
+		is_wh_entry = 1;
+	}
+
+	found = find_filldir_node(buf->rdstate, name, namelen, is_wh_entry);
+
+	if (found) {
+		/*
+		 * If we had non-whiteout entry in dir cache, then mark it
+		 * as a whiteout and but leave it in the dir cache.
+		 */
+		if (is_wh_entry && !found->whiteout)
+			found->whiteout = is_wh_entry;
+		goto out;
+	}
+
+	/* if 'name' isn't a whiteout, filldir it. */
+	if (!is_wh_entry) {
+		off_t pos = rdstate2offset(buf->rdstate);
+		u64 unionfs_ino = ino;
+
+		err = buf->filldir(buf->dirent, name, namelen, pos,
+				   unionfs_ino, d_type);
+		buf->rdstate->offset++;
+		verify_rdstate_offset(buf->rdstate);
+	}
+	/*
+	 * If we did fill it, stuff it in our hash, otherwise return an
+	 * error.
+	 */
+	if (err) {
+		buf->filldir_error = err;
+		goto out;
+	}
+	buf->entries_written++;
+	err = add_filldir_node(buf->rdstate, name, namelen,
+			       buf->rdstate->bindex, is_wh_entry);
+	if (err)
+		buf->filldir_error = err;
+
+out:
+	return err;
+}
+
+static int unionfs_readdir(struct file *file, void *dirent, filldir_t filldir)
+{
+	int err = 0;
+	struct file *lower_file = NULL;
+	struct inode *inode = NULL;
+	struct unionfs_getdents_callback buf;
+	struct unionfs_dir_state *uds;
+	int bend;
+	loff_t offset;
+
+	unionfs_read_lock(file->f_path.dentry->d_sb, UNIONFS_SMUTEX_PARENT);
+
+	err = unionfs_file_revalidate(file, false);
+	if (unlikely(err))
+		goto out;
+
+	inode = file->f_path.dentry->d_inode;
+
+	uds = UNIONFS_F(file)->rdstate;
+	if (!uds) {
+		if (file->f_pos == DIREOF) {
+			goto out;
+		} else if (file->f_pos > 0) {
+			uds = find_rdstate(inode, file->f_pos);
+			if (unlikely(!uds)) {
+				err = -ESTALE;
+				goto out;
+			}
+			UNIONFS_F(file)->rdstate = uds;
+		} else {
+			init_rdstate(file);
+			uds = UNIONFS_F(file)->rdstate;
+		}
+	}
+	bend = fbend(file);
+
+	while (uds->bindex <= bend) {
+		lower_file = unionfs_lower_file_idx(file, uds->bindex);
+		if (!lower_file) {
+			uds->bindex++;
+			uds->dirpos = 0;
+			continue;
+		}
+
+		/* prepare callback buffer */
+		buf.filldir_called = 0;
+		buf.filldir_error = 0;
+		buf.entries_written = 0;
+		buf.dirent = dirent;
+		buf.filldir = filldir;
+		buf.rdstate = uds;
+		buf.sb = inode->i_sb;
+
+		/* Read starting from where we last left off. */
+		offset = vfs_llseek(lower_file, uds->dirpos, SEEK_SET);
+		if (offset < 0) {
+			err = offset;
+			goto out;
+		}
+		err = vfs_readdir(lower_file, unionfs_filldir, &buf);
+
+		/* Save the position for when we continue. */
+		offset = vfs_llseek(lower_file, 0, SEEK_CUR);
+		if (offset < 0) {
+			err = offset;
+			goto out;
+		}
+		uds->dirpos = offset;
+
+		/* Copy the atime. */
+		fsstack_copy_attr_atime(inode,
+					lower_file->f_path.dentry->d_inode);
+
+		if (err < 0)
+			goto out;
+
+		if (buf.filldir_error)
+			break;
+
+		if (!buf.entries_written) {
+			uds->bindex++;
+			uds->dirpos = 0;
+		}
+	}
+
+	if (!buf.filldir_error && uds->bindex >= bend) {
+		/* Save the number of hash entries for next time. */
+		UNIONFS_I(inode)->hashsize = uds->hashentries;
+		free_rdstate(uds);
+		UNIONFS_F(file)->rdstate = NULL;
+		file->f_pos = DIREOF;
+	} else {
+		file->f_pos = rdstate2offset(uds);
+	}
+
+out:
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	return err;
+}
+
+/*
+ * This is not meant to be a generic repositioning function.  If you do
+ * things that aren't supported, then we return EINVAL.
+ *
+ * What is allowed:
+ *  (1) seeking to the same position that you are currently at
+ *	This really has no effect, but returns where you are.
+ *  (2) seeking to the beginning of the file
+ *	This throws out all state, and lets you begin again.
+ */
+static loff_t unionfs_dir_llseek(struct file *file, loff_t offset, int origin)
+{
+	struct unionfs_dir_state *rdstate;
+	loff_t err;
+
+	unionfs_read_lock(file->f_path.dentry->d_sb, UNIONFS_SMUTEX_PARENT);
+
+	err = unionfs_file_revalidate(file, false);
+	if (unlikely(err))
+		goto out;
+
+	rdstate = UNIONFS_F(file)->rdstate;
+
+	/*
+	 * we let users seek to their current position, but not anywhere
+	 * else.
+	 */
+	if (!offset) {
+		switch (origin) {
+		case SEEK_SET:
+			if (rdstate) {
+				free_rdstate(rdstate);
+				UNIONFS_F(file)->rdstate = NULL;
+			}
+			init_rdstate(file);
+			err = 0;
+			break;
+		case SEEK_CUR:
+			err = file->f_pos;
+			break;
+		case SEEK_END:
+			/* Unsupported, because we would break everything.  */
+			err = -EINVAL;
+			break;
+		}
+	} else {
+		switch (origin) {
+		case SEEK_SET:
+			if (rdstate) {
+				if (offset == rdstate2offset(rdstate))
+					err = offset;
+				else if (file->f_pos == DIREOF)
+					err = DIREOF;
+				else
+					err = -EINVAL;
+			} else {
+				struct inode *inode;
+				inode = file->f_path.dentry->d_inode;
+				rdstate = find_rdstate(inode, offset);
+				if (rdstate) {
+					UNIONFS_F(file)->rdstate = rdstate;
+					err = rdstate->offset;
+				} else {
+					err = -EINVAL;
+				}
+			}
+			break;
+		case SEEK_CUR:
+		case SEEK_END:
+			/* Unsupported, because we would break everything.  */
+			err = -EINVAL;
+			break;
+		}
+	}
+
+out:
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	return err;
+}
+
+/*
+ * Trimmed directory options, we shouldn't pass everything down since
+ * we don't want to operate on partial directories.
+ */
+struct file_operations unionfs_dir_fops = {
+	.llseek		= unionfs_dir_llseek,
+	.read		= generic_read_dir,
+	.readdir	= unionfs_readdir,
+	.unlocked_ioctl	= unionfs_ioctl,
+	.open		= unionfs_open,
+	.release	= unionfs_file_release,
+	.flush		= unionfs_flush,
+	.fsync		= unionfs_fsync,
+	.fasync		= unionfs_fasync,
+};
-- 
1.5.2.2

