Return-Path: <linux-kernel-owner+w=401wt.eu-S1757775AbZKXCoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbZKXCoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 21:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbZKXCoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 21:44:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41797 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410AbZKXCoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 21:44:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hNHr7QzyxiiTac2c4+HH6IU4OgltFk+mpe6l40trsetTOFleCtzdhjjfpBMQOWBRfd
         +s0x7m5fGU2eYHVkS8t2aCVZ6t4YQDeCEBthGTfZhpeDgzbB7pJu1K1aSqht1h5vbNTN
         omzs3b/4HZwNHSntAs72rsEGZWAKCnDI019PU=
Date: Tue, 24 Nov 2009 03:44:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH -tip v5 03/10] kprobes: Introduce kprobes jump
	optimization
Message-ID: <20091124024417.GA6752@nowhere>
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232141.22071.53317.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123232141.22071.53317.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 06:21:41PM -0500, Masami Hiramatsu wrote:
> +config OPTPROBES
> +	bool "Kprobes jump optimization support (EXPERIMENTAL)"
> +	default y
> +	depends on KPROBES
> +	depends on !PREEMPT


Why does it depends on !PREEMPT?



> +	depends on HAVE_OPTPROBES
> +	select KALLSYMS_ALL
> +	help
> +	  This option will allow kprobes to optimize breakpoint to
> +	  a jump for reducing its overhead.
> +
>  config HAVE_EFFICIENT_UNALIGNED_ACCESS
>  	bool
>  	help
> @@ -99,6 +110,8 @@ config HAVE_KPROBES
>  config HAVE_KRETPROBES
>  	bool
>  
> +config HAVE_OPTPROBES
> +	bool
>  #
>  # An arch should select this if it provides all these things:
>  #
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index 1b672f7..aed1f95 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -122,6 +122,11 @@ struct kprobe {
>  /* Kprobe status flags */
>  #define KPROBE_FLAG_GONE	1 /* breakpoint has already gone */
>  #define KPROBE_FLAG_DISABLED	2 /* probe is temporarily disabled */
> +#define KPROBE_FLAG_OPTIMIZED	4 /*
> +				   * probe is really optimized.
> +				   * NOTE:
> +				   * this flag is only for optimized_kprobe.
> +				   */
>  
>  /* Has this kprobe gone ? */
>  static inline int kprobe_gone(struct kprobe *p)
> @@ -134,6 +139,12 @@ static inline int kprobe_disabled(struct kprobe *p)
>  {
>  	return p->flags & (KPROBE_FLAG_DISABLED | KPROBE_FLAG_GONE);
>  }
> +
> +/* Is this kprobe really running optimized path ? */
> +static inline int kprobe_optimized(struct kprobe *p)
> +{
> +	return p->flags & KPROBE_FLAG_OPTIMIZED;
> +}
>  /*
>   * Special probe type that uses setjmp-longjmp type tricks to resume
>   * execution at a specified entry with a matching prototype corresponding
> @@ -249,6 +260,31 @@ extern kprobe_opcode_t *get_insn_slot(void);
>  extern void free_insn_slot(kprobe_opcode_t *slot, int dirty);
>  extern void kprobes_inc_nmissed_count(struct kprobe *p);
>  
> +#ifdef CONFIG_OPTPROBES
> +/*
> + * Internal structure for direct jump optimized probe
> + */
> +struct optimized_kprobe {
> +	struct kprobe kp;
> +	struct list_head list;	/* list for optimizing queue */
> +	struct arch_optimized_insn optinsn;
> +};
> +
> +/* Architecture dependent functions for direct jump optimization */
> +extern int arch_prepared_optinsn(struct arch_optimized_insn *optinsn);
> +extern int arch_check_optimized_kprobe(struct optimized_kprobe *op);
> +extern int arch_prepare_optimized_kprobe(struct optimized_kprobe *op);
> +extern void arch_remove_optimized_kprobe(struct optimized_kprobe *op);
> +extern int  arch_optimize_kprobe(struct optimized_kprobe *op);
> +extern void arch_unoptimize_kprobe(struct optimized_kprobe *op);
> +extern kprobe_opcode_t *get_optinsn_slot(void);
> +extern void free_optinsn_slot(kprobe_opcode_t *slot, int dirty);
> +extern int arch_within_optimized_kprobe(struct optimized_kprobe *op,
> +					unsigned long addr);
> +
> +extern void opt_pre_handler(struct kprobe *p, struct pt_regs *regs);
> +#endif /* CONFIG_OPTPROBES */
> +
>  /* Get the kprobe at this addr (if any) - called with preemption disabled */
>  struct kprobe *get_kprobe(void *addr);
>  void kretprobe_hash_lock(struct task_struct *tsk,
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 10d2ed5..15aa797 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -44,6 +44,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/kdebug.h>
>  #include <linux/memory.h>
> +#include <linux/cpu.h>
>  
>  #include <asm-generic/sections.h>
>  #include <asm/cacheflush.h>
> @@ -301,6 +302,31 @@ void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
>  	__free_insn_slot(&kprobe_insn_slots, slot, dirty);
>  	mutex_unlock(&kprobe_insn_mutex);
>  }
> +#ifdef CONFIG_OPTPROBES
> +/* For optimized_kprobe buffer */
> +static DEFINE_MUTEX(kprobe_optinsn_mutex); /* Protects kprobe_optinsn_slots */
> +static struct kprobe_insn_cache kprobe_optinsn_slots = {
> +	.pages = LIST_HEAD_INIT(kprobe_optinsn_slots.pages),
> +	/* .insn_size is initialized later */
> +	.nr_garbage = 0,
> +};
> +/* Get a slot for optimized_kprobe buffer */
> +kprobe_opcode_t __kprobes *get_optinsn_slot(void)
> +{
> +	kprobe_opcode_t *ret = NULL;
> +	mutex_lock(&kprobe_optinsn_mutex);
> +	ret = __get_insn_slot(&kprobe_optinsn_slots);
> +	mutex_unlock(&kprobe_optinsn_mutex);
> +	return ret;
> +}



Just a small nano-neat: could you add a line between variable
declarations and the rest? And also just before the return?
It makes the code a bit easier to review.



> +
> +void __kprobes free_optinsn_slot(kprobe_opcode_t * slot, int dirty)
> +{
> +	mutex_lock(&kprobe_optinsn_mutex);
> +	__free_insn_slot(&kprobe_optinsn_slots, slot, dirty);
> +	mutex_unlock(&kprobe_optinsn_mutex);
> +}
> +#endif
>  #endif
>  
>  /* We have preemption disabled.. so it is safe to use __ versions */
> @@ -334,20 +360,270 @@ struct kprobe __kprobes *get_kprobe(void *addr)
>  	return NULL;
>  }
>  
> +static int __kprobes aggr_pre_handler(struct kprobe *p, struct pt_regs *regs);
> +
> +/* Return true if the kprobe is an aggregator */
> +static inline int kprobe_aggrprobe(struct kprobe *p)
> +{
> +	return p->pre_handler == aggr_pre_handler;
> +}
> +
> +/*
> + * Keep all fields in the kprobe consistent
> + */
> +static inline void copy_kprobe(struct kprobe *old_p, struct kprobe *p)
> +{
> +	memcpy(&p->opcode, &old_p->opcode, sizeof(kprobe_opcode_t));
> +	memcpy(&p->ainsn, &old_p->ainsn, sizeof(struct arch_specific_insn));
> +}
> +
> +#ifdef CONFIG_OPTPROBES
> +/*
> + * Call all pre_handler on the list, but ignores its return value.
> + * This must be called from arch-dep optimized caller.
> + */
> +void __kprobes opt_pre_handler(struct kprobe *p, struct pt_regs *regs)
> +{
> +	struct kprobe *kp;
> +
> +	list_for_each_entry_rcu(kp, &p->list, list) {
> +		if (kp->pre_handler && likely(!kprobe_disabled(kp))) {
> +			set_kprobe_instance(kp);
> +			kp->pre_handler(kp, regs);
> +		}
> +		reset_kprobe_instance();
> +	}
> +}
> +
> +/* Return true(!0) if the kprobe is ready for optimization. */
> +static inline int kprobe_optready(struct kprobe *p)
> +{
> +	struct optimized_kprobe *op;
> +	if (kprobe_aggrprobe(p)) {
> +		op = container_of(p, struct optimized_kprobe, kp);
> +		return arch_prepared_optinsn(&op->optinsn);
> +	}
> +	return 0;
> +}
> +
> +/* Return an optimized kprobe which replaces instructions including addr. */
> +struct kprobe *__kprobes get_optimized_kprobe(unsigned long addr)
> +{
> +	int i;
> +	struct kprobe *p = NULL;
> +	struct optimized_kprobe *op;
> +	for (i = 0; !p && i < MAX_OPTIMIZED_LENGTH; i++)
> +		p = get_kprobe((void *)(addr - i));
> +
> +	if (p && kprobe_optready(p)) {
> +		op = container_of(p, struct optimized_kprobe, kp);
> +		if (arch_within_optimized_kprobe(op, addr))
> +			return p;
> +	}
> +	return NULL;
> +}
> +
> +/* Optimization staging list, protected by kprobe_mutex */
> +static LIST_HEAD(optimizing_list);
> +
> +static void kprobe_optimizer(struct work_struct *work);
> +static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
> +#define OPTIMIZE_DELAY 5
> +
> +/* Kprobe jump optimizer */
> +static __kprobes void kprobe_optimizer(struct work_struct *work)
> +{
> +	struct optimized_kprobe *op, *tmp;
> +
> +	/* Lock modules while optimizing kprobes */
> +	mutex_lock(&module_mutex);
> +	mutex_lock(&kprobe_mutex);
> +	if (kprobes_all_disarmed)
> +		goto end;
> +
> +	/* Wait quiesence period for ensuring all interrupts are done */
> +	synchronize_sched();



It's not clear to me why you are doing that.
Is this waiting for pending int 3 kprobes handlers
to complete? If so, why, and what does that prevent?

Also, why is it a delayed work? I'm not sure what we are
waiting for here.


> +
> +	get_online_cpus();	/* Use online_cpus while optimizing */



And this comment doesn't tell us much what this brings us.
The changelog tells it stands to avoid a text_mutex deadlock.
I'm not sure why we would deadlock without it.

Again, I think this dance with live patching protected
by int 3 only, which patching is in turn a necessary
stage before, is a complicated sequence that could be
simplified by choosing only one patching in stop_machine()
time.

