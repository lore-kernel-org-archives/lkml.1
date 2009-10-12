Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbZJLSbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbZJLSbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbZJLSbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:31:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbZJLSbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:31:36 -0400
Message-ID: <4AD375A5.8050205@redhat.com>
Date: Mon, 12 Oct 2009 20:29:57 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
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
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com>	<4ACB0833.2050203@redhat.com> <4ACB9074.1000804@goop.org>	<4ACC6C9C.7080707@redhat.com> <4ACFD43E.6000506@goop.org> <4AD0CDFB.9030704@redhat.com> <4AD3738B.6050200@goop.org>
In-Reply-To: <4AD3738B.6050200@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2009 08:20 PM, Jeremy Fitzhardinge wrote:
> On 10/10/09 11:10, Avi Kivity wrote:
>    
>> On 10/10/2009 02:24 AM, Jeremy Fitzhardinge wrote:
>>      
>>> On 10/07/09 03:25, Avi Kivity wrote:
>>>
>>>        
>>>> def try_pvclock_vtime():
>>>>     tsc, p0 = rdtscp()
>>>>     v0 = pvclock[p0].version
>>>>     tsc, p = rdtscp()
>>>>     t = pvclock_time(pvclock[p], tsc)
>>>>     if p != p0 or pvclock[p].version != v0:
>>>>        raise Exception("Processor or timebased change under our feet")
>>>>     return t
>>>>          
> There's a second problem:  If the time_info gets updated between the
> first rdtscp and the first version fetch, then we won't have a
> consistent tsc,time_info pair.  You could check if tsc_timestamp is>
> tsc, but that won't necessarily work on save/restore/migrate.
>    

Good catch.  Doesn't that invalidate rdtscp based vgettimeofday on 
non-virt as well (assuming p == cpu)?

> I suppose that works if you assume that:
>
>     1. every task->vcpu migration is associated with a hv/guest context
>        switch, and
>     2. every hv/guest context switch is a write barrier
>
> I guess 2 is a given, but I can at least imagine cases where 1 might not
> be true.  Maybe.  It all seems very subtle.
>    

What is 1 exactly?  task switching to another vcpu?  that doesn't incur 
hypervisor involvement.  vcpu moving to another cpu?  That does.

> And I don't really see a gain.  You avoid maintaining a second version
> number, but at the cost of two rdtscps.  In my measurements, the whole
> vsyscall takes around 100ns to run, and a single rdtsc takes about 30,
> so 30% of total.  Unlike rdtsc, rdtscp is documented as being ordered in
> the instruction stream, and so will take at least as long; two of them
> will completely blow the vsyscall execution time.
>    

I agree, let's stick with the rdtscpless implementation.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

