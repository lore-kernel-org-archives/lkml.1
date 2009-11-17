Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbZKQM6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbZKQM6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbZKQM6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:58:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbZKQM6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:58:36 -0500
Date: Tue, 17 Nov 2009 13:57:03 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] posix-cpu-timers: reset expire cache when no timer is
	running
Message-ID: <20091117125702.GA3658@dhcp-lab-161.englab.brq.redhat.com>
References: <4AF26176.4080307@jp.fujitsu.com> <1257778154.4108.341.camel@laptop> <20091109172020.GA7751@redhat.com> <1257787903.4108.345.camel@laptop> <20091109192355.GA13724@redhat.com> <20091110104452.GB2391@dhcp-lab-161.englab.brq.redhat.com> <20091110174008.GA12909@redhat.com> <20091110182415.GB6066@dhcp-lab-161.englab.brq.redhat.com> <20091110192327.GA16325@redhat.com> <20091117124851.GA3616@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117124851.GA3616@dhcp-lab-161.englab.brq.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When process delete cpu timer or timer expires we do not clear
expiration cache sig->cputimer_expires. This create situation when in
fastpath_timer_check() we _on_ cputimer (together with loop on all
threads) just to turn in off in check_process_timers(). We not
necessary go to slowpath and not necessary loop on all threads in
fastpath - and this is repeated on every tick.

To fix we zero sig->cputimer_expires in stop_process_timers().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/posix-cpu-timers.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 5c9dc22..ac54986 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1061,9 +1061,9 @@ static void check_thread_timers(struct task_struct *tsk,
 	}
 }
 
-static void stop_process_timers(struct task_struct *tsk)
+static void stop_process_timers(struct signal_struct *sig)
 {
-	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
+	struct thread_group_cputimer *cputimer = &sig->cputimer;
 	unsigned long flags;
 
 	if (!cputimer->running)
@@ -1072,6 +1072,10 @@ static void stop_process_timers(struct task_struct *tsk)
 	spin_lock_irqsave(&cputimer->lock, flags);
 	cputimer->running = 0;
 	spin_unlock_irqrestore(&cputimer->lock, flags);
+
+	sig->cputime_expires.prof_exp = cputime_zero;
+	sig->cputime_expires.virt_exp = cputime_zero;
+	sig->cputime_expires.sched_exp = 0;
 }
 
 static u32 onecputick;
@@ -1132,7 +1136,7 @@ static void check_process_timers(struct task_struct *tsk,
 	    list_empty(&timers[CPUCLOCK_VIRT]) &&
 	    cputime_eq(sig->it[CPUCLOCK_VIRT].expires, cputime_zero) &&
 	    list_empty(&timers[CPUCLOCK_SCHED])) {
-		stop_process_timers(tsk);
+		stop_process_timers(sig);
 		return;
 	}
 
-- 
1.6.2.5

