Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbZKEGrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbZKEGrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 01:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbZKEGrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 01:47:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318AbZKEGrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 01:47:46 -0500
Message-ID: <4AF274E5.5080205@redhat.com>
Date: Thu, 05 Nov 2009 08:47:01 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Glauber Costa <glommer@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com, Ingo Molnar <mingo@redhat.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall	implementation
References: <284e5d6c-7b31-4284-bd2d-c1d2ded1bc72@default>
In-Reply-To: <284e5d6c-7b31-4284-bd2d-c1d2ded1bc72@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2009 10:30 PM, Dan Magenheimer wrote:
>>
>> In this case we should provide a facility for this.
>> Providing a global
>> monotonic counter may be easier than providing a monotonic
>> clock.  Hence
>> my question.
>>      
> Maybe I'm misunderstanding something, but enterprise
> apps can do this entirely on their own without any
> kernel help, correct?
>    

Within a process, yes.  Across processes, not without writable shared 
memory.

That's why I'm trying to understand what the actual requirements are.  
Real monotonic, accurate, high resolution, low cost time sources are 
hard to come by.

>> I doubt it.  A discontinuity has occured, but what do we know
>> about it? nothing.
>>      
> Actually, I think for many/most profiling applications,
> just knowing a discontinuity occurred between two
> timestamps is very useful as that one specific measurement
> can be discarded.  If a discontinuity is invisible,
> one clearly knows that a negative interval is bad,
> but if an interval is very small or very large,
> one never knows if it is due to a discontinuity or
> due to some other reason.
>
> This would argue for a syscall/vsyscall that can
> "return" two values: the "time" and a second
> "continuity generation" counter.
>
>    

I doubt it.  You should expect discontinuities in user space due to 
being swapped out, scheduled out, migrated to a different cpu, or your 
laptop lid being closed.  There are no guarantees to a userspace 
application.  Even the kernel can expect discontinuities due to SMIs.  
So an explicit notification about one type of discontinuity adds nothing.

>>> True, though clock_gettime(CLOCK_MONOTONIC) can provide
>>> the monotonicity where it is required.
>>>        
>> We have that already.  The question is how to implement it in
>> a vsyscall.
>>      
> Oh, I see.  I missed that very crucial point.
>
> So, just to verify/clarify... There is NO WAY for
> a vsyscall to ensure monotonicity (presumably because
> the previous reading can't be safely stored?).  So
> speed and "correctness" are mutually exclusive?
>    

Yes.

> If true, yes, that's a potentially significant problem\
> though an intelligent app can layer monotonicity
> on top of the call I suppose.
>    

Unless it's a multi-process app with limited trust.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

