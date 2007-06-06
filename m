Return-Path: <linux-kernel-owner+w=401wt.eu-S936665AbXFFWdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936665AbXFFWdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936426AbXFFWa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:30:57 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1353 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935843AbXFFWaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:30:55 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Date: Wed, 06 Jun 2007 15:30:31 -0700
Subject: [patch 7/8] fdmap v2 - implement sys_socket2
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement a new syscall sys_socket2(), that accepts an
extra "flags" parameter:

int socket2(int domain, int type, int protocol, int flags);

The flags parameter is used to pass extra flags to the kernel, and is
at the moment used to select the file descriptor allocations inside
the non-sequential area (O_NONSEQFD). The remaining parameters are
exactly the same as the ones of sys_socket().
The sys_accept() system call has been modified to return a file
descriptor inside the non-sequential area, if the listening fd is.
The sys_socketcall() system call has been also changed to support
a new SYS_SOCKET2 indentifier.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



Index: linux-2.6.mod/fs/9p/trans_fd.c
===================================================================
--- linux-2.6.mod.orig/fs/9p/trans_fd.c	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/fs/9p/trans_fd.c	2007-06-06 12:48:41.000000000 -0700
@@ -181,7 +181,7 @@
 	int fd, ret;
 
 	csocket->sk->sk_allocation = GFP_NOIO;
-	if ((fd = sock_map_fd(csocket)) < 0) {
+	if ((fd = sock_map_fd(csocket, 0)) < 0) {
 		eprintk(KERN_ERR, "v9fs_socket_open: failed to map fd\n");
 		ret = fd;
 	      release_csocket:
Index: linux-2.6.mod/include/linux/net.h
===================================================================
--- linux-2.6.mod.orig/include/linux/net.h	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/include/linux/net.h	2007-06-06 13:09:20.000000000 -0700
@@ -43,6 +43,7 @@
 #define SYS_GETSOCKOPT	15		/* sys_getsockopt(2)		*/
 #define SYS_SENDMSG	16		/* sys_sendmsg(2)		*/
 #define SYS_RECVMSG	17		/* sys_recvmsg(2)		*/
+#define SYS_SOCKET2	18		/* sys_socket2(2)		*/
 
 typedef enum {
 	SS_FREE = 0,			/* not allocated		*/
@@ -190,7 +191,7 @@
 				  size_t len);
 extern int	     sock_recvmsg(struct socket *sock, struct msghdr *msg,
 				  size_t size, int flags);
-extern int 	     sock_map_fd(struct socket *sock);
+extern int 	     sock_map_fd(struct socket *sock, int flags);
 extern struct socket *sockfd_lookup(int fd, int *err);
 #define		     sockfd_put(sock) fput(sock->file)
 extern int	     net_ratelimit(void);
Index: linux-2.6.mod/net/sctp/socket.c
===================================================================
--- linux-2.6.mod.orig/net/sctp/socket.c	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/net/sctp/socket.c	2007-06-06 12:48:41.000000000 -0700
@@ -3605,7 +3605,7 @@
 		goto out;
 
 	/* Map the socket to an unused fd that can be returned to the user.  */
-	retval = sock_map_fd(newsock);
+	retval = sock_map_fd(newsock, 0);
 	if (retval < 0) {
 		sock_release(newsock);
 		goto out;
Index: linux-2.6.mod/net/socket.c
===================================================================
--- linux-2.6.mod.orig/net/socket.c	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/net/socket.c	2007-06-06 13:14:08.000000000 -0700
@@ -344,11 +344,11 @@
  *	but we take care of internal coherence yet.
  */
 
-static int sock_alloc_fd(struct file **filep)
+static int sock_alloc_fd(struct file **filep, int flags)
 {
 	int fd;
 
-	fd = get_unused_fd();
+	fd = allocate_fd(flags);
 	if (likely(fd >= 0)) {
 		struct file *file = get_empty_filp();
 
@@ -391,10 +391,10 @@
 	return 0;
 }
 
-int sock_map_fd(struct socket *sock)
+int sock_map_fd(struct socket *sock, int flags)
 {
 	struct file *newfile;
-	int fd = sock_alloc_fd(&newfile);
+	int fd = sock_alloc_fd(&newfile, flags);
 
 	if (likely(fd >= 0)) {
 		int err = sock_attach_fd(sock, newfile);
@@ -1198,7 +1198,7 @@
 	return __sock_create(family, type, protocol, res, 1);
 }
 
-asmlinkage long sys_socket(int family, int type, int protocol)
+asmlinkage long sys_socket2(int family, int type, int protocol, int flags)
 {
 	int retval;
 	struct socket *sock;
@@ -1207,7 +1207,7 @@
 	if (retval < 0)
 		goto out;
 
-	retval = sock_map_fd(sock);
+	retval = sock_map_fd(sock, flags);
 	if (retval < 0)
 		goto out_release;
 
@@ -1220,6 +1220,11 @@
 	return retval;
 }
 
+asmlinkage long sys_socket(int family, int type, int protocol)
+{
+	return sys_socket2(family, type, protocol, 0);
+}
+
 /*
  *	Create a pair of connected sockets.
  */
@@ -1248,11 +1253,11 @@
 	if (err < 0)
 		goto out_release_both;
 
-	fd1 = sock_alloc_fd(&newfile1);
+	fd1 = sock_alloc_fd(&newfile1, 0);
 	if (unlikely(fd1 < 0))
 		goto out_release_both;
 
-	fd2 = sock_alloc_fd(&newfile2);
+	fd2 = sock_alloc_fd(&newfile2, 0);
 	if (unlikely(fd2 < 0)) {
 		put_filp(newfile1);
 		put_unused_fd(fd1);
@@ -1407,7 +1412,8 @@
 	 */
 	__module_get(newsock->ops->owner);
 
-	newfd = sock_alloc_fd(&newfile);
+	newfd = sock_alloc_fd(&newfile,
+	      fd > current->signal->rlim[RLIMIT_NOFILE].rlim_cur ? O_NONSEQFD: 0);
 	if (unlikely(newfd < 0)) {
 		err = newfd;
 		sock_release(newsock);
@@ -1983,10 +1989,11 @@
 
 /* Argument list sizes for sys_socketcall */
 #define AL(x) ((x) * sizeof(unsigned long))
-static const unsigned char nargs[18]={
+static const unsigned char nargs[]={
 	AL(0),AL(3),AL(3),AL(3),AL(2),AL(3),
 	AL(3),AL(3),AL(4),AL(4),AL(4),AL(6),
-	AL(6),AL(2),AL(5),AL(5),AL(3),AL(3)
+	AL(6),AL(2),AL(5),AL(5),AL(3),AL(3),
+	AL(4)
 };
 
 #undef AL
@@ -2005,7 +2012,7 @@
 	unsigned long a0, a1;
 	int err;
 
-	if (call < 1 || call > SYS_RECVMSG)
+	if (call < 1 || call >= ARRAY_SIZE(nargs))
 		return -EINVAL;
 
 	/* copy_from_user should be SMP safe. */
@@ -2082,6 +2089,9 @@
 	case SYS_RECVMSG:
 		err = sys_recvmsg(a0, (struct msghdr __user *)a1, a[2]);
 		break;
+	case SYS_SOCKET2:
+		err = sys_socket2(a0, a1, a[2], a[3]);
+		break;
 	default:
 		err = -EINVAL;
 		break;

