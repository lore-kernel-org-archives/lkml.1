Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbZJLVKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbZJLVKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758185AbZJLVKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:10:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758183AbZJLVKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:10:12 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] dlm: fix socket fd translation
Date: Mon, 12 Oct 2009 16:10:29 -0500
Message-Id: <1255381829-3929-2-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code to set up sctp sockets was not using the sockfd_lookup()
and sockfd_put() routines to translate an fd to a socket.  The
direct fget and fput calls were resulting in error messages from
alloc_fd().

Also clean up two log messages and remove a third, related to
setting up sctp associations.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lowcomms.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index a3350e4..70736eb 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -459,9 +459,9 @@ static void process_sctp_notification(struct connection *con,
 			int prim_len, ret;
 			int addr_len;
 			struct connection *new_con;
-			struct file *file;
 			sctp_peeloff_arg_t parg;
 			int parglen = sizeof(parg);
+			int err;
 
 			/*
 			 * We get this before any data for an association.
@@ -516,19 +516,22 @@ static void process_sctp_notification(struct connection *con,
 			ret = kernel_getsockopt(con->sock, IPPROTO_SCTP,
 						SCTP_SOCKOPT_PEELOFF,
 						(void *)&parg, &parglen);
-			if (ret) {
+			if (ret < 0) {
 				log_print("Can't peel off a socket for "
-					  "connection %d to node %d: err=%d\n",
+					  "connection %d to node %d: err=%d",
 					  parg.associd, nodeid, ret);
+				return;
+			}
+			new_con->sock = sockfd_lookup(parg.sd, &err);
+			if (!new_con->sock) {
+				log_print("sockfd_lookup error %d", err);
+				return;
 			}
-			file = fget(parg.sd);
-			new_con->sock = SOCKET_I(file->f_dentry->d_inode);
 			add_sock(new_con->sock, new_con);
-			fput(file);
-			put_unused_fd(parg.sd);
+			sockfd_put(new_con->sock);
 
-			log_print("got new/restarted association %d nodeid %d",
-				 (int)sn->sn_assoc_change.sac_assoc_id, nodeid);
+			log_print("connecting to %d sctp association %d",
+				 nodeid, (int)sn->sn_assoc_change.sac_assoc_id);
 
 			/* Send any pending writes */
 			clear_bit(CF_CONNECT_PENDING, &new_con->flags);
@@ -841,8 +844,6 @@ static void sctp_init_assoc(struct connection *con)
 	if (con->retries++ > MAX_CONNECT_RETRIES)
 		return;
 
-	log_print("Initiating association with node %d", con->nodeid);
-
 	if (nodeid_to_addr(con->nodeid, (struct sockaddr *)&rem_addr)) {
 		log_print("no address for nodeid %d", con->nodeid);
 		return;
-- 
1.5.5.6

