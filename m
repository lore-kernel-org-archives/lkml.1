Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab0BXHIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:08:15 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45403 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab0BXHIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:08:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=aIB8vQGX2dMR+KQNo9+x6a5JcnqFrCyBWr3istHyXI9LFSv8gFvGZyLGopaiNDx2uy
         C0pLVHcED3aSetAvTHDwPW0IfDZzIEQQhXeS/0KfIqf+SC1XGIbDuZOHUSs+6ddB52zK
         jnGto8b46jbYElZqJcP4/Sx36hYLPeTMTRlOI=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E . Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH 4/6] mqueue: only set error codes if they are really necessary
Date: Tue, 23 Feb 2010 04:04:26 -0300
Message-Id: <5adcc4fa899a19778bb78cd99950772fdf954fb0.1266907496.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <cover.1266907495.git.andre.goddard@gmail.com>
References: <cover.1266907495.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... postponing assignments until they're needed. Doesn't change code size.

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 ipc/mqueue.c |   77 +++++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 50 insertions(+), 27 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 2cddf93..906e873 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -184,7 +184,7 @@ static int mqueue_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *inode;
 	struct ipc_namespace *ns = data;
-	int error = 0;
+	int error;
 
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
@@ -202,7 +202,9 @@ static int mqueue_fill_super(struct super_block *sb, void *data, int silent)
 	if (!sb->s_root) {
 		iput(inode);
 		error = -ENOMEM;
+		goto out;
 	}
+	error = 0;
 
 out:
 	return error;
