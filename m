Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbZHLTNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbZHLTNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 15:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZHLTNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 15:13:13 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42186 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbZHLTNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 15:13:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m7zAZbQQpFPKRfLX4+p+ajM7ny/3BOCf37i5lzQHeOq4zPaROcVtsitHRLme0Enue4
         h4rJlgK/l3Gky1MeIUJYeTkJ26oBsedG0yppOKbdv2hSWj8xE5emIw4SEMr121nPtZAM
         Biu7qsd7CVM4R38BvVgHQ9yhuRSdP8hzcB6KQ=
Date: Wed, 12 Aug 2009 21:13:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>
Subject: [RFD] Kprobes/Kretprobes perf support
Message-ID: <20090812191305.GB5974@nowhere>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <4A82EEC5.8000603@redhat.com> <4A82F5A0.2090603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A82F5A0.2090603@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 01:02:24PM -0400, Masami Hiramatsu wrote:
> 
> 
> Masami Hiramatsu wrote:
> > Hi Frederic and Jason,
> > 
> > Frederic Weisbecker wrote:
> >> Frederic Weisbecker (3):
> >>         tracing: Add ftrace event call parameter to its field descriptor handler
> > 
> >> Jason Baron (12):
> >>         tracing: Add ftrace_event_call void * 'data' field
> > 
> > Both of you added a parameter to ftrace_event_call for passing
> > sycall name (call->data) to handlers, but one passes 'ftrace_event_call *'
> > and another passes 'void *'. It seems not enough unified.
> > 
> > And also, I'm now updating my patch for 'dynamic ftrace_event_call'
> > http://lkml.org/lkml/2009/7/24/234
> > which adds 'ftrace_event_call *' for all handlers.
> > 
> > I think passing 'ftrace_event_call *' is more generic way
> > to do that. What would you think about that?
> 
> Hmm, I changed my mind that passing 'void *' is enough, since
> all other fields of ftrace_event_call will be handled in
> trace_events.c.
> 
> Thank you,



Well, actually I agree with you because:

- struct ftrace_event_call * is typed and let the compiler
  be able to perform basic type checks.
  (Even though that only delays the use of a void * type through
  call->data)

- Further dynamic trace events might need other fields of struct ftrace_event_call *

While adding the struct ftrace_event_call * as parameter in the show_format
callback yesterday, I first thought about applying your "dynamic ftrace
event creation" patch.

But it was just too much for what I needed.

Speaking about your patches. You told recently you would be willing
to implement a perf support for kprobes, right? :-)

I've thought about how to do that.
Ftrace events are supported by perfcounter currently but Kprobes
dynamic ftrace events are of a different nature: we must create them
before any toggling.

So a large part is already done through the ftrace events and the fact
that you create one dynamically for each kprobes (we'll just need
a little callback for perf sample submission but that's a small
point).

The largest work that remains is to port the current powerful interface
to create these k{ret}probes (with requested  arguments, etc...) through
ftrace but using perf open syscall.

And I imagine it won't be trivial.

Ingo, Peter do you have an idea on how we could do that?
We should be able to choose between a kprobe and kretprobe (these can
be two separate counters). And also one must be able to request the dump
of random desired parameters (or return values in case of kretprobe)
or registers...

May be we should use the perf attr by passing a __user address to a buffer
that contains all these options?
Once we get that to the kernel, that can be passed to ftrace-kprobe that
can parse it, create the desired trace event and rely on perf to create
a counter for it.

I guess that won't imply so much adds to Masami's patchset. Most of
the work is on the perf tools (parsing the user request).

./perf kprobes -e (func|addr):(c|r):(a1,a2,a3,... | rax,rbx,rcx,...)
                              ^  ^
                           c = call = kprobe
                           r = return = kretprobe

