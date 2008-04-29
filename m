Return-Path: <linux-kernel-owner+w=401wt.eu-S932570AbYD2Rez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbYD2Rez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759547AbYD2RWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:22:30 -0400
Received: from ns1.suse.de ([195.135.220.2]:52737 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759513AbYD2RW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:22:28 -0400
Date: Tue, 29 Apr 2008 10:19:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [37/37] hrtimer: raise softirq unlocked to avoid circular lock
	dependency
Message-ID: <20080429171926.GL14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hrtimer-raise-softirq-unlocked-to-avoid-circular-lock-dependency.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 0c96c5979a522c3323c30a078a70120e29b5bdbc upstream

The scheduler hrtimer bits in 2.6.25 introduced a circular lock
dependency in a rare code path:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.25-sched-devel.git-x86-latest.git #19
-------------------------------------------------------
X/2980 is trying to acquire lock:
 (&rq->rq_lock_key#2){++..}, at: [<ffffffff80230146>] task_rq_lock+0x56/0xa0

but task is already holding lock:
 (&cpu_base->lock){++..}, at: [<ffffffff80257ae1>] lock_hrtimer_base+0x31/0x60

which lock already depends on the new lock.

The scenario which leads to this is:

posix-timer signal is delivered
 -> posix-timer is rearmed
    timer is already expired in hrtimer_enqueue()
     -> softirq is raised

To prevent this we need to move the raise of the softirq out of the
base->lock protected code path.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/hrtimer.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -590,7 +590,6 @@ static inline int hrtimer_enqueue_reprog
 			list_add_tail(&timer->cb_entry,
 				      &base->cpu_base->cb_pending);
 			timer->state = HRTIMER_STATE_PENDING;
-			raise_softirq(HRTIMER_SOFTIRQ);
 			return 1;
 		default:
 			BUG();
@@ -633,6 +632,11 @@ static int hrtimer_switch_to_hres(void)
 	return 1;
 }
 
+static inline void hrtimer_raise_softirq(void)
+{
+	raise_softirq(HRTIMER_SOFTIRQ);
+}
+
 #else
 
 static inline int hrtimer_hres_active(void) { return 0; }
@@ -651,6 +655,7 @@ static inline int hrtimer_reprogram(stru
 {
 	return 0;
 }
+static inline void hrtimer_raise_softirq(void) { }
 
 #endif /* CONFIG_HIGH_RES_TIMERS */
 
@@ -850,7 +855,7 @@ hrtimer_start(struct hrtimer *timer, kti
 {
 	struct hrtimer_clock_base *base, *new_base;
 	unsigned long flags;
-	int ret;
+	int ret, raise;
 
 	base = lock_hrtimer_base(timer, &flags);
 
@@ -884,8 +889,18 @@ hrtimer_start(struct hrtimer *timer, kti
 	enqueue_hrtimer(timer, new_base,
 			new_base->cpu_base == &__get_cpu_var(hrtimer_bases));
 
+	/*
+	 * The timer may be expired and moved to the cb_pending
+	 * list. We can not raise the softirq with base lock held due
+	 * to a possible deadlock with runqueue lock.
+	 */
+	raise = timer->state == HRTIMER_STATE_PENDING;
+
 	unlock_hrtimer_base(timer, &flags);
 
+	if (raise)
+		hrtimer_raise_softirq();
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(hrtimer_start);

-- 
