Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbZINQOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbZINQOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZINQN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:13:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045AbZINQNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:13:55 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Paolo Bonzini <bonzini@gnu.org>
Subject: [PATCH 3/3] dlm: use kernel_sendpage
Date: Mon, 14 Sep 2009 11:05:52 -0500
Message-Id: <1252944352-5852-4-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <bonzini@gnu.org>

Using kernel_sendpage() is cleaner and safer than following
sock->ops ourselves.

Signed-off-by: Paolo Bonzini <bonzini@gnu.org>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lowcomms.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index bda690c..240cef1 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1285,7 +1285,6 @@ out:
 static void send_to_sock(struct connection *con)
 {
 	int ret = 0;
-	ssize_t(*sendpage) (struct socket *, struct page *, int, size_t, int);
 	const int msg_flags = MSG_DONTWAIT | MSG_NOSIGNAL;
 	struct writequeue_entry *e;
 	int len, offset;
@@ -1294,8 +1293,6 @@ static void send_to_sock(struct connection *con)
 	if (con->sock == NULL)
 		goto out_connect;
 
-	sendpage = con->sock->ops->sendpage;
-
 	spin_lock(&con->writequeue_lock);
 	for (;;) {
 		e = list_entry(con->writequeue.next, struct writequeue_entry,
@@ -1310,8 +1307,8 @@ static void send_to_sock(struct connection *con)
 
 		ret = 0;
 		if (len) {
-			ret = sendpage(con->sock, e->page, offset, len,
-				       msg_flags);
+			ret = kernel_sendpage(con->sock, e->page, offset, len,
+					      msg_flags);
 			if (ret == -EAGAIN || ret == 0) {
 				cond_resched();
 				goto out;
-- 
1.5.5.6

