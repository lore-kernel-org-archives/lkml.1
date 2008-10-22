Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbYJVKvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbYJVKvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYJVKvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:51:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33378 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbYJVKvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:51:15 -0400
Date: Wed, 22 Oct 2008 06:49:09 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       hpa@zytor.com, akpm@linux-foundation.org, ebiederm@xmission.com,
       tglx@linutronix.de
Subject: Re: [PATCH 1/7] i386, dumpstack: Move crash_kexec before
	bust_spinlocks(0) in oops_end
Message-ID: <20081022104909.GB18951@hmsreliant.think-freely.org>
References: <1224669614-25863-1-git-send-email-heukelum@fastmail.fm> <1224669614-25863-2-git-send-email-heukelum@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224669614-25863-2-git-send-email-heukelum@fastmail.fm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 12:00:08PM +0200, Alexander van Heukelum wrote:
> crash_kexec should not be called with console_sem held. Move
> the call before bust_spinlocks(0) in oops_end to avoid the
> problem.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> Cc: "Neil Horman" <nhorman@tuxdriver.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> ---
>  arch/x86/kernel/dumpstack_32.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
> index b361475..5493d31 100644
> --- a/arch/x86/kernel/dumpstack_32.c
> +++ b/arch/x86/kernel/dumpstack_32.c
> @@ -309,6 +309,9 @@ unsigned __kprobes long oops_begin(void)
>  
>  void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
>  {
> +	if (regs && kexec_should_crash(current))
> +		crash_kexec(regs);
> +
>  	bust_spinlocks(0);
>  	die_owner = -1;
>  	add_taint(TAINT_DIE);
> @@ -318,8 +321,6 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
>  	if (!regs)
>  		return;
>  
> -	if (kexec_should_crash(current))
> -		crash_kexec(regs);
>  	if (in_interrupt())
>  		panic("Fatal exception in interrupt");
>  	if (panic_on_oops)
> -- 
> 1.5.4.3
> 
> 

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
