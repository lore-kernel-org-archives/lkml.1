Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbZETAZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbZETAZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 20:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZETAY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 20:24:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:37809 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbZETAY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 20:24:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=enipkr8hYdYduHwgB/m7GuSPpSCJAIbRbMyKcPmvbp3r4AWAEDtkvee1+DMWXRYwc8
         Y0g+8+l83/xfzlH79cqoXWMBdujtcG/wE446fQpm3/ETO13TWxzW4z7Y/GBnKK6D1rOQ
         RrNhNwoShtT9oKmDKg+ikKsr2fO66dNwyiILc=
Date: Wed, 20 May 2009 02:24:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] tracing: add trace_event_read_lock()
Message-ID: <20090520002451.GE6066@nowhere>
References: <4A114806.7090302@cn.fujitsu.com> <20090518135930.GC4704@nowhere> <4A1213E1.8050608@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1213E1.8050608@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 10:05:21AM +0800, Lai Jiangshan wrote:
> Frederic Weisbecker wrote:
> > On Mon, May 18, 2009 at 07:35:34PM +0800, Lai Jiangshan wrote:
> >> I found that there is nothing to protect event_hash in
> >> ftrace_find_event().
> > 
> > 
> > 
> > Actually, rcu protects it, but not enough. We have neither
> > synchronize_rcu() nor rcu_read_lock.
> 
> We have no rcu_read_lock(), RCU can not protects it.
> 
> > 
> > So we protect against concurrent hlist accesses.
> > But the event can be removed when a module is unloaded,
> > and that can happen between the time we get the event output
> > callback and the time we actually use it.
> > 
> 
> [...]
> 
> > It could be more fine grained.
> 
> I think it's fine-grained enough, write-side(modules loading/unloading)
> is happened rarely. trace_event_read_lock() will not sleep very likely.
> 
> Thoughts?


Yeah, the write lock is a rare event, that's why I think
it's enough fine grained.

 
> > We could have a per event rwsem, and also place the
> > protected read section only in trace_print_entry() which is the only racy window.
> > 
> 
> print_trace_line() is the only racy window.
> So I just protect print_trace_line()(except __ftrace_dump())
> 
> I protect loops which call print_trace_line(), it
> reduces invoke-times:
> 
> trace_event_read_lock();
> while (...) {
> 	...
> 	print_trace_line();
> 	...
> }
> trace_event_read_unlock();



Yeah, I meant it could have been:

trace_event_read_lock();
print_trace_line();
trace_event_read_unlock();

It's more fine grained, but:

- the write lock path is rarely taken
- it would add more extra calls then more overhead

IMO this is fine as an rwsem design point of view.

But I have mixed feelings when I consider it could be
done using rcu. I will explain that in my next answer to
Paul and will wait for your comments.

Thanks!

Frederic.


> Thanks!
> Lai
> 
> > But I'm not sure it's that worthy since event removal is a rare thing.
> > 
> > So I guess this patch is fine.
> > 
> > 
> > 
> > 
> 
> 

