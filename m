Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYEZM1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYEZM1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbYEZMX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:23:56 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49577 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbYEZMXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:23:44 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH take 3 13/29] UBIFS: add the journal
Date: Mon, 26 May 2008 17:05:27 +0300
Message-Id: <1211810743-18936-14-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 May 2008 12:23:38.0791 (UTC) FILETIME=[53A57370:01C8BF2B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the new data first goes to the journal and sits there until it
gets committed. The journal contents does not have corresponding
on-flash indexing information, so the journal is like a small JFFS2
file-system. Once the journal is committed, the indexing information
is written to the flash media.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/journal.c | 1275 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ubifs/log.c     |  799 ++++++++++++++++++++++++++++++++
 2 files changed, 2074 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
new file mode 100644
index 0000000..a6c8411
--- /dev/null
+++ b/fs/ubifs/journal.c
@@ -0,0 +1,1275 @@
+/*
+ * This file is part of UBIFS.
+ *
+ * Copyright (C) 2006-2008 Nokia Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ * Authors: Artem Bityutskiy (Битюцкий Артём)
+ *          Adrian Hunter
+ */
+
+/*
+ * This file implements UBIFS journal.
+ *
+ * The journal consists of 2 parts - the log and bud LEBs. The log has fixed
+ * length and position, while a bud logical eraseblock is any LEB in the main
+ * area. Buds contain file system data - data nodes, inode nodes, etc. The log
+ * contains only references to buds and some other stuff like commit
+ * start node. The idea is that when we commit the journal, we do
+ * not copy the data, the buds just become indexed. Since after the commit the
+ * nodes in bud eraseblocks become leaf nodes of the file system index tree, we
+ * use term "bud". Analogy is obvious, bud eraseblocks contain nodes which will
+ * become leafs in the future.
+ *
+ * The journal is multi-headed because we want to write data to the journal as
+ * optimally as possible. It is nice to have nodes belonging to the same inode
+ * in one LEB, so we may write data owned by different inodes to different
+ * journal heads, although at present only one data head is used.
+ *
+ * For recovery reasons, the base head contains all inode nodes, all directory
+ * entry nodes and all truncate nodes.  This means that the other heads contain
+ * only data nodes.
+ *
+ * Bud LEBs may be half-indexed. For example, if the bud was not full at the
+ * time of commit, the bud is retained to continue to be used in the journal,
+ * even though the "front" of the LEB is now indexed. In that case, the log
+ * reference contains the offset where the bud starts for the purposes of the
+ * journal.
+ *
+ * The journal size has to be limited, because the larger is the journal, the
+ * longer it takes to mount UBIFS (scanning the journal) and the more memory it
+ * takes (indexing in the TNC).
+ *
+ * Note, all the journal write operations like 'ubifs_jnl_update()' here, which
+ * write multiple UBIFS nodes to the journal at one go, are atomic with respect
+ * to unclean reboots. Should the unclean reboot happen, the recovery code drops
+ * all the nodes.
+ */
+
+#include "ubifs.h"
+
+/**
+ * zero_ino_node_unused - zero out unused fields of an on-flash inode node.
+ * @ino: the inode to zero out
+ */
+static inline void zero_ino_node_unused(struct ubifs_ino_node *ino)
+{
+	memset(ino->padding, 0, 26);
+}
+
+/**
+ * zero_dent_node_unused - zero out unused fields of an on-flash directory
+ *                          entry node.
+ * @ino: the directory entry to zero out
+ */
+static inline void zero_dent_node_unused(struct ubifs_dent_node *dent)
+{
+	dent->padding1 = 0;
+	memset(dent->padding2, 0, 4);
+}
+
+/**
+ * zero_data_node_unused - zero out unused fields of an on-flash data node.
+ * @ino: the data node to zero out
+ */
+static inline void zero_data_node_unused(struct ubifs_data_node *data)
+{
+	memset(data->padding, 0, 2);
+}
+
+/**
+ * reserve_space - reserve space in the journal.
+ * @c: UBIFS file-system description object
+ * @jhead: journal head number
+ * @len: node length
+ *
+ * This function reserves space in journal head @head. If the reservation
+ * succeeded, the journal head stays locked and later has to be unlocked using
+ * 'release_head()'. 'write_node()' and 'write_head()' functions also unlock
+ * it. Returns zero in case of success, %-EAGAIN if commit has to be done, and
+ * other negative error codes in case of other failures.
+ */
+static int reserve_space(struct ubifs_info *c, int jhead, int len)
+{
+	int err = 0, err1, retries = 0, avail, lnum, offs, free, squeeze;
+	struct ubifs_wbuf *wbuf = &c->jheads[jhead].wbuf;
+
+	/*
+	 * Typically, the base head has smaller nodes written to it, so it is
+	 * better to try to allocate space at the ends of eraseblocks. This is
+	 * what the squeeze parameter does.
+	 */
+	squeeze = (jhead == BASEHD);
+again:
+	mutex_lock_nested(&wbuf->io_mutex, wbuf->jhead);
+	avail = c->leb_size - wbuf->offs - wbuf->used;
+
+	if (wbuf->lnum != -1 && avail >= len)
+		return 0;
+
+	/*
+	 * Write buffer wasn't seek'ed or there is no enough space - look for an
+	 * LEB with some empty space.
+	 */
+	lnum = ubifs_find_free_space(c, len, &free, squeeze);
+	if (lnum >= 0) {
+		/* Found an LEB, add it to the journal head */
+		offs = c->leb_size - free;
+		err = ubifs_add_bud_to_log(c, jhead, lnum, offs);
+		if (err)
+			goto out_return;
+		/* A new bud was successfully allocated and added to the log */
+		goto out;
+	}
+
+	err = lnum;
+	if (err != -ENOSPC)
+		goto out_unlock;
+
+	/*
+	 * No free space, we have to run garbage collector to make
+	 * some. But the write-buffer mutex has to be unlocked because
+	 * GC have to sync write buffers, which may lead a deadlock.
+	 */
+	dbg_jnl("no free space  jhead %d, run GC", jhead);
+	mutex_unlock(&wbuf->io_mutex);
+
+	lnum = ubifs_garbage_collect(c, 0);
+	if (lnum < 0) {
+		err = lnum;
+		if (err != -ENOSPC)
+			return err;
+
+		/*
+		 * GC could not make a free LEB. But someone else may
+		 * have allocated new bud for this journal head,
+		 * because we dropped the 'io_mutex', so try once
+		 * again.
+		 */
+		dbg_jnl("GC couldn't make a free LEB for jhead %d", jhead);
+		if (retries++ < 2) {
+			dbg_jnl("retry (%d)", retries);
+			goto again;
+		}
+
+		dbg_jnl("return -ENOSPC");
+		return err;
+	}
+
+	mutex_lock_nested(&wbuf->io_mutex, wbuf->jhead);
+	dbg_jnl("got LEB %d for jhead %d", lnum, jhead);
+	avail = c->leb_size - wbuf->offs - wbuf->used;
+
+	if (wbuf->lnum != -1 && avail >= len) {
+		/*
+		 * Someone else has switched the journal head and we have
+		 * enough space now. This happens when more then one process is
+		 * trying to write to the same journal head at the same time.
+		 */
+		dbg_jnl("return LEB %d back, already have LEB %d:%d",
+			lnum, wbuf->lnum, wbuf->offs + wbuf->used);
+		err = ubifs_return_leb(c, lnum);
+		if (err)
+			goto out_unlock;
+		return 0;
+	}
+
+	err = ubifs_add_bud_to_log(c, jhead, lnum, 0);
+	if (err)
+		goto out_return;
+	offs = 0;
+
+out:
+	err = ubifs_wbuf_seek_nolock(wbuf, lnum, offs, UBI_SHORTTERM);
+	if (err)
+		goto out_unlock;
+
+	return 0;
+
+out_unlock:
+	mutex_unlock(&wbuf->io_mutex);
+	return err;
+
+out_return:
+	/* An error occurred and the LEB has to be returned to lprops */
+	ubifs_assert(err < 0);
+	err1 = ubifs_return_leb(c, lnum);
+	if (err1 && err == -EAGAIN)
+		/*
+		 * Return original error code 'err' only if it is not
+		 * '-EAGAIN', which is not really an error. Otherwise, return
+		 * the error code of 'ubifs_return_leb()'.
+		 */
+		err = err1;
+	mutex_unlock(&wbuf->io_mutex);
+	return err;
+}
+
+/**
+ * write_node - write node to a journal head.
+ * @c: UBIFS file-system description object
+ * @jhead: journal head
+ * @node: node to write
+ * @len: node length
+ * @lnum: LEB number written is returned here
+ * @offs: offset written is returned here
+ *
+ * This function writes a node to reserved space of journal head @jhead.
+ * Returns zero in case of success and a negative error code in case of
+ * failure.
+ */
+static int write_node(struct ubifs_info *c, int jhead, void *node, int len,
+		      int *lnum, int *offs)
+{
+	struct ubifs_wbuf *wbuf = &c->jheads[jhead].wbuf;
+
+	ubifs_assert(jhead != GCHD);
+
+	*lnum = c->jheads[jhead].wbuf.lnum;
+	*offs = c->jheads[jhead].wbuf.offs + c->jheads[jhead].wbuf.used;
+
+	dbg_jnl("jhead %d, LEB %d:%d, len %d", jhead, *lnum, *offs, len);
+	ubifs_prepare_node(c, node, len, 0);
+
+	return ubifs_wbuf_write_nolock(wbuf, node, len);
+}
+
+/**
+ * write_head - write data to a journal head.
+ * @c: UBIFS file-system description object
+ * @jhead: journal head
+ * @buf: buffer to write
+ * @len: length to write
+ * @lnum: LEB number written is returned here
+ * @offs: offset written is returned here
+ * @sync: non-zero if the write-buffer has to by synchronized
+ *
+ * This function is the same as 'write_node()' but it does not assume the
+ * buffer it is writing is a node, so it does not prepare it (which means
+ * initializing common header and calculating CRC).
+ */
+static int write_head(struct ubifs_info *c, int jhead, void *buf, int len,
+		      int *lnum, int *offs, int sync)
+{
+	int err;
+	struct ubifs_wbuf *wbuf = &c->jheads[jhead].wbuf;
+
+	ubifs_assert(jhead != GCHD);
+
+	*lnum = c->jheads[jhead].wbuf.lnum;
+	*offs = c->jheads[jhead].wbuf.offs + c->jheads[jhead].wbuf.used;
+	dbg_jnl("jhead %d, LEB %d:%d, len %d", jhead, *lnum, *offs, len);
+
+	err = ubifs_wbuf_write_nolock(wbuf, buf, len);
+	if (err)
+		return err;
+	if (sync)
+		err = ubifs_wbuf_sync_nolock(wbuf);
+	return err;
+}
+
+/**
+ * make_reservation - reserve journal space.
+ * @c: UBIFS file-system description object
+ * @jhead: journal head
+ * @len: how many bytes to reserve
+ *
+ * This function makes space reservation in journal head @jhead. The function
+ * takes the commit lock and locks the journal head, and the caller has to
+ * unlock the head and finish the reservation with 'finish_reservation()'.
+ * Returns zero in case of success and a negative error code in case of
+ * failure.
+ *
+ * Note, the journal head may be unlocked as soon as the data is written, while
+ * the commit lock has to be released after the data has been added to the
+ * TNC.
+ */
+static int make_reservation(struct ubifs_info *c, int jhead, int len)
+{
+	int err, cmt_retries = 0, nospc_retries = 0;
+
+	ubifs_assert(len <= c->dark_wm);
+
+again:
+	down_read(&c->commit_sem);
+	err = reserve_space(c, jhead, len);
+	if (!err)
+		return 0;
+	up_read(&c->commit_sem);
+
+	if (err == -ENOSPC) {
+		/*
+		 * GC could not make any progress. We should try to commit
+		 * once because it could make some dirty space and GC would
+		 * make progress, so make the error -EAGAIN so that the below
+		 * will commit and re-try.
+		 */
+		if (nospc_retries++ < 2) {
+			dbg_jnl("no space, retry");
+			err = -EAGAIN;
+		}
+
+		/*
+		 * This means that the budgeting is incorrect. We always have
+		 * to be able to write to the media, because all operations are
+		 * budgeted. Deletions are not budgeted, though, but we reserve
+		 * an extra LEB for them.
+		 */
+	}
+
+	if (err != -EAGAIN)
+		goto out;
+
+	/*
+	 * -EAGAIN means that the journal is full or too large, or the above
+	 * code wants to do one commit. Do this and re-try.
+	 */
+	if (cmt_retries > 128) {
+		/*
+		 * This should not happen unless the journal size limitations
+		 * are too tough.
+		 */
+		ubifs_err("stuck in space allocation");
+		err = -ENOSPC;
+		goto out;
+	} else if (cmt_retries > 32)
+		ubifs_warn("too many space allocation re-tries (%d)",
+			   cmt_retries);
+
+	dbg_jnl("-EAGAIN, commit and retry (retried %d times)",
+		cmt_retries);
+	cmt_retries += 1;
+
+	err = ubifs_run_commit(c);
+	if (err)
+		return err;
+	goto again;
+
+out:
+	ubifs_err("cannot reserve %d bytes in jhead %d, error %d",
+		  len, jhead, err);
+	if (err == -ENOSPC) {
+		/* This are some budgeting problems, print useful information */
+		down_write(&c->commit_sem);
+		spin_lock(&c->space_lock);
+		dbg_dump_stack();
+		dbg_dump_budg(c);
+		spin_unlock(&c->space_lock);
+		dbg_dump_lprops(c);
+		cmt_retries = dbg_check_lprops(c);
+		up_write(&c->commit_sem);
+	}
+
+	return err;
+}
+
+/**
+ * release_head - release a journal head.
+ * @c: UBIFS file-system description object
+ * @jhead: journal head
+ *
+ * This function releases journal head @jhead which was locked by
+ * the 'make_reservation()' function. It has to be called after each successful
+ * 'make_reservation()' invocation.
+ */
+static inline void release_head(struct ubifs_info *c, int jhead)
+{
+	mutex_unlock(&c->jheads[jhead].wbuf.io_mutex);
+}
+
+/**
+ * finish_reservation - finish a reservation.
+ * @c: UBIFS file-system description object
+ *
+ * This function finishes journal space reservation. It must be called after
+ * 'make_reservation()'.
+ */
+static void finish_reservation(struct ubifs_info *c)
+{
+	up_read(&c->commit_sem);
+}
+
+/**
+ * get_dent_type - translate VFS inode mode to UBIFS directory entry type.
+ * @mode: inode mode
+ */
+static int get_dent_type(int mode)
+{
+	switch (mode & S_IFMT) {
+	case S_IFREG:
+		return UBIFS_ITYPE_REG;
+	case S_IFDIR:
+		return UBIFS_ITYPE_DIR;
+	case S_IFLNK:
+		return UBIFS_ITYPE_LNK;
+	case S_IFBLK:
+		return UBIFS_ITYPE_BLK;
+	case S_IFCHR:
+		return UBIFS_ITYPE_CHR;
+	case S_IFIFO:
+		return UBIFS_ITYPE_FIFO;
+	case S_IFSOCK:
+		return UBIFS_ITYPE_SOCK;
+	default:
+		BUG();
+	}
+	return 0;
+}
+
+/**
+ * pack_inode - pack an inode node.
+ * @c: UBIFS file-system description object
+ * @ino: buffer in which to pack inode node
+ * @inode: inode to pack
+ * @last: indicates the last node of the group
+ * @last_reference: non-zero if this is a deletion inode
+ */
+static void pack_inode(struct ubifs_info *c, struct ubifs_ino_node *ino,
+		       const struct inode *inode, int last, int last_reference)
+{
+	int data_len = 0;
+	struct ubifs_inode *ui = ubifs_inode(inode);
+
+	ino->ch.node_type = UBIFS_INO_NODE;
+	ino_key_init_flash(c, &ino->key, inode->i_ino);
+	ino->creat_sqnum = cpu_to_le64(ui->creat_sqnum);
+	ino->size  = cpu_to_le64(i_size_read(inode));
+	ino->nlink = cpu_to_le32(inode->i_nlink);
+	ino->atime_sec  = cpu_to_le64(inode->i_atime.tv_sec);
+	ino->atime_nsec = cpu_to_le32(inode->i_atime.tv_nsec);
+	ino->ctime_sec  = cpu_to_le64(inode->i_ctime.tv_sec);
+	ino->ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
+	ino->mtime_sec  = cpu_to_le64(inode->i_mtime.tv_sec);
+	ino->mtime_nsec = cpu_to_le32(inode->i_mtime.tv_nsec);
+	ino->uid   = cpu_to_le32(inode->i_uid);
+	ino->gid   = cpu_to_le32(inode->i_gid);
+	ino->mode  = cpu_to_le32(inode->i_mode);
+	ino->flags = cpu_to_le32(ui->flags);
+	ino->compr_type  = cpu_to_le16(ui->compr_type);
+	ino->xattr_cnt   = cpu_to_le32(ui->xattr_cnt);
+	ino->xattr_size  = cpu_to_le64(ui->xattr_size);
+	ino->xattr_names = cpu_to_le32(ui->xattr_names);
+	ino->data_len    = cpu_to_le32(ui->data_len);
+	zero_ino_node_unused(ino);
+
+	/*
+	 * Drop the attached data if this is a deletion inode, the data is not
+	 * needed anymore.
+	 */
+	if (!last_reference) {
+		memcpy(ino->data, ui->data, ui->data_len);
+		data_len = ui->data_len;
+	}
+
+	ubifs_prep_grp_node(c, ino, UBIFS_INO_NODE_SZ + data_len, last);
+}
+
+/**
+ * ubifs_jnl_update - update inode.
+ * @c: UBIFS file-system description object
+ * @dir: parent inode or host inode in case of extended attributes
+ * @nm: directory entry name
+ * @inode: inode
+ * @deletion: indicates a directory entry deletion i.e unlink or rmdir
+ * @sync: non-zero if the write-buffer has to be synchronized
+ * @xent: non-zero if the directory entry is an extended attribute entry
+ *
+ * This function updates an inode by writing a directory entry (or extended
+ * attribute entry), the inode itself, and the parent directory inode (or the
+ * host inode) to the journal.
+ *
+ * The function writes the host inode @dir last, which is important in case of
+ * extended attributes. Indeed, then we guarantee that if the host inode gets
+ * synchronized, and the write-buffer it sits in gets flushed, the extended
+ * attribute inode gets flushed too. And this is exactly what the user expects -
+ * synchronizing the host inode synchronizes its extended attributes.
+ * Similarly, this guarantees that if @dir is synchronized, its directory entry
+ * corresponding to @nm gets synchronized too.
+ *
+ * This function returns %0 on success and a negative error code on failure.
+ */
+int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
+		     const struct qstr *nm, const struct inode *inode,
+		     int deletion, int sync, int xent)
+{
+	int err, dlen, ilen, len, lnum, ino_offs, dent_offs;
+	int aligned_dlen, aligned_ilen;
+	int last_reference = !!(deletion && inode->i_nlink == 0);
+	struct ubifs_dent_node *dent;
+	struct ubifs_ino_node *ino;
+	union ubifs_key dent_key, ino_key;
+
+	dbg_jnl("ino %lu, dent '%.*s', data len %d in dir ino %lu",
+		inode->i_ino, nm->len, nm->name, ubifs_inode(inode)->data_len,
+		dir->i_ino);
+	ubifs_assert(ubifs_inode(dir)->data_len == 0);
+
+	dlen = UBIFS_DENT_NODE_SZ + nm->len + 1;
+	ilen = UBIFS_INO_NODE_SZ;
+
+	/*
+	 * If the last reference to the inode is being deleted, then there is no
+	 * need to attach and write inode data, it is being deleted anyway.
+	 */
+	if (!last_reference)
+		ilen += ubifs_inode(inode)->data_len;
+
+	aligned_dlen = ALIGN(dlen, 8);
+	aligned_ilen = ALIGN(ilen, 8);
+
+	len = aligned_dlen + aligned_ilen + UBIFS_INO_NODE_SZ;
+
+	dent = kmalloc(len, GFP_NOFS);
+	if (!dent)
+		return -ENOMEM;
+
+	/* Make reservation before allocating sequence numbers */
+	err = make_reservation(c, BASEHD, len);
+	if (err)
+		goto out_free;
+
+	if (!xent) {
+		dent->ch.node_type = UBIFS_DENT_NODE;
+		dent_key_init(c, &dent_key, dir->i_ino, nm);
+	} else {
+		dent->ch.node_type = UBIFS_XENT_NODE;
+		xent_key_init(c, &dent_key, dir->i_ino, nm);
+	}
+
+	key_write(c, &dent_key, dent->key);
+	dent->inum = deletion ? 0 : cpu_to_le64(inode->i_ino);
+	dent->type = get_dent_type(inode->i_mode);
+	dent->nlen = cpu_to_le16(nm->len);
+	memcpy(dent->name, nm->name, nm->len);
+	dent->name[nm->len] = '\0';
+	zero_dent_node_unused(dent);
+	ubifs_prep_grp_node(c, dent, dlen, 0);
+
+	ino = (void *)dent + aligned_dlen;
+	pack_inode(c, ino, inode, 0, last_reference);
+
+	ino = (void *)ino + aligned_ilen;
+	pack_inode(c, ino, dir, 1, 0);
+
+	if (last_reference) {
+		err = ubifs_add_orphan(c, inode->i_ino);
+		if (err) {
+			release_head(c, BASEHD);
+			goto out_finish;
+		}
+	}
+
+	err = write_head(c, BASEHD, dent, len, &lnum, &dent_offs, sync);
+	if (!sync && !err) {
+		struct ubifs_wbuf *wbuf = &c->jheads[BASEHD].wbuf;
+
+		ubifs_wbuf_add_ino_nolock(wbuf, inode->i_ino);
+		ubifs_wbuf_add_ino_nolock(wbuf, dir->i_ino);
+	}
+	release_head(c, BASEHD);
+	kfree(dent);
+	if (err)
+		goto out_ro;
+
+	if (deletion) {
+		err = ubifs_tnc_remove_nm(c, &dent_key, nm);
+		if (err)
+			goto out_ro;
+		err = ubifs_add_dirt(c, lnum, dlen);
+	} else
+		err = ubifs_tnc_add_nm(c, &dent_key, lnum, dent_offs, dlen, nm);
+	if (err)
+		goto out_ro;
+
+	/*
+	 * Note, we do not remove the inode from TNC even if the last reference
+	 * to it has just been deleted, because the inode may still be opened.
+	 * Instead, the inode has been added to orphan lists and the orphan
+	 * subsystem will take further care about it.
+	 */
+	ino_key_init(c, &ino_key, inode->i_ino);
+	ino_offs = dent_offs + aligned_dlen;
+	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs, ilen);
+	if (err)
+		goto out_ro;
+
+	ino_key_init(c, &ino_key, dir->i_ino);
+	ino_offs += aligned_ilen;
+	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs, UBIFS_INO_NODE_SZ);
+	if (err)
+		goto out_ro;
+
+	finish_reservation(c);
+	return 0;
+
+out_finish:
+	finish_reservation(c);
+out_free:
+	kfree(dent);
+	return err;
+
+out_ro:
+	ubifs_ro_mode(c, err);
+	if (last_reference)
+		ubifs_delete_orphan(c, inode->i_ino);
+	finish_reservation(c);
+	return err;
+}
+
+/**
+ * ubifs_jnl_write_data - write a data node to the journal.
+ * @c: UBIFS file-system description object
+ * @inode: inode the data node belongs to
+ * @key: node key
+ * @buf: buffer to write
+ * @len: data length (must not exceed %UBIFS_BLOCK_SIZE)
+ *
+ * This function writes a data node to the journal. Returns %0 if the data node
+ * was successfully written, and a negative error code in case of failure.
+ */
+int ubifs_jnl_write_data(struct ubifs_info *c, const struct inode *inode,
+			 const union ubifs_key *key, const void *buf, int len)
+{
+	int err, lnum, offs, compr_type, out_len;
+	int dlen = UBIFS_DATA_NODE_SZ + UBIFS_BLOCK_SIZE * WORST_COMPR_FACTOR;
+	const struct ubifs_inode *ui = ubifs_inode(inode);
+	struct ubifs_data_node *data;
+
+	dbg_jnl("ino %lu, blk %u, len %d, key %s", key_ino(c, key),
+		key_block(c, key), len, DBGKEY(key));
+	ubifs_assert(len <= UBIFS_BLOCK_SIZE);
+
+	data = kmalloc(dlen, GFP_NOFS);
+	if (!data)
+		return -ENOMEM;
+
+	data->ch.node_type = UBIFS_DATA_NODE;
+	key_write(c, key, &data->key);
+	data->size = cpu_to_le32(len);
+	zero_data_node_unused(data);
+
+	if (!(ui->flags && UBIFS_COMPR_FL))
+		/* Compression is disabled for this inode */
+		compr_type = UBIFS_COMPR_NONE;
+	else
+		compr_type = ui->compr_type;
+
+	out_len = dlen - UBIFS_DATA_NODE_SZ;
+	ubifs_compress(buf, len, &data->data, &out_len, &compr_type);
+	ubifs_assert(out_len <= UBIFS_BLOCK_SIZE);
+
+	dlen = UBIFS_DATA_NODE_SZ + out_len;
+	data->compr_type = cpu_to_le16(compr_type);
+
+	/* Make reservation before allocating sequence numbers */
+	err = make_reservation(c, DATAHD, dlen);
+	if (err)
+		goto out_free;
+
+	err = write_node(c, DATAHD, data, dlen, &lnum, &offs);
+	if (!err)
+		ubifs_wbuf_add_ino_nolock(&c->jheads[DATAHD].wbuf,
+					  key_ino(c, key));
+	release_head(c, DATAHD);
+	if (err)
+		goto out_ro;
+
+	err = ubifs_tnc_add(c, key, lnum, offs, dlen);
+	if (err)
+		goto out_ro;
+
+	finish_reservation(c);
+	kfree(data);
+	return 0;
+
+out_ro:
+	ubifs_ro_mode(c, err);
+	finish_reservation(c);
+out_free:
+	kfree(data);
+	return err;
+}
+
+/**
+ * ubifs_jnl_write_inode - flush inode to the journal.
+ * @c: UBIFS file-system description object
+ * @inode: inode to flush
+ * @last_reference: inode has been deleted
+ * @sync: non-zero if the write-buffer has to be synchronized
+ *
+ * This function writes inode @inode to the journal (to the base head). Returns
+ * zero in case of success and a negative error code in case of failure.
+ */
+int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode,
+			  int last_reference, int sync)
+{
+	int err, len, lnum, offs;
+	struct ubifs_ino_node *ino;
+	struct ubifs_inode *ui = ubifs_inode(inode);
+
+	dbg_jnl("ino %lu%s", inode->i_ino,
+		last_reference ? " (last reference)" : "");
+	if (last_reference)
+		ubifs_assert(inode->i_nlink == 0);
+
+	/* If the inode is deleted, do not write the attached data */
+	len = UBIFS_INO_NODE_SZ;
+	if (!last_reference)
+		len += ui->data_len;
+	ino = kmalloc(len, GFP_NOFS);
+	if (!ino)
+		return -ENOMEM;
+
+	/* Make reservation before allocating sequence numbers */
+	err = make_reservation(c, BASEHD, len);
+	if (err)
+		goto out_free;
+
+	pack_inode(c, ino, inode, 1, last_reference);
+
+	err = write_head(c, BASEHD, ino, len, &lnum, &offs, sync);
+	if (!sync && !err)
+		ubifs_wbuf_add_ino_nolock(&c->jheads[BASEHD].wbuf,
+					  inode->i_ino);
+	release_head(c, BASEHD);
+	if (err)
+		goto out_ro;
+
+	if (last_reference) {
+		err = ubifs_tnc_remove_ino(c, inode->i_ino);
+		if (err)
+			goto out_ro;
+		ubifs_delete_orphan(c, inode->i_ino);
+		err = ubifs_add_dirt(c, lnum, len);
+	} else {
+		union ubifs_key key;
+
+		ino_key_init(c, &key, inode->i_ino);
+		err = ubifs_tnc_add(c, &key, lnum, offs, len);
+	}
+	if (err)
+		goto out_ro;
+
+	finish_reservation(c);
+	kfree(ino);
+	return 0;
+
+out_ro:
+	ubifs_ro_mode(c, err);
+	finish_reservation(c);
+out_free:
+	kfree(ino);
+	return err;
+}
+
+/**
+ * ubifs_jnl_rename - rename a directory entry.
+ * @c: UBIFS file-system description object
+ * @old_dir: parent inode of directory entry to rename
+ * @old_dentry: directory entry to rename
+ * @new_dir: parent inode of directory entry to rename
+ * @new_dentry: new directory entry (or directory entry to replace)
+ * @sync: non-zero if the write-buffer has to be synchronized
+ *
+ * Returns zero in case of success and a negative error code in case of failure.
+ */
+int ubifs_jnl_rename(struct ubifs_info *c, const struct inode *old_dir,
+		     const struct dentry *old_dentry,
+		     const struct inode *new_dir,
+		     const struct dentry *new_dentry, int sync)
+{
+	const struct inode *old_inode = old_dentry->d_inode;
+	const struct inode *new_inode = new_dentry->d_inode;
+	int err, dlen1, dlen2, ilen, lnum, offs, len;
+	int aligned_dlen1, aligned_dlen2, plen = UBIFS_INO_NODE_SZ;
+	int last_reference = !!(new_inode && new_inode->i_nlink == 0);
+	struct ubifs_dent_node *dent, *dent2;
+	void *p;
+	union ubifs_key key;
+
+	dbg_jnl("dent '%.*s' in dir ino %lu to dent '%.*s' in dir ino %lu",
+		old_dentry->d_name.len, old_dentry->d_name.name,
+		old_dir->i_ino, new_dentry->d_name.len,
+		new_dentry->d_name.name, new_dir->i_ino);
+
+	ubifs_assert(ubifs_inode(old_dir)->data_len == 0);
+	ubifs_assert(ubifs_inode(new_dir)->data_len == 0);
+
+	dlen1 = UBIFS_DENT_NODE_SZ + new_dentry->d_name.len + 1;
+	dlen2 = UBIFS_DENT_NODE_SZ + old_dentry->d_name.len + 1;
+	if (new_inode) {
+		ilen = UBIFS_INO_NODE_SZ;
+		if (!last_reference)
+			ilen += ubifs_inode(new_inode)->data_len;
+	} else
+		ilen = 0;
+
+	aligned_dlen1 = ALIGN(dlen1, 8);
+	aligned_dlen2 = ALIGN(dlen2, 8);
+
+	len = aligned_dlen1 + aligned_dlen2 + ALIGN(ilen, 8) + ALIGN(plen, 8);
+	if (old_dir != new_dir)
+		len += plen;
+
+	dent = kmalloc(len, GFP_NOFS);
+	if (!dent)
+		return -ENOMEM;
+
+	/* Make reservation before allocating sequence numbers */
+	err = make_reservation(c, BASEHD, len);
+	if (err)
+		goto out_free;
+
+	/* Make new dent */
+	dent->ch.node_type = UBIFS_DENT_NODE;
+	dent_key_init_flash(c, &dent->key, new_dir->i_ino, &new_dentry->d_name);
+	dent->inum = cpu_to_le64(old_inode->i_ino);
+	dent->type = get_dent_type(old_inode->i_mode);
+	dent->nlen = cpu_to_le16(new_dentry->d_name.len);
+	memcpy(dent->name, new_dentry->d_name.name, new_dentry->d_name.len);
+	dent->name[new_dentry->d_name.len] = '\0';
+	zero_dent_node_unused(dent);
+	ubifs_prep_grp_node(c, dent, dlen1, 0);
+
+	dent2 = (void *)dent + aligned_dlen1;
+
+	/* Make deletion dent */
+	dent2->ch.node_type = UBIFS_DENT_NODE;
+	dent_key_init_flash(c, &dent2->key, old_dir->i_ino,
+			    &old_dentry->d_name);
+	dent2->inum = cpu_to_le64(0);
+	dent2->type = DT_UNKNOWN;
+	dent2->nlen = cpu_to_le16(old_dentry->d_name.len);
+	memcpy(dent2->name, old_dentry->d_name.name, old_dentry->d_name.len);
+	dent2->name[old_dentry->d_name.len] = '\0';
+	zero_dent_node_unused(dent2);
+	ubifs_prep_grp_node(c, dent2, dlen2, 0);
+
+	p = (void *)dent2 + aligned_dlen2;
+	if (new_inode) {
+		pack_inode(c, p, new_inode, 0, last_reference);
+		p += ALIGN(ilen, 8);
+	}
+
+	if (old_dir == new_dir)
+		pack_inode(c, p, old_dir, 1, 0);
+	else {
+		pack_inode(c, p, old_dir, 0, 0);
+		p += ALIGN(plen, 8);
+		pack_inode(c, p, new_dir, 1, 0);
+	}
+
+	if (last_reference) {
+		err = ubifs_add_orphan(c, new_inode->i_ino);
+		if (err) {
+			release_head(c, BASEHD);
+			goto out_finish;
+		}
+	}
+
+	err = write_head(c, BASEHD, dent, len, &lnum, &offs, sync);
+	if (!sync && !err) {
+		struct ubifs_wbuf *wbuf = &c->jheads[BASEHD].wbuf;
+
+		ubifs_wbuf_add_ino_nolock(wbuf, new_dir->i_ino);
+		ubifs_wbuf_add_ino_nolock(wbuf, old_dir->i_ino);
+		if (new_inode)
+			ubifs_wbuf_add_ino_nolock(&c->jheads[BASEHD].wbuf,
+						  new_inode->i_ino);
+	}
+	release_head(c, BASEHD);
+	if (err)
+		goto out_ro;
+
+	dent_key_init(c, &key, new_dir->i_ino, &new_dentry->d_name);
+	err = ubifs_tnc_add_nm(c, &key, lnum, offs, dlen1, &new_dentry->d_name);
+	if (err)
+		goto out_ro;
+
+	err = ubifs_add_dirt(c, lnum, dlen2);
+	if (err)
+		goto out_ro;
+
+	dent_key_init(c, &key, old_dir->i_ino, &old_dentry->d_name);
+	err = ubifs_tnc_remove_nm(c, &key, &old_dentry->d_name);
+	if (err)
+		goto out_ro;
+
+	offs += aligned_dlen1 + aligned_dlen2;
+	if (new_inode) {
+		ino_key_init(c, &key, new_inode->i_ino);
+		err = ubifs_tnc_add(c, &key, lnum, offs, ilen);
+		if (err)
+			goto out_ro;
+		offs += ALIGN(ilen, 8);
+	}
+
+	ino_key_init(c, &key, old_dir->i_ino);
+	err = ubifs_tnc_add(c, &key, lnum, offs, plen);
+	if (err)
+		goto out_ro;
+
+	if (old_dir != new_dir) {
+		offs += ALIGN(plen, 8);
+		ino_key_init(c, &key, new_dir->i_ino);
+		err = ubifs_tnc_add(c, &key, lnum, offs, plen);
+		if (err)
+			goto out_ro;
+	}
+
+	finish_reservation(c);
+	kfree(dent);
+	return 0;
+
+out_ro:
+	ubifs_ro_mode(c, err);
+	if (last_reference)
+		ubifs_delete_orphan(c, new_inode->i_ino);
+out_finish:
+	finish_reservation(c);
+out_free:
+	kfree(dent);
+	return err;
+}
+
+/**
+ * recomp_data_node - re-compress a truncated data node.
+ * @dn: data node to re-compress
+ * @new_len: new length
+ *
+ * This function is used when an inode is truncated and the last data node of
+ * the inode has to be re-compressed and re-written.
+ */
+static int recomp_data_node(struct ubifs_data_node *dn, int *new_len)
+{
+	void *buf;
+	int err, len, compr_type, out_len;
+
+	out_len = le32_to_cpu(dn->size);
+	buf = kmalloc(out_len * WORST_COMPR_FACTOR, GFP_NOFS);
+	if (!buf)
+		return -ENOMEM;
+
+	len = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
+	compr_type = le16_to_cpu(dn->compr_type);
+	err = ubifs_decompress(&dn->data, len, buf, &out_len, compr_type);
+	if (err)
+		goto out;
+
+	ubifs_compress(buf, *new_len, &dn->data, &out_len, &compr_type);
+	ubifs_assert(out_len <= UBIFS_BLOCK_SIZE);
+	dn->compr_type = cpu_to_le16(compr_type);
+	dn->size = cpu_to_le32(*new_len);
+	*new_len = UBIFS_DATA_NODE_SZ + out_len;
+out:
+	kfree(buf);
+	return err;
+}
+
+/**
+ * ubifs_jnl_truncate - update the journal for a truncation.
+ * @c: UBIFS file-system description object
+ * @inum: inode number of inode being truncated
+ * @old_size: old size
+ * @new_size: new size
+ *
+ * When the size of a file decreases due to truncation, a truncation node is
+ * written, the journal tree is updated, and the last data block is re-written
+ * if it has been affected.
+ *
+ * This function returns %0 in the case of success, and a negative error code in
+ * case of failure.
+ */
+int ubifs_jnl_truncate(struct ubifs_info *c, ino_t inum,
+		       loff_t old_size, loff_t new_size)
+{
+	union ubifs_key key, to_key;
+	struct ubifs_trun_node *trun;
+	struct ubifs_data_node *uninitialized_var(dn);
+	int err, dlen, len, lnum, offs, bit, sz;
+	unsigned int blk;
+
+	dbg_jnl("ino %lu, size %lld -> %lld", inum, old_size, new_size);
+
+	sz = UBIFS_TRUN_NODE_SZ + UBIFS_MAX_DATA_NODE_SZ * WORST_COMPR_FACTOR;
+	trun = kmalloc(sz, GFP_NOFS);
+	if (!trun)
+		return -ENOMEM;
+
+	trun->ch.node_type = UBIFS_TRUN_NODE;
+	trun_key_init_flash(c, &trun->key, inum);
+	trun->old_size = cpu_to_le64(old_size);
+	trun->new_size = cpu_to_le64(new_size);
+
+	dlen = new_size & (UBIFS_BLOCK_SIZE - 1);
+
+	if (dlen) {
+		/* Get last data block so it can be truncated */
+		dn = (void *)trun + ALIGN(UBIFS_TRUN_NODE_SZ, 8);
+		blk = new_size / UBIFS_BLOCK_SIZE;
+		data_key_init(c, &key, inum, blk);
+		dbg_jnl("last block key %s", DBGKEY(&key));
+		err = ubifs_tnc_lookup(c, &key, dn);
+		if (err == -ENOENT)
+			dlen = 0; /* Not found (so it is a hole) */
+		else if (err)
+			goto out_free;
+		else {
+			if (le32_to_cpu(dn->size) <= dlen)
+				dlen = 0; /* Nothing to do */
+			else {
+				int compr_type = le16_to_cpu(dn->compr_type);
+
+				if (compr_type != UBIFS_COMPR_NONE) {
+					err = recomp_data_node(dn, &dlen);
+					if (err)
+						goto out_free;
+				} else {
+					dn->size = cpu_to_le32(dlen);
+					dlen += UBIFS_DATA_NODE_SZ;
+				}
+				zero_data_node_unused(dn);
+			}
+		}
+	}
+
+	if (dlen)
+		len = ALIGN(UBIFS_TRUN_NODE_SZ, 8) + dlen;
+	else
+		len = UBIFS_TRUN_NODE_SZ;
+
+	/* Must make reservation before allocating sequence numbers */
+	err = make_reservation(c, BASEHD, len);
+	if (err)
+		goto out_free;
+
+	ubifs_prepare_node(c, trun, UBIFS_TRUN_NODE_SZ, 0);
+	if (dlen)
+		ubifs_prepare_node(c, dn, dlen, 0);
+
+	err = write_head(c, BASEHD, trun, len, &lnum, &offs, 0);
+	if (!err)
+		ubifs_wbuf_add_ino_nolock(&c->jheads[BASEHD].wbuf, inum);
+	release_head(c, BASEHD);
+	if (err)
+		goto out_ro;
+
+	if (dlen) {
+		offs += ALIGN(UBIFS_TRUN_NODE_SZ, 8);
+		err = ubifs_tnc_add(c, &key, lnum, offs, dlen);
+		if (err)
+			goto out_ro;
+	}
+
+	err = ubifs_add_dirt(c, lnum, UBIFS_TRUN_NODE_SZ);
+	if (err)
+		goto out_ro;
+
+	bit = new_size & (UBIFS_BLOCK_SIZE - 1);
+
+	blk = new_size / UBIFS_BLOCK_SIZE + (bit ? 1 : 0);
+	data_key_init(c, &key, inum, blk);
+
+	bit = old_size & (UBIFS_BLOCK_SIZE - 1);
+
+	blk = old_size / UBIFS_BLOCK_SIZE - (bit ? 0: 1);
+	data_key_init(c, &to_key, inum, blk);
+
+	err = ubifs_tnc_remove_range(c, &key, &to_key);
+	if (err)
+		goto out_ro;
+
+	finish_reservation(c);
+	kfree(trun);
+	return 0;
+
+out_ro:
+	ubifs_ro_mode(c, err);
+	finish_reservation(c);
+out_free:
+	kfree(trun);
+	return err;
+}
+
+#ifdef CONFIG_UBIFS_FS_XATTR
+
+int ubifs_jnl_delete_xattr(struct ubifs_info *c, const struct inode *host,
+			   const struct inode *inode, const struct qstr *nm,
+			   int sync)
+{
+	int err, xlen, hlen, len, lnum, xent_offs, aligned_xlen;
+	struct ubifs_dent_node *xent;
+	struct ubifs_ino_node *ino;
+	union ubifs_key xent_key, key1, key2;
+
+	dbg_jnl("host %lu, xattr ino %lu, name '%s', data len %d",
+		host->i_ino, inode->i_ino, nm->name,
+		ubifs_inode(inode)->data_len);
+	ubifs_assert(inode->i_nlink == 0);
+
+	/*
+	 * Since we are deleting the inode, we do not bother to attach any data
+	 * to it and assume its length is %UBIFS_INO_NODE_SZ.
+	 */
+	xlen = UBIFS_DENT_NODE_SZ + nm->len + 1;
+	aligned_xlen = ALIGN(xlen, 8);
+	hlen = ubifs_inode(host)->data_len + UBIFS_INO_NODE_SZ;
+	len = aligned_xlen + UBIFS_INO_NODE_SZ + ALIGN(hlen, 8);
+
+	xent = kmalloc(len, GFP_NOFS);
+	if (!xent)
+		return -ENOMEM;
+
+	/* Make reservation before allocating sequence numbers */
+	err = make_reservation(c, BASEHD, len);
+	if (err) {
+		kfree(xent);
+		return err;
+	}
+
+	xent->ch.node_type = UBIFS_XENT_NODE;
+	xent_key_init(c, &xent_key, host->i_ino, nm);
+	key_write(c, &xent_key, xent->key);
+	xent->inum = 0;
+	xent->type = get_dent_type(inode->i_mode);
+	xent->nlen = cpu_to_le16(nm->len);
+	memcpy(xent->name, nm->name, nm->len);
+	xent->name[nm->len] = '\0';
+	zero_dent_node_unused(xent);
+	ubifs_prep_grp_node(c, xent, xlen, 0);
+
+	ino = (void *)xent + aligned_xlen;
+	pack_inode(c, ino, inode, 0, 1);
+
+	ino = (void *)ino + UBIFS_INO_NODE_SZ;
+	pack_inode(c, ino, host, 1, 0);
+
+	err = write_head(c, BASEHD, xent, len, &lnum, &xent_offs, sync);
+	if (!sync && !err)
+		ubifs_wbuf_add_ino_nolock(&c->jheads[BASEHD].wbuf, host->i_ino);
+	release_head(c, BASEHD);
+	kfree(xent);
+	if (err)
+		goto out_ro;
+
+	/* Remove the extended attribute entry from TNC */
+	err = ubifs_tnc_remove_nm(c, &xent_key, nm);
+	if (err)
+		goto out_ro;
+	err = ubifs_add_dirt(c, lnum, xlen);
+	if (err)
+		goto out_ro;
+
+	/*
+	 * Remove all nodes belonging to the extended attribute inode from TNC.
+	 * Well, there actually must be only one node - the inode itself.
+	 */
+	lowest_ino_key(c, &key1, inode->i_ino);
+	highest_ino_key(c, &key2, inode->i_ino);
+	err = ubifs_tnc_remove_range(c, &key1, &key2);
+	if (err)
+		goto out_ro;
+	err = ubifs_add_dirt(c, lnum, UBIFS_INO_NODE_SZ);
+	if (err)
+		goto out_ro;
+
+	/* And update TNC with the new host inode position */
+	ino_key_init(c, &key1, host->i_ino);
+	err = ubifs_tnc_add(c, &key1, lnum, xent_offs + len - hlen, hlen);
+	if (err)
+		goto out_ro;
+
+	finish_reservation(c);
+	return 0;
+
+out_ro:
+	ubifs_ro_mode(c, err);
+	finish_reservation(c);
+	return err;
+}
+
+/**
+ * ubifs_jnl_write_2_inodes - write 2 inodes to the journal.
+ * @c: UBIFS file-system description object
+ * @inode1: first inode to write
+ * @inode2: second inode to write
+ * @sync: non-zero if the write-buffer has to be synchronized
+ *
+ * This function writes 2 inodes @inode1 and @inode2 to the journal (to the
+ * base head - first @inode1, then @inode2). Returns zero in case of success
+ * and a negative error code in case of failure.
+ */
+int ubifs_jnl_write_2_inodes(struct ubifs_info *c, const struct inode *inode1,
+			     const struct inode *inode2, int sync)
+{
+	int err, len1, len2, aligned_len, aligned_len1, lnum, offs;
+	struct ubifs_ino_node *ino;
+	union ubifs_key key;
+
+	dbg_jnl("ino %lu, ino %lu", inode1->i_ino, inode2->i_ino);
+	ubifs_assert(inode1->i_nlink > 0);
+	ubifs_assert(inode2->i_nlink > 0);
+
+	len1 = UBIFS_INO_NODE_SZ + ubifs_inode(inode1)->data_len;
+	len2 = UBIFS_INO_NODE_SZ + ubifs_inode(inode2)->data_len;
+	aligned_len1 = ALIGN(len1, 8);
+	aligned_len = aligned_len1 + ALIGN(len2, 8);
+
+	ino = kmalloc(aligned_len, GFP_NOFS);
+	if (!ino)
+		return -ENOMEM;
+
+	/* Make reservation before allocating sequence numbers */
+	err = make_reservation(c, BASEHD, aligned_len);
+	if (err)
+		goto out_free;
+
+	pack_inode(c, ino, inode1, 0, 0);
+	pack_inode(c, (void *)ino + aligned_len1, inode2, 1, 0);
+
+	err = write_head(c, BASEHD, ino, aligned_len, &lnum, &offs, 0);
+	if (!sync && !err) {
+		struct ubifs_wbuf *wbuf = &c->jheads[BASEHD].wbuf;
+
+		ubifs_wbuf_add_ino_nolock(wbuf, inode1->i_ino);
+		ubifs_wbuf_add_ino_nolock(wbuf, inode2->i_ino);
+	}
+	release_head(c, BASEHD);
+	if (err)
+		goto out_ro;
+
+	ino_key_init(c, &key, inode1->i_ino);
+	err = ubifs_tnc_add(c, &key, lnum, offs, len1);
+	if (err)
+		goto out_ro;
+
+	ino_key_init(c, &key, inode2->i_ino);
+	err = ubifs_tnc_add(c, &key, lnum, offs + aligned_len1, len2);
+	if (err)
+		goto out_ro;
+
+	finish_reservation(c);
+	kfree(ino);
+	return 0;
+
+out_ro:
+	ubifs_ro_mode(c, err);
+	finish_reservation(c);
+out_free:
+	kfree(ino);
+	return err;
+}
+
+#endif /* CONFIG_UBIFS_FS_XATTR */
diff --git a/fs/ubifs/log.c b/fs/ubifs/log.c
new file mode 100644
index 0000000..da0f70c
--- /dev/null
+++ b/fs/ubifs/log.c
@@ -0,0 +1,799 @@
+/*
+ * This file is part of UBIFS.
+ *
+ * Copyright (C) 2006-2008 Nokia Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ * Authors: Artem Bityutskiy (Битюцкий Артём)
+ *          Adrian Hunter
+ */
+
+/*
+ * This file is a part of UBIFS journal implementation and contains various
+ * functions which manipulate the log. The log is a fixed area on the flash
+ * which does not contain any data but refers to buds. The log is a part of the
+ * journal.
+ */
+
+#include "ubifs.h"
+
+#ifdef CONFIG_UBIFS_FS_DEBUG
+static int dbg_check_bud_bytes(struct ubifs_info *c);
+#else
+#define dbg_check_bud_bytes(c) 0
+#endif
+
+/**
+ * ubifs_search_bud - search bud LEB.
+ * @c: UBIFS file-system description object
+ * @lnum: logical eraseblock number to search
+ *
+ * This function searches bud LEB @lnum. Returns bud description object in case
+ * of success and %NULL if there is no bud with this LEB number.
+ */
+struct ubifs_bud *ubifs_search_bud(struct ubifs_info *c, int lnum)
+{
+	struct rb_node *p;
+	struct ubifs_bud *bud;
+
+	spin_lock(&c->buds_lock);
+	p = c->buds.rb_node;
+	while (p) {
+		bud = rb_entry(p, struct ubifs_bud, rb);
+		if (lnum < bud->lnum)
+			p = p->rb_left;
+		else if (lnum > bud->lnum)
+			p = p->rb_right;
+		else {
+			spin_unlock(&c->buds_lock);
+			return bud;
+		}
+	}
+	spin_unlock(&c->buds_lock);
+	return NULL;
+}
+
+/**
+ * ubifs_get_wbuf - get the wbuf associated with a LEB, if there is one.
+ * @c: UBIFS file-system description object
+ * @lnum: logical eraseblock number to search
+ *
+ * This functions returns the wbuf for @lnum or %NULL if there is not one.
+ */
+struct ubifs_wbuf *ubifs_get_wbuf(struct ubifs_info *c, int lnum)
+{
+	struct rb_node *p;
+	struct ubifs_bud *bud;
+	int jhead;
+
+	if (!c->jheads)
+		return NULL;
+
+	spin_lock(&c->buds_lock);
+	p = c->buds.rb_node;
+	while (p) {
+		bud = rb_entry(p, struct ubifs_bud, rb);
+		if (lnum < bud->lnum)
+			p = p->rb_left;
+		else if (lnum > bud->lnum)
+			p = p->rb_right;
+		else {
+			jhead = bud->jhead;
+			spin_unlock(&c->buds_lock);
+			return &c->jheads[jhead].wbuf;
+		}
+	}
+	spin_unlock(&c->buds_lock);
+	return NULL;
+}
+
+/**
+ * next_log_lnum - switch to the next log LEB.
+ * @c: UBIFS file-system description object
+ * @lnum: current log LEB
+ */
+static inline int next_log_lnum(const struct ubifs_info *c, int lnum)
+{
+	lnum += 1;
+	if (lnum > c->log_last)
+		lnum = UBIFS_LOG_LNUM;
+
+	return lnum;
+}
+
+/**
+ * empty_log_bytes - calculate amount of empty space in the log.
+ * @c: UBIFS file-system description object
+ */
+static inline long long empty_log_bytes(const struct ubifs_info *c)
+{
+	long long h, t;
+
+	h = c->lhead_lnum * c->leb_size + c->lhead_offs;
+	t = c->ltail_lnum * c->leb_size;
+
+	if (h >= t)
+		return c->log_bytes - h + t;
+	else
+		return t - h;
+}
+
+/**
+ * ubifs_add_bud - add bud LEB to the tree of buds and its journal head list.
+ * @c: UBIFS file-system description object
+ * @bud: the bud to add
+ */
+void ubifs_add_bud(struct ubifs_info *c, struct ubifs_bud *bud)
+{
+	struct rb_node **p, *parent = NULL;
+	struct ubifs_bud *b;
+	struct ubifs_jhead *jhead;
+
+	spin_lock(&c->buds_lock);
+	p = &c->buds.rb_node;
+	while (*p) {
+		parent = *p;
+		b = rb_entry(parent, struct ubifs_bud, rb);
+		ubifs_assert(bud->lnum != b->lnum);
+		if (bud->lnum < b->lnum)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&bud->rb, parent, p);
+	rb_insert_color(&bud->rb, &c->buds);
+	if (c->jheads) {
+		jhead = &c->jheads[bud->jhead];
+		list_add_tail(&bud->list, &jhead->buds_list);
+	} else
+		ubifs_assert(c->replaying && (c->vfs_sb->s_flags & MS_RDONLY));
+
+	/*
+	 * Note, although this is a new bud, we anyway account this space now,
+	 * before any data has been written to it, because this is about to
+	 * guarantee fixed mount time, and this bud will anyway be read and
+	 * scanned.
+	 */
+	c->bud_bytes += c->leb_size - bud->start;
+
+	dbg_log("LEB %d:%d, jhead %d, bud_bytes %lld", bud->lnum,
+		bud->start, bud->jhead, c->bud_bytes);
+	spin_unlock(&c->buds_lock);
+}
+
+/**
+ * ubifs_create_buds_lists - create journal head buds lists for remount rw.
+ * @c: UBIFS file-system description object
+ */
+void ubifs_create_buds_lists(struct ubifs_info *c)
+{
+	struct rb_node *p;
+
+	spin_lock(&c->buds_lock);
+	p = rb_first(&c->buds);
+	while (p) {
+		struct ubifs_bud *bud = rb_entry(p, struct ubifs_bud, rb);
+		struct ubifs_jhead *jhead = &c->jheads[bud->jhead];
+
+		list_add_tail(&bud->list, &jhead->buds_list);
+		p = rb_next(p);
+	}
+	spin_unlock(&c->buds_lock);
+}
+
+/**
+ * ubifs_add_bud_to_log - add a new bud to the log.
+ * @c: UBIFS file-system description object
+ * @jhead: journal head the bud belongs to
+ * @lnum: LEB number of the bud
+ * @offs: starting offset of the bud
+ *
+ * This function writes reference node for the new bud LEB @lnum it to the log,
+ * and adds it to the buds tress. It also makes sure that log size does not
+ * exceed the 'c->max_bud_bytes' limit. Returns zero in case of success,
+ * %-EAGAIN if commit is required, and a negative error codes in case of
+ * failure.
+ */
+int ubifs_add_bud_to_log(struct ubifs_info *c, int jhead, int lnum, int offs)
+{
+	int err;
+	struct ubifs_bud *bud;
+	struct ubifs_ref_node *ref;
+
+	bud = kmalloc(sizeof(struct ubifs_bud), GFP_NOFS);
+	if (!bud)
+		return -ENOMEM;
+	ref = kzalloc(c->ref_node_alsz, GFP_NOFS);
+	if (!ref) {
+		kfree(bud);
+		return -ENOMEM;
+	}
+
+	mutex_lock(&c->log_mutex);
+	/* Make sure we have enough space in the log */
+	if (empty_log_bytes(c) - c->ref_node_alsz < c->min_log_bytes) {
+		dbg_log("not enough log space - %lld, required %d",
+			empty_log_bytes(c), c->min_log_bytes);
+		ubifs_commit_required(c);
+		err = -EAGAIN;
+		goto out_unlock;
+	}
+
+	/*
+	 * Make sure the the amount of space in buds will not exceed
+	 * 'c->max_bud_bytes' limit, because we want to guarantee mount time
+	 * limits.
+	 *
+	 * It is not necessary to hold @c->buds_lock when reading @c->bud_bytes
+	 * because we are holding @c->log_mutex. All @c->bud_bytes take place
+	 * when both @c->log_mutex and @c->bud_bytes are locked.
+	 */
+	if (c->bud_bytes + c->leb_size - offs > c->max_bud_bytes) {
+		dbg_log("bud bytes %lld (%lld max), require commit",
+			c->bud_bytes, c->max_bud_bytes);
+		ubifs_commit_required(c);
+		err = -EAGAIN;
+		goto out_unlock;
+	}
+
+	/*
+	 * If the journal is full enough - start background commit. Note, it is
+	 * OK to read 'c->cmt_state' without spinlock because integer reads
+	 * are atomic in the kernel.
+	 */
+	if (c->bud_bytes >= c->bg_bud_bytes &&
+	    c->cmt_state == COMMIT_RESTING) {
+		dbg_log("bud bytes %lld (%lld max), initiate BG commit",
+			c->bud_bytes, c->max_bud_bytes);
+		ubifs_request_bg_commit(c);
+	}
+
+	bud->lnum = lnum;
+	bud->start = offs;
+	bud->jhead = jhead;
+
+	ref->ch.node_type = UBIFS_REF_NODE;
+	ref->lnum = cpu_to_le32(bud->lnum);
+	ref->offs = cpu_to_le32(bud->start);
+	ref->jhead = cpu_to_le32(jhead);
+
+	if (c->lhead_offs > c->leb_size - c->ref_node_alsz) {
+		c->lhead_lnum = next_log_lnum(c, c->lhead_lnum);
+		c->lhead_offs = 0;
+	}
+
+	if (c->lhead_offs == 0) {
+		/* Must ensure next log LEB has been unmapped */
+		err = ubifs_leb_unmap(c, c->lhead_lnum);
+		if (err)
+			goto out_unlock;
+	}
+
+	if (bud->start == 0) {
+		/*
+		 * Before writing the LEB reference which refers an empty LEB
+		 * to the log, we have to make sure it is mapped, because
+		 * otherwise we'd risk to refer an LEB with garbage in case of
+		 * an unclean reboot, because the target LEB might have been
+		 * unmapped, but not yet physically erased.
+		 */
+		err = ubi_leb_map(c->ubi, bud->lnum, UBI_SHORTTERM);
+		if (err)
+			goto out_unlock;
+	}
+
+	dbg_log("write ref LEB %d:%d",
+		c->lhead_lnum, c->lhead_offs);
+	err = ubifs_write_node(c, ref, UBIFS_REF_NODE_SZ, c->lhead_lnum,
+			       c->lhead_offs, UBI_SHORTTERM);
+	c->lhead_offs += c->ref_node_alsz;
+	if (err)
+		goto out_unlock;
+
+	ubifs_add_bud(c, bud);
+
+	mutex_unlock(&c->log_mutex);
+	kfree(ref);
+	return 0;
+
+out_unlock:
+	mutex_unlock(&c->log_mutex);
+	kfree(ref);
+	kfree(bud);
+	return err;
+}
+
+/**
+ * remove_buds - remove used buds.
+ * @c: UBIFS file-system description object
+ *
+ * This function removes use buds from the buds tree. It does not remove the
+ * buds which are pointed to by journal heads.
+ */
+static void remove_buds(struct ubifs_info *c)
+{
+	struct rb_node *p;
+
+	ubifs_assert(list_empty(&c->old_buds));
+	c->cmt_bud_bytes = 0;
+	spin_lock(&c->buds_lock);
+	p = rb_first(&c->buds);
+	while (p) {
+		struct rb_node *p1 = p;
+		struct ubifs_bud *bud;
+		struct ubifs_wbuf *wbuf;
+
+		p = rb_next(p);
+		bud = rb_entry(p1, struct ubifs_bud, rb);
+		wbuf = &c->jheads[bud->jhead].wbuf;
+
+		if (wbuf->lnum == bud->lnum) {
+			/*
+			 * Do not remove buds which are pointed to by journal
+			 * heads (non-closed buds).
+			 */
+			c->cmt_bud_bytes += wbuf->offs - bud->start;
+			dbg_log("preserve %d:%d, jhead %d, bud bytes %d, "
+				"cmt_bud_bytes %lld", bud->lnum, bud->start,
+				bud->jhead, wbuf->offs - bud->start,
+				c->cmt_bud_bytes);
+			bud->start = wbuf->offs;
+		} else {
+			c->cmt_bud_bytes += c->leb_size - bud->start;
+			dbg_log("remove %d:%d, jhead %d, bud bytes %d, "
+				"cmt_bud_bytes %lld", bud->lnum, bud->start,
+				bud->jhead, c->leb_size - bud->start,
+				c->cmt_bud_bytes);
+			rb_erase(p1, &c->buds);
+			list_del(&bud->list);
+			/*
+			 * If the commit does not finish, the recovery will need
+			 * to replay the journal, in which case the old buds
+			 * must be unchanged. Do not release them until post
+			 * commit i.e. do not allow them to be garbage
+			 * collected.
+			 */
+			list_add(&bud->list, &c->old_buds);
+		}
+	}
+	spin_unlock(&c->buds_lock);
+}
+
+/**
+ * ubifs_log_start_commit - start commit.
+ * @c: UBIFS file-system description object
+ * @ltail_lnum: return new log tail LEB number
+ *
+ * The commit operation starts with writing "commit start" node to the log and
+ * reference nodes for all journal heads which will define new journal after
+ * the commit has been finished. The commit start and reference nodes are
+ * written in one go to the nearest empty log LEB (hence, when commit is
+ * finished UBIFS may safely unmap all the previous log LEBs). This function
+ * returns zero in case of success and a negative error code in case of
+ * failure.
+ */
+int ubifs_log_start_commit(struct ubifs_info *c, int *ltail_lnum)
+{
+	void *buf;
+	struct ubifs_cs_node *cs;
+	struct ubifs_ref_node *ref;
+	int err, i, max_len, len;
+
+	err = dbg_check_bud_bytes(c);
+	if (err)
+		return err;
+
+	max_len = UBIFS_CS_NODE_SZ + c->jhead_cnt * UBIFS_REF_NODE_SZ;
+	max_len = ALIGN(max_len, c->min_io_size);
+	buf = cs = kmalloc(max_len, GFP_NOFS);
+	if (!buf)
+		return -ENOMEM;
+
+	cs->ch.node_type = UBIFS_CS_NODE;
+	cs->cmt_no = cpu_to_le64(c->cmt_no + 1);
+	ubifs_prepare_node(c, cs, UBIFS_CS_NODE_SZ, 0);
+
+	/*
+	 * Note, we do not lock 'c->log_mutex' because this is the commit start
+	 * phase and we are exclusively using the log. And we do not lock
+	 * write-buffer because nobody can write to the file-system at this
+	 * phase.
+	 */
+
+	len = UBIFS_CS_NODE_SZ;
+	for (i = 0; i < c->jhead_cnt; i++) {
+		int lnum = c->jheads[i].wbuf.lnum;
+		int offs = c->jheads[i].wbuf.offs;
+
+		if (lnum == -1 || offs == c->leb_size)
+			continue;
+
+		dbg_log("add ref to LEB %d:%d for jhead %d", lnum, offs, i);
+		ref = buf + len;
+		ref->ch.node_type = UBIFS_REF_NODE;
+		ref->lnum = cpu_to_le32(lnum);
+		ref->offs = cpu_to_le32(offs);
+		ref->jhead = cpu_to_le32(i);
+
+		ubifs_prepare_node(c, ref, UBIFS_REF_NODE_SZ, 0);
+		len += UBIFS_REF_NODE_SZ;
+	}
+
+	ubifs_pad(c, buf + len, ALIGN(len, c->min_io_size) - len);
+
+	/* Switch to the next log LEB */
+	if (c->lhead_offs) {
+		c->lhead_lnum = next_log_lnum(c, c->lhead_lnum);
+		c->lhead_offs = 0;
+	}
+
+	if (c->lhead_offs == 0) {
+		/* Must ensure next LEB has been unmapped */
+		err = ubifs_leb_unmap(c, c->lhead_lnum);
+		if (err)
+			goto out;
+	}
+
+	len = ALIGN(len, c->min_io_size);
+	dbg_log("writing commit start at LEB %d:0, len %d", c->lhead_lnum, len);
+	err = ubifs_leb_write(c, c->lhead_lnum, cs, 0, len, UBI_SHORTTERM);
+	if (err)
+		goto out;
+
+	*ltail_lnum = c->lhead_lnum;
+
+	c->lhead_offs += len;
+	if (c->lhead_offs == c->leb_size) {
+		c->lhead_lnum = next_log_lnum(c, c->lhead_lnum);
+		c->lhead_offs = 0;
+	}
+
+	remove_buds(c);
+
+	/*
+	 * We have started the commit and now users may use the rest of the log
+	 * for new writes.
+	 */
+	c->min_log_bytes = 0;
+
+out:
+	kfree(buf);
+	return err;
+}
+
+/**
+ * ubifs_log_end_commit - end commit.
+ * @c: UBIFS file-system description object
+ * @ltail_lnum: new log tail LEB number
+ *
+ * This function is called on when the commit operation was finished. It
+ * moves log tail to new position and unmaps LEBs which contain obsolete data.
+ * Returns zero in case of success and a negative error code in case of
+ * failure.
+ */
+int ubifs_log_end_commit(struct ubifs_info *c, int ltail_lnum)
+{
+	int err;
+
+	/*
+	 * At this phase we have to lock 'c->log_mutex' because UBIFS allows FS
+	 * writes during commit. Its only short "commit" start phase when
+	 * writers are blocked.
+	 */
+	mutex_lock(&c->log_mutex);
+
+	dbg_log("old tail was LEB %d:0, new tail is LEB %d:0",
+		c->ltail_lnum, ltail_lnum);
+
+	c->ltail_lnum = ltail_lnum;
+	/*
+	 * The commit is finished and from now on it must be guaranteed that
+	 * there is always enough space for the next commit.
+	 */
+	c->min_log_bytes = c->leb_size;
+
+	spin_lock(&c->buds_lock);
+	c->bud_bytes -= c->cmt_bud_bytes;
+	spin_unlock(&c->buds_lock);
+
+	err = dbg_check_bud_bytes(c);
+
+	mutex_unlock(&c->log_mutex);
+	return err;
+}
+
+/**
+ * ubifs_log_post_commit - things to do after commit is completed.
+ * @c: UBIFS file-system description object
+ * @old_ltail_lnum: old log tail LEB number
+ *
+ * Release buds only after commit is completed, because they must be unchanged
+ * if recovery is needed.
+ *
+ * Unmap log LEBs only after commit is completed, because they may be needed for
+ * recovery.
+ *
+ * This function returns %0 on success and a negative error code on failure.
+ */
+int ubifs_log_post_commit(struct ubifs_info *c, int old_ltail_lnum)
+{
+	int lnum, err = 0;
+
+	while (!list_empty(&c->old_buds)) {
+		struct ubifs_bud *bud;
+
+		bud = list_entry(c->old_buds.next, struct ubifs_bud, list);
+		err = ubifs_return_leb(c, bud->lnum);
+		if (err)
+			return err;
+		list_del(&bud->list);
+		kfree(bud);
+	}
+	mutex_lock(&c->log_mutex);
+	for (lnum = old_ltail_lnum; lnum != c->ltail_lnum;
+	     lnum = next_log_lnum(c, lnum)) {
+		dbg_log("unmap log LEB %d", lnum);
+		err = ubifs_leb_unmap(c, lnum);
+		if (err)
+			goto out;
+	}
+out:
+	mutex_unlock(&c->log_mutex);
+	return err;
+}
+
+/**
+ * struct done_ref - references that have been done.
+ * @rb: rb-tree node
+ * @lnum: LEB number
+ */
+struct done_ref {
+	struct rb_node rb;
+	int lnum;
+};
+
+/**
+ * done_already - determine if a reference has been done already.
+ * @done_tree: rb-tree to store references that have been done
+ * @lnum: LEB number of reference
+ *
+ * This function returns %1 if the reference has been done, %0 if not, otherwise
+ * a negative error code is returned.
+ */
+static int done_already(struct rb_root *done_tree, int lnum)
+{
+	struct rb_node **p = &done_tree->rb_node, *parent = NULL;
+	struct done_ref *dr;
+
+	while (*p) {
+		parent = *p;
+		dr = rb_entry(parent, struct done_ref, rb);
+		if (lnum < dr->lnum)
+			p = &(*p)->rb_left;
+		else if (lnum > dr->lnum)
+			p = &(*p)->rb_right;
+		else
+			return 1;
+	}
+
+	dr = kzalloc(sizeof(struct done_ref), GFP_NOFS);
+	if (!dr)
+		return -ENOMEM;
+
+	dr->lnum = lnum;
+
+	rb_link_node(&dr->rb, parent, p);
+	rb_insert_color(&dr->rb, done_tree);
+
+	return 0;
+}
+
+/**
+ * destroy_done_tree - destroy the done tree.
+ * @done_tree: done tree to destroy
+ */
+static void destroy_done_tree(struct rb_root *done_tree)
+{
+	struct rb_node *this = done_tree->rb_node;
+	struct done_ref *dr;
+
+	while (this) {
+		if (this->rb_left) {
+			this = this->rb_left;
+			continue;
+		} else if (this->rb_right) {
+			this = this->rb_right;
+			continue;
+		}
+		dr = rb_entry(this, struct done_ref, rb);
+		this = rb_parent(this);
+		if (this) {
+			if (this->rb_left == &dr->rb)
+				this->rb_left = NULL;
+			else
+				this->rb_right = NULL;
+		}
+		kfree(dr);
+	}
+}
+
+/**
+ * add_node - add a node to the consolidated log.
+ * @c: UBIFS file-system description object
+ * @buf: buffer to which to add
+ * @lnum: LEB number to which to write is passed and returned here
+ * @offs: offset to where to write is passed and returned here
+ * @node: node to add
+ *
+ * This function returns %0 on success and a negative error code on failure.
+ */
+static int add_node(struct ubifs_info *c, void *buf, int *lnum, int *offs,
+		    void *node)
+{
+	struct ubifs_ch *ch = node;
+	int len = le32_to_cpu(ch->len), remains = c->leb_size - *offs;
+
+	if (len > remains) {
+		int sz = ALIGN(*offs, c->min_io_size), err;
+
+		ubifs_pad(c, buf + *offs, sz - *offs);
+		err = ubi_leb_change(c->ubi, *lnum, buf, sz, UBI_SHORTTERM);
+		if (err)
+			return err;
+		*lnum = next_log_lnum(c, *lnum);
+		*offs = 0;
+	}
+	memcpy(buf + *offs, node, len);
+	*offs += ALIGN(len, 8);
+	return 0;
+}
+
+/**
+ * ubifs_consolidate_log - consolidate the log.
+ * @c: UBIFS file-system description object
+ *
+ * Repeated failed commits could cause the log to be full, but at least 1 LEB is
+ * needed for commit. This function rewrites the reference nodes in the log
+ * omitting duplicates, and failed CS nodes, and leaving no gaps.
+ *
+ * This function returns %0 on success and a negative error code on failure.
+ */
+int ubifs_consolidate_log(struct ubifs_info *c)
+{
+	struct ubifs_scan_leb *sleb;
+	struct ubifs_scan_node *snod;
+	struct rb_root done_tree = RB_ROOT;
+	int lnum, err, first = 1, write_lnum, offs = 0;
+	void *buf;
+
+	dbg_rcvry("log tail LEB %d, log head LEB %d", c->ltail_lnum,
+		  c->lhead_lnum);
+	buf = vmalloc(c->leb_size);
+	if (!buf)
+		return -ENOMEM;
+	lnum = c->ltail_lnum;
+	write_lnum = lnum;
+	while (1) {
+		sleb = ubifs_scan(c, lnum, 0, c->sbuf);
+		if (IS_ERR(sleb)) {
+			err = PTR_ERR(sleb);
+			goto out_free;
+		}
+		list_for_each_entry(snod, &sleb->nodes, list) {
+			switch (snod->type) {
+			case UBIFS_REF_NODE: {
+				struct ubifs_ref_node *ref = snod->node;
+				int ref_lnum = le32_to_cpu(ref->lnum);
+
+				err = done_already(&done_tree, ref_lnum);
+				if (err < 0)
+					goto out_scan;
+				if (err != 1) {
+					err = add_node(c, buf, &write_lnum,
+						       &offs, snod->node);
+					if (err)
+						goto out_scan;
+				}
+				break;
+			}
+			case UBIFS_CS_NODE:
+				if (!first)
+					break;
+				err = add_node(c, buf, &write_lnum, &offs,
+					       snod->node);
+				if (err)
+					goto out_scan;
+				first = 0;
+				break;
+			}
+		}
+		ubifs_scan_destroy(sleb);
+		if (lnum == c->lhead_lnum)
+			break;
+		lnum = next_log_lnum(c, lnum);
+	}
+	if (offs) {
+		int sz = ALIGN(offs, c->min_io_size);
+
+		ubifs_pad(c, buf + offs, sz - offs);
+		err = ubi_leb_change(c->ubi, write_lnum, buf, sz,
+				     UBI_SHORTTERM);
+		if (err)
+			goto out_free;
+		offs = ALIGN(offs, c->min_io_size);
+	}
+	destroy_done_tree(&done_tree);
+	vfree(buf);
+	if (write_lnum == c->lhead_lnum) {
+		ubifs_err("log is too full");
+		return -EINVAL;
+	}
+	/* Unmap remaining LEBs */
+	lnum = write_lnum;
+	do {
+		lnum = next_log_lnum(c, lnum);
+		err = ubifs_leb_unmap(c, lnum);
+		if (err)
+			return err;
+	} while (lnum != c->lhead_lnum);
+	c->lhead_lnum = write_lnum;
+	c->lhead_offs = offs;
+	dbg_rcvry("new log head at %d:%d", c->lhead_lnum, c->lhead_offs);
+	return 0;
+
+out_scan:
+	ubifs_scan_destroy(sleb);
+out_free:
+	destroy_done_tree(&done_tree);
+	vfree(buf);
+	return err;
+}
+
+#ifdef CONFIG_UBIFS_FS_DEBUG
+
+/**
+ * dbg_check_bud_bytes - make sure bud bytes calculation are all right.
+ * @c: UBIFS file-system description object
+ *
+ * This function makes sure the amount of flash space used by closed buds
+ * ('c->bud_bytes' is correct). Returns zero in case of success and %-EINVAL in
+ * case of failure.
+ */
+static int dbg_check_bud_bytes(struct ubifs_info *c)
+{
+	int i, err = 0;
+	struct ubifs_bud *bud;
+	long long bud_bytes = 0;
+
+	if (!(ubifs_chk_flags & UBIFS_CHK_GEN))
+		return 0;
+
+	spin_lock(&c->buds_lock);
+	for (i = 0; i < c->jhead_cnt; i++)
+		list_for_each_entry(bud, &c->jheads[i].buds_list, list)
+			bud_bytes += c->leb_size - bud->start;
+
+	if (c->bud_bytes != bud_bytes) {
+		ubifs_err("bad bud_bytes %lld, calculated %lld",
+			  c->bud_bytes, bud_bytes);
+		err = -EINVAL;
+	}
+	spin_unlock(&c->buds_lock);
+
+	return err;
+}
+
+#endif /* CONFIG_UBIFS_FS_DEBUG */
-- 
1.5.4.1

