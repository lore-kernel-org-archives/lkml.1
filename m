Return-Path: <linux-kernel-owner+w=401wt.eu-S1161328AbXEAStG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161328AbXEAStG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161293AbXEAStG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:49:06 -0400
Received: from mail.screens.ru ([213.234.233.54]:56886 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161149AbXEAStE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:49:04 -0400
Date: Tue, 1 May 2007 22:48:10 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ego@in.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] add-suspend-related-notifications-for-cpu-hotplug-cleanup
Message-ID: <20070501184810.GA1585@tv-sign.ru>
References: <200704260110.22224.rjw@sisk.pl> <20070425165410.b73443b4.akpm@linux-foundation.org> <20070426100922.GB12892@in.ibm.com> <20070426101547.GA97@tv-sign.ru> <20070426125838.GC12892@in.ibm.com> <20070427184258.62794053.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427184258.62794053.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Andrew Morton wrote:
>
> We have a huge amount of change pending in the kthread/workqueue/freezer
> area, partly because I decided not to merge most of the workqueue changes
> into 2.6.21.
> 
> It'd be good if people could take some time to sit down and re-review the
> code which we presently have.  I plan on sending it all off for 2.6.22 and
> there might be some glitches but it seems to have a good track record so
> far.

Oops. I completely misread the ->cpus_allowed check in try_to_wake_up(), and
so workqueue_cpu_callback() needs a simple fix: CPU_UP_CANCELED should rebind
cwq->thread. Or, better, we should not bind the task until CPU_ONLINE.

I'll send the patch soon, but it conflicts with Rafael's

	add-suspend-related-notifications-for-cpu-hotplug.patch

, so I am sending this cleanup first to make them independent.

Actually, I believe almost all subsystems could be simplified as well, most
of them don't care about CPU_TASKS_FROZEN bit.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- OLD/kernel/workqueue.c~1_FROZEN	2007-05-01 22:13:10.000000000 +0400
+++ OLD/kernel/workqueue.c	2007-05-01 22:18:15.000000000 +0400
@@ -747,6 +747,8 @@ static int __devinit workqueue_cpu_callb
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
 
+	action &= ~CPU_TASKS_FROZEN;
+
 	switch (action) {
 	case CPU_LOCK_ACQUIRE:
 		mutex_lock(&workqueue_mutex);
@@ -757,7 +759,6 @@ static int __devinit workqueue_cpu_callb
 		return NOTIFY_OK;
 
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		cpu_set(cpu, cpu_populated_map);
 	}
 
@@ -766,23 +767,19 @@ static int __devinit workqueue_cpu_callb
 
 		switch (action) {
 		case CPU_UP_PREPARE:
-		case CPU_UP_PREPARE_FROZEN:
 			if (!create_workqueue_thread(cwq, cpu))
 				break;
 			printk(KERN_ERR "workqueue for %i failed\n", cpu);
 			return NOTIFY_BAD;
 
 		case CPU_ONLINE:
-		case CPU_ONLINE_FROZEN:
 			wake_up_process(cwq->thread);
 			break;
 
 		case CPU_UP_CANCELED:
-		case CPU_UP_CANCELED_FROZEN:
 			if (cwq->thread)
 				wake_up_process(cwq->thread);
 		case CPU_DEAD:
-		case CPU_DEAD_FROZEN:
 			cleanup_workqueue_thread(cwq, cpu);
 			break;
 		}

