Return-Path: <linux-kernel-owner+w=401wt.eu-S1030621AbXCSVlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030621AbXCSVlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030599AbXCSVlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:41:12 -0400
Received: from ns2.suse.de ([195.135.220.15]:59266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030616AbXCSVlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:41:09 -0400
Date: Mon, 19 Mar 2007 14:39:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, mingo@elte.hu,
       tglx@linutronix.de
Subject: [patch 14/31] hrtimer: prevent overrun DoS in hrtimer_forward()
Message-ID: <20070319213920.GP9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hrtimer-prevent-overrun-dos-in-hrtimer_forward.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

hrtimer_forward() does not check for the possible overflow of
timer->expires.  This can happen on 64 bit machines with large interval
values and results currently in an endless loop in the softirq because the
expiry value becomes negative and therefor the timer is expired all the
time.

Check for this condition and set the expiry value to the max.  expiry time
in the future.  The fix should be applied to stable kernel series as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/hrtimer.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -332,6 +332,12 @@ hrtimer_forward(struct hrtimer *timer, k
 		orun++;
 	}
 	timer->expires = ktime_add(timer->expires, interval);
+	/*
+	 * Make sure, that the result did not wrap with a very large
+	 * interval.
+	 */
+	if (timer->expires.tv64 < 0)
+		timer->expires = ktime_set(KTIME_SEC_MAX, 0);
 
 	return orun;
 }

-- 
