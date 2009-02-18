Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZBRSjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZBRSjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbZBRSi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:38:57 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:28089 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbZBRSi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:38:56 -0500
Date: Wed, 18 Feb 2009 10:39:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH] staging/pohmelfs: fix quota build error and printk formats
Message-Id: <20090218103932.6a7880f9.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.499C55B3.0260:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix pohmelfs for disk quota changes and printk format warnings:

drivers/staging/pohmelfs/inode.c:917: warning: format '%u' expects type 'unsigned int', but argument 4 has type 'size_t'
drivers/staging/pohmelfs/inode.c:982: error: implicit declaration of function 'DQUOT_TRANSFER'
drivers/staging/pohmelfs/inode.c:1036: warning: format '%u' expects type 'unsigned int', but argument 7 has type 'size_t'

drivers/staging/pohmelfs/trans.c:164: warning: format '%u' expects type 'unsigned int', but argument 5 has type '__kernel_size_t'
drivers/staging/pohmelfs/trans.c:170: warning: format '%u' expects type 'unsigned int', but argument 7 has type '__kernel_size_t'
drivers/staging/pohmelfs/trans.c:517: warning: format '%u' expects type 'unsigned int', but argument 6 has type '__kernel_size_t'
drivers/staging/pohmelfs/trans.c:600: warning: format '%u' expects type 'unsigned int', but argument 6 has type '__kernel_size_t'
drivers/staging/pohmelfs/trans.c:610: warning: format '%u' expects type 'unsigned int', but argument 7 has type '__kernel_size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/staging/pohmelfs/inode.c |    6 +++---
 drivers/staging/pohmelfs/trans.c |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

--- linux-next-20090218.orig/drivers/staging/pohmelfs/inode.c
+++ linux-next-20090218/drivers/staging/pohmelfs/inode.c
@@ -914,7 +914,7 @@ ssize_t pohmelfs_write(struct file *file
 	kiocb.ki_pos = pos;
 	kiocb.ki_left = len;
 
-	dprintk("%s: len: %u, pos: %llu.\n", __func__, len, pos);
+	dprintk("%s: len: %zu, pos: %llu.\n", __func__, len, pos);
 
 	mutex_lock(&inode->i_mutex);
 	ret = pohmelfs_data_lock(pi, pos, len, POHMELFS_WRITE_LOCK);
@@ -979,7 +979,7 @@ int pohmelfs_setattr_raw(struct inode *i
 
 	if ((attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
 	    (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid)) {
-		err = DQUOT_TRANSFER(inode, attr) ? -EDQUOT : 0;
+		err = vfs_dq_transfer(inode, attr) ? -EDQUOT : 0;
 		if (err)
 			goto err_out_exit;
 	}
@@ -1033,7 +1033,7 @@ static int pohmelfs_send_xattr_req(struc
 	struct netfs_cmd *cmd;
 	void *data;
 
-	dprintk("%s: id: %llu, start: %llu, name: '%s', attrsize: %u, cmd: %d.\n",
+	dprintk("%s: id: %llu, start: %llu, name: '%s', attrsize: %zu, cmd: %d.\n",
 			__func__, id, start, name, attrsize, command);
 
 	path_len = pohmelfs_path_length(pi);
--- linux-next-20090218.orig/drivers/staging/pohmelfs/trans.c
+++ linux-next-20090218/drivers/staging/pohmelfs/trans.c
@@ -160,14 +160,14 @@ int netfs_trans_send(struct netfs_trans 
 
 	err = kernel_sendmsg(st->socket, &msg, (struct kvec *)msg.msg_iov, 1, t->iovec.iov_len);
 	if (err <= 0) {
-		printk("%s: failed to send contig transaction: t: %p, gen: %u, size: %u, err: %d.\n",
+		printk("%s: failed to send contig transaction: t: %p, gen: %u, size: %zu, err: %d.\n",
 				__func__, t, t->gen, t->iovec.iov_len, err);
 		if (err == 0)
 			err = -ECONNRESET;
 		goto err_out_unlock_return;
 	}
 
-	dprintk("%s: sent %s transaction: t: %p, gen: %u, size: %u, page_num: %u.\n",
+	dprintk("%s: sent %s transaction: t: %p, gen: %u, size: %zu, page_num: %u.\n",
 			__func__, (t->page_num)?"partial":"full",
 			t, t->gen, t->iovec.iov_len, t->page_num);
 
@@ -514,7 +514,7 @@ int netfs_trans_finish(struct netfs_tran
 		cmd->csize = psb->crypto_attached_size;
 	}
 
-	dprintk("%s: t: %u, size: %u, iov_len: %u, attached_size: %u, attached_pages: %u.\n",
+	dprintk("%s: t: %u, size: %u, iov_len: %zu, attached_size: %u, attached_pages: %u.\n",
 			__func__, t->gen, cmd->size, t->iovec.iov_len, t->attached_size, t->attached_pages);
 	err = pohmelfs_trans_crypt(t, psb);
 	if (err) {
@@ -597,7 +597,7 @@ void *netfs_trans_add(struct netfs_trans
 	}
 
 	if (io->iov_len + size > t->total_size) {
-		dprintk("%s: too big size t: %p, gen: %u, iov_len: %u, size: %u, total: %u.\n",
+		dprintk("%s: too big size t: %p, gen: %u, iov_len: %zu, size: %u, total: %u.\n",
 				__func__, t, t->gen, io->iov_len, size, t->total_size);
 		ptr = ERR_PTR(-E2BIG);
 		goto out;
@@ -607,7 +607,7 @@ void *netfs_trans_add(struct netfs_trans
 	io->iov_len += size;
 
 out:
-	dprintk("%s: t: %p, gen: %u, size: %u, total: %u.\n",
+	dprintk("%s: t: %p, gen: %u, size: %u, total: %zu.\n",
 		__func__, t, t->gen, size, io->iov_len);
 	return ptr;
 }
