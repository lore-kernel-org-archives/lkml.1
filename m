Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbXIBTpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbXIBTpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbXIBTo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:44:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58718 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXIBTo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:44:56 -0400
Date: Sun, 2 Sep 2007 21:44:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tong Li <tong.n.li@intel.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Simple Really Fair Scheduler
Message-ID: <20070902194447.GA30724@elte.hu>
References: <20070902120154.GA23769@elte.hu> <Pine.LNX.4.64.0709021106230.30970@tongli.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709021106230.30970@tongli.jf.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Tong Li <tong.n.li@intel.com> wrote:

> I like this patch since it's really simple. CFS does provide a nice 
> infrastructure to enable new algorithmic changes/extensions. My only 
> concern was the O(log N) complexity under heavy load, but I'm willing 
> to agree that it's OK in the common case. [...]

yeah. Note that just in case i wasnt clear enough: my patch attempts to 
be an adoption of the core fairness math algorithm Roman suggested - so 
it is not my idea and i dont want to take credit for it. (if it were to 
go upstream it would of course carry a prominent "fairness math 
rewritten by Roman Zippel" credit.)

about O(log N) complexity: the "timeline" nature of the CFS rbtree 
(which rbtree Roman's patch preserves) guarantees a certain good level 
of cache locality. We generally insert tasks at the "right side" of the 
tree and remove them from the "left side" of the tree. (not always of 
course, but for most workloads) So in practice, on a reasonable CPU, 
there's no difference to the cachemiss patterns of pure O(1) algorithms. 
And in terms of cycle overhead, lets consider something really extreme: 
_one million runnable tasks on a single CPU_ (which is clearly silly and 
unrealistic), which has a worst-case rbtree depth of ~31. A modern CPU 
can walk a 31-deep binary tree in the neighborhood of 100 cycles 
(cached). That makes it comparable to the O(1) scheduler's reliance on 
the BSF instruction on x86 (which instruction costs a few dozen cycles 
last i remember). In practice O(log(N)) algorithms are really equivalent 
to O(1) algorithms. The big thing about the "O(1) scheduler" was that 
the scheduler it replaced was O(N). Now an O(N) algorithm _does_ hurt.

No doubt, people _will_ play with CFS and will try to implement its 
timeline data structure using O(1) algorithms (or improved tree 
algorithms). It's doable and it will certainly be interesting to see the 
results of such experiments. The rbtree was simply the most natural 
choice of an already existing, lightweight in-kernel tree data 
structure. [ It's also used by the MM so continued sanity and 
performance of that code is guaranteed by the MM hackers ;-) ]

> [...] Some comments on the code:

> >+	key = se->exec_runtime;
> >
> >	se->fair_key = key;
> >}
> 
> Should we use the weighted fair clock exec_runtime as the key? This 
> way tasks with larger weights will have their keys incremented more 
> slowly and thus be given more CPU time. This is what other 
> virtual-clock based fair scheduling algorithms commonly do.

yep. The code i posted treats all tasks as nice-0. I suspect by adding a 
calc_weighted() transformation to the key calculation above we'd get 
most of the nice level support. (but i havent tried that yet - i was 
mainly interested in a simple expression of Roman's ideas)

> >+	se->exec_runtime = avg_exec_runtime(cfs_rq);
> >	__enqueue_entity(cfs_rq, se);
> >}
> 
> What's the intuition behind avg_exec_runtime? I thought the original 
> CFS approach, i.e., setting a newly arriving task's key to be the 
> current fair clock, adjusted by wait_runtime, was good. It matches 
> other fair queuing algorithms and thus has provably good properties.

it's i think what Roman's algorithm does, and i wanted to implement that 
and only that, to be able to review the effects of a much simpler, yet 
behaviorally equivalent patch. Perhaps Roman can shed some light on what 
the thinking behind that average is.

	Ingo
