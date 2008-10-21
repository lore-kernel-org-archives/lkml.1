Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbYJUPCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbYJUPCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 11:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYJUPCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 11:02:04 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48084 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYJUPCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 11:02:03 -0400
Date: Tue, 21 Oct 2008 10:59:54 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Ingo Molnar <mingo@elte.hu>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       ebiederm@xmission.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, akpm@linux-foundation.org,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] x86, dumpstack: make die and die_nmi equal
Message-ID: <20081021145954.GB25750@hmsreliant.think-freely.org>
References: <20081017210013.GD23591@hmsreliant.think-freely.org> <20081020121339.GE10594@elte.hu> <20081020134211.GA15574@hmsreliant.think-freely.org> <20081020150731.GA25999@mailshack.com> <20081020150834.GA26018@mailshack.com> <20081020151106.GA26034@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020151106.GA26034@mailshack.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 05:11:06PM +0200, Alexander van Heukelum wrote:
> Use the x86_64 version of die() and die_nmi() on i386 too.
> Changes to the original x86_64-version have no influence
> on the generated code:
> 
>  - whitespace, comments
>  - use user_mode_vm() instead of user_mode()
> 
Hey, smore more comments inline

> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> ---
>  arch/x86/kernel/dumpstack_32.c |   40 ++++++++++++++--------------------------
>  arch/x86/kernel/dumpstack_64.c |    9 +++++++--
>  2 files changed, 21 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
> index e45952b..6f00938 100644
> --- a/arch/x86/kernel/dumpstack_32.c
> +++ b/arch/x86/kernel/dumpstack_32.c
> @@ -377,52 +377,40 @@ void die(const char *str, struct pt_regs *regs, long err)
>  {
>  	unsigned long flags = oops_begin();
>  
> -	if (die_nest_count < 3) {
> +	if (!user_mode_vm(regs))
>  		report_bug(regs->ip, regs);
>  
> -		if (__die(str, regs, err))
> -			regs = NULL;
> -	} else {
> -		printk(KERN_EMERG "Recursive die() failure, output suppressed\n");
> -	}
> +	if (__die(str, regs, err))
> +		regs = NULL;
>  
>  	oops_end(flags, regs, SIGSEGV);
>  }
>  
> -static DEFINE_SPINLOCK(nmi_print_lock);
> -
>  void notrace __kprobes
>  die_nmi(char *str, struct pt_regs *regs, int do_panic)
>  {
> +	unsigned long flags;
> +
>  	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
>  		return;
>  
> -	spin_lock(&nmi_print_lock);
> +	flags = oops_begin();
>  	/*
>  	* We are in trouble anyway, lets at least try
> -	* to get a message out:
> +	* to get a message out.
>  	*/
> -	bust_spinlocks(1);
>  	printk(KERN_EMERG "%s", str);
>  	printk(" on CPU%d, ip %08lx, registers:\n",
>  		smp_processor_id(), regs->ip);
>  	show_registers(regs);
> -	if (do_panic)
> -		panic("Non maskable interrupt");
> -	console_silent();
> -	spin_unlock(&nmi_print_lock);
> -	bust_spinlocks(0);
> -
> -	/*
> -	 * If we are in kernel we are probably nested up pretty bad
> -	 * and might aswell get out now while we still can:
> -	 */
> -	if (!user_mode_vm(regs)) {
> -		current->thread.trap_no = 2;
> +	if (kexec_should_crash(current))
>  		crash_kexec(regs);
As I mentioned in your other patch, this crash_kexec can go I think if you're
going to do it in oops_end (as long as you correct the deadlock condition there

And as before, if you could rediff so that we didn't reintroduce the deadlock
that we just fixed, that would be much appreciated.

Beyond that, I think this looks good.  Fix that up and It'll have my ack.

Best
Neil

--
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
