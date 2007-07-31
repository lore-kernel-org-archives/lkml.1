Return-Path: <linux-kernel-owner+w=401wt.eu-S968966AbXGaEgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968966AbXGaEgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760217AbXGaEb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:31:56 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34586 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967066AbXGaEbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:31:53 -0400
Date: Mon, 30 Jul 2007 21:32:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mingo@elte.hu, drepper@redhat.com,
       jan.kiszka@web.de, Thomas Gleixner <tglx@linutronix.de>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 15/26] posix-timers: Prevent softirq starvation by small
	intervals and SIG_IGN
Message-ID: <20070731043259.GP3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="posix-timers-prevent-softirq-starvation-by-small-intervals-and-sig_ign.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

posix-timers which deliver an ignored signal are currently rearmed in
the timer softirq: This is necessary because the timer needs to be
delivered again when SIG_IGN is removed. This is not a problem, when
the interval is reasonable.

With high resolution timers enabled one might arm a posix timer with a
very small interval and ignore the signal. This might lead to a
softirq starvation when the interval is so small that the timer is
requeued onto the softirq pending list right away.

This problem was pointed out by Jan Kiszka. Thanks Jan !

The correct solution would be to stop the timer, when the signal is
ignored and rearm it when SIG_IGN is removed. Unfortunately this
requires modification in sigaction and involves non trivial sighand
locking. It's too late in the release cycle for such a change.

For now we just keep the timer running and enforce that the timer only
fires every jiffie. This does not break anything as we keep the
overrun counter correct. It adds a little inaccuracy to the
timer_gettime() interface, but...

The more complex change is necessary anyway to fix another short
coming of the current implementation, which I discovered while looking
at this problem: A pending signal is discarded when SIG_IGN is set. In
case that a posixtimer signal is pending then it is discarded as well,
but when SIG_IGN is removed later nothing rearms the timer. This is
not new, it's that way since posix timers have been merged. So nothing
to worry about right now.

I have a working solution to fix all of this, but the impact is too
large for both stable and 2.6.22. I'm going to send it out for review
in the next days.

This should go into 2.6.21.stable as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kiszka <jan.kiszka@web.de>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/posix-timers.c |   35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

--- linux-2.6.21.6.orig/kernel/posix-timers.c
+++ linux-2.6.21.6/kernel/posix-timers.c
@@ -354,9 +354,40 @@ static enum hrtimer_restart posix_timer_
 		 * it should be restarted.
 		 */
 		if (timr->it.real.interval.tv64 != 0) {
+			ktime_t now = hrtimer_cb_get_time(timer);
+
+			/*
+			 * FIXME: What we really want, is to stop this
+			 * timer completely and restart it in case the
+			 * SIG_IGN is removed. This is a non trivial
+			 * change which involves sighand locking
+			 * (sigh !), which we don't want to do late in
+			 * the release cycle.
+			 *
+			 * For now we just let timers with an interval
+			 * less than a jiffie expire every jiffie to
+			 * avoid softirq starvation in case of SIG_IGN
+			 * and a very small interval, which would put
+			 * the timer right back on the softirq pending
+			 * list. By moving now ahead of time we trick
+			 * hrtimer_forward() to expire the timer
+			 * later, while we still maintain the overrun
+			 * accuracy, but have some inconsistency in
+			 * the timer_gettime() case. This is at least
+			 * better than a starved softirq. A more
+			 * complex fix which solves also another related
+			 * inconsistency is already in the pipeline.
+			 */
+#ifdef CONFIG_HIGH_RES_TIMERS
+			{
+				ktime_t kj = ktime_set(0, NSEC_PER_SEC / HZ);
+
+				if (timr->it.real.interval.tv64 < kj.tv64)
+					now = ktime_add(now, kj);
+			}
+#endif
 			timr->it_overrun +=
-				hrtimer_forward(timer,
-						hrtimer_cb_get_time(timer),
+				hrtimer_forward(timer, now,
 						timr->it.real.interval);
 			ret = HRTIMER_RESTART;
 			++timr->it_requeue_pending;

-- 
