Return-Path: <linux-kernel-owner+w=401wt.eu-S1751320AbXBUPcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbXBUPcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbXBUPcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:32:02 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbXBUPb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:31:59 -0500
Message-Id: <20070221144843.299254000@taijtu.programming.kicks-ass.net>
References: <20070221144304.512721000@taijtu.programming.kicks-ass.net>
User-Agent: quilt/0.46-1
Date: Wed, 21 Feb 2007 15:43:22 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Subject: [PATCH 18/29] netfilter: notify about NF_QUEUE vs emergency skbs
Content-Disposition: inline; filename=emergency-nf_queue.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Emergency skbs should never touch user-space, however NF_QUEUE is fully user
configurable. Notify the user of his mistake and try to continue.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 net/netfilter/core.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6-git/net/netfilter/core.c
===================================================================
--- linux-2.6-git.orig/net/netfilter/core.c	2007-02-14 12:09:07.000000000 +0100
+++ linux-2.6-git/net/netfilter/core.c	2007-02-14 12:09:18.000000000 +0100
@@ -187,6 +187,11 @@ next_hook:
 		kfree_skb(*pskb);
 		ret = -EPERM;
 	} else if ((verdict & NF_VERDICT_MASK)  == NF_QUEUE) {
+		if (unlikely((*pskb)->emergency)) {
+			printk(KERN_ERR "nf_hook: NF_QUEUE encountered for "
+					"emergency skb - skipping rule.\n");
+			goto next_hook;
+		}
 		NFDEBUG("nf_hook: Verdict = QUEUE.\n");
 		if (!nf_queue(*pskb, elem, pf, hook, indev, outdev, okfn,
 			      verdict >> NF_VERDICT_BITS))

-- 

