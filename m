Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZJZQLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZJZQLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZJZQLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:11:30 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:37076 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbZJZQL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=Fh7LbqiGtpKLQBbMQ38sw8I23rWuxqjIqcwmm06XO32k2kBWoIoMmQb/KYrDDxnjt6
         cuNhToOn0keezE/4+fnfWUnIzHwlPaKKgYDQgm00k3Gl/pVM7+7c0Za9frSz44Pf1s2p
         20qy8MFOocULFMBltj1nz6SipqKX6+w1iQny0=
MIME-Version: 1.0
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Mon, 26 Oct 2009 14:11:13 -0200
Message-ID: <193b0f820910260911p218c0c1dn1986c48c7ecf6ee2@mail.gmail.com>
Subject: Bug when changing cpus_allowed of RT tasks?
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think there's a problem when balancing RT tasks: both find_lowest_rq_rt and
select_task_rq_rt check for p->rt.nr_cpus_allowed being greater than 1 to wake
a task in another cpu:

	static int select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
	{
		[...]
		if (unlikely(rt_task(rq->curr)) &&
		    (p->rt.nr_cpus_allowed > 1)) {
			int cpu = find_lowest_rq(p);

			return (cpu == -1) ? task_cpu(p) : cpu;
		}
		[...]
	}

	static int find_lowest_rq(struct task_struct *task)
	{
		struct sched_domain *sd;
		struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
		int this_cpu = smp_processor_id();
		int cpu      = task_cpu(task);
		cpumask_var_t domain_mask;

		if (task->rt.nr_cpus_allowed == 1)
			return -1; /* No other targets possible */
		[...]
	}


What happens if rt.nr_cpus_allowed continues to be 1, but the allowed cpu is
not the one in which task is being woken up? Since set_cpus_allowed_rt just
changed the mask and updated the value of nr_cpus_allowed_rt, as far as I can
see, it remains on same CPU even if the new mask does not allow.

A possible fix below, and in case it is right:
	Signed-off-by: Lucas De Marchi <lucas.de.marchi@gmail.com>



Lucas De Marchi


--

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a4d790c..531c946 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -962,8 +962,7 @@ static int select_task_rq_rt(struct task_struct
*p, int sd_flag, int flags)
 	 * that is just being woken and probably will have
 	 * cold cache anyway.
 	 */
-	if (unlikely(rt_task(rq->curr)) &&
-	    (p->rt.nr_cpus_allowed > 1)) {
+	if (unlikely(rt_task(rq->curr))) {
 		int cpu = find_lowest_rq(p);

 		return (cpu == -1) ? task_cpu(p) : cpu;
@@ -1177,7 +1176,8 @@ static int find_lowest_rq(struct task_struct *task)
 	int cpu      = task_cpu(task);
 	cpumask_var_t domain_mask;

-	if (task->rt.nr_cpus_allowed == 1)
+	if ((task->rt.nr_cpus_allowed == 1) &&
+			likely(cpumask_test_cpu(cpu, &task->cpus_allowed)))
 		return -1; /* No other targets possible */

 	if (!cpupri_find(&task_rq(task)->rd->cpupri, task, lowest_mask))
