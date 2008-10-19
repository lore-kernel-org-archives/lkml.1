Return-Path: <linux-kernel-owner+w=401wt.eu-S1751625AbYJSFaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbYJSFaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 01:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbYJSFaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 01:30:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:6231 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYJSFaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 01:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=so3PYzgtr3LJzk7fW+Ed2xNf4FiBmMWc7NbaN7fLM3o6I1Qcin0EJIeqv4yub0RZsg
         FVcm4vGq8q1zi0RC6WRsxzUc2Bd/e00c1jFru2bpLlkEy9rpNwNLKTBojD9yr73m9Ckk
         j5j7e33ntPOsVMu1kAD9XReHaQydcKzkX+5s0=
Date: Sun, 19 Oct 2008 09:29:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: CFS related question
Message-ID: <20081019052958.GA7764@localhost>
References: <20081018200319.GC8188@localhost> <1224361698.10548.38.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224361698.10548.38.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Peter Zijlstra - Sat, Oct 18, 2008 at 10:28:18PM +0200]
| On Sun, 2008-10-19 at 00:03 +0400, Cyrill Gorcunov wrote:
| > Hi Ingo, Peter,
| > 
| > I just curious, look we have the following
| > 
| > static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
| > {
| > 	struct sched_entity *se = NULL;
| > 
| > 	if (first_fair(cfs_rq)) {
| > 		se = __pick_next_entity(cfs_rq);
| > 		se = pick_next(cfs_rq, se);
| > 		set_next_entity(cfs_rq, se);
| > 	}
| > 
| > 	return se;
| > }
| > 
| > which I presume may return NULL so the following piece
| > could fail
| > 
| > static struct task_struct *pick_next_task_fair(struct rq *rq)
| > {
| > 	struct task_struct *p;
| > 	struct cfs_rq *cfs_rq = &rq->cfs;
| > 	struct sched_entity *se;
| > 
| > 	if (unlikely(!cfs_rq->nr_running))
| > 		return NULL;
| > 
| > 	do {
| > -->		se = pick_next_entity(cfs_rq);
| > --> OOPs	cfs_rq = group_cfs_rq(se);
| > 	} while (cfs_rq);
| > 
| > 	p = task_of(se);
| > 	hrtick_start_fair(rq, p);
| > 
| > 	return p;
| > }
| > 
| > Did I miss something? Or it comepletely can NOT happen?
| 
| pick_next_entity() only returns NULL when !first_fair(), which is when !
| nr_running.
| 
| So the initial !nr_running check in pick_next_task_fair() will catch
| that. Further nested RQs will never have !nr_running because then they
| get dequeued.
| 
| 
| 

Thanks Peter!

		- Cyrill -
