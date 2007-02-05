Return-Path: <linux-kernel-owner+w=401wt.eu-S932959AbXBEOmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbXBEOmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932952AbXBEOmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:42:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932968AbXBEOmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:42:10 -0500
Subject: [DLM] fix softlockup in dlm_recv [54/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Patrick Caulfield <pcaulfie@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:50:13 +0000
Message-Id: <1170687013.11001.379.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From aee6c8244dea3199ff3d17fc3167660ea95299ec Mon Sep 17 00:00:00 2001
From: Patrick Caulfield <pcaulfie@redhat.com>
Date: Thu, 1 Feb 2007 16:46:33 +0000
Subject: [PATCH] [DLM] fix softlockup in dlm_recv

This patch stops the dlm_recv workqueue from busy-waiting when a node
disconnects. This can cause soft lockup errors on debug systems and bad
performance generally.

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms-tcp.c b/fs/dlm/lowcomms-tcp.c
index 18ade44..f1efd17 100644
--- a/fs/dlm/lowcomms-tcp.c
+++ b/fs/dlm/lowcomms-tcp.c
@@ -2,7 +2,7 @@
 *******************************************************************************
 **
 **  Copyright (C) Sistina Software, Inc.  1997-2003  All rights reserved.
-**  Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+**  Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
 **
 **  This copyrighted material is made available to anyone wishing to use,
 **  modify, copy, or redistribute it subject to the terms and conditions
@@ -109,7 +109,6 @@ struct connection {
 	struct page *rx_page;
 	struct cbuf cb;
 	int retries;
-	atomic_t waiting_requests;
 #define MAX_CONNECT_RETRIES 3
 	struct connection *othercon;
 	struct work_struct rwork; /* Receive workqueue */
@@ -278,8 +277,11 @@ static int receive_from_sock(struct connection *con)
 
 	mutex_lock(&con->sock_mutex);
 
-	if (con->sock == NULL)
-		goto out;
+	if (con->sock == NULL) {
+		ret = -EAGAIN;
+		goto out_close;
+	}
+
 	if (con->rx_page == NULL) {
 		/*
 		 * This doesn't need to be atomic, but I think it should
@@ -352,7 +354,6 @@ static int receive_from_sock(struct connection *con)
 		con->rx_page = NULL;
 	}
 
-out:
 	if (call_again_soon)
 		goto out_resched;
 	mutex_unlock(&con->sock_mutex);
@@ -370,6 +371,9 @@ out_close:
 		close_connection(con, false);
 		/* Reconnect when there is something to send */
 	}
+	/* Don't return success if we really got EOF */
+	if (ret == 0)
+		ret = -EAGAIN;
 
 	return ret;
 }
@@ -847,7 +851,6 @@ int dlm_lowcomms_close(int nodeid)
 	if (con) {
 		clean_one_writequeue(con);
 		close_connection(con, true);
-		atomic_set(&con->waiting_requests, 0);
 	}
 	return 0;
 
-- 
1.4.4.2



