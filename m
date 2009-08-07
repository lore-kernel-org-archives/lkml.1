Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZHGWVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZHGWVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 18:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZHGWU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 18:20:59 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40921 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbZHGWU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 18:20:58 -0400
Message-ID: <4A7CA8C0.7010809@us.ibm.com>
Date: Fri, 07 Aug 2009 15:20:48 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: [PATCH V2] futex: Fix handling of bad requeue syscall pairing
References: <4A7CA06E.1090904@us.ibm.com>
In-Reply-To: <4A7CA06E.1090904@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhltc@us.ibm.com>

If futex_requeue(requeue_pi=1) finds a futex_q that was created by a call
other the futex_wait_requeue_pi(), the q.rt_waiter may be null.  If so,
this will result in an oops from the following call graph:

futex_requeue()
  rt_mutex_start_proxy_lock()
    task_blocks_on_rt_mutex()
      waiter->task dereference
        OOPS

We currently WARN_ON() if this is detected, clearly this is inadequate.
If we detect a mispairing in futex_requeue(), bail out, seding -EINVAL to
user-space.

V2: Fix parenthesis warnings.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
---

 kernel/futex.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/kernel/futex.c b/kernel/futex.c
index df30983..4705d89 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1306,8 +1306,15 @@ retry_private:
 		if (!match_futex(&this->key, &key1))
 			continue;
 
-		WARN_ON(!requeue_pi && this->rt_waiter);
-		WARN_ON(requeue_pi && !this->rt_waiter);
+		/*
+		 * FUTEX_WAIT_REQEUE_PI and FUTEX_CMP_REQUEUE_PI should always
+		 * be paired with each other and no other futex ops.
+		 */
+		if ((requeue_pi && !this->rt_waiter) ||
+		    (!requeue_pi && this->rt_waiter)) {
+			ret = -EINVAL;
+			break;
+		}
 
 		/*
 		 * Wake nr_wake waiters.  For requeue_pi, if we acquired the
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
