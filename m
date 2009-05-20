Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbZEYWKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbZEYWKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbZEYWJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:09:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55604 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbZEYWJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:09:50 -0400
Date: Tue, 19 May 2009 21:38:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] tracing: add trace_event_read_lock()
Message-ID: <20090520043833.GB6925@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4A114806.7090302@cn.fujitsu.com> <20090518135930.GC4704@nowhere> <20090519003505.GK6768@linux.vnet.ibm.com> <4A124080.7010400@cn.fujitsu.com> <20090519123853.GC7159@linux.vnet.ibm.com> <20090520005948.GF6066@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520005948.GF6066@nowhere>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 02:59:50AM +0200, Frederic Weisbecker wrote:
> On Tue, May 19, 2009 at 05:38:53AM -0700, Paul E. McKenney wrote:
> > On Tue, May 19, 2009 at 01:15:44PM +0800, Lai Jiangshan wrote:
> > > Paul E. McKenney wrote:
> > > > On Mon, May 18, 2009 at 03:59:31PM +0200, Frederic Weisbecker wrote:
> > > >> On Mon, May 18, 2009 at 07:35:34PM +0800, Lai Jiangshan wrote:
> > > >>> I found that there is nothing to protect event_hash in
> > > >>> ftrace_find_event().
> > > >> Actually, rcu protects it, but not enough. We have neither
> > > >> synchronize_rcu() nor rcu_read_lock.
> > > >>
> > > >> So we protect against concurrent hlist accesses.
> > > >> But the event can be removed when a module is unloaded,
> > > >> and that can happen between the time we get the event output
> > > >> callback and the time we actually use it.
> > > > 
> > > > I will ask the stupid question...  Would invoking rcu_barrier() in the
> > > > module-exit function take care of this?  The rcu_barrier() primitive
> > > > waits for all in-flight RCU callbacks to complete execution.
> > > > 
> > > > 							Thanx, Paul
> > > > 
> > > 
> > > We have no call_rcu* in it.
> > 
> > OK, I will ask the next stupid question...  Is it possible to use the
> > same trick rcu_barrier() uses, but for your events?
> > 
> > 							Thanx, Paul
> 
> 
> Hi Paul,
> 
> I think you're right, we could use RCU to solve this race.
> 
> The current race window to solve is as follows:
> 
> 
> --Task A--
> 
> print_trace_line(trace) {
> 	event = find_ftrace_event(trace) {
> 			hlist_for_each_entry_rcu(....) {
> 				...
> 				return found;
> 		}
> 	}
> 
> 
> --Task B--
> 
> /*
>  * Can be quite confusing.
>  * But we have "trace events" which are global objects
>  * handling tracing, output, everything.
>  * And we have also "ftrace events" which are unique
>  * identifiers on traces than make them able to retrieve  
>  * their associated output callbacks.
>  * So a "trace event" has an associated "ftrace event" to output
>  * itself.
>  */
> 
> trace_module_remove_events(mod) {
> 	list_trace_events_module(ev, mod) {
> 		unregister_ftrace_event(ev->event) {
> 			// mutex protected
> 			hlist_del(ev->event->node)
> 			list_del(....)
> 			//
> 		}
> 	}
> }
> //module removed

Ouch!!!  ;-)

> -- Task A--
> 
> event->print(trace) 
> 
> KABOOM! print callback was on the module. event doesn't even exist anymore.
> 
> So Lai's solution is correct to fix it.
> But rcu is also valid.
> 
> Currently rcu only protects the hashlist but not the callback until
> the job is complete.
> 
> What we could do is:
> 
> (Read side)
> 
> rcu_read_lock();
> 
> event = find_ftrace_event();
> event->print(trace);

As long as event->print() never blocks...

Though you could use SRCU if it might block:

	rcu_read_lock()		->	i = srcu_read_lock(&my_srcu_struct);
	rcu_read_unlock()	->	srcu_read_unlock(&my_srcu_struct, i);
	synchronize_rcu()	->	synchronize_srcu(&my_srcu_struct);

> rcu_read_unlock()
> 
> (Write side)
> 
> unregister_ftrace_event(e)
> {
> 	mutex_lock(&writer);
> 	hlist_del(e);
> 	list_del(e);
> 	mutex_unlock(&writer);
> 
> 	// Wait for every printing grace periods
> 	synchronize_rcu();
> }
> 
> 
> Then the only overhead is a preempt_disable()/preempt_enable()
> for each trace to be printed. Just a sub/add pair and quite few
> preemption disabled latency, just the time for a hashlist search
> and some work done to format a trace to be printed.
> But if latency does really matters, we have RCU_PREEMPT.
> 
> On the other side, the down_read() is an extra call but it is called
> only once for a whole loop of traces seeking.
> 
> I guess both solutions are valid.
> What do you think?

It could go either way.  As a very rough rule of thumb, if the down_read()
happens seldom, there is little advantage to RCU.  On the other hand,
if the down_read() could happen often enough that a new reader shows up
before the previous down_read() completes, then you really need RCU or
something like it.

On most systems, if down_read() was happening more than a few million
times per second, life might be hard.  On the other hand, if down_read()
never happened more than a few tens of thousand times per second or so,
should be no problem.

Since it sounds like a single down_read() substitutes for a potentially
large number of RCU read-side critical sections, I do not believe that
contention-free read-side overhead would be a problem.

Does that help?

							Thanx, Paul
