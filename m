Return-Path: <linux-kernel-owner+w=401wt.eu-S1760580AbZCPSbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580AbZCPSbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbZCPSbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:31:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47722 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbZCPSbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:31:08 -0400
Date: Mon, 16 Mar 2009 15:30:00 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm/x86: check KVM_REQ_TLB_FLUSH with irqs disabled
Message-ID: <20090316183000.GC3783@amt.cnet>
References: <1237208625-2657-1-git-send-email-joerg.roedel@amd.com> <49BE5054.6040707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BE5054.6040707@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 03:12:52PM +0200, Avi Kivity wrote:
> Joerg Roedel wrote:
>> For KVM remote TLB flushes we need to check the KVM_REQ_TLB_FLUSH
>> request flag when the irqs are already disabled. Otherwise there is a
>> small window of time for a race condition where we may enter a guest
>> without doing a requested TLB flush.
>>
>> @@ -3108,8 +3108,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>  			kvm_write_guest_time(vcpu);
>>  		if (test_and_clear_bit(KVM_REQ_MMU_SYNC, &vcpu->requests))
>>  			kvm_mmu_sync_roots(vcpu);
>> -		if (test_and_clear_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests))
>> -			kvm_x86_ops->tlb_flush(vcpu);
>>  		if (test_and_clear_bit(KVM_REQ_REPORT_TPR_ACCESS,
>>  				       &vcpu->requests)) {
>>  			kvm_run->exit_reason = KVM_EXIT_TPR_ACCESS;
>> @@ -3133,6 +3131,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>   	local_irq_disable();
>>  +	if (test_and_clear_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests))
>> +		kvm_x86_ops->tlb_flush(vcpu);
>> +
>>  	if (vcpu->requests || need_resched() || signal_pending(current)) {
>>  		local_irq_enable();
>>  		preempt_enable();
>>   
>
> If we lost the race and someone sets a bit after the test, then the test  
> immediately above will pick this up retry the bit tests.

BTW, I've wondered if the local_irq_enable in svm_vcpu_run is safe:

        clgi();

        local_irq_enable();

There is no way that an interrupt can be handled there without an exit, 
right?

