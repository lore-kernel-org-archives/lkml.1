Return-Path: <linux-kernel-owner+w=401wt.eu-S1759851AbZJGTaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbZJGTaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 15:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbZJGTaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 15:30:06 -0400
Received: from claw.goop.org ([74.207.240.146]:46013 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337AbZJGTaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 15:30:05 -0400
Message-ID: <4ACCEC18.90401@goop.org>
Date: Wed, 07 Oct 2009 12:29:28 -0700
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
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com> <4ACB0833.2050203@redhat.com> <4ACB9074.1000804@goop.org> <4ACC6C9C.7080707@redhat.com>
In-Reply-To: <4ACC6C9C.7080707@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/09 03:25, Avi Kivity wrote:
> On 10/06/2009 08:46 PM, Jeremy Fitzhardinge wrote:
>>
>>> Instead of using vgetcpu() and rdtsc() independently, you can use
>>> rdtscp to read both atomically.  This removes the need for the preempt
>>> notifier.
>>>      
>> rdtscp first appeared on Intel with Nehalem, so we need to support older
>> Intel chips.
>>    
>
> We can support them by falling back to the kernel.

Yes, but its easy enough to support them with the fast-path.

>   I'm a bit worried about the kernel playing with the hypervisor's
> version field.

For Xen I explicitly made it not a problem by adding the notion of a
secondary pvclock_vcpu_time_info structure which is updated by copying,
aside from the version number which is updated as-is.

As far as I can tell it isn't a problem for KVM either.  The guest
version number is atomic with respect to preemption by the hypervisor so
there's no scope for racing.  (The ABI already guarantees that the
pvclock structures are never updated cross-cpu.)

It ultimately doesn't matter what the version number is so long as it
changes when the parameters are updated, and version numbers can't be
reused within a window where things get confused.

> It's better to introduce yet a new version for the kernel, and check
> both.

Two version numbers are awkward to read atomically at least on 32-bit. 
And I don't think its necessary.

> def try_pvclock_vtime():
>   tsc, p0 = rdtscp()
>   v0 = pvclock[p0].version
>   tsc, p = rdtscp()
>   t = pvclock_time(pvclock[p], tsc)
>   if p != p0 or pvclock[p].version != v0:
>      raise Exception("Processor or timebased change under our feet")
>   return t
>
> def pvclock_time():
>   while True:
>     try:
>        return try_pvlock_time()
>     except:
>        pass
>
> So, two rdtscps and two compares.

Yep, that would work.

> It's sufficient to increment a version counter on thread migration, no
> need to do it on context switch.
>

That's true; switch_out is a pessimistic approximation of that.  But is
there a convenient hook to test for migration?

    J
