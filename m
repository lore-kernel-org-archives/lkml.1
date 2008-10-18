Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbYJRU2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbYJRU2e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbYJRU21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:28:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37788 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbYJRU20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:28:26 -0400
Subject: Re: CFS related question
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081018200319.GC8188@localhost>
References: <20081018200319.GC8188@localhost>
Content-Type: text/plain
Date: Sat, 18 Oct 2008 22:28:18 +0200
Message-Id: <1224361698.10548.38.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-19 at 00:03 +0400, Cyrill Gorcunov wrote:
> Hi Ingo, Peter,
> 
> I just curious, look we have the following
> 
> static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
> {
> 	struct sched_entity *se = NULL;
> 
> 	if (first_fair(cfs_rq)) {
> 		se = __pick_next_entity(cfs_rq);
> 		se = pick_next(cfs_rq, se);
> 		set_next_entity(cfs_rq, se);
> 	}
> 
> 	return se;
> }
> 
> which I presume may return NULL so the following piece
> could fail
> 
> static struct task_struct *pick_next_task_fair(struct rq *rq)
> {
> 	struct task_struct *p;
> 	struct cfs_rq *cfs_rq = &rq->cfs;
> 	struct sched_entity *se;
> 
> 	if (unlikely(!cfs_rq->nr_running))
> 		return NULL;
> 
> 	do {
> -->		se = pick_next_entity(cfs_rq);
> --> OOPs	cfs_rq = group_cfs_rq(se);
> 	} while (cfs_rq);
> 
> 	p = task_of(se);
> 	hrtick_start_fair(rq, p);
> 
> 	return p;
> }
> 
> Did I miss something? Or it comepletely can NOT happen?

pick_next_entity() only returns NULL when !first_fair(), which is when !
nr_running.

So the initial !nr_running check in pick_next_task_fair() will catch
that. Further nested RQs will never have !nr_running because then they
get dequeued.



