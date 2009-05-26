Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbZEZTmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbZEZTmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbZEZTmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:42:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41009 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248AbZEZTmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:42:42 -0400
Message-ID: <4A1C45CE.3010807@redhat.com>
Date: Tue, 26 May 2009 22:41:02 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: George Dunlap <George.Dunlap@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keir Fraser <keir.fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Xen-devel] Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default>
In-Reply-To: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Magenheimer wrote:
>> It will also be 
>> interesting to see how far Xen can get along without real memory 
>> management (overcommit).
>>     
>
> Several implementations of "classic" memory overcommit have been
> done for Xen, most recently the Difference Engine work at UCSD.
> It is true that none have been merged yet, in part because,
> in many real world environments, "generalized" overcommit
> often leads to hypervisor swapping, and performance becomes
> unacceptable.  (In other words, except in certain limited customer
> use models, memory overcommit is a "marketing feature".)
>   

Swapping indeed drags performance down horribly.  I regard it as a last 
resort solution used when everything else (page sharing, compression, 
ballooning, live migration) has failed.  By having that last resort you 
can actually use the other methods without fearing an out-of-memory 
condition eventually.

Note that with SSDs disks have started to narrow the gap between memory 
and secondary storage access times, so swapping will actually start 
improving rather than regressing as it has done in recent times.

> There's also a novel approach, Transcendent Memory (aka "tmem"
> see http://oss.oracle.com/projects/tmem).  Though tmem requires the
> guest to participate in memory management decisions (thus requiring
> a Linux patch), system-wide physical memory efficiency may
> improve vs memory deduplication, and hypervisor-based swapping
> is not necessary.
>   

Yes, I've seen that.  Another tool in the memory management arsenal.

>   
>> The Linux scheduler already supports multiple scheduling 
>> classes.  If we 
>> find that none of them will fit our needs, we'll propose a new one.  
>> When the need can be demonstrated to be real, and the 
>> implementation can 
>> be clean, Linux can usually be adapted.
>>     
>
> But that's exactly George and Jeremy's point.  KVM will
> eventually require changes that clutter Linux for purposes
> that are relevant only to a hypervisor.
>   

kvm has already made changes to Linux.  Preemption notifiers allow us to 
have a lightweight exit path, and mmu notifiers allow the Linux mmu to 
control the kvm mmu.  And in fact mmu notifiers have proven useful to 
device drivers.

It also works the other way around; for example work on cpu controllers 
will benefit kvm, and the real-time scheduler will also apply to kvm 
guests.  In fact many scheduler and memory management features 
immediately apply to kvm, usually without any need for integration.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

