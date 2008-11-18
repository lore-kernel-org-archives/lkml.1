Return-Path: <linux-kernel-owner+w=401wt.eu-S1752486AbYKQNZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbYKQNZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYKQNZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:25:11 -0500
Received: from ozlabs.org ([203.10.76.45]:39397 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbYKQNZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:25:10 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon Nov 17 23:47:44 CST 2008
CC: akpm@linux-foundation.org
Subject: [PATCH 1/3] Clean up alloc_percpu: make ip_rt_acct a normal percpu var
Cc: Christoph Lameter <cl@linux-foundation.org>
Message-Id: <20081117132509.361BEDDD0B@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There's no reason for this to be dynamically allocated: we panic if
allocation fails anyway.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/net/route.h |    3 ++-
 net/ipv4/ip_input.c |    2 +-
 net/ipv4/route.c    |   10 ++--------
 3 files changed, 5 insertions(+), 10 deletions(-)

diff -r 643c2cdfdb62 include/net/route.h
--- a/include/net/route.h	Mon Nov 17 19:57:42 2008 +1030
+++ b/include/net/route.h	Mon Nov 17 20:23:37 2008 +1030
@@ -34,6 +34,7 @@
 #include <linux/ip.h>
 #include <linux/cache.h>
 #include <linux/security.h>
+#include <linux/percpu.h>
 
 #ifndef __KERNEL__
 #warning This file is not supposed to be used outside of kernel.
@@ -105,7 +106,7 @@
         unsigned int out_hlist_search;
 };
 
-extern struct ip_rt_acct *ip_rt_acct;
+DECLARE_PER_CPU(struct ip_rt_acct[256], ip_rt_acct);
 
 struct in_device;
 extern int		ip_rt_init(void);
diff -r 643c2cdfdb62 net/ipv4/ip_input.c
--- a/net/ipv4/ip_input.c	Mon Nov 17 19:57:42 2008 +1030
+++ b/net/ipv4/ip_input.c	Mon Nov 17 20:23:37 2008 +1030
@@ -339,7 +339,7 @@
 
 #ifdef CONFIG_NET_CLS_ROUTE
 	if (unlikely(skb->dst->tclassid)) {
-		struct ip_rt_acct *st = per_cpu_ptr(ip_rt_acct, smp_processor_id());
+		struct ip_rt_acct *st = __get_cpu_var(ip_rt_acct);
 		u32 idx = skb->dst->tclassid;
 		st[idx&0xFF].o_packets++;
 		st[idx&0xFF].o_bytes+=skb->len;
diff -r 643c2cdfdb62 net/ipv4/route.c
--- a/net/ipv4/route.c	Mon Nov 17 19:57:42 2008 +1030
+++ b/net/ipv4/route.c	Mon Nov 17 20:23:37 2008 +1030
@@ -541,7 +541,7 @@
 			unsigned int j;
 			u32 *src;
 
-			src = ((u32 *) per_cpu_ptr(ip_rt_acct, i)) + offset;
+			src = ((u32 *)per_cpu(ip_rt_acct, i)) + offset;
 			for (j = 0; j < length/4; j++)
 				dst[j] += src[j];
 		}
@@ -3237,7 +3237,7 @@
 
 
 #ifdef CONFIG_NET_CLS_ROUTE
-struct ip_rt_acct *ip_rt_acct __read_mostly;
+DEFINE_PER_CPU(struct ip_rt_acct[256], ip_rt_acct);
 #endif /* CONFIG_NET_CLS_ROUTE */
 
 static __initdata unsigned long rhash_entries;
@@ -3253,12 +3253,6 @@
 int __init ip_rt_init(void)
 {
 	int rc = 0;
-
-#ifdef CONFIG_NET_CLS_ROUTE
-	ip_rt_acct = __alloc_percpu(256 * sizeof(struct ip_rt_acct));
-	if (!ip_rt_acct)
-		panic("IP: failed to allocate ip_rt_acct\n");
-#endif
 
 	ipv4_dst_ops.kmem_cachep =
 		kmem_cache_create("ip_dst_cache", sizeof(struct rtable), 0,

