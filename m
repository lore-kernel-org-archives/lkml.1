Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbZBOLkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbZBOLkM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 06:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZBOLj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 06:39:57 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56737 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168AbZBOLj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 06:39:57 -0500
Message-Id: <1234697995.25435.1300454125@webmail.messagingengine.com>
X-Sasl-Enc: 7tS+qSII6shdKKa39BPnFImShNiFdataJ4kyc12NZ+le 1234697995
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
       "Alexander van Heukelum" <heukelum@fastmail.fm>,
       "Thomas Gleixner" <tglx@linutronix.de>, rjw@sisk.pl,
       hramrach@centrum.cz, linux-kernel@vger.kernel.org,
       linux-tip-commits@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
       "Thomas Gleixner" <tglx@linutronix.de>, rjw@sisk.pl,
       hramrach@centrum.cz
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <tip-589de987dd2997eab59cbbccc1c9fc46c90ae5e8@kernel.org>
Subject: Re: [tip:x86/urgent] x86: vm86: fix preemption bug
In-Reply-To: <tip-589de987dd2997eab59cbbccc1c9fc46c90ae5e8@kernel.org>
Date: Sun, 15 Feb 2009 12:39:55 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Feb 2009 09:36:26 GMT, "Thomas Gleixner" <tglx@linutronix.de>
said:
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Tue, 13 Jan 2009 23:36:34 +0100
> Commit:     Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Sun, 15 Feb 2009 10:34:17 +0100
> 
> x86: vm86: fix preemption bug
> 
> commit 3d2a71a596bd9c761c8487a2178e95f8a61da083 (x86, traps: converge
> do_debug handlers) changed the preemption disable logic of do_debug()
> so vm86_handle_trap() is called with preemption disabled resulting in:
> 
> BUG: sleeping function called from invalid context at
> include/linux/kernel.h:155
> in_atomic(): 1, irqs_disabled(): 0, pid: 3005, name: dosemu.bin
> Pid: 3005, comm: dosemu.bin Tainted: G        W  2.6.29-rc1 #51
> Call Trace:
>  [<c050d669>] copy_to_user+0x33/0x108
>  [<c04181f4>] save_v86_state+0x65/0x149
>  [<c0418531>] handle_vm86_trap+0x20/0x8f
>  [<c064e345>] do_debug+0x15b/0x1a4
>  [<c064df1f>] debug_stack_correct+0x27/0x2c
>  [<c040365b>] sysenter_do_call+0x12/0x2f
> BUG: scheduling while atomic: dosemu.bin/3005/0x10000001
> 
> Restore the original calling convention and reenable preemption before
> calling handle_vm86_trap().
> 
> Reported-by: Michal Suchanek <hramrach@centrum.cz>
> Cc: stable@kernel.org
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Alexander van Heukelum <heukelum@fastmail.fm>

I have no objections.

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

Greetings,
    Alexander
 
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> ---
>  arch/x86/kernel/traps.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 7932338..a9e7548 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -99,6 +99,12 @@ static inline void preempt_conditional_sti(struct
> pt_regs *regs)
>  		local_irq_enable();
>  }
>  
> +static inline void conditional_cli(struct pt_regs *regs)
> +{
> +	if (regs->flags & X86_EFLAGS_IF)
> +		local_irq_disable();
> +}
> +
>  static inline void preempt_conditional_cli(struct pt_regs *regs)
>  {
>  	if (regs->flags & X86_EFLAGS_IF)
> @@ -626,8 +632,10 @@ clear_dr7:
>  
>  #ifdef CONFIG_X86_32
>  debug_vm86:
> +	/* reenable preemption: handle_vm86_trap() might sleep */
> +	dec_preempt_count();
>  	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
> -	preempt_conditional_cli(regs);
> +	conditional_cli(regs);
>  	return;
>  #endif
>  
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - One of many happy users:
  http://www.fastmail.fm/docs/quotes.html

