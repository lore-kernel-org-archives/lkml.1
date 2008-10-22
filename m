Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYJVLQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYJVLQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYJVLQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:16:50 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59072 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbYJVLQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:16:50 -0400
Date: Wed, 22 Oct 2008 07:14:42 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       hpa@zytor.com, akpm@linux-foundation.org, ebiederm@xmission.com,
       tglx@linutronix.de
Subject: Re: [PATCH 4/7] x86, dumpstack: always call oops_exit from oops_end
Message-ID: <20081022111442.GE18951@hmsreliant.think-freely.org>
References: <1224669614-25863-1-git-send-email-heukelum@fastmail.fm> <1224669614-25863-2-git-send-email-heukelum@fastmail.fm> <1224669614-25863-3-git-send-email-heukelum@fastmail.fm> <1224669614-25863-4-git-send-email-heukelum@fastmail.fm> <1224669614-25863-5-git-send-email-heukelum@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224669614-25863-5-git-send-email-heukelum@fastmail.fm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 12:00:11PM +0200, Alexander van Heukelum wrote:
> Always call oops_exit from oops_end, even if signr==0.
> 
> Also, move add_taint(TAINT_DIE) from __die to oops_end
> on x86_64 and interchange two lines to make oops_end
> more similar to the i386-version.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>


Acked-by: Neil Horman <nhorman@tuxdriver.com>

> ---
>  arch/x86/kernel/dumpstack_32.c |    2 +-
>  arch/x86/kernel/dumpstack_64.c |   11 +++++------
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
> index 7c22f99..a29b88f 100644
> --- a/arch/x86/kernel/dumpstack_32.c
> +++ b/arch/x86/kernel/dumpstack_32.c
> @@ -318,6 +318,7 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
>  	__raw_spin_unlock(&die_lock);
>  	raw_local_irq_restore(flags);
>  
> +	oops_exit();
>  	if (!signr)
>  		return;
>  
> @@ -325,7 +326,6 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
>  		panic("Fatal exception in interrupt");
>  	if (panic_on_oops)
>  		panic("Fatal exception");
> -	oops_exit();
>  	do_exit(signr);
>  }
>  
> diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
> index 57ce11b..dc6162b 100644
> --- a/arch/x86/kernel/dumpstack_64.c
> +++ b/arch/x86/kernel/dumpstack_64.c
> @@ -461,22 +461,22 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
>  	if (regs && kexec_should_crash(current))
>  		crash_kexec(regs);
>  
> -	die_owner = -1;
>  	bust_spinlocks(0);
> +	die_owner = -1;
> +	add_taint(TAINT_DIE);
>  	die_nest_count--;
>  	if (!die_nest_count)
>  		/* Nest count reaches zero, release the lock. */
>  		__raw_spin_unlock(&die_lock);
>  	raw_local_irq_restore(flags);
> -	if (!signr) {
> -		oops_exit();
> +	oops_exit();
> +
> +	if (!signr)
>  		return;
> -	}
>  	if (in_interrupt())
>  		panic("Fatal exception in interrupt");
>  	if (panic_on_oops)
>  		panic("Fatal exception");
> -	oops_exit();
>  	do_exit(signr);
>  }
>  
> @@ -499,7 +499,6 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
>  		return 1;
>  
>  	show_registers(regs);
> -	add_taint(TAINT_DIE);
>  	/* Executive summary in case the oops scrolled away */
>  	printk(KERN_ALERT "RIP ");
>  	printk_address(regs->ip, 1);
> -- 
> 1.5.4.3
> 
> 

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
