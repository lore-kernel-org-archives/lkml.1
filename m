Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbYA0Iwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbYA0Iwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 03:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbYA0Iwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 03:52:34 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:60646
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYA0Iwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 03:52:34 -0500
Message-ID: <479C464E.2060009@qumranet.com>
Date: Sun, 27 Jan 2008 10:52:30 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 8/8] SVM: add support for Nested Paging
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <1201294393-22613-9-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1201294393-22613-9-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> This patch contains the SVM architecture dependent changes for KVM to enable
> support for the Nested Paging feature of AMD Barcelona and Phenom processors.
>  
> +#ifdef CONFIG_X86_64
> +static bool npt_enabled = true;
> +#else
>  static bool npt_enabled = false;
> +#endif
>   

I think that i386 + pae can also support npt, with no changes, no?

So we should check CONFIG_X86_PAE, not X86_64.

> +
> +	if (npt_enabled) {
> +		/* Setup VMCB for Nested Paging */
> +		control->nested_ctl = 1;
> +		control->intercept_exceptions &= ~(1 << PF_VECTOR);
> +		control->intercept_cr_read &= ~(INTERCEPT_CR0_MASK|
> +						INTERCEPT_CR3_MASK|
> +						INTERCEPT_CR4_MASK);
> +		control->intercept_cr_write &= ~(INTERCEPT_CR0_MASK|
> +						 INTERCEPT_CR3_MASK|
> +						 INTERCEPT_CR4_MASK);
>   

What happens to lazy fpu if we don't trap cr0 changes?

Perhaps it's worth disabling lazy fpu with npt.

>  static int svm_vcpu_reset(struct kvm_vcpu *vcpu)
> @@ -789,6 +812,15 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> +	if (npt_enabled) {
> +		/*
> +		 * re-enable caching here because the QEMU bios
> +		 * does not do it - this results in some delay at
> +		 * reboot
> +		 */
> +		cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
> +		goto set;
> +	}
>  #ifdef CONFIG_X86_64
>  	if (vcpu->arch.shadow_efer & EFER_LME) {
>  		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
> @@ -812,13 +844,16 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  	cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
>  	if (!vcpu->fpu_active)
>  		cr0 |= X86_CR0_TS;
> +set:
>  	svm->vmcb->save.cr0 = cr0;
>  }
>   

You could move 'cr0 &= ~(X86_CR0_CD | X86_CR0_NW);' from three lines 
above the 'set' label downwards, and avoid it in the if () above.
>  static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	u32 exit_code = svm->vmcb->control.exit_code;
>  
> +	if (npt_enabled) {
> +		int mmu_reload = 0;
>   

blank line

> +		if (((vcpu->arch.cr0 ^ svm->vmcb->save.cr0) & X86_CR0_PG)
> +		    || ((vcpu->arch.cr4 ^ svm->vmcb->save.cr4) &
> +			(X86_CR4_PGE|X86_CR4_PAE)))
> +			mmu_reload = 1;
> +		vcpu->arch.cr0 = svm->vmcb->save.cr0;
> +		vcpu->arch.cr4 = svm->vmcb->save.cr4;
> +		vcpu->arch.cr3 = svm->vmcb->save.cr3;
> +		if (mmu_reload) {
> +			kvm_mmu_reset_context(vcpu);
> +			kvm_mmu_load(vcpu);
> +		}
> +		if (is_pae(vcpu) && !is_long_mode(vcpu))
> +			load_pdptrs(vcpu, vcpu->arch.cr3);
>   

load_pdptrs() may fail; you need to check that.


-- 
error compiling committee.c: too many arguments to function

