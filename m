Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZJRXJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZJRXJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 19:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbZJRXJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 19:09:56 -0400
Received: from aglcosbs02.cos.agilent.com ([192.25.218.39]:37878 "EHLO
	aglcosbs02.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755346AbZJRXJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 19:09:55 -0400
Message-ID: <4ADBA01C.6040508@agilent.com>
Date: Sun, 18 Oct 2009 16:09:16 -0700
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Bug in time warp detection code in older -rt kernels
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Oct 2009 23:09:33.0336 (UTC) FILETIME=[0DD43980:01CA5048]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly a historical note at this point but potentially relevant
to those who are working with older code.

RT kernels of the 2.6.21 vintage carry a time warp detection patch
like this:

http://www.filewatcher.com/p/patch-2.6.22.1-rt6-broken-out.tar.gz.627467/patches/time-warp-detect.patch.html

The patch will sometimes issue a false positive because:

+void warp_check_clock_was_changed(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		per_cpu(timestamp, cpu).tv64 = 0;
+}

will attempt to update the per-cpu timestamp as will the following
code in __get_realtime_clock_ts():

+	cpu = raw_smp_processor_id();
+	prev = per_cpu(timestamp, cpu);
+	per_cpu(timestamp, cpu) = now;


Sometimes warp_check_clock_was_changed() will get to update
the per-cpu timestamp, only to have its work de-railed by
__get_realtime_clock_ts() overwriting the per-cpu timestamp
with the last read value.


I chose to resolve the false positives by relaxing the warp
check and to allow some results to be returned unverified
under conditions of high contention.


Earl


--- linux-2.6.21_mvlcge500/kernel/timer.c.orig	2008-11-04 
09:19:46.000000000 -0800
+++ linux-2.6.21_mvlcge500/kernel/timer.c	2009-10-18 15:39:32.000000000 
-0700
@@ -970,14 +970,11 @@ cycle_t notrace usecs_to_cycles(unsigned
  	return ns2cyc(clock, (u64)usecs * 1000);
  }

-static DEFINE_PER_CPU(ktime_t, timestamp);
+static unsigned timestamp_epoch;

-void warp_check_clock_was_changed(void)
+void warp_check_clock_was_changed()
  {
-	int cpu;
-
-	for_each_online_cpu(cpu)
-		per_cpu(timestamp, cpu).tv64 = 0;
+	timestamp_epoch++;
  }

  /**
@@ -989,45 +986,66 @@ void warp_check_clock_was_changed(void)
   */
  static inline void __get_realtime_clock_ts(struct timespec *ts)
  {
-	unsigned long seq;
+	unsigned seq;
  	s64 nsecs;

-	unsigned long flags;
  	static int once = 1;
  	ktime_t prev, now;
-	int cpu;
+	unsigned epoch;
+	int gateholder;
+
+	static struct {
+		atomic_t gate;
+		ktime_t clock;
+		unsigned epoch;
+	} timestamp = { .gate = ATOMIC_INIT(1) };
+
+	/* As multiple threads across multiple cpus attempt to read
+	 * the time, only allow the first through the gate to perform
+	 * the time warp sanity check. This reduces the number of
+	 * verifications when there are many threads reading the clock,
+	 * but it would be uncommon to have so many threads reading the
+	 * time.
+	 */
+	gateholder = atomic_dec_and_test(&timestamp.gate);

-	local_irq_save(flags);
  	do {
  		seq = read_seqbegin(&xtime_lock);

  		*ts = xtime;
  		nsecs = __get_nsec_offset();
-
-		now = timespec_to_ktime(*ts);
+		epoch = timestamp_epoch;

  	} while (read_seqretry(&xtime_lock, seq));

  	timespec_add_ns(ts, nsecs);

  	now = timespec_to_ktime(*ts);
+	prev.tv64 = 0;
+
+	if (gateholder) {

-	cpu = raw_smp_processor_id();
-	prev = per_cpu(timestamp, cpu);
-	per_cpu(timestamp, cpu) = now;
+		if (epoch != timestamp.epoch) {
+			timestamp.clock.tv64 = 0;
+			timestamp.epoch = epoch;
+		}
+
+		prev = timestamp.clock;
+		timestamp.clock = now;
+	}
+
+	atomic_inc(&timestamp.gate);

  	if (once > 0 && prev.tv64 > now.tv64) {
  		once--;
  		stop_trace();
  		user_trace_stop();
-		local_irq_restore(flags);

-		printk("BUG: time warp detected!\n");
-		printk("prev > now, %016Lx > %016Lx:\n", prev.tv64, now.tv64);
-		printk("= %Ld delta, on CPU#%d\n", prev.tv64 - now.tv64, cpu);
+		printk(KERN_ERR "BUG: time warp detected: "
+			"prev %016Lx  now %016Lx:\n", prev.tv64, now.tv64);
+
  		dump_stack();
-	} else
-		local_irq_restore(flags);
+	}
  }

  /**



