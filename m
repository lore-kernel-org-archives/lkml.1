Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYKZEhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYKZEhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 23:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYKZEhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 23:37:09 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:35240 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751832AbYKZEhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 23:37:08 -0500
X-YMail-OSG: GjCvB3EVM1kKZL7nOYUCQrHRy4CgWPK8_642mhi4oORUyIRnYQulNZ7J06zeHFpj6UniVhNAjaeQllYg24se_.9bxMz5EBOsqpKn2RS37ucnXB_3QAPAKfOkXnuKxPgQJdW8Gn1R78DZ73orDUuC8PirR9.YXHn3T1mTlM3XIUb8V5xS9FSIRUm6tqI-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH] [LIO-Target]: Use modern kernel socket wrappers from
	linux/net/socket.c:kernel_*()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux Net <linux-net@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 20:37:04 -0800
Message-Id: <1227674224.5023.59.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 09898c433f71d32b3072ef14ff3d71ad1700d639 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 25 Nov 2008 19:50:16 -0800
Subject: [PATCH] [LIO-Target]: Use modern kernel socket wrappers from linux/net/socket.c:kernel_*()

Removed legacy drivers/lio-core/iscsi_linux_def.h:iscsi_sock_*() macros,
and converted v3.0 server side kernel socket code to use kernel sockets API
in linux/net/socket.c:kernel_*().  These functions first appeared in
kernel.org in v2.6.19.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_auth_kernel.h  |    5 +--
 drivers/lio-core/iscsi_linux_defs.h   |   23 ---------------
 drivers/lio-core/iscsi_target_login.c |   51 ++++++++++++++++++++-------------
 3 files changed, 33 insertions(+), 46 deletions(-)

