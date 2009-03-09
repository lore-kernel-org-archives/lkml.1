Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZCILTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZCILTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 07:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbZCILTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 07:19:30 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:41989 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZCILT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 07:19:29 -0400
Message-ID: <49B4FB37.7050401@davidnewall.com>
Date: Mon, 09 Mar 2009 21:49:19 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Balazs Scheidler <bazsi@balabit.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: scheduler oddity [bug?]
References: <1236448069.16726.21.camel@bzorp.balabit>	 <1236451624.16726.32.camel@bzorp.balabit> <1236541524.19045.6.camel@bzorp.balabit>
In-Reply-To: <1236541524.19045.6.camel@bzorp.balabit>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balazs Scheidler wrote:
> Some more test results:
>
> Latest tree from Linus seems to work, at least the program runs on both
> cores as it should. I bisected the patch that changed behaviour, and
> I've found this:
>
> commit 38736f475071b80b66be28af7b44c854073699cc
> Author: Gautham R Shenoy <ego@in.ibm.com>
> Date:   Sat Sep 6 14:50:23 2008 +0530
>
>     sched: fix __load_balance_iterator() for cfq with only one task
>     
>     The __load_balance_iterator() returns a NULL when there's only one
>     sched_entity which is a task. It is caused by the following code-path.
>     
>     	/* Skip over entities that are not tasks */
>     	do {
>     		se = list_entry(next, struct sched_entity, group_node);
>     		next = next->next;
>     	} while (next != &cfs_rq->tasks && !entity_is_task(se));
>     
>     	if (next == &cfs_rq->tasks)
>     		return NULL;
>     	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>           This will return NULL even when se is a task.
>     
>     As a side-effect, there was a regression in sched_mc behavior since 2.6.25,
>     since iter_move_one_task() when it calls load_balance_start_fair(),
>     would not get any tasks to move!
>     
>     Fix this by checking if the last entity was a task or not.
>     
>     Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
>     Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>

Woops!  That fails when the task is the last entry on the list.  This
fixes that:

--- sched_fair.c        2009-02-21 09:09:34.000000000 +1030
+++ sched_fair.c.dn     2009-03-09 20:48:36.000000000 +1030
@@ -1440,7 +1440,7 @@
 __load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
 {
        struct task_struct *p = NULL;
-       struct sched_entity *se;
+       struct sched_entity *se = NULL;
 
        if (next == &cfs_rq->tasks)
                return NULL;
@@ -1451,7 +1451,7 @@
                next = next->next;
        } while (next != &cfs_rq->tasks && !entity_is_task(se));
 
-       if (next == &cfs_rq->tasks)
+       if (se == NULL || !entity_is_task(se))
                return NULL;
 
        cfs_rq->balance_iterator = next;


Really, though, the function could stand a spring-cleaning, for example
either of the following, depending on how much you hate returning from
within a loop:

__load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
{
        do {
                struct sched_entity *se = list_entry(next, struct sched_entity, group_node);
                next = next->next;
                if (entity_is_task(se))
                {
                        cfs_rq->balance_iterator = next;
                        return task_of(se);
                }
        } while (next != &cfs_rq->tasks);
        return NULL;
}


__load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
{
        struct sched_entity *se;

        for ( ; next != &cfs_rq->tasks; next = next->next)
        {
                se = list_entry(next, struct sched_entity, group_node);
                if (entity_is_task(se))
                        break;
        }

        if (next == &cfs_rq->tasks)
                return NULL;

        cfs_rq->balance_iterator = next->next;
        return task_of(se);
}


I wonder if it was intended to set balance_iterator to the task's list
entry instead of the following one.

