Return-Path: <linux-kernel-owner+w=401wt.eu-S936948AbYBWAr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936948AbYBWAr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935308AbYBWAf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:35:56 -0500
Received: from ns1.suse.de ([195.135.220.2]:44991 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933373AbYBWAfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:35:54 -0500
Date: Fri, 22 Feb 2008 16:31:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 29/38] hrtimer: catch expired CLOCK_REALTIME timers early
Message-ID: <20080223003118.GD7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hrtimer-catch-expired-clock_realtime-timers-early.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 63070a79ba482c274bad10ac8c4b587a3e011f2c

A CLOCK_REALTIME timer, which has an absolute expiry time less than
the clock realtime offset calls with a negative delta into the clock
events code and triggers the WARN_ON() there.

This is a false positive and needs to be prevented. Check the result
of timer->expires - timer->base->offset right away and return -ETIME
right away.

Thanks to Frans Pop, who reported the problem and tested the fixes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/hrtimer.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -427,6 +427,8 @@ static int hrtimer_reprogram(struct hrti
 	ktime_t expires = ktime_sub(timer->expires, base->offset);
 	int res;
 
+	WARN_ON_ONCE(timer->expires.tv64 < 0);
+
 	/*
 	 * When the callback is running, we do not reprogram the clock event
 	 * device. The timer callback is either running on a different CPU or
@@ -437,6 +439,15 @@ static int hrtimer_reprogram(struct hrti
 	if (hrtimer_callback_running(timer))
 		return 0;
 
+	/*
+	 * CLOCK_REALTIME timer might be requested with an absolute
+	 * expiry time which is less than base->offset. Nothing wrong
+	 * about that, just avoid to call into the tick code, which
+	 * has now objections against negative expiry values.
+	 */
+	if (expires.tv64 < 0)
+		return -ETIME;
+
 	if (expires.tv64 >= expires_next->tv64)
 		return 0;
 

-- 
