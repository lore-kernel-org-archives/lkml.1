Return-Path: <linux-kernel-owner+w=401wt.eu-S966203AbXEIGao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966203AbXEIGao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 02:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969032AbXEIGaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 02:30:19 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:11947 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S968649AbXEIGaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 02:30:17 -0400
Subject: [PATCH] sunrpc: fix crash in rpc_malloc()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 09 May 2007 08:30:11 +0200
Message-Id: <1178692212.6810.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


While the comment says:
 * To prevent rpciod from hanging, this allocator never sleeps,
 * returning NULL if the request cannot be serviced immediately.

The function does not actually check for NULL pointers being returned.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 net/sunrpc/sched.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6-git/net/sunrpc/sched.c
===================================================================
--- linux-2.6-git.orig/net/sunrpc/sched.c
+++ linux-2.6-git/net/sunrpc/sched.c
@@ -762,6 +762,10 @@ void *rpc_malloc(struct rpc_task *task, 
 		buf = mempool_alloc(rpc_buffer_mempool, gfp);
 	else
 		buf = kmalloc(size, gfp);
+
+	if (!buf)
+		return NULL;
+
 	*buf = size;
 	dprintk("RPC: %5u allocated buffer of size %zu at %p\n",
 			task->tk_pid, size, buf);


