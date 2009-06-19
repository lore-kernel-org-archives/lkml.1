Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbZFSL7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbZFSL7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 07:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZFSL7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 07:59:39 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:55224 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZFSL7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 07:59:38 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:perfcounters/core] perf_counter: Simplify and fix task
 migration counting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-e5289d4a181fb6c0b7a7607649af2ffdc491335c@git.kernel.org>
References: <new-submission>
	 <tip-e5289d4a181fb6c0b7a7607649af2ffdc491335c@git.kernel.org>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 13:59:39 +0200
Message-Id: <1245412779.19816.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 11:52 +0000, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  e5289d4a181fb6c0b7a7607649af2ffdc491335c
> Gitweb:     http://git.kernel.org/tip/e5289d4a181fb6c0b7a7607649af2ffdc491335c
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Fri, 19 Jun 2009 13:22:51 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 19 Jun 2009 13:43:12 +0200
> 
> perf_counter: Simplify and fix task migration counting
> 
> The task migrations counter was causing rare and hard to decypher
> memory corruptions under load. After a day of debugging and bisection
> we found that the problem was introduced with:
> 
>   3f731ca: perf_counter: Fix cpu migration counter
> 
> Turning them off fixes the crashes. Incidentally, the whole
> perf_counter_task_migration() logic can be done simpler as well,
> by injecting a proper sw-counter event.
> 
> This cleanup also fixed the crashes. The precise failure mode is
> not completely clear yet, but we are clearly not unhappy about
> having a fix ;-)


I actually do know what happens:

static struct perf_counter_context *
perf_lock_task_context(struct task_struct *task, unsigned long *flags)
{
	struct perf_counter_context *ctx;

	rcu_read_lock();
 retry:
	ctx = rcu_dereference(task->perf_counter_ctxp);
	if (ctx) {

		spin_lock_irqsave(&ctx->lock, *flags);
		if (ctx != rcu_dereference(task->perf_counter_ctxp)) {
			spin_unlock_irqrestore(&ctx->lock, *flags);
			goto retry;
		}
	}
	rcu_read_unlock();
	return ctx;
}


static struct perf_counter_context *perf_pin_task_context(struct task_struct *task)
{
	struct perf_counter_context *ctx;
	unsigned long flags;

	ctx = perf_lock_task_context(task, &flags);
	if (ctx) {
		++ctx->pin_count;
		get_ctx(ctx);
		spin_unlock_irqrestore(&ctx->lock, flags);
	}
	return ctx;
}

Is buggy because perf_lock_task_context() can return a dead context.

the RCU read lock in perf_lock_task_context() only guarantees the memory
won't get freed, it doesn't guarantee the object is valid (in our case
refcount > 0).

Therefore we can return a locked object that can get freed the moment we
release the rcu read lock.

perf_pin_task_context() then increases the refcount and does an unlock
on freed memory.

That increased refcount will cause a double free, in case it started out
with 0.



