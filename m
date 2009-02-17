Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZBQSqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZBQSqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 13:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZBQSp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 13:45:58 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44859 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbZBQSp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:45:57 -0500
Date: Tue, 17 Feb 2009 10:45:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 10/15] ftrace: trace different functions with a
	different tracer
Message-ID: <20090217184554.GH6761@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090217051227.957864159@goodmis.org> <20090217051407.035764950@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217051407.035764950@goodmis.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 12:12:37AM -0500, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: new feature
> 
> Currently, the function tracer only gives you an ability to hook
> a tracer to all functions being traced. The dynamic function trace
> allows you to pick and choose which of those functions will be
> traced, but all functions being traced will call all tracers that
> registered with the function tracer.
> 
> This patch adds a new feature that allows a tracer to hook to specific
> functions, even when all functions are being traced. It allows for
> different functions to call different tracer hooks.
> 
> The way this is accomplished is by a special function that will hook
> to the function tracer and will set up a hash table knowing which
> tracer hook to call with which function. This is the most general
> and easiest method to accomplish this. Later, an arch may choose
> to supply their own method in changing the mcount call of a function
> to call a different tracer. But that will be an exercise for the
> future.
> 
> To register a function:
> 
>  struct ftrace_hook_ops {
> 	void			(*func)(unsigned long ip,
> 					unsigned long parent_ip,
> 					void **data);
> 	int			(*callback)(unsigned long ip, void **data);
> 	void			(*free)(void **data);
>  };
> 
>  int register_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
> 				  void *data);
> 
> glob is a simple glob to search for the functions to hook.
> ops is a pointer to the operations (listed below)
> data is the default data to be passed to the hook functions when traced
> 
> ops:
>  func is the hook function to call when the functions are traced
>  callback is a callback function that is called when setting up the hash.
>    That is, if the tracer needs to do something special for each
>    function, that is being traced, and wants to give each function
>    its own data. The address of the entry data is passed to this
>    callback, so that the callback may wish to update the entry to
>    whatever it would like.
>  free is a callback for when the entry is freed. In case the tracer
>    allocated any data, it is give the chance to free it.
> 
> To unregister we have three functions:
> 
>   void
>   unregister_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
> 				void *data)
> 
> This will unregister all hooks that match glob, point to ops, and
> have its data matching data. (note, if glob is NULL, blank or '*',
> all functions will be tested).
> 
>   void
>   unregister_ftrace_function_hook_func(char *glob,
> 				 struct ftrace_hook_ops *ops)
> 
> This will unregister all functions matching glob that has an entry
> pointing to ops.
> 
>   void unregister_ftrace_function_hook_all(char *glob)
> 
> This simply unregisters all funcs.

Looks like a nice addition!

One RCU type mismatch called out below.

> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  include/linux/ftrace.h |   18 ++++
>  kernel/trace/ftrace.c  |  247 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 265 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index f0a0ecc..13918c4 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -106,6 +106,24 @@ struct ftrace_func_command {
>  /* asm/ftrace.h must be defined for archs supporting dynamic ftrace */
>  #include <asm/ftrace.h>

[ . . . ]

> +
> +static void
> +__unregister_ftrace_function_hook(char *glob, struct ftrace_hook_ops *ops,
> +				  void *data, int flags)
> +{
> +	struct ftrace_func_hook *entry;
> +	struct hlist_node *n, *tmp;
> +	char str[KSYM_SYMBOL_LEN];
> +	int type = MATCH_FULL;
> +	int i, len = 0;
> +	char *search;
> +
> +	if (glob && (strcmp(glob, "*") || !strlen(glob)))
> +		glob = NULL;
> +	else {
> +		int not;
> +
> +		type = ftrace_setup_glob(glob, strlen(glob), &search, &not);
> +		len = strlen(search);
> +
> +		/* we do not support '!' for function hooks */
> +		if (WARN_ON(not))
> +			return;
> +	}
> +
> +	mutex_lock(&ftrace_lock);
> +	for (i = 0; i < FTRACE_FUNC_HASHSIZE; i++) {
> +		struct hlist_head *hhd = &ftrace_func_hash[i];
> +
> +		hlist_for_each_entry_safe(entry, n, tmp, hhd, node) {
> +
> +			/* break up if statements for readability */
> +			if ((flags & HOOK_TEST_FUNC) && entry->ops != ops)
> +				continue;
> +
> +			if ((flags & HOOK_TEST_DATA) && entry->data != data)
> +				continue;
> +
> +			/* do this last, since it is the most expensive */
> +			if (glob) {
> +				kallsyms_lookup(entry->ip, NULL, NULL,
> +						NULL, str);
> +				if (!ftrace_match(str, glob, len, type))
> +					continue;
> +			}
> +
> +			hlist_del(&entry->node);
> +			call_rcu(&entry->rcu, ftrace_free_entry_rcu);

This should be call_rcu_sched() to match the preemption disabling.

> +		}
> +	}
> +	__disable_ftrace_function_hook();
> +	mutex_unlock(&ftrace_lock);
> +}
