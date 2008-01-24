Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbYAXQ70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbYAXQ70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758257AbYAXQ6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758244AbYAXQ6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:34 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Lon Hohberger <lhh@redhat.com>
Subject: [PATCH 01/19] dlm: bind connections from known local address when using TCP
Date: Thu, 24 Jan 2008 10:50:24 -0600
Message-Id: <1201193442-8260-2-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lon Hohberger <lhh@redhat.com>

A common problem occurs when multiple IP addresses within the same
subnet are assigned to the same NIC.  If we make a connection attempt to
another address on the same subnet as one of those addresses, the
connection attempt will not necessarily be routed from the address we
want.

In the case of the DLM, the other nodes will quickly drop the connection
attempt, causing problems.

This patch makes the DLM bind to the local address it acquired from the
cluster manager when using TCP prior to making a connection, obviating
the need for administrators to "fix" their systems or use clever routing
tricks.

Signed-off-by: Lon Hohberger <lhh@redhat.com>
Signed-off-by: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lowcomms.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index e9923ca..5772844 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -864,7 +864,7 @@ static void sctp_init_assoc(struct connection *con)
 static void tcp_connect_to_sock(struct connection *con)
 {
 	int result = -EHOSTUNREACH;
-	struct sockaddr_storage saddr;
+	struct sockaddr_storage saddr, src_addr;
 	int addr_len;
 	struct socket *sock;
 
@@ -898,6 +898,17 @@ static void tcp_connect_to_sock(struct connection *con)
 	con->connect_action = tcp_connect_to_sock;
 	add_sock(sock, con);
 
+	/* Bind to our cluster-known address connecting to avoid
+	   routing problems */
+	memcpy(&src_addr, dlm_local_addr[0], sizeof(src_addr));
+	make_sockaddr(&src_addr, 0, &addr_len);
+	result = sock->ops->bind(sock, (struct sockaddr *) &src_addr,
+				 addr_len);
+	if (result < 0) {
+		log_print("could not bind for connect: %d", result);
+		/* This *may* not indicate a critical error */
+	}
+
 	make_sockaddr(&saddr, dlm_config.ci_tcp_port, &addr_len);
 
 	log_print("connecting to %d", con->nodeid);
-- 
1.5.3.3

