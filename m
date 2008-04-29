Return-Path: <linux-kernel-owner+w=401wt.eu-S1765520AbYD2Rc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765520AbYD2Rc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759439AbYD2RWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:22:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:43649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759433AbYD2RWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:22:07 -0400
Date: Tue, 29 Apr 2008 10:19:14 -0700
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
       Bodo Stroesser <bstroesser@fujitsu-siemens.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [32/37] hrtimer: timeout too long when using HRTIMER_CB_SOFTIRQ
Message-ID: <20080429171914.GG14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hrtimer-timeout-too-long-when-using-hrtimer_cb_softirq.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Bodo Stroesser <bstroesser@fujitsu-siemens.com>

commit d7b41a24bfb5d7fa02f7b49be1293d468814e424 upstream

When using hrtimer with timer->cb_mode == HRTIMER_CB_SOFTIRQ
in some cases the clockevent is not programmed.
This happens, if:
 - a timer is rearmed while it's state is HRTIMER_STATE_CALLBACK
 - hrtimer_reprogram() returns -ETIME, when it is called after
   CALLBACK is finished. This occurs if the new timer->expires
   is in the past when CALLBACK is done.
In this case, the timer needs to be removed from the tree and put
onto the pending list again.

The patch is against 2.6.22.5, but AFAICS, it is relevant
for 2.6.25 also (in run_hrtimer_pending()).

Signed-off-by: Bodo Stroesser <bstroesser@fujitsu-siemens.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/hrtimer.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1080,8 +1080,19 @@ static void run_hrtimer_pending(struct h
 			 * If the timer was rearmed on another CPU, reprogram
 			 * the event device.
 			 */
-			if (timer->base->first == &timer->node)
-				hrtimer_reprogram(timer, timer->base);
+			struct hrtimer_clock_base *base = timer->base;
+
+			if (base->first == &timer->node &&
+			    hrtimer_reprogram(timer, base)) {
+				/*
+				 * Timer is expired. Thus move it from tree to
+				 * pending list again.
+				 */
+				__remove_hrtimer(timer, base,
+						 HRTIMER_STATE_PENDING, 0);
+				list_add_tail(&timer->cb_entry,
+					      &base->cpu_base->cb_pending);
+			}
 		}
 	}
 	spin_unlock_irq(&cpu_base->lock);

-- 
