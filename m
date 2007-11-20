Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbXKTBUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbXKTBUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbXKTBN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:56 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49854 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754574AbXKTBNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:37 -0500
Message-Id: <20071120011336.678230087@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:53 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 21/45] cpu alloc: tcp statistics
Content-Disposition: inline; filename=0029-cpu-alloc-tcp-statistics.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 net/ipv4/tcp.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/net/ipv4/tcp.c
===================================================================
--- linux-2.6.orig/net/ipv4/tcp.c	2007-11-15 21:17:24.267654551 -0800
+++ linux-2.6/net/ipv4/tcp.c	2007-11-15 21:25:34.214404334 -0800
@@ -2273,7 +2273,7 @@ static void __tcp_free_md5sig_pool(struc
 {
 	int cpu;
 	for_each_possible_cpu(cpu) {
-		struct tcp_md5sig_pool *p = *per_cpu_ptr(pool, cpu);
+		struct tcp_md5sig_pool *p = *CPU_PTR(pool, cpu);
 		if (p) {
 			if (p->md5_desc.tfm)
 				crypto_free_hash(p->md5_desc.tfm);
@@ -2281,7 +2281,7 @@ static void __tcp_free_md5sig_pool(struc
 			p = NULL;
 		}
 	}
-	free_percpu(pool);
+	CPU_FREE(pool);
 }
 
 void tcp_free_md5sig_pool(void)
@@ -2305,7 +2305,7 @@ static struct tcp_md5sig_pool **__tcp_al
 	int cpu;
 	struct tcp_md5sig_pool **pool;
 
-	pool = alloc_percpu(struct tcp_md5sig_pool *);
+	pool = CPU_ALLOC(struct tcp_md5sig_pool *, GFP_KERNEL);
 	if (!pool)
 		return NULL;
 
@@ -2316,7 +2316,7 @@ static struct tcp_md5sig_pool **__tcp_al
 		p = kzalloc(sizeof(*p), GFP_KERNEL);
 		if (!p)
 			goto out_free;
-		*per_cpu_ptr(pool, cpu) = p;
+		*CPU_PTR(pool, cpu) = p;
 
 		hash = crypto_alloc_hash("md5", 0, CRYPTO_ALG_ASYNC);
 		if (!hash || IS_ERR(hash))
@@ -2381,7 +2381,7 @@ struct tcp_md5sig_pool *__tcp_get_md5sig
 	if (p)
 		tcp_md5sig_users++;
 	spin_unlock_bh(&tcp_md5sig_pool_lock);
-	return (p ? *per_cpu_ptr(p, cpu) : NULL);
+	return (p ? *CPU_PTR(p, cpu) : NULL);
 }
 
 EXPORT_SYMBOL(__tcp_get_md5sig_pool);

-- 
