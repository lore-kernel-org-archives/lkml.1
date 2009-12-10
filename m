Return-Path: <linux-kernel-owner+w=401wt.eu-S1762012AbZLJWkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762012AbZLJWkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761999AbZLJWkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:40:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49772 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761859AbZLJWkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:40:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dcQiOroFFtcSciq04tqyaK5ElDw7yIMVKS7iESVZdPG90QHg9JlzilViPM66Qjfg+3
         /QFDQllQI4F2BA7uFrvJ2jT5COHPD9F5NC5aQdcHbOKWUCjPg1zihW5PQ//Yem9DOqZG
         lZBaBqTM3RcFyqh+8yIwUswiRbON4d58f7V7Q=
Date: Thu, 10 Dec 2009 23:40:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
Message-ID: <20091210224019.GB6135@nowhere>
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu> <20091210120332.GA5042@nowhere> <1260455367.2146.143.camel@gandalf.stny.rr.com> <20091210202317.GA6135@nowhere> <1260482143.2146.224.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260482143.2146.224.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 04:55:43PM -0500, Steven Rostedt wrote:
> On Thu, 2009-12-10 at 21:23 +0100, Frederic Weisbecker wrote:
> > Oh no, I'm not planning to use tracepoints for that.
> 
> Thank goodness ;-)


:)


 
> > Hmm, yeah. The idea was just to move the use the struct trace to struct
> > trace_event. This would be about straightforward. A bit like kprobes: by
> > not using the TRACE_EVENT macros (would be impossible anyway) but
> > specific callbacks.
> 
> Hmm, please keep the use of struct tracer around. That is still a very
> powerful utility.


Sure. The goal is to move the function graph tracer into a
more unified interface that can profit to a wider range of
uses (perf being the new user I have in mind), and also to
make it easier to use concurrently.

But I'm not dropping struct tracer, as I too think that until
we have something superior (and not only potentially superior),
we need to keep it. And I'm pretty sure we all think the same.

But if I convert the graph tracer into the trace event interface,
I guess we shouldn't maintain its struct tracer version in
parallel.

 
> > But later on, a full trace event integration would probably imply
> > dicossiating dynamic tracing from the two function tracers.
> > For example if the function graph tracer asks to nop a function,
> > this shouldn't be propagated to a parallel function tracer user.
> > That's even worse once we get a perf integration, we can have
> > multiple parallel users of the function tracer. And patching
> > should probably adapt to parallel uses, maintaining a kind of
> > refcounting, extending the current function hashlist we have
> > for function profiling could probably help for that.
> 
> Yeah, this gets a bit complicated. The biggest issue is that the mcount
> call is not C abi, so it must go through some sort of trampoline. I've
> thought about making a dynamic trampoline, but again, that will start
> hogging up memory, and I'm not sure it is worth it.


Yeah, that would be too complicated and hard to maintain.

 
> I gave this some thought, and the best we could do is have a ref counter
> with the ftrace record itself. We need a global flag to know if all
> functions need to replace a nop to trace caller, or just some. That way
> we can have one tracer tracing all functions and another tracing just
> some. We sorta have that today though.
> 
> Making the API to this infrastructure will also take some thought. We
> currently can register a function to be called by the function tracer
> (we can today register more than one). But the filtering is at a global
> level. We need a way to have a tracer tell ftrace that it wants to trace
> all or some functions, as well as make up its mind later. Then this
> function can be called by all, or if a function in some hash table says
> its OK to be called.


Yeah, I thought about that too.
May be can we keep the current list of ftrace records.

Then when a random function tracer registers, we give it
a dedicated hashlist of functions (which kind of mirrors
the ftrace records, but in a hashlist fashion).

When it wants to trace a set of functions, we set appropriate
flags in its hashlist and the ftrace core patch the sites if
needed.

Once we want to disable tracing on functions, we disable it
on the tracer hashlist, then the ftrace core goes through
the list of every tracer hashlist and counts the current
users of the function, if there are no more of them, we nop
back the site. Well, that could be refcount in ftrace records
too.

But the point is this hashlist. I don't think it will be that
much a huge memory consumer as I don't expect there will ever be a
lot of concurrent function tracing users at the same time.

I just hope we can make it smart enough to be a near true O(1)
hashlist.

Just an idea...

