Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZBCEMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZBCEMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZBCEMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:12:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61910 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZBCEMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:12:39 -0500
Date: Mon, 2 Feb 2009 23:12:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/3] trace: fix default boot up tracer
In-Reply-To: <20090202195021.83bd0b80.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0902022302060.2192@gandalf.stny.rr.com>
References: <20090203023830.440860800@goodmis.org> <20090203024358.332574797@goodmis.org> <20090202195021.83bd0b80.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2 Feb 2009, Andrew Morton wrote:

> On Mon, 02 Feb 2009 21:38:32 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > @@ -510,8 +520,25 @@ int register_tracer(struct tracer *type)
> >   out:
> >  	tracing_selftest_running = false;
> >  	mutex_unlock(&trace_types_lock);
> > -	lock_kernel();
> >  
> > +	if (!ret && default_bootup_tracer) {
> > +		if (!strncmp(default_bootup_tracer, type->name,
> > +			     BOOTUP_TRACER_SIZE)) {
> > +			printk(KERN_INFO "Starting tracer '%s'\n",
> > +			       type->name);
> > +			/* Do we want this tracer to start on bootup? */
> > +			tracing_set_tracer(type->name);
> > +			default_bootup_tracer = NULL;
> > +			/* disable other selftests, since this will break it. */
> > +			tracing_selftest_disabled = 1;
> > +#ifdef CONFIG_FTRACE_STARTUP_TEST
> > +			printk(KERN_INFO "Disabling FTRACE selftests due"
> > +			       " to running tracer '%s'\n", type->name);
> > +#endif
> > +		}
> > +	}
> > +
> > +	lock_kernel();
> >  	return ret;
> >  }
> 
> The fun and games which register_tracer() plays with lock_kernel() tell
> us that this function is only called at bootup time and hence could be
> __init.  A quick whizz through callers confirms that.
> 
> And if register_tracer() is also only callable at bootup, one suspects
> that unregister_tracer() isn't useful.  And lo, it has no callers.
> 
> This leads one to further surmise that trace_types_lock a) could be
> __initdata and b) could be removed (the list is only altered when we're
> running single-threaded).  This appears to be the case.

The lock_kernel addition was added when the BKL became a spinlock again. 
The selftests needed to be able to sleep, and this caused issues.

The register_tracer was initial written to be pluggable at any time. 
Perhaps in the future to allow modules. But this does not seem to have 
panned out.

Since we have the lock_kernel there anyway, if we ever need to handle 
modules, that will need a different interface anyway. I guess I can nuke 
the unregister tracer.

As for the trace_types_lock mutex, that is still needed. Not only did it 
guard against the tracer registry, it also guards the switching of tracers.

 # echo function > /debug/tracing/current_tracer

-- Steve


