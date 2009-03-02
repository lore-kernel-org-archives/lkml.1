Return-Path: <linux-kernel-owner+w=401wt.eu-S1759245AbZCBJFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbZCBJFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 04:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZCBJF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 04:05:26 -0500
Received: from gw.goop.org ([64.81.55.164]:40535 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbZCBJFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 04:05:25 -0500
Message-ID: <49ABA151.5050302@goop.org>
Date: Mon, 02 Mar 2009 01:05:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <200903021737.24903.nickpiggin@yahoo.com.au> <49AB9336.7010103@goop.org> <200903021919.30068.nickpiggin@yahoo.com.au>
In-Reply-To: <200903021919.30068.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>> I wouldn't say that KVM is necessarily disadvantaged by its design; its
>> just a particular set of tradeoffs made up-front.  It loses Xen's
>> flexibility, but the result is very familiar to Linux people.  A guest
>> domain just looks like a qemu process that happens to run in a strange
>> processor mode a lot of the time.  The qemu process provides virtual
>> device access to its domain, and accesses the normal device drivers like
>> any other usermode process would.  The domains are as isolated from each
>> other as much as processes normally are, but they're all floating around
>> in the same kernel; whether that provides enough isolation for whatever
>> technical, billing, security, compliance/regulatory or other
>> requirements you have is up to the user to judge.
>>     
>
> Well what is the advantage of KVM? Just that it is integrated into
> the kernel? Can we look at the argument the other way around and
> ask why Xen can't replace KVM?

Xen was around before KVM was even a twinkle, so KVM is redundant from 
that perspective; they're certainly broadly equivalent in 
functionality.  But Xen has had a fairly fraught history with respect to 
being merged into the kernel, and being merged gets your feet into a lot 
of doors.  The upshot is that using Xen has generally required some 
preparation - like installing special kernels - before you can use it, 
and so tends to get used for servers which are specifically intended to 
be virtualized.  KVM runs like an accelerated qemu, so it easy to just 
fire up an instance of windows in the middle of a normal Linux desktop 
session, with no special preparation.

But Xen is getting better at being on laptops and desktops, and doing 
all the things people expect there (power management, suspend/resume, 
etc).  And people are definitely interested in using KVM in server 
environments, so the lines are not very clear any more.

(Of course, we're completely forgetting VMI in all this, but VMware seem 
to have as well.  And we're all waiting for Rusty to make his World 
Domination move.)

>  (is it possible to make use of HW
> memory virtualization in Xen?)

Yes, Xen will use all available hardware features when running hvm 
domains (== fully virtualized == Windows).

>  The hypervisor is GPL, right?
>   

Yep.

>>>  Would it be possible I wonder to make
>>> a MMU virtualization layer for CPUs without support, using Xen's page
>>> table protection methods, and have KVM use that? Or does that amount
>>> to putting a significant amount of Xen hypervisor into the kernel..?
>>>       
>> At one point Avi was considering doing it, but I don't think he ever
>> made any real effort in that direction.  KVM is pretty wedded to having
>> hardware support anyway, so there's not much point in removing it in
>> this one area.
>>     
>
> Not removing it, but making it available as an alternative form of
> "hardware supported" MMU virtualization. As you say if direct protected
> page tables often are faster than existing HW solutoins anyway, then it
> could be a win for KVM even on newer CPUs.
>   

Well, yes.  I'm sure it will make someone a nice little project.  It 
should be fairly easy to try out - all the hooks are in place, so its 
just a matter of implementing the kvm bits.  But it probably wouldn't be 
a comfortable fit with the rest of Linux; all the memory mapped via 
direct pagetables would be solidly pinned down, completely unswappable, 
giving the VM subsystem much less flexibility about allocating 
resources.  I guess it would be no worse than a multi-hundred 
megabyte/gigabyte process mlocking itself down, but I don't know if 
anyone actually does that.

    J
