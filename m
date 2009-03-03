Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZCCJ25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZCCJ25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 04:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbZCCJ2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 04:28:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45774 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbZCCJ2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 04:28:47 -0500
Date: Tue, 3 Mar 2009 10:27:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] Text Edit Lock - kprobes architecture independent
	support (v2)
Message-ID: <20090303092750.GG11484@elte.hu>
References: <20090302171914.GB21735@Krystal> <49AC5A87.7000604@redhat.com> <20090302222254.GA31962@elte.hu> <49AC63FA.70801@redhat.com> <20090302230915.GA11626@elte.hu> <49AC6DEA.2050304@redhat.com> <20090302234910.GA17956@elte.hu> <20090303000054.GC3906@Krystal> <20090303003237.GA30221@elte.hu> <20090303013124.GB7783@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303013124.GB7783@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> @@ -709,7 +711,8 @@ int __kprobes register_kprobe(struct kpr
>  
>  	if (kprobe_enabled)
>  		arch_arm_kprobe(p);

hm, it's cleaner now, but there's serious locking dependency 
problems visible in the patch:

> -
> +out_unlock_text:
> +	mutex_unlock(&text_mutex);
>  out:
>  	mutex_unlock(&kprobe_mutex);

this one creates a (text_mutex -> kprobe_mutex) dependency. 
(also you removed a newline spuriously - dont do that)

> @@ -746,8 +749,11 @@ valid_p:
>  		 * enabled and not gone - otherwise, the breakpoint would
>  		 * already have been removed. We save on flushing icache.
>  		 */
> -		if (kprobe_enabled && !kprobe_gone(old_p))
> +		if (kprobe_enabled && !kprobe_gone(old_p)) {
> +			mutex_lock(&text_mutex);
>  			arch_disarm_kprobe(p);
> +			mutex_unlock(&text_mutex);
> +		}
>  		hlist_del_rcu(&old_p->hlist);

(kprobe_mutex -> text_mutex) dependency. AB-BA deadlock.

>  	} else {
>  		if (p->break_handler && !kprobe_gone(p))
> @@ -918,7 +924,6 @@ static int __kprobes pre_handler_kretpro
>  		}
>  
>  		arch_prepare_kretprobe(ri, regs);
> -

spurious (and wrong) newline removal.

>  		/* XXX(hch): why is there no hlist_move_head? */
>  		INIT_HLIST_NODE(&ri->hlist);
>  		kretprobe_table_lock(hash, &flags);
> @@ -1280,12 +1285,14 @@ static void __kprobes enable_all_kprobes
>  	if (kprobe_enabled)
>  		goto already_enabled;
>  
> +	mutex_lock(&text_mutex);
>  	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
>  		head = &kprobe_table[i];
>  		hlist_for_each_entry_rcu(p, node, head, hlist)
>  			if (!kprobe_gone(p))
>  				arch_arm_kprobe(p);
>  	}
> +	mutex_unlock(&text_mutex);

this one creates a (kprobe_mutex -> text_mutex) dependency 
again.

> @@ -1310,6 +1317,7 @@ static void __kprobes disable_all_kprobe
>  
>  	kprobe_enabled = false;
>  	printk(KERN_INFO "Kprobes globally disabled\n");
> +	mutex_lock(&text_mutex);
>  	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
>  		head = &kprobe_table[i];
>  		hlist_for_each_entry_rcu(p, node, head, hlist) {
> @@ -1317,7 +1325,7 @@ static void __kprobes disable_all_kprobe
>  				arch_disarm_kprobe(p);
>  		}
>  	}
> -
> +	mutex_unlock(&text_mutex);
>  	mutex_unlock(&kprobe_mutex);

And this one in the reverse direction again.

The dependencies are totally wrong. The text lock (a low level 
lock) should nest inside the kprobes mutex (which is the higher 
level lock).

Have you reviewed the locking dependencies when writing this 
patch, at all? That's one of the first things to do when adding 
a new lock.

	Ingo
