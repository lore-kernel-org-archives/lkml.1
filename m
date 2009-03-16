Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbZCPSpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbZCPSpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZCPSpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:45:19 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:34664
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751476AbZCPSpR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:45:17 -0400
X-BigFish: VPS-17(z1857rz1432R98dR1805M936fKzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KGM42P-04-8ID-01
Date: Mon, 16 Mar 2009 19:44:54 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm/x86: check KVM_REQ_TLB_FLUSH with irqs disabled
Message-ID: <20090316184454.GN6159@amd.com>
References: <1237208625-2657-1-git-send-email-joerg.roedel@amd.com> <49BE5054.6040707@redhat.com> <20090316183000.GC3783@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090316183000.GC3783@amt.cnet>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Mar 2009 18:44:54.0825 (UTC) FILETIME=[4C45B990:01C9A667]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 03:30:00PM -0300, Marcelo Tosatti wrote:
> On Mon, Mar 16, 2009 at 03:12:52PM +0200, Avi Kivity wrote:
> > Joerg Roedel wrote:
> >> For KVM remote TLB flushes we need to check the KVM_REQ_TLB_FLUSH
> >> request flag when the irqs are already disabled. Otherwise there is a
> >> small window of time for a race condition where we may enter a guest
> >> without doing a requested TLB flush.
> >>
> >> @@ -3108,8 +3108,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> >>  			kvm_write_guest_time(vcpu);
> >>  		if (test_and_clear_bit(KVM_REQ_MMU_SYNC, &vcpu->requests))
> >>  			kvm_mmu_sync_roots(vcpu);
> >> -		if (test_and_clear_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests))
> >> -			kvm_x86_ops->tlb_flush(vcpu);
> >>  		if (test_and_clear_bit(KVM_REQ_REPORT_TPR_ACCESS,
> >>  				       &vcpu->requests)) {
> >>  			kvm_run->exit_reason = KVM_EXIT_TPR_ACCESS;
> >> @@ -3133,6 +3131,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> >>   	local_irq_disable();
> >>  +	if (test_and_clear_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests))
> >> +		kvm_x86_ops->tlb_flush(vcpu);
> >> +
> >>  	if (vcpu->requests || need_resched() || signal_pending(current)) {
> >>  		local_irq_enable();
> >>  		preempt_enable();
> >>   
> >
> > If we lost the race and someone sets a bit after the test, then the test  
> > immediately above will pick this up retry the bit tests.
> 
> BTW, I've wondered if the local_irq_enable in svm_vcpu_run is safe:
> 
>         clgi();
> 
>         local_irq_enable();

The reason behind this is that we have to allow the host to accept
interrupts. Interrupts are still blocked by clgi (together with
NMI, INIT, debug traps and SMI) until the global interrupt flag is
reenabled as a final step of VMRUN. If we don't enable interrupts here
they would be blocked and an external interrupt would not cause an
#VMEXIT.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

