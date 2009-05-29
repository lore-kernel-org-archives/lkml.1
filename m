Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbZE2INW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbZE2INW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbZE2INN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:13:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbZE2INM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:13:12 -0400
Subject: Re: [PATCH RFC] perf_counter: Don't swap contexts containing
 locked mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1243584388.23657.156.camel@twins>
References: <18975.31580.520676.619896@drongo.ozlabs.ibm.com>
	 <1243584388.23657.156.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 29 May 2009 10:13:13 +0200
Message-Id: <1243584793.23657.168.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 10:06 +0200, Peter Zijlstra wrote:

> static struct perf_counter_ctx *pin_ctx(struct perf_counter *counter, u64 *old_gen)
> {
> 	struct perf_counter_context *ctx;
> 	unsigned long flags;
> 
> 	rcu_read_lock();
> retry:
> 	ctx = rcu_dereference(counter->ctx);
> 	spin_lock_irqsave(&ctx->lock, flags);
> 	if (ctx != rcu_dereference(counter->ctx))
> 		goto retry;
> 
> 	*old_gen = ctx->generation;
> 	ctx->generation = ~0ULL;
> 	spin_unlock_irqrestore(&ctx->lock, flags);
> 	rcu_read_unlock();
> 
> 	return ctx;
> }
> 
> static void unpin_ctx(struct perf_counter_ctx *ctx, u64 old_gen)
> {
> 	unsigned long flags;
> 
> 	spin_lock_irqsave(&ctx->lock, flags);
> 	ctx->generation = old_gen;
> 	spin_unlock_irqrestore(&ctx->lock, flags);
> }

OK, I think I got this wrong, counter->ctx isn't the problem.
task->perf_counter_ctx is.

Still would be nice to write it in the above form. I'll go over the code
again to see who else might want it.
