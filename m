Return-Path: <linux-kernel-owner+w=401wt.eu-S1423396AbXD3Pcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423396AbXD3Pcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423390AbXD3Pcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:32:51 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:52998 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423398AbXD3Pcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:32:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=S15xl8jxrMUq40OGpRWsGd5QtLWJc7zA2u98PAEmKkRollNCzi4BYf5gH0m4SU/XUPJe9RPdiSBa82uH1clD2ly70Fg+obJSI/3iSBx+cSGZKa9tNIsp4PL4JTyUMOl15hRLwRbncI32hJRdTLYPbl9yN1cBOneF9ErpcNusjIA=
Message-ID: <f158dc670704300832l36889bf2kfa4480addbe8cfb2@mail.gmail.com>
Date: Mon, 30 Apr 2007 09:32:41 -0600
From: "Latchesar Ionkov" <lionkov@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>
Subject: [PATCH] 9p: create separate 9p client interface
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create a separate 9P client interface that can be used outside the VFS
layer. In addition to VFS, the new interface can be used to export the
authentication channel or from other interfaces.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
commit 775a1769e24d7a1cecefa6fc223559f391626d16
tree 59f952ad0684463820ec04625f68c3950df7e6bd
parent b9099ff63c75216d6ca10bce5a1abcd9293c27e6
author Latchesar Ionkov <lucho@ionkov.net> Sun, 29 Apr 2007 18:42:02 -0600
committer Latchesar Ionkov <lucho@ionkov.net> Sun, 29 Apr 2007 18:42:02 -0600

 fs/9p/Makefile     |    2
 fs/9p/clnt.c       |  934 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/9p/clnt.h       |   72 ++++
 fs/9p/conv.c       |   41 ++
 fs/9p/conv.h       |    3
 fs/9p/fcall.c      |  427 ------------------------
 fs/9p/fcprint.c    |    1
 fs/9p/fid.c        |  158 +++------
 fs/9p/fid.h        |   39 --
 fs/9p/trans_fd.c   |  329 ++++++++++--------
 fs/9p/transport.h  |    7
 fs/9p/v9fs.c       |  150 ++------
 fs/9p/v9fs.h       |   12 -
 fs/9p/vfs_addr.c   |   52 +--
 fs/9p/vfs_dentry.c |   25 +
 fs/9p/vfs_dir.c    |  139 ++------
 fs/9p/vfs_file.c   |  145 ++------
 fs/9p/vfs_inode.c  |  627 ++++++++++++-----------------------
 fs/9p/vfs_super.c  |   78 ++--
 19 files changed, 1656 insertions(+), 1585 deletions(-)

diff --git a/fs/9p/Makefile b/fs/9p/Makefile
index 87897f8..c59a761 100644
--- a/fs/9p/Makefile
+++ b/fs/9p/Makefile
@@ -3,8 +3,8 @@ obj-$(CONFIG_9P_FS) := 9p.o
 9p-objs := \
 	trans_fd.o \
 	mux.o \
-	fcall.o \
 	conv.o \
+	clnt.o \
 	vfs_super.o \
 	vfs_inode.o \
 	vfs_addr.o \
