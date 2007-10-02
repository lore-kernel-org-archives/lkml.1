Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbXJBRzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbXJBRzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbXJBRyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:54:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45530 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbXJBRyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:54:54 -0400
Date: Tue, 2 Oct 2007 19:54:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-fsdevel@vger.kernel.org
Subject: [patch 1/2] getattr - fill the size of pipes
Message-ID: <Pine.LNX.4.64.0710021952450.7130@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH]: Fill the size of pipes

Instead of reporting 0 in size when stating() a pipe, we give the number of
queued bytes. This might avoid using ioctl(FIONREAD) to get this information.

References and derived from: http://lkml.org/lkml/2007/4/2/138
Cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 fs/pipe.c |   49 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 13 deletions(-)

Index: linux-2.6.23/fs/pipe.c
===================================================================
--- linux-2.6.23.orig/fs/pipe.c
+++ linux-2.6.23/fs/pipe.c
@@ -577,27 +577,35 @@ bad_pipe_w(struct file *filp, const char
 	return -EBADF;
 }
 
+static unsigned int pipe_size(struct inode *inode)
+{
+	struct pipe_inode_info *pipe;
+	unsigned int count, buf;
+	int nrbufs;
+
+	mutex_lock(&inode->i_mutex);
+	pipe   = inode->i_pipe;
+	count  = 0;
+	buf    = pipe->curbuf;
+	nrbufs = pipe->nrbufs;
+	while (--nrbufs >= 0) {
+		count += pipe->bufs[buf].len;
+		buf = (buf + 1) & (PIPE_BUFFERS - 1);
+	}
+	mutex_unlock(&inode->i_mutex);
+	return count;
+}
+
 static int
 pipe_ioctl(struct inode *pino, struct file *filp,
 	   unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
-	struct pipe_inode_info *pipe;
-	int count, buf, nrbufs;
+	unsigned int count;
 
 	switch (cmd) {
 		case FIONREAD:
-			mutex_lock(&inode->i_mutex);
-			pipe = inode->i_pipe;
-			count = 0;
-			buf = pipe->curbuf;
-			nrbufs = pipe->nrbufs;
-			while (--nrbufs >= 0) {
-				count += pipe->bufs[buf].len;
-				buf = (buf+1) & (PIPE_BUFFERS-1);
-			}
-			mutex_unlock(&inode->i_mutex);
-
+			count = pipe_size(inode);
 			return put_user(count, (int __user *)arg);
 		default:
 			return -EINVAL;
@@ -915,6 +923,20 @@ static struct dentry_operations pipefs_d
 	.d_dname	= pipefs_dname,
 };
 
+int pipe_getattr(struct vfsmount *mnt, struct dentry *dentry,
+                 struct kstat *stat)
+{
+	struct inode *inode = dentry->d_inode;
+
+	generic_fillattr(inode, stat);
+	stat->size = pipe_size(inode);
+	return 0;
+}
+
+const struct inode_operations pipe_inode_operations = {
+	.getattr = pipe_getattr,
+};
+
 static struct inode * get_pipe_inode(void)
 {
 	struct inode *inode = new_inode(pipe_mnt->mnt_sb);
@@ -928,6 +950,7 @@ static struct inode * get_pipe_inode(voi
 		goto fail_iput;
 	inode->i_pipe = pipe;
 
+	inode->i_op = &pipe_inode_operations;
 	pipe->readers = pipe->writers = 1;
 	inode->i_fop = &rdwr_pipe_fops;
 

