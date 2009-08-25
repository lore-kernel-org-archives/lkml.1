Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZHYGk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZHYGk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbZHYGk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:40:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbZHYGkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:40:55 -0400
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A9385AA.508@cn.fujitsu.com>
References: <4A9214E3.2070807@cn.fujitsu.com>
	 <1251093660.7538.119.camel@twins> <4A923197.4040708@cn.fujitsu.com>
	 <1251097012.7538.123.camel@twins>  <20090824092455.GA25267@elte.hu>
	 <1251106058.7538.149.camel@twins>  <4A937505.5000209@cn.fujitsu.com>
	 <1251181266.7538.1016.camel@twins>  <4A9385AA.508@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Aug 2009 08:40:05 +0200
Message-Id: <1251182405.7538.1050.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 14:33 +0800, Li Zefan wrote:
> >>>>>>>> If the correspoding module is unloaded before ftrace_profile_disable()
> >>>>>>>> is called, event->profile_disable() won't be called, which can
> >>>>>>>> cause oops:
> >>>>>>>>
> >>>>>>>>   # insmod trace-events-sample.ko
> >>>>>>>>   # perf record -f -a -e sample:foo_bar sleep 3 &
> >>>>>>>>   # sleep 1
> >>>>>>>>   # rmmod trace_events_sample
> >>>>>>>>   # insmod trace-events-sample.ko
> >>>>>>>>   OOPS!
> >>>>>>>>
> >>>>>>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> >>>>>>> Hrmm, feel fragile, why don't we check if all a modules tracepoints are
> >>>>>>> unused on unload?
> >>>>>>>
> >>>>>> I don't think it's fragile. We are profiling via a module's
> >>>>>> tracepoint, so we should pin the module, via module_get().
> >>>>>> If event->profile_enable() has been calld, we should make
> >>>>>> sure it's profile_disable() will be called.
> >>>>> What I call fragile is that everyone registering a tracepoint 
> >>>>> callback will now apparently need to worry about modules, _that_ 
> >>>>> is fragile.
> >>>>>
> >>>>> Either make module unload look at tracepoint users, or place the 
> >>>>> try_get_module() in the registration hooks so that regular users 
> >>>>> don't need to worry about it.
> >>>> The bug found by Li needs to be fixed obviously.
> >>>>
> >>>> I tend to agree with you that this does not appear to be the best 
> >>>> place to do it: so you suggest to implicitly increase the module 
> >>>> refcount on callback registr instead? (and releasing it when 
> >>>> unregistering)
> >>>>
> >>>> Same end result, slightly cleaner place to bump the refcount.
> >>> Yes, because the user of tracepoints should never need to care about
> >>> modules.
> >>>
> >> I'm afraid it is not feasible to bump module refcnt implicitly
> >> in tracepoint_probe_register().
> >>
> >> If a tracepoint is registered in module_init, and unregistered
> >> in module_exit (see sample/tracepoints), the module is unloadable:
> >>
> >>  insmod
> >>  ->call mod->init()
> >>    ->trace_reg_foo()
> >>      ->module_get()
> >>
> >>  rmmod
> >>  ->check mod refcnt
> >>  ->call mod->exit()
> >>    ->trace_unreg_foo()
> >>      ->module_put()
> > 
> > Not tracepoint_probe_{un,}register(), in {un,}register_trace_$call().
> > 
> 
> Is there any difference?
> 
> 	static inline int register_trace_##name(void (*probe)(proto))	\
> 	{								\
> 		int ret;						\
> 		void (*func)(void) = reg;				\
> 									\
> 		ret = tracepoint_probe_register(#name, (void *)probe);	\
> 		if (func && !ret)					\
> 			func();						\
> 		return ret;						\
> 	}

Ah, my bad, I was thikning tracepoint_probe_register() was the thing
that registered the tracepoint itself, not the callback.

Ok, then what's the problem?, don't do modules that consume their own
tracepoints, seems simple enough.

> > Basically avoid module unload when a tracepoint from that module has
> > registered callbacks.
> 
> TRACE_EVENT() won't prevent this. Instead at module unload, a module
> notifier callback will be called to unregistread those tracepoint callbacks.

Ugh, that's disgusting. That means every single tracepoint user again
needs to be aware of modules.
