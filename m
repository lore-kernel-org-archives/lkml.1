Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbYAIXjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbYAIXjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757799AbYAIXdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:33:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757616AbYAIXdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:33:09 -0500
Message-ID: <4785596F.4030003@redhat.com>
Date: Wed, 09 Jan 2008 18:31:59 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>, hskinnemoen@atmel.com,
       schwidefsky@de.ibm.com, tony.luck@intel.com,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCHv4] kprobes: Introduce kprobe_handle_fault()
References: <1199737486.7666.12.camel@brick>	 <18307.64807.204087.375733@cargo.ozlabs.ibm.com>	 <1199833324.6424.12.camel@brick> <1199852360.6424.39.camel@brick>	 <20080109061408.GA9486@osiris.ibm.com>  <1199859742.6424.44.camel@brick> <1199916062.6424.60.camel@brick>
In-Reply-To: <1199916062.6424.60.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

Harvey Harrison wrote:
> Use a central kprobe_handle_fault() inline in kprobes.h to remove
> all of the arch-dependant, practically identical implementations in
> avr32, ia64, powerpc, s390, sparc64, and x86.
> 
> This patch removes the preempt_disable/enable pair around kprobe_running
> which was originally added to avoid the assertion from smp_processor_id
> which would be unreliable if preemption was enabled.
> 
> Kprobes can not be running if we are preemptible, so test explicitly
> for preemption and bail out before hitting kprobe_running().
> 
> Style comments from Christoph Hellwig and Heiko Carstens included in
> this version.

Could you please separate this patch into 2 parts as Christoph mentioned?:
- introduce kprobe_handle_fault()
- remove preempt_disable/enable.

I agree with removing preempt_disable/enable, because kprobes premises
that it runs on same CPU while processing probing and single-stepping.
Actually, it uses per-cpu  to check the running kprobe's status.
Thus, if a fault occurs when preemption is enabled, we can ensure
that it is not caused by a kprobe handler.

