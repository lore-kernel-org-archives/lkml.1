Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbZBTXKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbZBTXKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZBTXKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:10:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48851 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbZBTXJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:09:59 -0500
Message-ID: <499F383B.6060700@redhat.com>
Date: Fri, 20 Feb 2009 18:09:47 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: hpa@zytor.com, mingo@redhat.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm, kprobes: fault.c, simplify notify_page_fault()
References: <tip-b18018126f422f5b706fd750373425e10e84b486@kernel.org>
In-Reply-To: <tip-b18018126f422f5b706fd750373425e10e84b486@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Fri, 20 Feb 2009 22:42:57 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 21 Feb 2009 00:09:42 +0100
> 
> x86, mm, kprobes: fault.c, simplify notify_page_fault()
> 
> Impact: cleanup
> 
> Remove an #ifdef from notify_page_fault(). The function still
> compiles to nothing in the !CONFIG_KPROBES case.
> 
> Introduce kprobes_built_in() and kprobe_fault_handler() helpers
> to allow this - they returns 0 if !CONFIG_KPROBES.
> 
> No code changed:
> 
>    text	   data	    bss	    dec	    hex	filename
>    4618	     32	     24	   4674	   1242	fault.o.before
>    4618	     32	     24	   4674	   1242	fault.o.after

It seems good for me. Thank you for cleanup!

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> 
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/mm/fault.c     |    6 +-----
>  include/linux/kprobes.h |   22 +++++++++++++++++++---
>  2 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index fe99af4..379beae 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -68,11 +68,10 @@ static inline int kmmio_fault(struct pt_regs *regs, unsigned long addr)
>  
>  static inline int notify_page_fault(struct pt_regs *regs)
>  {
> -#ifdef CONFIG_KPROBES
>  	int ret = 0;
>  
>  	/* kprobe_running() needs smp_processor_id() */
> -	if (!user_mode_vm(regs)) {
> +	if (kprobes_built_in() && !user_mode_vm(regs)) {
>  		preempt_disable();
>  		if (kprobe_running() && kprobe_fault_handler(regs, 14))
>  			ret = 1;
> @@ -80,9 +79,6 @@ static inline int notify_page_fault(struct pt_regs *regs)
>  	}
>  
>  	return ret;
> -#else
> -	return 0;
> -#endif
>  }
>  
>  /*
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index 32851ee..2ec6cc1 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -182,6 +182,14 @@ struct kprobe_blackpoint {
>  DECLARE_PER_CPU(struct kprobe *, current_kprobe);
>  DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>  
> +/*
> + * For #ifdef avoidance:
> + */
> +static inline int kprobes_built_in(void)
> +{
> +	return 1;
> +}
> +
>  #ifdef CONFIG_KRETPROBES
>  extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
>  				   struct pt_regs *regs);
> @@ -271,8 +279,16 @@ void unregister_kretprobes(struct kretprobe **rps, int num);
>  void kprobe_flush_task(struct task_struct *tk);
>  void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
>  
> -#else /* CONFIG_KPROBES */
> +#else /* !CONFIG_KPROBES: */
>  
> +static inline int kprobes_built_in(void)
> +{
> +	return 0;
> +}
> +static inline int kprobe_fault_handler(struct pt_regs *regs, int trapnr)
> +{
> +	return 0;
> +}
>  static inline struct kprobe *get_kprobe(void *addr)
>  {
>  	return NULL;
> @@ -329,5 +345,5 @@ static inline void unregister_kretprobes(struct kretprobe **rps, int num)
>  static inline void kprobe_flush_task(struct task_struct *tk)
>  {
>  }
> -#endif				/* CONFIG_KPROBES */
> -#endif				/* _LINUX_KPROBES_H */
> +#endif /* CONFIG_KPROBES */
> +#endif /* _LINUX_KPROBES_H */

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

