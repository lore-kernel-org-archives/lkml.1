Return-Path: <linux-kernel-owner+w=401wt.eu-S933025AbXAaLEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbXAaLEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 06:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933028AbXAaLEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 06:04:41 -0500
Received: from il.qumranet.com ([62.219.232.206]:50206 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933025AbXAaLEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 06:04:40 -0500
Message-ID: <45C077C4.3070607@qumranet.com>
Date: Wed, 31 Jan 2007 13:04:36 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@osdl.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: cpu hotplug support
References: <45BF5B96.1070007@qumranet.com> <20070130145616.EFD52A0014@il.qumranet.com> <20070130164829.ce7f2f90.akpm@osdl.org> <20070131085039.GA17141@elte.hu>
In-Reply-To: <20070131085039.GA17141@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andrew Morton <akpm@osdl.org> wrote:
>
>   
>> On Tue, 30 Jan 2007 14:56:16 -0000
>> Avi Kivity <avi@qumranet.com> wrote:
>>
>>     
>>> +static void decache_vcpus_on_cpu(int cpu)
>>> +{
>>> +	struct kvm *vm;
>>> +	struct kvm_vcpu *vcpu;
>>> +	int i;
>>> +
>>> +	spin_lock(&kvm_lock);
>>> +	list_for_each_entry(vm, &vm_list, vm_list)
>>> +		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
>>> +			vcpu = &vm->vcpus[i];
>>> +			/*
>>> +			 * If the vcpu is locked, then it is running on some
>>> +			 * other cpu and therefore it is not cached on the
>>> +			 * cpu in question.
>>> +			 *
>>> +			 * If it's not locked, check the last cpu it executed
>>> +			 * on.
>>> +			 */
>>> +			if (mutex_trylock(&vcpu->mutex)) {
>>> +				if (vcpu->cpu == cpu) {
>>> +					kvm_arch_ops->vcpu_decache(vcpu);
>>> +					vcpu->cpu = -1;
>>> +				}
>>> +				mutex_unlock(&vcpu->mutex);
>>> +			}
>>> +		}
>>> +	spin_unlock(&kvm_lock);
>>> +}
>>>       
>> The trylock is unpleasing.  Perhaps kvm_lock should be a mutex or 
>> something?
>>     
>
> this is a special case. The vcpu->mutex acts as a 'this vcpu is running 
> right now' flag as well - hence the trylock signals: is it running right 
> now or not - if it's not running we do not have to 'decache' it. But i 
> agree and i already suggested to Avi to change kvm_lock to be a mutex - 
> but this wont change the trylock.
>   

To elaborate a little: replacing mutex_trylock() with mutex_lock() will 
cause unbounded latency as we wait for the vcpu to be descheduled.  In 
this case, we're only interested in descheduled vcpus, so there's no 
need to wait.

kvm is a bit funny in how it likes to pin cpus.

-- 
error compiling committee.c: too many arguments to function

