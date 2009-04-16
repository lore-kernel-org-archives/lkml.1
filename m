Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbZDPPgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbZDPPgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbZDPPg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:36:26 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:44669 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbZDPPgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:36:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DRL3eGj3esKUAE3R/qg3jFZJkqMu7qaywbcG4SgXoOo78Y9s6+Drw73eAsP73/HAs/
         OhjIV5E2tPmc9vFxPgELWdLBZwOdFnVdbHuG3y61Tys4U3bPnPDvCfBoz6GbiKviBHaB
         TifABSNgfxe8VfFSj9fw2z7jzc1iN0LlsEWRo=
Date: Thu, 16 Apr 2009 17:36:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/5] ftrace: use module notifier for function tracer
Message-ID: <20090416153618.GB6004@nowhere>
References: <20090416021830.556671772@goodmis.org> <20090416021928.040177084@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416021928.040177084@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 10:18:31PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: fix and clean up
> 
> The hooks in the module code for the function tracer must be called
> before any of that module code runs. The function tracer hooks
> modify the module (replacing calls to mcount to nops). If the code
> is executed while the change occurs, then the CPU can take a GPF.
> 
> To handle the above with a bit of paranoia, I originally implemented
> the hooks as calls directly from the module code.
> 
> After examining the notifier calls, it looks as though the start up
> notify is called before any of the module's code is executed. This makes
> the use of the notify safe with ftrace.
> 
> Only the startup notify is required to be "safe". The shutdown simply
> removes the entries from the ftrace function list, and does not modify
> any code.
> 
> This change has another benefit. It removes a issue with a reverse dependency
> in the mutexes of ftrace_lock and module_mutex.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/ftrace.h |    7 ----
>  include/linux/module.h |    4 ++
>  kernel/module.c        |   19 ++++------
>  kernel/trace/ftrace.c  |   90 ++++++++++++++++++++++++++++++++++--------------
>  4 files changed, 75 insertions(+), 45 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 53869be..97c83e1 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -233,8 +233,6 @@ extern int ftrace_arch_read_dyn_info(char *buf, int size);
>  
>  extern int skip_trace(unsigned long ip);
>  
> -extern void ftrace_release(void *start, unsigned long size);
> -
>  extern void ftrace_disable_daemon(void);
>  extern void ftrace_enable_daemon(void);
>  #else
> @@ -325,13 +323,8 @@ static inline void __ftrace_enabled_restore(int enabled)
>  
>  #ifdef CONFIG_FTRACE_MCOUNT_RECORD
>  extern void ftrace_init(void);
> -extern void ftrace_init_module(struct module *mod,
> -			       unsigned long *start, unsigned long *end);
>  #else
>  static inline void ftrace_init(void) { }
> -static inline void
> -ftrace_init_module(struct module *mod,
> -		   unsigned long *start, unsigned long *end) { }
>  #endif
>  
>  /*
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 6155fa4..a8f2c0a 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -341,6 +341,10 @@ struct module
>  	struct ftrace_event_call *trace_events;
>  	unsigned int num_trace_events;
>  #endif
> +#ifdef CONFIG_FTRACE_MCOUNT_RECORD
> +	unsigned long *ftrace_callsites;
> +	unsigned int num_ftrace_callsites;
> +#endif
>  
>  #ifdef CONFIG_MODULE_UNLOAD
>  	/* What modules depend on me? */
> diff --git a/kernel/module.c b/kernel/module.c
> index a039470..2383e60 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1490,9 +1490,6 @@ static void free_module(struct module *mod)
>  	/* Free any allocated parameters. */
>  	destroy_params(mod->kp, mod->num_kp);
>  
> -	/* release any pointers to mcount in this module */
> -	ftrace_release(mod->module_core, mod->core_size);
> -
>  	/* This may be NULL, but that's OK */
>  	module_free(mod, mod->module_init);
>  	kfree(mod->args);
> @@ -1893,11 +1890,9 @@ static noinline struct module *load_module(void __user *umod,
>  	unsigned int symindex = 0;
>  	unsigned int strindex = 0;
>  	unsigned int modindex, versindex, infoindex, pcpuindex;
> -	unsigned int num_mcount;
>  	struct module *mod;
>  	long err = 0;
>  	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
> -	unsigned long *mseg;
>  	mm_segment_t old_fs;
>  
>  	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
> @@ -2179,7 +2174,13 @@ static noinline struct module *load_module(void __user *umod,
>  					 sizeof(*mod->trace_events),
>  					 &mod->num_trace_events);
>  #endif
> -
> +#ifdef CONFIG_FTRACE_MCOUNT_RECORD
> +	/* sechdrs[0].sh_size is always zero */
> +	mod->ftrace_callsites = section_objs(hdr, sechdrs, secstrings,
> +					     "__mcount_loc",
> +					     sizeof(*mod->ftrace_callsites),
> +					     &mod->num_ftrace_callsites);
> +#endif
>  #ifdef CONFIG_MODVERSIONS
>  	if ((mod->num_syms && !mod->crcs)
>  	    || (mod->num_gpl_syms && !mod->gpl_crcs)
> @@ -2244,11 +2245,6 @@ static noinline struct module *load_module(void __user *umod,
>  			dynamic_debug_setup(debug, num_debug);
>  	}
>  
> -	/* sechdrs[0].sh_size is always zero */
> -	mseg = section_objs(hdr, sechdrs, secstrings, "__mcount_loc",
> -			    sizeof(*mseg), &num_mcount);
> -	ftrace_init_module(mod, mseg, mseg + num_mcount);
> -
>  	err = module_finalize(hdr, sechdrs, mod);
>  	if (err < 0)
>  		goto cleanup;
> @@ -2309,7 +2305,6 @@ static noinline struct module *load_module(void __user *umod,
>   cleanup:
>  	kobject_del(&mod->mkobj.kobj);
>  	kobject_put(&mod->mkobj.kobj);
> -	ftrace_release(mod->module_core, mod->core_size);
>   free_unload:
>  	module_unload_free(mod);
>  #if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index a234889..5b606f4 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -916,30 +916,6 @@ static void ftrace_free_rec(struct dyn_ftrace *rec)
>  	rec->flags |= FTRACE_FL_FREE;
>  }
>  
> -void ftrace_release(void *start, unsigned long size)
> -{
> -	struct dyn_ftrace *rec;
> -	struct ftrace_page *pg;
> -	unsigned long s = (unsigned long)start;
> -	unsigned long e = s + size;
> -
> -	if (ftrace_disabled || !start)
> -		return;
> -
> -	mutex_lock(&ftrace_lock);
> -	do_for_each_ftrace_rec(pg, rec) {
> -		if ((rec->ip >= s) && (rec->ip < e)) {
> -			/*
> -			 * rec->ip is changed in ftrace_free_rec()
> -			 * It should not between s and e if record was freed.
> -			 */
> -			FTRACE_WARN_ON(rec->flags & FTRACE_FL_FREE);
> -			ftrace_free_rec(rec);
> -		}
> -	} while_for_each_ftrace_rec();
> -	mutex_unlock(&ftrace_lock);
> -}
> -
>  static struct dyn_ftrace *ftrace_alloc_dyn_node(unsigned long ip)
>  {
>  	struct dyn_ftrace *rec;
> @@ -2752,14 +2728,72 @@ static int ftrace_convert_nops(struct module *mod,
>  	return 0;
>  }
>  
> -void ftrace_init_module(struct module *mod,
> -			unsigned long *start, unsigned long *end)
> +#ifdef CONFIG_MODULES
> +void ftrace_release(void *start, void *end)
> +{
> +	struct dyn_ftrace *rec;
> +	struct ftrace_page *pg;
> +	unsigned long s = (unsigned long)start;
> +	unsigned long e = (unsigned long)end;
> +
> +	if (ftrace_disabled || !start || start == end)
> +		return;
> +
> +	mutex_lock(&ftrace_lock);
> +	do_for_each_ftrace_rec(pg, rec) {
> +		if ((rec->ip >= s) && (rec->ip < e)) {
> +			/*
> +			 * rec->ip is changed in ftrace_free_rec()
> +			 * It should not between s and e if record was freed.
> +			 */
> +			FTRACE_WARN_ON(rec->flags & FTRACE_FL_FREE);
> +			ftrace_free_rec(rec);
> +		}
> +	} while_for_each_ftrace_rec();
> +	mutex_unlock(&ftrace_lock);
> +}
> +
> +static void ftrace_init_module(struct module *mod,
> +			       unsigned long *start, unsigned long *end)
>  {
>  	if (ftrace_disabled || start == end)
>  		return;
>  	ftrace_convert_nops(mod, start, end);
>  }
>  
> +static int ftrace_module_notify(struct notifier_block *self,
> +				unsigned long val, void *data)
> +{
> +	struct module *mod = data;
> +
> +	switch (val) {
> +	case MODULE_STATE_COMING:
> +		ftrace_init_module(mod, mod->ftrace_callsites,
> +				   mod->ftrace_callsites +
> +				   mod->num_ftrace_callsites);
> +		break;
> +	case MODULE_STATE_GOING:
> +		ftrace_release(mod->ftrace_callsites,
> +			       mod->ftrace_callsites +
> +			       mod->num_ftrace_callsites);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +#else
> +static int ftrace_module_notify(struct notifier_block *self,
> +				unsigned long val, void *data)
> +{
> +	return 0;
> +}



You don't seem to like my __init idea :)



> +#endif /* CONFIG_MODULES */
> +
> +struct notifier_block ftrace_module_nb = {
> +	.notifier_call = ftrace_module_notify,
> +	.priority = 0,
> +};
> +



Neither the __initdata_or_module.


Frederic.

>  extern unsigned long __start_mcount_loc[];
>  extern unsigned long __stop_mcount_loc[];
>  
> @@ -2791,6 +2825,10 @@ void __init ftrace_init(void)
>  				  __start_mcount_loc,
>  				  __stop_mcount_loc);
>  
> +	ret = register_module_notifier(&ftrace_module_nb);
> +	if (!ret)
> +		pr_warning("Failed to register trace ftrace module notifier\n");
> +
>  	return;
>   failed:
>  	ftrace_disabled = 1;
> -- 
> 1.6.2.1
> 
> -- 

