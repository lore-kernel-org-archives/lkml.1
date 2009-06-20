Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbZFTQzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbZFTQzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 12:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZFTQzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 12:55:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42670 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZFTQzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 12:55:44 -0400
Date: Sat, 20 Jun 2009 18:55:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fix
Message-ID: <20090620165540.GA30859@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
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
Eero Nurkkala (1):
      NOHZ: Properly feed cpufreq ondemand governor


 kernel/time/tick-sched.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d3f1ef4..a3562ce 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -222,6 +222,15 @@ void tick_nohz_stop_sched_tick(int inidle)
 
 	cpu = smp_processor_id();
 	ts = &per_cpu(tick_cpu_sched, cpu);
+
+	/*
+	 * Call to tick_nohz_start_idle stops the last_update_time from being
+	 * updated. Thus, it must not be called in the event we are called from
+	 * irq_exit() with the prior state different than idle.
+	 */
+	if (!inidle && !ts->inidle)
+		goto end;
+
 	now = tick_nohz_start_idle(ts);
 
 	/*
@@ -239,9 +248,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
 		goto end;
 
-	if (!inidle && !ts->inidle)
-		goto end;
-
 	ts->inidle = 1;
 
 	if (need_resched())
