Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbZBBMX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbZBBMX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 07:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbZBBMXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 07:23:50 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:50928 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZBBMXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 07:23:49 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Suresh B <suresh.b.siddha@intel.com>
Subject: [PATCH v2] NOHZ: fix nohz on cpu unplug
Date: Mon, 2 Feb 2009 13:23:43 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <200901301729.30284.borntraeger@de.ibm.com> <200902021058.45230.borntraeger@de.ibm.com>
In-Reply-To: <200902021058.45230.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902021323.44015.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After some testing, I think this patch is better:
[PATCH] NOHZ: fix nohz on cpu unplug

From: Christian Borntraeger <borntraeger@de.ibm.com>

After using cpu unplug I have seen one cpu with full ticks, even
on a idle systems. It turns out that nohz.cpu_mask is not updated on
cpu unplug. 
In select_nohz_load_balancer we check if the system is completely
idle to turn of load balancing. We compare cpu_online_map with
nohz.cpu_mask.
Since cpu_online_map is updated on cpu unplug, but nohz.cpu_mask is
not, the check fails and the scheduler believes that we need an 
"idle load balancer" even on a fully idle system. Since the ilb 
cpu does not deactivate the timer tick this breaks NOHZ.

This patch clear the nohz bits in the migration_call, a function that
is already called by the cpu hotplug notifier.

Opinions?

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 kernel/sched.c |    1 +
 1 file changed, 1 insertion(+)

Index: kvm/kernel/sched.c
===================================================================
--- kvm.orig/kernel/sched.c
+++ kvm/kernel/sched.c
@@ -6696,6 +6696,7 @@ migration_call(struct notifier_block *nf
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
 		spin_unlock_irq(&rq->lock);
+		cpumask_clear_cpu(cpu, nohz.cpu_mask);
 		cpuset_unlock();
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
