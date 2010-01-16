Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab0APLgz (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 06:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646Ab0APLgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 06:36:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41078 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab0APLgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 06:36:54 -0500
Date: Sat, 16 Jan 2010 12:36:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>, stable kernel team <stable@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sched_clock.c change to -stable?
Message-ID: <20100116113647.GB31414@elte.hu>
References: <20100116.005541.18991049.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100116.005541.18991049.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> 
> Ingo, I need commit:
> 
> commit b9f8fcd55bbdb037e5332dbdb7b494f0b70861ac
> Author: David Miller <davem@davemloft.net>
> Date:   Sun Dec 13 18:25:02 2009 -0800
> 
>     sched: Fix cpu_clock() in NMIs, on !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
>     
> as a dependency on some sparc perf bug fixes I'd like to
> submit to -stable.
> 
> Therefore, do you mind if I send this commit to -stable?
> 
> Thanks.

Sure!

I've attached the commit for the -stable team's convenience.

	Ingo

------------------>
>From b9f8fcd55bbdb037e5332dbdb7b494f0b70861ac Mon Sep 17 00:00:00 2001
From: David Miller <davem@davemloft.net>
Date: Sun, 13 Dec 2009 18:25:02 -0800
Subject: [PATCH] sched: Fix cpu_clock() in NMIs, on !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK

Relax stable-sched-clock architectures to not save/disable/restore
hardirqs in cpu_clock().

The background is that I was trying to resolve a sparc64 perf
issue when I discovered this problem.

On sparc64 I implement pseudo NMIs by simply running the kernel
at IRQ level 14 when local_irq_disable() is called, this allows
performance counter events to still come in at IRQ level 15.

This doesn't work if any code in an NMI handler does
local_irq_save() or local_irq_disable() since the "disable" will
kick us back to cpu IRQ level 14 thus letting NMIs back in and
we recurse.

The only path which that does that in the perf event IRQ
handling path is the code supporting frequency based events.  It
uses cpu_clock().

cpu_clock() simply invokes sched_clock() with IRQs disabled.

And that's a fundamental bug all on it's own, particularly for
the HAVE_UNSTABLE_SCHED_CLOCK case.  NMIs can thus get into the
sched_clock() code interrupting the local IRQ disable code
sections of it.

Furthermore, for the not-HAVE_UNSTABLE_SCHED_CLOCK case, the IRQ
disabling done by cpu_clock() is just pure overhead and
completely unnecessary.

So the core problem is that sched_clock() is not NMI safe, but
we are invoking it from NMI contexts in the perf events code
(via cpu_clock()).

A less important issue is the overhead of IRQ disabling when it
isn't necessary in cpu_clock().

CONFIG_HAVE_UNSTABLE_SCHED_CLOCK architectures are not
affected by this patch.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091213.182502.215092085.davem@davemloft.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_clock.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 479ce56..5b49613 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -236,6 +236,18 @@ void sched_clock_idle_wakeup_event(u64 delta_ns)
 }
 EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
 
+unsigned long long cpu_clock(int cpu)
+{
+	unsigned long long clock;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	clock = sched_clock_cpu(cpu);
+	local_irq_restore(flags);
+
+	return clock;
+}
+
 #else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 
 void sched_clock_init(void)
@@ -251,17 +263,12 @@ u64 sched_clock_cpu(int cpu)
 	return sched_clock();
 }
 
-#endif /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 
 unsigned long long cpu_clock(int cpu)
 {
-	unsigned long long clock;
-	unsigned long flags;
+	return sched_clock_cpu(cpu);
+}
 
-	local_irq_save(flags);
-	clock = sched_clock_cpu(cpu);
-	local_irq_restore(flags);
+#endif /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
 
-	return clock;
-}
 EXPORT_SYMBOL_GPL(cpu_clock);
