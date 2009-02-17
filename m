Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbZBQVii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbZBQVii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZBQVi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:38:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZBQVi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:38:28 -0500
Subject: Re: [PATCH -v4] generic-ipi: remove kmalloc()
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090217213027.GI6761@linux.vnet.ibm.com>
References: <20090216163847.431174825@chello.nl>
	 <20090216164114.433430761@chello.nl> <1234885258.4744.153.camel@laptop>
	 <20090217172113.GA26459@redhat.com> <1234892420.4744.158.camel@laptop>
	 <1234898958.4744.225.camel@laptop>
	 <20090217213027.GI6761@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 22:38:09 +0100
Message-Id: <1234906689.4744.241.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 13:30 -0800, Paul E. McKenney wrote:

> > +static void csd_complete(struct call_single_data *data)
> > +{
> > +	/*
> > +	 * Serialize stores to data with the flag clear and wakeup.
> > +	 */
> > +	smp_wmb();
> 
> Shouldn't the above be an smp_mb()?  There are reads preceding the calls
> to csd_complete() that look to me like they need to remain ordered
> before the flag-clearing below -- just in case of a quick reuse of this
> call_single_data structure.

Good point, however I just did a patch that made CSD_FLAG_WAIT go
away :-)

> > +	data->flags &= ~CSD_FLAG_WAIT;
> > +}
> > +
> > +static void csd_wait(struct call_single_data *data)
> > +{
> > +	while (data->flags & CSD_FLAG_WAIT)
> > +		cpu_relax();
> > +}
> > +
> > +/*
> > + * csd_lock/csd_unlock used to serialize access to per-cpu csd resources
> > + *
> > + * For non-synchronous ipi calls the csd can still be in use by the previous
> > + * function call. For multi-cpu calls its even more interesting as we'll have
> > + * to ensure no other cpu is observing our csd.
> > + */
> > +static void csd_lock(struct call_single_data *data)
> >  {
> > -	/* Wait for response */
> > -	do {
> > -		if (!(data->flags & CSD_FLAG_WAIT))
> > -			break;
> > +	while (data->flags & CSD_FLAG_LOCK)
> >  		cpu_relax();
> > -	} while (1);
> > +	data->flags = CSD_FLAG_LOCK;
> 
> OK, I'll bite...  Why don't we need a memory barrier here?

cpu_relax() is a compiler barrier, missing a memory barrier will just
make us spin this little while extra until the cacheline does hit us.

> > +}
> > +
> > +static void csd_unlock(struct call_single_data *data)
> > +{
> > +	WARN_ON(!(data->flags & CSD_FLAG_LOCK));
> > +	/*
> > +	 * Serialize stores to data with the flags clear.
> > +	 */
> > +	smp_wmb();
> 
> I am a bit worried about this being smp_wmb() rather than smp_mb(),
> but don't have a smoking gun.


		data->func(data->info);

		/*
		 * Unlocked CSDs are valid through generic_exec_single()
		 */
		if (data_flags & CSD_FLAG_LOCK)
			csd_unlock(data);

could the data->info read be delayed until after csd_unlock() ?

I'll make it an mb().


> And about here I get lost -- trying to find what the heck this patch
> applies to...  :-/

Right, I was in the process of sending out a full patch-set again.

