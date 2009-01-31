Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZAaRMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZAaRMI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 12:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZAaRL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 12:11:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51211 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbZAaRL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 12:11:56 -0500
Subject: Re: [git pull] scheduler fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Alexey Zaytsev <alexey.zaytsev@gmail.com>
In-Reply-To: <20090130230936.GA7549@elte.hu>
References: <20090130230936.GA7549@elte.hu>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 18:11:41 +0100
Message-Id: <1233421901.4787.27.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 00:09 +0100, Ingo Molnar wrote:

> Alexey Zaytsev (1):
>       x86: set the initial softirq preempt count to SOFTIRQ_OFFSET

> Nick Piggin (1):
>       sched: improve preempt debugging

> diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
> index 74b9ff7..8d99de6 100644
> --- a/arch/x86/kernel/irq_32.c
> +++ b/arch/x86/kernel/irq_32.c
> @@ -141,7 +141,7 @@ void __cpuinit irq_ctx_init(int cpu)
>  	irqctx->tinfo.task		= NULL;
>  	irqctx->tinfo.exec_domain	= NULL;
>  	irqctx->tinfo.cpu		= cpu;
> -	irqctx->tinfo.preempt_count	= 0;
> +	irqctx->tinfo.preempt_count	= SOFTIRQ_OFFSET;
>  	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
>  
>  	softirq_ctx[cpu] = irqctx;

> diff --git a/kernel/sched.c b/kernel/sched.c
> index 52bbf1c..5686bb5 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4440,7 +4450,7 @@ void __kprobes sub_preempt_count(int val)
>  	/*
>  	 * Underflow?
>  	 */
> -	if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
> +       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
>  		return;
>  	/*
>  	 * Is the spinlock portion underflowing?

I'm not at all convinced this is going to work well.

For one, why does only i386 suffer this problem?

Secondly, it seems to cause i386 lockdep troubles as
__local_bh_disable() and _local_bh_enable_ip() their
trace_softirqs_off/on() conditions won't ever trigger when ran in that
irq context.

One possible solution to that latter problem might be calling those
trace points unconditionally in __do_softirq() like the patch below
does, but that will generate a lot of redundant trace calls on basically
all other platforms.

All in all, it all seems rather a bit of a mess :-(

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/softirq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 3dd0d13..25b4691 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -191,6 +191,7 @@ asmlinkage void __do_softirq(void)
 	account_system_vtime(current);
 
 	__local_bh_disable((unsigned long)__builtin_return_address(0));
+	trace_softirqs_off();
 	trace_softirq_enter();
 
 	cpu = smp_processor_id();
@@ -232,7 +233,7 @@ restart:
 		wakeup_softirqd();
 
 	trace_softirq_exit();
-
+	trace_softirqs_on();
 	account_system_vtime(current);
 	_local_bh_enable();
 }


