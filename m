Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab0COEkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 00:40:43 -0400
Received: from in.cluded.net ([195.159.98.120]:38149 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab0COEkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 00:40:41 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2010 00:40:40 EDT
Message-ID: <4B9DB7F7.6010902@uw.no>
Date: Mon, 15 Mar 2010 04:30:47 +0000
From: "Daniel K." <dk@uw.no>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] KVM: MMU: Propagate the right fault back to the
 guest after gva_to_gpa
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com> <1267643541-451-16-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1267643541-451-16-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2883ce8..9f8b02d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -314,6 +314,19 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long addr,
>  	kvm_queue_exception_e(vcpu, PF_VECTOR, error_code)
>  }
>  
> +void kvm_propagate_fault(struct kvm_vcpu *vcpu, unsigned long addr, u32 error_code)
> +{
> +	u32 nested, error;
> +
> +	nested = error_code &  PFERR_NESTED_MASK;
> +	error  = error_code & ~PFERR_NESTED_MASK;
> +
> +	if (vcpu->arch.mmu.nested && !(error_code && PFERR_NESTED_MASK))

This looks incorrect, nested is unused.

At the very least it should be a binary & operation

	if (vcpu->arch.mmu.nested && !(error_code & PFERR_NESTED_MASK))

which can be simplified to

	if (vcpu->arch.mmu.nested && !nested)

but it seems wrong that the condition is that it is nested and not nested 
at the same time.


> +		vcpu->arch.nested_mmu.inject_page_fault(vcpu, addr, error);
> +	else
> +		vcpu->arch.mmu.inject_page_fault(vcpu, addr, error);
> +}
> +
>  void kvm_inject_nmi(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->arch.nmi_pending = 1;


Daniel K.
