Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbZLOIMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbZLOIMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbZLOIMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:12:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:59668 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758078AbZLOIMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:12:05 -0500
Date: Tue, 15 Dec 2009 08:11:09 GMT
From: tip-bot for David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, davem@davemloft.net,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, davem@davemloft.net,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091213.182502.215092085.davem@davemloft.net>
References: <20091213.182502.215092085.davem@davemloft.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix cpu_clock() in NMIs, on !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
Message-ID: <tip-b9f8fcd55bbdb037e5332dbdb7b494f0b70861ac@git.kernel.org>
Git-Commit-ID: b9f8fcd55bbdb037e5332dbdb7b494f0b70861ac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9f8fcd55bbdb037e5332dbdb7b494f0b70861ac
Gitweb:     http://git.kernel.org/tip/b9f8fcd55bbdb037e5332dbdb7b494f0b70861ac
Author:     David Miller <davem@davemloft.net>
AuthorDate: Sun, 13 Dec 2009 18:25:02 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 09:04:36 +0100

sched: Fix cpu_clock() in NMIs, on !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK

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
