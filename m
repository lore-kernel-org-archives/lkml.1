Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbYFFO5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbYFFO5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbYFFO5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:57:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59413 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127AbYFFO5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:57:37 -0400
Date: Fri, 6 Jun 2008 16:57:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-ID: <20080606145717.GA5300@elte.hu>
References: <20080606002957.6329a0ec.akpm@linux-foundation.org> <20080606024811.70db9ab2.akpm@linux-foundation.org> <20080606035413.37f340ef.akpm@linux-foundation.org> <20080606115759.GA29321@elte.hu> <19f34abd0806060533x6d3ff66tc29306143103fc40@mail.gmail.com> <48493CBD.1000202@sgi.com> <19f34abd0806060650q203bef48rd3b20c0cabec4774@mail.gmail.com> <19f34abd0806060707x7570c835u4b1837b54dfa36ba@mail.gmail.com> <484947A9.5050804@sgi.com> <19f34abd0806060736m10424455kfbc3e6272d18646e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806060736m10424455kfbc3e6272d18646e@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> > Thanks, yes I had that some after thought.  It should check the node 
> > index if CONFIG_DEBUG_PER_CPU_MAPS is enabled.  One gotcha is that 
> > nr_node_ids is intialized to MAX_NUMNODES until 
> > setup_node_to_cpumask_map() sets it to the correct value.  So uses 
> > before that should be caught by the earlier check.
> 
> I think it should always check the node index. The code in 
> kernel/sched.c (see above) calls node_to_cpumask(i) on nodes 0 < i < 
> MAX_NUMNODES and it WILL use invalid pointers. Or should 
> kernel/sched.c be changed to use nr_node_ids instead of MAX_NUMNODES? 
> I believe there are more places that do this than just sched.c.
> 
> I have attached two patches. The sched one fixes Andrew's boot 
> problem. The x86 one is untested, but I believe it is better to BUG 
> than silently corrupt some arbitrary memory. (Then the callers can be 
> found easily and fixed at least.)

nice fixes! I have applied both of them to -tip, this one to 
tip/sched-devel:

> Subject: [PATCH] sched: don't call node_to_cpumask() on nodes > nr_node_ids

AFAICS this is not yet required for v2.6.26, as the requirement to never 
iterate to MAX_NUMNODES and call nr_cpus_node() with the index only got 
introduced by Mike's patch.

and this one to tip/x86/numa:

> Subject: [PATCH] x86: don't return invalid pointers from node_to_cpumask()

and i've undone the revert of "x86: remove the static 256k 
node_to_cpumask_map" as well.

agreed?

	Ingo
