Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbYDRV4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbYDRV4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbYDRVz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 17:55:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:65389 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbYDRVz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 17:55:56 -0400
Message-ID: <480918B0.2070800@windriver.com>
Date: Fri, 18 Apr 2008 16:54:56 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       penberg@cs.helsinki.fi, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, jmorris@namei.org,
       sds@tycho.nsa.gov
Subject: Re: 2.6.25-mm1: not looking good
References: <20080417160331.b4729f0c.akpm@linux-foundation.org> <20080417164034.e406ef53.akpm@linux-foundation.org> <20080417171413.6f8458e4.akpm@linux-foundation.org> <48080FE7.1070400@windriver.com> <20080418073732.GA22724@elte.hu>
In-Reply-To: <20080418073732.GA22724@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2008 21:54:48.0765 (UTC) FILETIME=[D271FED0:01C8A19E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jason Wessel <jason.wessel@windriver.com> wrote:
>
>   
>>> [...] The final initcall is init_kgdbts() and disabling KGDB 
>>> prevents the hang.
>>>       
> incidentally, just today, in overnight testing i triggered a similar 
> hang in the KGDB self-test:
>
>   http://redhat.com/~mingo/misc/config-Thu_Apr_17_23_46_36_CEST_2008.bad
>
> to get a similar tree to the one i tested, pick up sched-devel/latest 
> from:
>
>    http://people.redhat.com/mingo/sched-devel.git/README 
>
> pick up that failing .config, do 'make oldconfig' and accept all the 
> defaults to get a comparable kernel to mine. (kgdb is embedded in 
> sched-devel.git.)
>
> the hang was at:
>
> [   12.504057] Calling initcall 0xffffffff80b800c1: init_kgdbts+0x0/0x1b()
> [   12.511298] kgdb: Registered I/O driver kgdbts.
> [   12.515062] kgdbts:RUN plant and detach test
> [   12.520283] kgdbts:RUN sw breakpoint test
> [   12.524651] kgdbts:RUN bad memory access test
> [   12.529052] kgdbts:RUN singlestep breakpoint test
>
>   

So I pulled your tree and I would agree there was a problem.  But it
seems unrelated to kgdb.  I bisected the tree because it worked starting
with the kgdb-light merge. 

It fails once with the patch below, but it is not clear as to why other
than the lock must have something to do with it.

I'll submit a patch to the kgdb test suite to increase the amount of
loops through the single step test as it is it can definitely catch
things :-)

Jason.


>From 84556fe84dd975161e70b782d7d7cc7bd080c06a Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 28 Feb 2008 21:00:21 +0100
Subject: [PATCH 0883/1078] sched: make cpu_clock() globally synchronous

Alexey Zaytsev reported (and bisected) that the introduction of
cpu_clock() in printk made the timestamps jump back and forth.

Make cpu_clock() more reliable while still keeping it fast when it's
called frequently.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8dcdec6..7377222 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -632,11 +632,39 @@ int sysctl_sched_rt_runtime = 950000;
  */
 #define RUNTIME_INF    ((u64)~0ULL)
 
+static const unsigned long long time_sync_thresh = 100000;
+
+static DEFINE_PER_CPU(unsigned long long, time_offset);
+static DEFINE_PER_CPU(unsigned long long, prev_cpu_time);
+
 /*
- * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
- * clock constructed from sched_clock():
+ * Global lock which we take every now and then to synchronize
+ * the CPUs time. This method is not warp-safe, but it's good
+ * enough to synchronize slowly diverging time sources and thus
+ * it's good enough for tracing:
  */
-unsigned long long cpu_clock(int cpu)
+static DEFINE_SPINLOCK(time_sync_lock);
+static unsigned long long prev_global_time;
+
+static unsigned long long __sync_cpu_clock(cycles_t time, int cpu)
+{
+    unsigned long flags;
+
+    spin_lock_irqsave(&time_sync_lock, flags);
+
+    if (time < prev_global_time) {
+        per_cpu(time_offset, cpu) += prev_global_time - time;
+        time = prev_global_time;
+    } else {
+        prev_global_time = time;
+    }
+
+    spin_unlock_irqrestore(&time_sync_lock, flags);
+
+    return time;
+}
+
+static unsigned long long __cpu_clock(int cpu)
 {
     unsigned long long now;
     unsigned long flags;
@@ -657,6 +685,24 @@ unsigned long long cpu_clock(int cpu)
 
     return now;
 }
+
+/*
+ * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
+ * clock constructed from sched_clock():
+ */
+unsigned long long cpu_clock(int cpu)
+{
+    unsigned long long prev_cpu_time, time, delta_time;
+
+    prev_cpu_time = per_cpu(prev_cpu_time, cpu);
+    time = __cpu_clock(cpu) + per_cpu(time_offset, cpu);
+    delta_time = time-prev_cpu_time;
+
+    if (unlikely(delta_time > time_sync_thresh))
+        time = __sync_cpu_clock(time, cpu);
+
+    return time;
+}
 EXPORT_SYMBOL_GPL(cpu_clock);
 
 #ifndef prepare_arch_switch
-- 
1.5.5


