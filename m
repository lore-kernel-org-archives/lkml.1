Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab0B1QB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 11:01:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab0B1QB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 11:01:57 -0500
Date: Sun, 28 Feb 2010 17:00:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 16/43] workqueue: kill cpu_populated_map
Message-ID: <20100228160005.GA16144@redhat.com>
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-17-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267187000-18791-17-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Tejun Heo wrote:
>
> @@ -1023,41 +991,40 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
> ...
> +	cpu_maps_update_done();
> ...
> +
> +	spin_lock(&workqueue_lock);
> +	list_add(&wq->list, &workqueues);
> +	spin_unlock(&workqueue_lock);

OK, but if cpu_up() happens right after we drop cpu_maps_update_done(),
cwq->thread on the new CPU will run unbound?

> @@ -1127,47 +1091,30 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
> ...
>  	list_for_each_entry(wq, &workqueues, list) {

this becomes unsafe. create/destroy can modify workqueues list
in parallel.

>  		case CPU_ONLINE:
> -			start_workqueue_thread(cwq, cpu);
> +			__set_cpus_allowed(cwq->thread, get_cpu_mask(cpu),
> +					   true);

if the thread doesn't have PF_THREAD_BOUND, who will set it?

>  		case CPU_POST_DEAD:
> -			cleanup_workqueue_thread(cwq);
> +			lock_map_acquire(&cwq->wq->lockdep_map);
> +			lock_map_release(&cwq->wq->lockdep_map);
> +			flush_cpu_workqueue(cwq);

This can race with destroy_workqueue(), no?



I guess this patch is preparation, probably these problems should
go away later...

Oleg.

