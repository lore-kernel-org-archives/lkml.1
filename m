Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbZGYPhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbZGYPhk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 11:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZGYPhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 11:37:39 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:23652 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbZGYPhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 11:37:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f0pTAqciOtmYGnqc1Pj5BhodVQnW06QtzrLw2jVwXt3k8L6s2+RudPnWidJpcBey75
         thhgj4nwgGkeIIEwPkZ9V+yBqVIqmDcoZ40q/QNsPqx80sl8upVzkLfAn0A69JLBqlVX
         uhx+V/QKnc5x/FBdmUm3zkNcluwlxK3jva7zk=
Date: Sat, 25 Jul 2009 17:37:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/events: Add module tracepoints
Message-ID: <20090725153733.GB5295@nowhere>
References: <4A6582C1.2040609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6582C1.2040609@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 04:56:33PM +0800, Li Zefan wrote:
> Add trace points to trace module_load, module_free, module_get,
> module_put and module_request, and use trace_event facility
> to get the trace output.
> 
> Here's the sample output:
> 
>      TASK-PID    CPU#    TIMESTAMP  FUNCTION
>         | |       |          |         |
>     <...>-42    [000]     1.758380: module_request: fb0 wait=1 call_site=fb_open
>     ...
>     <...>-60    [000]     3.269403: module_load: scsi_wait_scan 
>     <...>-60    [000]     3.269432: module_put: scsi_wait_scan call_site=sys_init_module refcnt=0
>     <...>-61    [001]     3.273168: module_free: scsi_wait_scan
>     ...
>     <...>-1021  [000]    13.836081: module_load: sunrpc 
>     <...>-1021  [000]    13.840589: module_put: sunrpc call_site=sys_init_module refcnt=-1
>     <...>-1027  [000]    13.848098: module_get: sunrpc call_site=try_module_get refcnt=0
>     <...>-1027  [000]    13.848308: module_get: sunrpc call_site=get_filesystem refcnt=1
>     <...>-1027  [000]    13.848692: module_put: sunrpc call_site=put_filesystem refcnt=0
>     ...
>  modprobe-2587  [001]  1088.437213: module_load: trace_events_sample F
>  modprobe-2587  [001]  1088.437786: module_put: trace_events_sample call_site=sys_init_module refcnt=0
> 
> 
> Note:
> 
> - the taints flag can be 'F', 'C' and/or 'P' if mod->taints != 0
> 
> - the module refcnt is percpu, so it can be negative in a specific cpu
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


Nice.

Just two worries about it.

The ring buffer are flushed on module unloading right?
That won't make it easy to perform module event tracing.

Also the events selftests do a lot of random things to trigger
each kind of events, I guess some new others will be needed to
tests these, unless they will seem to fail on every selftests.
Although I can't imagine a module loading/unloading for
every ftrace event selftest... I guess these will require
a specific treatement and also will need to be selftested once
the filesystem is set to be able to load modules.

Thanks,
Frederic.


