Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZINQOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZINQOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbZINQOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:14:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034AbZINQNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:13:52 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Lars Marowsky-Bree <lmb@suse.de>
Subject: [PATCH 2/3] dlm: fix connection close handling
Date: Mon, 14 Sep 2009 11:05:51 -0500
Message-Id: <1252944352-5852-3-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Marowsky-Bree <lmb@suse.de>

Closing a connection to a node can create problems if there are
outstanding messages for that node.  The problems include dlm_send
spinning attempting to reconnect, or BUG from tcp_connect_to_sock()
attempting to use a partially closed connection.

To cleanly close a connection, we now first attempt to send any pending
messages, cancel any remaining workqueue work, and flag the connection
as closed to avoid reconnect attempts.

Signed-off-by: Lars Marowsky-Bree <lmb@suse.de>
Signed-off-by: Christine Caulfield <ccaulfie@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lowcomms.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 210d52c..bda690c 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -106,6 +106,7 @@ struct connection {
 #define CF_CONNECT_PENDING 3
 #define CF_INIT_PENDING 4
 #define CF_IS_OTHERCON 5
+#define CF_CLOSE 6
 	struct list_head writequeue;  /* List of outgoing writequeue_entries */
 	spinlock_t writequeue_lock;
 	int (*rx_action) (struct connection *);	/* What to do when active */
@@ -299,6 +300,8 @@ static void lowcomms_write_space(struct sock *sk)
 
 static inline void lowcomms_connect_sock(struct connection *con)
 {
+	if (test_bit(CF_CLOSE, &con->flags))
+		return;
 	if (!test_and_set_bit(CF_CONNECT_PENDING, &con->flags))
 		queue_work(send_workqueue, &con->swork);
 }
@@ -1368,6 +1371,13 @@ int dlm_lowcomms_close(int nodeid)
 	log_print("closing connection to node %d", nodeid);
 	con = nodeid2con(nodeid, 0);
 	if (con) {
+		clear_bit(CF_CONNECT_PENDING, &con->flags);
+		clear_bit(CF_WRITE_PENDING, &con->flags);
+		set_bit(CF_CLOSE, &con->flags);
+		if (cancel_work_sync(&con->swork))
+			log_print("canceled swork for node %d", nodeid);
+		if (cancel_work_sync(&con->rwork))
+			log_print("canceled rwork for node %d", nodeid);
 		clean_one_writequeue(con);
 		close_connection(con, true);
 	}
@@ -1393,9 +1403,10 @@ static void process_send_sockets(struct work_struct *work)
 
 	if (test_and_clear_bit(CF_CONNECT_PENDING, &con->flags)) {
 		con->connect_action(con);
+		set_bit(CF_WRITE_PENDING, &con->flags);
 	}
-	clear_bit(CF_WRITE_PENDING, &con->flags);
-	send_to_sock(con);
+	if (test_and_clear_bit(CF_WRITE_PENDING, &con->flags))
+		send_to_sock(con);
 }
 
 
-- 
1.5.5.6

