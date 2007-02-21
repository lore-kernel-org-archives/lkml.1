Return-Path: <linux-kernel-owner+w=401wt.eu-S1751304AbXBUPb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbXBUPb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXBUPb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:31:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbXBUPb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:31:27 -0500
Message-Id: <20070221144843.132373000@taijtu.programming.kicks-ass.net>
References: <20070221144304.512721000@taijtu.programming.kicks-ass.net>
User-Agent: quilt/0.46-1
Date: Wed, 21 Feb 2007 15:43:20 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Subject: [PATCH 16/29] netvm: filter emergency skbs.
Content-Disposition: inline; filename=netvm-sk_filter.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Toss all emergency packets not for a SOCK_VMIO socket. This ensures our
precious memory reserve doesn't get stuck waiting for user-space.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/net/sock.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6-git/include/net/sock.h
===================================================================
--- linux-2.6-git.orig/include/net/sock.h	2007-02-14 16:15:49.000000000 +0100
+++ linux-2.6-git/include/net/sock.h	2007-02-14 16:16:27.000000000 +0100
@@ -926,6 +926,9 @@ static inline int sk_filter(struct sock 
 {
 	int err;
 	struct sk_filter *filter;
+
+	if (skb_emergency(skb) && !sk_has_vmio(sk))
+		return -EPERM;
 	
 	err = security_sock_rcv_skb(sk, skb);
 	if (err)

-- 

