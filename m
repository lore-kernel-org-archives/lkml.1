Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbYDBHnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbYDBHnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYDBHmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:42:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37777 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYDBHmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:42:52 -0400
Date: Wed, 2 Apr 2008 13:22:55 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: a.p.zijlstra@chello.nl
Cc: Ingo Molnar <mingo@elte.hu>, aneesh.kumar@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>
Subject: set_task_rq bug?
Message-ID: <20080402075255.GE17617@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the case of CONFIG_RT_GROUP_SCHED and !CONFIG_FAIR_GROUP_SCHED, this
piece of code seems to be wrong?

/* Change a task's cfs_rq and parent entity if it moves across
 * CPUs/groups */
static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
{
#ifdef CONFIG_FAIR_GROUP_SCHED
        p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
        p->se.parent = task_group(p)->se[cpu];
#endif

#ifdef CONFIG_RT_GROUP_SCHED
        p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
        p->rt.parent = task_group(p)->rt_se[cpu];
#endif
}

Basically for the above config case, a task's p->se.cfs_rq is never set,
which seems to be incorrect, as lot of sched_fair.c (for ex:
enqueue_task_fair) banks on the availability of this information. It should 
atleast be set to &rq->cfs?

-- 
Regards,
vatsa
