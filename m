Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbZBXV2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbZBXV2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZBXV23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:28:29 -0500
Received: from smtp6.tech.numericable.fr ([82.216.111.42]:49097 "EHLO
	smtp6.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZBXV22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:28:28 -0500
Message-ID: <49A46678.1030803@numericable.fr>
Date: Tue, 24 Feb 2009 22:28:24 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul.moore@hp.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM <linux-security-module@vger.kernel.org>
Subject: [PATCH][SMACK] add a socket_post_accept hook to fix netlabel issues
 with labeled TCP servers V1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

Today, if  a  TCP server run with a SMACK non-ambient label, it will send labeled packets back to the client,
_even_ if the clients IP are in the /smack/netlabel "whitelist"
that's because "smack_socket_post_create" hook set labeled CIPSO packets unconditionnally
On connect, they are removed if the dest matches the /smack/netlabel

for ->accept, there is no such "feature"; if the client that just connect is in the /smack/netlabel,
SMACK send packeted label (although it shouldn't)
This breaks some applications (like sshd)


The following patch  adds a "post_access" hook to get the client IP and check it against the netlabel list. 
Please comment

regards,
Etienne

Signed-off-by: <etienne.basset@numericable.fr>
--
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index e6f89d6..74206db 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -27,6 +27,7 @@
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
 #include <linux/audit.h>
+#include <net/ipv6.h>
 
 #include "smack.h"
 
@@ -1566,6 +1567,78 @@ static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
 }
 
 /**
+ * smack_socket_post_access - post access check
+ * @sock: the socket
+ * @newsock : the grafted sock
+ *
+ * we have to match client IP against smack_host_label()
+ */
+static void  smack_socket_post_accept(struct socket *sock, struct socket *newsock)
+{
+	char *hostsp;
+	struct sockaddr_storage address;
+	struct sockaddr_in *sin;
+	struct sockaddr_in6 *sin6;
+	struct in6_addr *addr6;
+	struct socket_smack *ssp = newsock->sk->sk_security;
+	int len;
+
+	if (sock->sk == NULL)
+		return;
+
+	/* sockets can listen on both IPv4 & IPv6,
+	   and fallback to V4 if client is V4 */
+	if  (newsock->sk->sk_family != AF_INET && newsock->sk->sk_family != AF_INET6)
+		return;
+
+	/* get the client IP address **/
+	newsock->ops->getname(newsock, (struct sockaddr *)&address, &len, 2);
+
+	switch (newsock->sk->sk_family) {
+	case AF_INET:
+		sin = (struct sockaddr_in *)&address;
+		break;
+	case AF_INET6:
+		sin6  = (struct sockaddr_in6 *)&address;
+		addr6 = &sin6->sin6_addr;
+		/* if a V4 client connects to a V6 listening server,
+		 * we will get a IPV6_ADDR_MAPPED mapped address here
+		 * we have to handle this case too
+		 * the test below is ipv6_addr_type()== IPV6_ADDR_MAPPED
+		 * without the requirement to have IPv6 compiled in
+		 */
+		if ((addr6->s6_addr32[0] | addr6->s6_addr32[1]) == 0 &&
+				addr6->s6_addr32[2] == htonl(0x0000ffff)) {
+			__be32 addr = sin6->sin6_addr.s6_addr32[3];
+			__be16 port = sin6->sin6_port;
+			sin = (struct sockaddr_in *)&address;
+			sin->sin_family = AF_INET;
+			sin->sin_port = port;
+			sin->sin_addr.s_addr = addr;
+		} else {
+			/* standard IPv6, we'll send unlabeled */
+			smack_netlabel(newsock->sk, SMACK_UNLABELED_SOCKET);
+			return;
+		}
+		break;
+	default:
+		/** not possible to be there **/
+		return;
+	}
+	/* so, is there a label for the source IP **/
+	hostsp = smack_host_label(sin);
+
+	if (hostsp == NULL) {
+		if (ssp->smk_labeled != SMACK_CIPSO_SOCKET)
+			smack_netlabel(newsock->sk, SMACK_CIPSO_SOCKET);
+		return;
+	}
+	if (ssp->smk_labeled != SMACK_UNLABELED_SOCKET)
+		smack_netlabel(newsock->sk, SMACK_UNLABELED_SOCKET);
+	return;
+}
+
+/**
  * smack_flags_to_may - convert S_ to MAY_ values
  * @flags: the S_ value
  *
@@ -2906,6 +2979,7 @@ struct security_operations smack_ops = {
 
 	.socket_post_create = 		smack_socket_post_create,
 	.socket_connect =		smack_socket_connect,
+	.socket_post_accept =           smack_socket_post_accept,
 	.socket_sendmsg =		smack_socket_sendmsg,
 	.socket_sock_rcv_skb = 		smack_socket_sock_rcv_skb,
 	.socket_getpeersec_stream =	smack_socket_getpeersec_stream,
@@ -2936,7 +3010,7 @@ struct security_operations smack_ops = {
 };
 
 
-static __init init_smack_know_list(void)
+static __init void init_smack_know_list(void)
 {
 	list_add(&smack_known_huh.list, &smack_known_list);
 	list_add(&smack_known_hat.list, &smack_known_list);
@@ -2944,6 +3018,7 @@ static __init init_smack_know_list(void)
 	list_add(&smack_known_floor.list, &smack_known_list);
 	list_add(&smack_known_invalid.list, &smack_known_list);
 	list_add(&smack_known_web.list, &smack_known_list);
+	return;
 }
 
 /**

