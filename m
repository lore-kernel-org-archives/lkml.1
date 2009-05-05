Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbZEENwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbZEENwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbZEENwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:52:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56415 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbZEENwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:52:14 -0400
Date: Tue, 5 May 2009 10:57:06 -0300
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] deal with interrupt shadow state for emulated
	instruction
Message-ID: <20090505135706.GA26401@poweredge.glommer>
References: <1240929045-6970-1-git-send-email-glommer@redhat.com> <49F99095.7060503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F99095.7060503@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, if the guest runs an infinite emulated 'mov ss', it will keep  
> toggling the MOV_SS bit, but STI will remain set, so we'll never allow  
> an interrupt into the guest kernel.
We have no choice but returning both flags, since svm does not differentiate
between them.

But see below for an alternative path that makes it a non-issue.

>
>> diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
>> index d2664fc..797d41f 100644
>> --- a/arch/x86/kvm/x86_emulate.c
>> +++ b/arch/x86/kvm/x86_emulate.c
>> @@ -1618,6 +1618,16 @@ special_insn:
>>  		int err;
>>   		sel = c->src.val;
>> +		if (c->modrm_reg == VCPU_SREG_SS) {
>> +			u32 int_shadow =
>> +				kvm_x86_ops->get_interrupt_shadow(ctxt->vcpu);
>> +			/* See sti emulation for an explanation of this */
>> +			if ((int_shadow & X86_SHADOW_INT_MOV_SS))
>> +				ctxt->interruptibility &= ~X86_SHADOW_INT_MOV_SS;
>> +			else
>> +				ctxt->interruptibility |= X86_SHADOW_INT_MOV_SS;
>> +		}
>>   
>
> ^=
 =p \o/

After re-reading this, masking the flags in here makes no sense.

I am moving to an approach in which I do

                        if (!(int_shadow & X86_SHADOW_INT_MOV_SS))
                                ctxt->interruptibility = X86_SHADOW_INT_MOV_SS;

Since if the next instruction is an sti, it is certainly not an sti; sti instruction
(the current is mov ss, after all). So we should mask it anyway. This also solves
nicely the problem you raised at svm.c.
>
>> @@ -1846,10 +1856,23 @@ special_insn:
>>  		ctxt->eflags &= ~X86_EFLAGS_IF;
>>  		c->dst.type = OP_NONE;	/* Disable writeback. */
>>  		break;
>> -	case 0xfb: /* sti */
>> +	case 0xfb: { /* sti */
>> +		u32 int_shadow = kvm_x86_ops->get_interrupt_shadow(ctxt->vcpu);
>> +		/*
>> +		 * an sti; sti; sequence only disable interrupts for the first
>> +		 * instruction. So, if the last instruction, be it emulated or
>> +		 * not, left the system with the INT_STI flag enabled, it
>> +		 * means that the last instruction is an sti. We should not
>> +		 * leave the flag on in this case
>> +		 */
>> +		if ((int_shadow & X86_SHADOW_INT_STI))
>> +			ctxt->interruptibility &= ~X86_SHADOW_INT_STI;
>> +		else
>> +			ctxt->interruptibility |= X86_SHADOW_INT_STI;
>>   
>
> ^=
ditto

