Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbYJUT37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbYJUT37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYJUT3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:29:51 -0400
Received: from www.tglx.de ([62.245.132.106]:60531 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbYJUT3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:29:51 -0400
Date: Tue, 21 Oct 2008 21:29:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [GIT pull] timers bugfix for .28
Message-ID: <alpine.LFD.2.00.0810212053120.3301@apollo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest v28-timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git v28-timers-for-linus

A single bugfix for a brown paperbag thinko introduced by myself.

Thanks,

	tglx 
------------------>
Thomas Gleixner (1):
      NOHZ: fix thinko in the timer restart code path


 kernel/time/tick-sched.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 0581c11..727c1ae 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -567,11 +567,21 @@ static void tick_nohz_switch_to_nohz(void)
 static void tick_nohz_kick_tick(int cpu)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t delta, now;
 
 	if (!ts->tick_stopped)
 		return;
 
-	tick_nohz_restart(ts, ktime_get());
+	/*
+	 * Do not touch the tick device, when the next expiry is either
+	 * already reached or less/equal than the tick period.
+	 */
+	now = ktime_get();
+	delta =	ktime_sub(ts->sched_timer.expires, now);
+	if (delta.tv64 <= tick_period.tv64)
+		return;
+
+	tick_nohz_restart(ts, now);
 }
 
 #else
