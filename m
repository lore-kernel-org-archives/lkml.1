Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbZJLVKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbZJLVKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbZJLVKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:10:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758184AbZJLVKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:10:12 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dlm: fix lowcomms_connect_node for sctp
Date: Mon, 12 Oct 2009 16:10:28 -0500
Message-Id: <1255381829-3929-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recently added dlm_lowcomms_connect_node() from
391fbdc5d527149578490db2f1619951d91f3561 does not work
when using SCTP instead of TCP.  The sctp connection code
has nothing to do without data to send.  Check for no data
in the sctp connection code and do nothing instead of
triggering a BUG.  Also have connect_node() do nothing
when the protocol is sctp.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lowcomms.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 240cef1..a3350e4 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -316,6 +316,10 @@ int dlm_lowcomms_connect_node(int nodeid)
 {
 	struct connection *con;
 
+	/* with sctp there's no connecting without sending */
+	if (dlm_config.ci_protocol != 0)
+		return 0;
+
 	if (nodeid == dlm_our_nodeid())
 		return 0;
 
@@ -855,11 +859,14 @@ static void sctp_init_assoc(struct connection *con)
 	outmessage.msg_flags = MSG_EOR;
 
 	spin_lock(&con->writequeue_lock);
-	e = list_entry(con->writequeue.next, struct writequeue_entry,
-		       list);
 
-	BUG_ON((struct list_head *) e == &con->writequeue);
+	if (list_empty(&con->writequeue)) {
+		spin_unlock(&con->writequeue_lock);
+		log_print("writequeue empty for nodeid %d", con->nodeid);
+		return;
+	}
 
+	e = list_first_entry(&con->writequeue, struct writequeue_entry, list);
 	len = e->len;
 	offset = e->offset;
 	spin_unlock(&con->writequeue_lock);
-- 
1.5.5.6

