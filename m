Return-Path: <linux-kernel-owner+w=401wt.eu-S1763409AbZDHS1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763409AbZDHS1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZDHS1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:27:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46616 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZDHS1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:27:03 -0400
Date: Wed, 8 Apr 2009 15:31:10 -0300
From: Glauber Costa <glommer@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] disable interrupt shadow state for emulated instruction
Message-ID: <20090408183110.GD25323@poweredge.glommer>
References: <1239213452-5966-1-git-send-email-glommer@redhat.com> <49DCE9E5.8020703@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DCE9E5.8020703@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 11:16:05AM -0700, H. Peter Anvin wrote:
> Glauber Costa wrote:
>> we currently unblock shadow interrupt state when we skip an instruction,
>> but failing to do so when we actually emulate one. This blocks interrupts
>> in key instruction blocks, in particular sti; hlt; sequences
>>
>> Without this patch, I cannot boot gpxe option roms at vmx machines.
>> This is described at https://bugzilla.redhat.com/show_bug.cgi?id=494469
>>
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index c6997c0..cee38e4 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -736,26 +736,34 @@ static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>>  	vmcs_writel(GUEST_RFLAGS, rflags);
>>  }
>>  +static void vmx_block_interrupt_shadow(struct kvm_vcpu *vcpu)
>> +{
>> +	/*
>> +	 * We emulated an instruction, so temporary interrupt blocking
>> +	 * should be removed, if set.
>> +	 */
>> +	u32 interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
>> +	u32 interruptibility_mask = ((GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS));
>> +
>> +	if (interruptibility & interruptibility_mask)
>> +		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
>> +			     interruptibility & ~interruptibility_mask);
>> +	vcpu->arch.interrupt_window_open = 1;
>> +}
>> +
>
> How does this logic work when the instruction emulated is an STI or MOV  
> SS instruction?  In particular, when does GUEST_INTERRUPTIBILITY_INFO  
> sets set to reflect the *blocking* operation?
mov ss is a non-issue, since it is executed natively.

As for sti, I'm not sure. I see code for emulating sti, but in my testings,
this code was never ever touched, under a number of different scenarios.
Avi, can you clarify if sti can be in fact emulated, and under which
circunstamces? 

If it can, I'd say we'd have to introduce a block_interrupt_shadow as well,
and call from it from within the emulator, whenever the first sti is dispatched.

