Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbXICTzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbXICTzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 15:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbXICTyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 15:54:52 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1534 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261AbXICTyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 15:54:51 -0400
Date: Mon, 3 Sep 2007 21:55:20 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Simple Really Fair Scheduler
In-Reply-To: <20070903192050.GA29049@elte.hu>
Message-ID: <Pine.LNX.4.64.0709032140140.1817@scrub.home>
References: <20070902120154.GA23769@elte.hu> <Pine.LNX.4.64.0709032030320.1817@scrub.home>
 <20070903185403.GA23479@elte.hu> <Pine.LNX.4.64.0709032106070.1817@scrub.home>
 <20070903192050.GA29049@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 3 Sep 2007, Ingo Molnar wrote:

> My next question then is about this code of yours in the wakeup path:
> 
>  +static void
>  +enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  +{
>  +       kclock_t min_time;
>  +
>  +       verify_queue(cfs_rq, cfs_rq->curr != se, se);
>  +       min_time = get_time_avg(cfs_rq) - se->req_weight_inv;
>  +       if ((kclock_t)(se->time_norm - min_time) < 0)
>  +               se->time_norm = min_time;
> 
> why do you only use the "min_time" if the pre-sleep time_norm is smaller 
> than the min_time? Here 'min_time' is close to the current average. 

It's a variation of the sleeper bonus. Let's assume two running tasks 
which have been running for 95ms and 105ms and a time slice of 10ms, the 
average is thus 100ms. If the new task has been sleeping for a while it 
starts at 90ms, if the task had been running lately it doesn't get this 
bonus again.

> Shouldnt here the woken up task be set to the average time, like i did 
> it in the crude prototype:
> 
> +               se->exec_runtime = avg_exec_runtime(cfs_rq);

That would be equivalent to simply clearing wait_runtime in CFS.

bye, Roman
