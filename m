Return-Path: <linux-kernel-owner+w=401wt.eu-S965414AbXDBKlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965414AbXDBKlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 06:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965417AbXDBKlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 06:41:11 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:59640 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965414AbXDBKlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 06:41:10 -0400
Date: Mon, 2 Apr 2007 12:41:07 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 13/16] show-pipesize-in-stat.diff
Message-Id: <20070402124107.06294b2e.dada1@cosmosbay.com>
In-Reply-To: <Pine.LNX.4.61.0704012010040.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704012010040.12316@yvahk01.tjqt.qr>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007 20:17:24 +0200 (MEST)
Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> Show the fill status of a pipe (in bytes) when stat'ing one.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
>  fs/stat.c             |   31 ++++++++++++++++++++++++++++++-
>  include/linux/un.h    |    2 ++
>  include/net/af_unix.h |    3 +++
>  net/unix/af_unix.c    |   10 ++++++++++
>  4 files changed, 45 insertions(+), 1 deletion(-)

Please dont do that, adding uggly tests in generic_fillattr()

The following patch does the right thing for pipes, I let you doing the same for sockets...

[PATCH] : fill the size of pipes

Instead of reporting 0 in size when stating() a pipe, we give the number of queued bytes. This might avoid using ioctl(FIONREAD) to get this information.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
--- linux-2.6.21-rc5-mm3/fs/pipe.c
+++ linux-2.6.21-rc5-mm3/fs/pipe.c
@@ -570,27 +570,34 @@ bad_pipe_w(struct file *filp, const char
 	return -EBADF;
 }
 
+static int pipe_size(struct inode *inode)
+{
+	struct pipe_inode_info *pipe;
+	int count, buf, nrbufs;
+
+	mutex_lock(&inode->i_mutex);
+	pipe = inode->i_pipe;
+	count = 0;
+	buf = pipe->curbuf;
+	nrbufs = pipe->nrbufs;
+	while (--nrbufs >= 0) {
+		count += pipe->bufs[buf].len;
+		buf = (buf+1) & (PIPE_BUFFERS-1);
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
+	int count;
 
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
@@ -908,6 +915,20 @@ static struct dentry_operations pipefs_d
 	.d_dname	= pipefs_dname,
 };
 
+int pipe_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		   struct kstat *stat)
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
@@ -921,6 +942,7 @@ static struct inode * get_pipe_inode(voi
 		goto fail_iput;
 	inode->i_pipe = pipe;
 
+	inode->i_op = &pipe_inode_operations;
 	pipe->readers = pipe->writers = 1;
 	inode->i_fop = &rdwr_pipe_fops;
 
