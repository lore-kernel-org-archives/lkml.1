Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbZHZQq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbZHZQq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZHZQq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:46:26 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:47643 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750935AbZHZQq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:46:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EAKAAlUpMROOX/2dsb2JhbACBU9dShBoF
Date: Wed, 26 Aug 2009 12:46:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
Message-ID: <20090826164624.GA21456@Krystal>
References: <20090825102215.GC26801@elte.hu> <1251196359.7538.1133.camel@twins> <20090825103907.GB28287@elte.hu> <1251197235.7538.1142.camel@twins> <1251211963.7538.1164.camel@twins> <4A94D3A8.1090902@cn.fujitsu.com> <1251269207.7538.1217.camel@twins> <1251270092.7538.1226.camel@twins> <4A94DFF4.5030301@cn.fujitsu.com> <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:41:17 up 8 days,  3:30,  2 users,  load average: 0.30, 0.48,
	0.38
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Wed, 26 Aug 2009, Li Zefan wrote:
> 
> > Peter Zijlstra wrote:
> > > On Wed, 2009-08-26 at 08:46 +0200, Peter Zijlstra wrote:
> > > 
> > >> Aahh, I see the bug, its only ftrace that knows about the module, not
> > >> tracepoints themselves, _that_ needs fixing.
> > > 
> > > You could possibly do something like:
> > > 
> > >  struct module *tp_mod = __module_address(&some_tp_symbol);
> > >  struct module *cb_mod = __module_text_address(func);
> > > 
> > >  if (tp_mod && tp_mod != cb_mod) {
> > > 	ret = try_get_module(tp_mod);
> > > 	if (ret)
> > > 		goto fail;
> > >  }
> > > 
> > > in register_trace_##name() or thereabout.
> > > 
> > 
> > Actually I tried it, but it didn't work. As I said, You can't find
> > any tp symbol when registering tp callback. The same example again:
> > 
> > 	In module bar, we have register_trace_foo()
> > 	In module foo, we have DEFINE_TRACE(foo) and trace_foo().
> > 
> > bar doesn't know any symbol of foo, so it can't bump foo's refcnt,
> > 
> > *Note: you can load module bar without loading module foo*
> 
> WTF!!!!
> 
> We can register a trace point that is defined in another module without 
> having that module?? How is that possible? That looks totally busted, and 
> that is not a case that I think we need to worry about, except to prevent 
> it from ever happening.
> 

Registering tracepoints even when no tracepoint definition is currently
visible is the intended allowed behavior. Let's say we need to trace
something happening in module init: if we disallow registering the tp
callback before the module is initialized, we run in a chicken and egg
problem.

So I am trying to figure out the problem source there. Is it that
modules containing the tp callbacks need to know if those are actually
connected to an instrumented module ? Or is it that the instrumented
module needs to know if a probe module is connected to is ? Or is it the
teardown of the probe module ? No refcount is needed there, because we
surround the probe call by preempt disable/enable, and we use
synchronize_sched() before removing the module which contains probe
callbacks.

Mathieu-trying-to-figure-out-what-this-whole-thread-is-about :)


> As for ref counts, would something like this work?
> 
>  (untested)
> 
> -- Steve
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 0341f2e..055275b 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -109,8 +109,9 @@ struct tracepoint {
>  #define EXPORT_TRACEPOINT_SYMBOL(name)					\
>  	EXPORT_SYMBOL(__tracepoint_##name)
>  
> -extern void tracepoint_update_probe_range(struct tracepoint *begin,
> -	struct tracepoint *end);
> +extern void tracepoint_update_probe_range(struct module *,
> +					  struct tracepoint *begin,
> +					  struct tracepoint *end);
>  
>  #else /* !CONFIG_TRACEPOINTS */
>  #define DECLARE_TRACE_WITH_CALLBACK(name, proto, args, reg, unreg)	\
> diff --git a/kernel/module.c b/kernel/module.c
> index b182143..a8e69fa 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2974,7 +2974,7 @@ void module_update_tracepoints(void)
>  	mutex_lock(&module_mutex);
>  	list_for_each_entry(mod, &modules, list)
>  		if (!mod->taints)
> -			tracepoint_update_probe_range(mod->tracepoints,
> +			tracepoint_update_probe_range(mod, mod->tracepoints,
>  				mod->tracepoints + mod->num_tracepoints);
>  	mutex_unlock(&module_mutex);
>  }
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 06f165a..b150255 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -274,7 +274,8 @@ static void disable_tracepoint(struct tracepoint *elem)
>   * Updates the probe callback corresponding to a range of tracepoints.
>   */
>  void
> -tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
> +tracepoint_update_probe_range(struct module *mod,
> +			      struct tracepoint *begin, struct tracepoint *end)
>  {
>  	struct tracepoint *iter;
>  	struct tracepoint_entry *mark_entry;
> @@ -286,9 +287,15 @@ tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
>  	for (iter = begin; iter < end; iter++) {
>  		mark_entry = get_tracepoint(iter->name);
>  		if (mark_entry) {
> +			if (mod) {
> +				if (!try_module_get(mod))
> +					continue;
> +			}
>  			set_tracepoint(&mark_entry, iter,
>  					!!mark_entry->refcount);
>  		} else {
> +			if (mod)
> +				module_put(mod);
>  			disable_tracepoint(iter);
>  		}
>  	}
> @@ -301,7 +308,7 @@ tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
>  static void tracepoint_update_probes(void)
>  {
>  	/* Core kernel tracepoints */
> -	tracepoint_update_probe_range(__start___tracepoints,
> +	tracepoint_update_probe_range(NULL, __start___tracepoints,
>  		__stop___tracepoints);
>  	/* tracepoints in modules. */
>  	module_update_tracepoints();
> @@ -556,7 +563,7 @@ int tracepoint_module_notify(struct notifier_block *self,
>  	switch (val) {
>  	case MODULE_STATE_COMING:
>  	case MODULE_STATE_GOING:
> -		tracepoint_update_probe_range(mod->tracepoints,
> +		tracepoint_update_probe_range(mod, mod->tracepoints,
>  			mod->tracepoints + mod->num_tracepoints);
>  		break;
>  	}

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
