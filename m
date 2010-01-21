Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525Ab0AUE0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0AUE0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161Ab0AUE0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:26:44 -0500
Received: from kroah.org ([198.145.64.141]:60174 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab0AUEXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:23:03 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:35 2010
Message-Id: <20100121041835.475421852@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [23/30] sched: Fix cpu_clock() in NMIs, on !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Miller <davem@davemloft.net>

commit b9f8fcd55bbdb037e5332dbdb7b494f0b70861ac upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched_clock.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -236,6 +236,18 @@ void sched_clock_idle_wakeup_event(u64 d
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


