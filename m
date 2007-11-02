Return-Path: <linux-kernel-owner+w=401wt.eu-S1761023AbXKBRLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761023AbXKBRLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760900AbXKBRLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:11:07 -0400
Received: from 71-33-33-68.albq.qwest.net ([71.33.33.68]:39896 "EHLO
	moria.ionkov.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760882AbXKBRLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:11:03 -0400
Date: Fri, 2 Nov 2007 11:11:00 -0600
From: Latchesar Ionkov <lucho@ionkov.net>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][REFERENCE ONLY] 9p: ramfs 9p server
Message-ID: <20071102171100.GL16063@ionkov.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sample ramfs file server that uses the in-kernel 9P file server support.
This code is for reference only.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
 net/9p/Kconfig       |    8 +-
 net/9p/Makefile      |    1 +
 net/9p/ramfs/ramfs.c |  986 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 994 insertions(+), 1 deletions(-)

diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index 5b0dc28..68f7496 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -23,11 +23,17 @@ config NET_9P_FD
 	  file descriptors.  TCP/IP is the default transport for 9p,
 	  so if you are going to use 9p, you'll likely want this.
 
-config NET_9P_SRV
+menuconfig NET_9P_SRV
 	tristate "9P server support"
 	depends on NET_9P
 	help
 	  Say Y if you want the 9P server support
+
+config NET_9P_RAMFS
+        tristate "9P ramfs sample file server"
+        depends on NET_9P_SRV && NET_9P_LOOP
+        help
+          Say Y if you want the 9P ramfs support
 config NET_9P_VIRTIO
 	depends on NET_9P && EXPERIMENTAL && VIRTIO
 	tristate "9P Virtio Transport (Experimental)"
diff --git a/net/9p/Makefile b/net/9p/Makefile
index 6ee024e..3808c40 100644
--- a/net/9p/Makefile
+++ b/net/9p/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_NET_9P_FD) += 9pnet_fd.o
 obj-$(CONFIG_NET_9P_LOOP) += 9pnet_loop.o
 obj-$(CONFIG_NET_9P_SRV) += 9psrv.o
 obj-$(CONFIG_NET_9P_VIRTIO) += 9pnet_virtio.o
+obj-$(CONFIG_NET_9P_RAMFS) += ramfs/
 
 9pnet-objs := \
 	mod.o \
