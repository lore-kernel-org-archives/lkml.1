Return-Path: <linux-kernel-owner+w=401wt.eu-S965576AbXCGRaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965576AbXCGRaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422874AbXCGR33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:29:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422821AbXCGRRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:17:20 -0500
Message-Id: <20070307171536.462274845@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 075/101] sched: fix SMT scheduler bug
Content-Disposition: inline; filename=sched-fix-smt-scheduler-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

[PATCH] sched: fix SMT scheduler bug

The SMT scheduler incorrectly skips kernel threads even if they are
runnable (but they are preempted by a higher-prio user-space task which got
SMT-delayed by an even higher-priority task running on a sibling CPU).

Fix this for now by only doing the SMT-nice optimization if the
to-be-delayed task is the only runnable task.  (This should cover most of
the real-life cases anyway.)

This bug has been in the SMT scheduler since 2.6.17 or so, but has only
been noticed now by the active check in the dynticks code.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/kernel/sched.c
+++ linux-2.6.20.1/kernel/sched.c
@@ -3528,7 +3528,7 @@ need_resched_nonpreemptible:
 		}
 	}
 	next->sleep_type = SLEEP_NORMAL;
-	if (dependent_sleeper(cpu, rq, next))
+	if (rq->nr_running == 1 && dependent_sleeper(cpu, rq, next))
 		next = rq->idle;
 switch_tasks:
 	if (next == rq->idle)

--
