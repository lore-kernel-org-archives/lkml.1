Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbYEMEcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbYEMEcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 00:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYEMEb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 00:31:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYEMEbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 00:31:55 -0400
Date: Tue, 13 May 2008 00:31:50 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805130431.m4D4Vo5e017311@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: [PATCH] flag parameters: arch-specific SOCK_NONBLOCK
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value of O_NONBLOCK clashes on Alpha dn PARISC with the bits used
for socket types.  Therefore we cannot define SOCK_NONBLOCK as
O_NONBLOCK on these platforms.  This patch adds support for an
arch-specific SOCK_NONBLOCK value which doesn't add costs for
other architectures.

 include/asm-alpha/socket.h  |    5 +++++
 include/asm-parisc/socket.h |    5 +++++
 include/linux/net.h         |    2 ++
 net/socket.c                |    9 +++++++++
 4 files changed, 21 insertions(+)


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/include/asm-alpha/socket.h b/include/asm-alpha/socket.h
index 08c9793..a1057c2 100644
--- a/include/asm-alpha/socket.h
+++ b/include/asm-alpha/socket.h
@@ -62,4 +62,9 @@
 
 #define SO_MARK			36
 
+/* O_NONBLOCK clashes with the bits used for socket types.  Therefore we
+ * have to define SOCK_NONBLOCK to a different value here.
+ */
+#define SOCK_NONBLOCK	0x40000000
+
 #endif /* _ASM_SOCKET_H */
diff --git a/include/asm-parisc/socket.h b/include/asm-parisc/socket.h
index 69a7a0d..fba402c 100644
--- a/include/asm-parisc/socket.h
+++ b/include/asm-parisc/socket.h
@@ -54,4 +54,9 @@
 
 #define SO_MARK			0x401f
 
+/* O_NONBLOCK clashes with the bits used for socket types.  Therefore we
+ * have to define SOCK_NONBLOCK to a different value here.
+ */
+#define SOCK_NONBLOCK   0x40000000
+
 #endif /* _ASM_SOCKET_H */
diff --git a/include/linux/net.h b/include/linux/net.h
index 1b35fd5..dd3b6cd 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -102,7 +102,9 @@ enum sock_type {
 
 /* Flags for socket, socketpair, paccept */
 #define SOCK_CLOEXEC	O_CLOEXEC
+#ifndef SOCK_NONBLOCK
 #define SOCK_NONBLOCK	O_NONBLOCK
+#endif
 
 #endif /* ARCH_HAS_SOCKET_TYPES */
 
diff --git a/net/socket.c b/net/socket.c
index 962bf07..5111af1 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1231,6 +1231,9 @@ asmlinkage long sys_socket(int family, int type, int protocol)
 		return -EINVAL;
 	type &= SOCK_TYPE_MASK;
 
+	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
+		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
+
 	retval = sock_create(family, type, protocol, &sock);
 	if (retval < 0)
 		goto out;
@@ -1265,6 +1268,9 @@ asmlinkage long sys_socketpair(int family, int type, int protocol,
 		return -EINVAL;
 	type &= SOCK_TYPE_MASK;
 
+	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
+		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
+
 	/*
 	 * Obtain the first socket and check if the underlying protocol
 	 * supports the socketpair call.
@@ -1430,6 +1436,9 @@ long do_accept(int fd, struct sockaddr __user *upeer_sockaddr,
 	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
 		return -EINVAL;
 
+	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
+		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
+
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