> 
> avr32 was the only arch without the preempt_disable/enable pair
> in its notify_page_fault implementation.
> 
> This uncovered a possible bug in the s390 version as that purely
> copied the x86 version unconditionally passing 14 as the trapnr
> rather than the error_code parameter.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  arch/avr32/mm/fault.c   |   21 +--------------------
>  arch/ia64/mm/fault.c    |   24 +-----------------------
>  arch/powerpc/mm/fault.c |   25 +------------------------
>  arch/s390/mm/fault.c    |   25 +------------------------
>  arch/sparc64/mm/fault.c |   23 +----------------------
>  arch/x86/mm/fault_64.c  |   23 ++---------------------
>  include/linux/kprobes.h |   17 +++++++++++++++++
>  7 files changed, 24 insertions(+), 134 deletions(-)
> 
> diff --git a/arch/avr32/mm/fault.c b/arch/avr32/mm/fault.c
> index 6560cb1..e41953e 100644
> --- a/arch/avr32/mm/fault.c
> +++ b/arch/avr32/mm/fault.c
> @@ -20,25 +20,6 @@
>  #include <asm/tlb.h>
>  #include <asm/uaccess.h>
>  
> -#ifdef CONFIG_KPROBES
> -static inline int notify_page_fault(struct pt_regs *regs, int trap)
> -{
> -	int ret = 0;
> -
> -	if (!user_mode(regs)) {
> -		if (kprobe_running() && kprobe_fault_handler(regs, trap))
> -			ret = 1;
> -	}
> -
> -	return ret;
> -}
> -#else
> -static inline int notify_page_fault(struct pt_regs *regs, int trap)
> -{
> -	return 0;
> -}
> -#endif
> -
>  int exception_trace = 1;
>  
>  /*
> @@ -66,7 +47,7 @@ asmlinkage void do_page_fault(unsigned long ecr, struct pt_regs *regs)
>  	int code;
>  	int fault;
>  
> -	if (notify_page_fault(regs, ecr))
> +	if (kprobe_handle_fault(regs, ecr))
>  		return;
>  
>  	address = sysreg_read(TLBEAR);
> diff --git a/arch/ia64/mm/fault.c b/arch/ia64/mm/fault.c
> index 7571076..bfc83e8 100644
> --- a/arch/ia64/mm/fault.c
> +++ b/arch/ia64/mm/fault.c
> @@ -18,28 +18,6 @@
>  
>  extern void die (char *, struct pt_regs *, long);
>  
> -#ifdef CONFIG_KPROBES
> -static inline int notify_page_fault(struct pt_regs *regs, int trap)
> -{
> -	int ret = 0;
> -
> -	if (!user_mode(regs)) {
> -		/* kprobe_running() needs smp_processor_id() */
> -		preempt_disable();
> -		if (kprobe_running() && kprobes_fault_handler(regs, trap))
> -			ret = 1;
> -		preempt_enable();
> -	}
> -
> -	return ret;
> -}
> -#else
> -static inline int notify_page_fault(struct pt_regs *regs, int trap)
> -{
> -	return 0;
> -}
> -#endif
> -
>  /*
>   * Return TRUE if ADDRESS points at a page in the kernel's mapped segment
>   * (inside region 5, on ia64) and that page is present.
> @@ -106,7 +84,7 @@ ia64_do_page_fault (unsigned long address, unsigned long isr, struct pt_regs *re
>  	/*
>  	 * This is to handle the kprobes on user space access instructions
>  	 */
> -	if (notify_page_fault(regs, TRAP_BRKPT))
> +	if (kprobe_handle_fault(regs, TRAP_BRKPT))
>  		return;
>  
>  	down_read(&mm->mmap_sem);
> diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
> index 8135da0..ff64bd3 100644
> --- a/arch/powerpc/mm/fault.c
> +++ b/arch/powerpc/mm/fault.c
> @@ -39,29 +39,6 @@
>  #include <asm/tlbflush.h>
>  #include <asm/siginfo.h>
>  
> -
> -#ifdef CONFIG_KPROBES
> -static inline int notify_page_fault(struct pt_regs *regs)
> -{
> -	int ret = 0;
> -
> -	/* kprobe_running() needs smp_processor_id() */
> -	if (!user_mode(regs)) {
> -		preempt_disable();
> -		if (kprobe_running() && kprobe_fault_handler(regs, 11))
> -			ret = 1;
> -		preempt_enable();
> -	}
> -
> -	return ret;
> -}
> -#else
> -static inline int notify_page_fault(struct pt_regs *regs)
> -{
> -	return 0;
> -}
> -#endif
> -
>  /*
>   * Check whether the instruction at regs->nip is a store using
>   * an update addressing form which will update r1.
> @@ -164,7 +141,7 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
>  	is_write = error_code & ESR_DST;
>  #endif /* CONFIG_4xx || CONFIG_BOOKE */
>  
> -	if (notify_page_fault(regs))
> +	if (kprobe_handle_fault(regs, 11))
>  		return 0;
>  
>  	if (trap == 0x300) {
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index 2456b52..a9033cf 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -51,29 +51,6 @@ extern int sysctl_userprocess_debug;
>  
>  extern void die(const char *,struct pt_regs *,long);
>  
> -#ifdef CONFIG_KPROBES
> -static inline int notify_page_fault(struct pt_regs *regs, long err)
> -{
> -	int ret = 0;
> -
> -	/* kprobe_running() needs smp_processor_id() */
> -	if (!user_mode(regs)) {
> -		preempt_disable();
> -		if (kprobe_running() && kprobe_fault_handler(regs, 14))
> -			ret = 1;
> -		preempt_enable();
> -	}
> -
> -	return ret;
> -}
> -#else
> -static inline int notify_page_fault(struct pt_regs *regs, long err)
> -{
> -	return 0;
> -}
> -#endif
> -
> -
>  /*
>   * Unlock any spinlocks which will prevent us from getting the
>   * message out.
> @@ -309,7 +286,7 @@ do_exception(struct pt_regs *regs, unsigned long error_code, int write)
>  	int si_code;
>  	int fault;
>  
> -	if (notify_page_fault(regs, error_code))
> +	if (kprobe_handle_fault(regs, 14))
>  		return;
>  
>  	tsk = current;
> diff --git a/arch/sparc64/mm/fault.c b/arch/sparc64/mm/fault.c
> index e2027f2..8467dd6 100644
> --- a/arch/sparc64/mm/fault.c
> +++ b/arch/sparc64/mm/fault.c
> @@ -31,27 +31,6 @@
>  #include <asm/sections.h>
>  #include <asm/mmu_context.h>
>  
> -#ifdef CONFIG_KPROBES
> -static inline int notify_page_fault(struct pt_regs *regs)
> -{
> -	int ret = 0;
> -
> -	/* kprobe_running() needs smp_processor_id() */
> -	if (!user_mode(regs)) {
> -		preempt_disable();
> -		if (kprobe_running() && kprobe_fault_handler(regs, 0))
> -			ret = 1;
> -		preempt_enable();
> -	}
> -	return ret;
> -}
> -#else
> -static inline int notify_page_fault(struct pt_regs *regs)
> -{
> -	return 0;
> -}
> -#endif
> -
>  /*
>   * To debug kernel to catch accesses to certain virtual/physical addresses.
>   * Mode = 0 selects physical watchpoints, mode = 1 selects virtual watchpoints.
> @@ -280,7 +259,7 @@ asmlinkage void __kprobes do_sparc64_fault(struct pt_regs *regs)
>  
>  	fault_code = get_thread_fault_code();
>  
> -	if (notify_page_fault(regs))
> +	if (kprobe_handle_fault(regs, 0))
>  		return;
>  
>  	si_code = SEGV_MAPERR;
> diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
> index f681ff8..f81660f 100644
> --- a/arch/x86/mm/fault_64.c
> +++ b/arch/x86/mm/fault_64.c
> @@ -45,25 +45,6 @@
>  #define PF_RSVD		(1<<3)
>  #define PF_INSTR	(1<<4)
>  
> -static inline int notify_page_fault(struct pt_regs *regs)
> -{
> -#ifdef CONFIG_KPROBES
> -	int ret = 0;
> -
> -	/* kprobe_running() needs smp_processor_id() */
> -	if (!user_mode(regs)) {
> -		preempt_disable();
> -		if (kprobe_running() && kprobe_fault_handler(regs, 14))
> -			ret = 1;
> -		preempt_enable();
> -	}
> -
> -	return ret;
> -#else
> -	return 0;
> -#endif
> -}
> -
>  #ifdef CONFIG_X86_32
>  /*
>   * Return EIP plus the CS segment base.  The segment limit is also
> @@ -468,7 +449,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
>  			if (vmalloc_fault(address) >= 0)
>  				return;
>  		}
> -		if (notify_page_fault(regs))
> +		if (kprobe_handle_fault(regs, 14))
>  			return;
>  		/*
>  		 * Don't take the mm semaphore here. If we fixup a prefetch
> @@ -477,7 +458,7 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
>  		goto bad_area_nosemaphore;
>  	}
>  
> -	if (notify_page_fault(regs))
> +	if (kprobe_handle_fault(regs, 14))
>  		return;
>  
>  	if (likely(regs->flags & X86_EFLAGS_IF))
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index 6168c0a..e099426 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -36,6 +36,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/rcupdate.h>
>  #include <linux/mutex.h>
> +#include <linux/hardirq.h>
>  
>  #ifdef CONFIG_KPROBES
>  #include <asm/kprobes.h>
> @@ -212,6 +213,18 @@ static inline struct kprobe *kprobe_running(void)
>  	return (__get_cpu_var(current_kprobe));
>  }
>  
> +/*
> + * If it is a kprobe pagefault we can not be preemptible so return before
> + * calling kprobe_running() as it will assert on smp_processor_id if
> + * preemption is enabled.
> + */
> +static inline int kprobe_handle_fault(struct pt_regs *regs, int trapnr)
> +{
> +	if (!user_mode(regs) && !preemptible() && kprobe_running())
> +		return kprobe_fault_handler(regs, trapnr);
> +	return 0;
> +}
> +
>  static inline void reset_current_kprobe(void)
>  {
>  	__get_cpu_var(current_kprobe) = NULL;
> @@ -247,6 +260,10 @@ static inline struct kprobe *kprobe_running(void)
>  {
>  	return NULL;
>  }
> +static inline int kprobe_handle_fault(struct pt_regs *regs, int trapnr)
> +{
> +	return 0;
> +}
>  static inline int register_kprobe(struct kprobe *p)
>  {
>  	return -ENOSYS;

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

