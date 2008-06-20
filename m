Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbYFTPVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbYFTPVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756502AbYFTPVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:21:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34489 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739AbYFTPVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:21:46 -0400
Date: Fri, 20 Jun 2008 17:21:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Jiri Slaby <jirislaby@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org, Eli Cohen <eli@dev.mellanox.co.il>,
       general@lists.openfabrics.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: wait_for_completion_timeout() spurious failure under heavy
	load?
Message-ID: <20080620152124.GC17373@elte.hu>
References: <ada63s5w088.fsf@cisco.com> <485B50F1.2020802@gmail.com> <20080620112042.GE7439@elte.hu> <20080620141400.GA411@tv-sign.ru> <20080620143220.GA441@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620143220.GA441@tv-sign.ru>
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


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> > IOW, how about the patch below? this also makes the code a bit 
> > simpler because we factor out __remove_wait_queue().
> 
> Even better, we can kill the first __remove_wait_queue() as well.

nice, thanks - applied it in the form below to tip/sched/urgent.

	Ingo

------------------>
commit 6b8464474776dccf619283ee5510b0b795382dfb
Author: Oleg Nesterov <oleg@tv-sign.ru>
Date:   Fri Jun 20 18:32:20 2008 +0400

    sched: refactor wait_for_completion_timeout()
    
    Simplify the code and fix the boundary condition of
    wait_for_completion_timeout(,0).
    
    We can kill the first __remove_wait_queue() as well.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched.c b/kernel/sched.c
index 577f160..bebf978 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4398,32 +4398,20 @@ do_wait_for_common(struct completion *x, long timeout, int state)
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
-
-			/*
-			 * If the completion has arrived meanwhile
-			 * then return 1 jiffy time left:
-			 */
-			if (x->done && !timeout) {
-				timeout = 1;
-				break;
-			}
-
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
