Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYJBN2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYJBN2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbYJBNUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:20:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:54767 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbYJBNSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:18:48 -0400
Message-Id: <20081002131609.278132620@chello.nl>
References: <20081002130504.927878499@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 02 Oct 2008 15:05:26 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Neil Brown <neilb@suse.de>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 22/32] netvm: filter emergency skbs.
Content-Disposition: inline; filename=netvm-sk_filter.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toss all emergency packets not for a SOCK_MEMALLOC socket. This ensures our
precious memory reserve doesn't get stuck waiting for user-space.

The correctness of this approach relies on the fact that networks must be
assumed lossy.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 net/core/filter.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/net/core/filter.c
===================================================================
--- linux-2.6.orig/net/core/filter.c
+++ linux-2.6/net/core/filter.c
@@ -81,6 +81,9 @@ int sk_filter(struct sock *sk, struct sk
 	int err;
 	struct sk_filter *filter;
 
+	if (skb_emergency(skb) && !sk_has_memalloc(sk))
+		return -ENOMEM;
+
 	err = security_sock_rcv_skb(sk, skb);
 	if (err)
 		return err;

-- 

