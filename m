Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbXKIUxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbXKIUxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 15:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXKIUxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 15:53:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:49508 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbXKIUxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 15:53:15 -0500
Subject: Re: [PATCH, RFC] improved hacks to allow -rt to run kernbench on
	POWER
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, tony@bakeyournoodle.com, paulus@samba.org,
       dino@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       antonb@us.ibm.com, rostedt@goodmis.org
In-Reply-To: <20071109181028.GA26800@linux.vnet.ibm.com>
References: <20071109181028.GA26800@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Sat, 10 Nov 2007 07:52:04 +1100
Message-Id: <1194641524.21340.14.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> diff -urpNa -X dontdiff linux-2.6.23.1-rt4/arch/powerpc/kernel/process.c linux-2.6.23.1-rt4-fix/arch/powerpc/kernel/process.c
> --- linux-2.6.23.1-rt4/arch/powerpc/kernel/process.c	2007-10-12 09:43:44.000000000 -0700
> +++ linux-2.6.23.1-rt4-fix/arch/powerpc/kernel/process.c	2007-11-08 20:33:59.000000000 -0800
> @@ -245,6 +245,8 @@ struct task_struct *__switch_to(struct t
>  	struct thread_struct *new_thread, *old_thread;
>  	unsigned long flags;
>  	struct task_struct *last;
> +	struct ppc64_tlb_batch *batch;
> +	int hadbatch;
>  
>  #ifdef CONFIG_SMP
>  	/* avoid complexity of lazy save/restore of fpu
> @@ -325,6 +327,16 @@ struct task_struct *__switch_to(struct t
>  	}
>  #endif
>  
> +	batch = &get_cpu_var(ppc64_tlb_batch);
> +	if (batch->active) {
> +		hadbatch = 1;
> +		if (batch->index) {
> +			__flush_tlb_pending(batch);
> +		}
> +		batch->active = 0;
> +	}
> +	put_cpu_var(ppc64_tlb_batch);
> +
>  	local_irq_save(flags);
>  
>  	account_system_vtime(current);
> @@ -335,6 +347,12 @@ struct task_struct *__switch_to(struct t
>  
>  	local_irq_restore(flags);
>  
> +	if (hadbatch) {
> +		batch = &get_cpu_var(ppc64_tlb_batch);
> +		batch->active = 1;
> +		put_cpu_var(ppc64_tlb_batch);
> +	}
> +
>  	return last;
>  }

I doubt we can schedule within __switch_to() (can somebody confirm
this ?), in which case, you can just use __get_cpu_var() and avoid
the put, thus saving a handful of cycles in the code above.

>  /* export that to outside world */
>  struct device_node *of_chosen;
> diff -urpNa -X dontdiff linux-2.6.23.1-rt4/arch/powerpc/mm/fault.c linux-2.6.23.1-rt4-fix/arch/powerpc/mm/fault.c
> --- linux-2.6.23.1-rt4/arch/powerpc/mm/fault.c	2007-10-27 22:20:57.000000000 -0700
> +++ linux-2.6.23.1-rt4-fix/arch/powerpc/mm/fault.c	2007-10-28 13:49:07.000000000 -0700
> @@ -301,6 +301,7 @@ good_area:
>  		if (get_pteptr(mm, address, &ptep, &pmdp)) {
>  			spinlock_t *ptl = pte_lockptr(mm, pmdp);
>  			spin_lock(ptl);
> +			preempt_disable();
>  			if (pte_present(*ptep)) {
>  				struct page *page = pte_page(*ptep);
>  
> @@ -310,10 +311,12 @@ good_area:
>  				}
>  				pte_update(ptep, 0, _PAGE_HWEXEC);
>  				_tlbie(address);
> +				preempt_enable();
>  				pte_unmap_unlock(ptep, ptl);
>  				up_read(&mm->mmap_sem);
>  				return 0;
>  			}
> +			preempt_enable();
>  			pte_unmap_unlock(ptep, ptl);
>  		}
>  #endif

 
The patch above will have to be rebased following a fix I did that makes
_tlbie() takes a context ID argument. I don't actually think
preempt_disable/enable is necessary here. I don't think it matters if we
preempt here, but I suppose better safe than sorry.... (this is 44x
code).

Overall, looks fine !

Cheers,
Ben.

