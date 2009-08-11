Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbZHKMiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbZHKMiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZHKMix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:38:53 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:34008 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbZHKMiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B41MGkLWPE9jdL13CIyxM5JQfY2NkO9+oMTyZ7H9ROxhyYSrvho1OV5jUx9fxPjSWe
         nThW1xO7tMVTyERCtjnfbsgc1zomHrIcW2zpu/ArATnuE5UYDDUn5/UrvLZu+Q32TAJ0
         XZ71+jAEMOZzmCFZl4yqYErZqTIm41PJnEkTc=
Date: Tue, 11 Aug 2009 13:28:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH 09/12] add support traceopint ids
Message-ID: <20090811112845.GD4938@nowhere>
References: <cover.1249932670.git.jbaron@redhat.com> <996d6713d889ddf697d3d4fdbb08645fa8343dd5.1249932670.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <996d6713d889ddf697d3d4fdbb08645fa8343dd5.1249932670.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 04:52:53PM -0400, Jason Baron wrote:
> This patch associates an id with each syscall trace event, so that we can
> identify each syscall trace event using the 'perf' tool.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
>  arch/x86/kernel/ftrace.c      |   10 ++++++++++
>  include/linux/syscalls.h      |   22 ++++++++++++++++++----
>  include/trace/syscall.h       |    8 ++++++++
>  kernel/trace/trace.h          |    6 ------
>  kernel/trace/trace_syscalls.c |   26 ++++++++++++++++----------
>  5 files changed, 52 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 0d93d40..3cff121 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -516,6 +516,16 @@ int syscall_name_to_nr(char *name)
>  	return -1;
>  }
>  
> +void set_syscall_enter_id(int num, int id)
> +{
> +	syscalls_metadata[num]->enter_id = id;
> +}
> +
> +void set_syscall_exit_id(int num, int id)
> +{
> +	syscalls_metadata[num]->exit_id = id;
> +}
> +
>  static int __init arch_init_ftrace_syscalls(void)
>  {
>  	int i;
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 5e5b4d3..ce4b01c 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -116,13 +116,20 @@ struct perf_counter_attr;
>  
>  #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
>  	static struct ftrace_event_call event_enter_##sname;		\
> +	struct trace_event enter_syscall_print_##sname = {		\
> +		.trace                  = print_syscall_enter,		\
> +	};								\
>  	static int init_enter_##sname(void)				\
>  	{								\
> -		int num;						\
> +		int num, id;						\
>  		num = syscall_name_to_nr("sys"#sname);			\
>  		if (num < 0)						\
>  			return -ENOSYS;					\
> -		register_ftrace_event(&event_syscall_enter);		\
> +		id = register_ftrace_event(&enter_syscall_print_##sname);\



Since kprobes also need a unique id despite a single print callback,
Because this issue is then not isolated, we need a generic event number
generator from ftrace.

IIRC Masami's kprobe patchset brought this. In this case,
we need to remember fixing this on the syscall tracing side once it's merged.




> +		if (!id)						\
> +			return -ENODEV;					\
> +		event_enter_##sname.id = id;				\
> +		set_syscall_enter_id(num, id);				\
>  		INIT_LIST_HEAD(&event_enter_##sname.fields);		\
>  		init_preds(&event_enter_##sname);			\
>  		return 0;						\
> @@ -142,13 +149,20 @@ struct perf_counter_attr;
>  
>  #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
>  	static struct ftrace_event_call event_exit_##sname;		\
> +	struct trace_event exit_syscall_print_##sname = {		\
> +		.trace                  = print_syscall_exit,		\
> +	};								\
>  	static int init_exit_##sname(void)				\
>  	{								\
> -		int num;						\
> +		int num, id;						\
>  		num = syscall_name_to_nr("sys"#sname);			\
>  		if (num < 0)						\
>  			return -ENOSYS;					\
> -		register_ftrace_event(&event_syscall_exit);		\
> +		id = register_ftrace_event(&exit_syscall_print_##sname);\
> +		if (!id)						\
> +			return -ENODEV;					\
> +		event_exit_##sname.id = id;				\
> +		set_syscall_exit_id(num, id);				\
>  		INIT_LIST_HEAD(&event_exit_##sname.fields);		\
>  		init_preds(&event_exit_##sname);			\
>  		return 0;						\
> diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> index 73fb8b4..df62840 100644
> --- a/include/trace/syscall.h
> +++ b/include/trace/syscall.h
> @@ -32,23 +32,31 @@ DECLARE_TRACE_WITH_CALLBACK(syscall_exit,
>   * @nb_args: number of parameters it takes
>   * @types: list of types as strings
>   * @args: list of args as strings (args[i] matches types[i])
> + * @enter_id: associated ftrace enter event id
> + * @exit_id: associated ftrace exit event id
>   */
>  struct syscall_metadata {
>  	const char	*name;
>  	int		nb_args;
>  	const char	**types;
>  	const char	**args;
> +	int		enter_id;
> +	int		exit_id;
>  };
>  
>  #ifdef CONFIG_FTRACE_SYSCALLS
>  extern struct syscall_metadata *syscall_nr_to_meta(int nr);
>  extern int syscall_name_to_nr(char *name);
> +void set_syscall_enter_id(int num, int id);
> +void set_syscall_exit_id(int num, int id);
>  extern struct trace_event event_syscall_enter;
>  extern struct trace_event event_syscall_exit;
>  extern int reg_event_syscall_enter(void *ptr);
>  extern void unreg_event_syscall_enter(void *ptr);
>  extern int reg_event_syscall_exit(void *ptr);
>  extern void unreg_event_syscall_exit(void *ptr);
> +enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags);
> +enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags);
>  #endif
>  
>  #endif /* _TRACE_SYSCALL_H */
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 44308f3..606073c 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -38,8 +38,6 @@ enum trace_type {
>  	TRACE_GRAPH_ENT,
>  	TRACE_USER_STACK,
>  	TRACE_HW_BRANCHES,
> -	TRACE_SYSCALL_ENTER,
> -	TRACE_SYSCALL_EXIT,
>  	TRACE_KMEM_ALLOC,
>  	TRACE_KMEM_FREE,
>  	TRACE_POWER,
> @@ -334,10 +332,6 @@ extern void __ftrace_bad_type(void);
>  			  TRACE_KMEM_ALLOC);	\
>  		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
>  			  TRACE_KMEM_FREE);	\
> -		IF_ASSIGN(var, ent, struct syscall_trace_enter,		\
> -			  TRACE_SYSCALL_ENTER);				\
> -		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
> -			  TRACE_SYSCALL_EXIT);				\
>  		IF_ASSIGN(var, ent, struct ksym_trace_entry, TRACE_KSYM);\
>  		__ftrace_bad_type();					\
>  	} while (0)
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index c7ae25e..e58a9c1 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -36,14 +36,18 @@ print_syscall_enter(struct trace_iterator *iter, int flags)
>  	struct syscall_metadata *entry;
>  	int i, ret, syscall;
>  
> -	trace_assign_type(trace, ent);
> -
> +	trace = (typeof(trace))ent;
>  	syscall = trace->nr;
> -
>  	entry = syscall_nr_to_meta(syscall);
> +
>  	if (!entry)
>  		goto end;
>  
> +	if (entry->enter_id != ent->type) {
> +		WARN_ON_ONCE(1);
> +		goto end;
> +	}
> +
>  	ret = trace_seq_printf(s, "%s(", entry->name);
>  	if (!ret)
>  		return TRACE_TYPE_PARTIAL_LINE;
> @@ -78,16 +82,20 @@ print_syscall_exit(struct trace_iterator *iter, int flags)
>  	struct syscall_metadata *entry;
>  	int ret;
>  
> -	trace_assign_type(trace, ent);
> -
> +	trace = (typeof(trace))ent;
>  	syscall = trace->nr;
> -
>  	entry = syscall_nr_to_meta(syscall);
> +
>  	if (!entry) {
>  		trace_seq_printf(s, "\n");
>  		return TRACE_TYPE_HANDLED;
>  	}
>  
> +	if (entry->exit_id != ent->type) {
> +		WARN_ON_ONCE(1);
> +		return TRACE_TYPE_UNHANDLED;
> +	}
> +
>  	ret = trace_seq_printf(s, "%s -> 0x%lx\n", entry->name,
>  				trace->ret);
>  	if (!ret)
> @@ -114,7 +122,7 @@ void ftrace_syscall_enter(struct pt_regs *regs, long id)
>  
>  	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
>  
> -	event = trace_current_buffer_lock_reserve(TRACE_SYSCALL_ENTER, size,
> +	event = trace_current_buffer_lock_reserve(sys_data->enter_id, size,
>  							0, 0);
>  	if (!event)
>  		return;
> @@ -142,7 +150,7 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
>  	if (!sys_data)
>  		return;
>  
> -	event = trace_current_buffer_lock_reserve(TRACE_SYSCALL_EXIT,
> +	event = trace_current_buffer_lock_reserve(sys_data->exit_id,
>  				sizeof(*entry), 0, 0);
>  	if (!event)
>  		return;
> @@ -239,10 +247,8 @@ void unreg_event_syscall_exit(void *ptr)
>  
>  struct trace_event event_syscall_enter = {
>  	.trace			= print_syscall_enter,
> -	.type			= TRACE_SYSCALL_ENTER
>  };
>  
>  struct trace_event event_syscall_exit = {
>  	.trace			= print_syscall_exit,
> -	.type			= TRACE_SYSCALL_EXIT
>  };


Do you still need the two above now that you have defined individual
print callbacks from syscall.h ?

> -- 
> 1.6.2.5
> 

