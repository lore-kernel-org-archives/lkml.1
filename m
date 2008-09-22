Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYIVOyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYIVOyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYIVOye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:54:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55081 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbYIVOye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:54:34 -0400
Date: Mon, 22 Sep 2008 16:54:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-parisc@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH] Demultiplexing SIGTRAP signal
Message-ID: <20080922145404.GC27956@elte.hu>
References: <200809221602.32616.srinivasa@in.ibm.com> <20080922104202.GE30137@elte.hu> <200809221841.27993.srinivasa@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809221841.27993.srinivasa@in.ibm.com>
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

> --- linux-2.6.27-rc7.orig/arch/ia64/include/asm/siginfo.h
> +++ linux-2.6.27-rc7/arch/ia64/include/asm/siginfo.h

please do not send patches that modify include/asm/ files, the 
include/asm-x86/ file should be modified instead.

(this problem will go away in v2.6.28 when we'll move include/asm-x86/ 
to arch/x86/include/)

> +	si_code = get_si_code((unsigned long*)&condition);

coding style problem: please run checkpatch.

>  	/* Ok, finally something we can handle */
> -	send_sigtrap(tsk, regs, error_code);
> +	send_sigtrap(tsk, regs, error_code, si_code);

ok, that looks much nicer.

> -	info.si_code = TRAP_BRKPT;
> +	info.si_code = get_si_code(&condition);

no need to pass in the condition by reference.

> +#define TRAP_BRANCH     (__SI_FAULT|3)  /* process taken branch trap */
> +#define TRAP_HWBKPT     (__SI_FAULT|4)  /* hardware breakpoint or watchpoint 
> */

stray linewrapped patch line - see Documentation/email-clients.txt.

> -void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int 
> error_code)
> +void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int 
> error_code,

linewrap.

> +++ linux-2.6.27-rc7/include/asm-x86/traps.h
> @@ -36,6 +36,16 @@ void do_invalid_op(struct pt_regs *, lon
>  void do_general_protection(struct pt_regs *, long);
>  void do_nmi(struct pt_regs *, long);
>  
> +int get_si_code(unsigned long *condition)
> +{
> +	if (*condition & DR_STEP)
> +		return TRAP_TRACE;

please declare inline functions explicitly as 'static inline'.

	Ingo
