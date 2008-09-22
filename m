Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbYIVKm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbYIVKm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYIVKmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:42:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45848 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbYIVKmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:42:51 -0400
Date: Mon, 22 Sep 2008 12:42:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srinivasa Ds <srinivasa@in.ibm.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, paulus@samba.org,
       roland@redhat.com, linuxppc-dev@ozlabs.org,
       linux-parisc@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH] Demultiplexing SIGTRAP signal
Message-ID: <20080922104202.GE30137@elte.hu>
References: <200809221602.32616.srinivasa@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809221602.32616.srinivasa@in.ibm.com>
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


* Srinivasa Ds <srinivasa@in.ibm.com> wrote:

> Currently a SIGTRAP signal can denote any one of below reasons.
> 	- Breakpoint hit
> 	- H/W debug register hit
> 	- Single step
> 	- SIGTRAP signal sent through kill() or rasie()
> 
> Architectures like powerpc/parisc provides infrastructure to 
> demultiplex SIGTRAP signal by passing down the information for 
> receiving SIGTRAP through si_code of siginfot_t structure. Here is an 
> attempt is generalise this infrastructure by extending it to x86 and 
> x86_64 archs.

no fundamental objections - assuming existing x86 apps have not grown an 
ABI dependency on the existing send_sigtrap() semantics. (Debuggers and 
JITs would be a candidate for such dependencies.)

a small implementational detail, this bit:

> @@ -935,8 +936,22 @@ void __kprobes do_debug(struct pt_regs *
>  			goto clear_TF_reenable;
>  	}
>  
> -	/* Ok, finally something we can handle */
> -	send_sigtrap(tsk, regs, error_code);
> +	tsk->thread.trap_no = 1;
> +	tsk->thread.error_code = error_code;
> +
> +	memset(&info, 0, sizeof(info));
> +	info.si_signo = SIGTRAP;
> +	if (condition & DR_STEP)
> +		info.si_code = TRAP_TRACE;
> +	else if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))
> +		info.si_code = TRAP_HWBKPT;
> +	else
> +		info.si_code = TRAP_BRKPT;
> +	/* User-mode ip? */
> +	info.si_addr = user_mode_vm(regs) ? (void __user *) regs->ip : NULL;
> +
> +	/* Send us the fake SIGTRAP */
> +	force_sig_info(SIGTRAP, &info, tsk);

should be pushed into [a sufficiently extended] send_sigtrap() instead.

and this bit:

> -	info.si_code = TRAP_BRKPT;
> +	if (condition & DR_STEP)
> +		info.si_code = TRAP_TRACE;
> +	else if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))
> +		info.si_code = TRAP_HWBKPT;
> +	else
> +		info.si_code = TRAP_BRKPT;

should be separated into a helper function as well i guess.

Roland, any objections to the core idea (or to the implementation)?

	Ingo
