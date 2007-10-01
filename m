Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbXJAG2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbXJAG2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 02:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbXJAG2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 02:28:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48253 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbXJAG2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 02:28:38 -0400
Date: Mon, 1 Oct 2007 08:28:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, satyam@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: + sched-use-show_regs-to-improve-__schedule_bug-output.patch
	added to -mm tree
Message-ID: <20071001062819.GA2914@elte.hu>
References: <200709130749.l8D7nJYX008415@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709130749.l8D7nJYX008415@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> The patch titled
>      sched: Use show_regs() to improve __schedule_bug() output
> has been added to the -mm tree.  Its filename is
>      sched-use-show_regs-to-improve-__schedule_bug-output.patch
[...]
>   */
>  static noinline void __schedule_bug(struct task_struct *prev)
>  {
> -	printk(KERN_ERR "BUG: scheduling while atomic: %s/0x%08x/%d\n",
> -		prev->comm, preempt_count(), prev->pid);
> +	struct pt_regs *regs = get_irq_regs();
> +
> +	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
> +		prev->comm, prev->pid, preempt_count());
> +
>  	debug_show_held_locks(prev);
>  	if (irqs_disabled())
>  		print_irqtrace_events(prev);
> -	dump_stack();
> +
> +	if (regs)
> +		show_regs(regs);
> +	else
> +		dump_stack();

the principle looks good to me, but please implement this a bit 
differently: make show_regs(NULL) fall back to dump_stack() (on all 
architectures) and thus reduce the size of the scheduler (and other code 
i guess).

	Ingo
