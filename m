Return-Path: <linux-kernel-owner+w=401wt.eu-S1762954AbYFWToQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762954AbYFWToQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYFWToE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:44:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39372 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbYFWToC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:44:02 -0400
Date: Mon, 23 Jun 2008 21:43:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20080623194345.GA30767@elte.hu>
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

please pull the latest scheduler fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

(note: i included the related wait_for_completion_timeout() cleanup from 
Oleg as well because it was tested together.)

	Ingo

------------------>
Oleg Nesterov (1):
      sched: refactor wait_for_completion_timeout()

Peter Zijlstra (1):
      sched: rt: dont stop the period timer when there are tasks wanting to run

Roland Dreier (1):
      sched: fix wait_for_completion_timeout() spurious failure under heavy load

 kernel/sched.c    |   14 ++++++--------
 kernel/sched_rt.c |    3 ++-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b048ad8..3aaa5c8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4398,22 +4398,20 @@ do_wait_for_common(struct completion *x, long timeout, int state)
 			     signal_pending(current)) ||
 			    (state == TASK_KILLABLE &&
 			     fatal_signal_pending(current))) {
-				__remove_wait_queue(&x->wait, &wait);
-				return -ERESTARTSYS;
+				timeout = -ERESTARTSYS;
+				break;
 			}
 			__set_current_state(state);
 			spin_unlock_irq(&x->wait.lock);
 			timeout = schedule_timeout(timeout);
 			spin_lock_irq(&x->wait.lock);
-			if (!timeout) {
-				__remove_wait_queue(&x->wait, &wait);
-				return timeout;
-			}
-		} while (!x->done);
+		} while (!x->done && timeout);
 		__remove_wait_queue(&x->wait, &wait);
+		if (!x->done)
+			return timeout;
 	}
 	x->done--;
-	return timeout;
+	return timeout ?: 1;
 }
 
 static long __sched
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 1dad5bb..0f3c191 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -250,7 +250,8 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 			if (rt_rq->rt_time || rt_rq->rt_nr_running)
 				idle = 0;
 			spin_unlock(&rt_rq->rt_runtime_lock);
-		}
+		} else if (rt_rq->rt_nr_running)
+			idle = 0;
 
 		if (enqueue)
 			sched_rt_rq_enqueue(rt_rq);