diff --git a/fs/9p/clnt.c b/fs/9p/clnt.c
new file mode 100644
index 0000000..4c5ae77
--- /dev/null
+++ b/fs/9p/clnt.c
@@ -0,0 +1,934 @@
+/*
+ * linux/fs/9p/clnt.c
+ *
+ * 9P Client
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
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <asm/uaccess.h>
+
+#include "debug.h"
+#include "v9fs.h"
+#include "9p.h"
+#include "conv.h"
+#include "transport.h"
+#include "mux.h"
+#include "clnt.h"
+
+static struct v9fs_fid *v9fs_fid_create(struct v9fs_clnt *clnt);
+static void v9fs_fid_destroy(struct v9fs_fid *fid);
+static struct v9fs_stat *v9fs_clone_stat(struct v9fs_stat *st, int dotu);
+
+struct v9fs_clnt *v9fs_clnt_create(struct v9fs_transport *trans, int
msize, int dotu)
+{
+	int err, n;
+	struct v9fs_clnt *clnt;
+	struct v9fs_fcall *tc, *rc;
+	struct v9fs_str *version;
+
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = kmalloc(sizeof(struct v9fs_clnt), GFP_KERNEL);
+	if (!clnt)
+		return ERR_PTR(-ENOMEM);
+
+	dprintk(DEBUG_9P, "clnt %p trans %p msize %d dotu %d\n",
+		clnt, trans, msize, dotu);
+	spin_lock_init(&clnt->lock);
+	clnt->trans = trans;
+	clnt->msize = msize;
+	clnt->dotu = dotu;
+	INIT_LIST_HEAD(&clnt->fidlist);
+	idr_init(&clnt->fidpool.pool);
+	init_MUTEX(&clnt->fidpool.lock);
+	clnt->mux = v9fs_mux_init(clnt->trans, clnt->msize, &clnt->dotu);
+	if (IS_ERR(clnt->mux)) {
+		err = PTR_ERR(clnt->mux);
+		clnt->mux = NULL;
+		goto error;
+	}
+
+	tc = v9fs_create_tversion(clnt->msize, clnt->dotu?"9P2000.u":"9P2000");
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto error;
+	}
+
+	err = v9fs_mux_rpc(clnt->mux, tc, &rc);
+	if (err)
+		goto error;
+
+	version = &rc->params.rversion.version;
+	if (version->len == 8 && !memcmp(version->str, "9P2000.u", 8))
+		clnt->dotu = 1;
+	else if (version->len == 6 && !memcmp(version->str, "9P2000", 6))
+		clnt->dotu = 0;
+	else {
+		err = -EREMOTEIO;
+		goto error;
+	}
+
+	n = rc->params.rversion.msize;
+	if (n < clnt->msize)
+		clnt->msize = n;
+
+	kfree(tc);
+	kfree(rc);
+	return clnt;
+
+error:
+	kfree(tc);
+	kfree(rc);
+	v9fs_clnt_destroy(clnt);
+	return ERR_PTR(err);
+}
+
+void v9fs_clnt_destroy(struct v9fs_clnt *clnt)
+{
+	struct v9fs_fid *fid, *fidptr;
+
+	dprintk(DEBUG_9P, "clnt %p\n", clnt);
+	if (clnt->mux) {
+		v9fs_mux_destroy(clnt->mux);
+		clnt->mux = NULL;
+	}
+
+	if (clnt->trans) {
+		clnt->trans->close(clnt->trans);
+		kfree(clnt->trans);
+		clnt->trans = NULL;
+	}
+
+	idr_destroy(&clnt->fidpool.pool);
+	list_for_each_entry_safe(fid, fidptr, &clnt->fidlist, flist)
+		v9fs_fid_destroy(fid);
+
+	kfree(clnt);
+}
+
+void v9fs_clnt_disconnect(struct v9fs_clnt *clnt)
+{
+	dprintk(DEBUG_9P, "clnt %p\n", clnt);
+	clnt->trans->status = Disconnected;
+	v9fs_mux_cancel(clnt->mux, -EIO);
+}
+
+struct v9fs_fid *v9fs_clnt_attach(struct v9fs_clnt *clnt, struct
v9fs_fid *afid,
+	char *uname, char *aname)
+{
+	int err;
+	struct v9fs_fcall *tc, *rc;
+	struct v9fs_fid *fid;
+
+	dprintk(DEBUG_9P, "clnt %p afid %d uname %s aname %s\n",
+		clnt, afid?afid->fid:-1, uname, aname);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+
+	fid = v9fs_fid_create(clnt);
+	if (IS_ERR(fid)) {
+		err = PTR_ERR(fid);
+		fid = NULL;
+		goto error;
+	}
+
+	tc = v9fs_create_tattach(fid->fid, afid?afid->fid:V9FS_NOFID, uname, aname);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto error;
+	}
+
+	err = v9fs_mux_rpc(clnt->mux, tc, &rc);
+	if (err)
+		goto error;
+
+	memmove(&fid->qid, &rc->params.rattach.qid, sizeof(struct v9fs_qid));
+	kfree(tc);
+	kfree(rc);
+	return fid;
+
+error:
+	kfree(tc);
+	kfree(rc);
+	if (fid)
+		v9fs_fid_destroy(fid);
+	return ERR_PTR(err);
+}
+
+struct v9fs_fid *v9fs_clnt_auth(struct v9fs_clnt *clnt, char *uname,
char *aname)
+{
+	int err;
+	struct v9fs_fcall *tc, *rc;
+	struct v9fs_fid *fid;
+
+	dprintk(DEBUG_9P, "clnt %p uname %s aname %s\n", clnt, uname, aname);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+
+	fid = v9fs_fid_create(clnt);
+	if (IS_ERR(fid)) {
+		err = PTR_ERR(fid);
+		fid = NULL;
+		goto error;
+	}
+
+	tc = v9fs_create_tauth(fid->fid, uname, aname);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto error;
+	}
+
+	err = v9fs_mux_rpc(clnt->mux, tc, &rc);
+	if (err)
+		goto error;
+
+	memmove(&fid->qid, &rc->params.rauth.qid, sizeof(struct v9fs_qid));
+	kfree(tc);
+	kfree(rc);
+	return fid;
+
+error:
+	kfree(tc);
+	kfree(rc);
+	if (fid)
+		v9fs_fid_destroy(fid);
+	return ERR_PTR(err);
+}
+
+struct v9fs_fid *v9fs_clnt_walk(struct v9fs_fid *oldfid, int nwname,
char **wnames,
+	int clone)
+{
+	int err;
+	struct v9fs_fcall *tc, *rc;
+	struct v9fs_clnt *clnt;
+	struct v9fs_fid *fid;
+
+	dprintk(DEBUG_9P, "fid %d nwname %d wname[0] %s\n",
+		oldfid->fid, nwname, wnames?wnames[0]:NULL);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = oldfid->clnt;
+	if (clone) {
+		fid = v9fs_fid_create(clnt);
+		if (IS_ERR(fid)) {
+			err = PTR_ERR(fid);
+			fid = NULL;
+			goto error;
+		}
+
+		fid->uid = oldfid->uid;
+	} else
+		fid = oldfid;
+
+	tc = v9fs_create_twalk(oldfid->fid, fid->fid, nwname, wnames);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto error;
+	}
+
+	err = v9fs_mux_rpc(clnt->mux, tc, &rc);
+	if (err) {
+		if (rc && rc->id == RWALK)
+			goto clunk_fid;
+		else
+			goto error;
+	}
+
+	if (rc->params.rwalk.nwqid != nwname) {
+		err = -ENOENT;
+		goto clunk_fid;
+	}
+
+	if (nwname)
+		memmove(&fid->qid, &rc->params.rwalk.wqids[rc->params.rwalk.nwqid - 1],
+			sizeof(struct v9fs_qid));
+	else
+		fid->qid = oldfid->qid;
+
+	kfree(tc);
+	kfree(rc);
+	return fid;
+
+clunk_fid:
+	kfree(tc);
+	kfree(rc);
+	rc = NULL;
+	tc = v9fs_create_tclunk(fid->fid);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto error;
+	}
+
+	v9fs_mux_rpc(clnt->mux, tc, &rc);
+
+error:
+	kfree(tc);
+	kfree(rc);
+	if (fid && fid!=oldfid)
+		v9fs_fid_destroy(fid);
+
+	return ERR_PTR(err);
+}
+
+int v9fs_clnt_open(struct v9fs_fid *fid, int mode)
+{
+	int err;
+	struct v9fs_fcall *tc, *rc;
+	struct v9fs_clnt *clnt;
+
+	dprintk(DEBUG_9P, "fid %d mode %d\n", fid->fid, mode);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+
+	if (fid->mode != -1)
+		return -EINVAL;
+
+	tc = v9fs_create_topen(fid->fid, mode);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto done;
+	}
+
+	err = v9fs_mux_rpc(clnt->mux, tc, &rc);
+	if (err)
+		goto done;
+
+	fid->mode = mode;
+	fid->iounit = rc->params.ropen.iounit;
+
+done:
+	kfree(tc);
+	kfree(rc);
+	return err;
+}
+
+int v9fs_clnt_fcreate(struct v9fs_fid *fid, char *name, u32 perm, int mode,
+		     char *extension)
+{
+	int err;
+	struct v9fs_fcall *tc, *rc;
+	struct v9fs_clnt *clnt;
+
+	dprintk(DEBUG_9P, "fid %d name %s perm %d mode %d\n", fid->fid,
+		name, perm, mode);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+
+	if (fid->mode != -1)
+		return -EINVAL;
+
+	tc = v9fs_create_tcreate(fid->fid, name, perm, mode, extension,
+		clnt->dotu);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto done;
+	}
+
+	err = v9fs_mux_rpc(clnt->mux, tc, &rc);
+	if (err)
+		goto done;
+
+	fid->mode = mode;
+	fid->iounit = rc->params.ropen.iounit;
+
+done:
+	kfree(tc);
+	kfree(rc);
+	return err;
+}
+
+int v9fs_clnt_clunk(struct v9fs_fid *fid)
+{
+	int err;
+	struct v9fs_fcall *tc, *rc;
+	struct v9fs_clnt *clnt;
+
+	dprintk(DEBUG_9P, "fid %d\n", fid->fid);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+
+	tc = v9fs_create_tclunk(fid->fid);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto done;
+	}
+
+	err = v9fs_mux_rpc(clnt->mux, tc, &rc);
+	if (err)
+		goto done;
+
+	v9fs_fid_destroy(fid);
+
+done:
+	kfree(tc);
+	kfree(rc);
+	return err;
+}
+
+int v9fs_clnt_remove(struct v9fs_fid *fid)
+{
+	int err;
+	struct v9fs_fcall *tc, *rc;
+	struct v9fs_clnt *clnt;
+
+	dprintk(DEBUG_9P, "fid %d\n", fid->fid);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+
+	tc = v9fs_create_tremove(fid->fid);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto done;
+	}
+
+	err = v9fs_mux_rpc(clnt->mux, tc, &rc);
+	if (err)
+		goto done;
+
+	v9fs_fid_destroy(fid);
+
+done:
+	kfree(tc);
+	kfree(rc);
+	return err;
+}
+
+int v9fs_clnt_read(struct v9fs_fid *fid, char *data, u64 offset, u32 count)
+{
+	int err, n, rsize, total;
+	struct v9fs_fcall *tc, *rc;
+	struct v9fs_clnt *clnt;
+
+	dprintk(DEBUG_9P, "fid %d offset %lld %d\n", fid->fid, offset, count);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+	total = 0;
+
+	rsize = fid->iounit;
+	if (!rsize || rsize>clnt->msize-V9FS_IOHDRSZ)
+		rsize = clnt->msize - V9FS_IOHDRSZ;
+
+	do {
+		if (count < rsize)
+			rsize = count;
+
+		tc = v9fs_create_tread(fid->fid, offset, rsize);
+		if (IS_ERR(tc)) {
+			err = PTR_ERR(tc);
+			tc = NULL;
+			goto error;
+		}
+
+		err = v9fs_mux_rpc(clnt->mux, tc, &rc);
+		if (err)
+			goto error;
+
+		n = rc->params.rread.count;
+		if (n > count)
+			n = count;
+
+		memmove(data, rc->params.rread.data, n);
+		count -= n;
+		data += n;
+		offset += n;
+		total += n;
+		kfree(tc);
+		tc = NULL;
+		kfree(rc);
+		rc = NULL;
+	} while (count>0 && n == rsize);
+
+	return total;
+
+error:
+	kfree(tc);
+	kfree(rc);
+	return err;
+}
+
+int v9fs_clnt_write(struct v9fs_fid *fid, char *data, u64 offset, u32 count)
+{
+	int err, n, rsize, total;
+	struct v9fs_fcall *tc, *rc;
+	struct v9fs_clnt *clnt;
+
+	dprintk(DEBUG_9P, "fid %d offset %lld count %d\n", fid->fid, offset,
+		count);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+	total = 0;
+
+	rsize = fid->iounit;
+	if (!rsize || rsize>clnt->msize-V9FS_IOHDRSZ)
+		rsize = clnt->msize - V9FS_IOHDRSZ;
+
+	do {
+		if (count < rsize)
+			rsize = count;
+
+		tc = v9fs_create_twrite(fid->fid, offset, rsize, data);
+		if (IS_ERR(tc)) {
+			err = PTR_ERR(tc);
+			tc = NULL;
+			goto error;
+		}
+
+		err = v9fs_mux_rpc(clnt->mux, tc, &rc);
+		if (err)
+			goto error;
+
+		n = rc->params.rread.count;
+		count -= n;
+		data += n;
+		offset += n;
+		total += n;
+		kfree(tc);
+		tc = NULL;
+		kfree(rc);
+		rc = NULL;
+	} while (count>0);
+
+	return total;
+
+error:
+	kfree(tc);
+	kfree(rc);
+	return err;
+}
+
+int v9fs_clnt_uread(struct v9fs_fid *fid, char __user *data, u64
offset, u32 count)
+{
+	int err, n, rsize, total;
+	struct v9fs_fcall *tc, *rc;
+	struct v9fs_clnt *clnt;
+
+	dprintk(DEBUG_9P, "fid %d offset %lld count %d\n", fid->fid, offset,
+		count);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+	total = 0;
+
+	rsize = fid->iounit;
+	if (!rsize || rsize>clnt->msize-V9FS_IOHDRSZ)
+		rsize = clnt->msize - V9FS_IOHDRSZ;
+
+	do {
+		if (count < rsize)
+			rsize = count;
+
+		tc = v9fs_create_tread(fid->fid, offset, rsize);
+		if (IS_ERR(tc)) {
+			err = PTR_ERR(tc);
+			tc = NULL;
+			goto error;
+		}
+
+		err = v9fs_mux_rpc(clnt->mux, tc, &rc);
+		if (err)
+			goto error;
+
+		n = rc->params.rread.count;
+		if (n > count)
+			n = count;
+
+		err = copy_to_user(data, rc->params.rread.data, n);
+		if (err) {
+			err = -EFAULT;
+			goto error;
+		}
+
+		count -= n;
+		data += n;
+		offset += n;
+		total += n;
+		kfree(tc);
+		tc = NULL;
+		kfree(rc);
+		rc = NULL;
+	} while (count>0 && n == rsize);
+
+	return total;
+
+error:
+	kfree(tc);
+	kfree(rc);
+	return err;
+}
+
+int v9fs_clnt_uwrite(struct v9fs_fid *fid, const char __user *data,
u64 offset, u32 count)
+{
+	int err, n, rsize, total;
+	struct v9fs_fcall *tc, *rc;
+	struct v9fs_clnt *clnt;
+
+	dprintk(DEBUG_9P, "fid %d offset %lld count %d\n", fid->fid, offset,
+		count);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+	total = 0;
+
+	rsize = fid->iounit;
+	if (!rsize || rsize>clnt->msize-V9FS_IOHDRSZ)
+		rsize = clnt->msize - V9FS_IOHDRSZ;
+
+	do {
+		if (count < rsize)
+			rsize = count;
+
+		tc = v9fs_create_twrite_u(fid->fid, offset, rsize, data);
+		if (IS_ERR(tc)) {
+			err = PTR_ERR(tc);
+			tc = NULL;
+			goto error;
+		}
+
+		err = v9fs_mux_rpc(clnt->mux, tc, &rc);
+		if (err)
+			goto error;
+
+		n = rc->params.rread.count;
+		count -= n;
+		data += n;
+		offset += n;
+		total += n;
+		kfree(tc);
+		tc = NULL;
+		kfree(rc);
+		rc = NULL;
+	} while (count>0);
+
+	return total;
+
+error:
+	kfree(tc);
+	kfree(rc);
+	return err;
+}
+
+int v9fs_clnt_readn(struct v9fs_fid *fid, char *data, u64 offset, u32 count)
+{
+	int n, total;
+
+	dprintk(DEBUG_9P, "fid %d offset %lld count %d\n", fid->fid, offset,
+		count);
+	n = 0;
+	total = 0;
+	while (count) {
+		n = v9fs_clnt_read(fid, data, offset, count);
+		if (n <= 0)
+			break;
+
+		data += n;
+		offset += n;
+		count -= n;
+		total += n;
+	}
+
+	if (n < 0)
+		total = n;
+
+	return total;
+}
+
+struct v9fs_stat *v9fs_clnt_stat(struct v9fs_fid *fid)
+{
+	int err;
+	struct v9fs_fcall *tc, *rc;
+	struct v9fs_clnt *clnt;
+	struct v9fs_stat *ret;
+
+	dprintk(DEBUG_9P, "fid %d\n", fid->fid);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	ret = NULL;
+	clnt = fid->clnt;
+
+	tc = v9fs_create_tstat(fid->fid);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto error;
+	}
+
+	err = v9fs_mux_rpc(clnt->mux, tc, &rc);
+	if (err)
+		goto error;
+
+	ret = v9fs_clone_stat(&rc->params.rstat.stat, clnt->dotu);
+	if (IS_ERR(ret)) {
+		err = PTR_ERR(ret);
+		ret = NULL;
+		goto error;
+	}
+
+	kfree(tc);
+	kfree(rc);
+	return ret;
+
+error:
+	kfree(tc);
+	kfree(rc);
+	kfree(ret);
+	return ERR_PTR(err);
+}
+
+int v9fs_clnt_wstat(struct v9fs_fid *fid, struct v9fs_wstat *wst)
+{
+	int err;
+	struct v9fs_fcall *tc, *rc;
+	struct v9fs_clnt *clnt;
+
+	dprintk(DEBUG_9P, "fid %d\n", fid->fid);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+
+	tc = v9fs_create_twstat(fid->fid, wst, clnt->dotu);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto done;
+	}
+
+	err = v9fs_mux_rpc(clnt->mux, tc, &rc);
+
+done:
+	kfree(tc);
+	kfree(rc);
+	return err;
+}
+
+struct v9fs_stat *v9fs_clnt_dirread(struct v9fs_fid *fid, u64 offset)
+{
+	int err, n, m;
+	struct v9fs_fcall *tc, *rc;
+	struct v9fs_clnt *clnt;
+	struct v9fs_stat st, *ret;
+
+	dprintk(DEBUG_9P, "fid %d offset %lld\n", fid->fid, offset);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	ret = NULL;
+	clnt = fid->clnt;
+
+	/* if the offset is below or above the current response, free it */
+	if (offset<fid->rdir_fpos || (fid->rdir_fcall &&
+		offset >= fid->rdir_fpos+fid->rdir_fcall->params.rread.count)) {
+		fid->rdir_pos = 0;
+		if (fid->rdir_fcall)
+			fid->rdir_fpos += fid->rdir_fcall->params.rread.count;
+
+		kfree(fid->rdir_fcall);
+		fid->rdir_fcall = NULL;
+		if (offset < fid->rdir_fpos)
+			fid->rdir_fpos = 0;
+	}
+
+	if (!fid->rdir_fcall) {
+		n = fid->iounit;
+		if (!n || n>clnt->msize-V9FS_IOHDRSZ)
+			n = clnt->msize - V9FS_IOHDRSZ;
+
+		while (1) {
+			if (fid->rdir_fcall) {
+				fid->rdir_fpos += fid->rdir_fcall->params.rread.count;
+				kfree(fid->rdir_fcall);
+				fid->rdir_fcall = NULL;
+			}
+
+			tc = v9fs_create_tread(fid->fid, fid->rdir_fpos, n);
+			if (IS_ERR(tc)) {
+				err = PTR_ERR(tc);
+				tc = NULL;
+				goto error;
+			}
+
+			err = v9fs_mux_rpc(clnt->mux, tc, &rc);
+			if (err)
+				goto error;
+
+			n = rc->params.rread.count;
+			if (n == 0)
+				goto done;
+
+			fid->rdir_fcall = rc;
+			rc = NULL;
+			if (offset>=fid->rdir_fpos && offset<fid->rdir_fpos+n)
+				break;
+		}
+
+		fid->rdir_pos = 0;
+	}
+
+	m = offset - fid->rdir_fpos;
+	if (m < 0)
+		goto done;
+
+	n = v9fs_deserialize_stat(fid->rdir_fcall->params.rread.data + m,
+		fid->rdir_fcall->params.rread.count - m, &st, clnt->dotu);
+
+	if (!n) {
+		err = -EIO;
+		goto error;
+	}
+
+	fid->rdir_pos += n;
+	st.size = n;
+	ret = v9fs_clone_stat(&st, clnt->dotu);
+	if (IS_ERR(ret)) {
+		err = PTR_ERR(ret);
+		ret = NULL;
+		goto error;
+	}
+
+done:
+	kfree(tc);
+	kfree(rc);
+	return ret;
+
+error:
+	kfree(tc);
+	kfree(rc);
+	kfree(ret);
+	return ERR_PTR(err);
+}
+
+static struct v9fs_stat *v9fs_clone_stat(struct v9fs_stat *st, int dotu)
+{
+	int n;
+	char *p;
+	struct v9fs_stat *ret;
+
+	n = sizeof(struct v9fs_stat) + st->name.len + st->uid.len + st->gid.len +
+		st->muid.len;
+
+	if (dotu)
+		n += st->extension.len;
+
+	ret = kmalloc(n, GFP_KERNEL);
+	if (!ret)
+		return ERR_PTR(-ENOMEM);
+
+	memmove(ret, st, sizeof(struct v9fs_stat));
+	p = ((char *) ret) + sizeof(struct v9fs_stat);
+	memmove(p, st->name.str, st->name.len);
+	p += st->name.len;
+	memmove(p, st->uid.str, st->uid.len);
+	p += st->uid.len;
+	memmove(p, st->gid.str, st->gid.len);
+	p += st->gid.len;
+	memmove(p, st->muid.str, st->muid.len);
+	p += st->muid.len;
+
+	if (dotu) {
+		memmove(p, st->extension.str, st->extension.len);
+		p += st->extension.len;
+	}
+
+	return ret;
+}
+
+static struct v9fs_fid *v9fs_fid_create(struct v9fs_clnt *clnt)
+{
+	int err;
+	struct v9fs_fid *fid;
+
+	dprintk(DEBUG_9P, "clnt %p\n", clnt);
+	fid = kmalloc(sizeof(struct v9fs_fid), GFP_KERNEL);
+	if (!fid)
+		return ERR_PTR(-ENOMEM);
+
+	fid->fid = v9fs_get_idpool(&clnt->fidpool);
+	if (fid->fid < 0) {
+		err = -ENOSPC;
+		goto error;
+	}
+
+	memset(&fid->qid, 0, sizeof(struct v9fs_qid));
+	fid->mode = -1;
+	fid->rdir_fpos = 0;
+	fid->rdir_pos = 0;
+	fid->rdir_fcall = NULL;
+	fid->uid = current->fsuid;
+	fid->clnt = clnt;
+	fid->aux = NULL;
+
+	spin_lock(&clnt->lock);
+	list_add(&fid->flist, &clnt->fidlist);
+	spin_unlock(&clnt->lock);
+
+	return fid;
+
+error:
+	kfree(fid);
+	return ERR_PTR(err);
+}
+
+static void v9fs_fid_destroy(struct v9fs_fid *fid)
+{
+	struct v9fs_clnt *clnt;
+
+	dprintk(DEBUG_9P, "fid %d\n", fid->fid);
+	clnt = fid->clnt;
+	v9fs_put_idpool(fid->fid, &clnt->fidpool);
+	spin_lock(&clnt->lock);
+	list_del(&fid->flist);
+	spin_unlock(&clnt->lock);
+	kfree(fid->rdir_fcall);
+	kfree(fid);
+}
diff --git a/fs/9p/clnt.h b/fs/9p/clnt.h
new file mode 100644
index 0000000..01a297b
--- /dev/null
+++ b/fs/9p/clnt.h
@@ -0,0 +1,72 @@
+/*
+ * linux/fs/9p/clnt.h
+ *
+ * 9P Client Definitions
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
+struct v9fs_clnt {
+	spinlock_t lock;
+	int msize;
+	unsigned char dotu;
+	struct v9fs_transport *trans;
+	struct v9fs_mux_data *mux;
+
+	struct v9fs_idpool fidpool;
+	struct list_head fidlist;
+};
+
+struct v9fs_fid {
+	struct v9fs_clnt *clnt;
+	u32 fid;
+	int mode;
+	struct v9fs_qid qid;
+	u32 iounit;
+	uid_t uid;
+	void *aux;
+
+	int rdir_fpos;
+	int rdir_pos;
+	struct v9fs_fcall *rdir_fcall;
+	struct list_head flist;
+	struct list_head dlist;	// list of all fids attached to a dentry
+};
+
+struct v9fs_clnt *v9fs_clnt_create(struct v9fs_transport *trans, int
msize, int dotu);
+void v9fs_clnt_destroy(struct v9fs_clnt *clnt);
+void v9fs_clnt_disconnect(struct v9fs_clnt *clnt);
+struct v9fs_fid *v9fs_clnt_attach(struct v9fs_clnt *clnt, struct
v9fs_fid *afid,
+	char *uname, char *aname);
+struct v9fs_fid *v9fs_clnt_auth(struct v9fs_clnt *clnt, char *uname,
char *aname);
+struct v9fs_fid *v9fs_clnt_walk(struct v9fs_fid *oldfid, int nwname,
char **wnames,
+	int clone);
+int v9fs_clnt_open(struct v9fs_fid *fid, int mode);
+int v9fs_clnt_fcreate(struct v9fs_fid *fid, char *name, u32 perm, int mode,
+	char *extension);
+int v9fs_clnt_clunk(struct v9fs_fid *fid);
+int v9fs_clnt_remove(struct v9fs_fid *fid);
+int v9fs_clnt_read(struct v9fs_fid *fid, char *data, u64 offset, u32 count);
+int v9fs_clnt_readn(struct v9fs_fid *fid, char *data, u64 offset, u32 count);
+int v9fs_clnt_write(struct v9fs_fid *fid, char *data, u64 offset, u32 count);
+int v9fs_clnt_uread(struct v9fs_fid *fid, char __user *data, u64
offset, u32 count);
+int v9fs_clnt_uwrite(struct v9fs_fid *fid, const char __user *data,
u64 offset, u32 count);
+struct v9fs_stat *v9fs_clnt_stat(struct v9fs_fid *fid);
+int v9fs_clnt_wstat(struct v9fs_fid *fid, struct v9fs_wstat *wst);
+struct v9fs_stat *v9fs_clnt_dirread(struct v9fs_fid *fid, u64 offset);
diff --git a/fs/9p/conv.c b/fs/9p/conv.c
index a3ed571..7a7139b 100644
--- a/fs/9p/conv.c
+++ b/fs/9p/conv.c
@@ -451,6 +451,15 @@ v9fs_put_str(struct cbuf *bufp, char *data,
struct v9fs_str *str)
 }

 static int
+v9fs_put_data(struct cbuf *bufp, const char *data, int count,
+		   unsigned char **pdata)
+{
+	*pdata = buf_alloc(bufp, count);
+	memmove(*pdata, data, count);
+	return count;
+}
+
+static int
 v9fs_put_user_data(struct cbuf *bufp, const char __user * data, int count,
 		   unsigned char **pdata)
 {
@@ -535,7 +544,6 @@ struct v9fs_fcall *v9fs_create_tversion(u32 msize,
char *version)
 	return fc;
 }

-#if 0
 struct v9fs_fcall *v9fs_create_tauth(u32 afid, char *uname, char *aname)
 {
 	int size;
@@ -559,7 +567,6 @@ struct v9fs_fcall *v9fs_create_tauth(u32 afid,
char *uname, char *aname)
       error:
 	return fc;
 }
-#endif  /*  0  */

 struct v9fs_fcall *
 v9fs_create_tattach(u32 fid, u32 afid, char *uname, char *aname)