@@ -621,9 +623,10 @@ static struct file *do_create(struct ipc_namespace *ipc_ns, struct dentry *dir,
 	int ret;
 
 	if (attr) {
-		ret = -EINVAL;
-		if (!mq_attr_ok(ipc_ns, attr))
+		if (!mq_attr_ok(ipc_ns, attr)) {
+			ret = -EINVAL;
 			goto out;
+		}
 		/* store for use during create */
 		dentry->d_fsdata = attr;
 	}
@@ -714,9 +717,10 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, mode_t, mode,
 	if (oflag & O_CREAT) {
 		if (dentry->d_inode) {	/* entry already exists */
 			audit_inode(name, dentry);
-			error = -EEXIST;
-			if (oflag & O_EXCL)
+			if (oflag & O_EXCL) {
+				error = -EEXIST;
 				goto out;
+			}
 			filp = do_open(ipc_ns, dentry, oflag);
 		} else {
 			filp = do_create(ipc_ns, ipc_ns->mq_mnt->mnt_root,
@@ -724,9 +728,10 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, mode_t, mode,
 						u_attr ? &attr : NULL);
 		}
 	} else {
-		error = -ENOENT;
-		if (!dentry->d_inode)
+		if (!dentry->d_inode) {
+			error = -ENOENT;
 			goto out;
+		}
 		audit_inode(name, dentry);
 		filp = do_open(ipc_ns, dentry, oflag);
 	}
@@ -874,19 +879,24 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 	audit_mq_sendrecv(mqdes, msg_len, msg_prio, p);
 	timeout = prepare_timeout(p);
 
-	ret = -EBADF;
 	filp = fget(mqdes);
-	if (unlikely(!filp))
+	if (unlikely(!filp)) {
+		ret = -EBADF;
 		goto out;
+	}
 
 	inode = filp->f_path.dentry->d_inode;
-	if (unlikely(filp->f_op != &mqueue_file_operations))
+	if (unlikely(filp->f_op != &mqueue_file_operations)) {
+		ret = -EBADF;
 		goto out_fput;
+	}
 	info = MQUEUE_I(inode);
 	audit_inode(NULL, filp->f_path.dentry);
 
-	if (unlikely(!(filp->f_mode & FMODE_WRITE)))
+	if (unlikely(!(filp->f_mode & FMODE_WRITE))) {
+		ret = -EBADF;
 		goto out_fput;
+	}
 
 	if (unlikely(msg_len > info->attr.mq_msgsize)) {
 		ret = -EMSGSIZE;
@@ -963,19 +973,24 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 	audit_mq_sendrecv(mqdes, msg_len, 0, p);
 	timeout = prepare_timeout(p);
 
-	ret = -EBADF;
 	filp = fget(mqdes);
-	if (unlikely(!filp))
+	if (unlikely(!filp)) {
+		ret = -EBADF;
 		goto out;
+	}
 
 	inode = filp->f_path.dentry->d_inode;
-	if (unlikely(filp->f_op != &mqueue_file_operations))
+	if (unlikely(filp->f_op != &mqueue_file_operations)) {
+		ret = -EBADF;
 		goto out_fput;
+	}
 	info = MQUEUE_I(inode);
 	audit_inode(NULL, filp->f_path.dentry);
 
-	if (unlikely(!(filp->f_mode & FMODE_READ)))
+	if (unlikely(!(filp->f_mode & FMODE_READ))) {
+		ret = -EBADF;
 		goto out_fput;
+	}
 
 	/* checks if buffer is big enough */
 	if (unlikely(msg_len < info->attr.mq_msgsize)) {
@@ -1065,13 +1080,14 @@ SYSCALL_DEFINE2(mq_notify, mqd_t, mqdes,
 
 			/* create the notify skb */
 			nc = alloc_skb(NOTIFY_COOKIE_LEN, GFP_KERNEL);
-			ret = -ENOMEM;
-			if (!nc)
+			if (!nc) {
+				ret = -ENOMEM;
 				goto out;
-			ret = -EFAULT;
+			}
 			if (copy_from_user(nc->data,
 					notification.sigev_value.sival_ptr,
 					NOTIFY_COOKIE_LEN)) {
+				ret = -EFAULT;
 				goto out;
 			}
 
@@ -1080,9 +1096,10 @@ SYSCALL_DEFINE2(mq_notify, mqd_t, mqdes,
 			/* and attach it to the socket */
 retry:
 			filp = fget(notification.sigev_signo);
-			ret = -EBADF;
-			if (!filp)
+			if (!filp) {
+				ret = -EBADF;
 				goto out;
+			}
 			sock = netlink_getsockbyfilp(filp);
 			fput(filp);
 			if (IS_ERR(sock)) {
@@ -1094,7 +1111,7 @@ retry:
 			timeo = MAX_SCHEDULE_TIMEOUT;
 			ret = netlink_attachskb(sock, nc, &timeo, NULL);
 			if (ret == 1)
-		       		goto retry;
+				goto retry;
 			if (ret) {
 				sock = NULL;
 				nc = NULL;
@@ -1103,14 +1120,17 @@ retry:
 		}
 	}
 
-	ret = -EBADF;
 	filp = fget(mqdes);
-	if (!filp)
+	if (!filp) {
+		ret = -EBADF;
 		goto out;
+	}
 
 	inode = filp->f_path.dentry->d_inode;
-	if (unlikely(filp->f_op != &mqueue_file_operations))
+	if (unlikely(filp->f_op != &mqueue_file_operations)) {
+		ret = -EBADF;
 		goto out_fput;
+	}
 	info = MQUEUE_I(inode);
 
 	ret = 0;
@@ -1173,14 +1193,17 @@ SYSCALL_DEFINE3(mq_getsetattr, mqd_t, mqdes,
 			return -EINVAL;
 	}
 
-	ret = -EBADF;
 	filp = fget(mqdes);
-	if (!filp)
+	if (!filp) {
+		ret = -EBADF;
 		goto out;
+	}
 
 	inode = filp->f_path.dentry->d_inode;
-	if (unlikely(filp->f_op != &mqueue_file_operations))
+	if (unlikely(filp->f_op != &mqueue_file_operations)) {
+		ret = -EBADF;
 		goto out_fput;
+	}
 	info = MQUEUE_I(inode);
 
 	spin_lock(&info->lock);
-- 
1.7.0.87.g0901d

