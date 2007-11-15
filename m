Return-Path: <linux-kernel-owner+w=401wt.eu-S1765434AbXKOSXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765434AbXKOSXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765383AbXKOSWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:22:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759867AbXKOSWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:22:50 -0500
Date: Thu, 15 Nov 2007 13:22:31 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711151822.lAFIMVnJ028596@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCHv2 4/4] first use of sys_indirect system call
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a first user of sys_indirect.  Several of the socket-related system
calls which produce a file handle now can be passed an additional parameter
to set the FD_CLOEXEC flag.

 socket.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -344,11 +344,11 @@ static struct dentry_operations sockfs_dentry_operations = {
  *	but we take care of internal coherence yet.
  */
 
-static int sock_alloc_fd(struct file **filep)
+static int sock_alloc_fd(struct file **filep, int flags)
 {
 	int fd;
 
-	fd = get_unused_fd();
+	fd = get_unused_fd_flags(flags);
 	if (likely(fd >= 0)) {
 		struct file *file = get_empty_filp();
 
@@ -391,10 +391,10 @@ static int sock_attach_fd(struct socket *sock, struct file *file)
 	return 0;
 }
 
-int sock_map_fd(struct socket *sock)
+static int sock_map_fd_flags(struct socket *sock, int flags)
 {
 	struct file *newfile;
-	int fd = sock_alloc_fd(&newfile);
+	int fd = sock_alloc_fd(&newfile, flags);
 
 	if (likely(fd >= 0)) {
 		int err = sock_attach_fd(sock, newfile);
@@ -409,6 +409,11 @@ int sock_map_fd(struct socket *sock)
 	return fd;
 }
 
+int sock_map_fd(struct socket *sock)
+{
+	return sock_map_fd_flags(sock, 0);
+}
+
 static struct socket *sock_from_file(struct file *file, int *err)
 {
 	if (file->f_op == &socket_file_ops)
@@ -1208,7 +1213,7 @@ asmlinkage long sys_socket(int family, int type, int protocol)
 	if (retval < 0)
 		goto out;
 
-	retval = sock_map_fd(sock);
+	retval = sock_map_fd_flags(sock, current->indirect_params.file_flags.flags);
 	if (retval < 0)
 		goto out_release;
 
@@ -1249,13 +1254,13 @@ asmlinkage long sys_socketpair(int family, int type, int protocol,
 	if (err < 0)
 		goto out_release_both;
 
-	fd1 = sock_alloc_fd(&newfile1);
+	fd1 = sock_alloc_fd(&newfile1, current->indirect_params.file_flags.flags);
 	if (unlikely(fd1 < 0)) {
 		err = fd1;
 		goto out_release_both;
 	}
 
-	fd2 = sock_alloc_fd(&newfile2);
+	fd2 = sock_alloc_fd(&newfile2, current->indirect_params.file_flags.flags);
 	if (unlikely(fd2 < 0)) {
 		err = fd2;
 		put_filp(newfile1);
@@ -1411,7 +1416,7 @@ asmlinkage long sys_accept(int fd, struct sockaddr __user *upeer_sockaddr,
 	 */
 	__module_get(newsock->ops->owner);
 
-	newfd = sock_alloc_fd(&newfile);
+	newfd = sock_alloc_fd(&newfile, current->indirect_params.file_flags.flags);
 	if (unlikely(newfd < 0)) {
 		err = newfd;
 		sock_release(newsock);
