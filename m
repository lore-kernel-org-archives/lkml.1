Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbZBCEeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbZBCEeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZBCEdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:33:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbZBCEdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:33:53 -0500
Date: Mon, 2 Feb 2009 23:33:52 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/3] trace: fix default boot up tracer
In-Reply-To: <20090202202041.6256a566.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0902022327080.2192@gandalf.stny.rr.com>
References: <20090203023830.440860800@goodmis.org> <20090203024358.332574797@goodmis.org> <20090202195021.83bd0b80.akpm@linux-foundation.org> <alpine.DEB.1.10.0902022302060.2192@gandalf.stny.rr.com> <20090202202041.6256a566.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2 Feb 2009, Andrew Morton wrote:
> > 
> > The lock_kernel addition was added when the BKL became a spinlock again. 
> > The selftests needed to be able to sleep, and this caused issues.
> 
> Sleeping inside lock_kernel() is quite OK.  Confused.

I did not explain that quite well. I need to focus on the emails 
that I write, and not do it half concentrating on code that I'm
also writing :-/

The preempt tracer expects preemption enabled when the self test is 
executed. Because the self test for preempt tracer is basically:

start_trace();
preempt_disable();
udelay(x);
preempt_enable();
stop_trace();

make sure we have a delay.

This failed, because lock_kernel now disables preemption. So that 
preempt_disable() never triggers the trace, and the test sees that nothing 
was recorded. This causes a failure to be flagged, and we disable the 
preempt tracer.

> 
> What is the call path to this function?  Does it all happen under
> ftrace_init()?  If not, do we risk breaking start_kernel()'s
> thou-shalt-not-enable-interrupts-early rule which powerpc (at least)
> imposes?

This function is always called via the initcall functions.

> 
> > The register_tracer was initial written to be pluggable at any time. 
> > Perhaps in the future to allow modules. But this does not seem to have 
> > panned out.
> > 
> > Since we have the lock_kernel there anyway, if we ever need to handle 
> > modules, that will need a different interface anyway. I guess I can nuke 
> > the unregister tracer.
> 
> And add some __init/__initdatas?

I'll take some time to analyze what can be annotated.

-- Steve
> 
