Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbYJGA57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbYJGA57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757855AbYJGApU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:45:20 -0400
Received: from ns.suse.de ([195.135.220.2]:47011 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672AbYJGApT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:45:19 -0400
Date: Mon, 6 Oct 2008 17:39:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Maciej W. Rozycki" <macro@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 48/71] ntp: fix calculation of the next jiffie to trigger
	RTC sync
Message-ID: <20081007003932.GW3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="timer-fix-10.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Maciej W. Rozycki <macro@linux-mips.org>

commit 4ff4b9e19a80b73959ebeb28d1df40176686f0a8 upstream

We have a bug in the calculation of the next jiffie to trigger the RTC
synchronisation.  The aim here is to run sync_cmos_clock() as close as
possible to the middle of a second.  Which means we want this function to
be called less than or equal to half a jiffie away from when now.tv_nsec
equals 5e8 (500000000).

If this is not the case for a given call to the function, for this purpose
instead of updating the RTC we calculate the offset in nanoseconds to the
next point in time where now.tv_nsec will be equal 5e8.  The calculated
offset is then converted to jiffies as these are the unit used by the
timer.

Hovewer timespec_to_jiffies() used here uses a ceil()-type rounding mode,
where the resulting value is rounded up.  As a result the range of
now.tv_nsec when the timer will trigger is from 5e8 to 5e8 + TICK_NSEC
rather than the desired 5e8 - TICK_NSEC / 2 to 5e8 + TICK_NSEC / 2.

As a result if for example sync_cmos_clock() happens to be called at the
time when now.tv_nsec is between 5e8 + TICK_NSEC / 2 and 5e8 to 5e8 +
TICK_NSEC, it will simply be rescheduled HZ jiffies later, falling in the
same range of now.tv_nsec again.  Similarly for cases offsetted by an
integer multiple of TICK_NSEC.

This change addresses the problem by subtracting TICK_NSEC / 2 from the
nanosecond offset to the next point in time where now.tv_nsec will be
equal 5e8, effectively shifting the following rounding in
timespec_to_jiffies() so that it produces a rounded-to-nearest result.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/ntp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -245,7 +245,7 @@ static void sync_cmos_clock(unsigned lon
 	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
 		fail = update_persistent_clock(now);
 
-	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec;
+	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec - (TICK_NSEC / 2);
 	if (next.tv_nsec <= 0)
 		next.tv_nsec += NSEC_PER_SEC;
 

-- 
