Return-Path: <linux-kernel-owner+w=401wt.eu-S934472AbYEBMhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934472AbYEBMhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 08:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759434AbYEBMhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 08:37:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:56743 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757705AbYEBMhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 08:37:06 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/dFCNL2mbdVPW7pmtj7+nBK2g4j0TFCmd0v7Jd5q
	F5vYBgB0f8VvcI
Subject: Re: Horrendous Audio Stutter - current git
From: Mike Galbraith <efault@gmx.de>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>
In-Reply-To: <82e4877d0805020521t696cc4fbu6ffd182f84ae1a2e@mail.gmail.com>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <1209717278.13978.136.camel@twins>
	 <82e4877d0805020410u78c6f03fr8e8e53d5a19f6846@mail.gmail.com>
	 <1209730185.18055.21.camel@marge.simson.net>
	 <82e4877d0805020521t696cc4fbu6ffd182f84ae1a2e@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-eaVeKP072N9ClrMsaqlb"
Date: Fri, 02 May 2008 14:37:02 +0200
Message-Id: <1209731822.25271.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eaVeKP072N9ClrMsaqlb
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 2008-05-02 at 08:21 -0400, Parag Warudkar wrote:
> On Fri, May 2, 2008 at 8:09 AM, Mike Galbraith <efault@gmx.de> wrote:
> >  Hm.  I've stumbled across a regression that may be related.  Can you
> >  please try the attached with group scheduling enabled in current git?
> 
> In file included from kernel/sched.c:1902:
> kernel/sched_fair.c: In function 'print_cfs_rq_tasks':
> kernel/sched_fair.c:1602: error: implicit declaration of function
> 'calc_delta_weight'
> kernel/sched_fair.c:1603: warning: format '%lu' expects type 'long
> unsigned int', but argument 5 has type 'int'
> make[1]: *** [kernel/sched.o] Error 1
> make: *** [kernel] Error 2
> 
> 'calc_delta_weight' or a replacement not found easily to fix it up!

Oops, I have an unrelated patch in my tree which you also need.

	-Mike

--=-eaVeKP072N9ClrMsaqlb
Content-Disposition: attachment; filename=revert_7ba2e74ab5a0518bc953042952dd165724bc70c9.diff
Content-Type: text/x-patch; name=revert_7ba2e74ab5a0518bc953042952dd165724bc70c9.diff; charset=utf-8
Content-Transfer-Encoding: 7bit

commit 7ba2e74ab5a0518bc953042952dd165724bc70c9
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Sat Apr 19 19:45:00 2008 +0200

    sched: debug: show a weight tree
    
    Print a tree of weights.
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Index: linux-2.6.26.git/kernel/sched_fair.c
===================================================================
--- linux-2.6.26.git.orig/kernel/sched_fair.c
+++ linux-2.6.26.git/kernel/sched_fair.c
@@ -1611,30 +1611,6 @@ static const struct sched_class fair_sch
 };
 
 #ifdef CONFIG_SCHED_DEBUG
-static void
-print_cfs_rq_tasks(struct seq_file *m, struct cfs_rq *cfs_rq, int depth)
-{
-	struct sched_entity *se;
-
-	if (!cfs_rq)
-		return;
-
-	list_for_each_entry_rcu(se, &cfs_rq->tasks, group_node) {
-		int i;
-
-		for (i = depth; i; i--)
-			seq_puts(m, "  ");
-
-		seq_printf(m, "%lu %s %lu\n",
-				se->load.weight,
-				entity_is_task(se) ? "T" : "G",
-				calc_delta_weight(SCHED_LOAD_SCALE, se)
-				);
-		if (!entity_is_task(se))
-			print_cfs_rq_tasks(m, group_cfs_rq(se), depth + 1);
-	}
-}
-
 static void print_cfs_stats(struct seq_file *m, int cpu)
 {
 	struct cfs_rq *cfs_rq;
@@ -1642,9 +1618,6 @@ static void print_cfs_stats(struct seq_f
 	rcu_read_lock();
 	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
 		print_cfs_rq(m, cpu, cfs_rq);
-
-	seq_printf(m, "\nWeight tree:\n");
-	print_cfs_rq_tasks(m, &cpu_rq(cpu)->cfs, 1);
 	rcu_read_unlock();
 }
 #endif

--=-eaVeKP072N9ClrMsaqlb--

