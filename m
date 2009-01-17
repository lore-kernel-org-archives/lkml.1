Return-Path: <linux-kernel-owner+w=401wt.eu-S1762222AbZAQBOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762222AbZAQBOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 20:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbZAQBO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 20:14:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbZAQBO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 20:14:27 -0500
Date: Fri, 16 Jan 2009 20:14:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
In-Reply-To: <20090116225948.GA12314@elte.hu>
Message-ID: <alpine.DEB.1.10.0901162003000.9232@gandalf.stny.rr.com>
References: <20090116004050.273665842@goodmis.org> <20090116112345.GC20082@elte.hu> <alpine.DEB.1.10.0901160929300.22303@gandalf.stny.rr.com> <20090116152103.GA28643@elte.hu> <alpine.DEB.1.10.0901161050470.22303@gandalf.stny.rr.com> <20090116160202.GA15209@elte.hu>
 <alpine.DEB.1.10.0901161111490.22303@gandalf.stny.rr.com> <20090116163021.GA27495@elte.hu> <20090116225948.GA12314@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 16 Jan 2009, Ingo Molnar wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > I was afraid you would say that :-)
> > > 
> > > Yes, we could add something to do this. It would take some thought on 
> > > a good api, and implementation. This is not an easy task by any means. 
> > > We need a way to map between a function call and a tracer, where a 
> > > function call can call more than one tracer.
> > 
> > Note that some other things could be consolidated under per function 
> > metadata: for example set_graph_function - which really is a per 
> > function attribute too. Plus a lot of new things would be enabled i 
> > think.
> 
> a few other things that could be per-function attributes:
> 
>  - Using function trace 'limits': trace a function 50 times and dont trace 
>    it afterwards. Each invocation of that function decreases the
>    remaining-count by one. For example:
> 
>      echo 'btrfs_join_transaction:#2' >> set_ftrace_filter
> 
>    Would specify that we generate two trace entries of
>    btrfs_join_transaction(), then stop tracing this function.
> 
>  - Using function-triggered tracing: a function could be specified (via a 
>    filter format extension) to act as a 'start tracing' trigger. Another 
>    extension would be 'stop tracing' trigger.
> 
>    For example:
> 
>       echo 'btrfs_join_transaction:+' >> set_ftrace_filter
>       echo 'btrfs_commit_transaction:-' >> set_ftrace_filter
> 
>    The '+' is a start-tracing trigger condition, the '-' is a stop-tracing 
>    trigger condition. All function calls between btrfs_join_transaction() 
>    and btrfs_commit_transaction() would be traced.
> 
> The two could be combined - to generate the trace of a single btrfs 
> transaction, one could do:
> 
>       echo 0 > tracing_enabled
>       echo 'btrfs_join_transaction:+#1' >> set_ftrace_filter
>       echo 'btrfs_commit_transaction:-#1' >> set_ftrace_filter
>       echo 1 > tracing_enabled
> 
> Other extensions are possible too:
> 
>  - Trace length triggers. For example one could do:
> 
>       echo 'btrfs_join_transaction:+*#10' >> set_ftrace_filter
> 
>    To trace 10 function calls [allowed by current filter settings] after
>    the first btrfs_join_transaction() call - and stop tracing after those 
>    10 trace entries.
> 
> This would allow the creation of "surgical" one-time traces - of events 
> and functions one is specifically interested in.

This all sounds great, but it would add a lot of conditionals into a 
extremely hot function tracer path. Remember, we are not modifying the 
calls to mcount to call a registered function directly. All functions 
being traced must call the same function. The reason is that mcount is not 
a normal function in C. It does not behave the same as other functions, 
and must be implemented in assembly (as you already know ;-) The dynamic 
tracer calls into a trampoline that calls the registered function. There 
is only one trampoline, so only one function gets called on a trace. We 
can at most enable or disable a given function. We can not change what 
that function calls (without implementing it for every arch).

This means any conditional that you make, must be made for all traced 
functions. And this will put an overhead onto the system.

Now we can register multiple functions to be called by a traced function, 
or pick and choose what function will be called by a traced function
depending on what option was asked for. But all traced functions will 
still call the same code. We can start experimenting, but I would 
be more keen on how this will be used by developers. Chris gave a great 
example of how he would use his feature. Doing what you ask would require 
a rewrite of most the code. I hate to do that and have only 2 or 3 people 
using it :-/

-- Steve

