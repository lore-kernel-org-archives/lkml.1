Return-Path: <linux-kernel-owner+w=401wt.eu-S1760950AbXJDJ06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950AbXJDJ06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759549AbXJDJSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759459AbXJDJSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:02 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Patrick Caulfield <pcaulfie@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 26/51] [DLM] Fix lowcomms socket closing
Date: Thu,  4 Oct 2007 09:49:19 +0100
Message-Id: <11914878383633-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878361239-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
 <11914878304004-git-send-email-swhiteho@redhat.com>
 <11914878323899-git-send-email-swhiteho@redhat.com>
 <11914878342921-git-send-email-swhiteho@redhat.com>
 <11914878361239-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Caulfield <pcaulfie@redhat.com>

This patch fixes the slight mess made in lowcomms closing by previous patches
and fixes all sorts of DLM hangs.

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 9e9d2e8..62a8a6c 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -334,18 +334,8 @@ static void close_connection(struct connection *con, bool and_other)
 		con->rx_page = NULL;
 	}
 
-	/* If we are an 'othercon' then NULL the pointer to us
-	   from the parent and tidy ourself up */
-	if (test_bit(CF_IS_OTHERCON, &con->flags)) {
-		struct connection *parent = __nodeid2con(con->nodeid, 0);
-		parent->othercon = NULL;
-		kmem_cache_free(con_cache, con);
-	}
-	else {
-		/* Parent connections get reused */
-		con->retries = 0;
-		mutex_unlock(&con->sock_mutex);
-	}
+	con->retries = 0;
+	mutex_unlock(&con->sock_mutex);
 }
 
 /* We only send shutdown messages to nodes that are not part of the cluster */
@@ -731,6 +721,8 @@ static int tcp_accept_from_sock(struct connection *con)
 			INIT_WORK(&othercon->swork, process_send_sockets);
 			INIT_WORK(&othercon->rwork, process_recv_sockets);
 			set_bit(CF_IS_OTHERCON, &othercon->flags);
+		}
+		if (!othercon->sock) {
 			newcon->othercon = othercon;
 			othercon->sock = newsock;
 			newsock->sk->sk_user_data = othercon;
-- 
1.5.1.2

