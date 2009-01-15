Return-Path: <linux-kernel-owner+w=401wt.eu-S1763623AbZAOKam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763623AbZAOKam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760657AbZAOKac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:30:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:36907 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754638AbZAOKaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:30:30 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX183SjVo1GE3kit+Kad/B6OACe8SF7h6g0EdRO7e5i
	6q0YN9RtA9gOlK
Subject: Re: [BUG] How to get real-time priority using idle priority
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Brian Rogers <brian@xyzw.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1232014456.8870.26.camel@laptop>
References: <4969D0D7.2060401@xyzw.org>
	 <1231736941.6003.7.camel@marge.simson.net>
	 <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu>
	 <496BE8F6.1040308@xyzw.org>  <1232011723.26761.36.camel@marge.simson.net>
	 <1232014456.8870.26.camel@laptop>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 11:30:23 +0100
Message-Id: <1232015423.13856.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 11:14 +0100, Peter Zijlstra wrote:
> On Thu, 2009-01-15 at 10:28 +0100, Mike Galbraith wrote:

> OK, so why did I write it like that to begin with...
> 
> Aah, yes.
> 
> Say we've just dequeued current
> 
> schedule
>   deactivate_task(prev)
>     dequeue_entity
>       update_min_vruntime
> 
> Then we'll set
> 
>   vruntime = cfs_rq->min_vruntime;
> 
> we find !cfs_rq->curr, but do find someone in the tree. Then we _must_
> do vruntime = se->vruntime, because
> 
>  vruntime = min_vruntime(vruntime := cfs_rq->min_vruntime, se->vruntime)
> 
> will not advance vruntime, and cause lags the other way around (which we
> fixed with that initial patch: 1af5f730fc1bf7c62ec9fb2d307206e18bf40a69
> (sched: more accurate min_vruntime accounting).
> 
> Which leads me to suggest the following
> 
> ---
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 8e1352c..f2d2d94 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -283,7 +283,7 @@ static void update_min_vruntime(struct cfs_rq
> *cfs_rq)
>  						   struct sched_entity,
>  						   run_node);
>  
> -		if (vruntime == cfs_rq->min_vruntime)
> +		if (!cfs_rq->curr)
>  			vruntime = se->vruntime;
>  		else
>  			vruntime = min_vruntime(vruntime, se->vruntime);

Aha.  Yeah, I'll re-test with that instead.

> The below can be split into 3 patches:
> 
>  - the idle weight change (do we really need that? why?)

I saw idle tasks slamming extremely far.  I'll verify, less is more.

	-Mike

