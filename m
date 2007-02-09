Return-Path: <linux-kernel-owner+w=401wt.eu-S1946653AbXBIQqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946653AbXBIQqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946642AbXBIQjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:39:04 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51680 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946646AbXBIQiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:38:46 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] dlm: use kern_recvmsg()
Cc: linux-kernel@vger.kernel.org, swhiteho@redhat.com
Message-Id: <E1HFYlp-0006mm-M2@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:38:45 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dlm/lowcomms-tcp.c |   23 ++++++-----------------
 1 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/fs/dlm/lowcomms-tcp.c b/fs/dlm/lowcomms-tcp.c
index f1efd17..07e0a12 100644
--- a/fs/dlm/lowcomms-tcp.c
+++ b/fs/dlm/lowcomms-tcp.c
@@ -268,12 +268,12 @@ static void close_connection(struct connection *con, bool and_other)
 static int receive_from_sock(struct connection *con)
 {
 	int ret = 0;
-	struct msghdr msg;
-	struct iovec iov[2];
-	mm_segment_t fs;
+	struct msghdr msg = {};
+	struct kvec iov[2];
 	unsigned len;
 	int r;
 	int call_again_soon = 0;
+	int nvec;
 
 	mutex_lock(&con->sock_mutex);
 
@@ -293,21 +293,13 @@ static int receive_from_sock(struct connection *con)
 		cbuf_init(&con->cb, PAGE_CACHE_SIZE);
 	}
 
-	msg.msg_control = NULL;
-	msg.msg_controllen = 0;
-	msg.msg_iovlen = 1;
-	msg.msg_iov = iov;
-	msg.msg_name = NULL;
-	msg.msg_namelen = 0;
-	msg.msg_flags = 0;
-
 	/*
 	 * iov[0] is the bit of the circular buffer between the current end
 	 * point (cb.base + cb.len) and the end of the buffer.
 	 */
 	iov[0].iov_len = con->cb.base - cbuf_data(&con->cb);
 	iov[0].iov_base = page_address(con->rx_page) + cbuf_data(&con->cb);
-	iov[1].iov_len = 0;
+	nvec = 1;
 
 	/*
 	 * iov[1] is the bit of the circular buffer between the start of the
@@ -317,15 +309,12 @@ static int receive_from_sock(struct connection *con)
 		iov[0].iov_len = PAGE_CACHE_SIZE - cbuf_data(&con->cb);
 		iov[1].iov_len = con->cb.base;
 		iov[1].iov_base = page_address(con->rx_page);
-		msg.msg_iovlen = 2;
+		nvec = 2;
 	}
 	len = iov[0].iov_len + iov[1].iov_len;
 
-	fs = get_fs();
-	set_fs(get_ds());
-	r = ret = sock_recvmsg(con->sock, &msg, len,
+	r = ret = kernel_recvmsg(con->sock, &msg, iov, nvec, len,
 			       MSG_DONTWAIT | MSG_NOSIGNAL);
-	set_fs(fs);
 
 	if (ret <= 0)
 		goto out_close;
-- 
1.5.0-rc2.GIT


