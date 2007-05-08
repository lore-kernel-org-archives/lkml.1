Return-Path: <linux-kernel-owner+w=401wt.eu-S1032071AbXEHU4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032071AbXEHU4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031763AbXEHU4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:56:09 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:41686 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031593AbXEHUz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=OP7qXOVhIpcKyAOrsHy+tpPJL6tbOKfKXO+lAniAyDpYvI/2/mz/NFoOJwvyqy+rzOHcyayqtpv8P1HnZd5/yabE8p4+G9jOqTm0v1bodtXtrAibUHJvAPwm/edKnPKcveoX02WfDpZQLrXyXUF5V8N2kX2muKNdOROnCgNhoww=
Message-ID: <f158dc670705081355y72e7729al884f4b617269e5ff@mail.gmail.com>
Date: Tue, 8 May 2007 14:55:57 -0600
From: "Latchesar Ionkov" <lucho@ionkov.net>
To: "Andrew Morton" <akpm@osdl.org>
Subject: [PATCH 4/4] v9fs: implement 9p client interface that can be used outside vfs
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 2183ed1f2a7801be
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset moves non-filesystem interfaces of v9fs from fs/9p to net/9p.
It moves the transport, packet marshalling and connection layers to net/9p
leaving only the VFS related files in fs/9p.

This patch:

In the current implementation the v9fs VFS layer uses directly the
low-level 9p messages. It intermixes the logic required by VFS with
managing some data structures (v9fs_fid for example) that belong to
9P. This makes the VFS code harder to understand and modify.

In order to implement proper authentication in v9fs, we need to export the
authentication channels to user space so a user program can do the
appropriate authentication (9P doesn't enforce a single authentication
protocol). From 9P point-of-view the authentication channels are normal 9P
files. Exporting them will require writing code similar to the one already
present in the VFS operations (sans the VFS specifics).

The patch defines a 9P client interface that the VFS operations can use,
making them easier to understand and maintain. The client interface is also
going to be used for the authentication channel export.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>
---
 fs/9p/Makefile          |    1 -
 fs/9p/fcall.c           |  426 ---------------------
 fs/9p/fid.c             |  165 +++------
 fs/9p/fid.h             |   43 +--
 fs/9p/v9fs.c            |  178 ++-------
 fs/9p/v9fs.h            |   50 +---
 fs/9p/vfs_addr.c        |   53 +--
 fs/9p/vfs_dentry.c      |   26 +-
 fs/9p/vfs_dir.c         |  137 ++------
 fs/9p/vfs_file.c        |  146 ++------
 fs/9p/vfs_inode.c       |  644 +++++++++++---------------------
 fs/9p/vfs_super.c       |   83 ++---
 include/net/9p/client.h |   77 ++++
 net/9p/client.c         |  955 +++++++++++++++++++++++++++++++++++++++++++++++
 14 files changed, 1471 insertions(+), 1513 deletions(-)

diff --git a/fs/9p/Makefile b/fs/9p/Makefile
index 66d40ca..bc7f0d1 100644
--- a/fs/9p/Makefile
+++ b/fs/9p/Makefile
@@ -1,7 +1,6 @@
 obj-$(CONFIG_9P_FS) := 9p.o

 9p-objs := \
-	fcall.o \
 	vfs_super.o \
 	vfs_inode.o \
 	vfs_addr.o \
