Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbYCaJso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbYCaJso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYCaJsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:48:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbYCaJsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:48:37 -0400
Date: Mon, 31 Mar 2008 11:48:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC,PATCH] loopback: calls netif_receive_skb() instead of
	netif_rx()
Message-ID: <20080331094823.GA11651@elte.hu>
References: <47BDC848.50607@cosmosbay.com> <20080226.182120.183405235.davem@davemloft.net> <47C92F49.4070100@cosmosbay.com> <20080323.032949.194309002.davem@davemloft.net> <47E6A5FD.6060407@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E6A5FD.6060407@cosmosbay.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> I noticed some paths in kernel are very stack aggressive, and on i386 
> with CONFIG_4KSTACKS we were really in a dangerous land, even without 
> my patch.
>
> What we call 4K stacks is in fact 4K - sizeof(struct task_struct), so 
> a litle bit more than 2K. [...]

that's just wrong - 4K stacks on x86 are 4K-sizeof(thread_info) - the 
task struct is allocated elsewhere. The patch below runs just fine on 
4K-stack x86.

	Ingo

------------->
Subject: net: loopback speedup
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Mar 31 11:23:21 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/loopback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/net/loopback.c
===================================================================
--- linux.orig/drivers/net/loopback.c
+++ linux/drivers/net/loopback.c
@@ -158,7 +158,7 @@ static int loopback_xmit(struct sk_buff 
 	lb_stats->bytes += skb->len;
 	lb_stats->packets++;
 
-	netif_rx(skb);
+	netif_receive_skb(skb);
 
 	return 0;
 }
