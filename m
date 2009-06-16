Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbZFPJ0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbZFPJ0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZFPJ0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:26:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51788 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbZFPJ0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:26:40 -0400
Date: Tue, 16 Jun 2009 11:26:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20090616092635.GB4184@elte.hu>
References: <20090615.050449.144947903.davem@davemloft.net> <20090616091538.GA4184@elte.hu> <20090616.022131.267374816.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616.022131.267374816.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 16 Jun 2009 11:15:38 +0200
> 
> > BUG: sleeping function called from invalid context at net/core/sock.c:1851
> 
> This line in my tree (and Linus's) reads:
> 
> 	if (sk->sk_lock.owned)
> 
> what gives? :-)

hmmm - i have to declare the small kmemcheck annotation attached 
below :-)

(kmemcheck is off in the config so it shouldnt matter)

So the line is:

        might_sleep();

Lemme dig.

	Ingo

diff --git a/net/core/sock.c b/net/core/sock.c
index 06e26b7..b0ba569 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -945,6 +945,8 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
 		sk = kmalloc(prot->obj_size, priority);
 
 	if (sk != NULL) {
+		kmemcheck_annotate_bitfield(sk, flags);
+
 		if (security_sk_alloc(sk, family, priority))
 			goto out_free;
 
