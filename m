Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbZE2JQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbZE2JQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbZE2JQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:16:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50403 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbZE2JQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:16:16 -0400
Date: Fri, 29 May 2009 11:16:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] perf_counter: Don't swap contexts containing
	locked mutex
Message-ID: <20090529091608.GA15278@elte.hu>
References: <18975.31580.520676.619896@drongo.ozlabs.ibm.com> <1243584388.23657.156.camel@twins> <1243584793.23657.168.camel@twins> <1243585721.23657.177.camel@twins> <20090529085916.GA21461@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529085916.GA21461@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, 2009-05-29 at 10:13 +0200, Peter Zijlstra wrote:
> > > On Fri, 2009-05-29 at 10:06 +0200, Peter Zijlstra wrote:
> > > 
> > > > static struct perf_counter_ctx *pin_ctx(struct perf_counter *counter, u64 *old_gen)
> > > > {
> > > > 	struct perf_counter_context *ctx;
> > > > 	unsigned long flags;
> > > > 
> > > > 	rcu_read_lock();
> > > > retry:
> > > > 	ctx = rcu_dereference(counter->ctx);
> > > > 	spin_lock_irqsave(&ctx->lock, flags);
> > > > 	if (ctx != rcu_dereference(counter->ctx))
> > > > 		goto retry;
> > > > 
> > > > 	*old_gen = ctx->generation;
> > > > 	ctx->generation = ~0ULL;
> > > > 	spin_unlock_irqrestore(&ctx->lock, flags);
> > > > 	rcu_read_unlock();
> > > > 
> > > > 	return ctx;
> > > > }
> > > > 
> > > > static void unpin_ctx(struct perf_counter_ctx *ctx, u64 old_gen)
> > > > {
> > > > 	unsigned long flags;
> > > > 
> > > > 	spin_lock_irqsave(&ctx->lock, flags);
> > > > 	ctx->generation = old_gen;
> > > > 	spin_unlock_irqrestore(&ctx->lock, flags);
> > > > }
> > > 
> > > OK, I think I got this wrong, counter->ctx isn't the problem.
> > > task->perf_counter_ctx is.
> > > 
> > > Still would be nice to write it in the above form. I'll go over the code
> > > again to see who else might want it.
> > 
> > OK, I went over the code, and your patch does indeed cover the few 
> > spots we need. It was just my brain going haywire and auditing the 
> > wrong pattern.
> 
> ok - i'll try this with my 'perf stat make -j' workload that 
> quickly locks up on a Nehalem. (bug introduced by the context 
> switch optimizations)

nope, that still hangs the box.

try the latest Git repo (i tried 95110d7) and do this:

  make clean
  perf stat -- make -j

that locks up for me, very quickly, with permanently stuck tasks:

   PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM   TIME    COMMAND        
 10748 mingo     20   0     0    0    0 R 100.4  0.0   0:06.44 chmod         
 10756 mingo     20   0     0    0    0 R 100.4  0.0   0:06.43 touch         

looping in the remove-context retry loop.

	Ingo
