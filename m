Return-Path: <linux-kernel-owner+w=401wt.eu-S1761089AbZAQNsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089AbZAQNsq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 08:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbZAQNsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 08:48:36 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:59417 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbZAQNsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 08:48:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hDon0F4OO5rYV4V47ifyDiAmPOF2kl9BYZHrcdQBqKABQS1aJ+UbGr0JJQZ6qr1358
         vamTH90/nE/T1YWPe8fuUTYYbHvJgo3s/zrI6KKElX180RWtQ70ijmXzNzZ0sg5BDj1Q
         fTGGKJ8W1oofm/mNiY4WZt8S0/Jk3ro7KxHqM=
Date: Sat, 17 Jan 2009 14:48:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
Message-ID: <20090117134829.GB8413@nowhere>
References: <20090116004050.273665842@goodmis.org> <20090116112345.GC20082@elte.hu> <alpine.DEB.1.10.0901160929300.22303@gandalf.stny.rr.com> <20090116152103.GA28643@elte.hu> <alpine.DEB.1.10.0901161050470.22303@gandalf.stny.rr.com> <20090116160202.GA15209@elte.hu> <alpine.DEB.1.10.0901161111490.22303@gandalf.stny.rr.com> <20090116163021.GA27495@elte.hu> <20090116225948.GA12314@elte.hu> <alpine.DEB.1.10.0901162003000.9232@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901162003000.9232@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 08:14:25PM -0500, Steven Rostedt wrote:
> 
> On Fri, 16 Jan 2009, Ingo Molnar wrote:
> 
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > I was afraid you would say that :-)
> > > > 
> > > > Yes, we could add something to do this. It would take some thought on 
> > > > a good api, and implementation. This is not an easy task by any means. 
> > > > We need a way to map between a function call and a tracer, where a 
> > > > function call can call more than one tracer.
> > > 
> > > Note that some other things could be consolidated under per function 
> > > metadata: for example set_graph_function - which really is a per 
> > > function attribute too. Plus a lot of new things would be enabled i 
> > > think.
> > 
> > a few other things that could be per-function attributes:
> > 
> >  - Using function trace 'limits': trace a function 50 times and dont trace 
> >    it afterwards. Each invocation of that function decreases the
> >    remaining-count by one. For example:
> > 
> >      echo 'btrfs_join_transaction:#2' >> set_ftrace_filter
> > 
> >    Would specify that we generate two trace entries of
> >    btrfs_join_transaction(), then stop tracing this function.
> > 
> >  - Using function-triggered tracing: a function could be specified (via a 
> >    filter format extension) to act as a 'start tracing' trigger. Another 
> >    extension would be 'stop tracing' trigger.
> > 
> >    For example:
> > 
> >       echo 'btrfs_join_transaction:+' >> set_ftrace_filter
> >       echo 'btrfs_commit_transaction:-' >> set_ftrace_filter
> > 
> >    The '+' is a start-tracing trigger condition, the '-' is a stop-tracing 
> >    trigger condition. All function calls between btrfs_join_transaction() 
> >    and btrfs_commit_transaction() would be traced.
> > 
> > The two could be combined - to generate the trace of a single btrfs 
> > transaction, one could do:
> > 
> >       echo 0 > tracing_enabled
> >       echo 'btrfs_join_transaction:+#1' >> set_ftrace_filter
> >       echo 'btrfs_commit_transaction:-#1' >> set_ftrace_filter
> >       echo 1 > tracing_enabled
> > 
> > Other extensions are possible too:
> > 
> >  - Trace length triggers. For example one could do:
> > 
> >       echo 'btrfs_join_transaction:+*#10' >> set_ftrace_filter
> > 
> >    To trace 10 function calls [allowed by current filter settings] after
> >    the first btrfs_join_transaction() call - and stop tracing after those 
> >    10 trace entries.
> > 
> > This would allow the creation of "surgical" one-time traces - of events 
> > and functions one is specifically interested in.
> 
> This all sounds great, but it would add a lot of conditionals into a 
> extremely hot function tracer path. Remember, we are not modifying the 
> calls to mcount to call a registered function directly. All functions 
> being traced must call the same function. The reason is that mcount is not 
> a normal function in C. It does not behave the same as other functions, 
> and must be implemented in assembly (as you already know ;-) The dynamic 
> tracer calls into a trampoline that calls the registered function. There 
> is only one trampoline, so only one function gets called on a trace. We 
> can at most enable or disable a given function. We can not change what 
> that function calls (without implementing it for every arch).
> 
> This means any conditional that you make, must be made for all traced 
> functions. And this will put an overhead onto the system.
> 
> Now we can register multiple functions to be called by a traced function, 
> or pick and choose what function will be called by a traced function
> depending on what option was asked for. But all traced functions will 
> still call the same code.


We could use a kind of ftrace_filter thing which would be a list of callbacks
to call, depending of the options set.

This would add one condition to verify for each function in the best case.



> We can start experimenting, but I would 
> be more keen on how this will be used by developers. Chris gave a great 
> example of how he would use his feature. Doing what you ask would require 
> a rewrite of most the code. I hate to do that and have only 2 or 3 people 
> using it :-/
> 
> -- Steve
> 

