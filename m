Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbYKPEij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbYKPEij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbYKPEh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:37:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64853 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbYKPEhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:37:24 -0500
Message-ID: <491FA2BC.1030600@cn.fujitsu.com>
Date: Sun, 16 Nov 2008 12:34:04 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] net: use simple_free()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


simple_free() free the memory by kfree(), or vfree() if it is vmalloc addr.
simple_free() is simpler than current codes.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/net/core/request_sock.c b/net/core/request_sock.c
index 7552495..53fd8a7 100644
--- a/net/core/request_sock.c
+++ b/net/core/request_sock.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
+#include <linux/mm.h>
 
 #include <net/request_sock.h>
 
@@ -71,22 +72,11 @@ int reqsk_queue_alloc(struct request_sock_queue *queue,
 
 void __reqsk_queue_destroy(struct request_sock_queue *queue)
 {
-	struct listen_sock *lopt;
-	size_t lopt_size;
-
 	/*
 	 * this is an error recovery path only
 	 * no locking needed and the lopt is not NULL
 	 */
-
-	lopt = queue->listen_opt;
-	lopt_size = sizeof(struct listen_sock) +
-		lopt->nr_table_entries * sizeof(struct request_sock *);
-
-	if (lopt_size > PAGE_SIZE)
-		vfree(lopt);
-	else
-		kfree(lopt);
+	simple_free(queue->listen_opt);
 }
 
 static inline struct listen_sock *reqsk_queue_yank_listen_sk(
@@ -106,8 +96,6 @@ void reqsk_queue_destroy(struct request_sock_queue *queue)
 {
 	/* make all the listen_opt local to us */
 	struct listen_sock *lopt = reqsk_queue_yank_listen_sk(queue);
-	size_t lopt_size = sizeof(struct listen_sock) +
-		lopt->nr_table_entries * sizeof(struct request_sock *);
 
 	if (lopt->qlen != 0) {
 		unsigned int i;
@@ -124,9 +112,6 @@ void reqsk_queue_destroy(struct request_sock_queue *queue)
 	}
 
 	WARN_ON(lopt->qlen != 0);
-	if (lopt_size > PAGE_SIZE)
-		vfree(lopt);
-	else
-		kfree(lopt);
+	simple_free(lopt);
 }
 


