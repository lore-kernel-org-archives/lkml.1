Return-Path: <linux-kernel-owner+w=401wt.eu-S1764564AbYBTVeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764564AbYBTVeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYBTVeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:34:09 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:57474 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbYBTVeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:34:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fWv+8XgVHg+yk901Q4mhS1559+sL7HiEdJ+Gh3paW2AE7u22/pWHqWWKW+fo3Iq4yoqlN+zP/dAjB2uib59V/NG7FUFeVQ+bLUQZP0Yiu0u3ZdeBIAVcqmJ75QtdV0Q2+7+JJJAwJZ2TmY/LtkuqJOZ5zmlMcOrEqj4VUZzh6Bs=
Subject: [PATCH 0/2] kthread: synchronization issues
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russel <rusty@rustcorp.com.au>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 22:34:00 +0100
Message-Id: <1203543240.6307.20.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ I've taken the liberty of CC'ing people who replied on my previous
message dedicated to this topic ]

Andrew,

could you please check whether this series makes any difference
on the 'permanent-pause-upon-power-off' issue you observed earlier?

You would also need to take along another fix (included below).
Although, I've sent it to you for -mm inclusion a few days ago.

And sure, remove that 'magic' msleep(1) thing in softlockup.c ::
cpu_callback() :-)

Thanks in advance.

[PATCH 1/2] kthread: add a missing memory barrier to kthread_stop()
[PATCH 2/2] kthread: call wake_up_process() whithout the lock being held

---

(this one is from Ingo's sched-devel tree)

softlockup: fix task state setting

kthread_stop() can be called when a 'watchdog' thread is executing after
kthread_should_stop() but before set_task_state(TASK_INTERRUPTIBLE).

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 7c2da88..b0fdb49 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -216,26 +216,25 @@ static int watchdog(void *__bind_cpu)
 	/* initialize timestamp */
 	touch_softlockup_watchdog();
 
+	set_current_state(TASK_INTERRUPTIBLE);
 	/*
 	 * Run briefly once per second to reset the softlockup timestamp.
 	 * If this gets delayed for more than 60 seconds then the
 	 * debug-printout triggers in softlockup_tick().
 	 */
 	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
 		touch_softlockup_watchdog();
 		schedule();
 
 		if (kthread_should_stop())
 			break;
 
-		if (this_cpu != check_cpu)
-			continue;
-
-		if (sysctl_hung_task_timeout_secs)
+		if (this_cpu == check_cpu && sysctl_hung_task_timeout_secs)
 			check_hung_uninterruptible_tasks(this_cpu);
 
+		set_current_state(TASK_INTERRUPTIBLE);
 	}
+	__set_current_state(TASK_RUNNING);
 
 	return 0;
 }


