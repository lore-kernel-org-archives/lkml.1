Return-Path: <linux-kernel-owner+w=401wt.eu-S1161474AbXDSJcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161474AbXDSJcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 05:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161479AbXDSJcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 05:32:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:6714 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161474AbXDSJcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 05:32:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=iLMj7zYDUeqazPtuEV+F3Dy9zCfkxhKKnn/w/S30vJHBQcA7v9JYTZU1vdcDzenK1lN51l71adrIx49RIH5f574NjlKelaHTNRenHFXpxC+ZdOZJkeo+woRPxcTiqqqlXMUdy+Ut0G2uLoJNfXxFWlQFMIzHEQNYXC8JJuejB/k=
Date: Thu, 19 Apr 2007 11:32:03 +0200 (CEST)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Ingo Molnar <mingo@elte.hu>
cc: Christian Hesse <mail@earthworm.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, suspend2-devel@lists.suspend2.net
Subject: Re: CFS and suspend2: hang in atomic copy (was: [Announce] [patch]
 Modular Scheduler Core and Completely Fair Scheduler [CFS])
In-Reply-To: <20070418164621.GA30744@elte.hu>
Message-ID: <Pine.LNX.4.64.0704191117530.8557@frodo.shire>
References: <20070413202100.GA9957@elte.hu> <200704181759.03559.mail@earthworm.de>
 <20070418164621.GA30744@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Apr 2007, Ingo Molnar wrote:

>
> * Christian Hesse <mail@earthworm.de> wrote:
>
>> Hi Ingo and all,
>>
>> On Friday 13 April 2007, Ingo Molnar wrote:
>>> as usual, any sort of feedback, bugreports, fixes and suggestions are
>>> more than welcome,
>>
>> I just gave CFS a try on my system. From a user's point of view it
>> looks good so far. Thanks for your work.
>
> you are welcome!
>
>> However I found a problem: When trying to suspend a system patched
>> with suspend2 2.2.9.11 it hangs with "doing atomic copy". Pressing the
>> ESC key results in a message that it tries to abort suspend, but then
>> still hangs.
>
> i took a quick look at suspend2 and it makes some use of yield().
> There's a bug in CFS's yield code, i've attached a patch that should fix
> it, does it make any difference to the hang?
>
> 	Ingo
>
> Index: linux/kernel/sched_fair.c
> ===================================================================
> --- linux.orig/kernel/sched_fair.c
> +++ linux/kernel/sched_fair.c
> @@ -264,15 +264,26 @@ static void dequeue_task_fair(struct rq
>
> /*
>  * sched_yield() support is very simple via the rbtree, we just
> - * dequeue and enqueue the task, which causes the task to
> - * roundrobin to the end of the tree:
> + * dequeue the task and move it to the rightmost position, which
> + * causes the task to roundrobin to the end of the tree.
>  */
> static void requeue_task_fair(struct rq *rq, struct task_struct *p)
> {
> 	dequeue_task_fair(rq, p);
> 	p->on_rq = 0;
> -	enqueue_task_fair(rq, p);
> +	/*
> +	 * Temporarily insert at the last position of the tree:
> +	 */
> +	p->fair_key = LLONG_MAX;
> +	__enqueue_task_fair(rq, p);
> 	p->on_rq = 1;
> +
> +	/*
> +	 * Update the key to the real value, so that when all other
> +	 * tasks from before the rightmost position have executed,
> +	 * this task is picked up again:
> +	 */
> +	p->fair_key = rq->fair_clock - p->wait_runtime + p->nice_offset;

I don't think it safe to change the key after inserting the element in the 
tree. You end up with an unsorted tree giving where new entries end up in 
wrong places "randomly".
I think a better approach would be to keep track of the rightmost entry, 
set the key to the rightmost's key +1 and then simply insert it there.

Esben

>
