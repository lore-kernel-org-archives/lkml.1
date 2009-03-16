Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbZCPNNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbZCPNNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 09:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbZCPNNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 09:13:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56309 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759668AbZCPNNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:13:04 -0400
Message-ID: <49BE5054.6040707@redhat.com>
Date: Mon, 16 Mar 2009 15:12:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm/x86: check KVM_REQ_TLB_FLUSH with irqs disabled
References: <1237208625-2657-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1237208625-2657-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> For KVM remote TLB flushes we need to check the KVM_REQ_TLB_FLUSH
> request flag when the irqs are already disabled. Otherwise there is a
> small window of time for a race condition where we may enter a guest
> without doing a requested TLB flush.
>
> @@ -3108,8 +3108,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  			kvm_write_guest_time(vcpu);
>  		if (test_and_clear_bit(KVM_REQ_MMU_SYNC, &vcpu->requests))
>  			kvm_mmu_sync_roots(vcpu);
> -		if (test_and_clear_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests))
> -			kvm_x86_ops->tlb_flush(vcpu);
>  		if (test_and_clear_bit(KVM_REQ_REPORT_TPR_ACCESS,
>  				       &vcpu->requests)) {
>  			kvm_run->exit_reason = KVM_EXIT_TPR_ACCESS;
> @@ -3133,6 +3131,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  
>  	local_irq_disable();
>  
> +	if (test_and_clear_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests))
> +		kvm_x86_ops->tlb_flush(vcpu);
> +
>  	if (vcpu->requests || need_resched() || signal_pending(current)) {
>  		local_irq_enable();
>  		preempt_enable();
>   

If we lost the race and someone sets a bit after the test, then the test 
immediately above will pick this up retry the bit tests.


-- 
error compiling committee.c: too many arguments to function

