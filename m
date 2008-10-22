Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYJVLOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYJVLOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYJVLOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:14:01 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34270 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbYJVLOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:14:00 -0400
Date: Wed, 22 Oct 2008 07:11:54 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       hpa@zytor.com, akpm@linux-foundation.org, ebiederm@xmission.com,
       tglx@linutronix.de
Subject: Re: [PATCH 3/7] x86_64, dumpstack: move kexec_crash from __die to
	oops_end
Message-ID: <20081022111154.GD18951@hmsreliant.think-freely.org>
References: <1224669614-25863-1-git-send-email-heukelum@fastmail.fm> <1224669614-25863-2-git-send-email-heukelum@fastmail.fm> <1224669614-25863-3-git-send-email-heukelum@fastmail.fm> <1224669614-25863-4-git-send-email-heukelum@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224669614-25863-4-git-send-email-heukelum@fastmail.fm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 12:00:10PM +0200, Alexander van Heukelum wrote:
> oops_end is preceded by either a call to __die, or a conditional
> call to crash_kexec. Move the conditional call to crash_kexec
> from the end of __die to the start of oops_end and remove
> the superfluous call to crash_kexec in die_nmi.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

Acked-by: Neil Horman <nhorman@tuxdriver.com>

> ---
>  arch/x86/kernel/dumpstack_64.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
> index ffefea6..57ce11b 100644
> --- a/arch/x86/kernel/dumpstack_64.c
> +++ b/arch/x86/kernel/dumpstack_64.c
> @@ -458,6 +458,9 @@ unsigned __kprobes long oops_begin(void)
>  
>  void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
>  {
> +	if (regs && kexec_should_crash(current))
> +		crash_kexec(regs);
> +
>  	die_owner = -1;
>  	bust_spinlocks(0);
>  	die_nest_count--;
> @@ -501,8 +504,6 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
>  	printk(KERN_ALERT "RIP ");
>  	printk_address(regs->ip, 1);
>  	printk(" RSP <%016lx>\n", regs->sp);
> -	if (kexec_should_crash(current))
> -		crash_kexec(regs);
>  	return 0;
>  }
>  
> @@ -536,11 +537,9 @@ die_nmi(char *str, struct pt_regs *regs, int do_panic)
>  	printk(" on CPU%d, ip %08lx, registers:\n",
>  		smp_processor_id(), regs->ip);
>  	show_registers(regs);
> -	if (kexec_should_crash(current))
> -		crash_kexec(regs);
> +	oops_end(flags, regs, 0);
>  	if (do_panic || panic_on_oops)
>  		panic("Non maskable interrupt");
> -	oops_end(flags, regs, 0);
>  	nmi_exit();
>  	local_irq_enable();
>  	do_exit(SIGBUS);
> -- 
> 1.5.4.3
> 
> 

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
