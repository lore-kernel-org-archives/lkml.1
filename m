Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbZELSO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbZELSO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 14:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbZELSOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 14:14:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57410 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756922AbZELSOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 14:14:38 -0400
Message-ID: <4A09BC90.9030700@redhat.com>
Date: Tue, 12 May 2009 21:14:40 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 2/2] deal with interrupt shadow state for emulated instruction
References: <1242141230-22514-1-git-send-email-glommer@redhat.com> <1242141230-22514-2-git-send-email-glommer@redhat.com> <1242141230-22514-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1242141230-22514-3-git-send-email-glommer@redhat.com>
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
>
> @@ -1618,6 +1620,15 @@ special_insn:
>  		int err;
>  
>  		sel = c->src.val;
> +		if (c->modrm_reg == VCPU_SREG_SS) {
> +			u32 int_shadow =
> +			kvm_x86_ops->get_interrupt_shadow(ctxt->vcpu,
> +							  X86_SHADOW_INT_MOV_SS);
> +			/* See sti emulation for an explanation of this */
> +			if (!(int_shadow & X86_SHADOW_INT_MOV_SS))
> +				ctxt->interruptibility = X86_SHADOW_INT_MOV_SS;
> +		}
>   

The indentation of the first statement here is annoying.  Suggest a 
function toggle_interruptibility(ctxt, mask).  Would eliminate the need 
for the comment forward reference as well.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

