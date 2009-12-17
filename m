Return-Path: <linux-kernel-owner+w=401wt.eu-S1763610AbZLQEDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763610AbZLQEDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763237AbZLQEDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:03:46 -0500
Received: from kroah.org ([198.145.64.141]:55266 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761781AbZLQEDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:40 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:44 2009
Message-Id: <20091217035644.657581252@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       arjan@infradead.org, Ingo Molnar <mingo@elte.hu>
Subject: [013/151] sched: Fix affinity logic in select_task_rq_fair()
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Galbraith <efault@gmx.de>

commit fd210738f6601d0fb462df9a2fe5a41896ff6a8f upstream.

Ingo Molnar reported:

[   26.804000] BUG: using smp_processor_id() in preemptible [00000000] code: events/1/10
[   26.808000] caller is vmstat_update+0x26/0x70
[   26.812000] Pid: 10, comm: events/1 Not tainted 2.6.32-rc5 #6887
[   26.816000] Call Trace:
[   26.820000]  [<c1924a24>] ? printk+0x28/0x3c
[   26.824000]  [<c13258a0>] debug_smp_processor_id+0xf0/0x110
[   26.824000] mount used greatest stack depth: 1464 bytes left
[   26.828000]  [<c111d086>] vmstat_update+0x26/0x70
[   26.832000]  [<c1086418>] worker_thread+0x188/0x310
[   26.836000]  [<c10863b7>] ? worker_thread+0x127/0x310
[   26.840000]  [<c108d310>] ? autoremove_wake_function+0x0/0x60
[   26.844000]  [<c1086290>] ? worker_thread+0x0/0x310
[   26.848000]  [<c108cf0c>] kthread+0x7c/0x90
[   26.852000]  [<c108ce90>] ? kthread+0x0/0x90
[   26.856000]  [<c100c0a7>] kernel_thread_helper+0x7/0x10
[   26.860000] BUG: using smp_processor_id() in preemptible [00000000] code: events/1/10
[   26.864000] caller is vmstat_update+0x3c/0x70

Because this commit:

  a1f84a3: sched: Check for an idle shared cache in select_task_rq_fair()

broke ->cpus_allowed.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: arjan@infradead.org
LKML-Reference: <1257415066.12867.1.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched_fair.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1415,6 +1415,8 @@ static int select_task_rq_fair(struct ta
 
 				if (candidate == -1 || candidate == cpu) {
 					for_each_cpu(i, sched_domain_span(tmp)) {
+						if (!cpumask_test_cpu(i, &p->cpus_allowed))
+							continue;
 						if (!cpu_rq(i)->cfs.nr_running) {
 							candidate = i;
 							break;


