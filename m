Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbZCHKUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbZCHKUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZCHKUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:20:23 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:9589 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZCHKUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:20:23 -0400
X-SourceIP: 213.93.53.227
Subject: Re: scheduler oddity [bug?]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Balazs Scheidler <bazsi@balabit.hu>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1236506309.6972.8.camel@marge.simson.net>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 11:19:54 +0100
Message-Id: <1236507594.22914.3641.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 10:58 +0100, Mike Galbraith wrote:
> 
> The below cures it, but is only a demo hack.
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 8e2558c..85f9ced 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1712,11 +1712,15 @@ static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
>  
>  static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
>  {
> +       u64 limit = sysctl_sched_migration_cost;
> +       u64 runtime = p->se.sum_exec_runtime - p->se.prev_sum_exec_runtime;
> +
>         if (sleep && p->se.last_wakeup) {
>                 update_avg(&p->se.avg_overlap,
>                            p->se.sum_exec_runtime - p->se.last_wakeup);
>                 p->se.last_wakeup = 0;
> -       }


Wouldn't something like the below be more suited:

diff --git a/kernel/sched.c b/kernel/sched.c
index 89e2ca0..94c8b02 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2501,7 +2501,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
 	p->se.last_wakeup		= 0;
-	p->se.avg_overlap		= 0;
+	p->se.avg_overlap		= sysctl_sched_migration_cost;
 	p->se.start_runtime		= 0;
 	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;
 


