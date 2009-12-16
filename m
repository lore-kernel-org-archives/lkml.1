Return-Path: <linux-kernel-owner+w=401wt.eu-S1762154AbZLPOmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154AbZLPOmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758001AbZLPOmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:42:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812AbZLPOmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:42:11 -0500
Date: Wed, 16 Dec 2009 12:41:45 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: Re: [PATCH RFC: kvm tsc virtualization 15/20] Fix longstanding races
Message-ID: <20091216144145.GA21466@amt.cnet>
References: <1260850127-9766-9-git-send-email-zamsden@redhat.com> <1260850127-9766-10-git-send-email-zamsden@redhat.com> <1260850127-9766-11-git-send-email-zamsden@redhat.com> <1260850127-9766-12-git-send-email-zamsden@redhat.com> <1260850127-9766-13-git-send-email-zamsden@redhat.com> <1260850127-9766-14-git-send-email-zamsden@redhat.com> <1260850127-9766-15-git-send-email-zamsden@redhat.com> <1260850127-9766-16-git-send-email-zamsden@redhat.com> <20091215182139.GA14005@amt.cnet> <4B27FF23.2030706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B27FF23.2030706@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 11:26:59AM -1000, Zachary Amsden wrote:
> On 12/15/2009 08:21 AM, Marcelo Tosatti wrote:
>> On Mon, Dec 14, 2009 at 06:08:42PM -1000, Zachary Amsden wrote:
>>
>> <snip>
>>
>> +               atomic_set(&per_cpu(cpu_tsc_synchronized, freq->cpu),
>> 0);
>> +               spin_lock(&kvm_lock);
>> +               list_for_each_entry(kvm,&vm_list, vm_list) {
>> +                       kvm_for_each_vcpu(i, vcpu, kvm) {
>> +                               if (vcpu->cpu != freq->cpu)
>> +                                       continue;
>> +                               if (vcpu->cpu != smp_processor_id())
>> +                                       send_ipi++;
>> +                               kvm_request_guest_time_update(vcpu);
>>
>> There is some overlap here between KVM_REQ_KVMCLOCK_UPDATE and
>> cpu_tsc_synchronized. Its the same information (frequency for a CPU has
>> changed) stored in two places.
>>
>> Later you do:
>>
>>                  spin_lock(&kvm_lock);
>>                  list_for_each_entry(kvm,&vm_list, vm_list) {
>>                          kvm_for_each_vcpu(i, vcpu, kvm) {
>>                                  if (vcpu->cpu != freq->cpu)
>>                                          continue;
>>                                  if (vcpu->cpu != smp_processor_id())
>>                                         send_ipi++;
>>                                  kvm_request_guest_time_update(vcpu);
>>                          }
>>                  }
>>                  spin_unlock(&kvm_lock);
>>                  <--- a remote CPU could have updated kvmclock information
>>                       with stale cpu_tsc_khz, clearing the
>>                       KVM_REQ_KVMCLOCK_UPDATE bit.
>>                  smp_call_function(evict) (which sets cpu_tsc_synchronized
>>                                            to zero)
>>
>> Maybe worthwhile to unify it. Perhaps use the per cpu tsc generation in
>> addition to vcpu_load to update kvmclock info (on arch vcpu_load update
>> kvmclock store generation, update again on generation change).
>>    
>
> Yes, that is an excellent point.  The generation counter, the  
> tsc_synchronized variable and the per-vcpu clock counter all have some  
> amount of redundancy of information.
>
> Perhaps instead of overlapping, they should be layered?
>
> A rule for kvmclock: can't update kvmclock info until cpu is synchronized?

How about update kvmclock on:

- cpu switch (kvm_arch_vcpu_load). Then store cpu tsc generation in
  vcpu->arch.
- on vcpu_enter_guest, if tsc generation changes.

If kvm_arch_vcpu_load stored stale cpu_khz into kvmclock, the tsc
generation will have changed by the time guest entry succeeds.

Then you can kill KVM_REQ_KVMCLOCK_UPDATE and the kvm_for_each_vcpu()
loop in the cpufreq callback. 

