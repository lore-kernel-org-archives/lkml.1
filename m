Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbYKDQPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbYKDQPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbYKDQPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:15:25 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57527 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754332AbYKDQPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:15:24 -0500
Date: Tue, 4 Nov 2008 11:15:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <jens.axboe@oracle.com>
cc: Tejun Heo <tj@kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] Add round_jiffies_up and related routines
Message-ID: <Pine.LNX.4.44L0.0811041111020.3614-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1158) adds round_jiffies_up() and friends.  These
routines work like the analogous round_jiffies() functions, except
that they will never round down.

The new routines will be useful for timeouts where we don't care
exactly when the timer expires, provided it doesn't expire too soon.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Jens:

This doesn't have anything to do with the block layer.  But the second
patch in this series does, and it uses round_jiffies_up().  Therefore I
thought it would be appropriate to submit this through you.

Alan Stern


Index: usb-2.6/include/linux/timer.h
===================================================================
--- usb-2.6.orig/include/linux/timer.h
+++ usb-2.6/include/linux/timer.h
@@ -186,4 +186,9 @@ unsigned long __round_jiffies_relative(u
 unsigned long round_jiffies(unsigned long j);
 unsigned long round_jiffies_relative(unsigned long j);
 
+unsigned long __round_jiffies_up(unsigned long j, int cpu);
+unsigned long __round_jiffies_up_relative(unsigned long j, int cpu);
+unsigned long round_jiffies_up(unsigned long j);
+unsigned long round_jiffies_up_relative(unsigned long j);
+
 #endif
Index: usb-2.6/kernel/timer.c
===================================================================
--- usb-2.6.orig/kernel/timer.c
+++ usb-2.6/kernel/timer.c
@@ -112,27 +112,8 @@ timer_set_base(struct timer_list *timer,
 				      tbase_get_deferrable(timer->base));
 }
 
