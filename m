Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbZFSXD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbZFSXD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 19:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZFSXDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 19:03:52 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:36885 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbZFSXDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 19:03:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K7LLCheX4o/MYnkTR79dbP4gZGZEQTbx8ztjBYk93ByXDw0sGnW/R+JstllZdIb4GW
         RW7Cux06yXf7VAxM1QjzuVXG7IZsUbtwVHPdukZb5W3lDse1bxDWhs4xtpyDppJnJjlj
         B0f78xSV8nxn73qqig6+i7T/nGVeGgOxpUlqo=
Date: Sat, 20 Jun 2009 01:03:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/3] ksym_tracer: Eliminate trace concatenation and
	machine stall issues post removal
Message-ID: <20090619230348.GA4700@nowhere>
References: <20090619172035.443923337@prasadkr_t60p.in.ibm.com> <20090619172453.GB26071@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619172453.GB26071@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 10:54:53PM +0530, K.Prasad wrote:
> This patch fixes two issues reported with ksym tracer, seen after
> removal of a symbol from the tracer i) Concatenation of trace logs
> into a single line ii) Machine stall seen when logs are viewed
> using 'trace_pipe'.
> 
> Known issue: Upon removal, 'cat trace_pipe' (without any preceding
> command and any further output in the trace buffer) responds to
> SIGTERM quickly but only after an indeterminate amount of delay
> for SIGINT.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  kernel/trace/trace.h      |   12 +++++++++---
>  kernel/trace/trace_ksym.c |   11 ++++-------
>  2 files changed, 13 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_ksym.c
> +++ linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> @@ -71,7 +71,7 @@ void ksym_hbp_handler(struct hw_breakpoi
>  {
>  	struct ring_buffer_event *event;
>  	struct trace_array *tr;
> -	struct trace_ksym *entry;
> +	struct trace_ksym_rb *entry;
>  	int pc;
>  
>  	if (!ksym_tracing_enabled)
> @@ -87,7 +87,7 @@ void ksym_hbp_handler(struct hw_breakpoi
>  
>  	entry = ring_buffer_event_data(event);
>  	strlcpy(entry->ksym_name, hbp->info.name, KSYM_SYMBOL_LEN);
> -	entry->ksym_hbp = hbp;
> +	memcpy(&(entry->ksym_hbp), hbp, sizeof(struct hw_breakpoint));


That looks wasteful. You only need the type from the arch_hw_breakpoint
and there you copy the whole generic breakpoint.

Frederic.



>  	entry->ip = instruction_pointer(regs);
>  	strlcpy(entry->p_name, current->comm, TASK_COMM_LEN);
>  #ifdef CONFIG_PROFILE_KSYM_TRACER
> @@ -380,7 +380,7 @@ static enum print_line_t ksym_trace_outp
>  {
>  	struct trace_entry *entry = iter->ent;
>  	struct trace_seq *s = &iter->seq;
> -	struct trace_ksym *field;
> +	struct trace_ksym_rb *field;
>  	char str[KSYM_SYMBOL_LEN];
>  	int ret;
>  
> @@ -394,17 +394,14 @@ static enum print_line_t ksym_trace_outp
>  	if (!ret)
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> -	switch (field->ksym_hbp->info.type) {
> +	switch (field->ksym_hbp.info.type) {
>  	case HW_BREAKPOINT_WRITE:
>  		ret = trace_seq_printf(s, " W  ");
>  		break;
>  	case HW_BREAKPOINT_RW:
>  		ret = trace_seq_printf(s, " RW ");
>  		break;
> -	default:
> -		return TRACE_TYPE_PARTIAL_LINE;
>  	}
> -
>  	if (!ret)
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> Index: linux-2.6-tip.hbkpt/kernel/trace/trace.h
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/kernel/trace/trace.h
> +++ linux-2.6-tip.hbkpt/kernel/trace/trace.h
> @@ -216,15 +216,21 @@ struct syscall_trace_exit {
>  extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
>  
>  struct trace_ksym {
> -	struct trace_entry	ent;
>  	struct hw_breakpoint	*ksym_hbp;
>  	unsigned long		ksym_addr;
> -	unsigned long		ip;
>  #ifdef CONFIG_PROFILE_KSYM_TRACER
>  	unsigned long		counter;
>  #endif
>  	struct hlist_node	ksym_hlist;
>  	char			ksym_name[KSYM_NAME_LEN];
> +};
> +
> +/* Ring buffer's copy of the breakpoint data */
> +struct trace_ksym_rb {
> +	struct trace_entry	ent;
> +	struct hw_breakpoint	ksym_hbp;
> +	unsigned long		ip;
> +	char			ksym_name[KSYM_NAME_LEN];
>  	char			p_name[TASK_COMM_LEN];
>  };
>  
> @@ -343,7 +349,7 @@ extern void __ftrace_bad_type(void);
>  			  TRACE_SYSCALL_ENTER);				\
>  		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
>  			  TRACE_SYSCALL_EXIT);				\
> -		IF_ASSIGN(var, ent, struct trace_ksym, TRACE_KSYM);	\
> +		IF_ASSIGN(var, ent, struct trace_ksym_rb, TRACE_KSYM);	\
>  		__ftrace_bad_type();					\
>  	} while (0)
>  
> 