diff --git a/net/9p/ramfs/ramfs.c b/net/9p/ramfs/ramfs.c
new file mode 100644
index 0000000..3aff620
--- /dev/null
+++ b/net/9p/ramfs/ramfs.c
@@ -0,0 +1,986 @@
+/*
+ * net/9p/srv/ramfs.c
+ *
+ * Simple RAM filesystem
+ *
+ *  Copyright (C) 2007 by Latchesar Ionkov <lucho@ionkov.net>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/parser.h>
+#include <net/9p/9p.h>
+#include <net/9p/transport.h>
+#include <net/9p/srv.h>
+
+#define ROOTPERM 	0777
+
+struct ramfs_file {
+	struct mutex		lock;		/* file lock */
+	atomic_t		refcount;
+	unsigned long		status;
+	char			*name;
+	u32			perm;
+	u64			length;
+	u32			atime;
+	u32			mtime;
+	u32			uid;
+	u32			gid;
+	u32			muid;
+	char			*extension;
+	struct p9_qid		qid;
+	int 			excl;
+
+	struct ramfs_file	*parent;
+	struct ramfs_file	*next;		/* protected by parent lock */
+	struct ramfs_file	*prev;
+
+	struct ramfs_file	*dirents;	/* if directory */
+	struct ramfs_file	*dirlast;
+
+	struct list_head	fid_list;	/* all fids for a file */
+
+	u8			*data;
+	u64			datasize;
+};
+
+struct ramfs_fid {
+	struct ramfs_file	*file;
+	int			omode;
+	u64			diroffset;
+	struct ramfs_file	*dirent;
+	struct list_head	fid_list;	/* all fids for a file */
+};
+
+enum {
+	Removed = 1,
+};
+
+static struct p9srv_type *ramfs_srv_type;
+static struct ramfs_file *root;
+static u64 qidpath;
+static int blksize = 8192;
+
+static char *Enospace = "no space left";
+static char *Einternal = "internal error";
+
+static void ramfs_attach(struct p9srv_req *req);
+static void ramfs_walk(struct p9srv_req *req);
+static void ramfs_open(struct p9srv_req *req);
+static void ramfs_create(struct p9srv_req *req);
+static void ramfs_read(struct p9srv_req *req);
+static void ramfs_write(struct p9srv_req *req);
+static void ramfs_clunk(struct p9srv_req *req);
+static void ramfs_remove(struct p9srv_req *req);
+static void ramfs_stat(struct p9srv_req *req);
+static void ramfs_wstat(struct p9srv_req *req);
+static void ramfs_fiddestroy(struct p9srv_fid *fid);
+static void ramfs_connopen(struct p9srv_conn *conn);
+static void ramfs_connclose(struct p9srv_conn *conn);
+
+static char *p9_strdup(struct p9_str *str)
+{
+	char *ret;
+
+	ret = kmalloc(str->len + 1, GFP_KERNEL);
+	memmove(ret, str->str, str->len);
+	ret[str->len] = '\0';
+
+	return ret;
+}
+
+static void file_incref(struct ramfs_file *f)
+{
+	if (!f)
+		return;
+
+	atomic_inc(&f->refcount);
+	P9_DPRINTK(P9SRV_DEBUG_FS, "file %p %s count %d\n", f, f->name,
+		atomic_read(&f->refcount));
+}
+
+static void file_decrefimpl(struct ramfs_file *f, int lock)
+{
+	int n;
+
+	if (!f)
+		return;
+
+	n = atomic_dec_and_test(&f->refcount);
+	P9_DPRINTK(P9SRV_DEBUG_FS, "file %p %s count %d\n", f, f->name,
+		atomic_read(&f->refcount));
+	if (n) {
+		P9_DPRINTK(P9SRV_DEBUG_FS, "file %p %s destroy\n", f, f->name);
+		if (lock)
+			mutex_lock(&f->lock);
+
+		kfree(f->name);
+		kfree(f->extension);
+		kfree(f->data);
+		if (lock)
+			mutex_unlock(&f->lock);
+		kfree(f);
+	}
+}
+
+static void file_decref0(struct ramfs_file *f)
+{
+	return file_decrefimpl(f, 0);
+}
+
+static void file_decref(struct ramfs_file *f)
+{
+	return file_decrefimpl(f, 1);
+}
+
+static int file_truncate(struct ramfs_file *f, u32 size)
+{
+	int n;
+	u8 *buf;
+
+	if (size == 0) {
+		kfree(f->data);
+		f->data = NULL;
+		f->datasize = 0;
+		return 0;
+	}
+
+	n = (size/blksize + (size%blksize?1:0)) * blksize;
+	if (n <= f->datasize)
+		return 0;
+
+	buf = kmalloc(n, GFP_KERNEL);
+	if (!buf)
+		return -1;
+
+	memmove(buf, f->data, f->length);
+	kfree(f->data);
+	f->data = buf;
+	f->datasize = n;
+	return 0;
+}
+
+static struct ramfs_file *
+find_file(struct ramfs_file *dir, char *name, int lock)
+{
+	struct ramfs_file *ret;
+	struct ramfs_file *f;
+
+	if (strcmp(name, "..") == 0)
+		return dir->parent;
+
+	ret = NULL;
+	if (lock)
+		mutex_lock(&dir->lock);
+
+	for (f = dir->dirents; f != NULL; f = f->next) {
+		P9_DPRINTK(P9SRV_DEBUG_FS, "dir %p '%s' child %p '%s'\n", dir,
+			dir->name, f, f->name);
+
+		if (strcmp(name, f->name) == 0) {
+			ret = f;
+			file_incref(f);
+			break;
+		}
+	}
+
+	if (lock)
+		mutex_unlock(&dir->lock);
+
+	return ret;
+}
+
+static int check_perm(struct p9srv_req *req, struct ramfs_file *dir,
+	u32 uid, int perm)
+{
+	int n;
+
+	if (!perm)
+		return 1;
+
+	n = dir->perm & 7;
+	if (dir->uid == uid) {
+		n |= (dir->perm >> 6) & 7;
+		n |= (dir->perm >> 3) & 7;
+	}
+
+	if (!(n & perm)) {
+		p9srv_respond_error(req, Eperm, EPERM);
+		return 0;
+	}
+
+	return 1;
+}
+
+/* called holding parent lock, if parent != NULL */
+static struct ramfs_file *file_create(struct ramfs_file *parent, char *name,
+	int perm, u32 uid, u32 gid)
+{
+	struct ramfs_file *file;
+
+	file = kmalloc(sizeof(*file), GFP_KERNEL);
+	mutex_init(&file->lock);
+	atomic_set(&file->refcount, 1);
+	file->status = 0;
+	file->name = name;
+	file->perm = perm;
+	file->length = 0;
+	file->atime = 0;
+	file->mtime = 0;
+	file->uid = uid;
+	file->gid = gid;
+	file->muid = uid;
+	file->extension = NULL;
+	file->excl = 0;
+
+	file->parent = parent;
+	file->next = NULL;
+	file->prev = NULL;
+	file->dirents = NULL;
+	file->dirlast = NULL;
+	file->data = NULL;
+	file->datasize = 0;
+	file_truncate(file, 0);
+	file->qid.type = perm >> 24;
+	file->qid.version = 0;
+	file->qid.path = qidpath++;
+	INIT_LIST_HEAD(&file->fid_list);
+
+	if (parent) {
+		if (parent->dirlast) {
+			parent->dirlast->next = file;
+			file->prev = parent->dirlast;
+		} else
+			parent->dirents = file;
+
+		parent->dirlast = file;
+		parent->muid = uid;
+/*		parent->mtime = time(NULL); */
+		parent->qid.version++;
+		file_incref(parent);
+	}
+
+	P9_DPRINTK(P9SRV_DEBUG_FS, "file %p %s\n", file, file->name);
+	return file;
+}
+
+static void file2wstat(struct ramfs_file *f, struct p9_wstat *wstat)
+{
+	wstat->size = 0;
+	wstat->type = 0;
+	wstat->dev = 0;
+	wstat->qid = f->qid;
+	wstat->mode = f->perm;
+	wstat->atime = f->atime;
+	wstat->mtime = f->mtime;
+	wstat->length = f->length;
+	wstat->name = f->name;
+	wstat->uid = NULL;
+	wstat->gid = NULL;
+	wstat->muid = NULL;
+	wstat->extension = f->extension;
+	wstat->n_uid = f->uid;
+	wstat->n_gid = f->gid;
+	wstat->n_muid = f->muid;
+}
+
+static struct ramfs_fid *fid_alloc(struct ramfs_file *file)
+{
+	struct ramfs_fid *f;
+
+	f = kmalloc(sizeof(*f), GFP_KERNEL);
+	f->file = file;
+	file_incref(file);
+	f->omode = -1;
+	f->diroffset = 0;
+	f->dirent = NULL;
+	INIT_LIST_HEAD(&f->fid_list);
+
+	mutex_lock(&file->lock);
+	list_add_tail(&f->fid_list, &file->fid_list);
+	mutex_unlock(&file->lock);
+
+	P9_DPRINTK(P9SRV_DEBUG_FS, "fid %p file %s\n", f, file->name);
+	return f;
+}
+
+/* file is already incref-ed */
+static void fid_move(struct ramfs_fid *fid, struct ramfs_file *file)
+{
+	P9_DPRINTK(P9SRV_DEBUG_FS, "fid %p from %s to %s\n", fid,
+		fid->file->name, file->name);
+
+	mutex_lock(&fid->file->lock);
+	list_del(&fid->fid_list);
+	mutex_unlock(&fid->file->lock);
+	file_decref(fid->file);
+
+	fid->file = file;
+	mutex_lock(&fid->file->lock);
+	list_add(&fid->fid_list, &fid->file->fid_list);
+	mutex_unlock(&fid->file->lock);
+}
+
+static void ramfs_fiddestroy(struct p9srv_fid *fid)
+{
+	struct ramfs_fid *f;
+
+	f = fid->aux;
+	if (!f)
+		return;
+
+	mutex_lock(&f->file->lock);
+	list_del(&f->fid_list);
+	mutex_unlock(&f->file->lock);
+
+	file_decref(f->file);
+	file_decref(f->dirent);
+	kfree(f);
+}
+
+static void ramfs_attach(struct p9srv_req *req)
+{
+	int err;
+	struct ramfs_fid *fid;
+
+	if (req->afid != NULL) {
+		p9srv_respond_error(req, Enoauth, EIO);
+		return;
+	}
+
+	if (!check_perm(req, root, req->tcall->params.tattach.n_uname, 4))
+		return;
+
+	req->fid->uid = req->tcall->params.tattach.n_uname;
+	fid = fid_alloc(root);
+	req->fid->aux = fid;
+
+	err = p9_create_rattach(req->rcall, &fid->file->qid);
+	if (err < 0)
+		p9srv_respond_error(req, Einternal, err);
+	else
+		p9srv_respond(req, req->rcall);
+}
+
+static void ramfs_walk(struct p9srv_req *req)
+{
+	int i, err;
+	char *name;
+	struct ramfs_fid *fid, *nfid;
+	struct ramfs_file *nf;
+	struct p9_fcall *tc;
+	struct p9_qid wqids[P9_MAXWELEM];
+
+	P9_DPRINTK(P9SRV_DEBUG_FS, "fid %d nfid %d nwname %d\n", req->fid->fid,
+		req->newfid->fid, req->tcall->params.twalk.nwname);
+
+	if (req->fid != req->newfid) {
+		fid = req->fid->aux;
+		nfid = fid_alloc(fid->file);
+		req->newfid->aux = nfid;
+	}
+
+	tc = req->tcall;
+	if (tc->params.twalk.nwname == 0) {
+		i = 0;
+		goto done;
+	}
+
+	nfid = req->newfid->aux;
+	for (i = 0; i < tc->params.twalk.nwname; i++) {
+		name = p9_strdup(&tc->params.twalk.wnames[i]);
+		nf = find_file(nfid->file, name, 1);
+		kfree(name);
+		if (!nf)
+			break;
+
+		wqids[i] = nf->qid;
+		fid_move(nfid, nf);
+	}
+
+	if (i == 0) {
+		p9srv_respond_error(req, Enotfound, ENOENT);
+		return;
+	}
+
+done:
+	err = p9_create_rwalk(req->rcall, i, wqids);
+	if (err < 0)
+		p9srv_respond_error(req, Einternal, err);
+	else
+		p9srv_respond(req, req->rcall);
+}
+
+static void ramfs_open(struct p9srv_req *req)
+{
+	int m, mode, err;
+	struct ramfs_fid *fid;
+	struct ramfs_file *file;
+
+	err = 0;
+	fid = req->fid->aux;
+	mode = req->tcall->params.topen.mode;
+	m = 0;
+	switch (mode & 3) {
+	case P9_OREAD:
+		m = 4;
+		break;
+
+	case P9_OWRITE:
+		m = 2;
+		break;
+
+	case P9_ORDWR:
+		m = 6;
+		break;
+
+	case P9_OEXEC:
+		m = 1;
+		break;
+	}
+
+	if (mode & P9_OTRUNC)
+		m |= 2;
+
+	file = fid->file;
+	mutex_lock(&file->lock);
+	if (!check_perm(req, file, req->fid->uid, m))
+		goto done;
+
+	if (mode & P9_OTRUNC)
+		file_truncate(file, 0);
+
+	if (mode & P9_OEXCL) {
+		if (file->excl) {
+			p9srv_respond_error(req, Eopen, EPERM);
+			goto done;
+		}
+
+		file->excl = 1;
+	}
+
+	fid->omode = mode;
+	err = p9_create_ropen(req->rcall, &file->qid, 0);
+	if (err < 0)
+		p9srv_respond_error(req, Einternal, err);
+
+done:
+	mutex_unlock(&file->lock);
+	if (err >= 0)
+		p9srv_respond(req, req->rcall);
+}
+
+static void ramfs_create(struct p9srv_req *req)
+{
+	int mode, err;
+	u32 perm;
+	struct p9_fcall *tc;
+	struct ramfs_fid *fid;
+	struct ramfs_file *dir, *file, *nf;
+	char *sname;
+
+	err = 0;
+	tc = req->tcall;
+	perm = tc->params.tcreate.perm;
+	mode = tc->params.tcreate.mode;
+	sname = NULL;
+	file = NULL;
+
+	if (perm & P9_DMLINK) {
+		p9srv_respond_error(req, Eperm, EPERM);
+		goto done;
+	}
+
+	fid = req->fid->aux;
+	dir = fid->file;
+	sname = p9_strdup(&tc->params.tcreate.name);
+	P9_DPRINTK(P9SRV_DEBUG_FS, "name %s\n", sname);
+	if (!strcmp(sname, ".") || !strcmp(sname, "..")) {
+		p9srv_respond_error(req, Eexist, EEXIST);
+		goto done;
+	}
+
+	if (!check_perm(req, dir, req->fid->uid, 2))
+		goto done;
+
+	if (perm & P9_DMDIR)
+		perm &= ~0777 | (dir->perm & 0777);
+	else
+		perm &= ~0666 | (dir->perm & 0666);
+
+	mutex_lock(&dir->lock);
+	nf = find_file(dir, sname, 0);
+	if (nf) {
+		mutex_unlock(&dir->lock);
+		file_decref(nf);
+		p9srv_respond_error(req, Eexist, EEXIST);
+		goto done;
+	}
+
+	file = file_create(dir, sname, perm, dir->uid, 0);
+	mutex_unlock(&dir->lock);
+
+	fid->omode = mode;
+	file_incref(file);
+	fid_move(fid, file);
+	if (perm & (P9_DMNAMEDPIPE | P9_DMSYMLINK | P9_DMLINK | P9_DMDEVICE |
+		P9_DMSOCKET)) {
+
+		file->extension = p9_strdup(&tc->params.tcreate.extension);
+	} else {
+		if (mode & P9_OEXCL)
+			file->excl = 1;
+	}
+
+	P9_DPRINTK(P9SRV_DEBUG_FS, "file %p parent %p first child %p\n",
+		file, dir, dir->dirents);
+	err = p9_create_rcreate(req->rcall, &file->qid, 0);
+	if (err < 0)
+		p9srv_respond_error(req, Einternal, err);
+
+done:
+	if (!sname)
+		kfree(sname);
+
+	if (err >= 0)
+		p9srv_respond(req, req->rcall);
+}
+
+static void ramfs_read(struct p9srv_req *req)
+{
+	int i, n, count;
+	u64 offset;
+	struct p9_fcall *tc, *rc;
+	struct ramfs_fid *fid;
+	struct ramfs_file *file, *cf;
+	struct p9_wstat wstat;
+	u8 *data;
+
+	tc = req->tcall;
+	rc = req->rcall;
+	n = p9_init_rread(rc);
+	fid = req->fid->aux;
+	count = tc->params.tread.count;
+	offset = tc->params.tread.offset;
+	data = rc->params.rread.data;
+	file = fid->file;
+	if (file->perm & P9_DMDIR) {
+		mutex_lock(&file->lock);
+		if (offset == 0) {
+			file_decref(fid->dirent);
+			fid->dirent = file->dirents;
+			file_incref(fid->dirent);
+			fid->diroffset = 0;
+		}
+
+		cf = fid->dirent;
+		for (n = 0, cf = fid->dirent; (n < count) && (cf != NULL);
+							cf = cf->next) {
+			BUG_ON(test_bit(Removed, &cf->status));
+			file2wstat(cf, &wstat);
+			P9_DPRINTK(P9SRV_DEBUG_FS, "name %s\n", wstat.name);
+			i = p9_serialize_stat(&wstat, data + n, count - n - 1,
+				req->conn->dotu);
+			if (i == 0)
+				break;
+
+			n += i;
+		}
+
+		fid->diroffset += n;
+		file_incref(cf);
+		file_decref(fid->dirent);
+		fid->dirent = cf;
+		mutex_unlock(&file->lock);
+	} else {
+		n = count;
+		if (file->length < offset+count)
+			n = file->length - offset;
+
+		if (n < 0)
+			n = 0;
+
+		memmove(data, file->data + offset, n);
+	}
+
+/*
+	pthread_mutex_lock(&file->lock);
+	file->atime = time(NULL);
+	pthread_mutex_unlock(&file->lock);
+*/
+
+	p9_set_rread_count(rc, n);
+	p9srv_respond(req, rc);
+}
+
+static void ramfs_write(struct p9srv_req *req)
+{
+	int err;
+	u32 count;
+	u64 offset;
+	struct p9_fcall *tc;
+	struct ramfs_fid *fid;
+	struct ramfs_file *file;
+
+	tc = req->tcall;
+	offset = tc->params.twrite.offset;
+	count = tc->params.twrite.count;
+	fid = req->fid->aux;
+	file = fid->file;
+	if (req->fid->omode & P9_OAPPEND)
+		offset = file->length;
+
+	if (file->length < offset+count) {
+		mutex_lock(&file->lock);
+		if (file_truncate(file, offset+count)) {
+			mutex_unlock(&file->lock);
+			p9srv_respond_error(req, Enospace, ENOSPC);
+			return;
+		}
+
+		if (offset+count > file->datasize) {
+			if (file->datasize - offset > 0)
+				count = file->datasize - offset;
+			else
+				count = 0;
+		}
+
+		if (count) {
+			if (file->length < offset)
+				memset(file->data+file->length, 0,
+					offset - file->length);
+
+			file->length = offset+count;
+		}
+		mutex_unlock(&file->lock);
+	}
+
+	if (count)
+		memmove(file->data + offset, tc->params.twrite.data, count);
+
+	mutex_lock(&file->lock);
+	file->qid.version++;
+	file->muid = req->fid->uid;
+	mutex_unlock(&file->lock);
+
+	err = p9_create_rwrite(req->rcall, count);
+	if (err < 0)
+		p9srv_respond_error(req, Einternal, err);
+	else
+		p9srv_respond(req, req->rcall);
+}
+
+static void ramfs_clunk(struct p9srv_req *req)
+{
+	int err;
+
+	err = p9_create_rclunk(req->rcall);
+	if (err < 0)
+		p9srv_respond_error(req, Einternal, err);
+	else
+		p9srv_respond(req, req->rcall);
+}
+
+static void ramfs_remove(struct p9srv_req *req)
+{
+	int err;
+	struct p9_fcall *rc;
+	struct ramfs_fid *fid, *f;
+	struct ramfs_file *file;
+
+	err = 0;
+	rc = NULL;
+	fid = req->fid->aux;
+	file = fid->file;
+	P9_DPRINTK(P9SRV_DEBUG_FS, "fid %d name %s\n", req->fid->fid,
+		file->name);
+	mutex_lock(&file->lock);
+	if (file->perm & P9_DMDIR && file->dirents) {
+		mutex_unlock(&file->lock);
+		p9srv_respond_error(req, Enotempty, ENOTEMPTY);
+		return;
+	}
+	mutex_unlock(&file->lock);
+
+	mutex_lock(&file->parent->lock);
+	if (!check_perm(req, file->parent, req->fid->uid, 2))
+		goto done;
+
+	if (test_and_set_bit(Removed, &file->status))
+		goto respond;
+
+	if (file->parent->dirents == file)
+		file->parent->dirents = file->next;
+	else
+		file->prev->next = file->next;
+
+	if (file->next)
+		file->next->prev = file->prev;
+
+	if (file == file->parent->dirlast)
+		file->parent->dirlast = file->prev;
+
+	/* check if any fid has dirent set to the removed file */
+	list_for_each_entry(f, &file->parent->fid_list, fid_list) {
+		if (f->dirent == file) {
+			file_incref(file->next);
+			f->dirent = file->next;
+			file_decref(f->dirent);
+		}
+	}
+
+	file->prev = NULL;
+	file->next = NULL;
+
+	file->parent->muid = req->fid->uid;
+	file->parent->qid.version++;
+
+	file_decref(file);
+	file_decref0(file->parent);
+
+respond:
+	err = p9_create_rremove(req->rcall);
+
+done:
+	mutex_unlock(&file->parent->lock);
+	if (err < 0)
+		p9srv_respond_error(req, Einternal, err);
+	else
+		p9srv_respond(req, req->rcall);
+}
+
+static void ramfs_stat(struct p9srv_req *req)
+{
+	int err;
+	struct ramfs_fid *f;
+	struct p9_wstat wstat;
+
+	f = req->fid->aux;
+	file2wstat(f->file, &wstat);
+	err = p9_create_rstat(req->rcall, &wstat, req->conn->dotu);
+	if (err < 0)
+		p9srv_respond_error(req, Einternal, err);
+	else
+		p9srv_respond(req, req->rcall);
+}
+
+static void ramfs_wstat(struct p9srv_req *req)
+{
+	int lockparent, lockfile, err;
+	struct ramfs_fid *f;
+	struct ramfs_file *file, *nf;
+	struct p9_stat *stat;
+	struct p9_fcall *rc;
+	char *sname, *oldname;
+	u64 length, oldlength;
+	u32 oldperm;
+	u32 oldmtime;
+
+	rc = NULL;
+	err = 0;
+	oldlength = ~0;
+	oldperm = ~0;
+	oldmtime = ~0;
+	oldname = NULL;
+
+	f = req->fid->aux;
+	file = f->file;
+	stat = &req->tcall->params.twstat.stat;
+
+	mutex_lock(&file->lock);
+	lockfile = 1;
+
+	lockparent = stat->name.len != 0 && file->parent != file;
+	if (lockparent)
+		mutex_lock(&file->parent->lock);
+
+	oldname = NULL;
+	if (stat->name.len != 0) {
+		if (!check_perm(req, file->parent, req->fid->uid, 2))
+			goto out;
+
+		sname = p9_strdup(&stat->name);
+		nf = find_file(file->parent, sname, 0);
+
+		if (nf) {
+			kfree(sname);
+			p9srv_respond_error(req, Eexist, EEXIST);
+			goto out;
+		}
+
+		oldname = file->name;
+		file->name = sname;
+	}
+
+	if (stat->length != (u64) ~0) {
+		if (!check_perm(req, file, req->fid->uid, 2) ||
+						file->perm & P9_DMDIR)
+			goto out;
+
+		oldlength = file->length;
+		length = stat->length;
+		if (file_truncate(file, length)) {
+			p9srv_respond_error(req, Enospace, ENOSPC);
+			goto out;
+		}
+
+		if (length > file->datasize)
+			length = file->datasize;
+
+		if (file->length < length)
+			memset(file->data+file->length, 0, length-file->length);
+
+		file->length = length;
+	}
+
+	if (stat->mode != (u32) ~0) {
+		if (file->uid != req->fid->uid) {
+			p9srv_respond_error(req, Eperm, EPERM);
+			goto out;
+		}
+
+		oldperm = file->perm;
+		file->perm = stat->mode;
+	}
+
+	if (stat->mtime != (u32) ~0) {
+		if (file->uid != req->fid->uid) {
+			p9srv_respond_error(req, Eperm, EPERM);
+			goto out;
+		}
+
+		oldmtime = file->mtime;
+		file->mtime = stat->mtime;
+	}
+
+	err = p9_create_rwstat(req->rcall);
+	if (err < 0)
+		p9srv_respond_error(req, Einternal, err);
+	else
+		rc = req->rcall;
+
+out:
+	if (!rc) {
+		if (oldname) {
+			kfree(file->name);
+			file->name = oldname;
+		}
+
+		if (oldperm != ~0)
+			file->perm = oldperm;
+
+		if (oldmtime != ~0)
+			file->mtime = oldmtime;
+
+		if (oldlength != ~0) {
+			file->length = oldlength;
+			file_truncate(file, oldlength);
+		}
+	} else {
+		kfree(oldname);
+		if (stat->length != ~0) {
+			file_truncate(file, file->length);
+			memset(file->data + file->length, 0,
+				file->datasize - file->length);
+		}
+	}
+
+	if (lockparent)
+		mutex_unlock(&file->parent->lock);
+
+	if (lockfile)
+		mutex_unlock(&file->lock);
+
+	if (rc)
+		p9srv_respond(req, rc);
+}
+
+static void ramfs_connopen(struct p9srv_conn *conn)
+{
+	try_module_get(THIS_MODULE);
+}
+
+static void ramfs_connclose(struct p9srv_conn *conn)
+{
+	module_put(THIS_MODULE);
+}
+
+static void ramfs_destroy(struct p9srv *srv)
+{
+	module_put(THIS_MODULE);
+}
+
+static struct p9srv *ramfs_srv_create(void)
+{
+	char *s;
+	struct p9srv *srv;
+
+	srv = p9srv_srv_create();
+	if (IS_ERR(srv))
+		return srv;
+
+	srv->attach = ramfs_attach;
+	srv->walk = ramfs_walk;
+	srv->open = ramfs_open;
+	srv->create = ramfs_create;
+	srv->read = ramfs_read;
+	srv->write = ramfs_write;
+	srv->clunk = ramfs_clunk;
+	srv->remove = ramfs_remove;
+	srv->stat = ramfs_stat;
+	srv->wstat = ramfs_wstat;
+	srv->destroy = ramfs_destroy;
+	srv->fiddestroy = ramfs_fiddestroy;
+	srv->debuglevel = 0;
+	srv->connopen = ramfs_connopen;
+	srv->connclose = ramfs_connclose;
+
+	s = kmalloc(2, GFP_KERNEL);
+	*s = '\0';
+	root = file_create(NULL, s, ROOTPERM | P9_DMDIR, 0, 0);
+	file_incref(root);
+	root->parent = root;
+
+	try_module_get(THIS_MODULE);
+	p9srv_srv_start(srv);
+	return srv;
+}
+
+static int __init ramfs_init(void)
+{
+	ramfs_srv_type = p9srv_type_register("ramfs", ramfs_srv_create);
+	if (IS_ERR(ramfs_srv_type))
+		return PTR_ERR(ramfs_srv_type);
+
+	return 0;
+}
+
+static void __exit ramfs_exit(void)
+{
+	p9srv_type_unregister("ramfs");
+}
+
+module_init(ramfs_init)
+module_exit(ramfs_exit)
+
+MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
+MODULE_LICENSE("GPL");
