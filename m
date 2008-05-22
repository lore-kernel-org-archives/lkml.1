Return-Path: <linux-kernel-owner+w=401wt.eu-S1765081AbYEVVkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765081AbYEVVkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbYEVVj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:39:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55612 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755271AbYEVVj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:39:58 -0400
Date: Thu, 22 May 2008 22:27:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rpc: Push down the ioctl BKL into the RPC code
Message-ID: <20080522222730.311832af@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One or two bits I couldn't figure out if the BKL could be dropped for

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index c996671..0c1af5d 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -826,11 +826,11 @@ cache_poll(struct file *filp, poll_table *wait)
 	return mask;
 }
 
-static int
-cache_ioctl(struct inode *ino, struct file *filp,
-	    unsigned int cmd, unsigned long arg)
+static long
+cache_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	int len = 0;
+	struct inode *ino = filp->f_path.dentry->d_inode;
 	struct cache_reader *rp = filp->private_data;
 	struct cache_queue *cq;
 	struct cache_detail *cd = PDE(ino)->data;
@@ -918,7 +918,7 @@ static const struct file_operations cache_file_operations = {
 	.read		= cache_read,
 	.write		= cache_write,
 	.poll		= cache_poll,
-	.ioctl		= cache_ioctl, /* for FIONREAD */
+	.unlocked_ioctl	= cache_ioctl, /* for FIONREAD */
 	.open		= cache_open,
 	.release	= cache_release,
 };
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 5a9b0e7..80bca08 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -296,23 +296,26 @@ rpc_pipe_poll(struct file *filp, struct poll_table_struct *wait)
 	return mask;
 }
 
-static int
-rpc_pipe_ioctl(struct inode *ino, struct file *filp,
-		unsigned int cmd, unsigned long arg)
+static long
+rpc_pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct rpc_inode *rpci = RPC_I(filp->f_path.dentry->d_inode);
 	int len;
 
 	switch (cmd) {
 	case FIONREAD:
-		if (rpci->ops == NULL)
+		lock_kernel();
+		if (rpci->ops == NULL) {
+			unlock_kernel();
 			return -EPIPE;
+		}
 		len = rpci->pipelen;
 		if (filp->private_data) {
 			struct rpc_pipe_msg *msg;
 			msg = (struct rpc_pipe_msg *)filp->private_data;
 			len += msg->len - msg->copied;
 		}
+		unlock_kernel();
 		return put_user(len, (int __user *)arg);
 	default:
 		return -EINVAL;
@@ -325,7 +328,7 @@ static const struct file_operations rpc_pipe_fops = {
 	.read		= rpc_pipe_read,
 	.write		= rpc_pipe_write,
 	.poll		= rpc_pipe_poll,
-	.ioctl		= rpc_pipe_ioctl,
+	.unlocked_ioctl	= rpc_pipe_ioctl,
 	.open		= rpc_pipe_open,
 	.release	= rpc_pipe_release,
 };
