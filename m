Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbXKTGy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbXKTGy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759268AbXKTGxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:53:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759251AbXKTGxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:53:44 -0500
Date: Tue, 20 Nov 2007 01:53:14 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for setting the O_NONBLOCK flag of the file
descriptors returned by socket, socketpair, and accept.

 socket.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- net/socket.c
+++ net/socket.c
@@ -362,7 +362,7 @@ static int sock_alloc_fd(struct file **filep, int flags)
 	return fd;
 }
 
-static int sock_attach_fd(struct socket *sock, struct file *file)
+static int sock_attach_fd(struct socket *sock, struct file *file, int flags)
 {
 	struct dentry *dentry;
 	struct qstr name = { .name = "" };
@@ -384,7 +384,7 @@ static int sock_attach_fd(struct socket *sock, struct file *file)
 	init_file(file, sock_mnt, dentry, FMODE_READ | FMODE_WRITE,
 		  &socket_file_ops);
 	SOCK_INODE(sock)->i_fop = &socket_file_ops;
-	file->f_flags = O_RDWR;
+	file->f_flags = O_RDWR | (flags & O_NONBLOCK);
 	file->f_pos = 0;
 	file->private_data = sock;
 
@@ -397,7 +397,7 @@ static int sock_map_fd_flags(struct socket *sock, int flags)
 	int fd = sock_alloc_fd(&newfile, flags);
 
 	if (likely(fd >= 0)) {
-		int err = sock_attach_fd(sock, newfile);
+		int err = sock_attach_fd(sock, newfile, flags);
 
 		if (unlikely(err < 0)) {
 			put_filp(newfile);
@@ -1268,12 +1268,14 @@ asmlinkage long sys_socketpair(int family, int type, int protocol,
 		goto out_release_both;
 	}
 
-	err = sock_attach_fd(sock1, newfile1);
+	err = sock_attach_fd(sock1, newfile1,
+			     INDIRECT_PARAM(file_flags, flags));
 	if (unlikely(err < 0)) {
 		goto out_fd2;
 	}
 
-	err = sock_attach_fd(sock2, newfile2);
+	err = sock_attach_fd(sock2, newfile2,
+			     INDIRECT_PARAM(file_flags, flags));
 	if (unlikely(err < 0)) {
 		fput(newfile1);
 		goto out_fd1;
@@ -1423,7 +1425,8 @@ asmlinkage long sys_accept(int fd, struct sockaddr __user *upeer_sockaddr,
 		goto out_put;
 	}
 
-	err = sock_attach_fd(newsock, newfile);
+	err = sock_attach_fd(newsock, newfile,
+			     INDIRECT_PARAM(file_flags, flags));
 	if (err < 0)
 		goto out_fd_simple;
 
