Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbYDBHtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbYDBHtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYDBHtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:49:12 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:57262 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbYDBHtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:49:11 -0400
Subject: Re: set_task_rq bug?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: vatsa@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, aneesh.kumar@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20080402075255.GE17617@linux.vnet.ibm.com>
References: <20080402075255.GE17617@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 09:48:57 +0200
Message-Id: <1207122537.8514.752.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 13:22 +0530, Srivatsa Vaddagiri wrote:
> For the case of CONFIG_RT_GROUP_SCHED and !CONFIG_FAIR_GROUP_SCHED, this
> piece of code seems to be wrong?
> 
> /* Change a task's cfs_rq and parent entity if it moves across
>  * CPUs/groups */
> static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
> {
> #ifdef CONFIG_FAIR_GROUP_SCHED
>         p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
>         p->se.parent = task_group(p)->se[cpu];
> #endif
> 
> #ifdef CONFIG_RT_GROUP_SCHED
>         p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
>         p->rt.parent = task_group(p)->rt_se[cpu];
> #endif
> }
> 
> Basically for the above config case, a task's p->se.cfs_rq is never set,
> which seems to be incorrect, as lot of sched_fair.c (for ex:
> enqueue_task_fair) banks on the availability of this information. It should 
> atleast be set to &rq->cfs?

struct sched_entity {
        struct load_weight      load;           /* for load-balancing */
        struct rb_node          timeline_node;
#ifdef CONFIG_FAIR_GROUP_SCHED
        struct rb_node          deadline_node;
        u64                     vdeadline;
#endif
        struct list_head        group_node;
        unsigned int            on_rq;

        u64                     exec_start;
        u64                     sum_exec_runtime;
        u64                     vruntime;
        u64                     prev_sum_exec_runtime;

        u64                     last_wakeup;
        u64                     avg_overlap;

#ifdef CONFIG_SCHEDSTATS
	...
#endif

#ifdef CONFIG_FAIR_GROUP_SCHED
        struct sched_entity     *parent;
        /* rq on which this entity is (to be) queued: */
        struct cfs_rq           *cfs_rq;
        /* rq "owned" by this entity/group: */
        struct cfs_rq           *my_q;
#endif
};

with !CONFIG_FAIR_GROUP_SCHED se.cfs_rq isn't even there.

