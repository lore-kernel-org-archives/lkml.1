Return-Path: <linux-kernel-owner+w=401wt.eu-S1423523AbXEAK3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423523AbXEAK3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423384AbXEAK33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:29:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423555AbXEAK3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:29:25 -0400
Subject: [DLM] lowcomms style [33/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, David Teigland <teigland@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:24:52 +0100
Message-Id: <1178015092.5462.196.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 617e82e10ccf96a13eb2efd5eac4abef44a87d02 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Thu, 26 Apr 2007 13:46:49 -0500
Subject: [PATCH] [DLM] lowcomms style

Replace some printk with log_print, and fix some simple cases of lines
over 80.  Also, return -ENOTCONN if lowcomms_start fails due to no local
IP address being available.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 5c33233..27970a5 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -395,7 +395,8 @@ static void sctp_init_failed(void)
 }
 
 /* Something happened to an association */
-static void process_sctp_notification(struct connection *con, struct msghdr *msg, char *buf)
+static void process_sctp_notification(struct connection *con,
+				      struct msghdr *msg, char *buf)
 {
 	union sctp_notification *sn = (union sctp_notification *)buf;
 
@@ -422,7 +423,7 @@ static void process_sctp_notification(struct connection *con, struct msghdr *msg
 			 */
 			if ((int)sn->sn_assoc_change.sac_assoc_id <= 0) {
 				log_print("COMM_UP for invalid assoc ID %d",
-					  (int)sn->sn_assoc_change.sac_assoc_id);
+					 (int)sn->sn_assoc_change.sac_assoc_id);
 				sctp_init_failed();
 				return;
 			}
@@ -465,10 +466,12 @@ static void process_sctp_notification(struct connection *con, struct msghdr *msg
 
 			/* Peel off a new sock */
 			parg.associd = sn->sn_assoc_change.sac_assoc_id;
-			ret = kernel_getsockopt(con->sock, IPPROTO_SCTP, SCTP_SOCKOPT_PEELOFF,
+			ret = kernel_getsockopt(con->sock, IPPROTO_SCTP,
+						SCTP_SOCKOPT_PEELOFF,
 						(void *)&parg, &parglen);
 			if (ret) {
-				log_print("Can't peel off a socket for connection %d to node %d: err=%d\n",
+				log_print("Can't peel off a socket for "
+					  "connection %d to node %d: err=%d\n",
 					  parg.associd, nodeid, ret);
 			}
 			file = fget(parg.sd);
@@ -478,7 +481,7 @@ static void process_sctp_notification(struct connection *con, struct msghdr *msg
 			put_unused_fd(parg.sd);
 
 			log_print("got new/restarted association %d nodeid %d",
-				  (int)sn->sn_assoc_change.sac_assoc_id, nodeid);
+				 (int)sn->sn_assoc_change.sac_assoc_id, nodeid);
 
 			/* Send any pending writes */
 			clear_bit(CF_CONNECT_PENDING, &new_con->flags);
@@ -587,7 +590,7 @@ static int receive_from_sock(struct connection *con)
 		msg.msg_controllen = sizeof(incmsg);
 
 		process_sctp_notification(con, &msg,
-					  page_address(con->rx_page) + con->cb.base);
+				page_address(con->rx_page) + con->cb.base);
 		mutex_unlock(&con->sock_mutex);
 		return 0;
 	}
@@ -601,10 +604,10 @@ static int receive_from_sock(struct connection *con)
 					  con->cb.base, con->cb.len,
 					  PAGE_CACHE_SIZE);
 	if (ret == -EBADMSG) {
-		printk(KERN_INFO "dlm: lowcomms: addr=%p, base=%u, len=%u, "
-		       "iov_len=%u, iov_base[0]=%p, read=%d\n",
-		       page_address(con->rx_page), con->cb.base, con->cb.len,
-		       len, iov[0].iov_base, r);
+		log_print("lowcomms: addr=%p, base=%u, len=%u, "
+			  "iov_len=%u, iov_base[0]=%p, read=%d",
+			  page_address(con->rx_page), con->cb.base, con->cb.len,
+			  len, iov[0].iov_base, r);
 	}
 	if (ret < 0)
 		goto out_close;
@@ -680,7 +683,7 @@ static int tcp_accept_from_sock(struct connection *con)
 	/* Get the new node's NODEID */
 	make_sockaddr(&peeraddr, 0, &len);
 	if (dlm_addr_to_nodeid(&peeraddr, &nodeid)) {
-		printk("dlm: connect from non cluster node\n");
+		log_print("connect from non cluster node");
 		sock_release(newsock);
 		mutex_unlock(&con->sock_mutex);
 		return -1;
@@ -705,7 +708,7 @@ static int tcp_accept_from_sock(struct connection *con)
 		if (!othercon) {
 			othercon = kmem_cache_zalloc(con_cache, GFP_KERNEL);
 			if (!othercon) {
-				printk("dlm: failed to allocate incoming socket\n");
+				log_print("failed to allocate incoming socket");
 				mutex_unlock(&newcon->sock_mutex);
 				result = -ENOMEM;
 				goto accept_err;
@@ -748,7 +751,7 @@ accept_err:
 	sock_release(newsock);
 
 	if (result != -EAGAIN)
-		printk("dlm: error accepting connection from node: %d\n", result);
+		log_print("error accepting connection from node: %d", result);
 	return result;
 }
 
@@ -826,7 +829,8 @@ static void sctp_init_assoc(struct connection *con)
 
 	ret = kernel_sendmsg(base_con->sock, &outmessage, iov, 1, len);
 	if (ret < 0) {
-		log_print("Send first packet to node %d failed: %d", con->nodeid, ret);
+		log_print("Send first packet to node %d failed: %d",
+			  con->nodeid, ret);
 
 		/* Try again later */
 		clear_bit(CF_CONNECT_PENDING, &con->flags);
@@ -929,9 +933,10 @@ static struct socket *tcp_create_listen_sock(struct connection *con,
 		addr_len = sizeof(struct sockaddr_in6);
 
 	/* Create a socket to communicate with */
-	result = sock_create_kern(dlm_local_addr[0]->ss_family, SOCK_STREAM, IPPROTO_TCP, &sock);
+	result = sock_create_kern(dlm_local_addr[0]->ss_family, SOCK_STREAM,
+				  IPPROTO_TCP, &sock);
 	if (result < 0) {
-		printk("dlm: Can't create listening comms socket\n");
+		log_print("Can't create listening comms socket");
 		goto create_out;
 	}
 
@@ -939,8 +944,7 @@ static struct socket *tcp_create_listen_sock(struct connection *con,
 				   (char *)&one, sizeof(one));
 
 	if (result < 0) {
-		printk("dlm: Failed to set SO_REUSEADDR on socket: result=%d\n",
-		       result);
+		log_print("Failed to set SO_REUSEADDR on socket: %d", result);
 	}
 	sock->sk->sk_user_data = con;
 	con->rx_action = tcp_accept_from_sock;
@@ -951,7 +955,7 @@ static struct socket *tcp_create_listen_sock(struct connection *con,
 	make_sockaddr(saddr, dlm_config.ci_tcp_port, &addr_len);
 	result = sock->ops->bind(sock, (struct sockaddr *) saddr, addr_len);
 	if (result < 0) {
-		printk("dlm: Can't bind to port %d\n", dlm_config.ci_tcp_port);
+		log_print("Can't bind to port %d", dlm_config.ci_tcp_port);
 		sock_release(sock);
 		sock = NULL;
 		con->sock = NULL;
@@ -960,12 +964,12 @@ static struct socket *tcp_create_listen_sock(struct connection *con,
 	result = kernel_setsockopt(sock, SOL_SOCKET, SO_KEEPALIVE,
 				 (char *)&one, sizeof(one));
 	if (result < 0) {
-		printk("dlm: Set keepalive failed: %d\n", result);
+		log_print("Set keepalive failed: %d", result);
 	}
 
 	result = sock->ops->listen(sock, 5);
 	if (result < 0) {
-		printk("dlm: Can't listen on port %d\n", dlm_config.ci_tcp_port);
+		log_print("Can't listen on port %d", dlm_config.ci_tcp_port);
 		sock_release(sock);
 		sock = NULL;
 		goto create_out;
@@ -994,8 +998,11 @@ static void init_local(void)
 	}
 }
 
-/* Bind to an IP address. SCTP allows multiple address so it can do multi-homing */
-static int add_sctp_bind_addr(struct connection *sctp_con, struct sockaddr_storage *addr, int addr_len, int num)
+/* Bind to an IP address. SCTP allows multiple address so it can do
+   multi-homing */
+static int add_sctp_bind_addr(struct connection *sctp_con,
+			      struct sockaddr_storage *addr,
+			      int addr_len, int num)
 {
 	int result = 0;
 
@@ -1048,10 +1055,10 @@ static int sctp_listen_for_all(void)
 	result = kernel_setsockopt(sock, SOL_SOCKET, SO_RCVBUF,
 				 (char *)&bufsize, sizeof(bufsize));
 	if (result)
-		log_print("Error increasing buffer space on socket: %d", result);
+		log_print("Error increasing buffer space on socket %d", result);
 
 	result = kernel_setsockopt(sock, SOL_SCTP, SCTP_EVENTS,
-				       (char *)&subscribe, sizeof(subscribe));
+				   (char *)&subscribe, sizeof(subscribe));
 	if (result < 0) {
 		log_print("Failed to set SCTP_EVENTS on socket: result=%d",
 			  result);
@@ -1102,7 +1109,8 @@ static int tcp_listen_for_all(void)
 
 	/* We don't support multi-homed hosts */
 	if (dlm_local_addr[1] != NULL) {
-		log_print("TCP protocol can't handle multi-homed hosts, try SCTP");
+		log_print("TCP protocol can't handle multi-homed hosts, "
+			  "try SCTP");
 		return -EINVAL;
 	}
 
@@ -1148,8 +1156,7 @@ static struct writequeue_entry *new_writequeue_entry(struct connection *con,
 	return entry;
 }
 
-void *dlm_lowcomms_get_buffer(int nodeid, int len,
-			      gfp_t allocation, char **ppc)
+void *dlm_lowcomms_get_buffer(int nodeid, int len, gfp_t allocation, char **ppc)
 {
 	struct connection *con;
 	struct writequeue_entry *e;
@@ -1253,8 +1260,7 @@ static void send_to_sock(struct connection *con)
 				goto out;
 			if (ret <= 0)
 				goto send_error;
-		}
-		else {
+		} else {
 			/* Don't starve people filling buffers */
 			cond_resched();
 		}
@@ -1426,6 +1432,7 @@ int dlm_lowcomms_start(void)
 
 	init_local();
 	if (!dlm_local_count) {
+		error = -ENOTCONN;
 		log_print("no local IP address has been set");
 		goto out;
 	}
-- 
1.5.1.2



