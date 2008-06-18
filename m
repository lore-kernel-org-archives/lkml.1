Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbYFRHaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbYFRHaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 03:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbYFRHaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 03:30:20 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:55174 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYFRHaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 03:30:19 -0400
Subject: Re: [PATCH/RFC] remove irqs_disabled warning from local_bh_enable
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>,
       David Ellingsworth <david@identd.dyndns.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.1.10.0806171648330.2907@woody.linux-foundation.org>
References: <1213739834.3803.137.camel@johannes.berg>
	 <alpine.LFD.1.10.0806171648330.2907@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 09:29:37 +0200
Message-Id: <1213774177.3803.164.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-17 at 16:55 -0700, Linus Torvalds wrote:

> > This warning has started to trigger with mac80211 because it can, under
> > some circumstances, use spin_lock_bh() protected sections within
> > irq-disabled sections. Is that a bug?
> 
> Yes, it's a bug.

You know, that actually makes sense to me.

> Why? Not because of the "spin_lock_bh()" itself, but because of the 
> _unlock_, which does a "local_bh_enable_ip()", which in turn will check 
> the whole "do_softirq()" if it was the last softirq_count.

Yeah, that makes sense to me as well. In fact, I pondered a bit over the
code until posting this.

> And you must not do softirq's when hard-irq's were disabled!
> 
> So it should in theory be ok (but perhaps a bit odd) to do something like
> 
> 	spin_lock_irq(&irq_lock);
> 	..do something..
> 	spin_lock_bh(&bh_lock);
> 	spin_unlock_irq(&irq_lock);
> 	.. do something else ..
> 	spin_unlock_bh(&bh_lock);
> 
> where the "spin_lock_bh()" itself is in an irq-locked context - as long as 
> the "spin_unlock_bh()" is *not*.
> 
> See?

Well, yes, from an API POV I do see that. And it's actually what I
thought up front. The thing that started to confuse me is that
local_bh_enable_ip reads like this:

void local_bh_enable_ip(unsigned long ip)
{
#ifdef CONFIG_TRACE_IRQFLAGS
        unsigned long flags;

        WARN_ON_ONCE(in_irq());

        local_irq_save(flags);
#endif

[...]
        if (unlikely(!in_interrupt() && local_softirq_pending()))
                do_softirq();

        dec_preempt_count();
#ifdef CONFIG_TRACE_IRQFLAGS
        local_irq_restore(flags);
#endif

So doesn't it actually run do_softirq() when interrupts are still
disabled? If I look deeper into the code that appears to be a rather odd
trick to avoid locking and __do_softirq will unconditionally enable
IRQs, so I guess here's my answer...

How about the patch below?

johannes

From: Johannes Berg <johannes@sipsolutions.net>
Subject: clean up and comment local_bh_enable code

There's no need to use local_irq_save() over local_irq_disable() in the
local_bh_enable code since it is a bug to call it with irqs disabled and
do_softirq will enable irqs if there is any pending work. Consolidate
the code from local_bh_enable and ..._ip to avoid having a disconnect
between them in the warnings they trigger that is currently there. Also
always trigger the warning on in_irq(), not just in the trace-irqflags
case.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I made it a static inline so that runtime behaviour isn't affected by
another function call, but that can be argued.

Maybe local_bh_enable() should just be a static inline somewhere in a
header file, that would get rid of one export_symbol as well.

 kernel/softirq.c |   48 +++++++++++-------------------------------------
 1 file changed, 11 insertions(+), 37 deletions(-)

--- everything.orig/kernel/softirq.c	2008-06-17 23:48:25.000000000 +0200
+++ everything/kernel/softirq.c	2008-06-18 09:13:21.000000000 +0200
@@ -131,23 +131,17 @@ void _local_bh_enable(void)
 
 EXPORT_SYMBOL(_local_bh_enable);
 
-void local_bh_enable(void)
+static inline void _local_bh_enable_ip(unsigned long ip)
 {
+	WARN_ON_ONCE(in_irq() || irqs_disabled());
 #ifdef CONFIG_TRACE_IRQFLAGS
-	unsigned long flags;
-
-	WARN_ON_ONCE(in_irq());
-#endif
-	WARN_ON_ONCE(irqs_disabled());
-
-#ifdef CONFIG_TRACE_IRQFLAGS
-	local_irq_save(flags);
+	local_irq_disable();
 #endif
 	/*
 	 * Are softirqs going to be turned on now:
 	 */
 	if (softirq_count() == SOFTIRQ_OFFSET)
-		trace_softirqs_on((unsigned long)__builtin_return_address(0));
+		trace_softirqs_on(ip);
 	/*
 	 * Keep preemption disabled until we are done with
 	 * softirq processing:
@@ -159,40 +153,20 @@ void local_bh_enable(void)
 
 	dec_preempt_count();
 #ifdef CONFIG_TRACE_IRQFLAGS
-	local_irq_restore(flags);
+	local_irq_enable();
 #endif
 	preempt_check_resched();
 }
+
+void local_bh_enable(void)
+{
+	_local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+}
 EXPORT_SYMBOL(local_bh_enable);
 
 void local_bh_enable_ip(unsigned long ip)
 {
-#ifdef CONFIG_TRACE_IRQFLAGS
-	unsigned long flags;
-
-	WARN_ON_ONCE(in_irq());
-
-	local_irq_save(flags);
-#endif
-	/*
-	 * Are softirqs going to be turned on now:
-	 */
-	if (softirq_count() == SOFTIRQ_OFFSET)
-		trace_softirqs_on(ip);
-	/*
-	 * Keep preemption disabled until we are done with
-	 * softirq processing:
- 	 */
- 	sub_preempt_count(SOFTIRQ_OFFSET - 1);
-
-	if (unlikely(!in_interrupt() && local_softirq_pending()))
-		do_softirq();
-
-	dec_preempt_count();
-#ifdef CONFIG_TRACE_IRQFLAGS
-	local_irq_restore(flags);
-#endif
-	preempt_check_resched();
+	_local_bh_enable_ip(ip);
 }
 EXPORT_SYMBOL(local_bh_enable_ip);
 


