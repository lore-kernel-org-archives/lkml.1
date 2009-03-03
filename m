Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbZCCALU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbZCCALU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbZCCALM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:11:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50258 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbZCCALL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:11:11 -0500
Message-ID: <49AC7571.7090908@redhat.com>
Date: Mon, 02 Mar 2009 19:10:25 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] Text Edit Lock - kprobes architecture independent support
References: <20090227185316.GA19811@Krystal> <49A853CD.3020607@redhat.com> <49AC10E9.1090102@redhat.com> <20090302171914.GB21735@Krystal> <49AC5A87.7000604@redhat.com> <20090302222254.GA31962@elte.hu> <49AC63FA.70801@redhat.com> <20090302230915.GA11626@elte.hu> <49AC6DEA.2050304@redhat.com> <20090302234910.GA17956@elte.hu> <20090303000151.GD3906@Krystal>
In-Reply-To: <20090303000151.GD3906@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Use the mutual exclusion provided by the text edit lock in the kprobes code. It
> allows coherent manipulation of the kernel code by other subsystems.

Oh, I see what you said...
This seems really useful.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> 
> Changelog:
> 
> Move the kernel_text_lock/unlock out of the for loops.
> 
> (applies on 2.6.29-rc6)
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> CC: ananth@in.ibm.com
> CC: anil.s.keshavamurthy@intel.com
> CC: davem@davemloft.net
> CC: Roel Kluin <12o3l@tiscali.nl>
> ---
>  kernel/kprobes.c |   17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6-lttng/kernel/kprobes.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/kprobes.c	2009-01-30 10:24:45.000000000 -0500
> +++ linux-2.6-lttng/kernel/kprobes.c	2009-01-30 10:27:56.000000000 -0500
> @@ -43,6 +43,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/debugfs.h>
>  #include <linux/kdebug.h>
> +#include <linux/memory.h>
>  
>  #include <asm-generic/sections.h>
>  #include <asm/cacheflush.h>
> @@ -699,9 +700,10 @@ int __kprobes register_kprobe(struct kpr
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
> @@ -709,7 +711,8 @@ int __kprobes register_kprobe(struct kpr
>  
>  	if (kprobe_enabled)
>  		arch_arm_kprobe(p);
> -
> +out_unlock_text:
> +	kernel_text_unlock();
>  out:
>  	mutex_unlock(&kprobe_mutex);
>  
> @@ -746,8 +749,11 @@ valid_p:
>  		 * enabled and not gone - otherwise, the breakpoint would
>  		 * already have been removed. We save on flushing icache.
>  		 */
> -		if (kprobe_enabled && !kprobe_gone(old_p))
> +		if (kprobe_enabled && !kprobe_gone(old_p)) {
> +			kernel_text_lock();
>  			arch_disarm_kprobe(p);
> +			kernel_text_unlock();
> +		}
>  		hlist_del_rcu(&old_p->hlist);
>  	} else {
>  		if (p->break_handler && !kprobe_gone(p))
> @@ -918,7 +924,6 @@ static int __kprobes pre_handler_kretpro
>  		}
>  
>  		arch_prepare_kretprobe(ri, regs);
> -
>  		/* XXX(hch): why is there no hlist_move_head? */
>  		INIT_HLIST_NODE(&ri->hlist);
>  		kretprobe_table_lock(hash, &flags);
> @@ -1280,12 +1285,14 @@ static void __kprobes enable_all_kprobes
>  	if (kprobe_enabled)
>  		goto already_enabled;
>  
> +	kernel_text_lock();
>  	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
>  		head = &kprobe_table[i];
>  		hlist_for_each_entry_rcu(p, node, head, hlist)
>  			if (!kprobe_gone(p))
>  				arch_arm_kprobe(p);
>  	}
> +	kernel_text_unlock();
>  
>  	kprobe_enabled = true;
>  	printk(KERN_INFO "Kprobes globally enabled\n");
> @@ -1310,6 +1317,7 @@ static void __kprobes disable_all_kprobe
>  
>  	kprobe_enabled = false;
>  	printk(KERN_INFO "Kprobes globally disabled\n");
> +	kernel_text_lock();
>  	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
>  		head = &kprobe_table[i];
>  		hlist_for_each_entry_rcu(p, node, head, hlist) {
> @@ -1317,6 +1325,7 @@ static void __kprobes disable_all_kprobe
>  				arch_disarm_kprobe(p);
>  		}
>  	}
> +	kernel_text_unlock();
>  
>  	mutex_unlock(&kprobe_mutex);
>  	/* Allow all currently running kprobes to complete */

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

