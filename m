Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbXKFUAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbXKFUAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 15:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbXKFTwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:35 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52143 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756011AbXKFTwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:02 -0500
Message-Id: <20071106195201.770202420@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:52:02 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 18/28] cpu alloc: tcp statistics
Content-Disposition: inline; filename=cpu_alloc_net_tcp
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>


---
 net/ipv4/tcp.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/net/ipv4/tcp.c
===================================================================
--- linux-2.6.orig/net/ipv4/tcp.c	2007-11-04 19:01:58.000000000 -0800
+++ linux-2.6/net/ipv4/tcp.c	2007-11-04 19:30:19.000000000 -0800
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
