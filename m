Return-Path: <linux-kernel-owner+w=401wt.eu-S933769AbXDASSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769AbXDASSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933795AbXDASSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:18:07 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:40217 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933794AbXDASRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:17:39 -0400
Date: Sun, 1 Apr 2007 20:17:24 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH 13/16] show-pipesize-in-stat.diff
In-Reply-To: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704012010040.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Show the fill status of a pipe (in bytes) when stat'ing one.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

 fs/stat.c             |   31 ++++++++++++++++++++++++++++++-
 include/linux/un.h    |    2 ++
 include/net/af_unix.h |    3 +++
 net/unix/af_unix.c    |   10 ++++++++++
 4 files changed, 45 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc5/fs/stat.c
===================================================================
--- linux-2.6.21-rc5.orig/fs/stat.c
+++ linux-2.6.21-rc5/fs/stat.c
@@ -14,6 +14,10 @@
 #include <linux/namei.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/blkdev.h>
+#include <linux/genhd.h>
+#include <linux/pipe_fs_i.h>
+#include <net/af_unix.h>
 #include <linux/pagemap.h>
 
 #include <asm/uaccess.h>
@@ -31,7 +35,32 @@ void generic_fillattr(struct inode *inod
 	stat->atime = inode->i_atime;
 	stat->mtime = inode->i_mtime;
 	stat->ctime = inode->i_ctime;
-	stat->size = i_size_read(inode);
+	stat->size = 0;
+	if (S_ISFIFO(inode->i_mode)) {
+		const struct pipe_inode_info *info = inode->i_pipe;
+		int i;
+		stat->size = 0;
+		if (info != NULL) {
+			for (i = 0; i < PIPE_BUFFERS; ++i) {
+				const struct pipe_buffer *buf = &info->bufs[i];
+				if (buf != NULL && buf->page != NULL)
+					stat->size += buf->len;
+			}
+		}
+	} else if (S_ISSOCK(inode->i_mode)) {
+#ifdef CONFIG_UNIX_MODULE
+		loff_t (*uxsize)(struct inode *) = __symbol_get("unixsock_size");
+		if (uxsize != NULL) {
+			stat->size = uxsize(inode);
+			symbol_put("unixsock_size");
+		}
+#endif
+#if defined(CONFIG_UNIX) && !defined(CONFIG_UNIX_MODULE)
+		stat->size = unixsock_size(inode);
+#endif
+	} else {
+		stat->size = i_size_read(inode);
+	}
 	stat->blocks = inode->i_blocks;
 	stat->blksize = (1 << inode->i_blkbits);
 }
Index: linux-2.6.21-rc5/include/linux/un.h
===================================================================
--- linux-2.6.21-rc5.orig/include/linux/un.h
+++ linux-2.6.21-rc5/include/linux/un.h
@@ -3,6 +3,8 @@
 
 #define UNIX_PATH_MAX	108
 
+#include <linux/socket.h>
+
 struct sockaddr_un {
 	sa_family_t sun_family;	/* AF_UNIX */
 	char sun_path[UNIX_PATH_MAX];	/* pathname */
Index: linux-2.6.21-rc5/include/net/af_unix.h
===================================================================
--- linux-2.6.21-rc5.orig/include/net/af_unix.h
+++ linux-2.6.21-rc5/include/net/af_unix.h
@@ -2,6 +2,7 @@
 #define __LINUX_NET_AFUNIX_H
 
 #include <linux/socket.h>
+#include <linux/types.h>
 #include <linux/un.h>
 #include <linux/mutex.h>
 #include <net/sock.h>
@@ -88,6 +89,8 @@ struct unix_sock {
 };
 #define unix_sk(__sk) ((struct unix_sock *)__sk)
 
+extern loff_t unixsock_size(struct inode *);
+
 #ifdef CONFIG_SYSCTL
 extern int sysctl_unix_max_dgram_qlen;
 extern void unix_sysctl_register(void);
Index: linux-2.6.21-rc5/net/unix/af_unix.c
===================================================================
--- linux-2.6.21-rc5.orig/net/unix/af_unix.c
+++ linux-2.6.21-rc5/net/unix/af_unix.c
@@ -744,6 +744,16 @@ fail:
 	return NULL;
 }
 
+loff_t unixsock_size(struct inode *inode) {
+    struct sock *sk = unix_find_socket_byinode(inode);
+    loff_t eax;
+
+    if(sk == NULL) { return 0; }
+    eax = sk->sk_rcvbuf;
+    sock_put(sk);
+    return eax;
+}
+EXPORT_SYMBOL(unixsock_size);
 
 static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
#<EOF>
