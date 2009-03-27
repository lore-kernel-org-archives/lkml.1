Return-Path: <linux-kernel-owner+w=401wt.eu-S932919AbZC0ASl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbZC0ASl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932856AbZC0ARm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:17:42 -0400
Received: from gw.goop.org ([64.81.55.164]:40750 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932867AbZC0ARk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:17:40 -0400
Message-ID: <49CC1B1C.3080102@goop.org>
Date: Thu, 26 Mar 2009 17:17:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lguest@ozlabs.org, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/5] lguest: avoid accidental recycling of pgdir pages
References: <200903271022.28863.rusty@rustcorp.com.au>
In-Reply-To: <200903271022.28863.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Impact: potential bugfix
>
> In theory, the kernel could reuse the same page as pgdir for a new process
> while the hypervisor keeps it cached.  This would have undesirable results.
>   

You can't just do this in tlb flush?

    J
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  arch/x86/include/asm/lguest_hcall.h |    1 +
>  arch/x86/lguest/boot.c              |    8 ++++++++
>  drivers/lguest/hypercalls.c         |    3 +++
>  drivers/lguest/lg.h                 |    1 +
>  drivers/lguest/page_tables.c        |   16 ++++++++++++++++
>  5 files changed, 29 insertions(+)
>
> diff --git a/drivers/lguest/hypercalls.c b/drivers/lguest/hypercalls.c
> index 54d66f0..a160894 100644
> --- a/drivers/lguest/hypercalls.c
> +++ b/drivers/lguest/hypercalls.c
> @@ -92,6 +92,9 @@ static void do_hcall(struct lg_cpu *cpu, struct hcall_args *args)
>  	case LHCALL_NOTIFY:
>  		cpu->pending_notify = args->arg1;
>  		break;
> +	case LHCALL_INVALIDATE_PGTABLE:
> +		invalidate_pagetable(cpu, args->arg1);
> +		break;
>  	default:
>  		/* It should be an architecture-specific hypercall. */
>  		if (lguest_arch_do_hcall(cpu, args))
> diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
> index 65f0b8a..c3bdf0b 100644
> --- a/arch/x86/lguest/boot.c
> +++ b/arch/x86/lguest/boot.c
> @@ -540,6 +551,13 @@ static void lguest_flush_tlb_kernel(void)
>  	lazy_hcall(LHCALL_FLUSH_TLB, 1, 0, 0);
>  }
>  
> +/* This routine is called when a process exits, and we're throwing away the
> + * page table. */
> +static void lguest_pgd_free(struct mm_struct *mm, pgd_t *pgd)
> +{
> +	lazy_hcall(LHCALL_INVALIDATE_PGTABLE, __pa(pgd), 0, 0);
> +}
> +
>  /*
>   * The Unadvanced Programmable Interrupt Controller.
>   *
> @@ -1018,6 +1046,7 @@ __init void lguest_init(void)
>  	pv_mmu_ops.lazy_mode.leave = lguest_leave_lazy_mode;
>  	pv_mmu_ops.pte_update = lguest_pte_update;
>  	pv_mmu_ops.pte_update_defer = lguest_pte_update;
> +	pv_mmu_ops.pgd_free = lguest_pgd_free;
>  
>  #ifdef CONFIG_X86_LOCAL_APIC
>  	/* apic read/write intercepts */
> diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
> index 5faefea..363c231 100644
> --- a/drivers/lguest/lg.h
> +++ b/drivers/lguest/lg.h
> @@ -174,6 +174,7 @@ void guest_set_pte(struct lg_cpu *cpu, unsigned long gpgdir,
>  		   unsigned long vaddr, pte_t val);
>  void map_switcher_in_guest(struct lg_cpu *cpu, struct lguest_pages *pages);
>  int demand_page(struct lg_cpu *cpu, unsigned long cr2, int errcode);
> +void invalidate_pagetable(struct lg_cpu *cpu, unsigned long pgtable);
>  void pin_page(struct lg_cpu *cpu, unsigned long vaddr);
>  unsigned long guest_pa(struct lg_cpu *cpu, unsigned long vaddr);
>  void page_table_guest_data_init(struct lg_cpu *cpu);
> diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
> index 81d0c60..fd3e1f5 100644
> --- a/drivers/lguest/page_tables.c
> +++ b/drivers/lguest/page_tables.c
> @@ -448,6 +571,22 @@ void guest_new_pagetable(struct lg_cpu *cpu, unsigned long pgtable)
>  		pin_stack_pages(cpu);
>  }
>  
> +/* The Guest tells us when a page is no longer being used as a pagetable.
> + * Without this there can be a subtle bug where the same page gets re-used
> + * for a different process, and we think it's the same one as the one we have
> + * in our little pgdir cache. */
> +void invalidate_pagetable(struct lg_cpu *cpu, unsigned long pgtable)
> +{
> +	unsigned int pgdir = find_pgdir(cpu->lg, pgtable);
> +
> +	if (pgdir != ARRAY_SIZE(cpu->lg->pgdirs)) {
> +		if (pgdir == cpu->cpu_pgd)
> +			kill_guest(cpu, "Attempt to invalidate in-use pgdir");
> +		/* We set it to an invalid value. */
> +		cpu->lg->pgdirs[pgdir].gpgdir = -1UL;
> +	}
> +}
> +
>  /*H:470 Finally, a routine which throws away everything: all PGD entries in all
>   * the shadow page tables, including the Guest's kernel mappings.  This is used
>   * when we destroy the Guest. */
> diff --git a/arch/x86/include/asm/lguest_hcall.h b/arch/x86/include/asm/lguest_hcall.h
> index 8f034ba..3e200ea 100644
> --- a/arch/x86/include/asm/lguest_hcall.h
> +++ b/arch/x86/include/asm/lguest_hcall.h
> @@ -17,6 +17,7 @@
>  #define LHCALL_SET_PMD		15
>  #define LHCALL_LOAD_TLS		16
>  #define LHCALL_NOTIFY		17
> +#define LHCALL_INVALIDATE_PGTABLE 18
>  
>  #define LGUEST_TRAP_ENTRY 0x1F
>  
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/virtualization
>   

