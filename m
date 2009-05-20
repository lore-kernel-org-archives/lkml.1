Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZETBAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZETBAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 21:00:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbZETA7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 20:59:52 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:47106 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbZETA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 20:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WhU4euqqJQkSyRvkOLOkj6614dcuW5LionPar/knmnexlmEEpzPzxgsHlHltU5c3VV
         ZwB72jcN8mLsEcGKvqpYi17hc8lqiF0L3WJDbDHKrTgKQJ002MM5qCt7Tbh9D/SizDD2
         ehP/ZHXUfvGSoJz0BtJOY/i5z65180gVgbFx4=
Date: Wed, 20 May 2009 02:59:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: add trace_event_read_lock()
Message-ID: <20090520005948.GF6066@nowhere>
References: <4A114806.7090302@cn.fujitsu.com> <20090518135930.GC4704@nowhere> <20090519003505.GK6768@linux.vnet.ibm.com> <4A124080.7010400@cn.fujitsu.com> <20090519123853.GC7159@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090519123853.GC7159@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 05:38:53AM -0700, Paul E. McKenney wrote:
> On Tue, May 19, 2009 at 01:15:44PM +0800, Lai Jiangshan wrote:
> > Paul E. McKenney wrote:
> > > On Mon, May 18, 2009 at 03:59:31PM +0200, Frederic Weisbecker wrote:
> > >> On Mon, May 18, 2009 at 07:35:34PM +0800, Lai Jiangshan wrote:
> > >>> I found that there is nothing to protect event_hash in
> > >>> ftrace_find_event().
> > >> Actually, rcu protects it, but not enough. We have neither
> > >> synchronize_rcu() nor rcu_read_lock.
> > >>
> > >> So we protect against concurrent hlist accesses.
> > >> But the event can be removed when a module is unloaded,
> > >> and that can happen between the time we get the event output
> > >> callback and the time we actually use it.
> > > 
> > > I will ask the stupid question...  Would invoking rcu_barrier() in the
> > > module-exit function take care of this?  The rcu_barrier() primitive
> > > waits for all in-flight RCU callbacks to complete execution.
> > > 
> > > 							Thanx, Paul
> > > 
> > 
> > We have no call_rcu* in it.
> 
> OK, I will ask the next stupid question...  Is it possible to use the
> same trick rcu_barrier() uses, but for your events?
> 
> 							Thanx, Paul


Hi Paul,

I think you're right, we could use RCU to solve this race.

The current race window to solve is as follows:


--Task A--

print_trace_line(trace) {
	event = find_ftrace_event(trace) {
			hlist_for_each_entry_rcu(....) {
				...
				return found;
		}
	}


--Task B--

/*
 * Can be quite confusing.
 * But we have "trace events" which are global objects
 * handling tracing, output, everything.
 * And we have also "ftrace events" which are unique
 * identifiers on traces than make them able to retrieve  
 * their associated output callbacks.
 * So a "trace event" has an associated "ftrace event" to output
 * itself.
 */

trace_module_remove_events(mod) {
	list_trace_events_module(ev, mod) {
		unregister_ftrace_event(ev->event) {
			// mutex protected
			hlist_del(ev->event->node)
			list_del(....)
			//
		}
	}
}
//module removed

-- Task A--

event->print(trace) 

KABOOM! print callback was on the module. event doesn't even exist anymore.

So Lai's solution is correct to fix it.
But rcu is also valid.

Currently rcu only protects the hashlist but not the callback until
the job is complete.

What we could do is:

(Read side)

rcu_read_lock();

event = find_ftrace_event();
event->print(trace);

rcu_read_unlock()

(Write side)

unregister_ftrace_event(e)
{
	mutex_lock(&writer);
	hlist_del(e);
	list_del(e);
	mutex_unlock(&writer);

	// Wait for every printing grace periods
	synchronize_rcu();
}


Then the only overhead is a preempt_disable()/preempt_enable()
for each trace to be printed. Just a sub/add pair and quite few
preemption disabled latency, just the time for a hashlist search
and some work done to format a trace to be printed.
But if latency does really matters, we have RCU_PREEMPT.

On the other side, the down_read() is an extra call but it is called
only once for a whole loop of traces seeking.

I guess both solutions are valid.
What do you think?

Thanks,

Frederic.



