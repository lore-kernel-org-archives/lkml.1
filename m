Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968476Ab0B1Oga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 09:36:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968342Ab0B1Og3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 09:36:29 -0500
Date: Sun, 28 Feb 2010 15:34:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 10/43] stop_machine: reimplement without using workqueue
Message-ID: <20100228143405.GA13236@redhat.com>
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-11-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267187000-18791-11-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Tejun Heo wrote:
>
> @@ -164,19 +259,18 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
>  	idle.fn = chill;
>  	idle.data = NULL;
>
> +	smp_wmb();			/* -> stop_cpu()::set_current_state() */
> ...
> +	for_each_online_cpu(i)
> +		wake_up_process(*per_cpu_ptr(stop_machine_threads, i));

Afaics, this smp_wmb() is not needed, wake_up_process() (try_to_wake_up)
should ensure we can't race with set_current_state() + check_condition.
It does, note the wmb() in try_to_wake_up().

Oleg.

