Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbZJFPMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbZJFPMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbZJFPMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:12:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757381AbZJFPMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:12:53 -0400
Message-ID: <4ACB5E1A.8000407@redhat.com>
Date: Tue, 06 Oct 2009 17:11:22 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kurt.hackel@oracle.com, Keir Fraser <keir.fraser@eu.citrix.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>, zach.brown@oracle.com,
       the arch/x86 maintainers <x86@kernel.org>, chris.mason@oracle.com
Subject: Re: [PATCH 3/5] x86/pvclock: add vsyscall implementation
References: <711a958d-5a76-4f00-aa69-8e5889945992@default>
In-Reply-To: <711a958d-5a76-4f00-aa69-8e5889945992@default>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2009 04:19 PM, Dan Magenheimer wrote:
>> From: Jeremy Fitzhardinge [mailto:jeremy.fitzhardinge@citrix.com]
>> With this in place, I can do a gettimeofday in about 100ns on a 2.4GHz
>> Q6600.  I'm sure this could be tuned a bit more, but it is
>> already much better than a syscall.
>>      
> To evaluate the goodness of this, we really need a full
> set of measurements for:
>
> a) cost of rdtsc (and rdtscp if different)
> b) cost of vsyscall+pvclock
> c) cost of rdtsc emulated
> d) cost of a hypercall that returns "hypervisor system time"
>
> On a E6850 (3Ghz but let's use cycles), I measured;
>
> a == 72 cycles
> c == 1080 cycles
> d == 780 cycles
>
> It may be partly apples and oranges, but it looks
> like a good guess for b on my machine is
>
> b == 240 cycles
>    

Two rdtscps should suffice (and I think they are much faster on modern 
machines).

> Not bad, but is there any additional context switch
> cost to support it?
>    

rdtscp requires an additional msr read/write on heavyweight host context 
switches.  Should be negligible compared to the savings.

>> From: Avi Kivity [mailto:avi@redhat.com]
>> Instead of using vgetcpu() and rdtsc() independently, you can
>> use rdtscp
>> to read both atomically.  This removes the need for the
>> preempt notifier.
>>      
> Xen does not currently expose rdtscp and so does not emulate
> (or context switch) TSC_AUX.  Context switching TSC_AUX
> is certainly possible, but will likely be expensive.
> If the primary reason for vsyscall+pvclock is to maximize
> performance for gettimeofday/clock_gettime, this cost
> would need to be added to the mix.
>    

It will cost ~100 cycles on heavyweight host context switch 
(guest-to-guest).

>> preempt notifiers are per-thread, not global, and will upset
>> the cycle
>> counters.  I'd drop them and use rdtscp instead (and give up if the
>> processor doesn't support it).
>>      
> Even if rdtscp is used, in the Intel processor lineup
> only the very latest (Nehalem) supports rdtscp, so
> "give up" doesn't seem like a very good option, at least
> in the near future.
>    

Why not?  we still fall back to the guest kernel.  By the time guest 
kernels with rdtscp support are in the field, these machines will be 
quiet old.

-- 
error compiling committee.c: too many arguments to function

