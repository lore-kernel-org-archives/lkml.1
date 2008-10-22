Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYJVMin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYJVMin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 08:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYJVMid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 08:38:33 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56989 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbYJVMic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 08:38:32 -0400
Date: Wed, 22 Oct 2008 08:36:20 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       hpa@zytor.com, akpm@linux-foundation.org, ebiederm@xmission.com,
       tglx@linutronix.de
Subject: Re: [PATCH 6/7] i386, dumpstack: use oops_begin/oops_end in die_nmi
Message-ID: <20081022123620.GG18951@hmsreliant.think-freely.org>
References: <1224669614-25863-1-git-send-email-heukelum@fastmail.fm> <1224669614-25863-2-git-send-email-heukelum@fastmail.fm> <1224669614-25863-3-git-send-email-heukelum@fastmail.fm> <1224669614-25863-4-git-send-email-heukelum@fastmail.fm> <1224669614-25863-5-git-send-email-heukelum@fastmail.fm> <1224669614-25863-6-git-send-email-heukelum@fastmail.fm> <1224669614-25863-7-git-send-email-heukelum@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224669614-25863-7-git-send-email-heukelum@fastmail.fm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 12:00:13PM +0200, Alexander van Heukelum wrote:
> Use oops_begin and oops_end in die_nmi.
> 
> Whitespace-only changes on x86_64, to make it equal to i386's
> version.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

Acked-by: Neil Horman <nhorman@tuxdriver.com>

> ---
>  arch/x86/kernel/dumpstack_32.c |   33 +++++++++++----------------------
>  arch/x86/kernel/dumpstack_64.c |    4 ++--
>  2 files changed, 13 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
> index 7c7d691..e91ae34 100644
> --- a/arch/x86/kernel/dumpstack_32.c
> +++ b/arch/x86/kernel/dumpstack_32.c
> @@ -390,40 +390,29 @@ void die(const char *str, struct pt_regs *regs, long err)
>  	oops_end(flags, regs, sig);
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
>  	/*
> -	* We are in trouble anyway, lets at least try
> -	* to get a message out:
> -	*/
> -	bust_spinlocks(1);
> +	 * We are in trouble anyway, lets at least try
> +	 * to get a message out.
> +	 */
> +	flags = oops_begin();
>  	printk(KERN_EMERG "%s", str);
>  	printk(" on CPU%d, ip %08lx, registers:\n",
>  		smp_processor_id(), regs->ip);
>  	show_registers(regs);
> -	if (do_panic)
> +	oops_end(flags, regs, 0);
> +	if (do_panic || panic_on_oops)
>  		panic("Non maskable interrupt");
> -	console_silent();
> -	spin_unlock(&nmi_print_lock);
> -
> -	/*
> -	 * If we are in kernel we are probably nested up pretty bad
> -	 * and might aswell get out now while we still can:
> -	 */
> -	if (!user_mode_vm(regs)) {
> -		current->thread.trap_no = 2;
> -		crash_kexec(regs);
> -	}
> -
> -	bust_spinlocks(0);
> -	do_exit(SIGSEGV);
> +	nmi_exit();
> +	local_irq_enable();
> +	do_exit(SIGBUS);
>  }
>  
>  static int __init oops_setup(char *s)
> diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
> index dc6162b..831e1e1 100644
> --- a/arch/x86/kernel/dumpstack_64.c
> +++ b/arch/x86/kernel/dumpstack_64.c
> @@ -519,7 +519,7 @@ void die(const char *str, struct pt_regs *regs, long err)
>  	oops_end(flags, regs, sig);
>  }
>  
> -notrace __kprobes void
> +void notrace __kprobes
>  die_nmi(char *str, struct pt_regs *regs, int do_panic)
>  {
>  	unsigned long flags;
> @@ -527,11 +527,11 @@ die_nmi(char *str, struct pt_regs *regs, int do_panic)
>  	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
>  		return;
>  
> -	flags = oops_begin();
>  	/*
>  	 * We are in trouble anyway, lets at least try
>  	 * to get a message out.
>  	 */
> +	flags = oops_begin();
>  	printk(KERN_EMERG "%s", str);
>  	printk(" on CPU%d, ip %08lx, registers:\n",
>  		smp_processor_id(), regs->ip);
> -- 
> 1.5.4.3
> 
> 

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
