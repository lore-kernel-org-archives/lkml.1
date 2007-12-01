Return-Path: <linux-kernel-owner+w=401wt.eu-S1760937AbXLADop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760937AbXLADop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 22:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbXLADo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 22:44:29 -0500
Received: from rtr.ca ([76.10.145.34]:4825 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758048AbXLADo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 22:44:28 -0500
Message-ID: <4750D899.4020905@rtr.ca>
Date: Fri, 30 Nov 2007 22:44:25 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org>	<924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com>	<20071130142058.816d1693.akpm@linux-foundation.org>	<924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>	<4750CC78.9070105@rtr.ca>	<20071130190227.1976e682@laptopd505.fenrus.org>	<4750D180.6080001@rtr.ca> <20071130191816.3e744205@laptopd505.fenrus.org> <4750D585.1030200@rtr.ca>
In-Reply-To: <4750D585.1030200@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Fri, 30 Nov 2007 22:31:17 -0500
> Mark Lord <lkml@rtr.ca> wrote:
> 
>> Arjan van de Ven wrote:
>>> On Fri, 30 Nov 2007 22:14:08 -0500
>>> Mark Lord <lkml@rtr.ca> wrote:
>>>
>>>>> in -mm there is.. the QoS stuff allows you to set maximum
>>>>> tolerable
>>>> ..
>>>>
>>>> That's encouraging, I think, but not for 2.6.24.
>>>>
>>>>> latency. If your app cant take any latency, you should set
>>>>> those... and the side effect is that the kernel will not do
>>>>> long-latency C-states or P-state transitions..
>>>> ..
>>>>
>>>> I don't mind the cpufreq changing (actually, I want it to drop in
>>>> cpugfreq to save power and keep the fan off), but the C-states just
>>>> kill this app.
>>>>
>>>> The app is VMware.  I force the max_state=1 when launching,
>>> ah but then its' even easier... and can be done in 2.6.24 already.
>>> VMWare after all has a kernel module, and the latency stuff is in
>>> 2.6.23 and 2.6.24 available inside the kernel already.
>> ..
>>
>> Oh, I'm perfectly happy to write my own kernel module if that's what
> 
> all you need to do in your kernel module is call
> 
> add_latency_constraint("mark_wants_his_mouse", 5);

Okay, and how to change it back again?  (thanks)

Then why not have a sysfs entry for scripts to write to
to trigger the exact same end result?  :)

>> Speaking of which.. what's with powertop on 2.6.24 ???
>> It's gone from 100-200 wakeups/sec to 20000 wakeups/sec !!!!!!!
> 
> ho hum.. Lenovo T61?
> I have some reports that that happens once in a while (but it's not
> limited to .24 and it's also real, it's not a powertop bug but it
> actually is waking up that much)..
..

No, it's my hefty Dell Inspiron 9400.

And I just figured out the powertop:  it needed the kernel timers
patch from the powertop site that was originally for 2.6.21.. 

Any chance of somebody actually pushing that patch upstream some year ??
Patch reproduced here for interest's sake only.
Hey, look who's on the Signed-off list for it, *Arjan* !

* * *

>From e6f2ff1e4763212f1dcc945db76fb744b951ac53 Mon Sep 17 00:00:00 2001
From: Josh Triplett <josh@freedesktop.org>
Date: Sun, 13 May 2007 15:21:39 -0700
Subject: [PATCH] Lengthen and align background timers to decrease wakeups

This patch changes a few background timers in the Linux kernel to
1) be aligned to full seconds so that multiple timers get handled in one
   processor wakeup
2) have longer timeouts for those timers that can use such longer timeouts

Some of these are a bit crude, but it's effective.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
[Josh: Updates for 2.6.22-rc1]
Signed-off-by: Josh Triplett <josh@kernel.org>
---
 kernel/time/clocksource.c |   10 ++++++++--
 mm/page-writeback.c       |    8 ++++----
 mm/slab.c                 |    6 +++---
 net/core/neighbour.c      |    4 ++--
 4 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 3db5c3c..77308c4 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -79,11 +79,17 @@ static int watchdog_resumed;
 /*
  * Interval: 0.5sec Threshold: 0.0625s
  */
