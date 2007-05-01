Return-Path: <linux-kernel-owner+w=401wt.eu-S1161706AbXEAK0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161706AbXEAK0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161698AbXEAK0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:26:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161680AbXEAK0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:26:48 -0400
Subject: [DLM] Lowcomms nodeid range & initialisation fixes [29/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Patrick Caulfield <pcaulfie@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:22:11 +0100
Message-Id: <1178014931.5462.188.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 30d3a2373f171e62e4032819f55fed2ec887d0b8 Mon Sep 17 00:00:00 2001
From: Patrick Caulfield <pcaulfie@redhat.com>
Date: Mon, 23 Apr 2007 16:26:21 +0100
Subject: [PATCH] [DLM] Lowcomms nodeid range & initialisation fixes

Fix a few range & initialization bugs in lowcomms.
- max_nodeid is really the highest nodeid encountered, so all loops must include
it in their iterations.
- clean dlm_local_count & connection_idr so we can do a clean restart.
- Remove a spurious BUG_ON

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 2b32f3c..5c33233 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -219,7 +219,7 @@ static struct connection *assoc2con(int assoc_id)
 	struct connection *con;
 
 	down(&connections_lock);
-	for (i=0; i<max_nodeid; i++) {
+	for (i=0; i<=max_nodeid; i++) {
 		con = __nodeid2con(i, 0);
 		if (con && con->sctp_assoc == assoc_id) {
 			up(&connections_lock);
@@ -467,12 +467,10 @@ static void process_sctp_notification(struct connection *con, struct msghdr *msg
 			parg.associd = sn->sn_assoc_change.sac_assoc_id;
 			ret = kernel_getsockopt(con->sock, IPPROTO_SCTP, SCTP_SOCKOPT_PEELOFF,
 						(void *)&parg, &parglen);
-			if (ret < 0) {
+			if (ret) {
 				log_print("Can't peel off a socket for connection %d to node %d: err=%d\n",
 					  parg.associd, nodeid, ret);
-				return;
 			}
-
 			file = fget(parg.sd);
 			new_con->sock = SOCKET_I(file->f_dentry->d_inode);
 			add_sock(new_con->sock, new_con);
@@ -585,7 +583,6 @@ static int receive_from_sock(struct connection *con)
 
 	/* Process SCTP notifications */
 	if (msg.msg_flags & MSG_NOTIFICATION) {
-		BUG_ON(con->nodeid != 0);
 		msg.msg_control = incmsg;
 		msg.msg_controllen = sizeof(incmsg);
 
@@ -984,6 +981,7 @@ static void init_local(void)
 	struct sockaddr_storage sas, *addr;
 	int i;
 
+	dlm_local_count = 0;
 	for (i = 0; i < DLM_MAX_ADDR_COUNT - 1; i++) {
 		if (dlm_our_addr(&sas, i))
 			break;
@@ -1350,8 +1348,8 @@ static void clean_writequeues(void)
 {
 	int nodeid;
 
-	for (nodeid = 1; nodeid < max_nodeid; nodeid++) {
-		struct connection *con = nodeid2con(nodeid, 0);
+	for (nodeid = 1; nodeid <= max_nodeid; nodeid++) {
+		struct connection *con = __nodeid2con(nodeid, 0);
 
 		if (con)
 			clean_one_writequeue(con);
@@ -1394,7 +1392,7 @@ void dlm_lowcomms_stop(void)
 	   socket activity.
 	*/
 	down(&connections_lock);
-	for (i = 0; i < max_nodeid; i++) {
+	for (i = 0; i <= max_nodeid; i++) {
 		con = __nodeid2con(i, 0);
 		if (con)
 			con->flags |= 0xFF;
@@ -1406,7 +1404,7 @@ void dlm_lowcomms_stop(void)
 	down(&connections_lock);
 	clean_writequeues();
 
-	for (i = 0; i < max_nodeid; i++) {
+	for (i = 0; i <= max_nodeid; i++) {
 		con = __nodeid2con(i, 0);
 		if (con) {
 			close_connection(con, true);
@@ -1415,8 +1413,10 @@ void dlm_lowcomms_stop(void)
 			kmem_cache_free(con_cache, con);
 		}
 	}
+	max_nodeid = 0;
 	up(&connections_lock);
 	kmem_cache_destroy(con_cache);
+	idr_init(&connections_idr);
 }
 
 int dlm_lowcomms_start(void)
-- 
1.5.1.2



