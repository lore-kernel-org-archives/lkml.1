Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbXKAEvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbXKAEvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 00:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbXKAEu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 00:50:56 -0400
Received: from gw.goop.org ([64.81.55.164]:56098 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbXKAEuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 00:50:55 -0400
Message-ID: <47295B2A.3080200@goop.org>
Date: Wed, 31 Oct 2007 21:50:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com, tglx@linutronix.de,
       jun.nakajima@intel.com, glommer@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 11/16] turn priviled operation into a macro in head_64.S
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com> <1193858118284-git-send-email-gcosta@redhat.com> <11938581242810-git-send-email-gcosta@redhat.com> <1193858130443-git-send-email-gcosta@redhat.com> <11938581351064-git-send-email-gcosta@redhat.com> <11938581403478-git-send-email-gcosta@redhat.com> <11938581451804-git-send-email-gcosta@redhat.com> <11938581512730-git-send-email-gcosta@redhat.com> <11938581562552-git-send-email-gcosta@redhat.com> <11938581612389-git-send-email-gcosta@redhat.com>
In-Reply-To: <11938581612389-git-send-email-gcosta@redhat.com>
X-Enigmail-Version: 0.95.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> under paravirt, read cr2 cannot be issued directly anymore.
> So wrap it in a macro, defined to the operation itself in case
> paravirt is off, but to something else if we have paravirt
> in the game
>   

Is this actually needed?  It's only used in the early fault handler in
head_64.S.  Will we be taking that path in the paravirt case?  If so,
should we disable the fault handler altogether, since the hypervisor can
probably provide better diagnositcs.

    J
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> ---
>  arch/x86/kernel/head_64.S |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index b6167fe..c31b1c9 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -19,6 +19,13 @@
>  #include <asm/msr.h>
>  #include <asm/cache.h>
>  
> +#ifdef CONFIG_PARAVIRT
> +#include <asm/asm-offsets.h>
> +#include <asm/paravirt.h>
> +#else
> +#define GET_CR2_INTO_RCX movq %cr2, %rcx
> +#endif
> +
>  /* we are not able to switch in one step to the final KERNEL ADRESS SPACE
>   * because we need identity-mapped pages.
>   *
> @@ -267,7 +274,7 @@ ENTRY(early_idt_handler)
>  	xorl %eax,%eax
>  	movq 8(%rsp),%rsi	# get rip
>  	movq (%rsp),%rdx
> -	movq %cr2,%rcx
> +	GET_CR2_INTO_RCX
>  	leaq early_idt_msg(%rip),%rdi
>  	call early_printk
>  	cmpl $2,early_recursion_flag(%rip)
>   

