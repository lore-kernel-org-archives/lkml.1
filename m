Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZCJOuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZCJOuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbZCJOuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:50:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50404 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbZCJOuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:50:02 -0400
Date: Tue, 10 Mar 2009 15:49:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: prasad@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 06/11] Use virtual debug registers in process/thread
	handling code
Message-ID: <20090310144933.GH3850@elte.hu>
References: <20090305043440.189041194@linux.vnet.ibm.com> <20090305044011.GG17747@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305044011.GG17747@in.ibm.com>
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


* prasad@linux.vnet.ibm.com <prasad@linux.vnet.ibm.com> wrote:

> @@ -437,16 +448,6 @@ __switch_to_xtra(struct task_struct *pre
>  	else if (next->debugctlmsr != prev->debugctlmsr)
>  		update_debugctlmsr(next->debugctlmsr);
>  
> -	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
> -		set_debugreg(next->debugreg0, 0);
> -		set_debugreg(next->debugreg1, 1);
> -		set_debugreg(next->debugreg2, 2);
> -		set_debugreg(next->debugreg3, 3);
> -		/* no 4 and 5 */
> -		set_debugreg(next->debugreg6, 6);
> -		set_debugreg(next->debugreg7, 7);
> -	}
> -
>  	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
>  	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
>  		/* prev and next are different */
> @@ -595,6 +596,12 @@ __switch_to(struct task_struct *prev_p, 
>  
>  	percpu_write(current_task, next_p);
>  
> +	/*
> +	 * Handle debug registers.  This must be done _after_ current
> +	 * is updated.
> +	 */
> +	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
> +		switch_to_thread_hw_breakpoint(next_p);

why does this have to be called after 'current' has been 
updated? AFAICS switch_to_thread_hw_breakpoint() does not take a 
look at 'current'.

Speaking of switch_to_thread_hw_breakpoint(), i dont like that 
function at all:

- why does it have to do a list of debug registers?

- why does it worry about IPIs arriving when context-switches on 
  x86 are always done with interrupts disabled?

- also, what do the ->installed() and ->uninstalled() callbacks 
  do - nothing uses it!

	Ingo
