Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbYIDKcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbYIDKcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 06:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYIDKcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 06:32:41 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:60498 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbYIDKck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 06:32:40 -0400
Message-ID: <48BFB8B2.2060007@gmail.com>
Date: Thu, 04 Sep 2008 06:30:10 -0400
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [rfc][patch] queueing spinlocks?
References: <20080828073428.GA19638@wotan.suse.de>
In-Reply-To: <20080828073428.GA19638@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,
  Cool stuff...see inline

Nick Piggin wrote:
> I've implemented a sort of spin local, queueing MCS lock that uses per-cpu
> nodes that can be shared by multiple locks. I guess it is preferable to
> remove global locks, but some don't seem to be going anywhere soon.
>
> The only issue is that only one set of nodes can be actively used for a lock
> at once, so if we want to nest these locks, we have to use different
> sets for each one. This shouldn't be much of a problem because we don't have
> too many "big" locks, and yet fewer ones that are nested in one another.
>
> With this modification to MCS locks, each lock is pretty small in size, so it
> could even be used for some per-object locks if we really wanted.
>
> I've converted dcache lock as well... it shows improved results on a 64-way
> Altix. Unfortunately this adds an extra atomic to the unlock path. I didn't
> look too hard at array based queue locks, there might be a a type of those
> that would work better.
>
> Index: linux-2.6/include/linux/mcslock.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/linux/mcslock.h
> @@ -0,0 +1,76 @@
> +/*
> + *	"Shared-node" MCS lock.
> + *	Nick Piggin <npiggin@suse.de>
> + */
> +#ifndef _LINUX_MCSLOCK_H
> +#define _LINUX_MCSLOCK_H
> +
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/irqflags.h>
> +#include <asm/atomic.h>
> +#include <asm/system.h>
> +#include <asm/processor.h>
> +
> +#ifndef CONFIG_SMP
> +typdef struct {
> +} mcslock_t;
> +
> +static inline void mcs_lock_init(mcslock_t *lock)
> +{
> +}
> +
> +static inline int mcs_is_locked(mcslock_t *lock)
> +{
> +	return 0;
> +}
> +
> +static inline void mcs_unlock_wait(mcslock_t *lock)
> +{
> +}
> +
> +static inline void mcs_lock(mcslock_t *lock, int nest)
> +{
> +}
> +static inline int mcs_trylock(mcslock_t *lock, int nest)
> +{
> +	return 1;
> +}
> +static inline void mcs_unlock(mcslock_t *lock, int nest)
> +{
> +}
> +
> +#else /*!CONFIG_SMP*/
> +
> +typedef struct {
> +	atomic_t cpu;
> +} mcslock_t;
> +
> +#define MCS_CPU_NONE	0x7fffffff
> +
> +#define DEFINE_MCS_LOCK(name) mcslock_t name = { .cpu = ATOMIC_INIT(MCS_CPU_NONE) }
> +static inline void mcs_lock_init(mcslock_t *lock)
> +{
> +	atomic_set(&lock->cpu, MCS_CPU_NONE); /* unlocked */
> +}
> +
> +static inline int mcs_is_locked(mcslock_t *lock)
> +{
> +	return atomic_read(&lock->cpu) != MCS_CPU_NONE;
> +}
> +
> +static inline void mcs_unlock_wait(mcslock_t *lock)
> +{
> +	while (mcs_is_locked(lock))
> +		cpu_relax();
> +}
> +
> +extern void mcs_lock(mcslock_t *lock, int nest);
> +extern int mcs_trylock(mcslock_t *lock, int nest);
> +extern void mcs_unlock(mcslock_t *lock, int nest);
> +
> +#endif /*!CONFIG_SMP*/
> +
> +extern int atomic_dec_and_mcslock(atomic_t *atomic, mcslock_t *lock, int nest);
>   

I would prefer to see this done as a polymorhpic atomic_dec_and_lock()
call with something like Ingo's "PICK_OP" method (currently used in -rt)
rather than expanding the atomic_X namespace.  I haven't looked into it
to make sure its plausible, but I do not see any reasons from 30k feet
why it would not.  Its not a huge deal either way, but just something to
consider.

-Greg

