Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbXLBXDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbXLBXDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 18:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbXLBXDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 18:03:12 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59073 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbXLBXDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 18:03:11 -0500
Message-ID: <475339A6.9020207@us.ibm.com>
Date: Sun, 02 Dec 2007 17:03:02 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Amit Shah <amit.shah@qumranet.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure (v2)
References: <11898788932902-git-send-email-aliguori@us.ibm.com> <200712021917.28706.amit.shah@qumranet.com>
In-Reply-To: <200712021917.28706.amit.shah@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah wrote:
> * Anthony Liguori wrote:
>   
>> This patch refactors the current hypercall infrastructure to better support
>> live migration and SMP.  It eliminates the hypercall page by trapping the
>> UD exception that would occur if you used the wrong hypercall instruction
>> for the underlying architecture and replacing it with the right one lazily.
>>     
>
> This doesn't work right for SVM. It keeps looping indefinitely; on a kvm_stat 
> run, I get about 230,000 light vm exits per second, with the hypercall never 
> returning to the guest.
>
> ...
>   

What are you using to issue the hypercall?

Regards,

Anthony Liguori

>> diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
>> index 729f1cd..d09a9f5 100644
>> --- a/drivers/kvm/svm.c
>> +++ b/drivers/kvm/svm.c
>> @@ -476,7 +476,8 @@ static void init_vmcb(struct vmcb *vmcb)
>>  					INTERCEPT_DR5_MASK |
>>  					INTERCEPT_DR7_MASK;
>>
>> -	control->intercept_exceptions = 1 << PF_VECTOR;
>> +	control->intercept_exceptions = (1 << PF_VECTOR) |
>> +					(1 << UD_VECTOR);
>>
>>
>>  	control->intercept = 	(1ULL << INTERCEPT_INTR) |
>> @@ -970,6 +971,17 @@ static int pf_interception(struct vcpu_svm *svm,
>> struct kvm_run *kvm_run) return 0;
>>  }
>>
>> +static int ud_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
>> +{
>> +	int er;
>> +
>> +	er = emulate_instruction(&svm->vcpu, kvm_run, 0, 0);
>> +	if (er != EMULATE_DONE)
>> +		inject_ud(&svm->vcpu);
>> +
>> +	return 1;
>> +}
>> +
>>  static int nm_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
>>  {
>>  	svm->vmcb->control.intercept_exceptions &= ~(1 << NM_VECTOR);
>> @@ -1036,7 +1048,8 @@ static int vmmcall_interception(struct vcpu_svm *svm,
>> struct kvm_run *kvm_run) {
>>  	svm->next_rip = svm->vmcb->save.rip + 3;
>>  	skip_emulated_instruction(&svm->vcpu);
>> -	return kvm_hypercall(&svm->vcpu, kvm_run);
>> +	kvm_emulate_hypercall(&svm->vcpu);
>> +	return 1;
>>  }
>>
>>  static int invalid_op_interception(struct vcpu_svm *svm,
>> @@ -1232,6 +1245,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm
>> *svm, [SVM_EXIT_WRITE_DR3]			= emulate_on_interception,
>>  	[SVM_EXIT_WRITE_DR5]			= emulate_on_interception,
>>  	[SVM_EXIT_WRITE_DR7]			= emulate_on_interception,
>> +	[SVM_EXIT_EXCP_BASE + UD_VECTOR]	= ud_interception,
>>  	[SVM_EXIT_EXCP_BASE + PF_VECTOR] 	= pf_interception,
>>  	[SVM_EXIT_EXCP_BASE + NM_VECTOR] 	= nm_interception,
>>  	[SVM_EXIT_INTR] 			= nop_on_interception,
>> @@ -1664,7 +1678,6 @@ svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned
>> char *hypercall) hypercall[0] = 0x0f;
>>  	hypercall[1] = 0x01;
>>  	hypercall[2] = 0xd9;
>> -	hypercall[3] = 0xc3;
>>  }
>>     
>
> ...
>
>   
>> +/* This instruction is vmcall.  On non-VT architectures, it will generate
>> a + * trap that we will then rewrite to the appropriate instruction. */
>> -#define __NR_hypercalls			0
>> +#define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"
>>     
>
> .. which never happens.
>   

