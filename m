Return-Path: <linux-kernel-owner+w=401wt.eu-S1762939AbXKPRSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762939AbXKPRSD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbXKPRRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:17:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951AbXKPRRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:17:55 -0500
Message-ID: <473DCFA3.3020203@redhat.com>
Date: Fri, 16 Nov 2007 12:13:07 -0500
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Stephane Eranian <eranian@hpl.hp.com>, Philip Mucci <mucci@cs.utk.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: perfmon2 merge news
References: <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org> <20071113203645.GA17145@one.firstfloor.org> <9FF72994-F55A-4B36-9EAA-CB1D2360A6F5@cs.utk.edu> <20071114015210.GA20365@one.firstfloor.org> <A42C2398-2EAB-460C-95C7-686A34A76F82@cs.utk.edu> <p737ikicjbn.fsf@bingen.suse.de> <20071116160056.GF10616@frankl.hpl.hp.com> <20071116162813.GA29644@one.firstfloor.org>
In-Reply-To: <20071116162813.GA29644@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Fri, Nov 16, 2007 at 08:00:56AM -0800, Stephane Eranian wrote:
>> No, he is talking about something similar to what was in perfctr.
>> The kernel emulates 64-bit counters in software and that is you
>> get back when you read the counters. If you read via RDPMC, you
>> get 40 bits. To reconstruct the full 64-bit value from user land
>> you need the upper bits. One approach is for the kernel to allow
>> you to remap a page that has the 64-bit (software) counters. With
>> that and a bit of mask/shifting you can reconstruct the full value.
> 
> You mean the page contains the upper [40;63] bits? 
> 
> Sounds reasonable, although I don't remember seeing that when I looked
> at the perfmon code last.

Upper 32-bit ([32:63]). On many implementations the only lower 32-bit are 
available in the register. the 32:40 bits in several processor implementation of 
x86 processors can not be set to bit outside of sign extension of bit 32. On 
other processor implementations the event counters are only 32-bit in width.

> 
>>> I'm considering that an essential feature too. I wasn't aware
>>> it was dropped.
>>>
>> What I dropped is the cr4.pce enabled for self-monitoring sessions.
> 
> That sounds bad.
> 
>> Perfmon2 allows you to have an in-kernel sampling buffer. The idea is
> 
> ... you also didn't say *why* that is needed.
> 
> Can you give a concrete use case for something that cannot be done
> without custom buffer formats? 
> 
>> Using this mechanism, for instance, we were able to connect the
>> Oprofile kernel code to perfmon2 on Itanium with a 100 lines of
>> code. The exact same approach would also work on X86 Oprofile as well.
> 
> The existing oprofile code works already fine on x86, no real
> need for another one.

OProfile is very useful in many cases, but it only perform sampling. If one want 
to take a look at the number events a specific section of code causes, one can't 
really do that with oprofile. The counters are running systemwide, not per 
thread. For some experiments developers really like to have per thread counters.

The rewrite of oprofile to use the perfmon code was to consolidate code using 
the performance monitoring hardware. Use one interface for accessing the 
performance monitoring hardware rather than have one for sampling and another 
for virtualizing the counters on a per thread basis.

>>> e.g. PEBS and so on pretty much fix the in memory sample format in hardware,
>>> so they only way to get a custom format would be to use a separate buffer.
>>>
>> This is also how we support PEBS because, as you said, the format of the
>> samples is not under your control. if you want zero-copy PEBS support,
>> you have to follow the PEBS format.
> 
> Exactly that makes the support for random custom buffers questionable.
> 
> e.g. as I can see the main advantage of perfmon over existing setups
> is that it support PEBS etc., but with your custom buffer formats which
> are by definition incompatible with PEBS you would negate that advantage
> again.
> 
> Ok IBS will probably need some special handling.
> 
>> Yes, you could do that without changing the core implementation of
>> perfmon2.
> 
> Why this insistence against changing anything?
> 
> -Andi

So the alternative approach is to write a new device driver for each of the new 
performance monitoring mechanisms, e.g. one for PEBS and another for IBS?

One of the reason for the custom sample buffers was to avoid having an expensive 
user-space signal for a process to record some simple pieces of data each time 
the data becomes available. For the oprofile port to the perfmon2 custom buffer 
  mechanism the instruction pointer and the counter that overflowed are 
recorded. The buffer can be processed in one large chunk by userspace, reducing 
overhead. In essence the current implementation of OProfile in the mainline 
kernels has a custom buffer mechanism.

-Will

