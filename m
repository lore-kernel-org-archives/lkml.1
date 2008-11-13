Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbYKMHle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbYKMHle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 02:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYKMHlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 02:41:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46872 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbYKMHlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 02:41:25 -0500
Date: Thu, 13 Nov 2008 08:41:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] x86: optimise page fault path a little
Message-ID: <20081113074109.GB1723@elte.hu>
References: <20081113072821.GB2946@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113072821.GB2946@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> Hi,
> 
> I was just looking around the page fault code for any obvious 
> performance improvements. I noticed do_page_fault is rather big, 
> uses a lot of stack, and generates some branch mispredicts.
> 
> It's only about 1.1% on the profile of the workload I'm looking at, 
> so my improvement is pretty close to in the noise, but I wonder if 
> micro optimisations like the following would be welcome?

it's definitely welcome!

> This patch adds branch hints and moves error condition code out of 
> line. It shrinks do_page_fault from 2410 bytes to 603 bytes, and 
> from 352 to 64 bytes of stack. Total text size does grow by about 
> 500 bytes due to the additional functions added.

Some small cleanliness nits:

> +/* TODO: match order of arguments */

please fix TODO ;)

> +static noinline void no_context(struct pt_regs *regs,
> +			unsigned long error_code, unsigned long address)
> +{
> +	struct task_struct *tsk = current;
> +#ifdef CONFIG_X86_64
> +	unsigned long flags;
> +#endif

we should just do this unconditionally on 32-bit too.

> +	/*
> +	 * Oops. The kernel tried to access some bad page. We'll have to
> +	 * terminate things with extreme prejudice.
> +	 */
> +#ifdef CONFIG_X86_32
> +	bust_spinlocks(1);
> +#else
> +	flags = oops_begin();
> +#endif

32-bit should use oops_begin() too. Solves the previous comment as 
well.

> +#ifdef CONFIG_X86_32
> +	die("Oops", regs, error_code);
> +	bust_spinlocks(0);
> +	do_exit(SIGKILL);
> +#else
> +	if (__die("Oops", regs, error_code))
> +		regs = NULL;
> +	/* Executive summary in case the body of the oops scrolled away */
> +	printk(KERN_EMERG "CR2: %016lx\n", address);
> +	oops_end(flags, regs, SIGKILL);
> +#endif

this difference seems unnecessary too - 32-bit should use oops_end() 
too.

> +/* TODO: fixup for oom handling */

please fix todo ;-)

this flow could be cleaned up further:

[...]
> +		bad_area(regs, error_code, address);
> +		return;
[...]
> +		bad_area(regs, error_code, address);
> +		return;
[...]
> +			bad_area(regs, error_code, address);
> +			return;
[...]
> +		bad_area(regs, error_code, address);
> +		return;

Any reason why that pattern shouldnt be changed to an appropriate goto 
bad_area? (probably the same goes for the nosemaphore error paths too)

	Ingo
