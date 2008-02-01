Return-Path: <linux-kernel-owner+w=401wt.eu-S1762346AbYBAMF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762346AbYBAMF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbYBAMFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:05:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56439 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbYBAMFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:05:19 -0500
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during
	suspend/hibernation on x86-64 (bisected)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <200801312154.33754.rjw@sisk.pl>
References: <200801272229.48955.rjw@sisk.pl>
	 <200801280226.22013.rjw@sisk.pl> <1201795128.32654.22.camel@lappy>
	 <200801312154.33754.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 13:04:57 +0100
Message-Id: <1201867497.32654.49.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 21:54 +0100, Rafael J. Wysocki wrote:
> On Thursday, 31 of January 2008, Peter Zijlstra wrote:

> > I can seem to reproduce this:
> > 
> > [root@opteron cpu1]# time echo 0 > online
> > 
> > real    0m6.230s
> > user    0m0.000s
> > sys     0m0.010s
> > [root@opteron cpu1]# echo 1 > online
> > [root@opteron cpu1]# time echo 0 > online
> > 
> > real    0m7.966s
> > user    0m0.000s
> > sys     0m0.011s
> > 
> > 
> > I'll have a look at it.
> 
> Much appreciated, thanks!

The below fixes it for me..

---
 - restore the old wakeup mechanism
 - fix break usage in do_each_thread() { } while_eac_thread().
 - fix the hotplug switch stmt, a fall-through case was broken.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index c1d7655..7c2da88 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -101,6 +101,10 @@ void softlockup_tick(void)
 
 	now = get_timestamp(this_cpu);
 
+	/* Wake up the high-prio watchdog task every second: */
+	if (now > (touch_timestamp + 1))
+		wake_up_process(per_cpu(watchdog_task, this_cpu));
+
 	/* Warn about unreasonable delays: */
 	if (now <= (touch_timestamp + softlockup_thresh))
 		return;
@@ -191,11 +195,11 @@ static void check_hung_uninterruptible_tasks(int this_cpu)
 	read_lock(&tasklist_lock);
 	do_each_thread(g, t) {
 		if (!--max_count)
-			break;
+			goto unlock;
 		if (t->state & TASK_UNINTERRUPTIBLE)
 			check_hung_task(t, now);
 	} while_each_thread(g, t);
-
+ unlock:
 	read_unlock(&tasklist_lock);
 }
 
@@ -218,14 +222,19 @@ static int watchdog(void *__bind_cpu)
 	 * debug-printout triggers in softlockup_tick().
 	 */
 	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
 		touch_softlockup_watchdog();
-		msleep_interruptible(10000);
+		schedule();
+
+		if (kthread_should_stop())
+			break;
 
 		if (this_cpu != check_cpu)
 			continue;
 
 		if (sysctl_hung_task_timeout_secs)
 			check_hung_uninterruptible_tasks(this_cpu);
+
 	}
 
 	return 0;
@@ -259,13 +268,6 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		wake_up_process(per_cpu(watchdog_task, hotcpu));
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		if (!per_cpu(watchdog_task, hotcpu))
-			break;
-		/* Unbind so it can run.  Fall thru. */
-		kthread_bind(per_cpu(watchdog_task, hotcpu),
-			     any_online_cpu(cpu_online_map));
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		if (hotcpu == check_cpu) {
@@ -275,6 +277,14 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 			check_cpu = any_online_cpu(temp_cpu_online_map);
 		}
 		break;
+
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		if (!per_cpu(watchdog_task, hotcpu))
+			break;
+		/* Unbind so it can run.  Fall thru. */
+		kthread_bind(per_cpu(watchdog_task, hotcpu),
+			     any_online_cpu(cpu_online_map));
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		p = per_cpu(watchdog_task, hotcpu);


