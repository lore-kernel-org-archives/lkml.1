Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbYK0Pde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbYK0Pde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYK0PdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:33:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:44848 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbYK0PdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:33:23 -0500
Subject: Re: [PATCH V2 2/3] Allow rwlocks to re-enable interrupts
From: Peter Zijlstra <peterz@infradead.org>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org, tee@sgi.com,
       Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1224777969.11530.67.camel@elijah.suse.cz>
References: <1224777451.11530.52.camel@elijah.suse.cz>
	 <1224777969.11530.67.camel@elijah.suse.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Nov 2008 16:33:21 +0100
Message-Id: <1227800001.4454.1712.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-23 at 18:06 +0200, Petr Tesarik wrote:
> Pass the original flags to rwlock arch-code, so that it can re-enable
> interrupts if implemented for that architecture.
> 
> Initially, make __raw_read_lock_flags and __raw_write_lock_flags
> stubs which just do the same thing as non-flags variants.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> diff --git a/kernel/spinlock.c b/kernel/spinlock.c
> index cf41b87..7c2f5b5 100644
> --- a/kernel/spinlock.c
> +++ b/kernel/spinlock.c
> @@ -121,7 +121,8 @@ unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
>  	local_irq_save(flags);
>  	preempt_disable();
>  	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
> -	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
> +	LOCK_CONTENDED_FLAGS(lock, _raw_read_trylock, _raw_read_lock,
> +			     _raw_read_lock_flags, &flags);
>  	return flags;
>  }
>  EXPORT_SYMBOL(_read_lock_irqsave);
> @@ -151,7 +152,8 @@ unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
>  	local_irq_save(flags);
>  	preempt_disable();
>  	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
> -	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
> +	LOCK_CONTENDED_FLAGS(lock, _raw_write_trylock, _raw_write_lock,
> +			     _raw_write_lock_flags, &flags);
>  	return flags;
>  }
>  EXPORT_SYMBOL(_write_lock_irqsave);
> 
> 
