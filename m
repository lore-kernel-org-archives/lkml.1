Return-Path: <linux-kernel-owner+w=401wt.eu-S1759645AbXFLHIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbXFLHIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759259AbXFLHG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:06:26 -0400
Received: from brick.kernel.dk ([80.160.20.94]:17205 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759454AbXFLHGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:06:16 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/3] tcp_read_sock: alloc recv_actor() return return negative error value
Date: Tue, 12 Jun 2007 09:03:59 +0200
Message-Id: <11816318403161-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <1181631840469-git-send-email-jens.axboe@oracle.com>
References: <1181631840469-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 net/ipv4/tcp.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cd3c7e9..450f44b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1064,7 +1064,11 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 					break;
 			}
 			used = recv_actor(desc, skb, offset, len);
-			if (used <= len) {
+			if (used < 0) {
+				if (!copied)
+					copied = used;
+				break;
+			} else if (used <= len) {
 				seq += used;
 				copied += used;
 				offset += used;
@@ -1086,7 +1090,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 	tcp_rcv_space_adjust(sk);
 
 	/* Clean up data we have read: This will do ACK frames. */
-	if (copied)
+	if (copied > 0)
 		tcp_cleanup_rbuf(sk, copied);
 	return copied;
 }
-- 
1.5.2.1.174.gcd03

