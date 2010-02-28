Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030491Ab0B1RO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 12:14:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968739Ab0B1RO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 12:14:57 -0500
Date: Sun, 28 Feb 2010 18:12:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 17/43] workqueue: update cwq alignement
Message-ID: <20100228171255.GA20167@redhat.com>
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-18-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267187000-18791-18-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Tejun Heo wrote:
>
> +static struct cpu_workqueue_struct *alloc_cwqs(void)
> +{
> +	const size_t size = sizeof(struct cpu_workqueue_struct);
> +	const size_t align = 1 << WORK_STRUCT_FLAG_BITS;
> +	struct cpu_workqueue_struct *cwqs;
> +#ifndef CONFIG_SMP
> +	void *ptr;
> +
> +	/*
> +	 * On UP, percpu allocator doesn't honor alignment parameter
> +	 * and simply uses arch-dependent default.  Allocate enough
> +	 * room to align cwq and put an extra pointer at the end
> +	 * pointing back to the originally allocated pointer which
> +	 * will be used for free.
> +	 */
> +	ptr = __alloc_percpu(size + align + sizeof(void *), 1);
> +	cwqs = PTR_ALIGN(ptr, align);
> +	*(void **)per_cpu_ptr(cwqs + 1, 0) = ptr;
> +#else

Nice trick, but perhaps it would be more simple/clear to just add
"void *my_memory" into cpu_workqueue_struct, under !CONFIG_SMP ?

Oleg.

