Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbZJGVT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbZJGVT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZJGVT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:19:58 -0400
Received: from claw.goop.org ([74.207.240.146]:42297 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbZJGVT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:19:57 -0400
Message-ID: <4ACD05D8.5090903@goop.org>
Date: Wed, 07 Oct 2009 14:19:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
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
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com> <4ACB0833.2050203@redhat.com> <4ACB9074.1000804@goop.org> <4ACC6C9C.7080707@redhat.com> <4ACCEC18.90401@goop.org> <4ACCF565.30804@redhat.com>
In-Reply-To: <4ACCF565.30804@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/09 13:09, Avi Kivity wrote:
> On 10/07/2009 09:29 PM, Jeremy Fitzhardinge wrote:
>>
>>>    I'm a bit worried about the kernel playing with the hypervisor's
>>> version field.
>>>      
>> For Xen I explicitly made it not a problem by adding the notion of a
>> secondary pvclock_vcpu_time_info structure which is updated by copying,
>> aside from the version number which is updated as-is.
>>    
>
> When do you copy?
>
> I'd rather have a single copy for guest and host.

When Xen updates the parameters normally.  The interface never really
needed to share the memory between hypervisor and guest, and I think
avoiding it is a bit more robust.

But for KVM, you already use the MSR to place the pvclock_vcpu_time_info
structure, so you could just place it in the page and use the same
memory for kernel and usermode.

> If the hypervisor does a pvclock->version = somethingelse->version++
> then the guest may get confused.  But I understand you have a
> guest-private ->version?

The guest should never get confused by the version being changed by the
hypervisor.  It's already part of the ABI.  Or did you mean something else?

I'm not sure what you mean by "guest-private version"; the versions are
always guest-private:  te version is part of the pvclock structure,
which is per-vcpu, which is private to each guest.   The guest nevern
maintains a separate long-term copy of the structure, only a transient
snapshot while computing time from the tsc (that's the current pvclock.c
code).

> No need to read them atomically.
>
> cpu1 = vgetcpu()
> hver1 = pvclock[cpu1].hver
> kver1 = pvclock[cpu1].kver
> tsc = rdtsc
> /* multipication magic with pvclock[cpu1]*/
> cpu2 = vgetcpu()
> hver2 = pvclock[cpu2].hver
> kver2 = pvclock[cpu2].kver
> valid = cpu1 == cpu2 && hver1 == hver2 && kver1 == kver2

I don't think that's necessary, but I can certainly live with it if it
makes you happier.

>>> It's sufficient to increment a version counter on thread migration, no
>>> need to do it on context switch.
>>>
>>>      
>> That's true; switch_out is a pessimistic approximation of that.  But is
>> there a convenient hook to test for migration?
>>    
>
> I'd guess not but it's probably easy to add one in the migration thread.

Looking at that now.

    J
