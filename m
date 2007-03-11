Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbXCKNEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbXCKNEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 09:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbXCKNEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 09:04:11 -0400
Received: from il.qumranet.com ([82.166.9.18]:54886 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbXCKNEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 09:04:10 -0400
Message-ID: <45F3FE48.2040808@qumranet.com>
Date: Sun, 11 Mar 2007 15:04:08 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org
Subject: Re: [patch] KVM: always reload segment selectors
References: <20070311122441.GA10774@elte.hu> <45F3F85D.7000509@qumranet.com> <20070311124146.GA15115@elte.hu> <20070311125233.GA17328@elte.hu>
In-Reply-To: <20070311125233.GA17328@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Subject: [patch] KVM: always reload segment selectors
> From: Ingo Molnar <mingo@elte.hu>
>
> failed VM entry on VMX might still change %fs or %gs, thus make sure 
> that KVM always reloads the segment selectors. This is crutial on both 
> x86 and x86_64: x86 has __KERNEL_PDA in %fs on which things like 
> 'current' depends and x86_64 has 0 there and needs MSR_GS_BASE to work.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/kvm/vmx.c |   37 +++++++++++++++++++++----------------
>  1 file changed, 21 insertions(+), 16 deletions(-)
>
> Index: linux/drivers/kvm/vmx.c
> ===================================================================
> --- linux.orig/drivers/kvm/vmx.c
> +++ linux/drivers/kvm/vmx.c
> @@ -1896,6 +1896,27 @@ again:
>  		[cr2]"i"(offsetof(struct kvm_vcpu, cr2))
>  	      : "cc", "memory" );
>  
> +	/*
> +	 * Reload segment selectors ASAP. (it's needed for a functional
> +	 * kernel: x86 relies on having __KERNEL_PDA in %fs and x86_64
> +	 * relies on having 0 in %gs for the CPU PDA to work.)
> +	 */
> +	if (fs_gs_ldt_reload_needed) {
> +		load_ldt(ldt_sel);
> +		load_fs(fs_sel);
> +		/*
> +		 * If we have to reload gs, we must take care to
> +		 * preserve our gs base.
> +		 */
> +		local_irq_disable();
> +		load_gs(gs_sel);
> +#ifdef CONFIG_X86_64
> +		wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
> +#endif
> +		local_irq_enable();
> +
> +		reload_tss();
> +	}
>  	++kvm_stat.exits;
>  
>  	save_msrs(vcpu->guest_msrs, NR_BAD_MSRS);

btw, looking at the code, we could just remove fs from the 
fs_gs_reload_needed and make in unconditional.  VT knows how to reload 
segments, except if they're user segments (groan).  In the case of fs, 
if it's used for the pda, it's obviously a kernel segment.

gs is different: since only the segment base is loaded (via swapgs), the 
selector part could well be a userspace selector, and thus the 
irq-protected reload is needed.

Anyway, I'm applying the patch as the above discourse is irrelevant to 
the fix.


-- 
error compiling committee.c: too many arguments to function

