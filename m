Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbZJ2IjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbZJ2IjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZJ2IjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:39:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:47163 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751939AbZJ2IjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:39:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+cEtJwBAWc0gcuWE3XJE5pDkl6iRtPrpLTgPcaK2
	ORGzjvUMwja8F3
Subject: [patch] Re: [regression bisect -next] BUG: using
 smp_processor_id() in preemptible [00000000] code: rmmod
From: Mike Galbraith <efault@gmx.de>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain
Date: Thu, 29 Oct 2009 09:39:12 +0100
Message-Id: <1256805552.7158.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 22:42 -0400, Eric Paris wrote:
> I get a slew of these on boot.

Ouch.  This fix it up for you?

sched: protect task_hot() buddy check.

Eric Paris reported that commit f685ceacab07d3f6c236f04803e2f2f0dbcc5afb
causes boot time PREEMPT_DEBUG complaints.

[    4.590699] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1314
[    4.593043] caller is task_hot+0x86/0xd0
[    4.593872] Pid: 1314, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    4.595443] Call Trace:
[    4.596177]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    4.597337]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    4.598320]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    4.599368]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    4.600354]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    4.601545]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    4.602526]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    4.603811]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    4.604922]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    4.606202]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b

Don't use this_rq() when preemptible.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Eric Paris <eparis@redhat.com>
LKML-Reference: <new-submission>

diff --git a/kernel/sched.c b/kernel/sched.c
index 91ffb01..21f52c4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2008,7 +2008,8 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	/*
 	 * Buddy candidates are cache hot:
 	 */
-	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
+	if (sched_feat(CACHE_HOT_BUDDY) && 
+			(preempt_count() ? this_rq()->nr_running : 1) &&
 			(&p->se == cfs_rq_of(&p->se)->next ||
 			 &p->se == cfs_rq_of(&p->se)->last))
 		return 1;


