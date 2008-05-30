Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbYE3EOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbYE3EOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbYE3EBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40522 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752649AbYE3EAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:21 -0400
Message-Id: <20080530040018.552701121@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:42 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 22/41] cpu alloc: Convert network sockets inuse counter
Content-Disposition: inline; filename=cpu_alloc_network_sockets_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert handling of the inuse counters to cpu alloc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 net/core/sock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/net/core/sock.c
===================================================================
--- linux-2.6.orig/net/core/sock.c	2008-05-14 19:40:34.000000000 -0700
+++ linux-2.6/net/core/sock.c	2008-05-21 22:00:56.000000000 -0700
@@ -1943,8 +1943,7 @@
 #ifdef CONFIG_NET_NS
 void sock_prot_inuse_add(struct net *net, struct proto *prot, int val)
 {
-	int cpu = smp_processor_id();
-	per_cpu_ptr(net->core.inuse, cpu)->val[prot->inuse_idx] += val;
+	__CPU_ADD(net->core.inuse->val[prot->inuse_idx], val);
 }
 EXPORT_SYMBOL_GPL(sock_prot_inuse_add);
 
@@ -1954,7 +1953,7 @@
 	int res = 0;
 
 	for_each_possible_cpu(cpu)
-		res += per_cpu_ptr(net->core.inuse, cpu)->val[idx];
+		res += CPU_PTR(net->core.inuse, cpu)->val[idx];
 
 	return res >= 0 ? res : 0;
 }
@@ -1962,13 +1961,13 @@
 
 static int sock_inuse_init_net(struct net *net)
 {
-	net->core.inuse = alloc_percpu(struct prot_inuse);
+	net->core.inuse = CPU_ALLOC(struct prot_inuse, GFP_KERNEL|__GFP_ZERO);
 	return net->core.inuse ? 0 : -ENOMEM;
 }
 
 static void sock_inuse_exit_net(struct net *net)
 {
-	free_percpu(net->core.inuse);
+	CPU_FREE(net->core.inuse);
 }
 
 static struct pernet_operations net_inuse_ops = {

-- 
