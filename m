Return-Path: <linux-kernel-owner+w=401wt.eu-S1758999AbYGaVsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbYGaVsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbYGaVsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:48:04 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:29463 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754818AbYGaVsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:48:01 -0400
X-SourceIP: 80.57.229.25
Subject: Re: Fwd: Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa breaks
	PXA270 (at least)?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       vatsa@linux.vnet.ibm.com, efault@gmx.de, linux-kernel@vger.kernel.org,
       Bill Gatliff <bgat@billgatliff.com>
In-Reply-To: <20080731213741.GJ2729@elte.hu>
References: <20080729223105.GK10982@flint.arm.linux.org.uk>
	 <20080729154605.d540cf6d.akpm@linux-foundation.org>
	 <20080731213741.GJ2729@elte.hu>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 23:47:55 +0200
Message-Id: <1217540875.8157.105.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 23:37 +0200, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 29 Jul 2008 23:31:05 +0100
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > 
> > > But then some bright spark thought it would be a good idea to get
> > > rid of printk_clock().
> > 
> > <does git-log, searches for printk_clock>
> 
> i think this is a fresh regression via the introduction of 
> kernel/sched_clock.c. We lost the (known) early-init behavior of 
> cpu_clock() in the !UNSTABLE_SCHED_CLOCK case. The fix would be to 
> restore that, not to reintroduce printk_clock().
> 
> Peter, any ideas?

How about something like this, it builds an atificial delay, exactly
like we already have for the HAVE_UNSTABLE_SCHED_CLOCK case.

This keeps cpu_clock() 0 until after sched_clock_init().

Russell, Bill, is this sufficient?

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1b26ed2..d13264b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1550,16 +1550,10 @@ static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 
 extern unsigned long long sched_clock(void);
 
-#ifndef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-static inline void sched_clock_init(void)
-{
-}
-
-static inline u64 sched_clock_cpu(int cpu)
-{
-	return sched_clock();
-}
+extern void sched_clock_init(void);
+extern u64 sched_clock_cpu(int cpu);
 
+#ifndef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 static inline void sched_clock_tick(void)
 {
 }
@@ -1583,8 +1577,6 @@ static inline void sched_clock_tick_start(int cpu)
 #endif
 
 #else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
-extern void sched_clock_init(void);
-extern u64 sched_clock_cpu(int cpu);
 extern void sched_clock_tick(void);
 extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 22ed55d..a804582 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -32,6 +32,7 @@
 #include <linux/ktime.h>
 #include <linux/module.h>
 
+static __read_mostly int sched_clock_running;
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 
@@ -71,8 +72,6 @@ static inline struct sched_clock_data *cpu_sdc(int cpu)
 	return &per_cpu(sched_clock_data, cpu);
 }
 
-static __read_mostly int sched_clock_running;
-
 void sched_clock_init(void)
 {
 	u64 ktime_now = ktime_to_ns(ktime_get());
@@ -319,6 +318,21 @@ void sched_clock_idle_wakeup_event(u64 delta_ns)
 }
 EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
 
+#else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
+
+void sched_clock_init(void)
+{
+	sched_clock_running = 1;
+}
+
+u64 sched_clock_cpu(int cpu)
+{
+	if (unlikely(!sched_clock_running))
+		return 0;
+
+	return sched_clock();
+}
+
 #endif
 
 /*