@@ -723,6 +730,36 @@ struct v9fs_fcall *v9fs_create_tread(u32 fid, u64
offset, u32 count)
 }

 struct v9fs_fcall *v9fs_create_twrite(u32 fid, u64 offset, u32 count,
+				      const char *data)
+{
+	int size, err;
+	struct v9fs_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4 + 8 + 4 + count;	/* fid[4] offset[8] count[4] data[count] */
+	fc = v9fs_create_common(bufp, size, TWRITE);
+	if (IS_ERR(fc))
+		goto error;
+
+	v9fs_put_int32(bufp, fid, &fc->params.twrite.fid);
+	v9fs_put_int64(bufp, offset, &fc->params.twrite.offset);
+	v9fs_put_int32(bufp, count, &fc->params.twrite.count);
+	err = v9fs_put_data(bufp, data, count, &fc->params.twrite.data);
+	if (err) {
+		kfree(fc);
+		fc = ERR_PTR(err);
+	}
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+      error:
+	return fc;
+}
+
+struct v9fs_fcall *v9fs_create_twrite_u(u32 fid, u64 offset, u32 count,
 				      const char __user * data)
 {
 	int size, err;
diff --git a/fs/9p/conv.h b/fs/9p/conv.h
index dd5b6b1..98801a5 100644
--- a/fs/9p/conv.h
+++ b/fs/9p/conv.h
@@ -34,6 +34,7 @@ void v9fs_set_tag(struct v9fs_fcall *fc, u16 tag);
 struct v9fs_fcall *v9fs_create_tversion(u32 msize, char *version);
 struct v9fs_fcall *v9fs_create_tattach(u32 fid, u32 afid, char *uname,
 	char *aname);
+struct v9fs_fcall *v9fs_create_tauth(u32 afid, char *uname, char *aname);
 struct v9fs_fcall *v9fs_create_tflush(u16 oldtag);
 struct v9fs_fcall *v9fs_create_twalk(u32 fid, u32 newfid, u16 nwname,
 	char **wnames);
@@ -42,6 +43,8 @@ struct v9fs_fcall *v9fs_create_tcreate(u32 fid, char
*name, u32 perm, u8 mode,
 	char *extension, int extended);
 struct v9fs_fcall *v9fs_create_tread(u32 fid, u64 offset, u32 count);
 struct v9fs_fcall *v9fs_create_twrite(u32 fid, u64 offset, u32 count,
+	const char *data);
+struct v9fs_fcall *v9fs_create_twrite_u(u32 fid, u64 offset, u32 count,
 	const char __user *data);
 struct v9fs_fcall *v9fs_create_tclunk(u32 fid);
 struct v9fs_fcall *v9fs_create_tremove(u32 fid);
diff --git a/fs/9p/fcall.c b/fs/9p/fcall.c
deleted file mode 100644
index dc336a6..0000000
--- a/fs/9p/fcall.c
+++ /dev/null
@@ -1,427 +0,0 @@
-/*
- *  linux/fs/9p/fcall.c
- *
- *  This file contains functions to perform synchronous 9P calls
- *
- *  Copyright (C) 2004 by Latchesar Ionkov <lucho@ionkov.net>
- *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
- *  Copyright (C) 2002 by Ron Minnich <rminnich@lanl.gov>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2
- *  as published by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to:
- *  Free Software Foundation
- *  51 Franklin Street, Fifth Floor
- *  Boston, MA  02111-1301  USA
- *
- */
-
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/fs.h>
-#include <linux/sched.h>
-#include <linux/idr.h>
-
-#include "debug.h"
-#include "v9fs.h"
-#include "9p.h"
-#include "conv.h"
-#include "mux.h"
-
-/**
- * v9fs_t_version - negotiate protocol parameters with sever
- * @v9ses: 9P2000 session information
- * @msize: requested max size packet
- * @version: requested version.extension string
- * @fcall: pointer to response fcall pointer
- *
- */
-
-int
-v9fs_t_version(struct v9fs_session_info *v9ses, u32 msize,
-	       char *version, struct v9fs_fcall **rcp)
-{
-	int ret;
-	struct v9fs_fcall *tc;
-
-	dprintk(DEBUG_9P, "msize: %d version: %s\n", msize, version);
-	tc = v9fs_create_tversion(msize, version);
-
-	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
-		kfree(tc);
-	} else
-		ret = PTR_ERR(tc);
-
-	return ret;
-}
-
-/**
- * v9fs_t_attach - mount the server
- * @v9ses: 9P2000 session information
- * @uname: user name doing the attach
- * @aname: remote name being attached to
- * @fid: mount fid to attatch to root node
- * @afid: authentication fid (in this case result key)
- * @fcall: pointer to response fcall pointer
- *
- */
-
-int
-v9fs_t_attach(struct v9fs_session_info *v9ses, char *uname, char *aname,
-	      u32 fid, u32 afid, struct v9fs_fcall **rcp)
-{
-	int ret;
-	struct v9fs_fcall* tc;
-
-	dprintk(DEBUG_9P, "uname '%s' aname '%s' fid %d afid %d\n", uname,
-		aname, fid, afid);
-
-	tc = v9fs_create_tattach(fid, afid, uname, aname);
-	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
-		kfree(tc);
-	} else
-		ret = PTR_ERR(tc);
-
-	return ret;
-}
-
-static void v9fs_t_clunk_cb(void *a, struct v9fs_fcall *tc,
-	struct v9fs_fcall *rc, int err)
-{
-	int fid, id;
-	struct v9fs_session_info *v9ses;
-
-	id = 0;
-	fid = tc->params.tclunk.fid;
-	if (rc)
-		id = rc->id;
-
-	kfree(tc);
-	kfree(rc);
-	if (id == RCLUNK) {
-		v9ses = a;
-		v9fs_put_idpool(fid, &v9ses->fidpool);
-	}
-}
-
-/**
- * v9fs_t_clunk - release a fid (finish a transaction)
- * @v9ses: 9P2000 session information
- * @fid: fid to release
- * @fcall: pointer to response fcall pointer
- *
- */
-
-int
-v9fs_t_clunk(struct v9fs_session_info *v9ses, u32 fid)
-{
-	int ret;
-	struct v9fs_fcall *tc, *rc;
-
-	dprintk(DEBUG_9P, "fid %d\n", fid);
-
-	rc = NULL;
-	tc = v9fs_create_tclunk(fid);
-	if (!IS_ERR(tc))
-		ret = v9fs_mux_rpc(v9ses->mux, tc, &rc);
-	else
-		ret = PTR_ERR(tc);
-
-	if (ret)
-		dprintk(DEBUG_ERROR, "failed fid %d err %d\n", fid, ret);
-
-	v9fs_t_clunk_cb(v9ses, tc, rc, ret);
-	return ret;
-}
-
-#if 0
-/**
- * v9fs_v9fs_t_flush - flush a pending transaction
- * @v9ses: 9P2000 session information
- * @tag: tag to release
- *
- */
-int v9fs_t_flush(struct v9fs_session_info *v9ses, u16 oldtag)
-{
-	int ret;
-	struct v9fs_fcall *tc;
-
-	dprintk(DEBUG_9P, "oldtag %d\n", oldtag);
-
-	tc = v9fs_create_tflush(oldtag);
-	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, NULL);
-		kfree(tc);
-	} else
-		ret = PTR_ERR(tc);
-
-	return ret;
-}
-#endif
-
-/**
- * v9fs_t_stat - read a file's meta-data
- * @v9ses: 9P2000 session information
- * @fid: fid pointing to file or directory to get info about
- * @fcall: pointer to response fcall
- *
- */
-
-int
-v9fs_t_stat(struct v9fs_session_info *v9ses, u32 fid, struct v9fs_fcall **rcp)
-{
-	int ret;
-	struct v9fs_fcall *tc;
-
-	dprintk(DEBUG_9P, "fid %d\n", fid);
-
-	ret = -ENOMEM;
-	tc = v9fs_create_tstat(fid);
-	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
-		kfree(tc);
-	} else
-		ret = PTR_ERR(tc);
-
-	return ret;
-}
-
-/**
- * v9fs_t_wstat - write a file's meta-data
- * @v9ses: 9P2000 session information
- * @fid: fid pointing to file or directory to write info about
- * @stat: metadata
- * @fcall: pointer to response fcall
- *
- */
-
-int
-v9fs_t_wstat(struct v9fs_session_info *v9ses, u32 fid,
-	     struct v9fs_wstat *wstat, struct v9fs_fcall **rcp)
-{
-	int ret;
-	struct v9fs_fcall *tc;
-
-	dprintk(DEBUG_9P, "fid %d\n", fid);
-
-	tc = v9fs_create_twstat(fid, wstat, v9ses->extended);
-	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
-		kfree(tc);
-	} else
-		ret = PTR_ERR(tc);
-
-	return ret;
-}
-
-/**
- * v9fs_t_walk - walk a fid to a new file or directory
- * @v9ses: 9P2000 session information
- * @fid: fid to walk
- * @newfid: new fid (for clone operations)
- * @name: path to walk fid to
- * @fcall: pointer to response fcall
- *
- */
-
-/* TODO: support multiple walk */
-
-int
-v9fs_t_walk(struct v9fs_session_info *v9ses, u32 fid, u32 newfid,
-	    char *name, struct v9fs_fcall **rcp)
-{
-	int ret;
-	struct v9fs_fcall *tc;
-	int nwname;
-
-	dprintk(DEBUG_9P, "fid %d newfid %d wname '%s'\n", fid, newfid, name);
-
-	if (name)
-		nwname = 1;
-	else
-		nwname = 0;
-
-	tc = v9fs_create_twalk(fid, newfid, nwname, &name);
-	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
-		kfree(tc);
-	} else
-		ret = PTR_ERR(tc);
-
-	return ret;
-}
-
-/**
- * v9fs_t_open - open a file
- *
- * @v9ses - 9P2000 session information
- * @fid - fid to open
- * @mode - mode to open file (R, RW, etc)
- * @fcall - pointer to response fcall
- *
- */
-
-int
-v9fs_t_open(struct v9fs_session_info *v9ses, u32 fid, u8 mode,
-	    struct v9fs_fcall **rcp)
-{
-	int ret;
-	struct v9fs_fcall *tc;
-
-	dprintk(DEBUG_9P, "fid %d mode %d\n", fid, mode);
-
-	tc = v9fs_create_topen(fid, mode);
-	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
-		kfree(tc);
-	} else
-		ret = PTR_ERR(tc);
-
-	return ret;
-}
-
-/**
- * v9fs_t_remove - remove a file or directory
- * @v9ses: 9P2000 session information
- * @fid: fid to remove
- * @fcall: pointer to response fcall
- *
- */
-
-int
-v9fs_t_remove(struct v9fs_session_info *v9ses, u32 fid,
-	      struct v9fs_fcall **rcp)
-{
-	int ret;
-	struct v9fs_fcall *tc;
-
-	dprintk(DEBUG_9P, "fid %d\n", fid);
-
-	tc = v9fs_create_tremove(fid);
-	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
-		kfree(tc);
-	} else
-		ret = PTR_ERR(tc);
-
-	return ret;
-}
-
-/**
- * v9fs_t_create - create a file or directory
- * @v9ses: 9P2000 session information
- * @fid: fid to create
- * @name: name of the file or directory to create
- * @perm: permissions to create with
- * @mode: mode to open file (R, RW, etc)
- * @fcall: pointer to response fcall
- *
- */
-
-int
-v9fs_t_create(struct v9fs_session_info *v9ses, u32 fid, char *name, u32 perm,
-	u8 mode, char *extension, struct v9fs_fcall **rcp)
-{
-	int ret;
-	struct v9fs_fcall *tc;
-
-	dprintk(DEBUG_9P, "fid %d name '%s' perm %x mode %d\n",
-		fid, name, perm, mode);
-
-	tc = v9fs_create_tcreate(fid, name, perm, mode, extension,
-		v9ses->extended);
-
-	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
-		kfree(tc);
-	} else
-		ret = PTR_ERR(tc);
-
-	return ret;
-}
-
-/**
- * v9fs_t_read - read data
- * @v9ses: 9P2000 session information
- * @fid: fid to read from
- * @offset: offset to start read at
- * @count: how many bytes to read
- * @fcall: pointer to response fcall (with data)
- *
- */
-
-int
-v9fs_t_read(struct v9fs_session_info *v9ses, u32 fid, u64 offset,
-	    u32 count, struct v9fs_fcall **rcp)
-{
-	int ret;
-	struct v9fs_fcall *tc, *rc;
-
-	dprintk(DEBUG_9P, "fid %d offset 0x%llux count 0x%x\n", fid,
-		(long long unsigned) offset, count);
-
-	tc = v9fs_create_tread(fid, offset, count);
-	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, &rc);
-		if (!ret)
-			ret = rc->params.rread.count;
-		if (rcp)
-			*rcp = rc;
-		else
-			kfree(rc);
-
-		kfree(tc);
-	} else
-		ret = PTR_ERR(tc);
-
-	return ret;
-}
-
-/**
- * v9fs_t_write - write data
- * @v9ses: 9P2000 session information
- * @fid: fid to write to
- * @offset: offset to start write at
- * @count: how many bytes to write
- * @fcall: pointer to response fcall
- *
- */
-
-int
-v9fs_t_write(struct v9fs_session_info *v9ses, u32 fid, u64 offset, u32 count,
-	const char __user *data, struct v9fs_fcall **rcp)
-{
-	int ret;
-	struct v9fs_fcall *tc, *rc;
-
-	dprintk(DEBUG_9P, "fid %d offset 0x%llux count 0x%x\n", fid,
-		(long long unsigned) offset, count);
-
-	tc = v9fs_create_twrite(fid, offset, count, data);
-	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, &rc);
-
-		if (!ret)
-			ret = rc->params.rwrite.count;
-		if (rcp)
-			*rcp = rc;
-		else
-			kfree(rc);
-
-		kfree(tc);
-	} else
-		ret = PTR_ERR(tc);
-
-	return ret;
-}
-
diff --git a/fs/9p/fcprint.c b/fs/9p/fcprint.c
index 34b9611..606b48c 100644
--- a/fs/9p/fcprint.c
+++ b/fs/9p/fcprint.c
@@ -29,6 +29,7 @@
 #include "debug.h"
 #include "v9fs.h"
 #include "9p.h"
+#include "transport.h"
 #include "mux.h"

 static int
diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 9041971..693d09d 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -31,6 +31,7 @@
 #include "v9fs.h"
 #include "9p.h"
 #include "v9fs_vfs.h"
+#include "clnt.h"
 #include "fid.h"

 /**
@@ -40,67 +41,28 @@
  *
  */

-int v9fs_fid_insert(struct v9fs_fid *fid, struct dentry *dentry)
+int v9fs_fid_add(struct dentry *dentry, struct v9fs_fid *fid)
 {
-	struct list_head *fid_list = (struct list_head *)dentry->d_fsdata;
-	dprintk(DEBUG_9P, "fid %d (%p) dentry %s (%p)\n", fid->fid, fid,
-		dentry->d_iname, dentry);
-	if (dentry->d_fsdata == NULL) {
-		dentry->d_fsdata =
-		    kmalloc(sizeof(struct list_head), GFP_KERNEL);
-		if (dentry->d_fsdata == NULL) {
-			dprintk(DEBUG_ERROR, "Out of memory\n");
-			return -ENOMEM;
-		}
-		fid_list = (struct list_head *)dentry->d_fsdata;
-		INIT_LIST_HEAD(fid_list);	/* Initialize list head */
-	}
+	struct v9fs_dentry *dent;

-	fid->uid = current->uid;
-	list_add(&fid->list, fid_list);
-	return 0;
-}
+	dprintk(DEBUG_VFS, "fid %d dentry %s\n", fid->fid, dentry->d_iname);

