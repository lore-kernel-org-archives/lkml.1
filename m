Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbZJLSVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbZJLSVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757490AbZJLSVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:21:40 -0400
Received: from claw.goop.org ([74.207.240.146]:36352 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489AbZJLSVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:21:39 -0400
Message-ID: <4AD3738B.6050200@goop.org>
Date: Mon, 12 Oct 2009 11:20:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Zach Brown <zach.brown@oracle.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall	implementation
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com>	<4ACB0833.2050203@redhat.com> <4ACB9074.1000804@goop.org>	<4ACC6C9C.7080707@redhat.com> <4ACFD43E.6000506@goop.org> <4AD0CDFB.9030704@redhat.com>
In-Reply-To: <4AD0CDFB.9030704@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/09 11:10, Avi Kivity wrote:
> On 10/10/2009 02:24 AM, Jeremy Fitzhardinge wrote:
>> On 10/07/09 03:25, Avi Kivity wrote:
>>   
>>> def try_pvclock_vtime():
>>>    tsc, p0 = rdtscp()
>>>    v0 = pvclock[p0].version
>>>    tsc, p = rdtscp()
>>>    t = pvclock_time(pvclock[p], tsc)
>>>    if p != p0 or pvclock[p].version != v0:
>>>       raise Exception("Processor or timebased change under our feet")
>>>    return t
>>>      
>> This doesn't quite work.
>>
>> If we end up migrating some time after the first rdtscp, then the
>> accesses to pvclock[] will be cross-cpu.  Since we don't made any strong
>> SMP memory ordering guarantees on updating the structure, the snapshot
>> isn't guaranteed to be consistent even if we re-check the version at the
>> end.
>>    
>
> We only hit this if we have a double migration, otherwise we see p != p0.
>
> Most likely all existing implementations do have a write barrier on
> the guest entry path, so if we add a read barrier between the two
> compares, that ensures we're reading from the same cpu again.

There's a second problem:  If the time_info gets updated between the
first rdtscp and the first version fetch, then we won't have a
consistent tsc,time_info pair.  You could check if tsc_timestamp is >
tsc, but that won't necessarily work on save/restore/migrate.

>> So to use rdtscp we need to either redefine the update of
>> pvclock_vcpu_time_info to be SMP-safe, or keep the additional migration
>> check.
>>    
>
> I think we can update the ABI after verifying all implementations do
> have a write barrier.
>

I suppose that works if you assume that:

   1. every task->vcpu migration is associated with a hv/guest context
      switch, and
   2. every hv/guest context switch is a write barrier

I guess 2 is a given, but I can at least imagine cases where 1 might not
be true.  Maybe.  It all seems very subtle.

And I don't really see a gain.  You avoid maintaining a second version
number, but at the cost of two rdtscps.  In my measurements, the whole
vsyscall takes around 100ns to run, and a single rdtsc takes about 30,
so 30% of total.  Unlike rdtsc, rdtscp is documented as being ordered in
the instruction stream, and so will take at least as long; two of them
will completely blow the vsyscall execution time.

(By contrast, lsl only takes around 10ns, which suggests it should be
used preferentially in vgetcpu anyway.)

AMD CPUs have traditionally been much better than Intel at these kinds
of things, so maybe rdtscp makes sense there.  Or maybe Nehalem is much
better than my Core2 Q6600.

    J

