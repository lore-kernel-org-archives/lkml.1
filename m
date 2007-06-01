Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbXFAGPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbXFAGPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 02:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbXFAGPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 02:15:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53182 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117AbXFAGPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 02:15:23 -0400
Date: Fri, 1 Jun 2007 08:15:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] timer stats: speedups
Message-ID: <20070601061506.GA29595@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] timer stats: speedups
From: Ingo Molnar <mingo@elte.hu>

make timer-stats have almost zero overhead when enabled in the config 
but not used. (this way distros can enable it more easily)

also update the documentation about overhead of timer_stats - it was 
written for the first version which had a global lock and a linear list 
walk based lookup ;-)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/hrtimer/timer_stats.txt |    7 ++++---
 kernel/time/timer_stats.c             |    7 ++++++-
 lib/Kconfig.debug                     |    5 ++++-
 3 files changed, 14 insertions(+), 5 deletions(-)

Index: linux/Documentation/hrtimer/timer_stats.txt
===================================================================
--- linux.orig/Documentation/hrtimer/timer_stats.txt
+++ linux/Documentation/hrtimer/timer_stats.txt
@@ -2,9 +2,10 @@ timer_stats - timer usage statistics
 ------------------------------------
 
 timer_stats is a debugging facility to make the timer (ab)usage in a Linux
-system visible to kernel and userspace developers. It is not intended for
-production usage as it adds significant overhead to the (hr)timer code and the
-(hr)timer data structures.
+system visible to kernel and userspace developers. If enabled in the config
+but not used it has almost zero runtime overhead, and a relatively small
+data structure overhead. Even if collection is enabled runtime all the
+locking is per-CPU and lookup is hashed.
 
 timer_stats should be used by kernel and userspace developers to verify that
 their code does not make unduly use of timers. This helps to avoid unnecessary
Index: linux/kernel/time/timer_stats.c
===================================================================
--- linux.orig/kernel/time/timer_stats.c
+++ linux/kernel/time/timer_stats.c
@@ -232,10 +232,15 @@ void timer_stats_update_stats(void *time
 	/*
 	 * It doesnt matter which lock we take:
 	 */
-	spinlock_t *lock = &per_cpu(lookup_lock, raw_smp_processor_id());
+	spinlock_t *lock;
 	struct entry *entry, input;
 	unsigned long flags;
 
+	if (likely(!active))
+		return;
+
+	lock = &per_cpu(lookup_lock, raw_smp_processor_id());
+
 	input.timer = timer;
 	input.start_func = startf;
 	input.expire_func = timerf;
Index: linux/lib/Kconfig.debug
===================================================================
--- linux.orig/lib/Kconfig.debug
+++ linux/lib/Kconfig.debug
@@ -143,7 +143,10 @@ config TIMER_STATS
 	  reprogrammed. The statistics can be read from /proc/timer_stats.
 	  The statistics collection is started by writing 1 to /proc/timer_stats,
 	  writing 0 stops it. This feature is useful to collect information
-	  about timer usage patterns in kernel and userspace.
+	  about timer usage patterns in kernel and userspace. This feature
+	  is lightweight if enabled in the kernel config but not activated
+	  (it defaults to deactivated on bootup and will only be activated
+	  if some application like powertop activates it explicitly).
 
 config DEBUG_SLAB
 	bool "Debug slab memory allocations"
