Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbZBRUQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbZBRUQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 15:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZBRUQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 15:16:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36254 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbZBRUQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:16:18 -0500
Date: Wed, 18 Feb 2009 21:12:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] generic-ipi: remove kmalloc()
Message-ID: <20090218201252.GA5895@redhat.com>
References: <20090217215904.059250145@chello.nl> <20090217220053.500765201@chello.nl> <20090218002823.GA25408@linux.vnet.ibm.com> <20090218161515.GA24895@redhat.com> <20090218194727.GB7011@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218194727.GB7011@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18, Paul E. McKenney wrote:
>
> On Wed, Feb 18, 2009 at 05:15:15PM +0100, Oleg Nesterov wrote:
>
> > On 02/17, Paul E. McKenney wrote:
> > >
> > > On Tue, Feb 17, 2009 at 10:59:06PM +0100, Peter Zijlstra wrote:
> > > > +static void csd_lock(struct call_single_data *data)
> > > >  {
> > > > -	/* Wait for response */
> > > > -	do {
> > > > -		if (!(data->flags & CSD_FLAG_WAIT))
> > > > -			break;
> > > > +	while (data->flags & CSD_FLAG_LOCK)
> > > >  		cpu_relax();
> > > > -	} while (1);
> > > > +	data->flags = CSD_FLAG_LOCK;
> > >
> > > We do need an smp_mb() here, otherwise, the call from
> > > smp_call_function_single() could be reordered by either CPU or compiler
> > > as follows:
> > >
> > > 	data->func = func;
> > > 	data->info = info;
> > > 	csd_lock(data);
> > >
> > > This might come as a bit of a surprise to the other CPU still trying to
> > > use the old values for data->func and data->info.
> >
> > Could you explain a bit more here?
> >
> > The compiler can't re-order this code due to cpu_relax(). Cpu can
> > re-order, but this doesn't matter because both the sender and ipi
> > handler take call_single_queue->lock.
> >
> > And, giwen that csd_unlock() does mb() before csd_unlock(), how
> > it is possible that other CPU (ipi handler) still uses the old
> > values in *data after we see !CSD_FLAG_LOCK ?
>
> Good point on cpu_relax(), which appears to be at least a compiler
> barrier on all architectures.
>
> I must confess to being in the habit of assuming reordering unless I
> can prove that such reordering cannot happen.

Yes, probably you are right...

But since almost nobody (except you ;) really understands this magic,
it would be nice to have a comment which explains exactly what is the
reason for mb(). Otherwise it is so hard to read the code, if you
don't understand mb(), then you probably missed something important.

> > Every time smp_call_function_many() reuses the element, it sets its
> > ->next pointer to the head of the list. If we race with another CPU
> > which fetches this pointer, this CPU has to re-scan the whole list,
> > but since we always modify/read data under data->lock this should
> > be safe, that CPU must notice (!cpumask_test_cpu(cpu, data->cpumask).
>
> You are quite correct.  I guess I should have gone home early instead of
> reviewing Peter's patch...  :-/

In that case I shouldn't even try to read this series ;) I was wrong so
many times...

Oleg.

