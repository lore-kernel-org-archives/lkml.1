Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYKXXc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYKXXc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYKXXci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:32:38 -0500
Received: from ozlabs.org ([203.10.76.45]:52714 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360AbYKXXch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:32:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/3] Fix locking error caused by e76bd8d9850c2296a7e8e24c9dce9b5e6b55fe2f
Date: Tue, 25 Nov 2008 09:59:20 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
References: <200811250238.53883.rusty@rustcorp.com.au> <200811250957.52031.rusty@rustcorp.com.au> <200811250958.41573.rusty@rustcorp.com.au>
In-Reply-To: <200811250958.41573.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811250959.20652.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't call cpuset_cpus_allowed_locked() with the rq lock held.
However, the rq lock merely protects us from (1) cpu_online_mask changing
and (2) someone else changing p->cpus_allowed.

The first can't happen because we're being called from a cpu hotplug
notifier.  The second doesn't really matter: we are forcing the task off
a CPU it was affine to, so we're not doing very well anyway.

So we remove the rq lock from this path, and all is good.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/sched.c b/kernel/sched.c
index 1aa840a..7acf95f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6126,7 +6126,6 @@ static int __migrate_task_irq(struct task_struct *p, int src_cpu, int 
dest_cpu)
  */
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
-	unsigned long flags;
 	struct rq *rq;
 	int dest_cpu;
 	/* FIXME: Use cpumask_of_node here. */
@@ -6146,10 +6145,8 @@ again:
 
 	/* No more Mr. Nice Guy. */
 	if (dest_cpu >= nr_cpu_ids) {
-		rq = task_rq_lock(p, &flags);
 		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
 		dest_cpu = cpumask_any_and(cpu_online_mask, &p->cpus_allowed);
-		task_rq_unlock(rq, &flags);
 
 		/*
 		 * Don't tell them about moving exiting tasks or

