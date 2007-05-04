Return-Path: <linux-kernel-owner+w=401wt.eu-S1767814AbXEDKjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767814AbXEDKjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 06:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767846AbXEDKjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 06:39:09 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:3563 "EHLO
	amsfep14-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1767825AbXEDKjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 06:39:00 -0400
Message-Id: <20070504103159.868846185@chello.nl>
References: <20070504102651.923946304@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 04 May 2007 12:27:10 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Patrick McHardy <kaber@trash.net>
Subject: [PATCH 19/40] netfilter: notify about NF_QUEUE vs emergency skbs
Content-Disposition: inline; filename=emergency-nf_queue.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid memory getting stuck waiting for userspace, drop all emergency packets.
This of course requires the regular storage route to not include an NF_QUEUE
target ;-)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/core.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6-git/net/netfilter/core.c
===================================================================
--- linux-2.6-git.orig/net/netfilter/core.c	2007-02-22 15:48:28.000000000 +0100
+++ linux-2.6-git/net/netfilter/core.c	2007-02-26 14:23:25.000000000 +0100
@@ -184,9 +184,12 @@ next_hook:
 		ret = 1;
 		goto unlock;
 	} else if (verdict == NF_DROP) {
+drop:
 		kfree_skb(*pskb);
 		ret = -EPERM;
 	} else if ((verdict & NF_VERDICT_MASK)  == NF_QUEUE) {
+		if (skb_emergency(*pskb))
+			goto drop;
 		NFDEBUG("nf_hook: Verdict = QUEUE.\n");
 		if (!nf_queue(*pskb, elem, pf, hook, indev, outdev, okfn,
 			      verdict >> NF_VERDICT_BITS))

--

