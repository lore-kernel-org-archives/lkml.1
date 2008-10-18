Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYJRTLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYJRTLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbYJRTER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:04:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:47501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbYJRTEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:04:15 -0400
Date: Sat, 18 Oct 2008 11:47:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Dario Faggioli <raistlin@linux.it>,
       Michael Trimarchi <trimarchimichael@yahoo.it>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 05/26] sched_rt.c: resch needed in rt_rq_enqueue() for the
	root rt_rq
Message-ID: <20081018184735.GF301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sched_rt.c-resch-needed-in-rt_rq_enqueue-for-the-root-rt_rq.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Dario Faggioli <raistlin@linux.it>

commit f6121f4f8708195e88cbdf8dd8d171b226b3f858 upstream

While working on the new version of the code for SCHED_SPORADIC I
noticed something strange in the present throttling mechanism. More
specifically in the throttling timer handler in sched_rt.c
(do_sched_rt_period_timer()) and in rt_rq_enqueue().

The problem is that, when unthrottling a runqueue, rt_rq_enqueue() only
asks for rescheduling if the runqueue has a sched_entity associated to
it (i.e., rt_rq->rt_se != NULL).
Now, if the runqueue is the root rq (which has a rt_se = NULL)
rescheduling does not take place, and it is delayed to some undefined
instant in the future.

This imply some random bandwidth usage by the RT tasks under throttling.
For instance, setting rt_runtime_us/rt_period_us = 950ms/1000ms an RT
task will get less than 95%. In our tests we got something varying
between 70% to 95%.
Using smaller time values, e.g., 95ms/100ms, things are even worse, and
I can see values also going down to 20-25%!!

The tests we performed are simply running 'yes' as a SCHED_FIFO task,
and checking the CPU usage with top, but we can investigate thoroughly
if you think it is needed.

Things go much better, for us, with the attached patch... Don't know if
it is the best approach, but it solved the issue for us.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Michael Trimarchi <trimarchimichael@yahoo.it>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched_rt.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -96,12 +96,12 @@ static void dequeue_rt_entity(struct sch
 
 static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
+	struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
 	struct sched_rt_entity *rt_se = rt_rq->rt_se;
 
-	if (rt_se && !on_rt_rq(rt_se) && rt_rq->rt_nr_running) {
-		struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
-
-		enqueue_rt_entity(rt_se);
+	if (rt_rq->rt_nr_running) {
+		if (rt_se && !on_rt_rq(rt_se))
+			enqueue_rt_entity(rt_se);
 		if (rt_rq->highest_prio < curr->prio)
 			resched_task(curr);
 	}

-- 
