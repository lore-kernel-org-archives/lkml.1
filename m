Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbYJVI6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbYJVI6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 04:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYJVI6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 04:58:21 -0400
Received: from styx.suse.cz ([82.119.242.94]:35375 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751079AbYJVI6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 04:58:20 -0400
Subject: Re: [PATCH 1/2] Allow rwlocks to re-enable interrupts
From: Petr Tesarik <ptesarik@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org, tee@sgi.com,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1224665128.15448.4.camel@twins>
References: <1224664414.4430.33.camel@elijah.suse.cz>
	 <1224664476.4430.38.camel@elijah.suse.cz>  <1224665128.15448.4.camel@twins>
Content-Type: text/plain
Organization: SUSE LINUX
Date: Wed, 22 Oct 2008 10:58:19 +0200
Message-Id: <1224665899.4430.48.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 10:45 +0200, Peter Zijlstra wrote:
> On Wed, 2008-10-22 at 10:34 +0200, Petr Tesarik wrote:
> > c b/kernel/spinlock.c
> > index 29ab207..f769d8a 100644
> > --- a/kernel/spinlock.c
> > +++ b/kernel/spinlock.c
> > @@ -121,7 +121,11 @@ unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
> >  	local_irq_save(flags);
> >  	preempt_disable();
> >  	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
> > +#ifdef CONFIG_LOCKDEP
> >  	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
> > +#else
> > +	_raw_read_lock_flags(lock, &flags);
> > +#endif
> >  	return flags;
> >  }
> 
> That should be CONFIG_LOCK_STAT.

Ugh. Fine with me, but is CONFIG_LOCKDEP correct in _spin_lock_irqsave,
or should it also read CONFIG_LOCK_STAT?

> But aside from that, I really don't like this change, I'd rather you'd
> create a LOCK_CONTENDED_FLAGS() that can deal with this.

No problem. I could then also use it for _spin_lock_irqsave, if the
answer to the above question is use CONFIG_LOCK_STAT there as well.

Petr Tesarik


