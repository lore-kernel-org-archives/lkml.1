Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZBSCkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZBSCkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 21:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZBSCkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 21:40:32 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59876 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbZBSCkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 21:40:31 -0500
Date: Wed, 18 Feb 2009 18:40:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] generic-ipi: remove kmalloc()
Message-ID: <20090219024030.GM7011@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090217215904.059250145@chello.nl> <20090217220053.500765201@chello.nl> <20090218002823.GA25408@linux.vnet.ibm.com> <20090218161515.GA24895@redhat.com> <20090218194727.GB7011@linux.vnet.ibm.com> <20090218201252.GA5895@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218201252.GA5895@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 09:12:52PM +0100, Oleg Nesterov wrote:
> On 02/18, Paul E. McKenney wrote:
> >
> > On Wed, Feb 18, 2009 at 05:15:15PM +0100, Oleg Nesterov wrote:
> >
> > > On 02/17, Paul E. McKenney wrote:
> > > >
> > > > On Tue, Feb 17, 2009 at 10:59:06PM +0100, Peter Zijlstra wrote:
> > > > > +static void csd_lock(struct call_single_data *data)
> > > > >  {
> > > > > -	/* Wait for response */
> > > > > -	do {
> > > > > -		if (!(data->flags & CSD_FLAG_WAIT))
> > > > > -			break;
> > > > > +	while (data->flags & CSD_FLAG_LOCK)
> > > > >  		cpu_relax();
> > > > > -	} while (1);
> > > > > +	data->flags = CSD_FLAG_LOCK;
> > > >
> > > > We do need an smp_mb() here, otherwise, the call from
> > > > smp_call_function_single() could be reordered by either CPU or compiler
> > > > as follows:
> > > >
> > > > 	data->func = func;
> > > > 	data->info = info;
> > > > 	csd_lock(data);
> > > >
> > > > This might come as a bit of a surprise to the other CPU still trying to
> > > > use the old values for data->func and data->info.
> > >
> > > Could you explain a bit more here?
> > >
> > > The compiler can't re-order this code due to cpu_relax(). Cpu can
> > > re-order, but this doesn't matter because both the sender and ipi
> > > handler take call_single_queue->lock.
> > >
> > > And, giwen that csd_unlock() does mb() before csd_unlock(), how
> > > it is possible that other CPU (ipi handler) still uses the old
> > > values in *data after we see !CSD_FLAG_LOCK ?
> >
> > Good point on cpu_relax(), which appears to be at least a compiler
> > barrier on all architectures.
> >
> > I must confess to being in the habit of assuming reordering unless I
> > can prove that such reordering cannot happen.
> 
> Yes, probably you are right...
> 
> But since almost nobody (except you ;) really understands this magic,
> it would be nice to have a comment which explains exactly what is the
> reason for mb(). Otherwise it is so hard to read the code, if you
> don't understand mb(), then you probably missed something important.

An hour-long stress test on both Power 5 and Power 6 failed to
locate a problem, though that of course does not prove lack of a
problem, particularly for CPUs that don't pay as much attention to
control-dependency ordering as Power does.  :-/

The test may be found in CodeSamples/advsync/special/mbtest/mb_lhs_ws.c
in git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/perfbook.git,
if anyone wants to take a look.

In the meantime, I nominate the following comment at the end of
csd_lock():

	/*
	 * prevent CPU from reordering the above assignment to ->flags
	 * with any subsequent assignments to other fields of the
	 * specified call_single_data structure.
	 */

	smp_mb(); /* See above block comment. */

> > > Every time smp_call_function_many() reuses the element, it sets its
> > > ->next pointer to the head of the list. If we race with another CPU
> > > which fetches this pointer, this CPU has to re-scan the whole list,
> > > but since we always modify/read data under data->lock this should
> > > be safe, that CPU must notice (!cpumask_test_cpu(cpu, data->cpumask).
> >
> > You are quite correct.  I guess I should have gone home early instead of
> > reviewing Peter's patch...  :-/
> 
> In that case I shouldn't even try to read this series ;) I was wrong so
> many times...

I suppose that I should be happy to be wrong nine times if I find a subtle
bug on the tenth attempt, but somehow it doesn't feel that way.  ;-)

							Thanx, Paul
