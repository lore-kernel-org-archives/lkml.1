Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbXJ3QUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbXJ3QUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbXJ3QOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:14:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121AbXJ3QOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:14:15 -0400
Message-Id: <20071030160914.329519000@chello.nl>
References: <20071030160401.296770000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 30 Oct 2007 17:04:21 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 20/33] netvm: filter emergency skbs.
Content-Disposition: inline; filename=netvm-sk_filter.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Toss all emergency packets not for a SOCK_MEMALLOC socket. This ensures our
precious memory reserve doesn't get stuck waiting for user-space.

The correctness of this approach relies on the fact that networks must be
assumed lossy.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/net/sock.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/include/net/sock.h
===================================================================
--- linux-2.6.orig/include/net/sock.h
+++ linux-2.6/include/net/sock.h
@@ -930,6 +930,9 @@ static inline int sk_filter(struct sock 
 {
 	int err;
 	struct sk_filter *filter;
+
+	if (skb_emergency(skb) && !sk_has_memalloc(sk))
+		return -ENOMEM;
 	
 	err = security_sock_rcv_skb(sk, skb);
 	if (err)

--

