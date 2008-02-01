Return-Path: <linux-kernel-owner+w=401wt.eu-S1762226AbYBAX0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762226AbYBAX0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760897AbYBAX0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:26:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49974 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760779AbYBAX0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:26:34 -0500
Date: Sat, 2 Feb 2008 00:25:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <srostedt@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during
	suspend/hibernation on x86-64 (bisected)
Message-ID: <20080201232550.GA682@elte.hu>
References: <200801280226.22013.rjw@sisk.pl> <1201795128.32654.22.camel@lappy> <200801312154.33754.rjw@sisk.pl> <1201867497.32654.49.camel@lappy> <b647ffbd0802010711q744f5023mdbfccd9540556b70@mail.gmail.com> <20080201171022.GC2159@elte.hu> <b647ffbd0802011354ra2b9494ub59475abad4466aa@mail.gmail.com> <b647ffbd0802011444n366c1537m7fb44acf0b848941@mail.gmail.com> <20080201224852.GA16700@elte.hu> <b647ffbd0802011522y3d4d779ambaf1a21f368ef74a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0802011522y3d4d779ambaf1a21f368ef74a@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> yeah, I was already on a half-way to check it out.
> 
> It does fix a problem for me.
> 
> Don't forget to take along these 2 fixes from Peter's patch:
> 
> - fix break usage in do_each_thread() { } while_each_thread().
> - fix the hotplug switch stmt, a fall-through case was broken.

Dmitry, i sent Peter's fix(es) below to Linus. Do you concur that it 
fixes all the practical and theoretical problems you could see with the 
code too?

	Ingo

--------------->
Subject: debug: softlockup looping fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Rafael J. Wysocki reported weird, multi-seconds delays during
suspend/resume and bisected it back to:

  commit 82a1fcb90287052aabfa235e7ffc693ea003fe69
  Author: Ingo Molnar <mingo@elte.hu>
  Date:   Fri Jan 25 21:08:02 2008 +0100

      softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks

fix it:

 - restore the old wakeup mechanism
 - fix break usage in do_each_thread() { } while_each_thread().
 - fix the hotplug switch stmt, a fall-through case was broken.

Bisected-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/softlockup.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

Index: linux/kernel/softlockup.c
===================================================================
--- linux.orig/kernel/softlockup.c
+++ linux/kernel/softlockup.c
@@ -101,6 +101,10 @@ void softlockup_tick(void)
 
 	now = get_timestamp(this_cpu);
 
+	/* Wake up the high-prio watchdog task every second: */
+	if (now > (touch_timestamp + 1))
+		wake_up_process(per_cpu(watchdog_task, this_cpu));
+
 	/* Warn about unreasonable delays: */
 	if (now <= (touch_timestamp + softlockup_thresh))
 		return;
@@ -191,11 +195,11 @@ static void check_hung_uninterruptible_t
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
@@ -259,13 +268,6 @@ cpu_callback(struct notifier_block *nfb,
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
@@ -275,6 +277,14 @@ cpu_callback(struct notifier_block *nfb,
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
