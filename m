Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbZCLK0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbZCLK0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZCLKZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:25:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:44964 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421AbZCLKZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:25:30 -0400
Date: Thu, 12 Mar 2009 10:24:51 GMT
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, arjan@linux.intel.com, rusty@rustcorp.com.au,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       arjan@linux.intel.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090312075559.9856.28822.stgit@Aeon>
References: <20090312075559.9856.28822.stgit@Aeon>
Subject: [tip:core/futexes] futex: use current->time_slack_ns for rt tasks too
Message-ID: <tip-16f4993f4e9860715918efd4eeac928f8de1218b@git.kernel.org>
Git-Commit-ID: 16f4993f4e9860715918efd4eeac928f8de1218b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Mar 2009 10:24:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16f4993f4e9860715918efd4eeac928f8de1218b
Gitweb:     http://git.kernel.org/tip/16f4993f4e9860715918efd4eeac928f8de1218b
Author:     "Darren Hart" <dvhltc@us.ibm.com>
AuthorDate: Thu, 12 Mar 2009 00:55:59 -0700
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Mar 2009 11:20:57 +0100

futex: use current->time_slack_ns for rt tasks too

RT tasks should set their timer slack to 0 on their own.  This
patch removes the 'if (rt_task()) slack = 0;' block in
futex_wait.

Build and boot tested on a 4 way Intel x86_64 workstation.
Passes basic pthread_mutex and PI tests out of
ltp/testcases/realtime.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <20090312075559.9856.28822.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/futex.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e149545..6579912 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1253,16 +1253,13 @@ retry:
 		if (!abs_time)
 			schedule();
 		else {
-			unsigned long slack;
-			slack = current->timer_slack_ns;
-			if (rt_task(current))
-				slack = 0;
 			hrtimer_init_on_stack(&t.timer,
 					      clockrt ? CLOCK_REALTIME :
 					      CLOCK_MONOTONIC,
 					      HRTIMER_MODE_ABS);
 			hrtimer_init_sleeper(&t, current);
-			hrtimer_set_expires_range_ns(&t.timer, *abs_time, slack);
+			hrtimer_set_expires_range_ns(&t.timer, *abs_time,
+						     current->timer_slack_ns);
 
 			hrtimer_start_expires(&t.timer, HRTIMER_MODE_ABS);
 			if (!hrtimer_active(&t.timer))