-#define WATCHDOG_INTERVAL (HZ >> 1)
+#define WATCHDOG_INTERVAL (HZ*10)
 #define WATCHDOG_THRESHOLD (NSEC_PER_SEC >> 4)
 
+static int secondtime;
+
 static void clocksource_ratewd(struct clocksource *cs, int64_t delta)
 {
+	if (!secondtime) {
+		secondtime = 1;
+		return;
+	};
 	if (delta > -WATCHDOG_THRESHOLD && delta < WATCHDOG_THRESHOLD)
 		return;
 
@@ -145,7 +151,7 @@ static void clocksource_watchdog(unsigned long data)
 
 	if (!list_empty(&watchdog_list)) {
 		__mod_timer(&watchdog_timer,
-			    watchdog_timer.expires + WATCHDOG_INTERVAL);
+			    round_jiffies(watchdog_timer.expires + WATCHDOG_INTERVAL));
 	}
 	spin_unlock(&watchdog_lock);
 }
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index eec1481..26318e5 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -77,7 +77,7 @@ int vm_dirty_ratio = 10;
 /*
  * The interval between `kupdate'-style writebacks, in jiffies
  */
-int dirty_writeback_interval = 5 * HZ;
+int dirty_writeback_interval = 15 * HZ;
 
 /*
  * The longest number of jiffies for which data is allowed to remain dirty
@@ -450,7 +450,7 @@ static void wb_kupdate(unsigned long arg)
 
 	oldest_jif = jiffies - dirty_expire_interval;
 	start_jif = jiffies;
-	next_jif = start_jif + dirty_writeback_interval;
+	next_jif = round_jiffies(start_jif + dirty_writeback_interval);
 	nr_to_write = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
@@ -467,7 +467,7 @@ static void wb_kupdate(unsigned long arg)
 		nr_to_write -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 	}
 	if (time_before(next_jif, jiffies + HZ))
-		next_jif = jiffies + HZ;
+		next_jif = round_jiffies(jiffies + HZ);
 	if (dirty_writeback_interval)
 		mod_timer(&wb_timer, next_jif);
 }
@@ -491,7 +491,7 @@ int dirty_writeback_centisecs_handler(ctl_table *table, int write,
 static void wb_timer_fn(unsigned long unused)
 {
 	if (pdflush_operation(wb_kupdate, 0) < 0)
-		mod_timer(&wb_timer, jiffies + HZ); /* delay 1 second */
+		mod_timer(&wb_timer, round_jiffies(jiffies + HZ)); /* delay 1 second */
 }
 
 static void laptop_flush(unsigned long unused)
diff --git a/mm/slab.c b/mm/slab.c
index 944b205..6003eef 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -467,8 +467,8 @@ struct kmem_cache {
  * OTOH the cpuarrays can contain lots of objects,
  * which could lock up otherwise freeable slabs.
  */
-#define REAPTIMEOUT_CPUC	(2*HZ)
-#define REAPTIMEOUT_LIST3	(4*HZ)
+#define REAPTIMEOUT_CPUC	(12*HZ)
+#define REAPTIMEOUT_LIST3	(20*HZ)
 
 #if STATS
 #define	STATS_INC_ACTIVE(x)	((x)->num_active++)
@@ -959,7 +959,7 @@ static void __devinit start_cpu_timer(int cpu)
 		init_reap_node(cpu);
 		INIT_DELAYED_WORK(reap_work, cache_reap);
 		schedule_delayed_work_on(cpu, reap_work,
-					__round_jiffies_relative(HZ, cpu));
+					__round_jiffies_relative(HZ*4, cpu));
 	}
 }
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 6f3bb73..e6aaa9c 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -696,10 +696,10 @@ next_elt:
 	if (!expire)
 		expire = 1;
 
-	if (expire>HZ)
+	if (expire>4*HZ)
 		mod_timer(&tbl->gc_timer, round_jiffies(now + expire));
 	else
-		mod_timer(&tbl->gc_timer, now + expire);
+		mod_timer(&tbl->gc_timer, round_jiffies(now + 4*HZ));
 
 	write_unlock(&tbl->lock);
 }
-- 
1.5.2-rc2.GIT