diff --git a/fs/9p/fcall.c b/fs/9p/fcall.c
deleted file mode 100644
index 6863d86..0000000
--- a/fs/9p/fcall.c
+++ /dev/null
@@ -1,426 +0,0 @@
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
-#include <net/9p/9p.h>
-#include <net/9p/transport.h>
-#include <net/9p/conn.h>
-#include "v9fs.h"
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
-	       char *version, struct p9_fcall **rcp)
-{
-	int ret;
-	struct p9_fcall *tc;
-
-	P9_DPRINTK(P9_DEBUG_9P, "msize: %d version: %s\n", msize, version);
-	tc = p9_create_tversion(msize, version);
-
-	if (!IS_ERR(tc)) {
-		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
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
-	      u32 fid, u32 afid, struct p9_fcall **rcp)
-{
-	int ret;
-	struct p9_fcall* tc;
-
-	P9_DPRINTK(P9_DEBUG_9P, "uname '%s' aname '%s' fid %d afid %d\n", uname,
-		aname, fid, afid);
-
-	tc = p9_create_tattach(fid, afid, uname, aname);
-	if (!IS_ERR(tc)) {
-		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
-		kfree(tc);
-	} else
-		ret = PTR_ERR(tc);
-
-	return ret;
-}
-
-static void v9fs_t_clunk_cb(void *a, struct p9_fcall *tc,
-	struct p9_fcall *rc, int err)
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
-	if (id == P9_RCLUNK) {
-		v9ses = a;
-		p9_idpool_put(fid, v9ses->fidpool);
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
-	struct p9_fcall *tc, *rc;
-
-	P9_DPRINTK(P9_DEBUG_9P, "fid %d\n", fid);
-
-	rc = NULL;
-	tc = p9_create_tclunk(fid);
-	if (!IS_ERR(tc))
-		ret = p9_conn_rpc(v9ses->conn, tc, &rc);
-	else
-		ret = PTR_ERR(tc);
-
-	if (ret)
-		P9_DPRINTK(P9_DEBUG_ERROR, "failed fid %d err %d\n", fid, ret);
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
-	struct p9_fcall *tc;
-
-	P9_DPRINTK(P9_DEBUG_9P, "oldtag %d\n", oldtag);
-
-	tc = p9_create_tflush(oldtag);
-	if (!IS_ERR(tc)) {
-		ret = p9_conn_rpc(v9ses->conn, tc, NULL);
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
-v9fs_t_stat(struct v9fs_session_info *v9ses, u32 fid, struct p9_fcall **rcp)
-{
-	int ret;
-	struct p9_fcall *tc;
-
-	P9_DPRINTK(P9_DEBUG_9P, "fid %d\n", fid);
-
-	ret = -ENOMEM;
-	tc = p9_create_tstat(fid);
-	if (!IS_ERR(tc)) {
-		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
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
-	     struct p9_wstat *wstat, struct p9_fcall **rcp)
-{
-	int ret;
-	struct p9_fcall *tc;
-
-	P9_DPRINTK(P9_DEBUG_9P, "fid %d\n", fid);
-
-	tc = p9_create_twstat(fid, wstat, v9ses->extended);
-	if (!IS_ERR(tc)) {
-		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
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
-	    char *name, struct p9_fcall **rcp)
-{
-	int ret;
-	struct p9_fcall *tc;
-	int nwname;
-
-	P9_DPRINTK(P9_DEBUG_9P, "fid %d newfid %d wname '%s'\n", fid, newfid, name);
-
-	if (name)
-		nwname = 1;
-	else
-		nwname = 0;
-
-	tc = p9_create_twalk(fid, newfid, nwname, &name);
-	if (!IS_ERR(tc)) {
-		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
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
-	    struct p9_fcall **rcp)
-{
-	int ret;
-	struct p9_fcall *tc;
-
-	P9_DPRINTK(P9_DEBUG_9P, "fid %d mode %d\n", fid, mode);
-
-	tc = p9_create_topen(fid, mode);
-	if (!IS_ERR(tc)) {
-		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
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
-	      struct p9_fcall **rcp)
-{
-	int ret;
-	struct p9_fcall *tc;
-
-	P9_DPRINTK(P9_DEBUG_9P, "fid %d\n", fid);
-
-	tc = p9_create_tremove(fid);
-	if (!IS_ERR(tc)) {
-		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
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
-	u8 mode, char *extension, struct p9_fcall **rcp)
-{
-	int ret;
-	struct p9_fcall *tc;
-
-	P9_DPRINTK(P9_DEBUG_9P, "fid %d name '%s' perm %x mode %d\n",
-		fid, name, perm, mode);
-
-	tc = p9_create_tcreate(fid, name, perm, mode, extension,
-		v9ses->extended);
-
-	if (!IS_ERR(tc)) {
-		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
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
-	    u32 count, struct p9_fcall **rcp)
-{
-	int ret;
-	struct p9_fcall *tc, *rc;
-
-	P9_DPRINTK(P9_DEBUG_9P, "fid %d offset 0x%llux count 0x%x\n", fid,
-		(long long unsigned) offset, count);
-
-	tc = p9_create_tread(fid, offset, count);
-	if (!IS_ERR(tc)) {
-		ret = p9_conn_rpc(v9ses->conn, tc, &rc);
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
-	const char __user *data, struct p9_fcall **rcp)
-{
-	int ret;
-	struct p9_fcall *tc, *rc;
-
-	P9_DPRINTK(P9_DEBUG_9P, "fid %d offset 0x%llux count 0x%x\n", fid,
-		(long long unsigned) offset, count);
-
-	tc = p9_create_twrite_u(fid, offset, count, data);
-	P9_DPRINTK(P9_DEBUG_ERROR, "tcall %p\n", tc);
-	if (!IS_ERR(tc)) {
-		ret = p9_conn_rpc(v9ses->conn, tc, &rc);
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
diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 713b802..ff21e71 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -27,6 +27,8 @@
 #include <linux/idr.h>
 #include <asm/semaphore.h>
 #include <net/9p/9p.h>
+#include <net/9p/client.h>
+
 #include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"
@@ -38,67 +40,28 @@
  *
  */

-int v9fs_fid_insert(struct v9fs_fid *fid, struct dentry *dentry)
+int v9fs_fid_add(struct dentry *dentry, struct p9_fid *fid)
 {
-	struct list_head *fid_list = (struct list_head *)dentry->d_fsdata;
-	P9_DPRINTK(P9_DEBUG_9P, "fid %d (%p) dentry %s (%p)\n", fid->fid, fid,
-		dentry->d_iname, dentry);
-	if (dentry->d_fsdata == NULL) {
-		dentry->d_fsdata =
-		    kmalloc(sizeof(struct list_head), GFP_KERNEL);
-		if (dentry->d_fsdata == NULL) {
-			P9_DPRINTK(P9_DEBUG_ERROR, "Out of memory\n");
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
-
-/**
- * v9fs_fid_create - allocate a FID structure
- * @dentry - dentry to link newly created fid to
- *
- */
+	P9_DPRINTK(P9_DEBUG_VFS, "fid %d dentry %s\n", fid->fid, dentry->d_iname);

-struct v9fs_fid *v9fs_fid_create(struct v9fs_session_info *v9ses, int fid)
-{
-	struct v9fs_fid *new;
+	dent = dentry->d_fsdata;
+	if (!dent) {
+		dent = kmalloc(sizeof(struct v9fs_dentry), GFP_KERNEL);
+		if (!dent)
+			return -ENOMEM;

-	P9_DPRINTK(P9_DEBUG_9P, "fid create fid %d\n", fid);
-	new = kmalloc(sizeof(struct v9fs_fid), GFP_KERNEL);
-	if (new == NULL) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "Out of Memory\n");
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
+	spin_lock(&dent->lock);
+	list_add(&fid->dlist, &dent->fidlist);
+	spin_unlock(&dent->lock);

-/**
- * v9fs_fid_destroy - deallocate a FID structure
- * @fid: fid to destroy
- *
- */
-
-void v9fs_fid_destroy(struct v9fs_fid *fid)
-{
-	list_del(&fid->list);
-	kfree(fid);
+	return 0;
 }

 /**
@@ -112,30 +75,42 @@ void v9fs_fid_destroy(struct v9fs_fid *fid)
  *
  */

-struct v9fs_fid *v9fs_fid_lookup(struct dentry *dentry)
+struct p9_fid *v9fs_fid_lookup(struct dentry *dentry)
 {
-	struct list_head *fid_list = (struct list_head *)dentry->d_fsdata;
-	struct v9fs_fid *return_fid = NULL;
-
-	P9_DPRINTK(P9_DEBUG_9P, " dentry: %s (%p)\n", dentry->d_iname, dentry);
-
-	if (fid_list)
-		return_fid = list_entry(fid_list->next, struct v9fs_fid, list);
+	struct v9fs_dentry *dent;
+	struct p9_fid *fid;
+
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	dent = dentry->d_fsdata;
+	if (dent)
+		fid = list_entry(dent->fidlist.next, struct p9_fid, dlist);
+	else
+		fid = ERR_PTR(-EBADF);
+
+	P9_DPRINTK(P9_DEBUG_VFS, " fid: %p\n", fid);
+	return fid;
+}

-	if (!return_fid) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "Couldn't find a fid in dentry\n");
-		return_fid = ERR_PTR(-EBADF);
+struct p9_fid *v9fs_fid_lookup_remove(struct dentry *dentry)
+{
+	struct p9_fid *fid;
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
- * 			release it
+ * 	release it
  * @dentry: dentry to look for fid in
  *
  * find a fid in the dentry and then clone to a new private fid
@@ -144,49 +119,15 @@ struct v9fs_fid *v9fs_fid_lookup(struct dentry *dentry)
  *
  */

-struct v9fs_fid *v9fs_fid_clone(struct dentry *dentry)
+struct p9_fid *v9fs_fid_clone(struct dentry *dentry)
 {
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
-	struct v9fs_fid *base_fid, *new_fid = ERR_PTR(-EBADF);
-	struct p9_fcall *fcall = NULL;
-	int fid, err;
-
-	base_fid = v9fs_fid_lookup(dentry);
-
-	if(IS_ERR(base_fid))
-		return base_fid;
-
-	if(base_fid) {  /* clone fid */
-		fid = p9_idpool_get(v9ses->fidpool);
-		if (fid < 0) {
-			P9_EPRINTK(KERN_WARNING, "newfid fails!\n");
-			new_fid = ERR_PTR(-ENOSPC);
-			goto Release_Fid;
-		}
-
-		err = v9fs_t_walk(v9ses, base_fid->fid, fid, NULL, &fcall);
-		if (err < 0) {
-			P9_DPRINTK(P9_DEBUG_ERROR, "clone walk didn't work\n");
-			p9_idpool_put(fid, v9ses->fidpool);
-			new_fid = ERR_PTR(err);
-			goto Free_Fcall;
-		}
-		new_fid = v9fs_fid_create(v9ses, fid);
-		if (new_fid == NULL) {
-			P9_DPRINTK(P9_DEBUG_ERROR, "out of memory\n");
-			new_fid = ERR_PTR(-ENOMEM);
-		}
-Free_Fcall:
-		kfree(fcall);
-	}
+	struct p9_fid *ofid, *fid;

-Release_Fid:
-	up(&base_fid->lock);
-	return new_fid;
-}
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	ofid = v9fs_fid_lookup(dentry);
+	if (IS_ERR(ofid))
+		return ofid;

-void v9fs_fid_clunk(struct v9fs_session_info *v9ses, struct v9fs_fid *fid)
-{
-	v9fs_t_clunk(v9ses, fid->fid);
-	v9fs_fid_destroy(fid);
+	fid = p9_client_walk(ofid, 0, NULL, 1);
+	return fid;
 }
diff --git a/fs/9p/fid.h b/fs/9p/fid.h
index a261ddf..bf75145 100644
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
-	struct p9_qid qid;
-	u32 iounit;
-
-	/* readdir stuff */
-	int rdir_fpos;
-	loff_t rdir_pos;
-	struct p9_fcall *rdir_fcall;
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

-struct v9fs_fid *v9fs_fid_lookup(struct dentry *dentry);
-struct v9fs_fid *v9fs_fid_get_created(struct dentry *);
-void v9fs_fid_destroy(struct v9fs_fid *fid);
-struct v9fs_fid *v9fs_fid_create(struct v9fs_session_info *, int fid);
-int v9fs_fid_insert(struct v9fs_fid *fid, struct dentry *dentry);
-struct v9fs_fid *v9fs_fid_clone(struct dentry *dentry);
-void v9fs_fid_clunk(struct v9fs_session_info *v9ses, struct v9fs_fid *fid);
-
+struct p9_fid *v9fs_fid_lookup(struct dentry *dentry);
+struct p9_fid *v9fs_fid_lookup_remove(struct dentry *dentry);
+struct p9_fid *v9fs_fid_clone(struct dentry *dentry);
+int v9fs_fid_add(struct dentry *dentry, struct p9_fid *fid);
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 70858ed..cb887f0 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -31,13 +31,11 @@
 #include <linux/idr.h>
 #include <net/9p/9p.h>
 #include <net/9p/transport.h>
-#include <net/9p/conn.h>
+#include <net/9p/client.h>
+
 #include "v9fs.h"
 #include "v9fs_vfs.h"

-/* TODO: sysfs or debugfs interface */
-unsigned int p9_debug_level = 0;	/* feature-rific global debug level  */
-
 /*
   * Option Parsing (code inspired by NFS code)
   *
@@ -45,7 +43,7 @@ unsigned int p9_debug_level = 0;	/* feature-rific
global debug level  */

 enum {
 	/* Options that take integer arguments */
-	Opt_port, Opt_msize, Opt_uid, Opt_gid, Opt_afid, Opt_debug,
+	Opt_port, Opt_msize, Opt_uid, Opt_gid, Opt_afid,
 	Opt_rfdno, Opt_wfdno,
 	/* String options */
 	Opt_uname, Opt_remotename,
@@ -65,7 +63,6 @@ static match_table_t tokens = {
 	{Opt_afid, "afid=%u"},
 	{Opt_rfdno, "rfdno=%u"},
 	{Opt_wfdno, "wfdno=%u"},
-	{Opt_debug, "debug=%x"},
 	{Opt_uname, "uname=%s"},
 	{Opt_remotename, "aname=%s"},
 	{Opt_unix, "proto=unix"},
@@ -147,9 +144,6 @@ static void v9fs_parse_options(char *options,
struct v9fs_session_info *v9ses)
 		case Opt_wfdno:
 			v9ses->wfdno = option;
 			break;
-		case Opt_debug:
-			v9ses->debug = option;
-			break;
 		case Opt_tcp:
 			v9ses->proto = PROTO_TCP;
 			break;
@@ -181,20 +175,6 @@ static void v9fs_parse_options(char *options,
struct v9fs_session_info *v9ses)
 }

 /**
- * v9fs_inode2v9ses - safely extract v9fs session info from super block
- * @inode: inode to extract information from
- *
- * Paranoid function to extract v9ses information from superblock,
- * if anything is missing it will report an error.
- *
- */
-
-struct v9fs_session_info *v9fs_inode2v9ses(struct inode *inode)
-{
-	return (inode->i_sb->s_fs_info);
-}
-
-/**
  * v9fs_session_init - initialize session
  * @v9ses: session information structure
  * @dev_name: device being mounted
@@ -202,25 +182,21 @@ struct v9fs_session_info
*v9fs_inode2v9ses(struct inode *inode)
  *
  */

-int
-v9fs_session_init(struct v9fs_session_info *v9ses,
+struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 		  const char *dev_name, char *data)
 {
-	struct p9_fcall *fcall = NULL;
-	struct p9_transport *trans;
-	int n = 0;
-	int newfid = -1;
 	int retval = -EINVAL;
-	struct p9_str *version;
+	struct p9_transport *trans;
+	struct p9_fid *fid;

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
@@ -228,16 +204,6 @@ v9fs_session_init(struct v9fs_session_info *v9ses,

 	v9fs_parse_options(data, v9ses);

-	/* set global debug level */
-	p9_debug_level = v9ses->debug;
-
-	v9ses->fidpool = p9_idpool_create();
-	if (IS_ERR(v9ses->fidpool)) {
-		retval = PTR_ERR(v9ses->fidpool);
-		v9ses->fidpool = NULL;
-		goto SessCleanUp;
-	}
-
 	switch (v9ses->proto) {
 	case PROTO_TCP:
 		trans = p9_trans_create_tcp(dev_name, v9ses->port);
@@ -253,102 +219,38 @@ v9fs_session_init(struct v9fs_session_info *v9ses,
 	default:
 		printk(KERN_ERR "v9fs: Bad mount protocol %d\n", v9ses->proto);
 		retval = -ENOPROTOOPT;
-		goto SessCleanUp;
+		goto error;
 	};

 	if (IS_ERR(trans)) {
 		retval = PTR_ERR(trans);
 		trans = NULL;
-		goto SessCleanUp;
+		goto error;
 	}

-	v9ses->transport = trans;
-	v9ses->inprogress = 0;
-	v9ses->shutdown = 0;
-	v9ses->session_hung = 0;
-
-	v9ses->conn = p9_conn_create(v9ses->transport, v9ses->maxdata + P9_IOHDRSZ,
-		&v9ses->extended);
+	v9ses->clnt = p9_client_create(trans, v9ses->maxdata + P9_IOHDRSZ,
+		v9ses->extended);

-	if (IS_ERR(v9ses->conn)) {
-		retval = PTR_ERR(v9ses->conn);
-		v9ses->conn = NULL;
-		P9_DPRINTK(P9_DEBUG_ERROR, "problem initializing mux\n");
-		goto SessCleanUp;
+	if (IS_ERR(v9ses->clnt)) {
+		retval = PTR_ERR(v9ses->clnt);
+		v9ses->clnt = NULL;
+		P9_DPRINTK(P9_DEBUG_ERROR, "problem initializing 9p client\n");
+		goto error;
 	}

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
-			P9_DPRINTK(P9_DEBUG_ERROR, "v9fs_t_version failed\n");
-			goto FreeFcall;
-		}
-
-		version = &fcall->params.rversion.version;
-		if (version->len==8 && !memcmp(version->str, "9P2000.u", 8)) {
-			P9_DPRINTK(P9_DEBUG_9P, "9P2000 UNIX extensions enabled\n");
-			v9ses->extended = 1;
-		} else if (version->len==6 && !memcmp(version->str, "9P2000", 6)) {
-			P9_DPRINTK(P9_DEBUG_9P, "9P2000 legacy mode enabled\n");
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
-
-	newfid = p9_idpool_get(v9ses->fidpool);
-	if (newfid < 0) {
-		P9_EPRINTK(KERN_WARNING, "couldn't allocate FID\n");
-		retval = -ENOMEM;
-		goto SessCleanUp;
-	}
-	/* it is a little bit ugly, but we have to prevent newfid */
-	/* being the same as afid, so if it is, get a new fid     */
-	if (v9ses->afid != ~0 && newfid == v9ses->afid) {
-		newfid = p9_idpool_get(v9ses->fidpool);
-		if (newfid < 0) {
-			P9_EPRINTK(KERN_WARNING, "couldn't allocate FID\n");
-			retval = -ENOMEM;
-			goto SessCleanUp;
-		}
-	}
-
-	if ((retval =
-	     v9fs_t_attach(v9ses, v9ses->name, v9ses->remotename, newfid,
-			   v9ses->afid, NULL))
-	    < 0) {
+	fid = p9_client_attach(v9ses->clnt, NULL, v9ses->name, v9ses->remotename);
+	if (IS_ERR(fid)) {
+		retval = PTR_ERR(fid);
+		fid = NULL;
 		P9_DPRINTK(P9_DEBUG_ERROR, "cannot attach\n");
-		goto SessCleanUp;
+		goto error;
 	}

-	if (v9ses->afid != ~0) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "afid not equal to ~0\n");
-		if (v9fs_t_clunk(v9ses, v9ses->afid))
-			P9_DPRINTK(P9_DEBUG_ERROR, "clunk failed\n");
-	}
+	return fid;

-	return newfid;
-
-      FreeFcall:
-	kfree(fcall);
-
-      SessCleanUp:
+error:
 	v9fs_session_close(v9ses);
-	return retval;
+	return ERR_PTR(retval);
 }

 /**
@@ -359,20 +261,9 @@ v9fs_session_init(struct v9fs_session_info *v9ses,

 void v9fs_session_close(struct v9fs_session_info *v9ses)
 {
-	if (v9ses->conn) {
-		p9_conn_destroy(v9ses->conn);
-		v9ses->conn = NULL;
-	}
-
-	if (v9ses->transport) {
-		v9ses->transport->close(v9ses->transport);
-		kfree(v9ses->transport);
-		v9ses->transport = NULL;
-	}
-
-	if (v9ses->fidpool) {
-		p9_idpool_destroy(v9ses->fidpool);
-		v9ses->fidpool = NULL;
+	if (v9ses->clnt) {
+		p9_client_destroy(v9ses->clnt);
+		v9ses->clnt = NULL;
 	}

 	__putname(v9ses->name);
@@ -385,10 +276,11 @@ void v9fs_session_close(struct v9fs_session_info *v9ses)
  */
 void v9fs_session_cancel(struct v9fs_session_info *v9ses) {
 	P9_DPRINTK(P9_DEBUG_ERROR, "cancel session %p\n", v9ses);
-	v9ses->transport->status = Disconnected;
-	p9_conn_cancel(v9ses->conn, -EIO);
+	p9_client_disconnect(v9ses->clnt);
 }

+extern int v9fs_error_init(void);
+
 /**
  * v9fs_init - Initialize module
  *
@@ -396,14 +288,9 @@ void v9fs_session_cancel(struct v9fs_session_info *v9ses) {

 static int __init init_v9fs(void)
 {
-	int ret;
-
 	printk(KERN_INFO "Installing v9fs 9p2000 file system support\n");
-	ret = register_filesystem(&v9fs_fs_type);
-	if (ret)
-		printk(KERN_WARNING "v9fs: registering file system failed\n");

-	return ret;
+	return register_filesystem(&v9fs_fs_type);
 }

 /**
@@ -419,6 +306,7 @@ static void __exit exit_v9fs(void)
 module_init(init_v9fs)
 module_exit(exit_v9fs)

+MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
 MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
 MODULE_AUTHOR("Ron Minnich <rminnich@lanl.gov>");
 MODULE_LICENSE("GPL");
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 0a0be4f..44760a5 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -44,15 +44,7 @@ struct v9fs_session_info {
 	unsigned int uid;	/* default uid/muid for legacy support */
 	unsigned int gid;	/* default gid for legacy support */

-	/* book keeping */
-	struct p9_idpool *fidpool;	/* The FID pool for file descriptors */
-
-	struct p9_transport *transport;
-	struct p9_conn *conn;
-
-	int inprogress;		/* session in progress => true */
-	int shutdown;		/* session shutting down. no more attaches. */
-	unsigned char session_hung;
+	struct p9_client *clnt;	/* 9p client */
 	struct dentry *debugfs_dir;
 };

@@ -72,44 +64,10 @@ enum {

 extern struct dentry *v9fs_debugfs_root;

-int v9fs_session_init(struct v9fs_session_info *, const char *, char *);
-struct v9fs_session_info *v9fs_inode2v9ses(struct inode *);
+struct p9_fid *v9fs_session_init(struct v9fs_session_info *, const
char *, char *);
 void v9fs_session_close(struct v9fs_session_info *v9ses);
 void v9fs_session_cancel(struct v9fs_session_info *v9ses);

-int v9fs_t_version(struct v9fs_session_info *v9ses, u32 msize,
-		   char *version, struct p9_fcall **rcall);
-
-int v9fs_t_attach(struct v9fs_session_info *v9ses, char *uname, char *aname,
-		  u32 fid, u32 afid, struct p9_fcall **rcall);
-
-int v9fs_t_clunk(struct v9fs_session_info *v9ses, u32 fid);
-
-int v9fs_t_stat(struct v9fs_session_info *v9ses, u32 fid,
-		struct p9_fcall **rcall);
-
-int v9fs_t_wstat(struct v9fs_session_info *v9ses, u32 fid,
-		 struct p9_wstat *wstat, struct p9_fcall **rcall);
-
-int v9fs_t_walk(struct v9fs_session_info *v9ses, u32 fid, u32 newfid,
-		char *name, struct p9_fcall **rcall);
-
-int v9fs_t_open(struct v9fs_session_info *v9ses, u32 fid, u8 mode,
-		struct p9_fcall **rcall);
-
-int v9fs_t_remove(struct v9fs_session_info *v9ses, u32 fid,
-		  struct p9_fcall **rcall);
-
-int v9fs_t_create(struct v9fs_session_info *v9ses, u32 fid, char *name,
-	u32 perm, u8 mode, char *extension, struct p9_fcall **rcall);
-
-int v9fs_t_read(struct v9fs_session_info *v9ses, u32 fid,
-		u64 offset, u32 count, struct p9_fcall **rcall);
-
-int v9fs_t_write(struct v9fs_session_info *v9ses, u32 fid, u64 offset,
-		 u32 count, const char __user * data,
-		 struct p9_fcall **rcall);
-
 #define V9FS_MAGIC 0x01021997

 /* other default globals */
@@ -117,3 +75,7 @@ int v9fs_t_write(struct v9fs_session_info *v9ses,
u32 fid, u64 offset,
 #define V9FS_DEFUSER	"nobody"
 #define V9FS_DEFANAME	""

+static inline struct v9fs_session_info *v9fs_inode2v9ses(struct inode *inode)
+{
+	return (inode->i_sb->s_fs_info);
+}
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 2b45de0..1569214 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -34,6 +34,8 @@
 #include <linux/pagemap.h>
 #include <linux/idr.h>
 #include <net/9p/9p.h>
+#include <net/9p/client.h>
+
 #include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"
@@ -48,55 +50,26 @@

 static int v9fs_vfs_readpage(struct file *filp, struct page *page)
 {
-	char *buffer = NULL;
-	int retval = -EIO;
-	loff_t offset = page_offset(page);
-	int count = PAGE_CACHE_SIZE;
-	struct inode *inode = filp->f_path.dentry->d_inode;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
-	int rsize = v9ses->maxdata - P9_IOHDRSZ;
-	struct v9fs_fid *v9f = filp->private_data;
-	struct p9_fcall *fcall = NULL;
-	int fid = v9f->fid;
-	int total = 0;
-	int result = 0;
+	int retval;
+	loff_t offset;
+	char *buffer;
+	struct p9_fid *fid;

 	P9_DPRINTK(P9_DEBUG_VFS, "\n");
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
+	retval = p9_client_readn(fid, buffer, offset, PAGE_CACHE_SIZE);
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
index 9ba3041..5896853 100644
--- a/fs/9p/vfs_dentry.c
+++ b/fs/9p/vfs_dentry.c
@@ -35,6 +35,8 @@
 #include <linux/namei.h>
 #include <linux/idr.h>
 #include <net/9p/9p.h>
+#include <net/9p/client.h>
+
 #include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"
@@ -83,26 +85,18 @@ static int v9fs_cached_dentry_delete(struct dentry *dentry)

 void v9fs_dentry_release(struct dentry *dentry)
 {
-	int err;
+	struct v9fs_dentry *dent;
+	struct p9_fid *temp, *current_fid;

 	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
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
-				P9_DPRINTK(P9_DEBUG_ERROR, "clunk failed: %d name %s\n",
-					err, dentry->d_iname);
-
-			v9fs_fid_destroy(current_fid);
+	dent = dentry->d_fsdata;
+	if (dent) {
+		list_for_each_entry_safe(current_fid, temp, &dent->fidlist, dlist) {
+			p9_client_clunk(current_fid);
 		}

-		kfree(dentry->d_fsdata);	/* free the list_head */
+		kfree(dent);
+		dentry->d_fsdata = NULL;
 	}
 }

diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 432571f..190acf2 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -34,6 +34,8 @@
 #include <linux/inet.h>
 #include <linux/idr.h>
 #include <net/9p/9p.h>
+#include <net/9p/client.h>
+
 #include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"
@@ -67,106 +69,36 @@ static inline int dt_type(struct p9_stat *mistat)

 static int v9fs_dir_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
-	struct p9_fcall *fcall = NULL;
-	struct inode *inode = filp->f_path.dentry->d_inode;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
-	struct v9fs_fid *file = filp->private_data;
-	unsigned int i, n, s;
-	int fid = -1;
-	int ret = 0;
-	struct p9_stat stat;
-	int over = 0;
+	int over;
+	struct p9_fid *fid;
+	struct v9fs_session_info *v9ses;
+	struct inode *inode;
+	struct p9_stat *st;

 	P9_DPRINTK(P9_DEBUG_VFS, "name %s\n", filp->f_path.dentry->d_name.name);
+	inode = filp->f_path.dentry->d_inode;
+	v9ses = v9fs_inode2v9ses(inode);
+	fid = filp->private_data;
+	while ((st = p9_client_dirread(fid, filp->f_pos)) != NULL) {
+		if (IS_ERR(st))
+			return PTR_ERR(st);

-	fid = file->fid;
-
-	if (file->rdir_fcall && (filp->f_pos != file->rdir_pos)) {
-		kfree(file->rdir_fcall);
-		file->rdir_fcall = NULL;
-	}
+		over = filldir(dirent, st->name.str, st->name.len, filp->f_pos,
+			v9fs_qid2ino(&st->qid), dt_type(st));

-	if (file->rdir_fcall) {
-		n = file->rdir_fcall->params.rread.count;
-		i = file->rdir_fpos;
-		while (i < n) {
-			s = p9_deserialize_stat(
-				file->rdir_fcall->params.rread.data + i,
-				n - i, &stat, v9ses->extended);
-
-			if (s == 0) {
-				P9_DPRINTK(P9_DEBUG_ERROR,
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
-			v9ses->maxdata-P9_IOHDRSZ, &fcall);
-		if (ret < 0) {
-			P9_DPRINTK(P9_DEBUG_ERROR, "error while reading: %d: %p\n",
-				ret, fcall);
-			goto FreeStructs;
-		} else if (ret == 0)
+		if (over)
 			break;

-		n = ret;
-		i = 0;
-		while (i < n) {
-			s = p9_deserialize_stat(fcall->params.rread.data + i,
-				n - i, &stat, v9ses->extended);
-
-			if (s == 0) {
-				P9_DPRINTK(P9_DEBUG_ERROR,
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
-				break;
-			}
-
-			i += s;
-			filp->f_pos += s;
-		}
-
-		kfree(fcall);
+		filp->f_pos += st->size;
+		kfree(st);
+		st = NULL;
 	}

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
@@ -176,29 +108,12 @@ static int v9fs_dir_readdir(struct file *filp,
void *dirent, filldir_t filldir)

 int v9fs_dir_release(struct inode *inode, struct file *filp)
 {
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
-	struct v9fs_fid *fid = filp->private_data;
-	int fidnum = -1;
-
-	P9_DPRINTK(P9_DEBUG_VFS, "inode: %p filp: %p fid: %d\n", inode, filp,
-		fid->fid);
-	fidnum = fid->fid;
+	struct p9_fid *fid;

+	fid = filp->private_data;
+	P9_DPRINTK(P9_DEBUG_VFS, "inode: %p filp: %p fid: %d\n", inode,
filp, fid->fid);
 	filemap_write_and_wait(inode->i_mapping);
-
-	if (fidnum >= 0) {
-		P9_DPRINTK(P9_DEBUG_VFS, "fidopen: %d v9f->fid: %d\n", fid->fidopen,
-			fid->fid);
-
-		if (v9fs_t_clunk(v9ses, fidnum))
-			P9_DPRINTK(P9_DEBUG_ERROR, "clunk failed\n");
-
-		kfree(fid->rdir_fcall);
-		kfree(fid);
-
-		filp->private_data = NULL;
-	}
-
+	p9_client_clunk(fid);
 	return 0;
 }

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index b2436aa..836abcc 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -36,6 +36,8 @@
 #include <asm/uaccess.h>
 #include <linux/idr.h>
 #include <net/9p/9p.h>
+#include <net/9p/client.h>
+
 #include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"
@@ -51,35 +53,29 @@ static const struct file_operations
v9fs_cached_file_operations;

 int v9fs_file_open(struct inode *inode, struct file *file)
 {
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
-	struct v9fs_fid *vfid;
-	struct p9_fcall *fcall = NULL;
-	int omode;
 	int err;
+	struct v9fs_session_info *v9ses;
+	struct p9_fid *fid;
+	int omode;

 	P9_DPRINTK(P9_DEBUG_VFS, "inode: %p file: %p \n", inode, file);
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
+		err = p9_client_open(fid, omode);
 	if (err < 0) {
-		PRINT_FCALL_ERROR("open failed", fcall);
-		goto Clunk_Fid;
+			p9_client_clunk(fid);
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
 		P9_DPRINTK(P9_DEBUG_VFS, "cached");
 		/* enable cached file options */
 		if(file->f_op == &v9fs_file_operations)
@@ -87,12 +83,6 @@ int v9fs_file_open(struct inode *inode, struct file *file)
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
@@ -135,55 +125,16 @@ static ssize_t
 v9fs_file_read(struct file *filp, char __user * data, size_t count,
 	       loff_t * offset)
 {
-	struct inode *inode = filp->f_path.dentry->d_inode;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
-	struct v9fs_fid *v9f = filp->private_data;
-	struct p9_fcall *fcall = NULL;
-	int fid = v9f->fid;
-	int rsize = 0;
-	int result = 0;
-	int total = 0;
-	int n;
+	int ret;
+	struct p9_fid *fid;

 	P9_DPRINTK(P9_DEBUG_VFS, "\n");
+	fid = filp->private_data;
+	ret = p9_client_uread(fid, data, *offset, count);
+	if (ret > 0)
+		*offset += ret;

-	rsize = v9ses->maxdata - P9_IOHDRSZ;
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
-			P9_DPRINTK(P9_DEBUG_ERROR, "Problem copying to user %d\n", n);
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
@@ -199,50 +150,19 @@ static ssize_t
 v9fs_file_write(struct file *filp, const char __user * data,
 		size_t count, loff_t * offset)
 {
-	struct inode *inode = filp->f_path.dentry->d_inode;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
-	struct v9fs_fid *v9fid = filp->private_data;
-	struct p9_fcall *fcall;
-	int fid = v9fid->fid;
-	int result = -EIO;
-	int rsize = 0;
-	int total = 0;
+	int ret;
+	struct p9_fid *fid;

 	P9_DPRINTK(P9_DEBUG_VFS, "data %p count %d offset %x\n", data, (int)count,
 		(int)*offset);
-	rsize = v9ses->maxdata - P9_IOHDRSZ;
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
-			P9_EPRINTK(KERN_ERR,
-				"short write: v9fs_t_write returned %d\n",
-				result);
-			break;
-		}

-		count -= result;
-		data += result;
-		total += result;
-	} while (count);
+	fid = filp->private_data;
+	ret = p9_client_uwrite(fid, data, *offset, count);
+	if (ret > 0)
+		*offset += ret;

-	invalidate_inode_pages2(inode->i_mapping);
-	return total;
+	invalidate_inode_pages2(filp->f_path.dentry->d_inode->i_mapping);
+	return ret;
 }

 static const struct file_operations v9fs_cached_file_operations = {
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 7d951e2..f29fed6 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -35,6 +35,8 @@
 #include <linux/namei.h>
 #include <linux/idr.h>
 #include <net/9p/9p.h>
+#include <net/9p/client.h>
+
 #include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"
@@ -250,71 +252,18 @@ struct inode *v9fs_get_inode(struct super_block
*sb, int mode)
 	return inode;
 }

-static int
-v9fs_create(struct v9fs_session_info *v9ses, u32 pfid, char *name, u32 perm,
-	u8 mode, char *extension, u32 *fidp, struct p9_qid *qid, u32 *iounit)
-{
-	int fid;
-	int err;
-	struct p9_fcall *fcall;
-
-	fid = p9_idpool_get(v9ses->fidpool);
-	if (fid < 0) {
-		P9_EPRINTK(KERN_WARNING, "no free fids available\n");
-		return -ENOSPC;
-	}
-
-	err = v9fs_t_walk(v9ses, pfid, fid, NULL, &fcall);
-	if (err < 0) {
-		PRINT_FCALL_ERROR("clone error", fcall);
-		if (fcall && fcall->id == P9_RWALK)
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
-	fid = P9_NOFID;
-
-put_fid:
-	if (fid != P9_NOFID)
-		p9_idpool_put(fid, v9ses->fidpool);
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
 	int err;
 	int nfid;
 	struct v9fs_fid *ret;
-	struct p9_fcall *fcall;
+	struct v9fs_fcall *fcall;

-	nfid = p9_idpool_get(v9ses->fidpool);
+	nfid = v9fs_get_idpool(&v9ses->fidpool);
 	if (nfid < 0) {
-		P9_EPRINTK(KERN_WARNING, "no free fids available\n");
+		eprintk(KERN_WARNING, "no free fids available\n");
 		return ERR_PTR(-ENOSPC);
 	}

@@ -322,11 +271,11 @@ v9fs_clone_walk(struct v9fs_session_info *v9ses,
u32 fid, struct dentry *dentry)
 		&fcall);

 	if (err < 0) {
-		if (fcall && fcall->id == P9_RWALK)
+		if (fcall && fcall->id == RWALK)
 			goto clunk_fid;

 		PRINT_FCALL_ERROR("walk error", fcall);
-		p9_idpool_put(nfid, v9ses->fidpool);
+		v9fs_put_idpool(nfid, &v9ses->fidpool);
 		goto error;
 	}

@@ -353,23 +302,25 @@ error:
 	kfree(fcall);
 	return ERR_PTR(err);
 }
+*/

 static struct inode *
-v9fs_inode_from_fid(struct v9fs_session_info *v9ses, u32 fid,
+v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 	struct super_block *sb)
 {
 	int err, umode;
 	struct inode *ret;
-	struct p9_fcall *fcall;
+	struct p9_stat *st;

 	ret = NULL;
-	err = v9fs_t_stat(v9ses, fid, &fcall);
-	if (err) {
-		PRINT_FCALL_ERROR("stat error", fcall);
+	st = p9_client_stat(fid);
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
@@ -377,12 +328,13 @@ v9fs_inode_from_fid(struct v9fs_session_info
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

@@ -399,43 +351,20 @@ error:

 static int v9fs_remove(struct inode *dir, struct dentry *file, int rmdir)
 {
-	struct p9_fcall *fcall = NULL;
-	struct super_block *sb = NULL;
-	struct v9fs_session_info *v9ses = NULL;
-	struct v9fs_fid *v9fid = NULL;
-	struct inode *file_inode = NULL;
-	int fid = -1;
-	int result = 0;
+	struct inode *file_inode;
+	struct v9fs_session_info *v9ses;
+	struct p9_fid *v9fid;

 	P9_DPRINTK(P9_DEBUG_VFS, "inode: %p dentry: %p rmdir: %d\n", dir, file,
 		rmdir);

 	file_inode = file->d_inode;
-	sb = file_inode->i_sb;
 	v9ses = v9fs_inode2v9ses(file_inode);
 	v9fid = v9fs_fid_clone(file);
 	if(IS_ERR(v9fid))
 		return PTR_ERR(v9fid);

-	fid = v9fid->fid;
-	if (fid < 0) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "inode #%lu, no fid!\n",
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
-	p9_idpool_put(fid, v9ses->fidpool);
-	v9fs_fid_destroy(v9fid);
-
-Error:
-	kfree(fcall);
-	return result;
+	return p9_client_remove(v9fid);
 }

 static int
@@ -444,61 +373,58 @@ v9fs_open_created(struct inode *inode, struct file *file)
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
+static struct p9_fid *v9fs_create(struct v9fs_session_info *v9ses,
struct inode *dir,
+	struct dentry *dentry, char *extension, u32 perm, u8 mode)
 {
 	int err;
-	u32 fid, perm, iounit;
-	int flags;
-	struct v9fs_session_info *v9ses;
-	struct v9fs_fid *dfid, *vfid, *ffid;
+	char *name;
+	struct p9_fid *dfid, *ofid, *fid;
 	struct inode *inode;
-	struct p9_qid qid;
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
+	ofid = p9_client_walk(dfid, 0, NULL, 1);
+	if (IS_ERR(ofid)) {
+		err = PTR_ERR(ofid);
+		ofid = NULL;
+		goto error;
+	}

-	if (err)
-		goto clunk_dfid;
+	err = p9_client_fcreate(ofid, name, perm, mode, extension);
+	if (err < 0)
+		goto error;

-	vfid = v9fs_clone_walk(v9ses, dfid->fid, dentry);
-	v9fs_fid_clunk(v9ses, dfid);
-	if (IS_ERR(vfid)) {
-		err = PTR_ERR(vfid);
-		vfid = NULL;
+	/* now walk from the parent so we can get unopened fid */
+	fid = p9_client_walk(dfid, 1, &name, 0);
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

@@ -506,35 +432,77 @@ v9fs_vfs_create(struct inode *dir, struct dentry
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
+		p9_client_clunk(dfid);
+
+	if (ofid)
+		p9_client_clunk(ofid);
+
+	if (fid)
+		p9_client_clunk(fid);
+
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
+	struct p9_fid *fid;
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
+		p9_client_clunk(fid);

 	return 0;

-clunk_dfid:
-	v9fs_fid_clunk(v9ses, dfid);
-
 error:
-	if (vfid)
-		v9fs_fid_destroy(vfid);
+	if (fid)
+		p9_client_clunk(fid);

 	return err;
 }
@@ -550,57 +518,23 @@ error:
 static int v9fs_vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 {
 	int err;
-	u32 fid, perm;
+	u32 perm;
 	struct v9fs_session_info *v9ses;
-	struct v9fs_fid *dfid, *vfid;
-	struct inode *inode;
+	struct p9_fid *fid;

-	inode = NULL;
-	vfid = NULL;
+	P9_DPRINTK(P9_DEBUG_VFS, "name %s\n", dentry->d_name.name);
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
-		perm, P9_OREAD, NULL, &fid, NULL, NULL);
-
-	if (err) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "create error %d\n", err);
-		goto clean_up_dfid;
-	}
-
-	vfid = v9fs_clone_walk(v9ses, dfid->fid, dentry);
-	if (IS_ERR(vfid)) {
-		err = PTR_ERR(vfid);
-		vfid = NULL;
-		goto clean_up_dfid;
+	fid = v9fs_create(v9ses, dir, dentry, NULL, perm, P9_OREAD);
+	if (IS_ERR(fid)) {
+		err = PTR_ERR(fid);
+		fid = NULL;
 	}

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
+	if (fid)
+		p9_client_clunk(fid);

-clean_up_dfid:
-	v9fs_fid_clunk(v9ses, dfid);
-
-error:
 	return err;
 }

@@ -617,12 +551,9 @@ static struct dentry *v9fs_vfs_lookup(struct
inode *dir, struct dentry *dentry,
 {
 	struct super_block *sb;
 	struct v9fs_session_info *v9ses;
-	struct v9fs_fid *dirfid;
-	struct v9fs_fid *fid;
+	struct p9_fid *dfid, *fid;
 	struct inode *inode;
-	struct p9_fcall *fcall = NULL;
-	int dirfidnum = -1;
-	int newfid = -1;
+	char *name;
 	int result = 0;

 	P9_DPRINTK(P9_DEBUG_VFS, "dir: %p dentry: (%s) %p nameidata: %p\n",
@@ -630,91 +561,44 @@ static struct dentry *v9fs_vfs_lookup(struct
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
-	newfid = p9_idpool_get(v9ses->fidpool);
-	if (newfid < 0) {
-		P9_EPRINTK(KERN_WARNING, "newfid fails!\n");
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
-		if (fcall && fcall->id == P9_RWALK)
-			v9fs_t_clunk(v9ses, newfid);
-		else
-			p9_idpool_put(newfid, v9ses->fidpool);
-
+	dfid = v9fs_fid_lookup(dentry->d_parent);
+	if(IS_ERR(dfid))
+		return ERR_PTR(PTR_ERR(dfid));
+
+	name = (char *) dentry->d_name.name;
+	fid = p9_client_walk(dfid, 1, &name, 1);
+	if (IS_ERR(fid)) {
+		result = PTR_ERR(fid);
 		if (result == -ENOENT) {
 			d_add(dentry, NULL);
-			P9_DPRINTK(P9_DEBUG_VFS,
-				"Return negative dentry %p count %d\n",
-				dentry, atomic_read(&dentry->d_count));
-			kfree(fcall);
 			return NULL;
 		}
-		P9_DPRINTK(P9_DEBUG_ERROR, "walk error:%d\n", result);
-		goto FreeFcall;
-	}
-	kfree(fcall);

-	result = v9fs_t_stat(v9ses, newfid, &fcall);
-	if (result < 0) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "stat error\n");
-		goto FreeFcall;
+		return ERR_PTR(result);
 	}

-	inode = v9fs_get_inode(sb, p9mode2unixmode(v9ses,
-		fcall->params.rstat.stat.mode));
-
-	if (IS_ERR(inode) && (PTR_ERR(inode) == -ENOSPC)) {
-		P9_EPRINTK(KERN_WARNING, "inode alloc failes, returns %ld\n",
-			PTR_ERR(inode));
-
-		result = -ENOSPC;
-		goto FreeFcall;
-	}
-
-	inode->i_ino = v9fs_qid2ino(&fcall->params.rstat.stat.qid);
-
-	fid = v9fs_fid_create(v9ses, newfid);
-	if (fid == NULL) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "couldn't insert\n");
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
+		p9_client_clunk(fid);

 	return ERR_PTR(result);
 }
@@ -756,73 +640,53 @@ static int
 v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		struct inode *new_dir, struct dentry *new_dentry)
 {
-	struct inode *old_inode = old_dentry->d_inode;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(old_inode);
-	struct v9fs_fid *oldfid = v9fs_fid_lookup(old_dentry);
-	struct v9fs_fid *olddirfid;
-	struct v9fs_fid *newdirfid;
+	struct inode *old_inode;
+	struct v9fs_session_info *v9ses;
+	struct p9_fid *oldfid;
+	struct p9_fid *olddirfid;
+	struct p9_fid *newdirfid;
 	struct p9_wstat wstat;
-	struct p9_fcall *fcall = NULL;
-	int fid = -1;
-	int olddirfidnum = -1;
-	int newdirfidnum = -1;
-	int retval = 0;
+	int retval;

 	P9_DPRINTK(P9_DEBUG_VFS, "\n");
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
 		P9_DPRINTK(P9_DEBUG_ERROR, "old dir and new dir are different\n");
 		retval = -EXDEV;
-		goto Clunk_newdir;
-	}
-
-	fid = oldfid->fid;
-	olddirfidnum = olddirfid->fid;
-	newdirfidnum = newdirfid->fid;
-
-	if (fid < 0) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "no fid for old file #%lu\n",
-			old_inode->i_ino);
-		retval = -EBADF;
-		goto Clunk_newdir;
+		goto clunk_newdir;
 	}

 	v9fs_blank_wstat(&wstat);
 	wstat.muid = v9ses->name;
 	wstat.name = (char *) new_dentry->d_name.name;
+	retval = p9_client_wstat(oldfid, &wstat);

-	retval = v9fs_t_wstat(v9ses, fid, &wstat, &fcall);
-
-	if (retval < 0)
-		PRINT_FCALL_ERROR("wstat error", fcall);
-
-	kfree(fcall);
-
-Clunk_newdir:
-	v9fs_fid_clunk(v9ses, newdirfid);
+clunk_newdir:
+	p9_client_clunk(olddirfid);

-Clunk_olddir:
-	v9fs_fid_clunk(v9ses, olddirfid);
-
-Release_lock:
-	up(&oldfid->lock);
+clunk_olddir:
+	p9_client_clunk(newdirfid);

+done:
 	return retval;
 }

@@ -838,28 +702,27 @@ static int
 v9fs_vfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		 struct kstat *stat)
 {
-	struct p9_fcall *fcall = NULL;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
-	struct v9fs_fid *fid = v9fs_fid_clone(dentry);
-	int err = -EPERM;
+	int err;
+	struct v9fs_session_info *v9ses;
+	struct p9_fid *fid;
+	struct p9_stat *st;

 	P9_DPRINTK(P9_DEBUG_VFS, "dentry: %p\n", dentry);
-	if(IS_ERR(fid))
+	err = -EPERM;
+	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	fid = v9fs_fid_lookup(dentry);
+	if (IS_ERR(fid))
 		return PTR_ERR(fid);

-	err = v9fs_t_stat(v9ses, fid->fid, &fcall);
+	st = p9_client_stat(fid);
+	if (IS_ERR(st))
+		return PTR_ERR(st);

-	if (err < 0)
-		P9_DPRINTK(P9_DEBUG_ERROR, "stat error\n");
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
@@ -871,13 +734,15 @@ v9fs_vfs_getattr(struct vfsmount *mnt, struct
dentry *dentry,

 static int v9fs_vfs_setattr(struct dentry *dentry, struct iattr *iattr)
 {
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
-	struct v9fs_fid *fid = v9fs_fid_clone(dentry);
-	struct p9_fcall *fcall = NULL;
+	int retval;
+	struct v9fs_session_info *v9ses;
+	struct p9_fid *fid;
 	struct p9_wstat wstat;
-	int res = -EPERM;

 	P9_DPRINTK(P9_DEBUG_VFS, "\n");
+	retval = -EPERM;
+	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	fid = v9fs_fid_lookup(dentry);
 	if(IS_ERR(fid))
 		return PTR_ERR(fid);

@@ -902,17 +767,11 @@ static int v9fs_vfs_setattr(struct dentry
*dentry, struct iattr *iattr)
 			wstat.n_gid = iattr->ia_gid;
 	}

-	res = v9fs_t_wstat(v9ses, fid->fid, &wstat, &fcall);
-
-	if (res < 0)
-		PRINT_FCALL_ERROR("wstat error", fcall);
+	retval = p9_client_wstat(fid, &wstat);
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
@@ -974,8 +833,8 @@ v9fs_stat2inode(struct p9_stat *stat, struct inode *inode,

 	inode->i_size = stat->length;

-	inode->i_blocks =
-	    (inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
+	/* not real number of blocks, but 512 byte ones ... */
+	inode->i_blocks = (inode->i_size + 512 - 1) >> 9;
 }

 /**
@@ -1008,56 +867,45 @@ ino_t v9fs_qid2ino(struct p9_qid *qid)

 static int v9fs_readlink(struct dentry *dentry, char *buffer, int buflen)
 {
-	int retval = -EPERM;
+	int retval;

-	struct p9_fcall *fcall = NULL;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
-	struct v9fs_fid *fid = v9fs_fid_clone(dentry);
+	struct v9fs_session_info *v9ses;
+	struct p9_fid *fid;
+	struct p9_stat *st;

+	P9_DPRINTK(P9_DEBUG_VFS, " %s\n", dentry->d_name.name);
+	retval = -EPERM;
+	v9ses = v9fs_inode2v9ses(dentry->d_inode);
+	fid = v9fs_fid_lookup(dentry);
 	if(IS_ERR(fid))
 		return PTR_ERR(fid);

-	if (!v9ses->extended) {
-		retval = -EBADF;
-		P9_DPRINTK(P9_DEBUG_ERROR, "not extended\n");
-		goto ClunkFid;
-	}
-
-	P9_DPRINTK(P9_DEBUG_VFS, " %s\n", dentry->d_name.name);
-	retval = v9fs_t_stat(v9ses, fid->fid, &fcall);
-
-	if (retval < 0) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "stat error\n");
-		goto FreeFcall;
-	}
+	if (!v9ses->extended)
+		return -EBADF;

-	if (!fcall) {
-		retval = -EIO;
-		goto ClunkFid;
-	}
+	st = p9_client_stat(fid);
+	if (IS_ERR(st))
+		return PTR_ERR(st);

-	if (!(fcall->params.rstat.stat.mode & P9_DMSYMLINK)) {
+	if (!(st->mode & P9_DMSYMLINK)) {
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

-	P9_DPRINTK(P9_DEBUG_ERROR, "%s -> %.*s (%s)\n", dentry->d_name.name,
fcall->params.rstat.stat.extension.len,
-		fcall->params.rstat.stat.extension.str, buffer);
-	retval = buflen;
+	P9_DPRINTK(P9_DEBUG_VFS, "%s -> %.*s (%s)\n", dentry->d_name.name,
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

@@ -1147,11 +995,9 @@ static void v9fs_vfs_put_link(struct dentry
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
+	struct p9_fid *fid;

 	v9ses = v9fs_inode2v9ses(dir);
 	if (!v9ses->extended) {
@@ -1159,54 +1005,13 @@ static int v9fs_vfs_mkspecial(struct inode
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
+	fid = v9fs_create(v9ses, dir, dentry, (char *) extension, perm, P9_OREAD);
+	if(IS_ERR(fid))
+		return PTR_ERR(fid);

-	err = v9fs_create(v9ses, dfid->fid, (char *) dentry->d_name.name,
-		perm, P9_OREAD, (char *) extension, &fid, NULL, NULL);
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
+	p9_client_clunk(fid);
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
@@ -1245,8 +1050,7 @@ v9fs_vfs_link(struct dentry *old_dentry, struct
inode *dir,
 	      struct dentry *dentry)
 {
 	int retval;
-	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dir);
-	struct v9fs_fid *oldfid;
+	struct p9_fid *oldfid;
 	char *name;

 	P9_DPRINTK(P9_DEBUG_VFS, " %lu,%s,%s\n", dir->i_ino, dentry->d_name.name,
@@ -1267,7 +1071,7 @@ v9fs_vfs_link(struct dentry *old_dentry, struct
inode *dir,
 	__putname(name);

 clunk_fid:
-	v9fs_fid_clunk(v9ses, oldfid);
+	p9_client_clunk(oldfid);
 	return retval;
 }

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 02b9764..d8cf3e5 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -38,6 +38,8 @@
 #include <linux/mount.h>
 #include <linux/idr.h>
 #include <net/9p/9p.h>
+#include <net/9p/client.h>
+
 #include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"
@@ -105,16 +107,14 @@ static int v9fs_get_sb(struct file_system_type
*fs_type, int flags,
 		       struct vfsmount *mnt)
 {
 	struct super_block *sb = NULL;
-	struct p9_fcall *fcall = NULL;
 	struct inode *inode = NULL;
 	struct dentry *root = NULL;
 	struct v9fs_session_info *v9ses = NULL;
-	struct v9fs_fid *root_fid = NULL;
+	struct p9_stat *st = NULL;
 	int mode = S_IRWXUGO | S_ISVTX;
 	uid_t uid = current->fsuid;
 	gid_t gid = current->fsgid;
-	int stat_result = 0;
-	int newfid = 0;
+	struct p9_fid *fid;
 	int retval = 0;

 	P9_DPRINTK(P9_DEBUG_VFS, " \n");
@@ -123,23 +123,32 @@ static int v9fs_get_sb(struct file_system_type
*fs_type, int flags,
 	if (!v9ses)
 		return -ENOMEM;

-	if ((newfid = v9fs_session_init(v9ses, dev_name, data)) < 0) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "problem initiating session\n");
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
+	st = p9_client_stat(fid);
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
@@ -148,54 +157,30 @@ static int v9fs_get_sb(struct file_system_type
*fs_type, int flags,
 	root = d_alloc_root(inode);
 	if (!root) {
 		retval = -ENOMEM;
-		goto put_back_sb;
+		goto error;
 	}

 	sb->s_root = root;
+	root->d_inode->i_ino = v9fs_qid2ino(&st->qid);
+	v9fs_stat2inode(st, root->d_inode, sb);
+	v9fs_fid_add(root, fid);

-	stat_result = v9fs_t_stat(v9ses, newfid, &fcall);
-	if (stat_result < 0) {
-		P9_DPRINTK(P9_DEBUG_ERROR, "stat error\n");
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
+	return simple_set_mnt(mnt, sb);

-	kfree(fcall);
+error:
+	if (fid)
+		p9_client_clunk(fid);

-	if (stat_result < 0) {
-		retval = stat_result;
-		goto put_back_sb;
+	if (v9ses) {
+		v9fs_session_close(v9ses);
+		kfree(v9ses);
 	}

-	return simple_set_mnt(mnt, sb);
-
-out_close_session:
-	v9fs_session_close(v9ses);
-out_free_session:
-	kfree(v9ses);
-	return retval;
+	if (sb) {
+		up_write(&sb->s_umount);
+		deactivate_super(sb);
+	}

-put_back_sb:
-	/* deactivate_super calls v9fs_kill_super which will frees the rest */
-	up_write(&sb->s_umount);
-	deactivate_super(sb);
 	return retval;
 }

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
new file mode 100644
index 0000000..b79d865
--- /dev/null
+++ b/include/net/9p/client.h
@@ -0,0 +1,77 @@
+/*
+ * include/net/9p/client.h
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
+#ifndef NET_9P_CLIENT_H
+#define NET_9P_CLIENT_H
+
+struct p9_client {
+	spinlock_t lock;
+	int msize;
+	unsigned char dotu;
+	struct p9_transport *trans;
+	struct p9_conn *conn;
+
+	struct p9_idpool *fidpool;
+	struct list_head fidlist;
+};
+
+struct p9_fid {
+	struct p9_client *clnt;
+	u32 fid;
+	int mode;
+	struct p9_qid qid;
+	u32 iounit;
+	uid_t uid;
+	void *aux;
+
+	int rdir_fpos;
+	int rdir_pos;
+	struct p9_fcall *rdir_fcall;
+	struct list_head flist;
+	struct list_head dlist;	// list of all fids attached to a dentry
+};
+
+struct p9_client *p9_client_create(struct p9_transport *trans, int
msize, int dotu);
+void p9_client_destroy(struct p9_client *clnt);
+void p9_client_disconnect(struct p9_client *clnt);
+struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
+	char *uname, char *aname);
+struct p9_fid *p9_client_auth(struct p9_client *clnt, char *uname,
char *aname);
+struct p9_fid *p9_client_walk(struct p9_fid *oldfid, int nwname, char **wnames,
+	int clone);
+int p9_client_open(struct p9_fid *fid, int mode);
+int p9_client_fcreate(struct p9_fid *fid, char *name, u32 perm, int mode,
+	char *extension);
+int p9_client_clunk(struct p9_fid *fid);
+int p9_client_remove(struct p9_fid *fid);
+int p9_client_read(struct p9_fid *fid, char *data, u64 offset, u32 count);
+int p9_client_readn(struct p9_fid *fid, char *data, u64 offset, u32 count);
+int p9_client_write(struct p9_fid *fid, char *data, u64 offset, u32 count);
+int p9_client_uread(struct p9_fid *fid, char __user *data, u64
offset, u32 count);
+int p9_client_uwrite(struct p9_fid *fid, const char __user *data, u64
offset, u32 count);
+struct p9_stat *p9_client_stat(struct p9_fid *fid);
+int p9_client_wstat(struct p9_fid *fid, struct p9_wstat *wst);
+struct p9_stat *p9_client_dirread(struct p9_fid *fid, u64 offset);
+
+#endif /* NET_9P_CLIENT_H */
diff --git a/net/9p/client.c b/net/9p/client.c
new file mode 100644
index 0000000..f0c7ef0
--- /dev/null
+++ b/net/9p/client.c
@@ -0,0 +1,955 @@
+/*
+ * net/9p/clnt.c
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
+#include <net/9p/9p.h>
+#include <net/9p/transport.h>
+#include <net/9p/conn.h>
+#include <net/9p/client.h>
+
+static struct p9_fid *p9_fid_create(struct p9_client *clnt);
+static void p9_fid_destroy(struct p9_fid *fid);
+static struct p9_stat *p9_clone_stat(struct p9_stat *st, int dotu);
+
+struct p9_client *p9_client_create(struct p9_transport *trans, int
msize, int dotu)
+{
+	int err, n;
+	struct p9_client *clnt;
+	struct p9_fcall *tc, *rc;
+	struct p9_str *version;
+
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = kmalloc(sizeof(struct p9_client), GFP_KERNEL);
+	if (!clnt)
+		return ERR_PTR(-ENOMEM);
+
+	P9_DPRINTK(P9_DEBUG_9P, "clnt %p trans %p msize %d dotu %d\n",
+		clnt, trans, msize, dotu);
+	spin_lock_init(&clnt->lock);
+	clnt->trans = trans;
+	clnt->msize = msize;
+	clnt->dotu = dotu;
+	INIT_LIST_HEAD(&clnt->fidlist);
+	clnt->fidpool = p9_idpool_create();
+	if (!clnt->fidpool) {
+		err = PTR_ERR(clnt->fidpool);
+		clnt->fidpool = NULL;
+		goto error;
+	}
+
+	clnt->conn = p9_conn_create(clnt->trans, clnt->msize, &clnt->dotu);
+	if (IS_ERR(clnt->conn)) {
+		err = PTR_ERR(clnt->conn);
+		clnt->conn = NULL;
+		goto error;
+	}
+
+	tc = p9_create_tversion(clnt->msize, clnt->dotu?"9P2000.u":"9P2000");
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto error;
+	}
+
+	err = p9_conn_rpc(clnt->conn, tc, &rc);
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
+	p9_client_destroy(clnt);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(p9_client_create);
+
+void p9_client_destroy(struct p9_client *clnt)
+{
+	struct p9_fid *fid, *fidptr;
+
+	P9_DPRINTK(P9_DEBUG_9P, "clnt %p\n", clnt);
+	if (clnt->conn) {
+		p9_conn_destroy(clnt->conn);
+		clnt->conn = NULL;
+	}
+
+	if (clnt->trans) {
+		clnt->trans->close(clnt->trans);
+		kfree(clnt->trans);
+		clnt->trans = NULL;
+	}
+
+	if (clnt->fidpool)
+		p9_idpool_destroy(clnt->fidpool);
+
+	list_for_each_entry_safe(fid, fidptr, &clnt->fidlist, flist)
+		p9_fid_destroy(fid);
+
+	kfree(clnt);
+}
+EXPORT_SYMBOL(p9_client_destroy);
+
+void p9_client_disconnect(struct p9_client *clnt)
+{
+	P9_DPRINTK(P9_DEBUG_9P, "clnt %p\n", clnt);
+	clnt->trans->status = Disconnected;
+	p9_conn_cancel(clnt->conn, -EIO);
+}
+EXPORT_SYMBOL(p9_client_disconnect);
+
+struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
+	char *uname, char *aname)
+{
+	int err;
+	struct p9_fcall *tc, *rc;
+	struct p9_fid *fid;
+
+	P9_DPRINTK(P9_DEBUG_9P, "clnt %p afid %d uname %s aname %s\n",
+		clnt, afid?afid->fid:-1, uname, aname);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+
+	fid = p9_fid_create(clnt);
+	if (IS_ERR(fid)) {
+		err = PTR_ERR(fid);
+		fid = NULL;
+		goto error;
+	}
+
+	tc = p9_create_tattach(fid->fid, afid?afid->fid:P9_NOFID, uname, aname);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto error;
+	}
+
+	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	if (err)
+		goto error;
+
+	memmove(&fid->qid, &rc->params.rattach.qid, sizeof(struct p9_qid));
+	kfree(tc);
+	kfree(rc);
+	return fid;
+
+error:
+	kfree(tc);
+	kfree(rc);
+	if (fid)
+		p9_fid_destroy(fid);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(p9_client_attach);
+
+struct p9_fid *p9_client_auth(struct p9_client *clnt, char *uname, char *aname)
+{
+	int err;
+	struct p9_fcall *tc, *rc;
+	struct p9_fid *fid;
+
+	P9_DPRINTK(P9_DEBUG_9P, "clnt %p uname %s aname %s\n", clnt, uname, aname);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+
+	fid = p9_fid_create(clnt);
+	if (IS_ERR(fid)) {
+		err = PTR_ERR(fid);
+		fid = NULL;
+		goto error;
+	}
+
+	tc = p9_create_tauth(fid->fid, uname, aname);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto error;
+	}
+
+	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	if (err)
+		goto error;
+
+	memmove(&fid->qid, &rc->params.rauth.qid, sizeof(struct p9_qid));
+	kfree(tc);
+	kfree(rc);
+	return fid;
+
+error:
+	kfree(tc);
+	kfree(rc);
+	if (fid)
+		p9_fid_destroy(fid);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(p9_client_auth);
+
+struct p9_fid *p9_client_walk(struct p9_fid *oldfid, int nwname, char **wnames,
+	int clone)
+{
+	int err;
+	struct p9_fcall *tc, *rc;
+	struct p9_client *clnt;
+	struct p9_fid *fid;
+
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d nwname %d wname[0] %s\n",
+		oldfid->fid, nwname, wnames?wnames[0]:NULL);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = oldfid->clnt;
+	if (clone) {
+		fid = p9_fid_create(clnt);
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
+	tc = p9_create_twalk(oldfid->fid, fid->fid, nwname, wnames);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto error;
+	}
+
+	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	if (err) {
+		if (rc && rc->id == P9_RWALK)
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
+			sizeof(struct p9_qid));
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
+	tc = p9_create_tclunk(fid->fid);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto error;
+	}
+
+	p9_conn_rpc(clnt->conn, tc, &rc);
+
+error:
+	kfree(tc);
+	kfree(rc);
+	if (fid && fid!=oldfid)
+		p9_fid_destroy(fid);
+
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(p9_client_walk);
+
+int p9_client_open(struct p9_fid *fid, int mode)
+{
+	int err;
+	struct p9_fcall *tc, *rc;
+	struct p9_client *clnt;
+
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d mode %d\n", fid->fid, mode);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+
+	if (fid->mode != -1)
+		return -EINVAL;
+
+	tc = p9_create_topen(fid->fid, mode);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto done;
+	}
+
+	err = p9_conn_rpc(clnt->conn, tc, &rc);
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
+EXPORT_SYMBOL(p9_client_open);
+
+int p9_client_fcreate(struct p9_fid *fid, char *name, u32 perm, int mode,
+		     char *extension)
+{
+	int err;
+	struct p9_fcall *tc, *rc;
+	struct p9_client *clnt;
+
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d name %s perm %d mode %d\n", fid->fid,
+		name, perm, mode);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+
+	if (fid->mode != -1)
+		return -EINVAL;
+
+	tc = p9_create_tcreate(fid->fid, name, perm, mode, extension,
+		clnt->dotu);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto done;
+	}
+
+	err = p9_conn_rpc(clnt->conn, tc, &rc);
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
+EXPORT_SYMBOL(p9_client_fcreate);
+
+int p9_client_clunk(struct p9_fid *fid)
+{
+	int err;
+	struct p9_fcall *tc, *rc;
+	struct p9_client *clnt;
+
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d\n", fid->fid);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+
+	tc = p9_create_tclunk(fid->fid);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto done;
+	}
+
+	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	if (err)
+		goto done;
+
+	p9_fid_destroy(fid);
+
+done:
+	kfree(tc);
+	kfree(rc);
+	return err;
+}
+EXPORT_SYMBOL(p9_client_clunk);
+
+int p9_client_remove(struct p9_fid *fid)
+{
+	int err;
+	struct p9_fcall *tc, *rc;
+	struct p9_client *clnt;
+
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d\n", fid->fid);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+
+	tc = p9_create_tremove(fid->fid);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto done;
+	}
+
+	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	if (err)
+		goto done;
+
+	p9_fid_destroy(fid);
+
+done:
+	kfree(tc);
+	kfree(rc);
+	return err;
+}
+EXPORT_SYMBOL(p9_client_remove);
+
+int p9_client_read(struct p9_fid *fid, char *data, u64 offset, u32 count)
+{
+	int err, n, rsize, total;
+	struct p9_fcall *tc, *rc;
+	struct p9_client *clnt;
+
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d offset %lld %d\n", fid->fid, offset, count);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+	total = 0;
+
+	rsize = fid->iounit;
+	if (!rsize || rsize>clnt->msize-P9_IOHDRSZ)
+		rsize = clnt->msize - P9_IOHDRSZ;
+
+	do {
+		if (count < rsize)
+			rsize = count;
+
+		tc = p9_create_tread(fid->fid, offset, rsize);
+		if (IS_ERR(tc)) {
+			err = PTR_ERR(tc);
+			tc = NULL;
+			goto error;
+		}
+
+		err = p9_conn_rpc(clnt->conn, tc, &rc);
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
+EXPORT_SYMBOL(p9_client_read);
+
+int p9_client_write(struct p9_fid *fid, char *data, u64 offset, u32 count)
+{
+	int err, n, rsize, total;
+	struct p9_fcall *tc, *rc;
+	struct p9_client *clnt;
+
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d offset %lld count %d\n", fid->fid, offset,
+		count);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+	total = 0;
+
+	rsize = fid->iounit;
+	if (!rsize || rsize>clnt->msize-P9_IOHDRSZ)
+		rsize = clnt->msize - P9_IOHDRSZ;
+
+	do {
+		if (count < rsize)
+			rsize = count;
+
+		tc = p9_create_twrite(fid->fid, offset, rsize, data);
+		if (IS_ERR(tc)) {
+			err = PTR_ERR(tc);
+			tc = NULL;
+			goto error;
+		}
+
+		err = p9_conn_rpc(clnt->conn, tc, &rc);
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
+EXPORT_SYMBOL(p9_client_write);
+
+int p9_client_uread(struct p9_fid *fid, char __user *data, u64
offset, u32 count)
+{
+	int err, n, rsize, total;
+	struct p9_fcall *tc, *rc;
+	struct p9_client *clnt;
+
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d offset %lld count %d\n", fid->fid, offset,
+		count);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+	total = 0;
+
+	rsize = fid->iounit;
+	if (!rsize || rsize>clnt->msize-P9_IOHDRSZ)
+		rsize = clnt->msize - P9_IOHDRSZ;
+
+	do {
+		if (count < rsize)
+			rsize = count;
+
+		tc = p9_create_tread(fid->fid, offset, rsize);
+		if (IS_ERR(tc)) {
+			err = PTR_ERR(tc);
+			tc = NULL;
+			goto error;
+		}
+
+		err = p9_conn_rpc(clnt->conn, tc, &rc);
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
+EXPORT_SYMBOL(p9_client_uread);
+
+int p9_client_uwrite(struct p9_fid *fid, const char __user *data, u64
offset, u32 count)
+{
+	int err, n, rsize, total;
+	struct p9_fcall *tc, *rc;
+	struct p9_client *clnt;
+
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d offset %lld count %d\n", fid->fid, offset,
+		count);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+	total = 0;
+
+	rsize = fid->iounit;
+	if (!rsize || rsize>clnt->msize-P9_IOHDRSZ)
+		rsize = clnt->msize - P9_IOHDRSZ;
+
+	do {
+		if (count < rsize)
+			rsize = count;
+
+		tc = p9_create_twrite_u(fid->fid, offset, rsize, data);
+		if (IS_ERR(tc)) {
+			err = PTR_ERR(tc);
+			tc = NULL;
+			goto error;
+		}
+
+		err = p9_conn_rpc(clnt->conn, tc, &rc);
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
+EXPORT_SYMBOL(p9_client_uwrite);
+
+int p9_client_readn(struct p9_fid *fid, char *data, u64 offset, u32 count)
+{
+	int n, total;
+
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d offset %lld count %d\n", fid->fid, offset,
+		count);
+	n = 0;
+	total = 0;
+	while (count) {
+		n = p9_client_read(fid, data, offset, count);
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
+EXPORT_SYMBOL(p9_client_readn);
+
+struct p9_stat *p9_client_stat(struct p9_fid *fid)
+{
+	int err;
+	struct p9_fcall *tc, *rc;
+	struct p9_client *clnt;
+	struct p9_stat *ret;
+
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d\n", fid->fid);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	ret = NULL;
+	clnt = fid->clnt;
+
+	tc = p9_create_tstat(fid->fid);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto error;
+	}
+
+	err = p9_conn_rpc(clnt->conn, tc, &rc);
+	if (err)
+		goto error;
+
+	ret = p9_clone_stat(&rc->params.rstat.stat, clnt->dotu);
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
+EXPORT_SYMBOL(p9_client_stat);
+
+int p9_client_wstat(struct p9_fid *fid, struct p9_wstat *wst)
+{
+	int err;
+	struct p9_fcall *tc, *rc;
+	struct p9_client *clnt;
+
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d\n", fid->fid);
+	err = 0;
+	tc = NULL;
+	rc = NULL;
+	clnt = fid->clnt;
+
+	tc = p9_create_twstat(fid->fid, wst, clnt->dotu);
+	if (IS_ERR(tc)) {
+		err = PTR_ERR(tc);
+		tc = NULL;
+		goto done;
+	}
+
+	err = p9_conn_rpc(clnt->conn, tc, &rc);
+
+done:
+	kfree(tc);
+	kfree(rc);
+	return err;
+}
+EXPORT_SYMBOL(p9_client_wstat);
+
+struct p9_stat *p9_client_dirread(struct p9_fid *fid, u64 offset)
+{
+	int err, n, m;
+	struct p9_fcall *tc, *rc;
+	struct p9_client *clnt;
+	struct p9_stat st, *ret;
+
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d offset %lld\n", fid->fid, offset);
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
+		if (!n || n>clnt->msize-P9_IOHDRSZ)
+			n = clnt->msize - P9_IOHDRSZ;
+
+		while (1) {
+			if (fid->rdir_fcall) {
+				fid->rdir_fpos += fid->rdir_fcall->params.rread.count;
+				kfree(fid->rdir_fcall);
+				fid->rdir_fcall = NULL;
+			}
+
+			tc = p9_create_tread(fid->fid, fid->rdir_fpos, n);
+			if (IS_ERR(tc)) {
+				err = PTR_ERR(tc);
+				tc = NULL;
+				goto error;
+			}
+
+			err = p9_conn_rpc(clnt->conn, tc, &rc);
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
+	n = p9_deserialize_stat(fid->rdir_fcall->params.rread.data + m,
+		fid->rdir_fcall->params.rread.count - m, &st, clnt->dotu);
+
+	if (!n) {
+		err = -EIO;
+		goto error;
+	}
+
+	fid->rdir_pos += n;
+	st.size = n;
+	ret = p9_clone_stat(&st, clnt->dotu);
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
+EXPORT_SYMBOL(p9_client_dirread);
+
+static struct p9_stat *p9_clone_stat(struct p9_stat *st, int dotu)
+{
+	int n;
+	char *p;
+	struct p9_stat *ret;
+
+	n = sizeof(struct p9_stat) + st->name.len + st->uid.len + st->gid.len +
+		st->muid.len;
+
+	if (dotu)
+		n += st->extension.len;
+
+	ret = kmalloc(n, GFP_KERNEL);
+	if (!ret)
+		return ERR_PTR(-ENOMEM);
+
+	memmove(ret, st, sizeof(struct p9_stat));
+	p = ((char *) ret) + sizeof(struct p9_stat);
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
+static struct p9_fid *p9_fid_create(struct p9_client *clnt)
+{
+	int err;
+	struct p9_fid *fid;
+
+	P9_DPRINTK(P9_DEBUG_9P, "clnt %p\n", clnt);
+	fid = kmalloc(sizeof(struct p9_fid), GFP_KERNEL);
+	if (!fid)
+		return ERR_PTR(-ENOMEM);
+
+	fid->fid = p9_idpool_get(clnt->fidpool);
+	if (fid->fid < 0) {
+		err = -ENOSPC;
+		goto error;
+	}
+
+	memset(&fid->qid, 0, sizeof(struct p9_qid));
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
+static void p9_fid_destroy(struct p9_fid *fid)
+{
+	struct p9_client *clnt;
+
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d\n", fid->fid);
+	clnt = fid->clnt;
+	p9_idpool_put(fid->fid, clnt->fidpool);
+	spin_lock(&clnt->lock);
+	list_del(&fid->flist);
+	spin_unlock(&clnt->lock);
+	kfree(fid->rdir_fcall);
+	kfree(fid);
+}
-- 
1.4.4.2
