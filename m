Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbXLBOwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbXLBOwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 09:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbXLBOwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 09:52:08 -0500
Received: from lazybastard.de ([212.112.238.170]:38179 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbXLBOwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 09:52:07 -0500
Date: Sun, 2 Dec 2007 15:46:36 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mark Lord <lkml@rtr.ca>,
       Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071202144635.GC9516@lazybastard.org>
References: <20071130183510.GA1570@lazybastard.org> <20071130184625.GB9928@elte.hu> <20071201151650.GA5031@lazybastard.org> <20071201183256.GA14052@elte.hu> <20071201204747.GA6458@lazybastard.org> <20071201205456.GA8231@elte.hu> <20071201234112.GA7209@lazybastard.org> <20071202085607.GA28966@elte.hu> <20071202113143.GA9378@lazybastard.org> <20071202123125.GA9516@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071202123125.GA9516@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 December 2007 13:31:25 +0100, Jörn Engel wrote:
> 
> After another ten or so notrace annotations throughout the spinlock
> code, the latency tracer appears to work.  Not sure how many useful
> information is missing through all the annotations, though.

And here is a patch with the needed annotations.  Looks a bit shabby, as
it was generated though git diff, patcher, interdiff and combinediff.

Jörn

-- 
Joern's library part 10:
http://blogs.msdn.com/David_Gristwood/archive/2004/06/24/164849.aspx

unchanged:
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -125,7 +125,7 @@ void __init setup_pit_timer(void)
  * to just read by itself. So use jiffies to emulate a free
  * running counter:
  */
-static cycle_t pit_read(void)
+static notrace cycle_t pit_read(void)
 {
 	unsigned long flags;
 	int count;
unchanged:
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -76,7 +76,7 @@ void __lockfunc _read_lock(rwlock_t *lock)
 }
 EXPORT_SYMBOL(_read_lock);
 
-unsigned long __lockfunc _spin_lock_irqsave(spinlock_t *lock)
+unsigned long notrace __lockfunc _spin_lock_irqsave(spinlock_t *lock)
 {
 	unsigned long flags;
 
@@ -341,7 +341,7 @@ void __lockfunc _read_unlock(rwlock_t *lock)
 }
 EXPORT_SYMBOL(_read_unlock);
 
-void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
+void notrace __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
unchanged:
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -148,7 +148,7 @@ int _raw_spin_trylock(spinlock_t *lock)
 	return ret;
 }
 
-void _raw_spin_unlock(spinlock_t *lock)
+void notrace _raw_spin_unlock(spinlock_t *lock)
 {
 	debug_spin_unlock(lock);
 	__raw_spin_unlock(&lock->raw_lock);
only in patch2:
unchanged:
--- linux/arch/x86/kernel/tsc_32.c
+++ linux-2.6.24-rc3logfs/arch/x86/kernel/tsc_32.c	2007-12-02 15:21:15.000000000 +0100
@@ -92,7 +92,7 @@
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
-unsigned long long native_sched_clock(void)
+unsigned notrace long long native_sched_clock(void)
 {
 	unsigned long long this_offset;
 
only in patch2:
unchanged:
--- linux/kernel/lockdep.c
+++ linux-2.6.24-rc3logfs/kernel/lockdep.c	2007-12-02 15:21:16.000000000 +0100
@@ -139,7 +139,7 @@
 	return i;
 }
 
-static void lock_time_inc(struct lock_time *lt, s64 time)
+static notrace void lock_time_inc(struct lock_time *lt, s64 time)
 {
 	if (time > lt->max)
 		lt->max = time;
@@ -198,7 +198,7 @@
 	memset(class->contention_point, 0, sizeof(class->contention_point));
 }
 
-static struct lock_class_stats *get_lock_stats(struct lock_class *class)
+static notrace struct lock_class_stats *get_lock_stats(struct lock_class *class)
 {
 	return &get_cpu_var(lock_stats)[class - lock_classes];
 }
@@ -208,7 +208,7 @@
 	put_cpu_var(lock_stats);
 }
 
-static void lock_release_holdtime(struct held_lock *hlock)
+static notrace void lock_release_holdtime(struct held_lock *hlock)
 {
 	struct lock_class_stats *stats;
 	s64 holdtime;
@@ -2872,7 +2872,7 @@
 }
 EXPORT_SYMBOL_GPL(lock_contended);
 
-void lock_acquired(struct lockdep_map *lock)
+void notrace lock_acquired(struct lockdep_map *lock)
 {
 	unsigned long flags;
 
