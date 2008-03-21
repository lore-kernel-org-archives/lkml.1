Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbYCUKkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbYCUKkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 06:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYCUKkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 06:40:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59495 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbYCUKkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 06:40:01 -0400
Date: Fri, 21 Mar 2008 11:39:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 handle_vm86_trap cleanup
Message-ID: <20080321103946.GO20420@elte.hu>
References: <20080317092108.EC6C626F995@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080317092108.EC6C626F995@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Roland McGrath <roland@redhat.com> wrote:

> Use force_sig in handle_vm86_trap like other machine traps do.

thanks, applied.

> -	if (current->ptrace & PT_PTRACED) {
> -		unsigned long flags;
> -		spin_lock_irqsave(&current->sighand->siglock, flags);
> -		sigdelset(&current->blocked, SIGTRAP);
> -		recalc_sigpending();
> -		spin_unlock_irqrestore(&current->sighand->siglock, flags);
> -	}
> -	send_sig(SIGTRAP, current, 1);
>  	current->thread.trap_no = trapno;
>  	current->thread.error_code = error_code;
> +	force_sig(SIGTRAP, current);
>  	return 0;
>  }

for the record, this also changes semantics, because previously we'd 
permanently unblock SIGTRAP (most certainly as a hack, to be able to do 
the send_sig()), while now we use force_sig() which just ignores the 
blocked mask. (and i agree with your fix of course)

	Ingo
