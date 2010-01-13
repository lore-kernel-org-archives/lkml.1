Return-Path: <linux-kernel-owner+w=401wt.eu-S932075Ab0AMJ1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab0AMJ1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203Ab0AMJ1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:27:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59249 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab0AMJ1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:27:50 -0500
Subject: Re: Entry conditions for perf_event_do_pending?
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Milton Miller <miltonm@bga.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20100113041445.GA17829@brick.ozlabs.ibm.com>
References: <20100113041445.GA17829@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 10:27:39 +0100
Message-ID: <1263374859.4244.192.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 15:14 +1100, Paul Mackerras wrote:
> We're seeing some perf-related crashes on powerpc related to having
> irqs in an inconsistent state (soft-enable vs. hard-enable
> vs. trace-irqs state) when entering perf_event_do_pending().
> We're fixing that, but along the way we have struck a question about
> what conditions are required on entry to perf_event_do_pending.
> 
> Its use of __get_cpu_var implies that it at least needs to be called
> with either interrupts or preemption disabled.  Does it in fact need
> to be called with irqs off?  Do we need to call irq_enter()/irq_exit()
> around it?  Are there any other requirements that people can think of?

Right, so when I wrote it all it required was preempt disabled, but then
I added all that disable stuff (perf_pending_event():
event->pending_disable) and that requires IRQs disabled because it calls
__perf_event_disable() which takes ctx->lock, which is supposed to be an
IRQ safe lock.

On x86 we always run it from a self-ipi, which is I guess why the
generic timer softirq callback never triggered for me, because that
looks broken.

So in short, I think perf_event_do_pending() requires full IRQ context,
if that includes calling irq_enter()/irq_exit() then yes.

Something like the below ought to do I guess..

---
 kernel/timer.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 15533b7..c61a794 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1198,6 +1198,7 @@ void update_process_times(int user_tick)
 	run_local_timers();
 	rcu_check_callbacks(cpu, user_tick);
 	printk_tick();
+	perf_event_do_pending();
 	scheduler_tick();
 	run_posix_cpu_timers(p);
 }
@@ -1209,8 +1210,6 @@ static void run_timer_softirq(struct softirq_action *h)
 {
 	struct tvec_base *base = __get_cpu_var(tvec_bases);
 
-	perf_event_do_pending();
-
 	hrtimer_run_pending();
 
 	if (time_after_eq(jiffies, base->timer_jiffies))


