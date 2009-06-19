Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZFSMYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZFSMYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 08:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZFSMYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 08:24:38 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:53612 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbZFSMYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 08:24:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19003.33663.47733.451895@cargo.ozlabs.ibm.com>
Date: Fri, 19 Jun 2009 22:24:31 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: Simplify and fix task
 migration counting
In-Reply-To: <1245412779.19816.5.camel@twins>
References: <new-submission>
	<tip-e5289d4a181fb6c0b7a7607649af2ffdc491335c@git.kernel.org>
	<1245412779.19816.5.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> static struct perf_counter_context *perf_pin_task_context(struct task_struct *task)
> {
> 	struct perf_counter_context *ctx;
> 	unsigned long flags;
> 
> 	ctx = perf_lock_task_context(task, &flags);
> 	if (ctx) {
> 		++ctx->pin_count;
> 		get_ctx(ctx);
> 		spin_unlock_irqrestore(&ctx->lock, flags);
> 	}
> 	return ctx;
> }
> 
> Is buggy because perf_lock_task_context() can return a dead context.
> 
> the RCU read lock in perf_lock_task_context() only guarantees the memory
> won't get freed, it doesn't guarantee the object is valid (in our case
> refcount > 0).
> 
> Therefore we can return a locked object that can get freed the moment we
> release the rcu read lock.
> 
> perf_pin_task_context() then increases the refcount and does an unlock
> on freed memory.
> 
> That increased refcount will cause a double free, in case it started out
> with 0.

Wow, good catch!  Thanks for finding that.

Paul.
