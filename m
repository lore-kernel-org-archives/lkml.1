Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbZBANyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbZBANyq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 08:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZBANyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 08:54:37 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43987 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbZBANyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 08:54:36 -0500
Date: Sun, 1 Feb 2009 05:54:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       richardj_moore@uk.ibm.com, naren@linux.vnet.ibm.com
Subject: Re: [RFC Patch 1/10] Introducing generic hardware breakpoint
	handler interfaces
Message-ID: <20090201135433.GE7021@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090130111914.GB13814@in.ibm.com> <Pine.LNX.4.44L0.0901301044540.2466-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0901301044540.2466-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 10:55:39AM -0500, Alan Stern wrote:
> On Fri, 30 Jan 2009, K.Prasad wrote:
> 
> > > A few RCU-related questions below.
> > > 
> > > 							Thanx, Paul
> 
> Paul, you've got to learn to trim your replies!  It's not nice to have
> to skim over hundreds and hundreds lines of quoted text while searching
> for your interpolated comments.  In fact, the phrase "needle in a 
> haystack" springs to mind...

I should have said "search for empty lines", but yes, I should have
trimmed a bit.  My apologies!!!

> > > > +	thr_kbpdata = chbi->cur_kbpdata;
> > > > +	barrier();
> > > 
> > > Couldn't the above two lines instead be:
> > > 
> > > 	thr_kbpdata = ACCESS_ONCE(chbi->cur_kbpdata);
> > > 
> > > This would prevent the pointer aliasing, but would make it very clear
> > > exactly how the compiler was to be restricted.
> > 
> > Ok. Using a barrier() could be an overkill. I will change it.
> 
> IIRC, the original code above was written before ACCESS_ONCE came into
> being.  But I could be wrong about that...

Could well be, ACCESS_ONCE() showed up in 2.6.24, and moved out of
rcupdate.h a couple of releases later.

> > > > +/*
> > > > + * Tell all CPUs to update their debug registers.
> > > > + *
> > > > + * The caller must hold hw_breakpoint_mutex.
> > > > + */
> > > > +static void update_all_cpus(void)
> > > > +{
> > > > +	/* We don't need to use any sort of memory barrier.  The IPI
> > > > +	 * carried out by on_each_cpu() includes its own barriers.
> > > > +	 */
> > > > +	on_each_cpu(update_this_cpu, NULL, 0);
> > > > +	synchronize_rcu();
> > > 
> > > Don't we need the rcu_read_lock() / rcu_read_unlock() pair from
> > > load_debug_registers() to move down into update_this_cpu() in order
> > > for this to be guaranteed to work?  As the code reads now, the
> > > update_this_cpu() calls running on other CPUs are not running under
> > > RCU protection, right?
> 
> Maybe I'm misunderstanding the question.  update_this_cpu() is called
> from only two places: on_each_cpu() as shown above, and
> load_debug_registers().  It seems clear that contexts resulting from
> on_each_cpu() don't need RCU protection, because on_each_cpu() won't
> return until those routines have completed.
> 
> This leaves only contexts resulting from load_debug_registers().  But
> the first thing load_debug_registers() does is disable local
> interrupts, thus blocking IPI delivery.  Hence any simultaneous
> on_each_cpu() won't complete until after load_debug_registers() is
> done.
> 
> So there doesn't seem to be any need for RCU protection in
> update_this_cpu().
> 
> > Yes, indeed. With the current implementation, there's a possibility of
> > two instances of update_this_cpu() function executing - one with an
> > rcu_read_lock() taken (when called from load_debug_registers) while the
> > other without (when invoked through update_all_cpus()).
> 
> No, this isn't possible unless I have misunderstood the nature of
> IPIs.  Isn't is true that calling local_irq_save() will block delivery
> of IPIs?

Touche!  ;-)

But in that case, why do you need the synchronize_rcu() following the
on_each_cpu() above?  Is this needed to make sure that any concurrent
load_debug_registers() call has completed?

							Thanx, Paul
