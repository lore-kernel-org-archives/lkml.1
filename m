Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbYIEOvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbYIEOvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYIEOvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:51:42 -0400
Received: from gw.goop.org ([64.81.55.164]:32880 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbYIEOvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:51:42 -0400
Message-ID: <48C1477B.6060500@goop.org>
Date: Fri, 05 Sep 2008 07:51:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Eric Lacombe <tuxiko@free.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: [x86] fs, gs purpose & multicore prog
References: <200809031109.45660.goretux@gmail.com> <48C011A6.2000609@goop.org> <200809051317.11116.goretux@gmail.com>
In-Reply-To: <200809051317.11116.goretux@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Lacombe wrote:
> So, %gs is not used in 32-bit kernel and %fs is not used in 64-bit kernel. Is 
> it right ? Why there were different choices of design ?
>   

They both use the opposite from what their respective usermodes use for
thread local storage, since there may be a slight performance advantage
to doing so (at least on 32-bit).  32-bit's use of %gs for usermode TLS
is old and arbitrary, probably predating x86-64 (at least its wide
availability).  The use of %gs for kernel per-cpu data is architectural
on 64-bit, because of the "swapgs" instruction; there's no "swapfs"
instruction.

>>> - When I do a "mov %fs ..." instruction (in a module), it seems that %fs
>>> is equal to 0 (idem for %gs). Are these registers not always filled ?
>>>       
>> On 32-bit they will always have a value, or you'll get a GPF.  On 64-bit
>> the value of the selector doesn't matter because the MSRs are the real
>> content.
>>     
>
> ok, but what about the limits and access types?
>   

They don't exist in 64-bit.  The GDT contains them, but they're not
enforced.

>>> - What is the purpose of MSR_FS_BASE and MSR_GS_BASE ?
>>> (I thought they were filled with "gdt[fs_entry].base")
>>>       
>> On 64-bit, the GDT isn't large enough to hold a 64-bit offset, so it
>> only stores the low 32-bits.  When you load a segment register with a
>> selector, it picks up from the gdt.  If you want a full 64-bit offset,
>> you need to write it to the msr.
>>     
>
> Ok, I just saw that a 64-bit base in segment descriptor is only available for 
> the system descriptor.
>   

Yes, the IDT has double-wide entries to fit 64-bit values, but they
didn't extend that to the GDT.  Or something - I last looked at this a
couple of months ago, and it never sticks in my brain for long.

> Ok, but how does the kernel technically run tasks on different processor (or 
> core)? My question was ambiguous, I was not assuming that I knew how 
> multiprocessor works.
>   

That's a very broad question.  A good proportion of the core kernel code
is dedicated to doing just that.  Very roughly, at boot time it brings
up all the cpus, and they more or less run independently each looking
for work to do in the form of processes waiting to run on the run
queue.  They collectively run the scheduler algorithms to work out who
runs what when; almost everything run in the kernel is a task - both
usermode processes and kernel threads.  Except for the stuff which isn't.

    J
