Return-Path: <linux-kernel-owner+w=401wt.eu-S1761103AbZLOVZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761103AbZLOVZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760768AbZLOVZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:25:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760753AbZLOVZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:25:04 -0500
Message-ID: <4B27FF23.2030706@redhat.com>
Date: Tue, 15 Dec 2009 11:26:59 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: Re: [PATCH RFC: kvm tsc virtualization 15/20] Fix longstanding	races
References: <1260850127-9766-7-git-send-email-zamsden@redhat.com> <1260850127-9766-8-git-send-email-zamsden@redhat.com> <1260850127-9766-9-git-send-email-zamsden@redhat.com> <1260850127-9766-10-git-send-email-zamsden@redhat.com> <1260850127-9766-11-git-send-email-zamsden@redhat.com> <1260850127-9766-12-git-send-email-zamsden@redhat.com> <1260850127-9766-13-git-send-email-zamsden@redhat.com> <1260850127-9766-14-git-send-email-zamsden@redhat.com> <1260850127-9766-15-git-send-email-zamsden@redhat.com> <1260850127-9766-16-git-send-email-zamsden@redhat.com> <20091215182139.GA14005@amt.cnet>
In-Reply-To: <20091215182139.GA14005@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2009 08:21 AM, Marcelo Tosatti wrote:
> On Mon, Dec 14, 2009 at 06:08:42PM -1000, Zachary Amsden wrote:
>
> <snip>
>
> +               atomic_set(&per_cpu(cpu_tsc_synchronized, freq->cpu),
> 0);
> +               spin_lock(&kvm_lock);
> +               list_for_each_entry(kvm,&vm_list, vm_list) {
> +                       kvm_for_each_vcpu(i, vcpu, kvm) {
> +                               if (vcpu->cpu != freq->cpu)
> +                                       continue;
> +                               if (vcpu->cpu != smp_processor_id())
> +                                       send_ipi++;
> +                               kvm_request_guest_time_update(vcpu);
>
> There is some overlap here between KVM_REQ_KVMCLOCK_UPDATE and
> cpu_tsc_synchronized. Its the same information (frequency for a CPU has
> changed) stored in two places.
>
> Later you do:
>
>                  spin_lock(&kvm_lock);
>                  list_for_each_entry(kvm,&vm_list, vm_list) {
>                          kvm_for_each_vcpu(i, vcpu, kvm) {
>                                  if (vcpu->cpu != freq->cpu)
>                                          continue;
>                                  if (vcpu->cpu != smp_processor_id())
>                                         send_ipi++;
>                                  kvm_request_guest_time_update(vcpu);
>                          }
>                  }
>                  spin_unlock(&kvm_lock);
>                  <--- a remote CPU could have updated kvmclock information
>                       with stale cpu_tsc_khz, clearing the
>                       KVM_REQ_KVMCLOCK_UPDATE bit.
>                  smp_call_function(evict) (which sets cpu_tsc_synchronized
>                                            to zero)
>
> Maybe worthwhile to unify it. Perhaps use the per cpu tsc generation in
> addition to vcpu_load to update kvmclock info (on arch vcpu_load update
> kvmclock store generation, update again on generation change).
>    

Yes, that is an excellent point.  The generation counter, the 
tsc_synchronized variable and the per-vcpu clock counter all have some 
amount of redundancy of information.

Perhaps instead of overlapping, they should be layered?

A rule for kvmclock: can't update kvmclock info until cpu is synchronized?

Thanks,

Zach
