Return-Path: <linux-kernel-owner+w=401wt.eu-S1758505AbXKQKRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505AbXKQKRo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 05:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbXKQKRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 05:17:36 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:53799 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbXKQKRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 05:17:35 -0500
Message-ID: <473EBFBA.7080705@tiscali.nl>
Date: Sat, 17 Nov 2007 11:17:30 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: linux-kernel@vger.kernel.org,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: Re: [rfc-patch 07/11] Text Edit Lock - kprobes architecture independent
 support
References: <20071116195747.448703304@polymtl.ca> <20071116200139.134470826@polymtl.ca>
In-Reply-To: <20071116200139.134470826@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Use the mutual exclusion provided by the text edit lock in the kprobes code. It
> allows coherent manipulation of the kernel code by other subsystems.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> CC: prasanna@in.ibm.com
> CC: ananth@in.ibm.com
> CC: anil.s.keshavamurthy@intel.com
> CC: davem@davemloft.net
> ---
>  kernel/kprobes.c |   19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6-lttng/kernel/kprobes.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/kprobes.c	2007-09-07 10:12:06.000000000 -0400
> +++ linux-2.6-lttng/kernel/kprobes.c	2007-09-07 10:13:09.000000000 -0400
> @@ -43,6 +43,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/debugfs.h>
>  #include <linux/kdebug.h>
> +#include <linux/memory.h>
>  
>  #include <asm-generic/sections.h>
>  #include <asm/cacheflush.h>
> @@ -568,9 +569,10 @@ static int __kprobes __register_kprobe(s
>  		goto out;
>  	}
>  
> +	kernel_text_lock();
>  	ret = arch_prepare_kprobe(p);
>  	if (ret)
> -		goto out;
> +		goto out_unlock_text;
>  
>  	INIT_HLIST_NODE(&p->hlist);
>  	hlist_add_head_rcu(&p->hlist,
> @@ -578,7 +580,8 @@ static int __kprobes __register_kprobe(s
>  
>  	if (kprobe_enabled)
>  		arch_arm_kprobe(p);
> -
> +out_unlock_text:
> +	kernel_text_unlock();
>  out:
>  	mutex_unlock(&kprobe_mutex);
>  
> @@ -621,8 +624,11 @@ valid_p:
>  		 * enabled - otherwise, the breakpoint would already have
>  		 * been removed. We save on flushing icache.
>  		 */
> -		if (kprobe_enabled)
> +		if (kprobe_enabled) {
> +			kernel_text_lock();
>  			arch_disarm_kprobe(p);
> +			kernel_text_unlock();
> +		}
>  		hlist_del_rcu(&old_p->hlist);
>  		cleanup_p = 1;
>  	} else {
> @@ -644,9 +650,7 @@ valid_p:
>  			list_del_rcu(&p->list);
>  			kfree(old_p);
>  		}
> -		mutex_lock(&kprobe_mutex);
>  		arch_remove_kprobe(p);
> -		mutex_unlock(&kprobe_mutex);
>  	} else {
>  		mutex_lock(&kprobe_mutex);
>  		if (p->break_handler)
> @@ -717,7 +721,6 @@ static int __kprobes pre_handler_kretpro
>  		ri->rp = rp;
>  		ri->task = current;
>  		arch_prepare_kretprobe(ri, regs);
> -
>  		/* XXX(hch): why is there no hlist_move_head? */
>  		hlist_del(&ri->uflist);
>  		hlist_add_head(&ri->uflist, &ri->rp->used_instances);
> @@ -940,8 +943,10 @@ static void __kprobes enable_all_kprobes
>  
>  	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
>  		head = &kprobe_table[i];
> +		kernel_text_lock();
>  		hlist_for_each_entry_rcu(p, node, head, hlist)
>  			arch_arm_kprobe(p);
> +		kernel_text_unlock();
>  	}

isn't it better to put the kernel_text_lock around the for loop?

>  
>  	kprobe_enabled = true;
> @@ -969,10 +974,12 @@ static void __kprobes disable_all_kprobe
>  	printk(KERN_INFO "Kprobes globally disabled\n");
>  	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
>  		head = &kprobe_table[i];
> +		kernel_text_lock();
>  		hlist_for_each_entry_rcu(p, node, head, hlist) {
>  			if (!arch_trampoline_kprobe(p))
>  				arch_disarm_kprobe(p);
>  		}
> +		kernel_text_unlock();
>  	}

same question here

>  
>  	mutex_unlock(&kprobe_mutex);
> 

