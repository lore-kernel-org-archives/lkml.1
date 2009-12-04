Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbZLDDNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbZLDDNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 22:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZLDDNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 22:13:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:48255 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbZLDDNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 22:13:05 -0500
Subject: Re: [PATCH 1/2] hw-breakpoints: Perf interface support for
 breakpoint ranges
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1259874964-7757-1-git-send-regression-fweisbec@gmail.com>
References: <1259874964-7757-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 14:08:53 +1100
Message-ID: <1259896133.2076.1254.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 22:16 +0100, Frederic Weisbecker wrote:
> Looking a the PowerPc cpu implementations of breakpoints, we have
> for both data and instruction breakpoints:
> 
> - 2 Address registers (let's rather talk about a comparison operand)
> - Control registers that define the comparison nature (equal, greater,
>   lesser than) against the above addresses.
> - Control registers that define how to handle the 2 address registers.
>   The instruction address or memory access need to either match
>    - Address 1 OR Address 2 (OR = boolean OR, not binary)
>    - Address 1 AND Address 2 ( AND = boolean AND, not binary)
>   And this match is subject to the comparison rules independantly
>   defined for these two addresses by the control registers

Well.. the debug facility is different between different PowerPC CPU
families... There's range breakpoints on some but not all, there's data
value compare or even instruction value compare on some, etc...

> The most obvious practical uses of these facilities are either the
> definition of two independant traditional breakpoints, or the
> definition of a breakpoint that matches a range of addresses.
> 
> Hence we want the generic breakpoint interface to support it.
> This patch splits up the struct perf_event_attr::bp_addr field
> into bp_start and bp_end.

Ok, that sounds like a good idea.

> The definition of a simple breakpoint needs bp_start and bp_end to be
> equal, ie: a simple breakpoint is a range breakpoint which start and
> end addresses are identical.

Ok. So a 0 sized point. Makes sense.

> To define a range breakpoint, you just need to set bp_start and bp_end
> to the limits of your address range.

Inclusive ?

Cheers,
Ben.

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Prasad <prasad@linux.vnet.ibm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> ---
>  arch/x86/kernel/hw_breakpoint.c         |    8 ++++++--
>  arch/x86/kernel/ptrace.c                |    6 ++++--
>  include/linux/hw_breakpoint.h           |    4 ++--
>  include/linux/perf_event.h              |    3 ++-
>  kernel/perf_event.c                     |    2 +-
>  kernel/trace/trace_ksym.c               |   15 ++++++++-------
>  samples/hw_breakpoint/data_breakpoint.c |    3 ++-
>  tools/perf/util/parse-events.c          |    3 ++-
>  8 files changed, 27 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
> index d42f65a..910ae0e 100644
> --- a/arch/x86/kernel/hw_breakpoint.c
> +++ b/arch/x86/kernel/hw_breakpoint.c
> @@ -277,7 +277,11 @@ static int arch_build_bp_info(struct perf_event *bp)
>  {
>  	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
>  
> -	info->address = bp->attr.bp_addr;
> +	/* We don't support breakpoint ranges */
> +	if (bp->attr.bp_start != bp->attr.bp_end)
> +		return -EINVAL;
> +
> +	info->address = bp->attr.bp_start;
>  
>  	/* Len */
>  	switch (bp->attr.bp_len) {
> @@ -406,7 +410,7 @@ void aout_dump_debugregs(struct user *dump)
>  		bp = thread->ptrace_bps[i];
>  
>  		if (bp && !bp->attr.disabled) {
> -			dump->u_debugreg[i] = bp->attr.bp_addr;
> +			dump->u_debugreg[i] = bp->attr.bp_start;
>  			info = counter_arch_bp(bp);
>  			dr7 |= encode_dr7(i, info->len, info->type);
>  		} else {
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index 04d182a..5d60a0f 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -728,7 +728,8 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
>  		 * Put stub len and type to register (reserve) an inactive but
>  		 * correct bp
>  		 */
> -		attr.bp_addr = addr;
> +		attr.bp_start = addr;
> +		attr.bp_end = addr;
>  		attr.bp_len = HW_BREAKPOINT_LEN_1;
>  		attr.bp_type = HW_BREAKPOINT_W;
>  		attr.disabled = 1;
> @@ -739,7 +740,8 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
>  		t->ptrace_bps[nr] = NULL;
>  
>  		attr = bp->attr;
> -		attr.bp_addr = addr;
> +		attr.bp_start = addr;
> +		attr.bp_end = addr;
>  		bp = modify_user_hw_breakpoint(bp, &attr, bp->callback, tsk);
>  	}
>  	/*
> diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
> index a03daed..d711c98 100644
> --- a/include/linux/hw_breakpoint.h
> +++ b/include/linux/hw_breakpoint.h
> @@ -35,9 +35,9 @@ static inline void hw_breakpoint_init(struct perf_event_attr *attr)
>  	attr->pinned = 1;
>  }
>  
> -static inline unsigned long hw_breakpoint_addr(struct perf_event *bp)
> +static inline unsigned long hw_breakpoint_start_addr(struct perf_event *bp)
>  {
> -	return bp->attr.bp_addr;
> +	return bp->attr.bp_start;
>  }
>  
>  static inline int hw_breakpoint_type(struct perf_event *bp)
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 43adbd7..771d04c 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -217,7 +217,8 @@ struct perf_event_attr {
>  
>  	union {
>  		struct { /* Hardware breakpoint info */
> -			__u64		bp_addr;
> +			__u64		bp_start;
> +			__u64		bp_end;
>  			__u32		bp_type;
>  			__u32		bp_len;
>  		};
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 6b7ddba..43ed326 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4308,7 +4308,7 @@ void perf_bp_event(struct perf_event *bp, void *data)
>  	struct perf_sample_data sample;
>  	struct pt_regs *regs = data;
>  
> -	sample.addr = bp->attr.bp_addr;
> +	sample.addr = instruction_pointer(regs);
>  
>  	if (!perf_exclude_event(bp, regs))
>  		perf_swevent_add(bp, 1, 1, &sample, regs);
> diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
> index ddfa0fd..bbdc02a 100644
> --- a/kernel/trace/trace_ksym.c
> +++ b/kernel/trace/trace_ksym.c
> @@ -69,7 +69,7 @@ void ksym_collect_stats(unsigned long hbp_hit_addr)
>  
>  	rcu_read_lock();
>  	hlist_for_each_entry_rcu(entry, node, &ksym_filter_head, ksym_hlist) {
> -		if ((entry->attr.bp_addr == hbp_hit_addr) &&
> +		if ((entry->attr.bp_start == hbp_hit_addr) &&
>  		    (entry->counter <= MAX_UL_INT)) {
>  			entry->counter++;
>  			break;
> @@ -102,11 +102,11 @@ void ksym_hbp_handler(struct perf_event *hbp, void *data)
>  	entry		= ring_buffer_event_data(event);
>  	entry->ip	= instruction_pointer(regs);
>  	entry->type	= hw_breakpoint_type(hbp);
> -	entry->addr	= hw_breakpoint_addr(hbp);
> +	entry->addr	= hw_breakpoint_start_addr(hbp);
>  	strlcpy(entry->cmd, current->comm, TASK_COMM_LEN);
>  
>  #ifdef CONFIG_PROFILE_KSYM_TRACER
> -	ksym_collect_stats(hw_breakpoint_addr(hbp));
> +	ksym_collect_stats(hw_breakpoint_start_addr(hbp));
>  #endif /* CONFIG_PROFILE_KSYM_TRACER */
>  
>  	trace_buffer_unlock_commit(buffer, event, 0, pc);
> @@ -193,7 +193,8 @@ int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
>  	hw_breakpoint_init(&entry->attr);
>  
>  	entry->attr.bp_type = op;
> -	entry->attr.bp_addr = addr;
> +	entry->attr.bp_start = addr;
> +	entry->attr.bp_end = addr;
>  	entry->attr.bp_len = HW_BREAKPOINT_LEN_4;
>  
>  	ret = -EAGAIN;
> @@ -235,7 +236,7 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
>  	mutex_lock(&ksym_tracer_mutex);
>  
>  	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
> -		ret = trace_seq_printf(s, "%pS:", (void *)entry->attr.bp_addr);
> +		ret = trace_seq_printf(s, "%pS:", (void *)entry->attr.bp_start);
>  		if (entry->attr.bp_type == HW_BREAKPOINT_R)
>  			ret = trace_seq_puts(s, "r--\n");
>  		else if (entry->attr.bp_type == HW_BREAKPOINT_W)
> @@ -316,7 +317,7 @@ static ssize_t ksym_trace_filter_write(struct file *file,
>  
>  	ret = -EINVAL;
>  	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
> -		if (entry->attr.bp_addr == ksym_addr) {
> +		if (entry->attr.bp_start == ksym_addr) {
>  			/* Check for malformed request: (6) */
>  			if (entry->attr.bp_type != op)
>  				changed = 1;
> @@ -503,7 +504,7 @@ static int ksym_tracer_stat_show(struct seq_file *m, void *v)
>  		seq_puts(m, "  NA          ");
>  	}
>  
> -	if (lookup_symbol_name(entry->attr.bp_addr, fn_name) >= 0)
> +	if (lookup_symbol_name(entry->attr.bp_start, fn_name) >= 0)
>  		seq_printf(m, "  %-36s", fn_name);
>  	else
>  		seq_printf(m, "  %-36s", "<NA>");
> diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
> index 2952550..1bc5c4e 100644
> --- a/samples/hw_breakpoint/data_breakpoint.c
> +++ b/samples/hw_breakpoint/data_breakpoint.c
> @@ -53,7 +53,8 @@ static int __init hw_break_module_init(void)
>  	int ret;
>  	DEFINE_BREAKPOINT_ATTR(attr);
>  
> -	attr.bp_addr = kallsyms_lookup_name(ksym_name);
> +	attr.bp_start = kallsyms_lookup_name(ksym_name);
> +	attr.bp_end = attr.bp_start;
>  	attr.bp_len = HW_BREAKPOINT_LEN_4;
>  	attr.bp_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
>  
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 9e5dbd6..4fa41a0 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -594,7 +594,8 @@ parse_breakpoint_event(const char **strp, struct perf_event_attr *attr)
>  	if (target == endaddr)
>  		return EVT_FAILED;
>  
> -	attr->bp_addr = addr;
> +	attr->bp_start = addr;
> +	attr->bp_end = addr;
>  	*strp = endaddr;
>  
>  	type = strchr(target, ':');


