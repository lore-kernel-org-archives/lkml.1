Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZIXA3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZIXA3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZIXA30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:29:26 -0400
Received: from smtp231.iad.emailsrvr.com ([207.97.245.231]:39153 "EHLO
	smtp231.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZIXA3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:29:18 -0400
From: Oren Laadan <orenl@librato.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Dan Smith <danms@us.ibm.com>, netdev@vger.kernel.org
Subject: [PATCH v18 68/80] Add common socket helpers to unify the security hooks
Date: Wed, 23 Sep 2009 19:51:48 -0400
Message-Id: <1253749920-18673-69-git-send-email-orenl@librato.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253749920-18673-1-git-send-email-orenl@librato.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Smith <danms@us.ibm.com>

This moves the meat out of the bind(), getsockname(), and getpeername() syscalls
into helper functions that performs security_socket_bind() and then the
sock->ops->call().  This allows a unification of this behavior between the
syscalls and the pending socket restart logic.

Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Dan Smith <danms@us.ibm.com>
Cc: netdev@vger.kernel.org
---
 include/net/sock.h |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/socket.c       |   29 ++++++-----------------------
 2 files changed, 54 insertions(+), 23 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 950409d..12530bf 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1578,6 +1578,54 @@ extern void sock_enable_timestamp(struct sock *sk, int flag);
 extern int sock_get_timestamp(struct sock *, struct timeval __user *);
 extern int sock_get_timestampns(struct sock *, struct timespec __user *);
 
+/* bind() helper shared between any callers needing to perform a bind on
+ * behalf of userspace (syscall and restart) with the security hooks.
+ */
+static inline int sock_bind(struct socket *sock,
+			    struct sockaddr *addr,
+			    int addr_len)
+{
+	int err;
+
+	err = security_socket_bind(sock, addr, addr_len);
+	if (err)
+		return err;
+	else
+		return sock->ops->bind(sock, addr, addr_len);
+}
+
+/* getname() helper shared between any callers needing to perform a getname on
+ * behalf of userspace (syscall and restart) with the security hooks.
+ */
+static inline int sock_getname(struct socket *sock,
+			       struct sockaddr *addr,
+			       int *addr_len)
+{
+	int err;
+
+	err = security_socket_getsockname(sock);
+	if (err)
+		return err;
+	else
+		return sock->ops->getname(sock, addr, addr_len, 0);
+}
+
+/* getpeer() helper shared between any callers needing to perform a getpeer on
+ * behalf of userspace (syscall and restart) with the security hooks.
+ */
+static inline int sock_getpeer(struct socket *sock,
+			       struct sockaddr *addr,
+			       int *addr_len)
+{
+	int err;
+
+	err = security_socket_getpeername(sock);
+	if (err)
+		return err;
+	else
+		return sock->ops->getname(sock, addr, addr_len, 1);
+}
+
 /* 
  *	Enable debug/info messages 
  */
diff --git a/net/socket.c b/net/socket.c
index 6d47165..63c4498 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1414,15 +1414,10 @@ SYSCALL_DEFINE3(bind, int, fd, struct sockaddr __user *, umyaddr, int, addrlen)
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock) {
 		err = move_addr_to_kernel(umyaddr, addrlen, (struct sockaddr *)&address);
-		if (err >= 0) {
-			err = security_socket_bind(sock,
-						   (struct sockaddr *)&address,
-						   addrlen);
-			if (!err)
-				err = sock->ops->bind(sock,
-						      (struct sockaddr *)
-						      &address, addrlen);
-		}
+		if (err >= 0)
+			err = sock_bind(sock,
+					(struct sockaddr *)&address,
+					addrlen);
 		fput_light(sock->file, fput_needed);
 	}
 	return err;
@@ -1610,11 +1605,7 @@ SYSCALL_DEFINE3(getsockname, int, fd, struct sockaddr __user *, usockaddr,
 	if (!sock)
 		goto out;
 
-	err = security_socket_getsockname(sock);
-	if (err)
-		goto out_put;
-
-	err = sock->ops->getname(sock, (struct sockaddr *)&address, &len, 0);
+	err = sock_getname(sock, (struct sockaddr *)&address, &len);
 	if (err)
 		goto out_put;
 	err = move_addr_to_user((struct sockaddr *)&address, len, usockaddr, usockaddr_len);
@@ -1639,15 +1630,7 @@ SYSCALL_DEFINE3(getpeername, int, fd, struct sockaddr __user *, usockaddr,
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock != NULL) {
-		err = security_socket_getpeername(sock);
-		if (err) {
-			fput_light(sock->file, fput_needed);
-			return err;
-		}
-
-		err =
-		    sock->ops->getname(sock, (struct sockaddr *)&address, &len,
-				       1);
+		err = sock_getpeer(sock, (struct sockaddr *)&address, &len);
 		if (!err)
 			err = move_addr_to_user((struct sockaddr *)&address, len, usockaddr,
 						usockaddr_len);
-- 
1.6.0.4

