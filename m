Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZCLKyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZCLKyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbZCLKx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:53:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59915 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbZCLKx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:53:56 -0400
Date: Thu, 12 Mar 2009 11:53:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] x86-64: add unwind annotations to early_idt_handler
Message-ID: <20090312105345.GB30204@elte.hu>
References: <49B8F3A2.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B8F3A2.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> 
> ---
>  arch/x86/kernel/head_64.S |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> --- linux-2.6.29-rc7/arch/x86/kernel/head_64.S	2009-03-11 17:52:10.000000000 +0100
> +++ 2.6.29-rc7-x86_64-unwind-early_idt_handler/arch/x86/kernel/head_64.S	2009-02-18 13:38:09.000000000 +0100
> @@ -280,6 +280,8 @@ early_idt_handlers:
>  
>  ENTRY(early_idt_handler)
>  #ifdef CONFIG_EARLY_PRINTK
> +#include <asm/calling.h>
> +#include <asm/dwarf2.h>
>  	cmpl $2,early_recursion_flag(%rip)
>  	jz  1f
>  	incl early_recursion_flag(%rip)
> @@ -295,6 +297,16 @@ ENTRY(early_idt_handler)
>  	testl $0x27d00,%eax
>  	je 0f
>  	popq %r8		# get error code
> +
> +	CFI_STARTPROC	simple
> +	CFI_SIGNAL_FRAME
> +	CFI_DEF_CFA	rsp, SS+8-RIP
> +#	CFI_REL_OFFSET	ss, SS-RIP
> +	CFI_REL_OFFSET	rsp, RSP-RIP
> +#	CFI_REL_OFFSET	rflags, EFLAGS-RIP
> +#	CFI_REL_OFFSET	cs, CS-RIP
> +	CFI_REL_OFFSET	rip, RIP-RIP
> +

This too is too ugly - there should be a structured macro that 
expresses this - instead of open-coded CFI details. This is a 
regular x86 entry layout with a lot of commonalities with other 
entry points.

	Ingo
