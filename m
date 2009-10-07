Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbZJGVjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbZJGVjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZJGVjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:39:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbZJGVjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:39:23 -0400
Message-ID: <4ACD0A2B.1080307@redhat.com>
Date: Wed, 07 Oct 2009 23:37:47 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Zach Brown <zach.brown@oracle.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall implementation
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com> <4ACB0833.2050203@redhat.com> <4ACB9074.1000804@goop.org> <4ACC6C9C.7080707@redhat.com> <4ACCEC18.90401@goop.org> <4ACCF565.30804@redhat.com> <4ACD05D8.5090903@goop.org>
In-Reply-To: <4ACD05D8.5090903@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2009 11:19 PM, Jeremy Fitzhardinge wrote:
>
>> When do you copy?
>>
>> I'd rather have a single copy for guest and host.
>>      
> When Xen updates the parameters normally.  The interface never really
> needed to share the memory between hypervisor and guest, and I think
> avoiding it is a bit more robust.
>
> But for KVM, you already use the MSR to place the pvclock_vcpu_time_info
> structure, so you could just place it in the page and use the same
> memory for kernel and usermode.
>    

Yes.

>> If the hypervisor does a pvclock->version = somethingelse->version++
>> then the guest may get confused.  But I understand you have a
>> guest-private ->version?
>>      
> The guest should never get confused by the version being changed by the
> hypervisor.  It's already part of the ABI.  Or did you mean something else?
>    

If the guest does a RMW on the version, but the host does not (copying 
it from somewhere else), then the guest RMW can be lost.

Looking at the code, that's what kvm does:

     vcpu->hv_clock.version += 2;

     shared_kaddr = kmap_atomic(vcpu->time_page, KM_USER0);

     memcpy(shared_kaddr + vcpu->time_offset, &vcpu->hv_clock,
            sizeof(vcpu->hv_clock));

so a guest-side ++version can be lost.

> I'm not sure what you mean by "guest-private version"; the versions are
> always guest-private:  te version is part of the pvclock structure,
> which is per-vcpu, which is private to each guest.   The guest nevern
> maintains a separate long-term copy of the structure, only a transient
> snapshot while computing time from the tsc (that's the current pvclock.c
> code).
>    

Same for kvm.  I'm not worried about cross-guest corruption, just the 
guest and host working together to confuse the guest.

>> No need to read them atomically.
>>
>> cpu1 = vgetcpu()
>> hver1 = pvclock[cpu1].hver
>> kver1 = pvclock[cpu1].kver
>> tsc = rdtsc
>> /* multipication magic with pvclock[cpu1]*/
>> cpu2 = vgetcpu()
>> hver2 = pvclock[cpu2].hver
>> kver2 = pvclock[cpu2].kver
>> valid = cpu1 == cpu2&&  hver1 == hver2&&  kver1 == kver2
>>      
> I don't think that's necessary, but I can certainly live with it if it
> makes you happier.
>    

I think the version issue requires it.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

