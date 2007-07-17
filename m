Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbXGQFhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbXGQFhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 01:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbXGQFgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 01:36:51 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53375 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546AbXGQFgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 01:36:50 -0400
Date: Tue, 17 Jul 2007 11:08:40 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: Re: [PATCH] Kprobes - use a mutex to protect the instruction pages list.
Message-ID: <20070717053840.GB7033@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20070714012133.612727310@polymtl.ca> <20070714012411.262873138@polymtl.ca> <20070714104914.GB7358@infradead.org> <20070714195139.GM6975@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714195139.GM6975@Krystal>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2007 at 03:51:39PM -0400, Mathieu Desnoyers wrote:
> Kprobes - use a mutex to protect the instruction pages list.
> 
> Protect the instruction pages list by a specific insn pages mutex, called in 
> get_insn_slot() and free_insn_slot(). It makes sure that architectures that does
> not need to call arch_remove_kprobe() does not take an unneeded kprobes mutex.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: hch@infradead.org
> CC: prasanna@in.ibm.com
> CC: ananth@in.ibm.com
> CC: anil.s.keshavamurthy@intel.com
> CC: davem@davemloft.net

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Thanks Mathieu

> ---
>  kernel/kprobes.c |   27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6-lttng/kernel/kprobes.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/kprobes.c	2007-07-14 15:47:19.000000000 -0400
> +++ linux-2.6-lttng/kernel/kprobes.c	2007-07-14 15:48:51.000000000 -0400
> @@ -101,6 +101,10 @@ enum kprobe_slot_state {
>  	SLOT_USED = 2,
>  };
> 
> +/*
> + * Protects the kprobe_insn_pages list. Can nest into kprobe_mutex.
> + */
> +static DEFINE_MUTEX(kprobe_insn_mutex);
>  static struct hlist_head kprobe_insn_pages;
>  static int kprobe_garbage_slots;
>  static int collect_garbage_slots(void);
> @@ -137,7 +141,9 @@ kprobe_opcode_t __kprobes *get_insn_slot
>  {
>  	struct kprobe_insn_page *kip;
>  	struct hlist_node *pos;
> +	kprobe_opcode_t *ret;
> 
> +	mutex_lock(&kprobe_insn_mutex);
>   retry:
>  	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
>  		if (kip->nused < INSNS_PER_PAGE) {
> @@ -146,7 +152,8 @@ kprobe_opcode_t __kprobes *get_insn_slot
>  				if (kip->slot_used[i] == SLOT_CLEAN) {
>  					kip->slot_used[i] = SLOT_USED;
>  					kip->nused++;
> -					return kip->insns + (i * MAX_INSN_SIZE);
> +					ret = kip->insns + (i * MAX_INSN_SIZE);
> +					goto end;
>  				}
>  			}
>  			/* Surprise!  No unused slots.  Fix kip->nused. */
> @@ -160,8 +167,10 @@ kprobe_opcode_t __kprobes *get_insn_slot
>  	}
>  	/* All out of space.  Need to allocate a new page. Use slot 0. */
>  	kip = kmalloc(sizeof(struct kprobe_insn_page), GFP_KERNEL);
> -	if (!kip)
> -		return NULL;
> +	if (!kip) {
> +		ret = NULL;
> +		goto end;
> +	}
> 
>  	/*
>  	 * Use module_alloc so this page is within +/- 2GB of where the
> @@ -171,7 +180,8 @@ kprobe_opcode_t __kprobes *get_insn_slot
>  	kip->insns = module_alloc(PAGE_SIZE);
>  	if (!kip->insns) {
>  		kfree(kip);
> -		return NULL;
> +		ret = NULL;
> +		goto end;
>  	}
>  	INIT_HLIST_NODE(&kip->hlist);
>  	hlist_add_head(&kip->hlist, &kprobe_insn_pages);
> @@ -179,7 +189,10 @@ kprobe_opcode_t __kprobes *get_insn_slot
>  	kip->slot_used[0] = SLOT_USED;
>  	kip->nused = 1;
>  	kip->ngarbage = 0;
> -	return kip->insns;
> +	ret = kip->insns;
> +end:
> +	mutex_unlock(&kprobe_insn_mutex);
> +	return ret;
>  }
> 
>  /* Return 1 if all garbages are collected, otherwise 0. */
> @@ -213,7 +226,7 @@ static int __kprobes collect_garbage_slo
>  	struct kprobe_insn_page *kip;
>  	struct hlist_node *pos, *next;
> 
> -	/* Ensure no-one is preepmted on the garbages */
> +	/* Ensure no-one is preempted on the garbages */
>  	if (check_safety() != 0)
>  		return -EAGAIN;
> 
> @@ -237,6 +250,7 @@ void __kprobes free_insn_slot(kprobe_opc
>  	struct kprobe_insn_page *kip;
>  	struct hlist_node *pos;
> 
> +	mutex_lock(&kprobe_insn_mutex);
>  	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
>  		if (kip->insns <= slot &&
>  		    slot < kip->insns + (INSNS_PER_PAGE * MAX_INSN_SIZE)) {
> @@ -253,6 +267,7 @@ void __kprobes free_insn_slot(kprobe_opc
> 
>  	if (dirty && ++kprobe_garbage_slots > INSNS_PER_PAGE)
>  		collect_garbage_slots();
> +	mutex_unlock(&kprobe_insn_mutex);
>  }
>  #endif
> 
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
