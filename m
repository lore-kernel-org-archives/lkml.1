Return-Path: <linux-kernel-owner+w=401wt.eu-S1752305AbYILHFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbYILHFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 03:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYILHFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 03:05:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:32463 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbYILHFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 03:05:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=YcxUDLcxfU7MXxXZXvtLpKP1UlwjXkV0rgIoooPHoiNZhoxeB+iwICx6adkHKu0e4/
         ICxF1vPw/AwheZr7b9rGB2JY0peduJLh0VVExEoQ2NfsFIAiCIFvZdS4bNePnQV8SA9n
         usBKheRC2ba4jOXtfSvYLfOtRaVJn8OfM5X4c=
Date: Fri, 12 Sep 2008 09:05:25 +0200
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.28] tcp_ipv6: fix use of uninitialized memory
Message-ID: <20080912070525.GA22276@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6544c4074aa5dde2e3f4d3e02f5601c1c33b770e Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 9 Sep 2008 07:17:32 +0200
Subject: [PATCH] tcp_ipv6: fix use of uninitialized memory

inet6_rsk() is called on a struct request_sock * before we
have checked whether the socket is an ipv6 socket or a ipv6-
mapped ipv4 socket. The access that triggers this is the
inet_rsk(rsk)->inet6_rsk_offset dereference in inet6_rsk().

This is arguably not a critical error as the inet6_rsk_offset
is only used to compute a pointer which is never really used
(in the code path in question) anyway. But it might be a
latent error, so let's fix it.

Spotted by kmemcheck.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 net/ipv6/tcp_ipv6.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5b90b36..c9b6c13 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1286,7 +1286,7 @@ static struct sock * tcp_v6_syn_recv_sock(struct sock *sk, struct sk_buff *skb,
 					  struct request_sock *req,
 					  struct dst_entry *dst)
 {
-	struct inet6_request_sock *treq = inet6_rsk(req);
+	struct inet6_request_sock *treq;
 	struct ipv6_pinfo *newnp, *np = inet6_sk(sk);
 	struct tcp6_sock *newtcp6sk;
 	struct inet_sock *newinet;
@@ -1350,6 +1350,7 @@ static struct sock * tcp_v6_syn_recv_sock(struct sock *sk, struct sk_buff *skb,
 		return newsk;
 	}
 
+	treq = inet6_rsk(req);
 	opt = np->opt;
 
 	if (sk_acceptq_is_full(sk))
-- 
1.5.5.1

