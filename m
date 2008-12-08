Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbYLHOcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbYLHOcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYLHOch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:32:37 -0500
Received: from relay2.sgi.com ([192.48.179.30]:40859 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751945AbYLHOcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:32:36 -0500
Message-ID: <493D300A.6080805@sgi.com>
Date: Mon, 08 Dec 2008 06:32:42 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, kvm-devel <kvm@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kvm: use modern cpumask primitives, no cpumask_t
 on stack
References: <200812072125.14416.rusty@rustcorp.com.au> <493BF144.9080106@redhat.com>
In-Reply-To: <493BF144.9080106@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Rusty Russell wrote:
>> We're getting rid on on-stack cpumasks for large NR_CPUS.
>>
>> 1) Use cpumask_var_t and alloc_cpumask_var (a noop normally).  Fallback
>>    code is inefficient but never happens in practice.
>> 2) smp_call_function_mask -> smp_call_function_many
>> 3) cpus_clear, cpus_empty, cpu_set -> cpumask_clear, cpumask_empty,
>>    cpumask_set_cpu.
>>
>> --- linux-2.6.orig/virt/kvm/kvm_main.c
>> +++ linux-2.6/virt/kvm/kvm_main.c
>> @@ -358,11 +358,23 @@ static void ack_flush(void *_completed)
>>  void kvm_flush_remote_tlbs(struct kvm *kvm)
>>  {
>>      int i, cpu, me;
>> -    cpumask_t cpus;
>> +    cpumask_var_t cpus;
>>      struct kvm_vcpu *vcpu;
>>  
>>      me = get_cpu();
>> -    cpus_clear(cpus);
>> +    if (!alloc_cpumask_var(&cpus, GFP_ATOMIC)) {
>> +        /* Slow path on failure.  Call everyone. */
>> +        for (i = 0; i < KVM_MAX_VCPUS; ++i) {
>> +            vcpu = kvm->vcpus[i];
>> +            if (vcpu)
>> +                set_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests);
>> +        }
>> +        ++kvm->stat.remote_tlb_flush;
>> +        smp_call_function_many(cpu_online_mask, ack_flush, NULL, 1);
>> +        put_cpu();
>> +        return;
>> +    }
>> +
>>   
> 
> Wow, code duplication from Rusty. Things must be bad.
> 
> Since we're in a get_cpu() here, how about a per_cpu static cpumask
> instead? I don't mind the inefficient fallback, just the duplication.
> 

One thing to note is that when CPUMASK_OFFSTACK=n, then alloc_cpumask_var
returns a constant 1 and the duplicate code is not even compiled.

