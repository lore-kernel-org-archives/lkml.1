Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbZGGVZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbZGGVZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 17:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbZGGVZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 17:25:30 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33701 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbZGGVZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 17:25:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NCM5oisbBi2ITMEB4BvW5vhBsmkYV1PLkXyANoZfo2kZl2e7X7IIilW717EkG1KEB7
         khKrkas4EiHFmSZX1xFbfsXWu+VRqQXG2feKTAhsbDY3iS7HJmvmY16vuAaWmcfWyWfT
         LCA+X4BekRHFZX0nSi0PK2j7XgGARV7K7JhfQ=
Date: Tue, 7 Jul 2009 23:25:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] ksym_tracer: Extract trace entry from struct
	trace_ksym
Message-ID: <20090707212520.GA7412@nowhere>
References: <4A52E291.1020408@cn.fujitsu.com> <4A52E2A4.4050007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A52E2A4.4050007@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 01:52:36PM +0800, Li Zefan wrote:
> struct trace_ksym is used as an entry in hbp list, and is also
> used as trace_entry stored in ring buffer.
> 
> This is not necessary and is a waste of memory in ring buffer.
> 
> There is also a bug that dereferencing field->ksym_hbp in
> ksym_trace_output() can be invalid.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace.h      |   13 ++++---------
>  kernel/trace/trace_ksym.c |   26 ++++++++++++++++++--------
>  2 files changed, 22 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 61b4e94..6868902 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -215,17 +215,12 @@ struct syscall_trace_exit {
>  #define KSYM_SELFTEST_ENTRY "ksym_selftest_dummy"
>  extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
>  
> -struct trace_ksym {
> +struct ksym_trace_entry {
>  	struct trace_entry	ent;
> -	struct hw_breakpoint	*ksym_hbp;
> -	unsigned long		ksym_addr;
>  	unsigned long		ip;
> -#ifdef CONFIG_PROFILE_KSYM_TRACER
> -	unsigned long		counter;
> -#endif
> -	struct hlist_node	ksym_hlist;
> +	unsigned char		type;
>  	char			ksym_name[KSYM_NAME_LEN];
> -	char			p_name[TASK_COMM_LEN];
> +	char			cmd[TASK_COMM_LEN];
>  };
>  
>  /*
> @@ -343,7 +338,7 @@ extern void __ftrace_bad_type(void);
>  			  TRACE_SYSCALL_ENTER);				\
>  		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
>  			  TRACE_SYSCALL_EXIT);				\
> -		IF_ASSIGN(var, ent, struct trace_ksym, TRACE_KSYM);	\
> +		IF_ASSIGN(var, ent, struct ksym_trace_entry, TRACE_KSYM);\
>  		__ftrace_bad_type();					\
>  	} while (0)
>  
> diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
> index eef97e7..085ff05 100644
> --- a/kernel/trace/trace_ksym.c
> +++ b/kernel/trace/trace_ksym.c
> @@ -37,6 +37,15 @@
>  #define KSYM_TRACER_OP_LEN 3 /* rw- */
>  #define KSYM_FILTER_ENTRY_LEN (KSYM_NAME_LEN + KSYM_TRACER_OP_LEN + 1)
>  
> +struct trace_ksym {
> +	struct hw_breakpoint	*ksym_hbp;
> +	unsigned long		ksym_addr;
> +#ifdef CONFIG_PROFILE_KSYM_TRACER
> +	unsigned long		counter;
> +#endif
> +	struct hlist_node	ksym_hlist;
> +};
> +
>  static struct trace_array *ksym_trace_array;
>  
>  static unsigned int ksym_filter_entry_count;
> @@ -71,7 +80,7 @@ void ksym_hbp_handler(struct hw_breakpoint *hbp, struct pt_regs *regs)
>  {
>  	struct ring_buffer_event *event;
>  	struct trace_array *tr;
> -	struct trace_ksym *entry;
> +	struct ksym_trace_entry *entry;
>  	int pc;
>  
>  	if (!ksym_tracing_enabled)
> @@ -85,11 +94,12 @@ void ksym_hbp_handler(struct hw_breakpoint *hbp, struct pt_regs *regs)
>  	if (!event)
>  		return;
>  
> -	entry = ring_buffer_event_data(event);
> +	entry		= ring_buffer_event_data(event);
> +	entry->ip	= instruction_pointer(regs);
> +	entry->type	= hbp->info.type;
>  	strlcpy(entry->ksym_name, hbp->info.name, KSYM_SYMBOL_LEN);
> -	entry->ksym_hbp = hbp;
> -	entry->ip = instruction_pointer(regs);
> -	strlcpy(entry->p_name, current->comm, TASK_COMM_LEN);
> +	strlcpy(entry->cmd, current->comm, TASK_COMM_LEN);


Ah, I did not realized that the cmdline was that roughly saved.
It would be more ring-buffer-friendly to use tracing_record_cmdline.



> +
>  #ifdef CONFIG_PROFILE_KSYM_TRACER
>  	ksym_collect_stats(hbp->info.address);
>  #endif /* CONFIG_PROFILE_KSYM_TRACER */
> @@ -380,7 +390,7 @@ static enum print_line_t ksym_trace_output(struct trace_iterator *iter)
>  {
>  	struct trace_entry *entry = iter->ent;
>  	struct trace_seq *s = &iter->seq;
> -	struct trace_ksym *field;
> +	struct ksym_trace_entry *field;
>  	char str[KSYM_SYMBOL_LEN];
>  	int ret;
>  
> @@ -389,12 +399,12 @@ static enum print_line_t ksym_trace_output(struct trace_iterator *iter)
>  
>  	trace_assign_type(field, entry);
>  
> -	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ", field->p_name,
> +	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ", field->cmd,
>  				entry->pid, iter->cpu, field->ksym_name);
>  	if (!ret)
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> -	switch (field->ksym_hbp->info.type) {
> +	switch (field->type) {
>  	case HW_BREAKPOINT_WRITE:
>  		ret = trace_seq_printf(s, " W  ");
>  		break;


Thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Prasad, any objection?

