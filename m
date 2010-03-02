Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab0CBUcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 15:32:24 -0500
Received: from bob75-7-88-160-5-175.fbx.proxad.net ([88.160.5.175]:47388 "EHLO
	cerbere.dyndns.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab0CBUa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 15:30:27 -0500
From: Samir Bellabes <sam@synack.fr>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, jamal <hadi@cyberus.ca>,
       Patrick McHardy <kaber@trash.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Neil Horman <nhorman@tuxdriver.com>,
       Grzegorz Nosek <root@localdomain.pl>, Samir Bellabes <sam@synack.fr>
Subject: [RFC v2 02/10] Revert "lsm: Remove the socket_post_accept() hook"
Date: Tue,  2 Mar 2010 21:23:06 +0100
Message-Id: <1267561394-13626-3-git-send-email-sam@synack.fr>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267561394-13626-1-git-send-email-sam@synack.fr>
References: <1267561394-13626-1-git-send-email-sam@synack.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 8651d5c0b1f874c5b8307ae2b858bc40f9f02482.

snet needs to reintroduce this hook, as it was designed to be: a hook for
updating security informations on objects.

Signed-off-by: Samir Bellabes <sam@synack.fr>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 include/linux/security.h |   13 +++++++++++++
 net/socket.c             |    2 ++
 security/capability.c    |    5 +++++
 security/security.c      |    5 +++++
 4 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 74e564b..d8ad624 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -938,6 +938,11 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@sock contains the listening socket structure.
  *	@newsock contains the newly created server socket for connection.
  *	Return 0 if permission is granted.
+ * @socket_post_accept:
+ *	This hook allows a security module to copy security
+ *	information into the newly created socket's inode.
+ *	@sock contains the listening socket structure.
+ *	@newsock contains the newly created server socket for connection.
  * @socket_sendmsg:
  *	Check permission before transmitting a message to another socket.
  *	@sock contains the socket structure.
@@ -1674,6 +1679,8 @@ struct security_operations {
 			       struct sockaddr *address, int addrlen);
 	int (*socket_listen) (struct socket *sock, int backlog);
 	int (*socket_accept) (struct socket *sock, struct socket *newsock);
+	void (*socket_post_accept) (struct socket *sock,
+				    struct socket *newsock);
 	int (*socket_sendmsg) (struct socket *sock,
 			       struct msghdr *msg, int size);
 	int (*socket_recvmsg) (struct socket *sock,
@@ -2696,6 +2703,7 @@ int security_socket_bind(struct socket *sock, struct sockaddr *address, int addr
 int security_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen);
 int security_socket_listen(struct socket *sock, int backlog);
 int security_socket_accept(struct socket *sock, struct socket *newsock);
+void security_socket_post_accept(struct socket *sock, struct socket *newsock);
 int security_socket_sendmsg(struct socket *sock, struct msghdr *msg, int size);
 int security_socket_recvmsg(struct socket *sock, struct msghdr *msg,
 			    int size, int flags);
@@ -2778,6 +2786,11 @@ static inline int security_socket_accept(struct socket *sock,
 	return 0;
 }
 
+static inline void security_socket_post_accept(struct socket *sock,
+					       struct socket *newsock)
+{
+}
+
 static inline int security_socket_sendmsg(struct socket *sock,
 					  struct msghdr *msg, int size)
 {
diff --git a/net/socket.c b/net/socket.c
index b4eb361..2e66a5a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1538,6 +1538,8 @@ SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
 	fd_install(newfd, newfile);
 	err = newfd;
 
+	security_socket_post_accept(sock, newsock);
+
 out_put:
 	fput_light(sock->file, fput_needed);
 out:
diff --git a/security/capability.c b/security/capability.c
index a9810dc..61eae40 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -641,6 +641,10 @@ static int cap_socket_accept(struct socket *sock, struct socket *newsock)
 	return 0;
 }
 
+static void cap_socket_post_accept(struct socket *sock, struct socket *newsock)
+{
+}
+
 static int cap_socket_sendmsg(struct socket *sock, struct msghdr *msg, int size)
 {
 	return 0;
@@ -1081,6 +1085,7 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, socket_connect);
 	set_to_cap_if_null(ops, socket_listen);
 	set_to_cap_if_null(ops, socket_accept);
+	set_to_cap_if_null(ops, socket_post_accept);
 	set_to_cap_if_null(ops, socket_sendmsg);
 	set_to_cap_if_null(ops, socket_recvmsg);
 	set_to_cap_if_null(ops, socket_getsockname);
diff --git a/security/security.c b/security/security.c
index 288c3a8..673979f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1082,6 +1082,11 @@ int security_socket_accept(struct socket *sock, struct socket *newsock)
 	return security_ops->socket_accept(sock, newsock);
 }
 
+void security_socket_post_accept(struct socket *sock, struct socket *newsock)
+{
+	security_ops->socket_post_accept(sock, newsock);
+}
+
 int security_socket_sendmsg(struct socket *sock, struct msghdr *msg, int size)
 {
 	return security_ops->socket_sendmsg(sock, msg, size);
-- 
1.6.3.3

