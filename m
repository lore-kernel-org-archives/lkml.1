Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYJTSUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYJTSUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYJTSUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:20:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:46401 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbYJTSUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:20:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aeL0ayCIBhEdIlDeMpjkvsP0F4Q6ux/TClPy3d8VqklI+CFEdVU8FJtfhGJHQUxzfe
         d1sjKU7Y5IJ3YZZ8WvzeG8sVFBscx0OpcF1mImE0o5OqC4AQcUAnZXjUEQz+yU2j4Vju
         4MSuHl0SSa/c5GiK7oTlVV+Tscsvcs8e3a4kQ=
Date: Mon, 20 Oct 2008 22:20:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: CFS related question
Message-ID: <20081020182038.GB503@localhost>
References: <20081018200319.GC8188@localhost> <1224361698.10548.38.camel@lappy.programming.kicks-ass.net> <48FCCA14.5000103@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FCCA14.5000103@ct.jp.nec.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Hiroshi Shimamoto - Mon, Oct 20, 2008 at 11:12:36AM -0700]
| Peter Zijlstra wrote:
| > On Sun, 2008-10-19 at 00:03 +0400, Cyrill Gorcunov wrote:
| >> Hi Ingo, Peter,
| >>
| >> I just curious, look we have the following
| >>
| >> static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
| >> {
| >> 	struct sched_entity *se = NULL;
| >>
| >> 	if (first_fair(cfs_rq)) {
| >> 		se = __pick_next_entity(cfs_rq);
| >> 		se = pick_next(cfs_rq, se);
| >> 		set_next_entity(cfs_rq, se);
| >> 	}
| >>
| >> 	return se;
| >> }
| >>
| >> which I presume may return NULL so the following piece
| >> could fail
| >>
| >> static struct task_struct *pick_next_task_fair(struct rq *rq)
| >> {
| >> 	struct task_struct *p;
| >> 	struct cfs_rq *cfs_rq = &rq->cfs;
| >> 	struct sched_entity *se;
| >>
| >> 	if (unlikely(!cfs_rq->nr_running))
| >> 		return NULL;
| >>
| >> 	do {
| >> -->		se = pick_next_entity(cfs_rq);
| >> --> OOPs	cfs_rq = group_cfs_rq(se);
| >> 	} while (cfs_rq);
| >>
| >> 	p = task_of(se);
| >> 	hrtick_start_fair(rq, p);
| >>
| >> 	return p;
| >> }
| >>
| >> Did I miss something? Or it comepletely can NOT happen?
| > 
| > pick_next_entity() only returns NULL when !first_fair(), which is when !
| > nr_running.
| > 
| > So the initial !nr_running check in pick_next_task_fair() will catch
| > that. Further nested RQs will never have !nr_running because then they
| > get dequeued.
| 
| Hi Peter,
| 
| pick_next_entity() is used in pick_next_task_fair() only.
| So, checking first_fair() never fail, and if fails it means bug. Right?
| 
| How about the below patch?
| --------
| From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
| Subject: [PATCH] sched: replace check with BUG_ON in pick_next_entity()
| 
| BUG_ON instead of returning NULL in pick_next_entity() when !first_fair().
| Basically first_fair() is always true, and returning NULL will cause oops later.
| 
| Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
| ---
|  kernel/sched_fair.c |   12 ++++++------
|  1 files changed, 6 insertions(+), 6 deletions(-)
| 
| diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
| index 9573c33..3ce7c25 100644
| --- a/kernel/sched_fair.c
| +++ b/kernel/sched_fair.c
| @@ -758,13 +758,13 @@ pick_next(struct cfs_rq *cfs_rq, struct sched_entity *se)
|  
|  static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
|  {
| -	struct sched_entity *se = NULL;
| +	struct sched_entity *se;
|  
| -	if (first_fair(cfs_rq)) {
| -		se = __pick_next_entity(cfs_rq);
| -		se = pick_next(cfs_rq, se);
| -		set_next_entity(cfs_rq, se);
| -	}
| +	BUG_ON(!first_fair(cfs_rq));
| +
| +	se = __pick_next_entity(cfs_rq);
| +	se = pick_next(cfs_rq, se);
| +	set_next_entity(cfs_rq, se);
|  
|  	return se;
|  }
| -- 
| 1.5.6
|

Technically it should not happen (as Peter explained). But it
seems it happens sometime -- and most probably 'cause of error
in another part of kernel (ie indirect error). So if Peter would
not object against -- I would really like to better have BUG_ON
check there :) Peter?

	http://lkml.org/lkml/2008/8/3/269
	http://lists.openwall.net/linux-kernel/2008/05/14/130
 
		- Cyrill -
