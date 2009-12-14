Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbZLNCZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbZLNCZG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 21:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756470AbZLNCZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 21:25:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51956
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756468AbZLNCZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 21:25:03 -0500
Date: Sun, 13 Dec 2009 18:25:02 -0800 (PST)
Message-Id: <20091213.182502.215092085.davem@davemloft.net>
To: mingo@elte.hu
CC: tglx@linutronix.de, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: cpu_clock() in NMIs
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The background is that I was trying to resolve a sparc64 perf
issue when I discovered this problem.

On sparc64 I implement pseudo NMIs by simply running the kernel
at IRQ level 14 when local_irq_disable() is called, this allows
performance counter events to still come in at IRQ level 15.

This doesn't work if any code in an NMI handler does local_irq_save()
or local_irq_disable() since the "disable" will kick us back to cpu
IRQ level 14 thus letting NMIs back in and we recurse.

The only path which that does that in the perf event IRQ handling path
is the code supporting frequency based events.  It uses cpu_clock().

cpu_clock() simply invokes sched_clock() with IRQs disabled.

And that's a fundamental bug all on it's own, particularly for the
HAVE_UNSTABLE_SCHED_CLOCK case.  NMIs can thus get into the
sched_clock() code interrupting the local IRQ disable code sections
of it.

Furthermore, for the not-HAVE_UNSTABLE_SCHED_CLOCK case, the IRQ
disabling done by cpu_clock() is just pure overhead and completely
unnecessary.

So the core problem is that sched_clock() is not NMI safe, but we
are invoking it from NMI contexts in the perf events code (via
cpu_clock()).

A less important issue is the overhead of IRQ disabling when it isn't
necessary in cpu_clock().  Maybe something simple like the patch below
to handle that.

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
