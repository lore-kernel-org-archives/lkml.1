Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYGJHk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYGJHk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbYGJHkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:40:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60058 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbYGJHkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:40:10 -0400
Date: Thu, 10 Jul 2008 09:39:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, miaox@cn.fujitsu.com,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@qumranet.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] CFS vs cpu hotplug
Message-ID: <20080710073938.GB21543@elte.hu>
References: <1215642760.5310.12.camel@earth> <20080710073055.GA7127@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710073055.GA7127@osiris.boeblingen.de.ibm.com>
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


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> > Subject: sched: prevent a potentially endless loop in 
> > move_task_off_dead_cpu()
> > 
> > Interrupts are enabled on other CPUs when migration_call(CPU_DEAD, 
> > ...) is called so we may get a race between try_to_wake_up() and 
> > migrate_live_tasks() -> move_task_off_dead_cpu(). The former one may 
> > push a task out of a dead CPU causing the later one to loop 
> > endlessly.
> 
> That's exactly what explains a dump I got yesterday. Thanks for 
> fixing! :)

applied to tip/sched/urgent via the commit below - lets see whether we 
can still get it into v2.6.26.

	Ingo

---------------->
commit dc7fab8b3bb388c57c6c4a43ba68c8a32ca25204
Author: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Date:   Thu Jul 10 00:32:40 2008 +0200

    sched: fix cpu hotplug
    
    I think we may have a race between try_to_wake_up() and
    migrate_live_tasks() -> move_task_off_dead_cpu() when the later one
    may end up looping endlessly.
    
    Interrupts are enabled on other CPUs when migration_call(CPU_DEAD, ...) is
    called so we may get a race between try_to_wake_up() and
    migrate_live_tasks() -> move_task_off_dead_cpu(). The former one may push
    a task out of a dead CPU causing the later one to loop endlessly.
    
    Heiko Carstens observed:
    
    | That's exactly what explains a dump I got yesterday. Thanks for fixing! :)
    
    Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
    Cc: miaox@cn.fujitsu.com
    Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
    Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Avi Kivity <avi@qumranet.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched.c b/kernel/sched.c
index 94ead43..9397b87 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5621,8 +5621,10 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 
 	double_rq_lock(rq_src, rq_dest);
 	/* Already moved. */
-	if (task_cpu(p) != src_cpu)
+	if (task_cpu(p) != src_cpu) {
+		ret = 1;
 		goto out;
+	}
 	/* Affinity changed (again). */
 	if (!cpu_isset(dest_cpu, p->cpus_allowed))
 		goto out;
