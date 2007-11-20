Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbXKTBWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbXKTBWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbXKTBOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:03 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49862 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755713AbXKTBNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:38 -0500
Message-Id: <20071120011338.331890229@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:00 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 28/45] cpu_alloc: convert network sockets
Content-Disposition: inline; filename=0036-cpu_alloc-convert-network-sockets.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 net/core/sock.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/net/core/sock.c
===================================================================
--- linux-2.6.orig/net/core/sock.c	2007-11-18 14:38:23.290283038 -0800
+++ linux-2.6/net/core/sock.c	2007-11-18 22:04:47.561605283 -0800
@@ -1809,21 +1809,21 @@ static LIST_HEAD(proto_list);
  */
 static void inuse_add(struct proto *prot, int inc)
 {
-	per_cpu_ptr(prot->inuse_ptr, smp_processor_id())[0] += inc;
+	__CPU_ADD(prot->inuse_ptr[0], inc);
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
