Return-Path: <linux-kernel-owner+w=401wt.eu-S1760327AbXKMSlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327AbXKMSlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbXKMSlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:41:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbXKMSlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:41:44 -0500
Message-ID: <4739EE13.2090006@redhat.com>
Date: Tue, 13 Nov 2007 13:33:55 -0500
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: eranian@hpl.hp.com
CC: akpm@osdl.org, Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, perfmon@napali.hpl.hp.com,
       Andi Kleen <andi@firstfloor.org>, perfmon2-devel@lists.sourceforge.net
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
References: <20071107003454.GA13374@kroah.com>	<20071109120627.60ec9ab4.akpm@linux-foundation.org>	<20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de>	<20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com>
In-Reply-To: <20071113175545.GD4319@frankl.hpl.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian wrote:
> Hello,
> 
> On Tue, Nov 13, 2007 at 10:35:11AM -0500, William Cohen wrote:
>> Robert Richter wrote:
>>> On 10.11.07 21:32:39, Andi Kleen wrote:
>>>> It would be really good to extract a core perfmon and start with
>>>> that and then add stuff as it makes sense.
>>>>
>>>> e.g. core perfmon could be something simple like just support
>>>> to context switch state and initialize counters in a basic way 
>>>> and perhaps get counter numbers for RDPMC in ring3 on x86[1]
>>> Perhaps a core could provide also as much functionality so that
>>> Perfmon can be used with an *unpatched* kernel using loadable modules?
>>> One drawback with today's Perfmon is that it can not be used with a
>>> vanilla kernel. But maybe such a core is by far too complex for a
>>> first merge.
>>>
>>> -Robert
>>>
>> Hi Robert,
>>
>> In the past I suggested that it might be useful to have a version of perfmon2 
>> that only set up the perfmon on a global basis. That would allow the patches for 
>> context switches to be added as a separate step, splitting up the patch into 
>> smaller set of patches.
>>
>> Perfmon2 uses a set of system calls to control the performance monitoring 
>> hardware. This would make it difficult to use an unpatch kernel unless perfmon 
>> changed the mechanism used to control the performance monitoring hardware.
>>
> Yes, that would be a possibility but as you pointed out there are some problems:
> 
> 	- perfmon2 uses system calls. So unless you can dynamically patch the
> 	  syscall table we would have to go back to the ioctl() and driver model.
> 	  I was under the impression that people did not quite like multiplexing
> 	  syscalls such as ioctl(). I also do prefer the multi syscall approach.
> 
> 	- perfmon2 needs to install a PMU interrupt handler. On X86, this is not just
> 	  an external device interrupts. There needs to be some APIC and interrupt
> 	  gate setup. There maybe other constraints on other architectures as well.
> 	  Not sure if all functions/structures necessary for this are available to
> 	  modules.

The oprofile module can setup a handler for PMU interrupts. This is done in 
archi/x86/oprofile/nmi_int:nmi_cpu_setup().  Other modules could do the same. 
However, it bumps what ever was using the nmi/pmu off, then restores nmi/pmu 
when oprofile is shut down. Maybe the pmu/nmi resource reservation mechanism 
should be another self-contained patch.

> 	- we could not support per-thread mode with the kernel module approach due to
> 	  link to the context switch code. I do believe per-thread is a key value-add
> 	  for performance monitoring.

The per-thread monitoring is useful to a number of people and many people want 
it. The thought was how to break the large perfmon patch into set of smaller 
incremental patches. So it isn't whether to have per-thread pmu virtualization, 
but rather when/how to get it in.

-Will