-/**
- * v9fs_fid_create - allocate a FID structure
- * @dentry - dentry to link newly created fid to
- *
- */
-
-struct v9fs_fid *v9fs_fid_create(struct v9fs_session_info *v9ses, int fid)
-{
-	struct v9fs_fid *new;
+	dent = dentry->d_fsdata;
+	if (!dent) {
+		dent = kmalloc(sizeof(struct v9fs_dentry), GFP_KERNEL);
+		if (!dent)
+			return -ENOMEM;

-	dprintk(DEBUG_9P, "fid create fid %d\n", fid);
-	new = kmalloc(sizeof(struct v9fs_fid), GFP_KERNEL);
-	if (new == NULL) {
-		dprintk(DEBUG_ERROR, "Out of Memory\n");
-		return ERR_PTR(-ENOMEM);
+		spin_lock_init(&dent->lock);
+		INIT_LIST_HEAD(&dent->fidlist);
+		dentry->d_fsdata = dent;
 	}

-	new->fid = fid;
-	new->v9ses = v9ses;
-	new->fidopen = 0;
-	new->fidclunked = 0;
-	new->iounit = 0;
-	new->rdir_pos = 0;
-	new->rdir_fcall = NULL;
-	init_MUTEX(&new->lock);
-	INIT_LIST_HEAD(&new->list);
-
-	return new;
-}
-
-/**
- * v9fs_fid_destroy - deallocate a FID structure
- * @fid: fid to destroy
- *
- */
+	spin_lock(&dent->lock);
+	list_add(&fid->dlist, &dent->fidlist);
+	spin_unlock(&dent->lock);

-void v9fs_fid_destroy(struct v9fs_fid *fid)
-{
-	list_del(&fid->list);
-	kfree(fid);
+	return 0;
 }

 /**
@@ -116,25 +78,37 @@ void v9fs_fid_destroy(struct v9fs_fid *fid)

 struct v9fs_fid *v9fs_fid_lookup(struct dentry *dentry)
 {
-	struct list_head *fid_list = (struct list_head *)dentry->d_fsdata;
-	struct v9fs_fid *return_fid = NULL;
-
-	dprintk(DEBUG_9P, " dentry: %s (%p)\n", dentry->d_iname, dentry);
-
-	if (fid_list)
-		return_fid = list_entry(fid_list->next, struct v9fs_fid, list);
+	struct v9fs_dentry *dent;
+	struct v9fs_fid *fid;
+
+	dprintk(DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	dent = dentry->d_fsdata;
+	if (dent)
+		fid = list_entry(dent->fidlist.next, struct v9fs_fid, dlist);
+	else
+		fid = ERR_PTR(-EBADF);
+
+	dprintk(DEBUG_VFS, " fid: %p\n", fid);
+	return fid;
+}

-	if (!return_fid) {
-		dprintk(DEBUG_ERROR, "Couldn't find a fid in dentry\n");
-		return_fid = ERR_PTR(-EBADF);
+struct v9fs_fid *v9fs_fid_lookup_remove(struct dentry *dentry)
+{
+	struct v9fs_fid *fid;
+	struct v9fs_dentry *dent;
+
+	dent = dentry->d_fsdata;
+	fid = v9fs_fid_lookup(dentry);
+	if (!IS_ERR(fid)) {
+		spin_lock(&dent->lock);
+		list_del(&fid->dlist);
+		spin_unlock(&dent->lock);
 	}

-	if(down_interruptible(&return_fid->lock))
-		return ERR_PTR(-EINTR);
-
-	return return_fid;
+	return fid;
 }

+
 /**
  * v9fs_fid_clone - lookup the fid for a dentry, clone a private copy and
  * 			release it
@@ -148,47 +122,13 @@ struct v9fs_fid *v9fs_fid_lookup(struct dentry *dentry)

 struct v9fs_fid *v9fs_fid_clone(struct dentry *dentry)
 {
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
-	struct v9fs_fid *base_fid, *new_fid = ERR_PTR(-EBADF);
-	struct v9fs_fcall *fcall = NULL;
-	int fid, err;
-
-	base_fid = v9fs_fid_lookup(dentry);
-
-	if(IS_ERR(base_fid))
-		return base_fid;
-
-	if(base_fid) {  /* clone fid */
-		fid = v9fs_get_idpool(&v9ses->fidpool);
-		if (fid < 0) {
-			eprintk(KERN_WARNING, "newfid fails!\n");
-			new_fid = ERR_PTR(-ENOSPC);
-			goto Release_Fid;
-		}
-
-		err = v9fs_t_walk(v9ses, base_fid->fid, fid, NULL, &fcall);
-		if (err < 0) {
-			dprintk(DEBUG_ERROR, "clone walk didn't work\n");
-			v9fs_put_idpool(fid, &v9ses->fidpool);
-			new_fid = ERR_PTR(err);
-			goto Free_Fcall;
-		}
-		new_fid = v9fs_fid_create(v9ses, fid);
-		if (new_fid == NULL) {
-			dprintk(DEBUG_ERROR, "out of memory\n");
-			new_fid = ERR_PTR(-ENOMEM);
-		}
-Free_Fcall:
-		kfree(fcall);
-	}
+	struct v9fs_fid *ofid, *fid;

