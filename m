Return-Path: <linux-kernel-owner+w=401wt.eu-S1765914AbYBTPc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765914AbYBTPc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932351AbYBTP2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:28:23 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:35879 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932324AbYBTP2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:28:14 -0500
X-SourceIP: 80.56.237.116
Message-Id: <20080220150307.640565000@chello.nl>
References: <20080220144610.548202000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 20 Feb 2008 15:46:28 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 18/28] netvm: filter emergency skbs.
Content-Disposition: inline; filename=netvm-sk_filter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
@@ -998,6 +998,9 @@ static inline int sk_filter(struct sock 
 {
 	int err;
 	struct sk_filter *filter;
+
+	if (skb_emergency(skb) && !sk_has_memalloc(sk))
+		return -ENOMEM;
 	
 	err = security_sock_rcv_skb(sk, skb);
 	if (err)

--

