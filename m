Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZINQOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZINQOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbZINQNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:13:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108AbZINQNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:13:50 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Casey Dahlin <cdahlin@redhat.com>
Subject: [PATCH 1/3] dlm: fix double-release of socket in error exit path
Date: Mon, 14 Sep 2009 11:05:50 -0500
Message-Id: <1252944352-5852-2-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Dahlin <cdahlin@redhat.com>

The last correction to the tcp_connect_to_sock error exit path,
commit a89d63a159b1ba5833be2bef00adf8ad8caac8be, can free an already
freed socket, due to collision with a previous (incomplete) attempt
to fix the same issue, commit 311f6fc77c51926dbdfbeab0a5d88d70f01fa3f4.

Signed-off-by: Casey Dahlin <cdahlin@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lowcomms.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 618a60f..210d52c 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -926,10 +926,8 @@ static void tcp_connect_to_sock(struct connection *con)
 		goto out_err;
 
 	memset(&saddr, 0, sizeof(saddr));
-	if (dlm_nodeid_to_addr(con->nodeid, &saddr)) {
-		sock_release(sock);
+	if (dlm_nodeid_to_addr(con->nodeid, &saddr))
 		goto out_err;
-	}
 
 	sock->sk->sk_user_data = con;
 	con->rx_action = receive_from_sock;
-- 
1.5.5.6