-Release_Fid:
-	up(&base_fid->lock);
-	return new_fid;
-}
+	dprintk(DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	ofid = v9fs_fid_lookup(dentry);
+	if (IS_ERR(ofid))
+		return ofid;

-void v9fs_fid_clunk(struct v9fs_session_info *v9ses, struct v9fs_fid *fid)
-{
-	v9fs_t_clunk(v9ses, fid->fid);
-	v9fs_fid_destroy(fid);
+	fid = v9fs_clnt_walk(ofid, 0, NULL, 1);
+	return fid;
 }
diff --git a/fs/9p/fid.h b/fs/9p/fid.h
index 48fc170..2ae420f 100644
--- a/fs/9p/fid.h
+++ b/fs/9p/fid.h
@@ -22,41 +22,12 @@

 #include <linux/list.h>

-#define FID_OP   0
-#define FID_WALK 1
-#define FID_CREATE 2
-
-struct v9fs_fid {
-	struct list_head list;	 /* list of fids associated with a dentry */
-	struct list_head active; /* XXX - debug */
-
-	struct semaphore lock;
-
-	u32 fid;
-	unsigned char fidopen;	  /* set when fid is opened */
-	unsigned char fidclunked; /* set when fid has already been clunked */
-
-	struct v9fs_qid qid;
-	u32 iounit;
-
-	/* readdir stuff */
-	int rdir_fpos;
-	loff_t rdir_pos;
-	struct v9fs_fcall *rdir_fcall;
-
-	/* management stuff */
-	uid_t uid;		/* user associated with this fid */
-
-	/* private data */
-	struct file *filp;	/* backpointer to File struct for open files */
-	struct v9fs_session_info *v9ses;	/* session info for this FID */
+struct v9fs_dentry {
+	spinlock_t lock;
+	struct list_head fidlist;
 };

 struct v9fs_fid *v9fs_fid_lookup(struct dentry *dentry);
-struct v9fs_fid *v9fs_fid_get_created(struct dentry *);
-void v9fs_fid_destroy(struct v9fs_fid *fid);
-struct v9fs_fid *v9fs_fid_create(struct v9fs_session_info *, int fid);
-int v9fs_fid_insert(struct v9fs_fid *fid, struct dentry *dentry);
+struct v9fs_fid *v9fs_fid_lookup_remove(struct dentry *dentry);
 struct v9fs_fid *v9fs_fid_clone(struct dentry *dentry);
-void v9fs_fid_clunk(struct v9fs_session_info *v9ses, struct v9fs_fid *fid);
-
+int v9fs_fid_add(struct dentry *dentry, struct v9fs_fid *fid);
diff --git a/fs/9p/trans_fd.c b/fs/9p/trans_fd.c
index 34d4335..7fadc82 100644
--- a/fs/9p/trans_fd.c
+++ b/fs/9p/trans_fd.c
@@ -48,6 +48,193 @@ struct v9fs_trans_fd {
 	struct file *wr;
 };

+static int v9fs_socket_open(struct v9fs_transport *trans, struct
socket *csocket);
+static int v9fs_fd_open(struct v9fs_transport *trans, int rfd, int wfd);
+static int v9fs_fd_read(struct v9fs_transport *trans, void *v, int len);
+static int v9fs_fd_write(struct v9fs_transport *trans, void *v, int len);
+static unsigned int v9fs_fd_poll(struct v9fs_transport *trans,
+	struct poll_table_struct *pt);
+static void v9fs_fd_close(struct v9fs_transport *trans);
+
+struct v9fs_transport *v9fs_trans_create_tcp(const char *addr, int port)
+{
+	int err;
+	struct v9fs_transport *trans;
+	struct socket *csocket;
+	struct sockaddr_in sin_server;
+
+	csocket = NULL;
+	trans = kmalloc(sizeof(struct v9fs_transport), GFP_KERNEL);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
+
+	trans->write = v9fs_fd_write;
+	trans->read = v9fs_fd_read;
+	trans->close = v9fs_fd_close;
+	trans->poll = v9fs_fd_poll;
+
+	sin_server.sin_family = AF_INET;
+	sin_server.sin_addr.s_addr = in_aton(addr);
+	sin_server.sin_port = htons(port);
+	sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &csocket);
+
+	if (!csocket) {
+		eprintk(KERN_ERR, "v9fs_trans_tcp: problem creating socket\n");
+		err = -EIO;
+		goto error;
+	}
+
+	err = csocket->ops->connect(csocket,
+				    (struct sockaddr *)&sin_server,
+				    sizeof(struct sockaddr_in), 0);
+	if (err < 0) {
+		eprintk(KERN_ERR,
+			"v9fs_trans_tcp: problem connecting socket to %s\n",
+			addr);
+		goto error;
+	}
+
+	err = v9fs_socket_open(trans, csocket);
+	if (err < 0)
+		goto error;
+
+	return trans;
+
+error:
+	if (csocket)
+		sock_release(csocket);
+
+	kfree(trans);
+	return ERR_PTR(err);
+}
+
+struct v9fs_transport *v9fs_trans_create_unix(const char *addr)
+{
+	int err;
+	struct socket *csocket;
+	struct sockaddr_un sun_server;
+	struct v9fs_transport *trans;
+
+	csocket = NULL;
+	trans = kmalloc(sizeof(struct v9fs_transport), GFP_KERNEL);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
+
+	trans->write = v9fs_fd_write;
+	trans->read = v9fs_fd_read;
+	trans->close = v9fs_fd_close;
+	trans->poll = v9fs_fd_poll;
+
+	if (strlen(addr) > UNIX_PATH_MAX) {
+		eprintk(KERN_ERR, "v9fs_trans_unix: address too long: %s\n",
+			addr);
+		err = -ENAMETOOLONG;
+		goto error;
+	}
+
+	sun_server.sun_family = PF_UNIX;
+	strcpy(sun_server.sun_path, addr);
+	sock_create_kern(PF_UNIX, SOCK_STREAM, 0, &csocket);
+	err = csocket->ops->connect(csocket, (struct sockaddr *)&sun_server,
+			sizeof(struct sockaddr_un) - 1, 0);
+	if (err < 0) {
+		eprintk(KERN_ERR,
+			"v9fs_trans_unix: problem connecting socket: %s: %d\n",
+			addr, err);
+		goto error;
+	}
+
+	err = v9fs_socket_open(trans, csocket);
+	if (err < 0)
+		goto error;
+
+	return trans;
+
+error:
+	if (csocket)
+		sock_release(csocket);
+
+	kfree(trans);
+	return ERR_PTR(err);
+}
+
+struct v9fs_transport *v9fs_trans_create_fd(int rfd, int wfd)
+{
+	int err;
+	struct v9fs_transport *trans;
+
+	if (rfd == ~0 || wfd == ~0) {
+		printk(KERN_ERR "v9fs: Insufficient options for proto=fd\n");
+		return ERR_PTR(-ENOPROTOOPT);
+	}
+
+	trans = kmalloc(sizeof(struct v9fs_transport), GFP_KERNEL);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
+
+	trans->write = v9fs_fd_write;
+	trans->read = v9fs_fd_read;
+	trans->close = v9fs_fd_close;
+	trans->poll = v9fs_fd_poll;
+
+	err = v9fs_fd_open(trans, rfd, wfd);
+	if (err < 0)
+		goto error;
+
+	return trans;
+
+error:
+	kfree(trans);
+	return ERR_PTR(err);
+}
+
+static int v9fs_socket_open(struct v9fs_transport *trans, struct
socket *csocket)
+{
+	int fd, ret;
+
+	csocket->sk->sk_allocation = GFP_NOIO;
+	fd = sock_map_fd(csocket);
+	if (fd < 0) {
+		eprintk(KERN_ERR, "v9fs_socket_open: failed to map fd\n");
+		return fd;
+	}
+
+	ret = v9fs_fd_open(trans, fd, fd);
+	if (ret < 0) {
+		eprintk(KERN_ERR, "v9fs_socket_open: failed to open fd\n");
+		sockfd_put(csocket);
+		return ret;
+	}
+
+	((struct v9fs_trans_fd *)trans->priv)->rd->f_flags |= O_NONBLOCK;
+
+	return 0;
+}
+
+static int v9fs_fd_open(struct v9fs_transport *trans, int rfd, int wfd)
+{
+	struct v9fs_trans_fd *ts = kmalloc(sizeof(struct v9fs_trans_fd),
+					   GFP_KERNEL);
+	if (!ts)
+		return -ENOMEM;
+
+	ts->rd = fget(rfd);
+	ts->wr = fget(wfd);
+	if (!ts->rd || !ts->wr) {
+		if (ts->rd)
+			fput(ts->rd);
+		if (ts->wr)
+			fput(ts->wr);
+		kfree(ts);
+		return -EIO;
+	}
+
+	trans->priv = ts;
+	trans->status = Connected;
+
+	return 0;
+}
+
 /**
  * v9fs_fd_read- read from a fd
  * @v9ses: session information
@@ -139,125 +326,6 @@ v9fs_fd_poll(struct v9fs_transport *trans,
struct poll_table_struct *pt)
 	return ret;
 }

-static int v9fs_fd_open(struct v9fs_session_info *v9ses, int rfd, int wfd)
-{
-	struct v9fs_transport *trans = v9ses->transport;
-	struct v9fs_trans_fd *ts = kmalloc(sizeof(struct v9fs_trans_fd),
-					   GFP_KERNEL);
-	if (!ts)
-		return -ENOMEM;
-
-	ts->rd = fget(rfd);
-	ts->wr = fget(wfd);
-	if (!ts->rd || !ts->wr) {
-		if (ts->rd)
-			fput(ts->rd);
-		if (ts->wr)
-			fput(ts->wr);
-		kfree(ts);
-		return -EIO;
-	}
-
-	trans->priv = ts;
-	trans->status = Connected;
-
-	return 0;
-}
-
-static int v9fs_fd_init(struct v9fs_session_info *v9ses, const char *addr,
-			char *data)
-{
-	if (v9ses->rfdno == ~0 || v9ses->wfdno == ~0) {
-		printk(KERN_ERR "v9fs: Insufficient options for proto=fd\n");
-		return -ENOPROTOOPT;
-	}
-
-	return v9fs_fd_open(v9ses, v9ses->rfdno, v9ses->wfdno);
-}
-
-static int v9fs_socket_open(struct v9fs_session_info *v9ses,
-			    struct socket *csocket)
-{
-	int fd, ret;
-
-	csocket->sk->sk_allocation = GFP_NOIO;
-	if ((fd = sock_map_fd(csocket)) < 0) {
-		eprintk(KERN_ERR, "v9fs_socket_open: failed to map fd\n");
-		ret = fd;
-	      release_csocket:
-		sock_release(csocket);
-		return ret;
-	}
-
-	if ((ret = v9fs_fd_open(v9ses, fd, fd)) < 0) {
-		sockfd_put(csocket);
-		eprintk(KERN_ERR, "v9fs_socket_open: failed to open fd\n");
-		goto release_csocket;
-	}
-
-	((struct v9fs_trans_fd *)v9ses->transport->priv)->rd->f_flags |=
-	    O_NONBLOCK;
-	return 0;
-}
-
-static int v9fs_tcp_init(struct v9fs_session_info *v9ses, const char *addr,
-			 char *data)
-{
-	int ret;
-	struct socket *csocket = NULL;
-	struct sockaddr_in sin_server;
-
-	sin_server.sin_family = AF_INET;
-	sin_server.sin_addr.s_addr = in_aton(addr);
-	sin_server.sin_port = htons(v9ses->port);
-	sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &csocket);
-
-	if (!csocket) {
-		eprintk(KERN_ERR, "v9fs_trans_tcp: problem creating socket\n");
-		return -1;
-	}
-
-	ret = csocket->ops->connect(csocket,
-				    (struct sockaddr *)&sin_server,
-				    sizeof(struct sockaddr_in), 0);
-	if (ret < 0) {
-		eprintk(KERN_ERR,
-			"v9fs_trans_tcp: problem connecting socket to %s\n",
-			addr);
-		return ret;
-	}
-
-	return v9fs_socket_open(v9ses, csocket);
-}
-
-static int
-v9fs_unix_init(struct v9fs_session_info *v9ses, const char *addr, char *data)
-{
-	int ret;
-	struct socket *csocket;
-	struct sockaddr_un sun_server;
-
-	if (strlen(addr) > UNIX_PATH_MAX) {
-		eprintk(KERN_ERR, "v9fs_trans_unix: address too long: %s\n",
-			addr);
-		return -ENAMETOOLONG;
-	}
-
-	sun_server.sun_family = PF_UNIX;
-	strcpy(sun_server.sun_path, addr);
-	sock_create_kern(PF_UNIX, SOCK_STREAM, 0, &csocket);
-	ret = csocket->ops->connect(csocket, (struct sockaddr *)&sun_server,
-			sizeof(struct sockaddr_un) - 1, 0);
-	if (ret < 0) {
-		eprintk(KERN_ERR,
-			"v9fs_trans_unix: problem connecting socket: %s: %d\n",
-			addr, ret);
-		return ret;
-	}
-
-	return v9fs_socket_open(v9ses, csocket);
-}
-
 /**
  * v9fs_sock_close - shutdown socket
  * @trans: private socket structure
@@ -283,26 +351,3 @@ static void v9fs_fd_close(struct v9fs_transport *trans)
 	kfree(ts);
 }

-struct v9fs_transport v9fs_trans_fd = {
-	.init = v9fs_fd_init,
-	.write = v9fs_fd_write,
-	.read = v9fs_fd_read,
-	.close = v9fs_fd_close,
-	.poll = v9fs_fd_poll,
-};
-
-struct v9fs_transport v9fs_trans_tcp = {
-	.init = v9fs_tcp_init,
-	.write = v9fs_fd_write,
-	.read = v9fs_fd_read,
-	.close = v9fs_fd_close,
-	.poll = v9fs_fd_poll,
-};
-
-struct v9fs_transport v9fs_trans_unix = {
-	.init = v9fs_unix_init,
-	.write = v9fs_fd_write,
-	.read = v9fs_fd_read,
-	.close = v9fs_fd_close,
-	.poll = v9fs_fd_poll,
-};
diff --git a/fs/9p/transport.h b/fs/9p/transport.h
index b38a4b8..030d22c 100644
--- a/fs/9p/transport.h
+++ b/fs/9p/transport.h
@@ -33,13 +33,12 @@ struct v9fs_transport {
 	enum v9fs_transport_status status;
 	void *priv;

-	int (*init) (struct v9fs_session_info *, const char *, char *);
 	int (*write) (struct v9fs_transport *, void *, int);
 	int (*read) (struct v9fs_transport *, void *, int);
 	void (*close) (struct v9fs_transport *);
 	unsigned int (*poll)(struct v9fs_transport *, struct poll_table_struct *);
 };

-extern struct v9fs_transport v9fs_trans_tcp;
-extern struct v9fs_transport v9fs_trans_unix;
-extern struct v9fs_transport v9fs_trans_fd;
+struct v9fs_transport *v9fs_trans_create_tcp(const char *addr, int port);
+struct v9fs_transport *v9fs_trans_create_unix(const char *addr);
+struct v9fs_transport *v9fs_trans_create_fd(int rfd, int wfd);
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 6ad6f19..0ce5b78 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -36,6 +36,7 @@
 #include "v9fs_vfs.h"
 #include "transport.h"
 #include "mux.h"
+#include "clnt.h"

 /* TODO: sysfs or debugfs interface */
 int v9fs_debug_level = 0;	/* feature-rific global debug level  */
@@ -266,25 +267,21 @@ int v9fs_check_idpool(int id, struct v9fs_idpool *p)
  *
  */

-int
-v9fs_session_init(struct v9fs_session_info *v9ses,
+struct v9fs_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 		  const char *dev_name, char *data)
 {
-	struct v9fs_fcall *fcall = NULL;
-	struct v9fs_transport *trans_proto;
-	int n = 0;
-	int newfid = -1;
 	int retval = -EINVAL;
-	struct v9fs_str *version;
+	struct v9fs_transport *trans;
+	struct v9fs_fid *fid;

 	v9ses->name = __getname();
 	if (!v9ses->name)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);

 	v9ses->remotename = __getname();
 	if (!v9ses->remotename) {
 		__putname(v9ses->name);
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 	}

 	strcpy(v9ses->name, V9FS_DEFUSER);
@@ -295,127 +292,53 @@ v9fs_session_init(struct v9fs_session_info *v9ses,
 	/* set global debug level */
 	v9fs_debug_level = v9ses->debug;

-	/* id pools that are session-dependent: fids and tags */
-	idr_init(&v9ses->fidpool.pool);
-	init_MUTEX(&v9ses->fidpool.lock);
-
 	switch (v9ses->proto) {
 	case PROTO_TCP:
-		trans_proto = &v9fs_trans_tcp;
+		trans = v9fs_trans_create_tcp(dev_name, v9ses->port);
 		break;
 	case PROTO_UNIX:
-		trans_proto = &v9fs_trans_unix;
+		trans = v9fs_trans_create_unix(dev_name);
 		*v9ses->remotename = 0;
 		break;
 	case PROTO_FD:
-		trans_proto = &v9fs_trans_fd;
+		trans = v9fs_trans_create_fd(v9ses->rfdno, v9ses->wfdno);
 		*v9ses->remotename = 0;
 		break;
 	default:
 		printk(KERN_ERR "v9fs: Bad mount protocol %d\n", v9ses->proto);
 		retval = -ENOPROTOOPT;
-		goto SessCleanUp;
+		goto error;
 	};

-	v9ses->transport = kmalloc(sizeof(*v9ses->transport), GFP_KERNEL);
-	if (!v9ses->transport) {
-		retval = -ENOMEM;
-		goto SessCleanUp;
-	}
-
-	memmove(v9ses->transport, trans_proto, sizeof(*v9ses->transport));
-
-	if ((retval = v9ses->transport->init(v9ses, dev_name, data)) < 0) {
-		eprintk(KERN_ERR, "problem initializing transport\n");
-		goto SessCleanUp;
+	if (IS_ERR(trans)) {
+		retval = PTR_ERR(trans);
+		trans = NULL;
+		goto error;
 	}

-	v9ses->inprogress = 0;
-	v9ses->shutdown = 0;
-	v9ses->session_hung = 0;
-
-	v9ses->mux = v9fs_mux_init(v9ses->transport, v9ses->maxdata + V9FS_IOHDRSZ,
-		&v9ses->extended);
-
-	if (IS_ERR(v9ses->mux)) {
-		retval = PTR_ERR(v9ses->mux);
-		v9ses->mux = NULL;
-		dprintk(DEBUG_ERROR, "problem initializing mux\n");
-		goto SessCleanUp;
-	}
-
-	if (v9ses->afid == ~0) {
-		if (v9ses->extended)
-			retval =
-			    v9fs_t_version(v9ses, v9ses->maxdata, "9P2000.u",
-					   &fcall);
-		else
-			retval = v9fs_t_version(v9ses, v9ses->maxdata, "9P2000",
-						&fcall);
-
-		if (retval < 0) {
-			dprintk(DEBUG_ERROR, "v9fs_t_version failed\n");
-			goto FreeFcall;
-		}
-
-		version = &fcall->params.rversion.version;
-		if (version->len==8 && !memcmp(version->str, "9P2000.u", 8)) {
-			dprintk(DEBUG_9P, "9P2000 UNIX extensions enabled\n");
-			v9ses->extended = 1;
-		} else if (version->len==6 && !memcmp(version->str, "9P2000", 6)) {
-			dprintk(DEBUG_9P, "9P2000 legacy mode enabled\n");
-			v9ses->extended = 0;
-		} else {
-			retval = -EREMOTEIO;
-			goto FreeFcall;
-		}
-
-		n = fcall->params.rversion.msize;
-		kfree(fcall);
-
-		if (n < v9ses->maxdata)
-			v9ses->maxdata = n;
-	}
+	v9ses->clnt = v9fs_clnt_create(trans, v9ses->maxdata + V9FS_IOHDRSZ,
+		v9ses->extended);

-	newfid = v9fs_get_idpool(&v9ses->fidpool);
-	if (newfid < 0) {
-		eprintk(KERN_WARNING, "couldn't allocate FID\n");
-		retval = -ENOMEM;
-		goto SessCleanUp;
-	}
-	/* it is a little bit ugly, but we have to prevent newfid */
-	/* being the same as afid, so if it is, get a new fid     */
-	if (v9ses->afid != ~0 && newfid == v9ses->afid) {
-		newfid = v9fs_get_idpool(&v9ses->fidpool);
-		if (newfid < 0) {
-			eprintk(KERN_WARNING, "couldn't allocate FID\n");
-			retval = -ENOMEM;
-			goto SessCleanUp;
-		}
+	if (IS_ERR(v9ses->clnt)) {
+		retval = PTR_ERR(v9ses->clnt);
+		v9ses->clnt = NULL;
+		dprintk(DEBUG_ERROR, "problem initializing 9p client\n");
+		goto error;
 	}

-	if ((retval =
-	     v9fs_t_attach(v9ses, v9ses->name, v9ses->remotename, newfid,
-			   v9ses->afid, NULL))
-	    < 0) {
+	fid = v9fs_clnt_attach(v9ses->clnt, NULL, v9ses->name, v9ses->remotename);
+	if (IS_ERR(fid)) {
+		retval = PTR_ERR(fid);
+		fid = NULL;
 		dprintk(DEBUG_ERROR, "cannot attach\n");
-		goto SessCleanUp;
+		goto error;
 	}

-	if (v9ses->afid != ~0) {
-		dprintk(DEBUG_ERROR, "afid not equal to ~0\n");
-		if (v9fs_t_clunk(v9ses, v9ses->afid))
-			dprintk(DEBUG_ERROR, "clunk failed\n");
-	}
-
-	return newfid;
-
-      FreeFcall:
-	kfree(fcall);
+	return fid;

-      SessCleanUp:
+error:
 	v9fs_session_close(v9ses);
-	return retval;
+	return ERR_PTR(retval);
 }

 /**
@@ -426,15 +349,9 @@ v9fs_session_init(struct v9fs_session_info *v9ses,

 void v9fs_session_close(struct v9fs_session_info *v9ses)
 {
-	if (v9ses->mux) {
-		v9fs_mux_destroy(v9ses->mux);
-		v9ses->mux = NULL;
-	}
-
-	if (v9ses->transport) {
-		v9ses->transport->close(v9ses->transport);
-		kfree(v9ses->transport);
-		v9ses->transport = NULL;
+	if (v9ses->clnt) {
+		v9fs_clnt_destroy(v9ses->clnt);
+		v9ses->clnt = NULL;
 	}

 	__putname(v9ses->name);
@@ -447,8 +364,7 @@ void v9fs_session_close(struct v9fs_session_info *v9ses)
  */
 void v9fs_session_cancel(struct v9fs_session_info *v9ses) {
 	dprintk(DEBUG_ERROR, "cancel session %p\n", v9ses);
-	v9ses->transport->status = Disconnected;
-	v9fs_mux_cancel(v9ses->mux, -EIO);
+	v9fs_clnt_disconnect(v9ses->clnt);
 }

 extern int v9fs_error_init(void);
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 820bf5c..1eb837e 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -54,15 +54,7 @@ struct v9fs_session_info {
 	unsigned int uid;	/* default uid/muid for legacy support */
 	unsigned int gid;	/* default gid for legacy support */

-	/* book keeping */
-	struct v9fs_idpool fidpool;	/* The FID pool for file descriptors */
-
-	struct v9fs_transport *transport;
-	struct v9fs_mux_data *mux;
-
-	int inprogress;		/* session in progress => true */
-	int shutdown;		/* session shutting down. no more attaches. */
-	unsigned char session_hung;
+	struct v9fs_clnt *clnt;	/* 9p client */
 	struct dentry *debugfs_dir;
 };

@@ -82,7 +74,7 @@ enum {

 extern struct dentry *v9fs_debugfs_root;

-int v9fs_session_init(struct v9fs_session_info *, const char *, char *);
+struct v9fs_fid *v9fs_session_init(struct v9fs_session_info *, const
char *, char *);
 struct v9fs_session_info *v9fs_inode2v9ses(struct inode *);
 void v9fs_session_close(struct v9fs_session_info *v9ses);
 int v9fs_get_idpool(struct v9fs_idpool *p);
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index bed48fa..45278d6 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -38,6 +38,7 @@
 #include "v9fs.h"
 #include "9p.h"
 #include "v9fs_vfs.h"
+#include "clnt.h"
 #include "fid.h"

 /**
@@ -50,55 +51,26 @@

 static int v9fs_vfs_readpage(struct file *filp, struct page *page)
 {
-	char *buffer = NULL;
-	int retval = -EIO;
-	loff_t offset = page_offset(page);
-	int count = PAGE_CACHE_SIZE;
-	struct inode *inode = filp->f_path.dentry->d_inode;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
-	int rsize = v9ses->maxdata - V9FS_IOHDRSZ;
-	struct v9fs_fid *v9f = filp->private_data;
-	struct v9fs_fcall *fcall = NULL;
-	int fid = v9f->fid;
-	int total = 0;
-	int result = 0;
+	int retval;
+	loff_t offset;
+	char *buffer;
+	struct v9fs_fid *fid;

 	dprintk(DEBUG_VFS, "\n");
-
+	fid = filp->private_data;
 	buffer = kmap(page);
-	do {
-		if (count < rsize)
-			rsize = count;
-
-		result = v9fs_t_read(v9ses, fid, offset, rsize, &fcall);
-
-		if (result < 0) {
-			printk(KERN_ERR "v9fs_t_read returned %d\n",
-			       result);
-
-			kfree(fcall);
-			goto UnmapAndUnlock;
-		} else
-			offset += result;
-
-		memcpy(buffer, fcall->params.rread.data, result);
-
-		count -= result;
-		buffer += result;
-		total += result;
-
-		kfree(fcall);
+	offset = page_offset(page);

-		if (result < rsize)
-			break;
-	} while (count);
+	retval = v9fs_clnt_readn(fid, buffer, offset, PAGE_CACHE_SIZE);
+	if (retval < 0)
+		goto done;

-	memset(buffer, 0, count);
+	memset(buffer + retval, 0, PAGE_CACHE_SIZE - retval);
 	flush_dcache_page(page);
 	SetPageUptodate(page);
 	retval = 0;

-UnmapAndUnlock:
+done:
 	kunmap(page);
 	unlock_page(page);
 	return retval;
diff --git a/fs/9p/vfs_dentry.c b/fs/9p/vfs_dentry.c
index ddffd8a..473ee35 100644
--- a/fs/9p/vfs_dentry.c
+++ b/fs/9p/vfs_dentry.c
@@ -39,6 +39,7 @@
 #include "v9fs.h"
 #include "9p.h"
 #include "v9fs_vfs.h"
+#include "clnt.h"
 #include "fid.h"

 /**
@@ -85,26 +86,18 @@ static int v9fs_cached_dentry_delete(struct dentry *dentry)

 void v9fs_dentry_release(struct dentry *dentry)
 {
-	int err;
+	struct v9fs_dentry *dent;
+	struct v9fs_fid *temp, *current_fid;

 	dprintk(DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
-
-	if (dentry->d_fsdata != NULL) {
-		struct list_head *fid_list = dentry->d_fsdata;
-		struct v9fs_fid *temp = NULL;
-		struct v9fs_fid *current_fid = NULL;
-
-		list_for_each_entry_safe(current_fid, temp, fid_list, list) {
-			err = v9fs_t_clunk(current_fid->v9ses, current_fid->fid);
-
-			if (err < 0)
-				dprintk(DEBUG_ERROR, "clunk failed: %d name %s\n",
-					err, dentry->d_iname);
-
-			v9fs_fid_destroy(current_fid);
+	dent = dentry->d_fsdata;
+	if (dent) {
+		list_for_each_entry_safe(current_fid, temp, &dent->fidlist, dlist) {
+			v9fs_clnt_clunk(current_fid);
 		}

-		kfree(dentry->d_fsdata);	/* free the list_head */
+		kfree(dent);
+		dentry->d_fsdata = NULL;
 	}
 }

diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 3129688..3a395d8 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -39,6 +39,7 @@
 #include "9p.h"
 #include "conv.h"
 #include "v9fs_vfs.h"
+#include "clnt.h"
 #include "fid.h"

 /**
@@ -70,106 +71,39 @@ static inline int dt_type(struct v9fs_stat *mistat)

 static int v9fs_dir_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
-	struct v9fs_fcall *fcall = NULL;
-	struct inode *inode = filp->f_path.dentry->d_inode;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
-	struct v9fs_fid *file = filp->private_data;
-	unsigned int i, n, s;
-	int fid = -1;
-	int ret = 0;
-	struct v9fs_stat stat;
-	int over = 0;
+	int over;
+	struct v9fs_fid *fid;
+	struct v9fs_session_info *v9ses;
+	struct inode *inode;
+	struct v9fs_stat *st;

 	dprintk(DEBUG_VFS, "name %s\n", filp->f_path.dentry->d_name.name);
-
-	fid = file->fid;
-
-	if (file->rdir_fcall && (filp->f_pos != file->rdir_pos)) {
-		kfree(file->rdir_fcall);
-		file->rdir_fcall = NULL;
-	}
-
-	if (file->rdir_fcall) {
-		n = file->rdir_fcall->params.rread.count;
-		i = file->rdir_fpos;
-		while (i < n) {
-			s = v9fs_deserialize_stat(
-				file->rdir_fcall->params.rread.data + i,
-				n - i, &stat, v9ses->extended);
-
-			if (s == 0) {
-				dprintk(DEBUG_ERROR,
-					"error while deserializing stat\n");
-				ret = -EIO;
-				goto FreeStructs;
-			}
-
-			over = filldir(dirent, stat.name.str, stat.name.len,
-				    filp->f_pos, v9fs_qid2ino(&stat.qid),
-				    dt_type(&stat));
-
-			if (over) {
-				file->rdir_fpos = i;
-				file->rdir_pos = filp->f_pos;
-				break;
-			}
-
-			i += s;
-			filp->f_pos += s;
-		}
-
-		if (!over) {
-			kfree(file->rdir_fcall);
-			file->rdir_fcall = NULL;
-		}
-	}
-
-	while (!over) {
-		ret = v9fs_t_read(v9ses, fid, filp->f_pos,
-			v9ses->maxdata-V9FS_IOHDRSZ, &fcall);
-		if (ret < 0) {
-			dprintk(DEBUG_ERROR, "error while reading: %d: %p\n",
-				ret, fcall);
-			goto FreeStructs;
-		} else if (ret == 0)
+	inode = filp->f_path.dentry->d_inode;
+	v9ses = v9fs_inode2v9ses(inode);
+	fid = filp->private_data;
+	while (1) {
+		st = v9fs_clnt_dirread(fid, filp->f_pos);
+		if (IS_ERR(st))
+			return PTR_ERR(st);
+		else if (!st)
 			break;

-		n = ret;
-		i = 0;
-		while (i < n) {
-			s = v9fs_deserialize_stat(fcall->params.rread.data + i,
-				n - i, &stat, v9ses->extended);
-
-			if (s == 0) {
-				dprintk(DEBUG_ERROR,
-					"error while deserializing stat\n");
-				return -EIO;
-			}
-
-			over = filldir(dirent, stat.name.str, stat.name.len,
-				    filp->f_pos, v9fs_qid2ino(&stat.qid),
-				    dt_type(&stat));
-
-			if (over) {
-				file->rdir_fcall = fcall;
-				file->rdir_fpos = i;
-				file->rdir_pos = filp->f_pos;
-				fcall = NULL;
+		over = filldir(dirent, st->name.str, st->name.len, filp->f_pos,
+			v9fs_qid2ino(&st->qid), dt_type(st));
+
+		if (over)
 				break;
-			}

-			i += s;
-			filp->f_pos += s;
+		filp->f_pos += st->size;
+		kfree(st);
+		st = NULL;
 		}

-		kfree(fcall);
-	}
-
-      FreeStructs:
-	kfree(fcall);
-	return ret;
+	kfree(st);
+	return 0;
 }

+
 /**
  * v9fs_dir_release - close a directory
  * @inode: inode of the directory
@@ -179,29 +113,12 @@ static int v9fs_dir_readdir(struct file *filp,
void *dirent, filldir_t filldir)

 int v9fs_dir_release(struct inode *inode, struct file *filp)
 {
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
-	struct v9fs_fid *fid = filp->private_data;
-	int fidnum = -1;
-
-	dprintk(DEBUG_VFS, "inode: %p filp: %p fid: %d\n", inode, filp,
-		fid->fid);
-	fidnum = fid->fid;
+	struct v9fs_fid *fid;

+	fid = filp->private_data;
+	dprintk(DEBUG_VFS, "inode: %p filp: %p fid: %d\n", inode, filp, fid->fid);
 	filemap_write_and_wait(inode->i_mapping);
-
-	if (fidnum >= 0) {
-		dprintk(DEBUG_VFS, "fidopen: %d v9f->fid: %d\n", fid->fidopen,
-			fid->fid);
-
-		if (v9fs_t_clunk(v9ses, fidnum))
-			dprintk(DEBUG_ERROR, "clunk failed\n");
-
-		kfree(fid->rdir_fcall);
-		kfree(fid);
-
-		filp->private_data = NULL;
-	}
-
+	v9fs_clnt_clunk(fid);
 	return 0;
 }

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index c7b6772..2833ad3 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -40,6 +40,7 @@
 #include "v9fs.h"
 #include "9p.h"
 #include "v9fs_vfs.h"
+#include "clnt.h"
 #include "fid.h"

 static const struct file_operations v9fs_cached_file_operations;
@@ -53,35 +54,29 @@ static const struct file_operations
v9fs_cached_file_operations;

 int v9fs_file_open(struct inode *inode, struct file *file)
 {
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
-	struct v9fs_fid *vfid;
-	struct v9fs_fcall *fcall = NULL;
-	int omode;
 	int err;
+	struct v9fs_session_info *v9ses;
+	struct v9fs_fid *fid;
+	int omode;

 	dprintk(DEBUG_VFS, "inode: %p file: %p \n", inode, file);
-
-	vfid = v9fs_fid_clone(file->f_path.dentry);
-	if (IS_ERR(vfid))
-		return PTR_ERR(vfid);
-
+	v9ses = v9fs_inode2v9ses(inode);
 	omode = v9fs_uflags2omode(file->f_flags);
-	err = v9fs_t_open(v9ses, vfid->fid, omode, &fcall);
+	fid = file->private_data;
+	if (!fid) {
+		fid = v9fs_fid_clone(file->f_path.dentry);
+		if (IS_ERR(fid))
+			return PTR_ERR(fid);
+
+		err = v9fs_clnt_open(fid, omode);
 	if (err < 0) {
-		PRINT_FCALL_ERROR("open failed", fcall);
-		goto Clunk_Fid;
+			v9fs_clnt_clunk(fid);
+			return err;
+		}
 	}

-	file->private_data = vfid;
-	vfid->fidopen = 1;
-	vfid->fidclunked = 0;
-	vfid->iounit = fcall->params.ropen.iounit;
-	vfid->rdir_pos = 0;
-	vfid->rdir_fcall = NULL;
-	vfid->filp = file;
-	kfree(fcall);
-
-	if((vfid->qid.version) && (v9ses->cache)) {
+	file->private_data = fid;
+	if((fid->qid.version) && (v9ses->cache)) {
 		dprintk(DEBUG_VFS, "cached");
 		/* enable cached file options */
 		if(file->f_op == &v9fs_file_operations)
@@ -89,12 +84,6 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 	}

 	return 0;
-
-Clunk_Fid:
-	v9fs_fid_clunk(v9ses, vfid);
-	kfree(fcall);
-
-	return err;
 }

 /**
@@ -137,55 +126,16 @@ static ssize_t
 v9fs_file_read(struct file *filp, char __user * data, size_t count,
 	       loff_t * offset)
 {
-	struct inode *inode = filp->f_path.dentry->d_inode;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
-	struct v9fs_fid *v9f = filp->private_data;
-	struct v9fs_fcall *fcall = NULL;
-	int fid = v9f->fid;
-	int rsize = 0;
-	int result = 0;
-	int total = 0;
-	int n;
+	int ret;
+	struct v9fs_fid *fid;

 	dprintk(DEBUG_VFS, "\n");
+	fid = filp->private_data;
+	ret = v9fs_clnt_uread(fid, data, *offset, count);
+	if (ret > 0)
+		*offset += ret;

-	rsize = v9ses->maxdata - V9FS_IOHDRSZ;
-	if (v9f->iounit != 0 && rsize > v9f->iounit)
-		rsize = v9f->iounit;
-
-	do {
-		if (count < rsize)
-			rsize = count;
-
-		result = v9fs_t_read(v9ses, fid, *offset, rsize, &fcall);
-
-		if (result < 0) {
-			printk(KERN_ERR "9P2000: v9fs_t_read returned %d\n",
-			       result);
-
-			kfree(fcall);
-			return total;
-		} else
-			*offset += result;
-
-		n = copy_to_user(data, fcall->params.rread.data, result);
-		if (n) {
-			dprintk(DEBUG_ERROR, "Problem copying to user %d\n", n);
-			kfree(fcall);
-			return -EFAULT;
-		}
-
-		count -= result;
-		data += result;
-		total += result;
-
-		kfree(fcall);
-
-		if (result < rsize)
-			break;
-	} while (count);
-
-	return total;
+	return ret;
 }

 /**
@@ -201,50 +151,19 @@ static ssize_t
 v9fs_file_write(struct file *filp, const char __user * data,
 		size_t count, loff_t * offset)
 {
-	struct inode *inode = filp->f_path.dentry->d_inode;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
-	struct v9fs_fid *v9fid = filp->private_data;
-	struct v9fs_fcall *fcall;
-	int fid = v9fid->fid;
-	int result = -EIO;
-	int rsize = 0;
-	int total = 0;
+	int ret;
+	struct v9fs_fid *fid;

 	dprintk(DEBUG_VFS, "data %p count %d offset %x\n", data, (int)count,
 		(int)*offset);
-	rsize = v9ses->maxdata - V9FS_IOHDRSZ;
-	if (v9fid->iounit != 0 && rsize > v9fid->iounit)
-		rsize = v9fid->iounit;
-
-	do {
-		if (count < rsize)
-			rsize = count;
-
-		result = v9fs_t_write(v9ses, fid, *offset, rsize, data, &fcall);
-		if (result < 0) {
-			PRINT_FCALL_ERROR("error while writing", fcall);
-			kfree(fcall);
-			return result;
-		} else
-			*offset += result;
-
-		kfree(fcall);
-		fcall = NULL;
-
-		if (result != rsize) {
-			eprintk(KERN_ERR,
-				"short write: v9fs_t_write returned %d\n",
-				result);
-			break;
-		}

-		count -= result;
-		data += result;
-		total += result;
-	} while (count);
+	fid = filp->private_data;
+	ret = v9fs_clnt_uwrite(fid, data, *offset, count);
+	if (ret > 0)
+		*offset += ret;

-	invalidate_inode_pages2(inode->i_mapping);
-	return total;
+	invalidate_inode_pages2(filp->f_path.dentry->d_inode->i_mapping);
+	return ret;
 }

 static const struct file_operations v9fs_cached_file_operations = {
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index b01b0a4..1988b5b 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -40,6 +40,7 @@
 #include "9p.h"
 #include "v9fs_vfs.h"
 #include "fid.h"
+#include "clnt.h"

 static const struct inode_operations v9fs_dir_inode_operations;
 static const struct inode_operations v9fs_dir_inode_operations_ext;
@@ -252,60 +253,7 @@ struct inode *v9fs_get_inode(struct super_block
*sb, int mode)
 	return inode;
 }

-static int
-v9fs_create(struct v9fs_session_info *v9ses, u32 pfid, char *name, u32 perm,
-	u8 mode, char *extension, u32 *fidp, struct v9fs_qid *qid, u32 *iounit)
-{
-	int fid;
-	int err;
-	struct v9fs_fcall *fcall;
-
-	fid = v9fs_get_idpool(&v9ses->fidpool);
-	if (fid < 0) {
-		eprintk(KERN_WARNING, "no free fids available\n");
-		return -ENOSPC;
-	}
-
-	err = v9fs_t_walk(v9ses, pfid, fid, NULL, &fcall);
-	if (err < 0) {
-		PRINT_FCALL_ERROR("clone error", fcall);
-		if (fcall && fcall->id == RWALK)
-			goto clunk_fid;
-		else
-			goto put_fid;
-	}
-	kfree(fcall);
-
-	err = v9fs_t_create(v9ses, fid, name, perm, mode, extension, &fcall);
-	if (err < 0) {
-		PRINT_FCALL_ERROR("create fails", fcall);
-		goto clunk_fid;
-	}
-
-	if (iounit)
-		*iounit = fcall->params.rcreate.iounit;
-
-	if (qid)
-		*qid = fcall->params.rcreate.qid;
-
-	if (fidp)
-		*fidp = fid;
-
-	kfree(fcall);
-	return 0;
-
-clunk_fid:
-	v9fs_t_clunk(v9ses, fid);
-	fid = V9FS_NOFID;
-
-put_fid:
-	if (fid != V9FS_NOFID)
-		v9fs_put_idpool(fid, &v9ses->fidpool);
-
-	kfree(fcall);
-	return err;
-}
-
+/*
 static struct v9fs_fid*
 v9fs_clone_walk(struct v9fs_session_info *v9ses, u32 fid, struct
dentry *dentry)
 {
@@ -355,23 +303,25 @@ error:
 	kfree(fcall);
 	return ERR_PTR(err);
 }
+*/

 static struct inode *
-v9fs_inode_from_fid(struct v9fs_session_info *v9ses, u32 fid,
+v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct v9fs_fid *fid,
 	struct super_block *sb)
 {
 	int err, umode;
 	struct inode *ret;
-	struct v9fs_fcall *fcall;
+	struct v9fs_stat *st;

 	ret = NULL;
-	err = v9fs_t_stat(v9ses, fid, &fcall);
-	if (err) {
-		PRINT_FCALL_ERROR("stat error", fcall);
+	st = v9fs_clnt_stat(fid);
+	if (IS_ERR(st)) {
+		err = PTR_ERR(st);
+		st = NULL;
 		goto error;
 	}

-	umode = p9mode2unixmode(v9ses, fcall->params.rstat.stat.mode);
+	umode = p9mode2unixmode(v9ses, st->mode);
 	ret = v9fs_get_inode(sb, umode);
 	if (IS_ERR(ret)) {
 		err = PTR_ERR(ret);
@@ -379,12 +329,13 @@ v9fs_inode_from_fid(struct v9fs_session_info
*v9ses, u32 fid,
 		goto error;
 	}

-	v9fs_stat2inode(&fcall->params.rstat.stat, ret, sb);
-	kfree(fcall);
+	v9fs_stat2inode(st, ret, sb);
+	ret->i_ino = v9fs_qid2ino(&st->qid);
+	kfree(st);
 	return ret;

 error:
-	kfree(fcall);
+	kfree(st);
 	if (ret)
 		iput(ret);

@@ -401,43 +352,20 @@ error:

 static int v9fs_remove(struct inode *dir, struct dentry *file, int rmdir)
 {
-	struct v9fs_fcall *fcall = NULL;
-	struct super_block *sb = NULL;
-	struct v9fs_session_info *v9ses = NULL;
-	struct v9fs_fid *v9fid = NULL;
-	struct inode *file_inode = NULL;
-	int fid = -1;
-	int result = 0;
+	struct inode *file_inode;
+	struct v9fs_session_info *v9ses;
+	struct v9fs_fid *v9fid;

 	dprintk(DEBUG_VFS, "inode: %p dentry: %p rmdir: %d\n", dir, file,
 		rmdir);

 	file_inode = file->d_inode;
-	sb = file_inode->i_sb;
 	v9ses = v9fs_inode2v9ses(file_inode);
 	v9fid = v9fs_fid_clone(file);
 	if(IS_ERR(v9fid))
 		return PTR_ERR(v9fid);

-	fid = v9fid->fid;
-	if (fid < 0) {
-		dprintk(DEBUG_ERROR, "inode #%lu, no fid!\n",
-			file_inode->i_ino);
-		return -EBADF;
-	}
-
-	result = v9fs_t_remove(v9ses, fid, &fcall);
-	if (result < 0) {
-		PRINT_FCALL_ERROR("remove fails", fcall);
-		goto Error;
-	}
-
-	v9fs_put_idpool(fid, &v9ses->fidpool);
-	v9fs_fid_destroy(v9fid);
-
-Error:
-	kfree(fcall);
-	return result;
+	return v9fs_clnt_remove(v9fid);
 }

 static int
@@ -446,61 +374,58 @@ v9fs_open_created(struct inode *inode, struct file *file)
 	return 0;
 }

+
 /**
- * v9fs_vfs_create - VFS hook to create files
- * @inode: directory inode that is being deleted
- * @dentry:  dentry that is being deleted
- * @mode: create permissions
- * @nd: path information
+ * v9fs_create - Create a file
+ * @dentry:  dentry that is being created
+ * @perm: create permissions
+ * @mode: open mode
  *
  */
-
-static int
-v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
+static struct v9fs_fid *v9fs_create(struct v9fs_session_info *v9ses,
struct inode *dir,
+	struct dentry *dentry, char *extension, u32 perm, u8 mode)
 {
 	int err;
-	u32 fid, perm, iounit;
-	int flags;
-	struct v9fs_session_info *v9ses;
-	struct v9fs_fid *dfid, *vfid, *ffid;
+	char *name;
+	struct v9fs_fid *dfid, *ofid, *fid;
 	struct inode *inode;
-	struct v9fs_qid qid;
-	struct file *filp;

-	inode = NULL;
-	vfid = NULL;
-	v9ses = v9fs_inode2v9ses(dir);
+	err = 0;
+	ofid = NULL;
+	fid = NULL;
+	name = (char *) dentry->d_name.name;
 	dfid = v9fs_fid_clone(dentry->d_parent);
 	if(IS_ERR(dfid)) {
 		err = PTR_ERR(dfid);
+		dfid = NULL;
 		goto error;
 	}

-	perm = unixmode2p9mode(v9ses, mode);
-	if (nd && nd->flags & LOOKUP_OPEN)
-		flags = nd->intent.open.flags - 1;
-	else
-		flags = O_RDWR;
-
-	err = v9fs_create(v9ses, dfid->fid, (char *) dentry->d_name.name,
-		perm, v9fs_uflags2omode(flags), NULL, &fid, &qid, &iounit);
+	/* clone a fid to use for creation */
+	ofid = v9fs_clnt_walk(dfid, 0, NULL, 1);
+	if (IS_ERR(ofid)) {
+		err = PTR_ERR(ofid);
+		ofid = NULL;
+		goto error;
+	}

-	if (err)
-		goto clunk_dfid;
+	err = v9fs_clnt_fcreate(ofid, name, perm, mode, extension);
+	if (err < 0)
+		goto error;

-	vfid = v9fs_clone_walk(v9ses, dfid->fid, dentry);
-	v9fs_fid_clunk(v9ses, dfid);
-	if (IS_ERR(vfid)) {
-		err = PTR_ERR(vfid);
-		vfid = NULL;
+	/* now walk from the parent so we can get unopened fid */
+	fid = v9fs_clnt_walk(dfid, 1, &name, 0);
+	if (IS_ERR(fid)) {
+		err = PTR_ERR(fid);
+		fid = NULL;
 		goto error;
-	}
+	} else
+		dfid = NULL;

-	inode = v9fs_inode_from_fid(v9ses, vfid->fid, dir->i_sb);
+	/* instantiate inode and assign the unopened fid to the dentry */
+	inode = v9fs_inode_from_fid(v9ses, fid, dir->i_sb);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
-		inode = NULL;
 		goto error;
 	}

@@ -508,35 +433,77 @@ v9fs_vfs_create(struct inode *dir, struct dentry
*dentry, int mode,
 		dentry->d_op = &v9fs_cached_dentry_operations;
 	else
 		dentry->d_op = &v9fs_dentry_operations;
+
 	d_instantiate(dentry, inode);
+	v9fs_fid_add(dentry, fid);
+	return ofid;

-	if (nd && nd->flags & LOOKUP_OPEN) {
-		ffid = v9fs_fid_create(v9ses, fid);
-		if (!ffid)
-			return -ENOMEM;
+error:
+	if (dfid)
+		v9fs_clnt_clunk(dfid);
+
+	if (ofid)
+		v9fs_clnt_clunk(ofid);
+
+	if (fid)
+		v9fs_clnt_clunk(fid);

+	return ERR_PTR(err);
+}
+
+/**
+ * v9fs_vfs_create - VFS hook to create files
+ * @inode: directory inode that is being created
+ * @dentry:  dentry that is being deleted
+ * @mode: create permissions
+ * @nd: path information
+ *
+ */
+
+static int
+v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
+		struct nameidata *nd)
+{
+	int err;
+	u32 perm;
+	int flags;
+	struct v9fs_session_info *v9ses;
+	struct v9fs_fid *fid;
+	struct file *filp;
+
+	err = 0;
+	fid = NULL;
+	v9ses = v9fs_inode2v9ses(dir);
+	perm = unixmode2p9mode(v9ses, mode);
+	if (nd && nd->flags & LOOKUP_OPEN)
+		flags = nd->intent.open.flags - 1;
+	else
+		flags = O_RDWR;
+
+	fid = v9fs_create(v9ses, dir, dentry, NULL, perm, v9fs_uflags2omode(flags));
+	if (IS_ERR(fid)) {
+		err = PTR_ERR(fid);
+		fid = NULL;
+		goto error;
+	}
+
+	/* if we are opening a file, assign the open fid to the file */
+	if (nd && nd->flags & LOOKUP_OPEN) {
 		filp = lookup_instantiate_filp(nd, dentry, v9fs_open_created);
 		if (IS_ERR(filp)) {
-			v9fs_fid_destroy(ffid);
-			return PTR_ERR(filp);
+			err = PTR_ERR(filp);
+			goto error;
 		}

-		ffid->rdir_pos = 0;
-		ffid->rdir_fcall = NULL;
-		ffid->fidopen = 1;
-		ffid->iounit = iounit;
-		ffid->filp = filp;
-		filp->private_data = ffid;
-	}
+		filp->private_data = fid;
+	} else
+		v9fs_clnt_clunk(fid);

 	return 0;

-clunk_dfid:
-	v9fs_fid_clunk(v9ses, dfid);
-
 error:
-	if (vfid)
-		v9fs_fid_destroy(vfid);
+	if (fid)
+		v9fs_clnt_clunk(fid);

 	return err;
 }
@@ -552,57 +519,23 @@ error:
 static int v9fs_vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
 	int err;
-	u32 fid, perm;
+	u32 perm;
 	struct v9fs_session_info *v9ses;
-	struct v9fs_fid *dfid, *vfid;
-	struct inode *inode;
+	struct v9fs_fid *fid;

-	inode = NULL;
-	vfid = NULL;
+	dprintk(DEBUG_VFS, "name %s\n", dentry->d_name.name);
+	err = 0;
 	v9ses = v9fs_inode2v9ses(dir);
-	dfid = v9fs_fid_clone(dentry->d_parent);
-	if(IS_ERR(dfid)) {
-		err = PTR_ERR(dfid);
-		goto error;
-	}
-
 	perm = unixmode2p9mode(v9ses, mode | S_IFDIR);
-
-	err = v9fs_create(v9ses, dfid->fid, (char *) dentry->d_name.name,
-		perm, V9FS_OREAD, NULL, &fid, NULL, NULL);
-
-	if (err) {
-		dprintk(DEBUG_ERROR, "create error %d\n", err);
-		goto clean_up_dfid;
+	fid = v9fs_create(v9ses, dir, dentry, NULL, perm, V9FS_OREAD);
+	if (IS_ERR(fid)) {
+		err = PTR_ERR(fid);
+		fid = NULL;
 	}

-	vfid = v9fs_clone_walk(v9ses, dfid->fid, dentry);
-	if (IS_ERR(vfid)) {
-		err = PTR_ERR(vfid);
-		vfid = NULL;
-		goto clean_up_dfid;
-	}
-
-	v9fs_fid_clunk(v9ses, dfid);
-	inode = v9fs_inode_from_fid(v9ses, vfid->fid, dir->i_sb);
-	if (IS_ERR(inode)) {
-		err = PTR_ERR(inode);
-		inode = NULL;
-		v9fs_fid_destroy(vfid);
-		goto error;
-	}
-
-	if(v9ses->cache)
-		dentry->d_op = &v9fs_cached_dentry_operations;
-	else
-		dentry->d_op = &v9fs_dentry_operations;
-	d_instantiate(dentry, inode);
-	return 0;
-
-clean_up_dfid:
-	v9fs_fid_clunk(v9ses, dfid);
+	if (fid)
+		v9fs_clnt_clunk(fid);

-error:
 	return err;
 }

@@ -619,12 +552,9 @@ static struct dentry *v9fs_vfs_lookup(struct
inode *dir, struct dentry *dentry,
 {
 	struct super_block *sb;
 	struct v9fs_session_info *v9ses;
-	struct v9fs_fid *dirfid;
-	struct v9fs_fid *fid;
+	struct v9fs_fid *dfid, *fid;
 	struct inode *inode;
-	struct v9fs_fcall *fcall = NULL;
-	int dirfidnum = -1;
-	int newfid = -1;
+	char *name;
 	int result = 0;

 	dprintk(DEBUG_VFS, "dir: %p dentry: (%s) %p nameidata: %p\n",
@@ -632,91 +562,44 @@ static struct dentry *v9fs_vfs_lookup(struct
inode *dir, struct dentry *dentry,

 	sb = dir->i_sb;
 	v9ses = v9fs_inode2v9ses(dir);
-	dirfid = v9fs_fid_lookup(dentry->d_parent);
-
-	if(IS_ERR(dirfid))
-		return ERR_PTR(PTR_ERR(dirfid));
-
-	dirfidnum = dirfid->fid;
-
-	newfid = v9fs_get_idpool(&v9ses->fidpool);
-	if (newfid < 0) {
-		eprintk(KERN_WARNING, "newfid fails!\n");
-		result = -ENOSPC;
-		goto Release_Dirfid;
-	}
-
-	result = v9fs_t_walk(v9ses, dirfidnum, newfid,
-		(char *)dentry->d_name.name, &fcall);
-
-	up(&dirfid->lock);
-
-	if (result < 0) {
-		if (fcall && fcall->id == RWALK)
-			v9fs_t_clunk(v9ses, newfid);
-		else
-			v9fs_put_idpool(newfid, &v9ses->fidpool);
-
+	dfid = v9fs_fid_lookup(dentry->d_parent);
+	if(IS_ERR(dfid))
+		return ERR_PTR(PTR_ERR(dfid));
+
+	name = (char *) dentry->d_name.name;
+	fid = v9fs_clnt_walk(dfid, 1, &name, 1);
+	if (IS_ERR(fid)) {
+		result = PTR_ERR(fid);
 		if (result == -ENOENT) {
 			d_add(dentry, NULL);
-			dprintk(DEBUG_VFS,
-				"Return negative dentry %p count %d\n",
-				dentry, atomic_read(&dentry->d_count));
-			kfree(fcall);
 			return NULL;
 		}
-		dprintk(DEBUG_ERROR, "walk error:%d\n", result);
-		goto FreeFcall;
-	}
-	kfree(fcall);
-
-	result = v9fs_t_stat(v9ses, newfid, &fcall);
-	if (result < 0) {
-		dprintk(DEBUG_ERROR, "stat error\n");
-		goto FreeFcall;
-	}
-
-	inode = v9fs_get_inode(sb, p9mode2unixmode(v9ses,
-		fcall->params.rstat.stat.mode));

-	if (IS_ERR(inode) && (PTR_ERR(inode) == -ENOSPC)) {
-		eprintk(KERN_WARNING, "inode alloc failes, returns %ld\n",
-			PTR_ERR(inode));
-
-		result = -ENOSPC;
-		goto FreeFcall;
+		return ERR_PTR(result);
 	}

-	inode->i_ino = v9fs_qid2ino(&fcall->params.rstat.stat.qid);
-
-	fid = v9fs_fid_create(v9ses, newfid);
-	if (fid == NULL) {
-		dprintk(DEBUG_ERROR, "couldn't insert\n");
-		result = -ENOMEM;
-		goto FreeFcall;
+	inode = v9fs_inode_from_fid(v9ses, fid, dir->i_sb);
+	if (IS_ERR(inode)) {
+		result = PTR_ERR(inode);
+		inode = NULL;
+		goto error;
 	}

-	result = v9fs_fid_insert(fid, dentry);
+	result = v9fs_fid_add(dentry, fid);
 	if (result < 0)
-		goto FreeFcall;
+		goto error;

-	fid->qid = fcall->params.rstat.stat.qid;
-	v9fs_stat2inode(&fcall->params.rstat.stat, inode, inode->i_sb);
 	if((fid->qid.version)&&(v9ses->cache))
 		dentry->d_op = &v9fs_cached_dentry_operations;
 	else
 		dentry->d_op = &v9fs_dentry_operations;

 	d_add(dentry, inode);
-	kfree(fcall);
-
 	return NULL;

-Release_Dirfid:
-	up(&dirfid->lock);
-
-FreeFcall:
-	kfree(fcall);
+error:
+	if (fid)
+		v9fs_clnt_clunk(fid);

 	return ERR_PTR(result);
 }
@@ -758,73 +641,53 @@ static int
 v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		struct inode *new_dir, struct dentry *new_dentry)
 {
-	struct inode *old_inode = old_dentry->d_inode;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(old_inode);
-	struct v9fs_fid *oldfid = v9fs_fid_lookup(old_dentry);
+	struct inode *old_inode;
+	struct v9fs_session_info *v9ses;
+	struct v9fs_fid *oldfid;
 	struct v9fs_fid *olddirfid;
 	struct v9fs_fid *newdirfid;
 	struct v9fs_wstat wstat;
-	struct v9fs_fcall *fcall = NULL;
-	int fid = -1;
-	int olddirfidnum = -1;
-	int newdirfidnum = -1;
-	int retval = 0;
+	int retval;

 	dprintk(DEBUG_VFS, "\n");
-
+	retval = 0;
+	old_inode = old_dentry->d_inode;
+	v9ses = v9fs_inode2v9ses(old_inode);
+	oldfid = v9fs_fid_lookup(old_dentry);
 	if(IS_ERR(oldfid))
 		return PTR_ERR(oldfid);

 	olddirfid = v9fs_fid_clone(old_dentry->d_parent);
 	if(IS_ERR(olddirfid)) {
 		retval = PTR_ERR(olddirfid);
-		goto Release_lock;
+		goto done;
 	}

 	newdirfid = v9fs_fid_clone(new_dentry->d_parent);
 	if(IS_ERR(newdirfid)) {
 		retval = PTR_ERR(newdirfid);
-		goto Clunk_olddir;
+		goto clunk_olddir;
 	}

 	/* 9P can only handle file rename in the same directory */
 	if (memcmp(&olddirfid->qid, &newdirfid->qid, sizeof(newdirfid->qid))) {
 		dprintk(DEBUG_ERROR, "old dir and new dir are different\n");
 		retval = -EXDEV;
-		goto Clunk_newdir;
-	}
-
-	fid = oldfid->fid;
-	olddirfidnum = olddirfid->fid;
-	newdirfidnum = newdirfid->fid;
-
-	if (fid < 0) {
-		dprintk(DEBUG_ERROR, "no fid for old file #%lu\n",
-			old_inode->i_ino);
-		retval = -EBADF;
-		goto Clunk_newdir;
+		goto clunk_newdir;
 	}

 	v9fs_blank_wstat(&wstat);
 	wstat.muid = v9ses->name;
 	wstat.name = (char *) new_dentry->d_name.name;
+	retval = v9fs_clnt_wstat(oldfid, &wstat);

-	retval = v9fs_t_wstat(v9ses, fid, &wstat, &fcall);
-
-	if (retval < 0)
-		PRINT_FCALL_ERROR("wstat error", fcall);
-
-	kfree(fcall);
+clunk_newdir:
+	v9fs_clnt_clunk(olddirfid);

-Clunk_newdir:
-	v9fs_fid_clunk(v9ses, newdirfid);
-
-Clunk_olddir:
-	v9fs_fid_clunk(v9ses, olddirfid);
-
-Release_lock:
-	up(&oldfid->lock);
+clunk_olddir:
+	v9fs_clnt_clunk(newdirfid);

+done:
 	return retval;
 }

@@ -840,28 +703,27 @@ static int
 v9fs_vfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		 struct kstat *stat)
 {
-	struct v9fs_fcall *fcall = NULL;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
-	struct v9fs_fid *fid = v9fs_fid_clone(dentry);
-	int err = -EPERM;
+	int err;
+	struct v9fs_session_info *v9ses;
+	struct v9fs_fid *fid;
+	struct v9fs_stat *st;

 	dprintk(DEBUG_VFS, "dentry: %p\n", dentry);
-	if(IS_ERR(fid))
+	err = -EPERM;
+	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	fid = v9fs_fid_lookup(dentry);
+	if (IS_ERR(fid))
 		return PTR_ERR(fid);

-	err = v9fs_t_stat(v9ses, fid->fid, &fcall);
+	st = v9fs_clnt_stat(fid);
+	if (IS_ERR(st))
+		return PTR_ERR(st);

-	if (err < 0)
-		dprintk(DEBUG_ERROR, "stat error\n");
-	else {
-		v9fs_stat2inode(&fcall->params.rstat.stat, dentry->d_inode,
-				  dentry->d_inode->i_sb);
+	v9fs_stat2inode(st, dentry->d_inode, dentry->d_inode->i_sb);
 		generic_fillattr(dentry->d_inode, stat);
-	}

-	kfree(fcall);
-	v9fs_fid_clunk(v9ses, fid);
-	return err;
+	kfree(st);
+	return 0;
 }

 /**
@@ -873,13 +735,15 @@ v9fs_vfs_getattr(struct vfsmount *mnt, struct
dentry *dentry,

 static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 {
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
-	struct v9fs_fid *fid = v9fs_fid_clone(dentry);
-	struct v9fs_fcall *fcall = NULL;
+	int retval;
+	struct v9fs_session_info *v9ses;
+	struct v9fs_fid *fid;
 	struct v9fs_wstat wstat;
-	int res = -EPERM;

 	dprintk(DEBUG_VFS, "\n");
+	retval = -EPERM;
+	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	fid = v9fs_fid_lookup(dentry);
 	if(IS_ERR(fid))
 		return PTR_ERR(fid);

@@ -904,17 +768,11 @@ static int v9fs_vfs_setattr(struct dentry
*dentry, struct iattr *iattr)
 			wstat.n_gid = iattr->ia_gid;
 	}

-	res = v9fs_t_wstat(v9ses, fid->fid, &wstat, &fcall);
-
-	if (res < 0)
-		PRINT_FCALL_ERROR("wstat error", fcall);
+	retval = v9fs_clnt_wstat(fid, &wstat);
+	if (retval >= 0)
+		retval = inode_setattr(dentry->d_inode, iattr);

-	kfree(fcall);
-	if (res >= 0)
-		res = inode_setattr(dentry->d_inode, iattr);
-
-	v9fs_fid_clunk(v9ses, fid);
-	return res;
+	return retval;
 }

 /**
@@ -976,8 +834,8 @@ v9fs_stat2inode(struct v9fs_stat *stat, struct inode *inode,

 	inode->i_size = stat->length;

-	inode->i_blocks =
-	    (inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
+	/* not real number of blocks, but 512 byte ones ... */
+	inode->i_blocks = (inode->i_size + 512 - 1) >> 9;
 }

 /**
@@ -1010,56 +868,45 @@ ino_t v9fs_qid2ino(struct v9fs_qid *qid)

 static int v9fs_readlink(struct dentry *dentry, char *buffer, int buflen)
 {
-	int retval = -EPERM;
+	int retval;

-	struct v9fs_fcall *fcall = NULL;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
-	struct v9fs_fid *fid = v9fs_fid_clone(dentry);
+	struct v9fs_session_info *v9ses;
+	struct v9fs_fid *fid;
+	struct v9fs_stat *st;

+	dprintk(DEBUG_VFS, " %s\n", dentry->d_name.name);
+	retval = -EPERM;
+	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	fid = v9fs_fid_lookup(dentry);
 	if(IS_ERR(fid))
 		return PTR_ERR(fid);

-	if (!v9ses->extended) {
-		retval = -EBADF;
-		dprintk(DEBUG_ERROR, "not extended\n");
-		goto ClunkFid;
-	}
-
-	dprintk(DEBUG_VFS, " %s\n", dentry->d_name.name);
-	retval = v9fs_t_stat(v9ses, fid->fid, &fcall);
-
-	if (retval < 0) {
-		dprintk(DEBUG_ERROR, "stat error\n");
-		goto FreeFcall;
-	}
+	if (!v9ses->extended)
+		return -EBADF;

-	if (!fcall) {
-		retval = -EIO;
-		goto ClunkFid;
-	}
+	st = v9fs_clnt_stat(fid);
+	if (IS_ERR(st))
+		return PTR_ERR(st);

-	if (!(fcall->params.rstat.stat.mode & V9FS_DMSYMLINK)) {
+	if (!(st->mode & V9FS_DMSYMLINK)) {
 		retval = -EINVAL;
-		goto FreeFcall;
+		goto done;
 	}

 	/* copy extension buffer into buffer */
-	if (fcall->params.rstat.stat.extension.len < buflen)
-		buflen = fcall->params.rstat.stat.extension.len + 1;
+	if (st->extension.len < buflen)
+		buflen = st->extension.len + 1;

-	memmove(buffer, fcall->params.rstat.stat.extension.str, buflen - 1);
+	memmove(buffer, st->extension.str, buflen - 1);
 	buffer[buflen-1] = 0;

-	dprintk(DEBUG_ERROR, "%s -> %.*s (%s)\n", dentry->d_name.name,
fcall->params.rstat.stat.extension.len,
-		fcall->params.rstat.stat.extension.str, buffer);
-	retval = buflen;
+	dprintk(DEBUG_VFS, "%s -> %.*s (%s)\n", dentry->d_name.name,
st->extension.len,
+		st->extension.str, buffer);

-FreeFcall:
-	kfree(fcall);
-
-ClunkFid:
-	v9fs_fid_clunk(v9ses, fid);
+	retval = buflen;

+done:
+	kfree(st);
 	return retval;
 }

@@ -1149,11 +996,9 @@ static void v9fs_vfs_put_link(struct dentry
*dentry, struct nameidata *nd, void
 static int v9fs_vfs_mkspecial(struct inode *dir, struct dentry *dentry,
 	int mode, const char *extension)
 {
-	int err;
-	u32 fid, perm;
+	u32 perm;
 	struct v9fs_session_info *v9ses;
-	struct v9fs_fid *dfid, *vfid = NULL;
-	struct inode *inode = NULL;
+	struct v9fs_fid *fid;

 	v9ses = v9fs_inode2v9ses(dir);
 	if (!v9ses->extended) {
@@ -1161,54 +1006,13 @@ static int v9fs_vfs_mkspecial(struct inode
*dir, struct dentry *dentry,
 		return -EPERM;
 	}

-	dfid = v9fs_fid_clone(dentry->d_parent);
-	if(IS_ERR(dfid)) {
-		err = PTR_ERR(dfid);
-		goto error;
-	}
-
 	perm = unixmode2p9mode(v9ses, mode);
+	fid = v9fs_create(v9ses, dir, dentry, (char *) extension, perm, V9FS_OREAD);
+	if(IS_ERR(fid))
+		return PTR_ERR(fid);

-	err = v9fs_create(v9ses, dfid->fid, (char *) dentry->d_name.name,
-		perm, V9FS_OREAD, (char *) extension, &fid, NULL, NULL);
-
-	if (err)
-		goto clunk_dfid;
-
-	err = v9fs_t_clunk(v9ses, fid);
-	if (err)
-		goto clunk_dfid;
-
-	vfid = v9fs_clone_walk(v9ses, dfid->fid, dentry);
-	if (IS_ERR(vfid)) {
-		err = PTR_ERR(vfid);
-		vfid = NULL;
-		goto clunk_dfid;
-	}
-
-	inode = v9fs_inode_from_fid(v9ses, vfid->fid, dir->i_sb);
-	if (IS_ERR(inode)) {
-		err = PTR_ERR(inode);
-		inode = NULL;
-		goto free_vfid;
-	}
-
-	if(v9ses->cache)
-		dentry->d_op = &v9fs_cached_dentry_operations;
-	else
-		dentry->d_op = &v9fs_dentry_operations;
-	d_instantiate(dentry, inode);
+	v9fs_clnt_clunk(fid);
 	return 0;
-
-free_vfid:
-	v9fs_fid_destroy(vfid);
-
-clunk_dfid:
-	v9fs_fid_clunk(v9ses, dfid);
-
-error:
-	return err;
-
 }

 /**
@@ -1247,7 +1051,6 @@ v9fs_vfs_link(struct dentry *old_dentry, struct
inode *dir,
 	      struct dentry *dentry)
 {
 	int retval;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dir);
 	struct v9fs_fid *oldfid;
 	char *name;

@@ -1269,7 +1072,7 @@ v9fs_vfs_link(struct dentry *old_dentry, struct
inode *dir,
 	__putname(name);

 clunk_fid:
-	v9fs_fid_clunk(v9ses, oldfid);
+	v9fs_clnt_clunk(oldfid);
 	return retval;
 }

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 0ec42f6..b414e1a 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -42,6 +42,7 @@
 #include "v9fs.h"
 #include "9p.h"
 #include "v9fs_vfs.h"
+#include "clnt.h"
 #include "fid.h"

 static void v9fs_clear_inode(struct inode *);
@@ -107,16 +108,14 @@ static int v9fs_get_sb(struct file_system_type
*fs_type, int flags,
 		       struct vfsmount *mnt)
 {
 	struct super_block *sb = NULL;
-	struct v9fs_fcall *fcall = NULL;
 	struct inode *inode = NULL;
 	struct dentry *root = NULL;
 	struct v9fs_session_info *v9ses = NULL;
-	struct v9fs_fid *root_fid = NULL;
+	struct v9fs_stat *st = NULL;
 	int mode = S_IRWXUGO | S_ISVTX;
 	uid_t uid = current->fsuid;
 	gid_t gid = current->fsgid;
-	int stat_result = 0;
-	int newfid = 0;
+	struct v9fs_fid *fid;
 	int retval = 0;

 	dprintk(DEBUG_VFS, " \n");
@@ -125,23 +124,32 @@ static int v9fs_get_sb(struct file_system_type
*fs_type, int flags,
 	if (!v9ses)
 		return -ENOMEM;

-	if ((newfid = v9fs_session_init(v9ses, dev_name, data)) < 0) {
-		dprintk(DEBUG_ERROR, "problem initiating session\n");
-		retval = newfid;
-		goto out_free_session;
+	fid = v9fs_session_init(v9ses, dev_name, data);
+	if (IS_ERR(fid)) {
+		retval = PTR_ERR(fid);
+		fid = NULL;
+		kfree(v9ses);
+		v9ses = NULL;
+		goto error;
+	}
+
+	st = v9fs_clnt_stat(fid);
+	if (IS_ERR(st)) {
+		retval = PTR_ERR(st);
+		goto error;
 	}

 	sb = sget(fs_type, NULL, v9fs_set_super, v9ses);
 	if (IS_ERR(sb)) {
 		retval = PTR_ERR(sb);
-		goto out_close_session;
+		goto error;
 	}
 	v9fs_fill_super(sb, v9ses, flags);

 	inode = v9fs_get_inode(sb, S_IFDIR | mode);
 	if (IS_ERR(inode)) {
 		retval = PTR_ERR(inode);
-		goto put_back_sb;
+		goto error;
 	}

 	inode->i_uid = uid;
@@ -150,54 +158,30 @@ static int v9fs_get_sb(struct file_system_type
*fs_type, int flags,
 	root = d_alloc_root(inode);
 	if (!root) {
 		retval = -ENOMEM;
-		goto put_back_sb;
+		goto error;
 	}

 	sb->s_root = root;
-
-	stat_result = v9fs_t_stat(v9ses, newfid, &fcall);
-	if (stat_result < 0) {
-		dprintk(DEBUG_ERROR, "stat error\n");
-		v9fs_t_clunk(v9ses, newfid);
-	} else {
-		/* Setup the Root Inode */
-		root_fid = v9fs_fid_create(v9ses, newfid);
-		if (root_fid == NULL) {
-			retval = -ENOMEM;
-			goto put_back_sb;
-		}
-
-		retval = v9fs_fid_insert(root_fid, root);
-		if (retval < 0) {
-			kfree(fcall);
-			goto put_back_sb;
-		}
-
-		root_fid->qid = fcall->params.rstat.stat.qid;
-		root->d_inode->i_ino =
-		    v9fs_qid2ino(&fcall->params.rstat.stat.qid);
-		v9fs_stat2inode(&fcall->params.rstat.stat, root->d_inode, sb);
-	}
-
-	kfree(fcall);
-
-	if (stat_result < 0) {
-		retval = stat_result;
-		goto put_back_sb;
-	}
+	root->d_inode->i_ino = v9fs_qid2ino(&st->qid);
+	v9fs_stat2inode(st, root->d_inode, sb);
+	v9fs_fid_add(root, fid);

 	return simple_set_mnt(mnt, sb);

-out_close_session:
+error:
+	if (fid)
+		v9fs_clnt_clunk(fid);
+
+	if (v9ses) {
 	v9fs_session_close(v9ses);
-out_free_session:
 	kfree(v9ses);
-	return retval;
+	}

-put_back_sb:
-	/* deactivate_super calls v9fs_kill_super which will frees the rest */
+	if (sb) {
 	up_write(&sb->s_umount);
 	deactivate_super(sb);
+	}
+
 	return retval;
 }
