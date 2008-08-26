Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbYHZWx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbYHZWx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYHZWxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:53:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:35329 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbYHZWxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:53:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LJny8NPMp0OzUkRhNJfW0dyteJ6T2v+ux4AWzK1C7quYI9VcFwGPu6rFSDXe1RDn2t
         WAZkPMQ9KfZSBk1ZI1Nxj0AQCCLsOPS9Yy1h+jo7DCSC0vOqokKYg9J+B5xe/07niT+H
         47jfSfhtgsAxILVRb3fJowp7p1Toi72XvzK1U=
Date: Wed, 27 Aug 2008 02:55:19 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] utrace core
Message-ID: <20080826225519.GC27724@x200.localdomain>
References: <20080826220102.89635154233@magilla.localdomain> <20080826220157.397C7154233@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826220157.397C7154233@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 03:01:57PM -0700, Roland McGrath wrote:
> This adds the utrace facility, a new modular interface in the kernel for
> implementing user thread tracing and debugging.  This fits on top of the
> tracehook_* layer, so the new code is well-isolated.

I'll says this again: tracehook_* is pointless abstraction because
there will be no second generic tracing facility. The author of second
one will be asked what is bad in utrace with very high odds.

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1196,6 +1196,11 @@ struct task_struct {
>  #endif
>  	seccomp_t seccomp;
>  
> +#ifdef CONFIG_UTRACE
> +	struct utrace *utrace;
> +	unsigned long utrace_flags;
> +#endif

Again, embed struct utrace directly into task_struct. task_struct
lifetime rules are way more tested than struct utrace ones.

Add simple spinlock guarding all accesses (OK, I haven't looked very
closely if it's possible)

Nobody needs hundred-line utrace_attach with CPU barriers.

Nobody needs RCU.

Nobody needs restart logic.

Reminder: that struct utrace double-free was P_I_T_A to debug.

I'll check last utrace oops we talked is still there and bogus patch was applied
(sorry, haven't slept night at all). And run to confirm that attach/detach/exec
program still crashes it. There is PREEMPT_RCU now so it will be even more not
funny.

> --- /dev/null
> +++ b/kernel/utrace.c

> +/*
> + * Make sure target->utrace is allocated, and return with it locked on
> + * success.  This function mediates startup races.  The creating parent
> + * task has priority, and other callers will delay here to let its call
> + * succeed and take the new utrace lock first.
> + */
> +static struct utrace *utrace_first_engine(struct task_struct *target,
> +					  struct utrace_attached_engine *engine)
> +	__acquires(utrace->lock)
> +{
> +	struct utrace *utrace;
> +
> +	/*
> +	 * If this is a newborn thread and we are not the creator,
> +	 * we have to wait for it.  The creator gets the first chance
> +	 * to attach.  The PF_STARTING flag is cleared after its
> +	 * report_clone hook has had a chance to run.
> +	 */
> +	if (target->flags & PF_STARTING) {
> +		utrace = current->utrace;
> +		if (utrace == NULL || utrace->u.live.cloning != target) {
> +			yield();
> +			if (signal_pending(current))
> +				return ERR_PTR(-ERESTARTNOINTR);
> +			return NULL;
> +		}
> +	}
> +
> +	utrace = kmem_cache_zalloc(utrace_cachep, GFP_KERNEL);
> +	if (unlikely(utrace == NULL))
> +		return ERR_PTR(-ENOMEM);
> +
> +	INIT_LIST_HEAD(&utrace->attached);
> +	INIT_LIST_HEAD(&utrace->attaching);
> +	list_add(&engine->entry, &utrace->attached);
> +	spin_lock_init(&utrace->lock);
> +	CHECK_INIT(utrace);
> +
> +	spin_lock(&utrace->lock);
> +	task_lock(target);
> +	if (likely(target->utrace == NULL)) {
> +		rcu_assign_pointer(target->utrace, utrace);
> +
> +		/*
> +		 * The task_lock protects us against another thread doing
> +		 * the same thing.  We might still be racing against
> +		 * tracehook_release_task.  It's called with ->exit_state
> +		 * set to EXIT_DEAD and then checks ->utrace with an
> +		 * smp_mb() in between.  If EXIT_DEAD is set, then
> +		 * release_task might have checked ->utrace already and saw
> +		 * it NULL; we can't attach.  If we see EXIT_DEAD not yet
> +		 * set after our barrier, then we know release_task will
> +		 * see our target->utrace pointer.
> +		 */
> +		smp_mb();
> +		if (likely(target->exit_state != EXIT_DEAD)) {
> +			task_unlock(target);
> +			return utrace;
> +		}
> +
> +		/*
> +		 * The target has already been through release_task.
> +		 * Our caller will restart and notice it's too late now.
> +		 */
> +		target->utrace = NULL;
> +	}
> +
> +	/*
> +	 * Another engine attached first, so there is a struct already.
> +	 * A null return says to restart looking for the existing one.
> +	 */
> +	task_unlock(target);
> +	spin_unlock(&utrace->lock);
> +	kmem_cache_free(utrace_cachep, utrace);
> +
> +	return NULL;
> +}

All this junk will dissapear. I even posted proff-of-concept patch.

> +/*
> + * Called with utrace locked.  Clean it up and free it via RCU.
> + */
> +static void rcu_utrace_free(struct utrace *utrace)
> +	__releases(utrace->lock)
> +{
> +	CHECK_DEAD(utrace);
> +	spin_unlock(&utrace->lock);
> +	INIT_RCU_HEAD(&utrace->u.dead);
> +	call_rcu(&utrace->u.dead, utrace_free);

INIT_RCU_HEAD is not needed, call_rcu() will overwrite rcu head unconditionally.

