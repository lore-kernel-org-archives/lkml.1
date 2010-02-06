Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0BFMUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 07:20:15 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:38746 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab0BFMUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 07:20:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jU3U3qKgXTv9nT9PgSNyraBMV7t0PNoA9mlpcCCLjDl59I08EpF8cM0+WQo8b0LI6R
         RBMpAvL9WptMuwiT6vfPNQsid50ZCCJHR0LNsxkvieFk4rEBVsN1IYg2gfGsr5fI2i4v
         InWfdwFa8SRMK7fTMpgtuvQgDE88CAoDd32nQ=
Date: Sat, 6 Feb 2010 13:20:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 02/11] tracing: Introduce TRACE_EVENT_INJECT
Message-ID: <20100206122004.GF5062@nowhere>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com> <1265188475-23509-3-git-send-regression-fweisbec@gmail.com> <1265381266.24386.32.camel@gandalf.stny.rr.com> <1265381604.22001.682.camel@laptop> <1265382452.24386.38.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265382452.24386.38.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 10:07:32AM -0500, Steven Rostedt wrote:
> How would it be dumping all?
> 
> You need to pick an event to register, not all events will do this.
> 
> How is this different than defining a TRACE_EVENT_INJECT()?  Now
> lock_class_init will always call this inject.
> 
> What I am proposing is to add the lock_class_init just as TRACE_EVENT()
> and then in a initcall, do:
> 
> register_event_command("lock_class_init", NULL, NULL, inject_me, 
> 			inject_me, data);
> 
> The above would have lock_class_init, when enabled or disabled call
> inject_me. Isn't that exactly what the TRACE_EVENT_INJECT() is doing?
> 
> I have no qualms about adding lock_class_init, I just don't think we
> need another TRACE_EVENT macro, that is very inflexible. I rather
> consolidate the macros in ftrace.h than be adding new ones.


This won't work for perf needs because:

1) we need this call to be asynchronous, ie: called whenever we
   want.

Basically, the injection of this event is required for other
lock events to be understandable. It is split in two parts:

* a normal trace event, synchronous, that has a normal trace_* thing
  call site. This tracks the new lock classes created.
* an asynchronous point that catch up with old events we need.

These two parts cover all lock init events we need.

But there is a reason I haven't made this injection callback something
we call once the event gets enabled (I had a first version using
TRACE_EVENT_CALLBACK, but it didn't work), because when perf registers
a trace event, it is not yet scheduled in, not at the same time but
a bit after (it's even more complicated from perf tools as we
create every events as disabled first and enable them later).

So if you call the injector right after registering a user for
the trace event, the injected events will be refused by perf,
as it is not yet set up in the context.

This is why perf needs to choose the time when this injector
is called.

2) we don't want to call that for every lock init events
   registered

We create one lock_init perf event per cpu, only one will need
to call this injector. We just need to catch up with old events
only once.


3) perf and ftrace need the same injector callback here.

4) but ftrace needs this callback to be called when the event gets
enabled (otherwise, other lock init events just don't make sense).

I agree with you that creating a new trace event macro is a bit
insane. ftrace.h is already a nightmare. I just thought that
having the injector set inside the same macro that the synchronous
event is defined helped to make it clear about its nature: that
it needs a secondary async catch up thing.

But a register_event_injector thing will work too, we probably
better want that, given the maintainance pain otherwise.

I really would like to make something useful for everyone, could
you tell me more about johill needs?

Thanks.

