Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbZE2I7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbZE2I7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbZE2I71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:59:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47743 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433AbZE2I7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:59:25 -0400
Date: Fri, 29 May 2009 10:59:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] perf_counter: Don't swap contexts containing
	locked mutex
Message-ID: <20090529085916.GA21461@elte.hu>
References: <18975.31580.520676.619896@drongo.ozlabs.ibm.com> <1243584388.23657.156.camel@twins> <1243584793.23657.168.camel@twins> <1243585721.23657.177.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243585721.23657.177.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2009-05-29 at 10:13 +0200, Peter Zijlstra wrote:
> > On Fri, 2009-05-29 at 10:06 +0200, Peter Zijlstra wrote:
> > 
> > > static struct perf_counter_ctx *pin_ctx(struct perf_counter *counter, u64 *old_gen)
> > > {
> > > 	struct perf_counter_context *ctx;
> > > 	unsigned long flags;
> > > 
> > > 	rcu_read_lock();
> > > retry:
> > > 	ctx = rcu_dereference(counter->ctx);
> > > 	spin_lock_irqsave(&ctx->lock, flags);
> > > 	if (ctx != rcu_dereference(counter->ctx))
> > > 		goto retry;
> > > 
> > > 	*old_gen = ctx->generation;
> > > 	ctx->generation = ~0ULL;
> > > 	spin_unlock_irqrestore(&ctx->lock, flags);
> > > 	rcu_read_unlock();
> > > 
> > > 	return ctx;
> > > }
> > > 
> > > static void unpin_ctx(struct perf_counter_ctx *ctx, u64 old_gen)
> > > {
> > > 	unsigned long flags;
> > > 
> > > 	spin_lock_irqsave(&ctx->lock, flags);
> > > 	ctx->generation = old_gen;
> > > 	spin_unlock_irqrestore(&ctx->lock, flags);
> > > }
> > 
> > OK, I think I got this wrong, counter->ctx isn't the problem.
> > task->perf_counter_ctx is.
> > 
> > Still would be nice to write it in the above form. I'll go over the code
> > again to see who else might want it.
> 
> OK, I went over the code, and your patch does indeed cover the few 
> spots we need. It was just my brain going haywire and auditing the 
> wrong pattern.

ok - i'll try this with my 'perf stat make -j' workload that quickly 
locks up on a Nehalem. (bug introduced by the context switch 
optimizations)

	Ingo
