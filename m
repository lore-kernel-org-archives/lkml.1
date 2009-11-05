Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbZKEJ5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbZKEJ5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 04:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbZKEJ5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 04:57:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:53874 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750775AbZKEJ5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 04:57:45 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19qQE0TK/tqvLqh09oKnNxGSpRJz+VCoje9wyJnkU
	JSw1xAbFuVT1wE
Subject: Re: [tip:sched/core] sched: Check for an idle shared cache in
 select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       arjan@infradead.org, stable@kernel.org, tglx@linutronix.de
In-Reply-To: <20091105093016.GA18892@elte.hu>
References: <1256654138.17752.7.camel@marge.simson.net>
	 <tip-a1f84a3ab8e002159498814eaa7e48c33752b04b@git.kernel.org>
	 <20091105093016.GA18892@elte.hu>
Content-Type: text/plain
Date: Thu, 05 Nov 2009 10:57:46 +0100
Message-Id: <1257415066.12867.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-05 at 10:30 +0100, Ingo Molnar wrote:
> * tip-bot for Mike Galbraith <efault@gmx.de> wrote:
> 
> > Commit-ID:  a1f84a3ab8e002159498814eaa7e48c33752b04b
> > Gitweb:     http://git.kernel.org/tip/a1f84a3ab8e002159498814eaa7e48c33752b04b
> > Author:     Mike Galbraith <efault@gmx.de>
> > AuthorDate: Tue, 27 Oct 2009 15:35:38 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 4 Nov 2009 18:46:22 +0100
> > 
> > sched: Check for an idle shared cache in select_task_rq_fair()
> 
> -tip testing found that this causes problems:
> 
> [   26.804000] BUG: using smp_processor_id() in preemptible [00000000] code: events/1/10
> [   26.808000] caller is vmstat_update+0x26/0x70
> [   26.812000] Pid: 10, comm: events/1 Not tainted 2.6.32-rc5 #6887
> [   26.816000] Call Trace:
> [   26.820000]  [<c1924a24>] ? printk+0x28/0x3c
> [   26.824000]  [<c13258a0>] debug_smp_processor_id+0xf0/0x110
> [   26.824000] mount used greatest stack depth: 1464 bytes left
> [   26.828000]  [<c111d086>] vmstat_update+0x26/0x70
> [   26.832000]  [<c1086418>] worker_thread+0x188/0x310
> [   26.836000]  [<c10863b7>] ? worker_thread+0x127/0x310
> [   26.840000]  [<c108d310>] ? autoremove_wake_function+0x0/0x60
> [   26.844000]  [<c1086290>] ? worker_thread+0x0/0x310
> [   26.848000]  [<c108cf0c>] kthread+0x7c/0x90
> [   26.852000]  [<c108ce90>] ? kthread+0x0/0x90
> [   26.856000]  [<c100c0a7>] kernel_thread_helper+0x7/0x10
> [   26.860000] BUG: using smp_processor_id() in preemptible [00000000] code: events/1/10
> [   26.864000] caller is vmstat_update+0x3c/0x70
> 
> oh ... doesnt it break cpus_allowed?

Erk, indeed.  You didn't apply the follow-up fix, and I forgot as well.


sched: select_task_rq_fair():: add missing cpu allowed check in commit a1f84a3.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 32f06ed..5488a5d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1415,6 +1415,8 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 
 				if (candidate == -1 || candidate == cpu) {
 					for_each_cpu(i, sched_domain_span(tmp)) {
+						if (!cpumask_test_cpu(i, &p->cpus_allowed))
+							continue;
 						if (!cpu_rq(i)->cfs.nr_running) {
 							candidate = i;
 							break;


