Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbZA3Q3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbZA3Q3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 11:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZA3Q3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 11:29:36 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:40140 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbZA3Q3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 11:29:35 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC] NOHZ: fix nohz on cpu unplug
Date: Fri, 30 Jan 2009 17:29:30 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301729.30284.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Thomas,

After using cpu unplug I have seen one cpu with enabled ticks on s390,
even on a idle systems. It turned out that nohz.cpu_mask is not
updated on cpu unplug. 
In select_nohz_load_balancer we check if the system is completely
idle to turn of load balancing. We compare the weights of
cpu_online_map with nohz.cpu_mask.
Since cpu_online_map is updated on cpu unplug, but nohz.cpu_mask is
not, the check fails and the scheduler believes that we need an 
"idle load balancer" even on a fully idle system. Since the ilb 
cpu does not deactivate the timer tick this "breaks" NOHZ.

One possible fix is to only add the cpu to the nohz.cpu_mask,
if the cpu is active.

The alternative is to add nohz.cpu_mask in the cpu hotplug path.

This patch seems to work on s390 (Shortly tested with kvm guests
with cpu hotplug and kvm_stat on the host), but I want to hear your
opinion.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: kvm/kernel/sched.c
===================================================================
--- kvm.orig/kernel/sched.c
+++ kvm/kernel/sched.c
@@ -3880,7 +3880,8 @@ int select_nohz_load_balancer(int stop_t
 	int cpu = smp_processor_id();
 
 	if (stop_tick) {
-		cpumask_set_cpu(cpu, nohz.cpu_mask);
+		if (cpu_active(cpu))
+			cpumask_set_cpu(cpu, nohz.cpu_mask);
 		cpu_rq(cpu)->in_nohz_recently = 1;
 
 		/*
