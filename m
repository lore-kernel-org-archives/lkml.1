Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbXGIQcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbXGIQcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbXGIQX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758183AbXGIQX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:57 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Patrick Caulfield <pcaulfie@redhat.com>,
       David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] fix socket shutdown
Date: Mon,  9 Jul 2007 17:02:32 +0100
Message-Id: <11839970421091-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970403929-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
 <1183997034982-git-send-email-swhiteho@redhat.com>
 <1183997036270-git-send-email-swhiteho@redhat.com>
 <11839970383020-git-send-email-swhiteho@redhat.com>
 <11839970403929-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Caulfield <pcaulfie@redhat.com>

This patch clears the user_data of active sockets as part of cleanup.
This prevents any late-arriving data from trying to add jobs to the work
queue while we are tidying up.

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-Off-By: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 27970a5..fc0bff7 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -260,7 +260,7 @@ static int nodeid_to_addr(int nodeid, struct sockaddr *retaddr)
 static void lowcomms_data_ready(struct sock *sk, int count_unused)
 {
 	struct connection *con = sock2con(sk);
-	if (!test_and_set_bit(CF_READ_PENDING, &con->flags))
+	if (con && !test_and_set_bit(CF_READ_PENDING, &con->flags))
 		queue_work(recv_workqueue, &con->rwork);
 }
 
@@ -268,7 +268,7 @@ static void lowcomms_write_space(struct sock *sk)
 {
 	struct connection *con = sock2con(sk);
 
-	if (!test_and_set_bit(CF_WRITE_PENDING, &con->flags))
+	if (con && !test_and_set_bit(CF_WRITE_PENDING, &con->flags))
 		queue_work(send_workqueue, &con->swork);
 }
 
@@ -1400,8 +1400,11 @@ void dlm_lowcomms_stop(void)
 	down(&connections_lock);
 	for (i = 0; i <= max_nodeid; i++) {
 		con = __nodeid2con(i, 0);
-		if (con)
+		if (con) {
 			con->flags |= 0xFF;
+			if (con->sock)
+				con->sock->sk->sk_user_data = NULL;
+		}
 	}
 	up(&connections_lock);
 
-- 
1.5.1.2

