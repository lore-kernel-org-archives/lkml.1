Return-Path: <linux-kernel-owner+w=401wt.eu-S932868AbXBEOcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbXBEOcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932874AbXBEOcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:32:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868AbXBEOcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:32:07 -0500
Subject: [DLM] Make sock_sem into a mutex [40/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Patrick Caulfield <pcaulfie@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:40:03 +0000
Message-Id: <1170686403.11001.351.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From efc9c1f41a1858b588727f3520579e01cd9ac914 Mon Sep 17 00:00:00 2001
From: Patrick Caulfield <pcaulfie@redhat.com>
Date: Wed, 24 Jan 2007 11:17:59 +0000
Subject: [PATCH] [DLM] Make sock_sem into a mutex

Now that there can be multiple dlm_recv threads running we need to prevent two
recvs running for the same connection - it's unlikely but it can happen and it
causes message corruption.

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms-tcp.c b/fs/dlm/lowcomms-tcp.c
index 8e6a76c..18ade44 100644
--- a/fs/dlm/lowcomms-tcp.c
+++ b/fs/dlm/lowcomms-tcp.c
@@ -96,7 +96,7 @@ static bool cbuf_empty(struct cbuf *cb)
 struct connection {
 	struct socket *sock;	/* NULL if not connected */
 	uint32_t nodeid;	/* So we know who we are in the list */
-	struct rw_semaphore sock_sem; /* Stop connect races */
+	struct mutex sock_mutex;
 	unsigned long flags;	/* bit 1,2 = We are on the read/write lists */
 #define CF_READ_PENDING 1
 #define CF_WRITE_PENDING 2
@@ -171,7 +171,7 @@ static struct connection *nodeid2con(int nodeid, gfp_t allocation)
 			goto finish;
 
 		con->nodeid = nodeid;
-		init_rwsem(&con->sock_sem);
+		mutex_init(&con->sock_mutex);
 		INIT_LIST_HEAD(&con->writequeue);
 		spin_lock_init(&con->writequeue_lock);
 		INIT_WORK(&con->swork, process_send_sockets);
@@ -247,7 +247,7 @@ static void make_sockaddr(struct sockaddr_storage *saddr, uint16_t port,
 /* Close a remote connection and tidy up */
 static void close_connection(struct connection *con, bool and_other)
 {
-	down_write(&con->sock_sem);
+	mutex_lock(&con->sock_mutex);
 
 	if (con->sock) {
 		sock_release(con->sock);
@@ -262,7 +262,7 @@ static void close_connection(struct connection *con, bool and_other)
 		con->rx_page = NULL;
 	}
 	con->retries = 0;
-	up_write(&con->sock_sem);
+	mutex_unlock(&con->sock_mutex);
 }
 
 /* Data received from remote end */
@@ -276,7 +276,7 @@ static int receive_from_sock(struct connection *con)
 	int r;
 	int call_again_soon = 0;
 
-	down_read(&con->sock_sem);
+	mutex_lock(&con->sock_mutex);
 
 	if (con->sock == NULL)
 		goto out;
@@ -355,17 +355,17 @@ static int receive_from_sock(struct connection *con)
 out:
 	if (call_again_soon)
 		goto out_resched;
-	up_read(&con->sock_sem);
+	mutex_unlock(&con->sock_mutex);
 	return 0;
 
 out_resched:
 	if (!test_and_set_bit(CF_READ_PENDING, &con->flags))
 		queue_work(recv_workqueue, &con->rwork);
-	up_read(&con->sock_sem);
+	mutex_unlock(&con->sock_mutex);
 	return -EAGAIN;
 
 out_close:
-	up_read(&con->sock_sem);
+	mutex_unlock(&con->sock_mutex);
 	if (ret != -EAGAIN && !test_bit(CF_IS_OTHERCON, &con->flags)) {
 		close_connection(con, false);
 		/* Reconnect when there is something to send */
@@ -391,7 +391,7 @@ static int accept_from_sock(struct connection *con)
 	if (result < 0)
 		return -ENOMEM;
 
-	down_read_nested(&con->sock_sem, 0);
+	mutex_lock_nested(&con->sock_mutex, 0);
 
 	result = -ENOTCONN;
 	if (con->sock == NULL)
@@ -417,7 +417,7 @@ static int accept_from_sock(struct connection *con)
 	if (dlm_addr_to_nodeid(&peeraddr, &nodeid)) {
 		printk("dlm: connect from non cluster node\n");
 		sock_release(newsock);
-		up_read(&con->sock_sem);
+		mutex_unlock(&con->sock_mutex);
 		return -1;
 	}
 
@@ -434,7 +434,7 @@ static int accept_from_sock(struct connection *con)
 		result = -ENOMEM;
 		goto accept_err;
 	}
-	down_write_nested(&newcon->sock_sem, 1);
+	mutex_lock_nested(&newcon->sock_mutex, 1);
 	if (newcon->sock) {
 		struct connection *othercon = newcon->othercon;
 
@@ -442,13 +442,13 @@ static int accept_from_sock(struct connection *con)
 			othercon = kmem_cache_zalloc(con_cache, GFP_KERNEL);
 			if (!othercon) {
 				printk("dlm: failed to allocate incoming socket\n");
-				up_write(&newcon->sock_sem);
+				mutex_unlock(&newcon->sock_mutex);
 				result = -ENOMEM;
 				goto accept_err;
 			}
 			othercon->nodeid = nodeid;
 			othercon->rx_action = receive_from_sock;
-			init_rwsem(&othercon->sock_sem);
+			mutex_init(&othercon->sock_mutex);
 			INIT_WORK(&othercon->swork, process_send_sockets);
 			INIT_WORK(&othercon->rwork, process_recv_sockets);
 			set_bit(CF_IS_OTHERCON, &othercon->flags);
@@ -466,7 +466,7 @@ static int accept_from_sock(struct connection *con)
 		addcon = newcon;
 	}
 
-	up_write(&newcon->sock_sem);
+	mutex_unlock(&newcon->sock_mutex);
 
 	/*
 	 * Add it to the active queue in case we got data
@@ -475,12 +475,12 @@ static int accept_from_sock(struct connection *con)
 	 */
 	if (!test_and_set_bit(CF_READ_PENDING, &addcon->flags))
 		queue_work(recv_workqueue, &addcon->rwork);
-	up_read(&con->sock_sem);
+	mutex_unlock(&con->sock_mutex);
 
 	return 0;
 
 accept_err:
-	up_read(&con->sock_sem);
+	mutex_unlock(&con->sock_mutex);
 	sock_release(newsock);
 
 	if (result != -EAGAIN)
@@ -501,7 +501,7 @@ static void connect_to_sock(struct connection *con)
 		return;
 	}
 
-	down_write(&con->sock_sem);
+	mutex_lock(&con->sock_mutex);
 	if (con->retries++ > MAX_CONNECT_RETRIES)
 		goto out;
 
@@ -553,7 +553,7 @@ out_err:
 		result = 0;
 	}
 out:
-	up_write(&con->sock_sem);
+	mutex_unlock(&con->sock_mutex);
 	return;
 }
 
@@ -757,7 +757,7 @@ static void send_to_sock(struct connection *con)
 	struct writequeue_entry *e;
 	int len, offset;
 
-	down_read(&con->sock_sem);
+	mutex_lock(&con->sock_mutex);
 	if (con->sock == NULL)
 		goto out_connect;
 
@@ -803,17 +803,17 @@ static void send_to_sock(struct connection *con)
 	}
 	spin_unlock(&con->writequeue_lock);
 out:
-	up_read(&con->sock_sem);
+	mutex_unlock(&con->sock_mutex);
 	return;
 
 send_error:
-	up_read(&con->sock_sem);
+	mutex_unlock(&con->sock_mutex);
 	close_connection(con, false);
 	lowcomms_connect_sock(con);
 	return;
 
 out_connect:
-	up_read(&con->sock_sem);
+	mutex_unlock(&con->sock_mutex);
 	connect_to_sock(con);
 	return;
 }
-- 
1.4.4.2



