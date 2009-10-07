Return-Path: <linux-kernel-owner+w=401wt.eu-S934372AbZJGU7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934372AbZJGU7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934355AbZJGU7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:59:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934352AbZJGU7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:59:34 -0400
Date: Wed, 7 Oct 2009 17:58:52 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] KVM: SVM: Move nested INTR #vmexit into
	preemtible code
Message-ID: <20091007205852.GA7692@amt.cnet>
References: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com> <1254925888-13743-4-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254925888-13743-4-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 04:31:21PM +0200, Joerg Roedel wrote:
> This patch makes use of the KVM_REQ_VMEXIT to move the
> emulation of #vmexit(INTR) out of non-preemptible code.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/svm.c |   18 ++++++++++++++++--
>  1 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index b6ce1a9..7015680 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1379,8 +1379,14 @@ static inline int nested_svm_intr(struct vcpu_svm *svm)
>  
>  	svm->vmcb->control.exit_code = SVM_EXIT_INTR;
>  
> -	if (nested_svm_exit_handled(svm)) {
> -		nsvm_printk("VMexit -> INTR\n");
> +	if (svm->nested.intercept & 1ULL) {
> +		/*
> +		 * The #vmexit can't be emulated here directly because this
> +		 * code path runs with irqs and preemtion disabled and a
> +		 * #vmexit emulation might sleep. Only set the request bit for
> +		 * the #vmexit here.
> +		 */
> +		set_bit(KVM_REQ_VMEXIT, &svm->vcpu.requests);
>  		return 1;
>  	}

What if you keep this internal to SVM? Proceed to svm_vcpu_run and
return, do the emulation on the exit handler.

Then there's no need for the request bit (VMX does that, see
vmx_vcpu_run).

