Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbXHNKNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbXHNKNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbXHNKKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:10:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367AbXHNKKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:10:44 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Patrick Caulfield <pcaulfie@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] More othercon fixes
Date: Tue, 14 Aug 2007 10:47:09 +0100
Message-Id: <11870848503463-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11870848365-git-send-email-swhiteho@redhat.com>
References: <11870848365-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Caulfield <pcaulfie@redhat.com>

The last patch to clean out 'othercon' structures only fixed half the problem.
The attached addresses the other situations too, and fixes bz#238490

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 631bc43..9e9d2e8 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -328,15 +328,24 @@ static void close_connection(struct connection *con, bool and_other)
 	if (con->othercon && and_other) {
 		/* Will only re-enter once. */
 		close_connection(con->othercon, false);
-		kmem_cache_free(con_cache, con->othercon);
-		con->othercon = NULL;
 	}
 	if (con->rx_page) {
 		__free_page(con->rx_page);
 		con->rx_page = NULL;
 	}
-	con->retries = 0;
-	mutex_unlock(&con->sock_mutex);
+
+	/* If we are an 'othercon' then NULL the pointer to us
+	   from the parent and tidy ourself up */
+	if (test_bit(CF_IS_OTHERCON, &con->flags)) {
+		struct connection *parent = __nodeid2con(con->nodeid, 0);
+		parent->othercon = NULL;
+		kmem_cache_free(con_cache, con);
+	}
+	else {
+		/* Parent connections get reused */
+		con->retries = 0;
+		mutex_unlock(&con->sock_mutex);
+	}
 }
 
 /* We only send shutdown messages to nodes that are not part of the cluster */
@@ -634,7 +643,7 @@ out_resched:
 
 out_close:
 	mutex_unlock(&con->sock_mutex);
-	if (ret != -EAGAIN && !test_bit(CF_IS_OTHERCON, &con->flags)) {
+	if (ret != -EAGAIN) {
 		close_connection(con, false);
 		/* Reconnect when there is something to send */
 	}
@@ -1125,8 +1134,6 @@ static int tcp_listen_for_all(void)
 
 	log_print("Using TCP for communications");
 
-	set_bit(CF_IS_OTHERCON, &con->flags);
-
 	sock = tcp_create_listen_sock(con, dlm_local_addr[0]);
 	if (sock) {
 		add_sock(sock, con);
@@ -1410,7 +1417,7 @@ void dlm_lowcomms_stop(void)
 	for (i = 0; i <= max_nodeid; i++) {
 		con = __nodeid2con(i, 0);
 		if (con) {
-			con->flags |= 0xFF;
+			con->flags |= 0x0F;
 			if (con->sock)
 				con->sock->sk->sk_user_data = NULL;
 		}
@@ -1426,8 +1433,6 @@ void dlm_lowcomms_stop(void)
 		con = __nodeid2con(i, 0);
 		if (con) {
 			close_connection(con, true);
-			if (con->othercon)
-				kmem_cache_free(con_cache, con->othercon);
 			kmem_cache_free(con_cache, con);
 		}
 	}
-- 
1.5.1.2

