Return-Path: <linux-kernel-owner+w=401wt.eu-S932558AbZJAOIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbZJAOIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932519AbZJAOHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:07:15 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:46715 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395AbZJAOHJ (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com;0:0>);
	Thu, 1 Oct 2009 10:07:09 -0400
From: Suresh Jayaraman <sjayaraman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Cc: netdev@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: [PATCH 19/31] netvm: filter emergency skbs.
Date: Thu,  1 Oct 2009 19:38:25 +0530
Message-Id: <1254406105-16336-1-git-send-email-sjayaraman@suse.de>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl> 

Toss all emergency packets not for a SOCK_MEMALLOC socket. This ensures our
precious memory reserve doesn't get stuck waiting for user-space.

The correctness of this approach relies on the fact that networks must be
assumed lossy.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 net/core/filter.c |    3 +++
 1 file changed, 3 insertions(+)

Index: mmotm/net/core/filter.c
===================================================================
--- mmotm.orig/net/core/filter.c
+++ mmotm/net/core/filter.c
@@ -81,6 +81,9 @@ int sk_filter(struct sock *sk, struct sk
 	int err;
 	struct sk_filter *filter;
 
+	if (skb_emergency(skb) && !sk_has_memalloc(sk))
+		return -ENOMEM;
+
 	err = security_sock_rcv_skb(sk, skb);
 	if (err)
 		return err;