diff --git a/drivers/lio-core/iscsi_auth_kernel.h b/drivers/lio-core/iscsi_auth_kernel.h
index 96dc7ae..cf789dd 100644
--- a/drivers/lio-core/iscsi_auth_kernel.h
+++ b/drivers/lio-core/iscsi_auth_kernel.h
@@ -101,9 +101,8 @@ extern u32 iscsi_handle_authentication (
 	s_addr.sin_addr.s_addr	= htonl(INADDR_LOOPBACK);
 	s_addr.sin_port		= htons(AUTH_PORT);
 
-	if (iscsi_sock_create(&authsock, AF_INET, SOCK_DGRAM, IPPROTO_UDP,
-			NULL, NULL) < 0) {
-		TRACE_ERROR("iscsi_sock_create() failed!\n");
+	if (sock_create(AF_INET, SOCK_DGRAM, IPPROTO_UDP, &authsock) < 0) {
+		TRACE_ERROR("sock_create() failed!\n");
 		ret = -1;
 		goto out;
 	}
diff --git a/drivers/lio-core/iscsi_linux_defs.h b/drivers/lio-core/iscsi_linux_defs.h
index f609c9d..52b55de 100644
--- a/drivers/lio-core/iscsi_linux_defs.h
+++ b/drivers/lio-core/iscsi_linux_defs.h
@@ -48,29 +48,6 @@
 	copy_to_user((void *)(dest), (void *)(src), (len))
 
 /*
- * Sockets.
- */
-#define iscsi_sock_create(sock, f, t, p, uc, td) sock_create(f, t, p, sock)
-#define iscsi_sock_connect(sock, s_in, size, td) sock->ops->connect(sock, s_in, size, 0)
-#define iscsi_sock_bind(sock, s_in, size, td) sock->ops->bind(sock, s_in, size)
-#define iscsi_sock_listen(sock, backlog, td) sock->ops->listen(sock, backlog)
-#define iscsi_sock_accept(sock, newsock, td) sock->ops->accept(sock, newsock, 0)
-#define iscsi_sock_sockopt_off(sock, p, o) \
-	{ \
-	int value = 0; \
-	sock->ops->setsockopt(sock, p, o, (char *)&value, sizeof(value)); \
-	}
-#define iscsi_sock_sockopt_on(sock, p, o) \
-	{ \
-	int value = 1; \
-	sock->ops->setsockopt(sock, p, o, (char *)&value, sizeof(value)); \
-	}
-#define iscsi_sock_sockopt_bindtodev(sock, dev) \
-	{ \
-	sock->ops->setsockopt(sock, SOL_SOCKET, SO_BINDTODEVICE, dev, strlen(dev)); \
-	}
-
-/*
  * Threads.
  */
 #define iscsi_daemon(thread, name, sigs) \
diff --git a/drivers/lio-core/iscsi_target_login.c b/drivers/lio-core/iscsi_target_login.c
index 6c49e77..0b0a54a 100644
--- a/drivers/lio-core/iscsi_target_login.c
+++ b/drivers/lio-core/iscsi_target_login.c
@@ -737,7 +737,7 @@ static struct socket *iscsi_target_setup_login_socket (iscsi_np_t *np)
 {
 	const char *end;
 	struct socket *sock;
-	int backlog = 5, ip_proto, sock_type, ret;
+	int backlog = 5, ip_proto, sock_type, ret, opt = 0;
 	struct sockaddr_in sock_in;
 	struct sockaddr_in6 sock_in6;
 	
@@ -763,9 +763,9 @@ static struct socket *iscsi_target_setup_login_socket (iscsi_np_t *np)
 		goto fail;
 	}
 	
-	if (iscsi_sock_create(&sock, (np->np_flags & NPF_NET_IPV6) ? AF_INET6 :
-			AF_INET, sock_type, ip_proto, NULL, NULL) < 0) {
-		TRACE_ERROR("iscsi_sock_create() failed.\n");
+	if (sock_create((np->np_flags & NPF_NET_IPV6) ? AF_INET6 : AF_INET,
+			sock_type, ip_proto, &sock) < 0) {
+		TRACE_ERROR("sock_create() failed.\n");
 		goto fail;
 	}
 	np->np_socket = sock;
@@ -814,28 +814,39 @@ static struct socket *iscsi_target_setup_login_socket (iscsi_np_t *np)
 
 	/*
 	 * Set SO_REUSEADDR, and disable Nagel Algorithm with TCP_NODELAY.
-	 * NOTE: setsockopt() w/ SO_REUSEADDR on LINUX 2.4 is broken,  force it.
 	 */
-	iscsi_sock_sockopt_on(sock, IPPROTO_TCP, TCP_NODELAY);
-	iscsi_sock_sockopt_on(sock, SOL_SOCKET, SO_REUSEADDR);
-	sock->sk->sk_reuse = 1;
+	opt = 1;
+	if (np->np_network_transport == ISCSI_TCP) {
+		if ((ret = kernel_setsockopt(sock, IPPROTO_TCP, TCP_NODELAY,
+				(char *)&opt, sizeof(opt))) < 0) {
+			printk(KERN_ERR "kernel_setsockopt() for TCP_NODELAY"
+				" failed: %d\n", ret);
+			goto fail;
+		}
+	}
+	if ((ret = kernel_setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, 
+			(char *)&opt, sizeof(opt))) < 0) {
+		printk(KERN_ERR "kernel_setsockopt() for SO_REUSEADDR"
+			" failed\n");
+		goto fail;
+	}
 	
 	if (np->np_flags & NPF_NET_IPV6) {
-		if ((ret = iscsi_sock_bind(sock, (struct sockaddr *)&sock_in6,
-				sizeof(struct sockaddr_in6), NULL)) < 0) {
-			TRACE_ERROR("iscsi_sock_bind() failed: %d\n", ret);
+		if ((ret = kernel_bind(sock, (struct sockaddr *)&sock_in6,
+				sizeof(struct sockaddr_in6))) < 0) {
+			TRACE_ERROR("kernel_bind() failed: %d\n", ret);
 			goto fail;
 		}
 	} else {
-		if ((ret = iscsi_sock_bind(sock, (struct sockaddr *)&sock_in,
-				sizeof(struct sockaddr), NULL)) < 0) {
-			TRACE_ERROR("iscsi_sock_bind() failed: %d\n", ret);
+		if ((ret = kernel_bind(sock, (struct sockaddr *)&sock_in,
+				sizeof(struct sockaddr))) < 0) {
+			TRACE_ERROR("kernel_bind() failed: %d\n", ret);
 			goto fail;
 		}
 	}
 
-	if (iscsi_sock_listen(sock, backlog, NULL)) {
-		TRACE_ERROR("iscsi_sock_listen() failed.\n");
+	if (kernel_listen(sock, backlog)) {
+		TRACE_ERROR("kernel_listen() failed.\n");
 		goto fail;
 	}
 	
@@ -914,9 +925,9 @@ get_new_sock:
 		return(-1);
 	}
 	
-	if (iscsi_sock_create(&new_sock, (np->np_flags & NPF_NET_IPV6) ? AF_INET6 :
-			AF_INET, sock_type, ip_proto, NULL, NULL) < 0) {
-		TRACE_ERROR("iscsi_sock_create() failed for new_sock\n");
+	if (sock_create((np->np_flags & NPF_NET_IPV6) ? AF_INET6 : AF_INET,
+			sock_type, ip_proto, &new_sock) < 0) {
+		TRACE_ERROR("sock_create() failed for new_sock\n");
 		if (start) {
 			up(&np->np_start_sem);
 			return(0);
@@ -968,7 +979,7 @@ get_new_sock:
 	}
 	spin_unlock_bh(&np->np_thread_lock);
 	
-	if (iscsi_sock_accept(sock, new_sock, NULL) < 0) {
+	if (kernel_accept(sock, &new_sock, 0) < 0) {
 		if (new_sock) {
 			if (set_sctp_conn_flag) {
 				kfree(new_sock->file);
-- 
1.5.4.1



