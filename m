Return-Path: <linux-kernel-owner+w=401wt.eu-S935489AbXKPXXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935489AbXKPXXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935009AbXKPXLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:11:55 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51819 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762650AbXKPXLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:11:09 -0500
Message-Id: <20071116231108.524198543@sgi.com>
References: <20071116230920.278761667@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:09:46 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [patch 26/30] cpu_alloc: convert network sockets
Content-Disposition: inline; filename=0036-cpu_alloc-convert-network-sockets.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 net/core/sock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/net/core/sock.c
===================================================================
--- linux-2.6.orig/net/core/sock.c	2007-11-15 21:17:23.775404482 -0800
+++ linux-2.6/net/core/sock.c	2007-11-15 21:25:38.183201940 -0800
@@ -1809,21 +1809,21 @@ static LIST_HEAD(proto_list);
  */
 static void inuse_add(struct proto *prot, int inc)
 {
-	per_cpu_ptr(prot->inuse_ptr, smp_processor_id())[0] += inc;
+	THIS_CPU(prot->inuse_ptr)[0] += inc;
 }
 
 static int inuse_get(const struct proto *prot)
 {
 	int res = 0, cpu;
 	for_each_possible_cpu(cpu)
-		res += per_cpu_ptr(prot->inuse_ptr, cpu)[0];
+		res += CPU_PTR(prot->inuse_ptr, cpu)[0];
 	return res;
 }
 
 static int inuse_init(struct proto *prot)
 {
 	if (!prot->inuse_getval || !prot->inuse_add) {
-		prot->inuse_ptr = alloc_percpu(int);
+		prot->inuse_ptr = CPU_ALLOC(int, GFP_KERNEL);
 		if (prot->inuse_ptr == NULL)
 			return -ENOBUFS;
 
@@ -1836,7 +1836,7 @@ static int inuse_init(struct proto *prot
 static void inuse_fini(struct proto *prot)
 {
 	if (prot->inuse_ptr != NULL) {
-		free_percpu(prot->inuse_ptr);
+		CPU_FREE(prot->inuse_ptr);
 		prot->inuse_ptr = NULL;
 		prot->inuse_getval = NULL;
 		prot->inuse_add = NULL;

-- 
