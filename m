Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab0BYNhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 08:37:37 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:42731 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab0BYNhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 08:37:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=I5B2+Vnh8aDFmxYmpU16uoxWFZStrswsWyM1NG+pjb3eInq5SdBSri3hdJPxU1UYSE
         VS3W+uZTHJaG9wygPAu+U3pe8/lMuYMkNSBy0LdohMIb79JODOPvRktsETkpdsyGYn5O
         8cZF8Bu7A/GUVPeYXM7XuC5NhEwA0VTfmdKy8=
Date: Thu, 25 Feb 2010 21:40:23 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       =?utf-8?B?QW5kcsOp?= Goddard Rosa <andre.goddard@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E . Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Xiaotian Feng <xtfeng@gmail.com>
Subject: [Patch] mqueue: fix the bad code in sys_mq_open()
Message-ID: <20100225134023.GB3842@hack>
References: <cover.1266907495.git.andre.goddard@gmail.com> <a3a62a6cd7cc0ba011949396a1f2c7f9c32aa4b9.1266907496.git.andre.goddard@gmail.com> <2375c9f91002241935k56dff805q57582d998b660889@mail.gmail.com> <7b6bb4a51002242000x49f0b3bdncb40912bf18f90bb@mail.gmail.com> <2375c9f91002242025n1ab73e18i5950aa4f14ea36db@mail.gmail.com> <2375c9f91002242259n2fabb190ic77d6ca603bd1df7@mail.gmail.com> <7b6bb4a51002250249t7e4f03c9r6b2b9a8f348a29aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b6bb4a51002250249t7e4f03c9r6b2b9a8f348a29aa@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix bad code in ipc/mqueue.c.

Inspired by André Goddard Rosa's  patch.

a) do_create() and do_open() should not release the resources which
   are not acquired within themselves, it's their caller's work;

b) Fix an fd leak;

c) The goto label 'out_upsem' doesn't make any sense, rename to
   'out_unlock';

d) mntget() should be called before looking up dentry within
   ->mnt->mnt_root;

e) When dealing with failure case, we should release the resources
   in a reversed order of acquiring, so reorder the goto labels;

f) Remove some unused labels due to reorder.

Also, this shrinks the binary by 60 bytes:

   text	      data     bss       dec	    hex	filename
   7674       1684        8      9366      2496	ipc/mqueue.o.BEFORE
   7614	      1684        8      9306      245a	ipc/mqueue.o.AFTER


Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: André Goddard Rosa <andre.goddard@gmail.com>

---
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index c79bd57..fdd09da 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -650,8 +650,6 @@ static struct file *do_create(struct ipc_namespace *ipc_ns, struct dentry *dir,
 out_drop_write:
 	mnt_drop_write(ipc_ns->mq_mnt);
 out:
-	dput(dentry);
-	mntput(ipc_ns->mq_mnt);
 	return ERR_PTR(ret);
 }
 
@@ -664,17 +662,11 @@ static struct file *do_open(struct ipc_namespace *ipc_ns,
 	static const int oflag2acc[O_ACCMODE] = { MAY_READ, MAY_WRITE,
 						  MAY_READ | MAY_WRITE };
 
-	if ((oflag & O_ACCMODE) == (O_RDWR | O_WRONLY)) {
-		dput(dentry);
-		mntput(ipc_ns->mq_mnt);
+	if ((oflag & O_ACCMODE) == (O_RDWR | O_WRONLY))
 		return ERR_PTR(-EINVAL);
-	}
 
-	if (inode_permission(dentry->d_inode, oflag2acc[oflag & O_ACCMODE])) {
-		dput(dentry);
-		mntput(ipc_ns->mq_mnt);
+	if (inode_permission(dentry->d_inode, oflag2acc[oflag & O_ACCMODE]))
 		return ERR_PTR(-EACCES);
-	}
 
 	return dentry_open(dentry, ipc_ns->mq_mnt, oflag, cred);
 }
@@ -686,7 +678,7 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, mode_t, mode,
 	struct file *filp;
 	char *name;
 	struct mq_attr attr;
-	int fd, error;
+	int fd, error = 0;
 	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
 
 	if (u_attr && copy_from_user(&attr, u_attr, sizeof(struct mq_attr)))
@@ -701,13 +693,13 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, mode_t, mode,
 	if (fd < 0)
 		goto out_putname;
 
+	mntget(ipc_ns->mq_mnt);
 	mutex_lock(&ipc_ns->mq_mnt->mnt_root->d_inode->i_mutex);
 	dentry = lookup_one_len(name, ipc_ns->mq_mnt->mnt_root, strlen(name));
 	if (IS_ERR(dentry)) {
 		error = PTR_ERR(dentry);
-		goto out_err;
+		goto out_unlock;
 	}
-	mntget(ipc_ns->mq_mnt);
 
 	if (oflag & O_CREAT) {
 		if (dentry->d_inode) {	/* entry already exists */
@@ -731,24 +723,23 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, mode_t, mode,
 
 	if (IS_ERR(filp)) {
 		error = PTR_ERR(filp);
-		goto out_putfd;
+		goto out;
 	}
 
 	fd_install(fd, filp);
-	goto out_upsem;
+	goto out_unlock;
 
 out:
 	dput(dentry);
-	mntput(ipc_ns->mq_mnt);
-out_putfd:
-	put_unused_fd(fd);
-out_err:
-	fd = error;
-out_upsem:
+out_unlock:
 	mutex_unlock(&ipc_ns->mq_mnt->mnt_root->d_inode->i_mutex);
+	if (error) {
+		mntput(ipc_ns->mq_mnt);
+		put_unused_fd(fd);
+	}
 out_putname:
 	putname(name);
-	return fd;
+	return error;
 }
 
 SYSCALL_DEFINE1(mq_unlink, const char __user *, u_name)
