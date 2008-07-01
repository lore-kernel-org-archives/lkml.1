Return-Path: <linux-kernel-owner+w=401wt.eu-S1759882AbYGAT7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882AbYGAT7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYGAT7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:59:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58319 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbYGAT7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:59:15 -0400
Date: Tue, 1 Jul 2008 21:59:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] rcu fix
Message-ID: <20080701195858.GA2740@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Linus,

Please pull the latest RCU fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

Thanks,

	Ingo

------------------>
Gautham R Shenoy (1):
      rcu: fix hotplug vs rcu race

 kernel/rcuclassic.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index f4ffbd0..a38895a 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -89,8 +89,22 @@ static void force_quiescent_state(struct rcu_data *rdp,
 		/*
 		 * Don't send IPI to itself. With irqs disabled,
 		 * rdp->cpu is the current cpu.
+		 *
+		 * cpu_online_map is updated by the _cpu_down()
+		 * using stop_machine_run(). Since we're in irqs disabled
+		 * section, stop_machine_run() is not exectuting, hence
+		 * the cpu_online_map is stable.
+		 *
+		 * However,  a cpu might have been offlined _just_ before
+		 * we disabled irqs while entering here.
+		 * And rcu subsystem might not yet have handled the CPU_DEAD
+		 * notification, leading to the offlined cpu's bit
+		 * being set in the rcp->cpumask.
+		 *
+		 * Hence cpumask = (rcp->cpumask & cpu_online_map) to prevent
+		 * sending smp_reschedule() to an offlined CPU.
 		 */
-		cpumask = rcp->cpumask;
+		cpus_and(cpumask, rcp->cpumask, cpu_online_map);
 		cpu_clear(rdp->cpu, cpumask);
 		for_each_cpu_mask(cpu, cpumask)
 			smp_send_reschedule(cpu);
