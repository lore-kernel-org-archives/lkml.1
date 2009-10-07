Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbZJGUK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbZJGUK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759930AbZJGUK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:10:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759921AbZJGUK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:10:56 -0400
Message-ID: <4ACCF565.30804@redhat.com>
Date: Wed, 07 Oct 2009 22:09:09 +0200
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
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com> <4ACB0833.2050203@redhat.com> <4ACB9074.1000804@goop.org> <4ACC6C9C.7080707@redhat.com> <4ACCEC18.90401@goop.org>
In-Reply-To: <4ACCEC18.90401@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2009 09:29 PM, Jeremy Fitzhardinge wrote:
>
>>    I'm a bit worried about the kernel playing with the hypervisor's
>> version field.
>>      
> For Xen I explicitly made it not a problem by adding the notion of a
> secondary pvclock_vcpu_time_info structure which is updated by copying,
> aside from the version number which is updated as-is.
>    

When do you copy?

I'd rather have a single copy for guest and host.

> As far as I can tell it isn't a problem for KVM either.  The guest
> version number is atomic with respect to preemption by the hypervisor so
> there's no scope for racing.  (The ABI already guarantees that the
> pvclock structures are never updated cross-cpu.)
>
> It ultimately doesn't matter what the version number is so long as it
> changes when the parameters are updated, and version numbers can't be
> reused within a window where things get confused.
>    

If the hypervisor does a pvclock->version = somethingelse->version++ 
then the guest may get confused.  But I understand you have a 
guest-private ->version?

>> It's better to introduce yet a new version for the kernel, and check
>> both.
>>      
> Two version numbers are awkward to read atomically at least on 32-bit.
> And I don't think its necessary.
>    

No need to read them atomically.

cpu1 = vgetcpu()
hver1 = pvclock[cpu1].hver
kver1 = pvclock[cpu1].kver
tsc = rdtsc
/* multipication magic with pvclock[cpu1]*/
cpu2 = vgetcpu()
hver2 = pvclock[cpu2].hver
kver2 = pvclock[cpu2].kver
valid = cpu1 == cpu2 && hver1 == hver2 && kver1 == kver2

>> It's sufficient to increment a version counter on thread migration, no
>> need to do it on context switch.
>>
>>      
> That's true; switch_out is a pessimistic approximation of that.  But is
> there a convenient hook to test for migration?
>    

I'd guess not but it's probably easy to add one in the migration thread.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

