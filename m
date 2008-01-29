Return-Path: <linux-kernel-owner+w=401wt.eu-S1758484AbYA2Fk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbYA2Fk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYA2FkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:40:16 -0500
Received: from gw.goop.org ([64.81.55.164]:57546 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbYA2FkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:40:14 -0500
Message-ID: <479EBC3B.4090303@goop.org>
Date: Mon, 28 Jan 2008 21:40:11 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Reduce ifdef sections in fault.c
References: <1201578604.19875.59.camel@brick>
In-Reply-To: <1201578604.19875.59.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>   

x86.git has my patch which makes the pgd_list the same for 32-bit and 
64-bit, which means the code which traverses that list can be common now.

    J
> ---
>  arch/x86/mm/fault.c |   31 +++++++++----------------------
>  1 files changed, 9 insertions(+), 22 deletions(-)
>
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index e28cc52..2737493 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -508,6 +508,10 @@ static int vmalloc_fault(unsigned long address)
>  	pmd_t *pmd, *pmd_ref;
>  	pte_t *pte, *pte_ref;
>  
> +	/* Make sure we are in vmalloc area */
> +	if (!(address >= VMALLOC_START && address < VMALLOC_END))
> +		return -1;
> +
>  	/* Copy kernel mappings over when needed. This can also
>  	   happen within a race in page table update. In the later
>  	   case just flush. */
> @@ -603,6 +607,9 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	 */
>  #ifdef CONFIG_X86_32
>  	if (unlikely(address >= TASK_SIZE)) {
> +#else
> +	if (unlikely(address >= TASK_SIZE64)) {
> +#endif
>  		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
>  		    vmalloc_fault(address) >= 0)
>  			return;
> @@ -618,6 +625,8 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  		goto bad_area_nosemaphore;
>  	}
>  
> +
> +#ifdef CONFIG_X86_32
>  	/* It's safe to allow irq's after cr2 has been saved and the vmalloc
>  	   fault has been handled. */
>  	if (regs->flags & (X86_EFLAGS_IF|VM_MASK))
> @@ -630,28 +639,6 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	if (in_atomic() || !mm)
>  		goto bad_area_nosemaphore;
>  #else /* CONFIG_X86_64 */
> -	if (unlikely(address >= TASK_SIZE64)) {
> -		/*
> -		 * Don't check for the module range here: its PML4
> -		 * is always initialized because it's shared with the main
> -		 * kernel text. Only vmalloc may need PML4 syncups.
> -		 */
> -		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
> -		      ((address >= VMALLOC_START && address < VMALLOC_END))) {
> -			if (vmalloc_fault(address) >= 0)
> -				return;
> -		}
> -
> -		/* Can handle a stale RO->RW TLB */
> -		if (spurious_fault(address, error_code))
> -			return;
> -
> -		/*
> -		 * Don't take the mm semaphore here. If we fixup a prefetch
> -		 * fault we could otherwise deadlock.
> -		 */
> -		goto bad_area_nosemaphore;
> -	}
>  	if (likely(regs->flags & X86_EFLAGS_IF))
>  		local_irq_enable();
>  
>   

