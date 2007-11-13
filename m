Return-Path: <linux-kernel-owner+w=401wt.eu-S1761337AbXKMTSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761337AbXKMTSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbXKMTSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:18:22 -0500
Received: from shu.cs.utk.edu ([160.36.56.39]:56768 "EHLO shu.cs.utk.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756739AbXKMTSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:18:21 -0500
X-Greylist: delayed 1820 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2007 14:18:21 EST
In-Reply-To: <20071113175545.GD4319@frankl.hpl.hp.com>
References: <20071107003454.GA13374@kroah.com> <20071109120627.60ec9ab4.akpm@linux-foundation.org> <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu>
Cc: William Cohen <wcohen@redhat.com>, akpm@osdl.org,
       Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, Perfmon <perfmon@napali.hpl.hp.com>,
       Andi Kleen <andi@firstfloor.org>, perfmon2-devel@lists.sourceforge.net,
       OSPAT devel <ospat-devel@cs.utk.edu>,
       papi list <ptools-perfapi@cs.utk.edu>
Content-Transfer-Encoding: 7bit
From: Philip Mucci <mucci@cs.utk.edu>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Date: Tue, 13 Nov 2007 10:47:45 -0800
To: eranian@hpl.hp.com
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Well, I can say the mood here at supercomputing'07 is pretty somber  
in regards to the latest exchange of messages regarding the perfmon  
patches. Our community has been the largest user of both the PerfCtr  
and the Perfmon patches, the former being regularly installed by  
vendors and integrators on clusters at install time, and the latter  
now being adopted into vendor kernels by IBM, Cray, AMD, SiCortex and  
others. Of course, adoption by a vendor, does not a good kernel patch  
make. However, it should be viewed as a strong data point on demand  
for such functionality. We are a community focused on performance and  
we have long had a need for these tools.

A solution that does not provide 64 bit virtualized per-thread counts  
is not a solution at all. That would need to be ripped out by all of  
us using this functionality so we could get something that actually  
does what the community needs, not what the you folks think we need.  
Device level access and/or root access to the counters is not  
unacceptable for machines in production. If that was fine, oprofile  
would have satisfied everyone and we wouldn't be sucking up your  
bandwidth. Please understand that people outside of the your  
community are desperate for adoption of any form of 'per-thread' PMU  
functionality into the kernel. For those of you who are (still) not  
convinced of this, I can arrange your inbox to be spammed by 1000's  
of HPC geeks, managers, vendors, etc. My point is, let's start  
somewhere that the community finds useful. Otherwise we run the risk  
of developing an interface that everyone isn't comfortable with and  
no-one uses. Hardly a productive exercise.

So please, do consider a set of core functionality that provides for  
(at least) the following:

- per-CPU and per-thread 64 bit virtualized counts
- third person operation (attach/ptrace)
- dispatch of signal upon interrupt on overflow if requested
- 'buffered' interrupts into a buffer that can be mmap'd into user space
- support for a variety of the major processor platforms

Regards,


On Nov 13, 2007, at 9:55 AM, Stephane Eranian wrote:

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
>>>
>>> Perhaps a core could provide also as much functionality so that
>>> Perfmon can be used with an *unpatched* kernel using loadable  
>>> modules?
>>> One drawback with today's Perfmon is that it can not be used with a
>>> vanilla kernel. But maybe such a core is by far too complex for a
>>> first merge.
>>>
>>> -Robert
>>>
>>
>> Hi Robert,
>>
>> In the past I suggested that it might be useful to have a version  
>> of perfmon2
>> that only set up the perfmon on a global basis. That would allow  
>> the patches for
>> context switches to be added as a separate step, splitting up the  
>> patch into
>> smaller set of patches.
>>
>> Perfmon2 uses a set of system calls to control the performance  
>> monitoring
>> hardware. This would make it difficult to use an unpatch kernel  
>> unless perfmon
>> changed the mechanism used to control the performance monitoring  
>> hardware.
>>
> Yes, that would be a possibility but as you pointed out there are  
> some problems:
>
> 	- perfmon2 uses system calls. So unless you can dynamically patch the
> 	  syscall table we would have to go back to the ioctl() and driver  
> model.
> 	  I was under the impression that people did not quite like  
> multiplexing
> 	  syscalls such as ioctl(). I also do prefer the multi syscall  
> approach.
>
> 	- perfmon2 needs to install a PMU interrupt handler. On X86, this  
> is not just
> 	  an external device interrupts. There needs to be some APIC and  
> interrupt
> 	  gate setup. There maybe other constraints on other architectures  
> as well.
> 	  Not sure if all functions/structures necessary for this are  
> available to
> 	  modules.
>
> 	- we could not support per-thread mode with the kernel module  
> approach due to
> 	  link to the context switch code. I do believe per-thread is a  
> key value-add
> 	  for performance monitoring.
>
> -- 
> -Stephane
> _______________________________________________
> perfmon mailing list
> perfmon@linux.hpl.hp.com
> http://www.hpl.hp.com/hosted/linux/mail-archives/perfmon/

