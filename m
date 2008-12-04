Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbYLDUxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbYLDUxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 15:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYLDUwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 15:52:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41387 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbYLDUwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 15:52:53 -0500
Date: Thu, 4 Dec 2008 21:52:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] timer fixes
Message-ID: <20081204205243.GA6565@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
John Stultz (1):
      time: catch xtime_nsec underflows and fix them

Petr Tesarik (1):
      posix-cpu-timers: fix clock_gettime with CLOCK_PROCESS_CPUTIME_ID


 kernel/posix-cpu-timers.c |    2 +-
 kernel/time/timekeeping.c |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 895337b..4e5288a 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -311,7 +311,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 	struct task_cputime cputime;
 
 	thread_group_cputime(p, &cputime);
-	switch (which_clock) {
+	switch (CPUCLOCK_WHICH(which_clock)) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e7acfb4..fa05e88 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -518,6 +518,28 @@ void update_wall_time(void)
 	/* correct the clock when NTP error is too big */
 	clocksource_adjust(offset);
 
+	/*
+	 * Since in the loop above, we accumulate any amount of time
+	 * in xtime_nsec over a second into xtime.tv_sec, its possible for
+	 * xtime_nsec to be fairly small after the loop. Further, if we're
+	 * slightly speeding the clocksource up in clocksource_adjust(),
+	 * its possible the required corrective factor to xtime_nsec could
+	 * cause it to underflow.
+	 *
+	 * Now, we cannot simply roll the accumulated second back, since
+	 * the NTP subsystem has been notified via second_overflow. So
+	 * instead we push xtime_nsec forward by the amount we underflowed,
+	 * and add that amount into the error.
+	 *
+	 * We'll correct this error next time through this function, when
+	 * xtime_nsec is not as small.
+	 */
+	if (unlikely((s64)clock->xtime_nsec < 0)) {
+		s64 neg = -(s64)clock->xtime_nsec;
+		clock->xtime_nsec = 0;
+		clock->error += neg << (NTP_SCALE_SHIFT - clock->shift);
+	}
+
 	/* store full nanoseconds into xtime after rounding it up and
 	 * add the remainder to the error difference.
 	 */
