Return-Path: <linux-kernel-owner+w=401wt.eu-S1760425AbYHEI4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425AbYHEI4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 04:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758601AbYHEI4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 04:56:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:41155 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766AbYHEI4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 04:56:33 -0400
Subject: Re: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
From: Peter Zijlstra <peterz@infradead.org>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: mingo@elte.hu, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
In-Reply-To: <20080804194646.GA17390@us.ibm.com>
References: <20080804194646.GA17390@us.ibm.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 10:56:25 +0200
Message-Id: <1217926585.3589.113.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 12:46 -0700, Nishanth Aravamudan wrote:
> Bisection on an x455 (2-node IA64) showed that commit
> 27ec4407790d075c325e1f4da0a19c56953cce23 (sched: make cpu_clock()
> globally synchronous) broke booting. I see the uncompressing initramfs
> message and then nothing on the console. I wait about 5 minutes (which
> is way longer than it takes for the first console messages to get
> printed normally). The commit immediately before it works fine.
> 
> The commit no longer cleanly reverts, but I tried to manually put things
> back to the way they were before in cpu_clock(). The resulting kernel
> boots fine. I could figure out a clean way to leave cpu_clock() in
> sched_clock.c because of all the rq dependencies from sched.c. The
> attempt I tested is below [1]. This patch is *NOT* for inclusion, just
> to demonstrate what I tested.
> 
> I'm happy to test any better patches.

Does this work for you?

---
Subject: sched_clock: delay using sched_clock()

Some arch's can't handle sched_clock() being called too early - delay
this until sched_clock_init() has been called.

Reported-by: Bill Gatliff <bgat@billgatliff.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>
---
 include/linux/sched.h |   14 +++-----------
 kernel/sched_clock.c  |   18 ++++++++++++++++--
 2 files changed, 19 insertions(+), 13 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1551,16 +1551,10 @@ static inline int set_cpus_allowed(struc
 
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
@@ -1584,8 +1578,6 @@ static inline void sched_clock_tick_star
 #endif
 
 #else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
-extern void sched_clock_init(void);
-extern u64 sched_clock_cpu(int cpu);
 extern void sched_clock_tick(void);
 extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
Index: linux-2.6/kernel/sched_clock.c
===================================================================
--- linux-2.6.orig/kernel/sched_clock.c
+++ linux-2.6/kernel/sched_clock.c
@@ -32,6 +32,7 @@
 #include <linux/ktime.h>
 #include <linux/module.h>
 
+static __read_mostly int sched_clock_running;
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 
@@ -71,8 +72,6 @@ static inline struct sched_clock_data *c
 	return &per_cpu(sched_clock_data, cpu);
 }
 
-static __read_mostly int sched_clock_running;
-
 void sched_clock_init(void)
 {
 	u64 ktime_now = ktime_to_ns(ktime_get());
@@ -319,6 +318,21 @@ void sched_clock_idle_wakeup_event(u64 d
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