-/**
- * __round_jiffies - function to round jiffies to a full second
- * @j: the time in (absolute) jiffies that should be rounded
- * @cpu: the processor number on which the timeout will happen
- *
- * __round_jiffies() rounds an absolute time in the future (in jiffies)
- * up or down to (approximately) full seconds. This is useful for timers
- * for which the exact time they fire does not matter too much, as long as
- * they fire approximately every X seconds.
- *
- * By rounding these timers to whole seconds, all such timers will fire
- * at the same time, rather than at various times spread out. The goal
- * of this is to have the CPU wake up less, which saves power.
- *
- * The exact rounding is skewed for each processor to avoid all
- * processors firing at the exact same time, which could lead
- * to lock contention or spurious cache line bouncing.
- *
- * The return value is the rounded version of the @j parameter.
- */
-unsigned long __round_jiffies(unsigned long j, int cpu)
+static unsigned long round_jiffies_common(unsigned long j, int cpu,
+		bool force_up)
 {
 	int rem;
 	unsigned long original = j;
@@ -154,8 +135,9 @@ unsigned long __round_jiffies(unsigned l
 	 * due to delays of the timer irq, long irq off times etc etc) then
 	 * we should round down to the whole second, not up. Use 1/4th second
 	 * as cutoff for this rounding as an extreme upper bound for this.
+	 * But never round down if @force_up is set.
 	 */
-	if (rem < HZ/4) /* round down */
+	if (rem < HZ/4 && !force_up) /* round down */
 		j = j - rem;
 	else /* round up */
 		j = j - rem + HZ;
@@ -167,6 +149,31 @@ unsigned long __round_jiffies(unsigned l
 		return original;
 	return j;
 }
+
+/**
+ * __round_jiffies - function to round jiffies to a full second
+ * @j: the time in (absolute) jiffies that should be rounded
+ * @cpu: the processor number on which the timeout will happen
+ *
+ * __round_jiffies() rounds an absolute time in the future (in jiffies)
+ * up or down to (approximately) full seconds. This is useful for timers
+ * for which the exact time they fire does not matter too much, as long as
+ * they fire approximately every X seconds.
+ *
+ * By rounding these timers to whole seconds, all such timers will fire
+ * at the same time, rather than at various times spread out. The goal
+ * of this is to have the CPU wake up less, which saves power.
+ *
+ * The exact rounding is skewed for each processor to avoid all
+ * processors firing at the exact same time, which could lead
+ * to lock contention or spurious cache line bouncing.
+ *
+ * The return value is the rounded version of the @j parameter.
+ */
+unsigned long __round_jiffies(unsigned long j, int cpu)
+{
+	return round_jiffies_common(j, cpu, false);
+}
 EXPORT_SYMBOL_GPL(__round_jiffies);
 
 /**
@@ -191,13 +198,10 @@ EXPORT_SYMBOL_GPL(__round_jiffies);
  */
 unsigned long __round_jiffies_relative(unsigned long j, int cpu)
 {
-	/*
-	 * In theory the following code can skip a jiffy in case jiffies
-	 * increments right between the addition and the later subtraction.
-	 * However since the entire point of this function is to use approximate
-	 * timeouts, it's entirely ok to not handle that.
-	 */
-	return  __round_jiffies(j + jiffies, cpu) - jiffies;
+	unsigned long j0 = jiffies;
+
+	barrier();	/* Prevent the compiler from aliasing j0 and jiffies */
+	return round_jiffies_common(j + j0, cpu, false) - j0;
 }
 EXPORT_SYMBOL_GPL(__round_jiffies_relative);
 
@@ -218,7 +222,7 @@ EXPORT_SYMBOL_GPL(__round_jiffies_relati
  */
 unsigned long round_jiffies(unsigned long j)
 {
-	return __round_jiffies(j, raw_smp_processor_id());
+	return round_jiffies_common(j, raw_smp_processor_id(), false);
 }
 EXPORT_SYMBOL_GPL(round_jiffies);
 
@@ -243,6 +247,71 @@ unsigned long round_jiffies_relative(uns
 }
 EXPORT_SYMBOL_GPL(round_jiffies_relative);
 
+/**
+ * __round_jiffies_up - function to round jiffies up to a full second
+ * @j: the time in (absolute) jiffies that should be rounded
+ * @cpu: the processor number on which the timeout will happen
+ *
+ * This is the same as __round_jiffies() except that it will never
+ * round down.  This is useful for timeouts for which the exact time
+ * of firing does not matter too much, as long as they don't fire too
+ * early.
+ */
+unsigned long __round_jiffies_up(unsigned long j, int cpu)
+{
+	return round_jiffies_common(j, cpu, true);
+}
+EXPORT_SYMBOL_GPL(__round_jiffies_up);
+
+/**
+ * __round_jiffies_up_relative - function to round jiffies up to a full second
+ * @j: the time in (relative) jiffies that should be rounded
+ * @cpu: the processor number on which the timeout will happen
+ *
+ * This is the same as __round_jiffies_relative() except that it will never
+ * round down.  This is useful for timeouts for which the exact time
+ * of firing does not matter too much, as long as they don't fire too
+ * early.
+ */
+unsigned long __round_jiffies_up_relative(unsigned long j, int cpu)
+{
+	unsigned long j0 = jiffies;
+
+	barrier();	/* Prevent the compiler from aliasing j0 and jiffies */
+	return round_jiffies_common(j + j0, cpu, true) - j0;
+}
+EXPORT_SYMBOL_GPL(__round_jiffies_up_relative);
+
+/**
+ * round_jiffies_up - function to round jiffies up to a full second
+ * @j: the time in (absolute) jiffies that should be rounded
+ *
+ * This is the same as round_jiffies() except that it will never
+ * round down.  This is useful for timeouts for which the exact time
+ * of firing does not matter too much, as long as they don't fire too
+ * early.
+ */
+unsigned long round_jiffies_up(unsigned long j)
+{
+	return round_jiffies_common(j, raw_smp_processor_id(), true);
+}
+EXPORT_SYMBOL_GPL(round_jiffies_up);
+
+/**
+ * round_jiffies_up_relative - function to round jiffies up to a full second
+ * @j: the time in (relative) jiffies that should be rounded
+ *
+ * This is the same as round_jiffies_relative() except that it will never
+ * round down.  This is useful for timeouts for which the exact time
+ * of firing does not matter too much, as long as they don't fire too
+ * early.
+ */
+unsigned long round_jiffies_up_relative(unsigned long j)
+{
+	return __round_jiffies_up_relative(j, raw_smp_processor_id());
+}
+EXPORT_SYMBOL_GPL(round_jiffies_up_relative);
+
 
 static inline void set_running_timer(struct tvec_base *base,
 					struct timer_list *timer)

