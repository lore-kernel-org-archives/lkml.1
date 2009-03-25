Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbZCYHe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbZCYHe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 03:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZCYHeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 03:34:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39914 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbZCYHeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 03:34:17 -0400
Date: Wed, 25 Mar 2009 08:33:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090325073349.GF25833@elte.hu>
References: <20090324150928.GB30224@gondor.apana.org.au> <20090324.143622.186562202.davem@davemloft.net> <20090325002303.GA2219@gondor.apana.org.au> <20090324.191134.05205089.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324.191134.05205089.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* David Miller <davem@davemloft.net> wrote:

> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Wed, 25 Mar 2009 08:23:03 +0800
> 
> > On Tue, Mar 24, 2009 at 02:36:22PM -0700, David Miller wrote:
> > >
> > > I think the problem is that we need to do the GRO flush before the
> > > list delete and clearing the NAPI_STATE_SCHED bit.
> > 
> > Well first of all GRO shouldn't even be on in Ingo's case, unless
> > he enabled it by hand with ethtool.  Secondly the only thing that
> > touches the GRO state for the legacy path is process_backlog, and
> > since this is per-cpu, I can't see how another instance can run
> > while the first is still going.
> 
> Right.
> 
> I think the conditions Ingo is running under is that both loopback 
> (using legacy paths) and his NAPI based device (forcedeth) are 
> processing a lot of packets at the same time.
> 
> Another thing that seems to be critical is he can only trigger 
> this on UP, which means that we don't have the damn APIC 
> potentially moving the cpu target of the forcedeth interrupts 
> around.  And this means also that all the processing will be on 
> one cpu's backlog queue only.

I tested the plain revert i sent in the original report overnight 
(with about 12 hours of combined testing time), and all systems held 
up fine. The system that would reproduce the bug within 10-20 
iterations did 210 successful iterations. Other systems held up fine 
too.

So if there's no definitive resolution for the real cause of the 
bug, the plain revert looks like an acceptable interim choice for 
.29.1 - at least as far as my systems go.

	Ingo
