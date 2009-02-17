Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbZBQMt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbZBQMt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 07:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZBQMtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 07:49:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63510 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZBQMtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 07:49:50 -0500
Date: Tue, 17 Feb 2009 07:49:49 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/15] [git pull] for tip/tracing/ftrace
In-Reply-To: <20090217104213.GC6602@elte.hu>
Message-ID: <alpine.DEB.1.10.0902170747160.910@gandalf.stny.rr.com>
References: <20090217051227.957864159@goodmis.org> <20090217104213.GC6602@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Feb 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > This is a patch series that offers a variety of features.
> > 
> > The first is to add:
> > 
> >  #### all functions enabled ####
> > 
> > to set_ftrace_filter when all functions will be traced when function
> > tracing is on.
> > 
> > The next is to add a :command: interface, and the module command:
> > 
> >  echo '*:mod:ext4' > set_ftrace_filter
> > 
> > Will select all functions in the ext4 module.
> > 
> >  echo '!*write*:mod:ext4' > set_ftrace_filter
> > 
> > will remove all functions with the characters 'write' and are
> > in ext4.
> 
> Very nice feature!
> 
> I'm wondering, would it be possible to somehow extend this to 
> built-in drivers too, so that we get symmetry of usage 
> independently of whether something is built in or a module? I 
> suspect it needs some extensions to kbuild though ...

Yeah, that may needs some kbuild magic.

> 
> > Next we extend the :command: interface as well as add a way to
> > hook tracers to specific functions. Instead of tracing all functions
> > the same, this patch series adds a hash to be able to trace different
> > functions differently.
> 
> That's a nice extension too!
> 
> Small naming detail: instead of calling it a 'hook' (which 
> really has a bad sound to it for various reasons), how about 
> calling it a 'trigger' and/or a 'callback'?

Hmm, I can switch it to trigger. I used callback in too many other
places in this series, and that would lead to more confusion.

> 
> > I implement a 'traceon' and 'traceoff' to have a function 
> > start or stop tracing when it is hit. It also includes a 
> > counter for the number of times to implement the trace on/off.
> > 
> >  echo '*_lock:traceon:4' > set_ftrace_filter
> >  echo '*_unlock:traceoff:5' > set_ftrace_filter
> 
> if there's no counter specified, does it default to 1 
> [single-shot trigger] or infinity?

Bad documentation on my part :-/

No number is infinity, since infinity is no number ;-)

> 
> > This will have all functions that end with _lock turn on 
> > tracing and all that end with _unlock disable it, 4 times 
> > each.
> > 
> > The following patches are in:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > 
> >     branch: tip/tracing/ftrace
> > 
> > 
> > Steven Rostedt (15):
> >       ftrace: state that all functions are enabled in set_ftrace_filter
> >       ftrace: add do_for_each_ftrace_rec and while_for_each_ftrace_rec
> >       ftrace: rename ftrace_match to ftrace_match_records
> >       ftrace: break up ftrace_match_records into smaller components
> >       ftrace: add module command function filter selection
> >       ftrace: enable filtering only when a function is filtered on
> >       ftrace: add command interface for function selection
> >       ftrace: convert ftrace_lock from a spinlock to mutex
> >       ftrace: consolidate mutexes
> >       ftrace: trace different functions with a different tracer
> >       ring-buffer: add tracing_is_on to test if ring buffer is enabled
> >       ftrace: add traceon traceoff commands to enable/disable the buffers
> >       ftrace: show selected functions in set_ftrace_filter
> >       ftrace: add pretty print to selected fuction traces
> >       ftrace: add pretty print function for traceon and traceoff hooks
> > 
> > ----
> >  include/linux/ftrace.h         |   40 ++
> >  include/linux/ring_buffer.h    |    2 +
> >  kernel/trace/ftrace.c          |  929 +++++++++++++++++++++++++++++++---------
> >  kernel/trace/ring_buffer.c     |    9 +
> >  kernel/trace/trace_functions.c |  163 +++++++
> >  5 files changed, 946 insertions(+), 197 deletions(-)
> 
> Pulled into tip:tracing/ftrace, thanks Steve!

Thanks! This answers my other question. I'll be sending out clean up 
patches later today.

-- Steve