> ---
>  include/linux/module.h        |   14 ++++-
>  include/trace/events/module.h |  126 +++++++++++++++++++++++++++++++++++++++++
>  kernel/kmod.c                 |    4 +
>  kernel/module.c               |   11 ++++
>  4 files changed, 152 insertions(+), 3 deletions(-)
>  create mode 100644 include/trace/events/module.h
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 7a5c82c..86863cd 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -17,10 +17,12 @@
>  #include <linux/moduleparam.h>
>  #include <linux/marker.h>
>  #include <linux/tracepoint.h>
> -#include <asm/local.h>
>  
> +#include <asm/local.h>
>  #include <asm/module.h>
>  
> +#include <trace/events/module.h>
> +
>  /* Not Yet Implemented */
>  #define MODULE_SUPPORTED_DEVICE(name)
>  
> @@ -480,7 +482,10 @@ static inline local_t *__module_ref_addr(struct module *mod, int cpu)
>  static inline void __module_get(struct module *module)
>  {
>  	if (module) {
> -		local_inc(__module_ref_addr(module, get_cpu()));
> +		unsigned int cpu = get_cpu();
> +		local_inc(__module_ref_addr(module, cpu));
> +		trace_module_get(module, _THIS_IP_,
> +				 local_read(__module_ref_addr(module, cpu)));
>  		put_cpu();
>  	}
>  }
> @@ -491,8 +496,11 @@ static inline int try_module_get(struct module *module)
>  
>  	if (module) {
>  		unsigned int cpu = get_cpu();
> -		if (likely(module_is_live(module)))
> +		if (likely(module_is_live(module))) {
>  			local_inc(__module_ref_addr(module, cpu));
> +			trace_module_get(module, _THIS_IP_,
> +				local_read(__module_ref_addr(module, cpu)));
> +		}
>  		else
>  			ret = 0;
>  		put_cpu();
> diff --git a/include/trace/events/module.h b/include/trace/events/module.h
> new file mode 100644
> index 0000000..84160fb
> --- /dev/null
> +++ b/include/trace/events/module.h
> @@ -0,0 +1,126 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM module
> +
> +#if !defined(_TRACE_MODULE_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_MODULE_H
> +
> +#include <linux/tracepoint.h>
> +
> +#ifdef CONFIG_MODULES
> +
> +struct module;
> +
> +#define show_module_flags(flags) __print_flags(flags, "",	\
> +	{ (1UL << TAINT_PROPRIETARY_MODULE),	"P" },		\
> +	{ (1UL << TAINT_FORCED_MODULE),		"F" },		\
> +	{ (1UL << TAINT_CRAP),			"C" })
> +
> +TRACE_EVENT(module_load,
> +
> +	TP_PROTO(struct module *mod),
> +
> +	TP_ARGS(mod),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned int,	taints		)
> +		__string(	name,		mod->name	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->taints = mod->taints;
> +		__assign_str(name, mod->name);
> +	),
> +
> +	TP_printk("%s %s", __get_str(name), show_module_flags(__entry->taints))
> +);
> +
> +TRACE_EVENT(module_free,
> +
> +	TP_PROTO(struct module *mod),
> +
> +	TP_ARGS(mod),
> +
> +	TP_STRUCT__entry(
> +		__string(	name,		mod->name	)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(name, mod->name);
> +	),
> +
> +	TP_printk("%s", __get_str(name))
> +);
> +
> +TRACE_EVENT(module_get,
> +
> +	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
> +
> +	TP_ARGS(mod, ip, refcnt),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	ip		)
> +		__field(	int,		refcnt		)
> +		__string(	name,		mod->name	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->ip	= ip;
> +		__entry->refcnt	= refcnt;
> +		__assign_str(name, mod->name);
> +	),
> +
> +	TP_printk("%s call_site=%pf refcnt=%d",
> +		  __get_str(name), (void *)__entry->ip, __entry->refcnt)
> +);
> +
> +TRACE_EVENT(module_put,
> +
> +	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
> +
> +	TP_ARGS(mod, ip, refcnt),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	ip		)
> +		__field(	int,		refcnt		)
> +		__string(	name,		mod->name	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->ip	= ip;
> +		__entry->refcnt	= refcnt;
> +		__assign_str(name, mod->name);
> +	),
> +
> +	TP_printk("%s call_site=%pf refcnt=%d",
> +		  __get_str(name), (void *)__entry->ip, __entry->refcnt)
> +);
> +
> +TRACE_EVENT(module_request,
> +
> +	TP_PROTO(char *name, bool wait, unsigned long ip),
> +
> +	TP_ARGS(name, wait, ip),
> +
> +	TP_STRUCT__entry(
> +		__field(	bool,		wait		)
> +		__field(	unsigned long,	ip		)
> +		__string(	name,		name		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->wait	= wait;
> +		__entry->ip	= ip;
> +		__assign_str(name, name);
> +	),
> +
> +	TP_printk("%s wait=%d call_site=%pf",
> +		  __get_str(name), (int)__entry->wait, (void *)__entry->ip)
> +);
> +
> +#endif /* CONFIG_MODULES */
> +
> +#endif /* _TRACE_MODULE_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> +
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 385c31a..a922808 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -37,6 +37,8 @@
>  #include <linux/suspend.h>
>  #include <asm/uaccess.h>
>  
> +#include <trace/events/module.h>
> +
>  extern int max_threads;
>  
>  static struct workqueue_struct *khelper_wq;
> @@ -108,6 +110,8 @@ int __request_module(bool wait, const char *fmt, ...)
>  		return -ENOMEM;
>  	}
>  
> +	trace_module_request(module_name, wait, _RET_IP_);
> +
>  	ret = call_usermodehelper(modprobe_path, argv, envp,
>  			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
>  	atomic_dec(&kmod_concurrent);
> diff --git a/kernel/module.c b/kernel/module.c
> index 0a04983..38bf87a 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -55,6 +55,11 @@
>  #include <linux/percpu.h>
>  #include <linux/kmemleak.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/module.h>
> +
> +EXPORT_TRACEPOINT_SYMBOL(module_get);
> +
>  #if 0
>  #define DEBUGP printk
>  #else
> @@ -940,6 +945,8 @@ void module_put(struct module *module)
>  	if (module) {
>  		unsigned int cpu = get_cpu();
>  		local_dec(__module_ref_addr(module, cpu));
> +		trace_module_put(module, _RET_IP_,
> +				 local_read(__module_ref_addr(module, cpu)));
>  		/* Maybe they're waiting for us to drop reference? */
>  		if (unlikely(!module_is_live(module)))
>  			wake_up_process(module->waiter);
> @@ -1490,6 +1497,8 @@ static int __unlink_module(void *_mod)
>  /* Free a module, remove from lists, etc (must hold module_mutex). */
>  static void free_module(struct module *mod)
>  {
> +	trace_module_free(mod);
> +
>  	/* Delete from various lists */
>  	stop_machine(__unlink_module, mod, NULL);
>  	remove_notes_attrs(mod);
> @@ -2357,6 +2366,8 @@ static noinline struct module *load_module(void __user *umod,
>  	/* Get rid of temporary copy */
>  	vfree(hdr);
>  
> +	trace_module_load(mod);
> +
>  	/* Done! */
>  	return mod;
>  
> -- 
> 1.6.3
> 

