Return-Path: <linux-kernel-owner+w=401wt.eu-S932883AbXBEO1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbXBEO1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932911AbXBEO1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:27:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932883AbXBEO1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:27:19 -0500
Subject: [DLM] lowcomms tidy [33/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Patrick Caulfield <pcaulfie@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:35:20 +0000
Message-Id: <1170686120.11001.337.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From f9e63b1a6a1af856ce6f82710368924386353196 Mon Sep 17 00:00:00 2001
From: Patrick Caulfield <pcaulfie@redhat.com>
Date: Mon, 22 Jan 2007 14:50:10 +0000
Subject: [PATCH] [DLM] lowcomms tidy

This patch removes some redundant fields from the connection structure and adds
some lockdep annotation to remove spurious warnings.

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms-tcp.c b/fs/dlm/lowcomms-tcp.c
index 86e5f81..6e27201 100644
--- a/fs/dlm/lowcomms-tcp.c
+++ b/fs/dlm/lowcomms-tcp.c
@@ -97,9 +97,6 @@ struct connection {
 	struct socket *sock;	/* NULL if not connected */
 	uint32_t nodeid;	/* So we know who we are in the list */
 	struct rw_semaphore sock_sem; /* Stop connect races */
-	struct list_head read_list;   /* On this list when ready for reading */
-	struct list_head write_list;  /* On this list when ready for writing */
-	struct list_head state_list;  /* On this list when ready to connect */
 	unsigned long flags;	/* bit 1,2 = We are on the read/write lists */
 #define CF_READ_PENDING 1
 #define CF_WRITE_PENDING 2
@@ -391,7 +388,7 @@ static int accept_from_sock(struct connection *con)
 	if (result < 0)
 		return -ENOMEM;
 
-	down_read(&con->sock_sem);
+	down_read_nested(&con->sock_sem, 0);
 
 	result = -ENOTCONN;
 	if (con->sock == NULL)
@@ -434,7 +431,7 @@ static int accept_from_sock(struct connection *con)
 		result = -ENOMEM;
 		goto accept_err;
 	}
-	down_write(&newcon->sock_sem);
+	down_write_nested(&newcon->sock_sem, 1);
 	if (newcon->sock) {
 		struct connection *othercon = newcon->othercon;
 
-- 
1.4.4.2



