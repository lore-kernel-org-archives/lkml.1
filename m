Return-Path: <linux-kernel-owner+w=401wt.eu-S932815AbXBEO2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbXBEO2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932874AbXBEO2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:28:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868AbXBEO2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:28:39 -0500
Subject: [DLM] fix lowcomms receiving [35/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Patrick Caulfield <pcaulfie@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:36:43 +0000
Message-Id: <1170686203.11001.341.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8fc2b7f76db12f7f214948e01ebd9d36f25a873c Mon Sep 17 00:00:00 2001
From: Patrick Caulfield <pcaulfie@redhat.com>
Date: Mon, 22 Jan 2007 14:51:33 +0000
Subject: [PATCH] [DLM] fix lowcomms receiving

This patch fixes a bug whereby data on a newly accepted connection would be
ignored if it arrived soon after the accept.

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms-tcp.c b/fs/dlm/lowcomms-tcp.c
index 6e27201..8e6a76c 100644
--- a/fs/dlm/lowcomms-tcp.c
+++ b/fs/dlm/lowcomms-tcp.c
@@ -327,6 +327,9 @@ static int receive_from_sock(struct connection *con)
 
 	if (ret <= 0)
 		goto out_close;
+	if (ret == -EAGAIN)
+		goto out_resched;
+
 	if (ret == len)
 		call_again_soon = 1;
 	cbuf_add(&con->cb, ret);
@@ -359,8 +362,7 @@ out_resched:
 	if (!test_and_set_bit(CF_READ_PENDING, &con->flags))
 		queue_work(recv_workqueue, &con->rwork);
 	up_read(&con->sock_sem);
-	cond_resched();
-	return 0;
+	return -EAGAIN;
 
 out_close:
 	up_read(&con->sock_sem);
@@ -381,6 +383,7 @@ static int accept_from_sock(struct connection *con)
 	int len;
 	int nodeid;
 	struct connection *newcon;
+	struct connection *addcon;
 
 	memset(&peeraddr, 0, sizeof(peeraddr));
 	result = sock_create_kern(dlm_local_addr.ss_family, SOCK_STREAM,
@@ -454,12 +457,13 @@ static int accept_from_sock(struct connection *con)
 		othercon->sock = newsock;
 		newsock->sk->sk_user_data = othercon;
 		add_sock(newsock, othercon);
+		addcon = othercon;
 	}
 	else {
 		newsock->sk->sk_user_data = newcon;
 		newcon->rx_action = receive_from_sock;
 		add_sock(newsock, newcon);
-
+		addcon = newcon;
 	}
 
 	up_write(&newcon->sock_sem);
@@ -469,8 +473,8 @@ static int accept_from_sock(struct connection *con)
 	 * beween processing the accept adding the socket
 	 * to the read_sockets list
 	 */
-	if (!test_and_set_bit(CF_READ_PENDING, &newcon->flags))
-		queue_work(recv_workqueue, &newcon->rwork);
+	if (!test_and_set_bit(CF_READ_PENDING, &addcon->flags))
+		queue_work(recv_workqueue, &addcon->rwork);
 	up_read(&con->sock_sem);
 
 	return 0;
@@ -610,8 +614,7 @@ static struct socket *create_listen_sock(struct connection *con,
 
 	result = sock->ops->listen(sock, 5);
 	if (result < 0) {
-		printk("dlm: Can't listen on port %d\n",
-		       dlm_config.ci_tcp_port);
+		printk("dlm: Can't listen on port %d\n", dlm_config.ci_tcp_port);
 		sock_release(sock);
 		sock = NULL;
 		goto create_out;
@@ -811,7 +814,7 @@ send_error:
 
 out_connect:
 	up_read(&con->sock_sem);
-	lowcomms_connect_sock(con);
+	connect_to_sock(con);
 	return;
 }
 
@@ -873,9 +876,8 @@ static void process_send_sockets(struct work_struct *work)
 		connect_to_sock(con);
 	}
 
-	if (test_and_clear_bit(CF_WRITE_PENDING, &con->flags)) {
-		send_to_sock(con);
-	}
+	clear_bit(CF_WRITE_PENDING, &con->flags);
+	send_to_sock(con);
 }
 
 
-- 
1.4.4.2



