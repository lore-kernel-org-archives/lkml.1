Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZEJNLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZEJNLB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 09:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbZEJNKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 09:10:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34581 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbZEJNKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 09:10:49 -0400
Message-ID: <4A06D21C.2060008@redhat.com>
Date: Sun, 10 May 2009 16:09:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 2/2] deal with interrupt shadow state for emulated instruction
References: <1241814187-5973-1-git-send-email-glommer@redhat.com> <1241814187-5973-2-git-send-email-glommer@redhat.com> <1241814187-5973-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1241814187-5973-3-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> we currently unblock shadow interrupt state when we skip an instruction,
> but failing to do so when we actually emulate one. This blocks interrupts
> in key instruction blocks, in particular sti; hlt; sequences
>
> If the instruction emulated is an sti, we have to block shadow interrupts.
> The same goes for mov ss. pop ss also needs it, but we don't currently
> emulate it.
>
> Without this patch, I cannot boot gpxe option roms at vmx machines.
> This is described at https://bugzilla.redhat.com/show_bug.cgi?id=494469
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3d8fcc5..c456aa5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2362,7 +2362,7 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
>  			u16 error_code,
>  			int emulation_type)
>  {
> -	int r;
> +	int r, shadow_mask;
>  	struct decode_cache *c;
>  
>  	kvm_clear_exception_queue(vcpu);
> @@ -2415,7 +2415,12 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
>  		return EMULATE_DONE;
>  	}
>  
> +	vcpu->arch.emulate_ctxt.interruptibility = 0;
>   

If the instruction is sti or mov ss, this is ouput only.  Otherwise, it 
is an input/output parameter.

To reduce confusion suggest moving this statement to x86_emulate_insn, 
so it can be an output-only parameter.


-- 
error compiling committee.c: too many arguments to function

