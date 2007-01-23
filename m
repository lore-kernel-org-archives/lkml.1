Return-Path: <linux-kernel-owner+w=401wt.eu-S965511AbXAWWBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965511AbXAWWBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965508AbXAWWBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:01:13 -0500
Received: from www.osadl.org ([213.239.205.134]:35865 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933161AbXAWWBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:01:04 -0500
Message-Id: <20070123211206.025974000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 21/46] Fix cascade lookup of next_timer_interrupt
Content-Disposition: inline;
	filename=next-timer-interrupt-fix-cascade-lookup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

When searching for the next pending timer in the timer wheel we
need to take the cascade into account. The current code has several
problems:
 1. it looks into the previous cascade
 2. it ignores a pending cascade 
 3. it ignores multiple cascades

Change the cascade lookup, so it calculates the array index from the
point of the next cascade and always look at the cascade buckets, when
the cascade is pending, i.e. gets executed in the next timer softirq.
When multiple cascades are pending, then lookup the next buckets too.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 kernel/timer.c |  151 ++++++++++++++++++++++++++++++---------------------------
 1 file changed, 81 insertions(+), 70 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/kernel/timer.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/timer.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/timer.c
@@ -597,99 +597,110 @@ static inline void __run_timers(tvec_bas
  * is used on S/390 to stop all activity when a cpus is idle.
  * This functions needs to be called disabled.
  */
-unsigned long next_timer_interrupt(void)
+static unsigned long __next_timer_interrupt(tvec_base_t *base)
 {
-	tvec_base_t *base;
-	struct list_head *list;
+	unsigned long timer_jiffies = base->timer_jiffies;
+	unsigned long expires = timer_jiffies + (LONG_MAX >> 1);
+	int index, slot, array, found = 0;
 	struct timer_list *nte;
-	unsigned long expires;
-	unsigned long hr_expires = MAX_JIFFY_OFFSET;
-	ktime_t hr_delta;
 	tvec_t *varray[4];
-	int i, j;
-
-	hr_delta = hrtimer_get_next_event();
-	if (hr_delta.tv64 != KTIME_MAX) {
-		struct timespec tsdelta;
-		tsdelta = ktime_to_timespec(hr_delta);
-		hr_expires = timespec_to_jiffies(&tsdelta);
-		if (hr_expires < 3)
-			return hr_expires + jiffies;
-	}
-	hr_expires += jiffies;
-
-	base = __get_cpu_var(tvec_bases);
-	spin_lock(&base->lock);
-	expires = base->timer_jiffies + (LONG_MAX >> 1);
-	list = NULL;
 
 	/* Look for timer events in tv1. */
-	j = base->timer_jiffies & TVR_MASK;
+	index = slot = timer_jiffies & TVR_MASK;
 	do {
-		list_for_each_entry(nte, base->tv1.vec + j, entry) {
+		list_for_each_entry(nte, base->tv1.vec + slot, entry) {
+			found = 1;
 			expires = nte->expires;
-			if (j < (base->timer_jiffies & TVR_MASK))
-				list = base->tv2.vec + (INDEX(0));
-			goto found;
+			/* Look at the cascade bucket(s)? */
+			if (!index || slot < index)
+				goto cascade;
+			return expires;
 		}
-		j = (j + 1) & TVR_MASK;
-	} while (j != (base->timer_jiffies & TVR_MASK));
+		slot = (slot + 1) & TVR_MASK;
+	} while (slot != index);
+
+cascade:
+	/* Calculate the next cascade event */
+	if (index)
+		timer_jiffies += TVR_SIZE - index;
+	timer_jiffies >>= TVR_BITS;
 
 	/* Check tv2-tv5. */
 	varray[0] = &base->tv2;
 	varray[1] = &base->tv3;
 	varray[2] = &base->tv4;
 	varray[3] = &base->tv5;
-	for (i = 0; i < 4; i++) {
-		j = INDEX(i);
+
+	for (array = 0; array < 4; array++) {
+		tvec_t *varp = varray[array];
+
+		index = slot = timer_jiffies & TVN_MASK;
 		do {
-			if (list_empty(varray[i]->vec + j)) {
-				j = (j + 1) & TVN_MASK;
-				continue;
-			}
-			list_for_each_entry(nte, varray[i]->vec + j, entry)
+			list_for_each_entry(nte, varp->vec + slot, entry) {
+				found = 1;
 				if (time_before(nte->expires, expires))
 					expires = nte->expires;
-			if (j < (INDEX(i)) && i < 3)
-				list = varray[i + 1]->vec + (INDEX(i + 1));
-			goto found;
-		} while (j != (INDEX(i)));
-	}
-found:
-	if (list) {
-		/*
-		 * The search wrapped. We need to look at the next list
-		 * from next tv element that would cascade into tv element
-		 * where we found the timer element.
-		 */
-		list_for_each_entry(nte, list, entry) {
-			if (time_before(nte->expires, expires))
-				expires = nte->expires;
-		}
+			}
+			/*
+			 * Do we still search for the first timer or are
+			 * we looking up the cascade buckets ?
+			 */
+			if (found) {
+				/* Look at the cascade bucket(s)? */
+				if (!index || slot < index)
+					break;
+				return expires;
+			}
+			slot = (slot + 1) & TVN_MASK;
+		} while (slot != index);
+
+		if (index)
+			timer_jiffies += TVN_SIZE - index;
+		timer_jiffies >>= TVN_BITS;
 	}
-	spin_unlock(&base->lock);
+	return expires;
+}
 
-	/*
-	 * It can happen that other CPUs service timer IRQs and increment
-	 * jiffies, but we have not yet got a local timer tick to process
-	 * the timer wheels.  In that case, the expiry time can be before
-	 * jiffies, but since the high-resolution timer here is relative to
-	 * jiffies, the default expression when high-resolution timers are
-	 * not active,
-	 *
-	 *   time_before(MAX_JIFFY_OFFSET + jiffies, expires)
-	 *
-	 * would falsely evaluate to true.  If that is the case, just
-	 * return jiffies so that we can immediately fire the local timer
-	 */
-	if (time_before(expires, jiffies))
-		return jiffies;
+/*
+ * Check, if the next hrtimer event is before the next timer wheel
+ * event:
+ */
+static unsigned long cmp_next_hrtimer_event(unsigned long now,
+					    unsigned long expires)
+{
+	ktime_t hr_delta = hrtimer_get_next_event();
+	struct timespec tsdelta;
 
-	if (time_before(hr_expires, expires))
-		return hr_expires;
+	if (hr_delta.tv64 == KTIME_MAX)
+		return expires;
 
+	if (hr_delta.tv64 <= TICK_NSEC)
+		return now;
+
+	tsdelta = ktime_to_timespec(hr_delta);
+	now += timespec_to_jiffies(&tsdelta);
+	if (time_before(now, expires))
+		return now;
 	return expires;
 }
+
+/**
+ * next_timer_interrupt - return the jiffy of the next pending timer
+ */
+unsigned long next_timer_interrupt(void)
+{
+	tvec_base_t *base = __get_cpu_var(tvec_bases);
+	unsigned long expires, now = jiffies;
+
+	spin_lock(&base->lock);
+	expires = __next_timer_interrupt(base);
+	spin_unlock(&base->lock);
+
+	if (time_before_eq(expires, now))
+		return now;
+
+	return cmp_next_hrtimer_event(now, expires);
+}
 #endif
 
 /******************************************************************/

--

