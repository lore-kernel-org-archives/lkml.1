Return-Path: <linux-kernel-owner+w=401wt.eu-S1759767AbYE3EPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767AbYE3EPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756855AbYE3EBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:41 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56599 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751958AbYE3EAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:18 -0400
Message-Id: <20080530040015.127667113@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:35 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 15/41] cpu_alloc: Convert ip route statistics
Content-Disposition: inline; filename=cpu_alloc_ip_rt_act_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert IP route stats to cpu alloc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6/net/ipv4/ip_input.c
===================================================================
--- linux-2.6.orig/net/ipv4/ip_input.c	2008-05-21 22:37:24.000000000 -0700
+++ linux-2.6/net/ipv4/ip_input.c	2008-05-21 22:38:39.000000000 -0700
@@ -345,7 +345,7 @@
 
 #ifdef CONFIG_NET_CLS_ROUTE
 	if (unlikely(skb->dst->tclassid)) {
-		struct ip_rt_acct *st = per_cpu_ptr(ip_rt_acct, smp_processor_id());
+		struct ip_rt_acct *st = THIS_CPU(ip_rt_acct);
 		u32 idx = skb->dst->tclassid;
 		st[idx&0xFF].o_packets++;
 		st[idx&0xFF].o_bytes+=skb->len;
Index: linux-2.6/net/ipv4/route.c
===================================================================
--- linux-2.6.orig/net/ipv4/route.c	2008-05-21 22:37:24.000000000 -0700
+++ linux-2.6/net/ipv4/route.c	2008-05-21 22:38:39.000000000 -0700
@@ -534,7 +534,7 @@
 			unsigned int j;
 			u32 *src;
 
-			src = ((u32 *) per_cpu_ptr(ip_rt_acct, i)) + offset;
+			src = ((u32 *) CPU_PTR(ip_rt_acct, i)) + offset;
 			for (j = 0; j < length/4; j++)
 				dst[j] += src[j];
 		}
@@ -3035,7 +3035,8 @@
 			     (jiffies ^ (jiffies >> 7))));
 
 #ifdef CONFIG_NET_CLS_ROUTE
-	ip_rt_acct = __alloc_percpu(256 * sizeof(struct ip_rt_acct));
+	ip_rt_acct = cpu_alloc(256 * sizeof(struct ip_rt_acct),
+		GFP_KERNEL|__GFP_ZERO, __alignof__(struct ip_rt_acct));
 	if (!ip_rt_acct)
 		panic("IP: failed to allocate ip_rt_acct\n");
 #endif

-- 
