Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbXGIQj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbXGIQj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758238AbXGIQYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947AbXGIQYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:40 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Patrick Caulfield <pcaulfie@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] Telnet to port 21064 can stop all lockspaces
Date: Mon,  9 Jul 2007 17:02:54 +0100
Message-Id: <11839970852076-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970832750-git-send-email-swhiteho@redhat.com>
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
 <11839970421091-git-send-email-swhiteho@redhat.com>
 <11839970442448-git-send-email-swhiteho@redhat.com>
 <11839970463325-git-send-email-swhiteho@redhat.com>
 <11839970481383-git-send-email-swhiteho@redhat.com>
 <1183997050365-git-send-email-swhiteho@redhat.com>
 <11839970521835-git-send-email-swhiteho@redhat.com>
 <11839970542719-git-send-email-swhiteho@redhat.com>
 <1183997056121-git-send-email-swhiteho@redhat.com>
 <11839970573954-git-send-email-swhiteho@redhat.com>
 <11839970591207-git-send-email-swhiteho@redhat.com>
 <11839970611456-git-send-email-swhiteho@redhat.com>
 <11839970633982-git-send-email-swhiteho@redhat.com>
 <11839970653759-git-send-email-swhiteho@redhat.com>
 <1183997067333-git-send-email-swhiteho@redhat.com>
 <11839970691406-git-send-email-swhiteho@redhat.com>
 <11839970711372-git-send-email-swhiteho@redhat.com>
 <1183997073435-git-send-email-swhiteho@redhat.com>
 <11839970752058-git-send-email-swhiteho@redhat.com>
 <11839970773694-git-send-email-swhiteho@redhat.com>
 <11839970793713-git-send-email-swhiteho@redhat.com>
 <11839970813260-git-send-email-swhiteho@redhat.com>
 <11839970832750-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Caulfield <pcaulfie@redhat.com>

This patch fixes Red Hat bz#245892

Opening a tcp connection from a cluster member to another cluster member
targeting the dlm port it is enough to stop every dlm operation in the cluster.
This means that GFS and rgmanager will hang.

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index fc0bff7..73d44f5 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -720,11 +720,17 @@ static int tcp_accept_from_sock(struct connection *con)
 			INIT_WORK(&othercon->rwork, process_recv_sockets);
 			set_bit(CF_IS_OTHERCON, &othercon->flags);
 			newcon->othercon = othercon;
+			othercon->sock = newsock;
+			newsock->sk->sk_user_data = othercon;
+			add_sock(newsock, othercon);
+			addcon = othercon;
+		}
+		else {
+			printk("Extra connection from node %d attempted\n", nodeid);
+			result = -EAGAIN;
+			up_write(&newcon->sock_sem);
+			goto accept_err;
 		}
-		othercon->sock = newsock;
-		newsock->sk->sk_user_data = othercon;
-		add_sock(newsock, othercon);
-		addcon = othercon;
 	}
 	else {
 		newsock->sk->sk_user_data = newcon;
-- 
1.5.1.2

