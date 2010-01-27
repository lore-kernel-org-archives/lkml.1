Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716Ab0A0Mfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab0A0Mfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 07:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394Ab0A0Mfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 07:35:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab0A0Mff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 07:35:35 -0500
Message-ID: <4B6032E7.1090900@redhat.com>
Date: Wed, 27 Jan 2010 10:34:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Borislav Petkov <petkovbb@googlemail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org, tglx@linutronix.de,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-tip-commits@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Aristeu Rozanski <aris@redhat.com>, Doug Thompson <norsk5@yahoo.com>,
       Huang Ying <ying.huang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to mce_cpu_specific_poll
References: <20100121221711.GA8242@basil.fritz.box> <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org> <20100123051717.GA26471@elte.hu> <20100123075851.GA7098@liondog.tnic> <20100123090003.GA20056@elte.hu>
In-Reply-To: <20100123090003.GA20056@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Borislav Petkov <petkovbb@googlemail.com> wrote:
> 
>> (Adding some more interested parties to Cc:)
>>
>> On Sat, Jan 23, 2010 at 06:17:17AM +0100, Ingo Molnar wrote:
>>> * tip-bot for H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>>> Commit-ID:  f91c4d2649531cc36e10c6bc0f92d0f99116b209
>>>> Gitweb:     http://git.kernel.org/tip/f91c4d2649531cc36e10c6bc0f92d0f99116b209
>>>> Author:     H. Peter Anvin <hpa@zytor.com>
>>>> AuthorDate: Thu, 21 Jan 2010 18:31:54 -0800
>>>> Committer:  H. Peter Anvin <hpa@zytor.com>
>>>> CommitDate: Thu, 21 Jan 2010 18:31:54 -0800
>>>>
>>>> x86, mce: Rename cpu_specific_poll to mce_cpu_specific_poll
>>>>
>>>> cpu_specific_poll is a global variable, and it should have a global
>>>> namespace name.  Since it is MCE-specific (it takes a struct mce *),
>>>> rename it mce_cpu_specific_poll.
>>>>
>>>> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>>>> Cc: Andi Kleen <andi@firstfloor.org>
>>>> LKML-Reference: <20100121221711.GA8242@basil.fritz.box>
>>> FYI, this commit triggered a -tip test failure:
>>>
>>>  arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c: In function 'xeon75xx_mce_init':
>>>  arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c:340: error: implicit declaration of function 'pci_match_id'
>>>
>>> I'm excluding it from tip:master.
>>>
>>> But the bigger problem with this commit is structure of it - or the lack 
>>> thereof.
>>>
>>> It just blindly goes into the direction the MCE code has been going for some 
>>> time, minimally enabling the hardware, ignoring both the new EDAC design and 
>>> the new performance monitoring related design i outlined some time ago.
>> I completely agree - from what I see this is adding vendor- or rather 
>> vendor-and-machine-specific hooks to read out (1) the position of the the 
>> memory translation table from PCI config space (0x8c), (2) then to read out 
>> the offset from the first MCA status register in order to (3) rdmsr the 
>> status information.
>>
>> In AMD's case, we need similar hooks too, in order to evaluate correctable 
>> MCEs for different RAS reasons like for example L3 cache or data arrays 
>> errors for disabling L3 indices. I was looking into adding hooks into 
>> machine_check_poll() and cpu_specific_poll() interface could work.
>>
>> Furthermore, lets leave mcheck be mcheck and do error decoding in EDAC 
>> modules. For example, there was a core i7 EDAC module submission from Mauro 
>> and the Xeon75xx-specific decoding bits could be added to it or even as a 
>> new machine-specific module instead of mcelog.
>>
>> With the evergrowing complexity of memory controller design I don't think 
>> that the userspace mcelog approach will scale - you need the whole decoding 
>> in the kernel where the module knows the exact memory controllers setup and 
>> which DRAM addresses belong to which nodes and whether you do memory 
>> hoisting and whether you interleave, if yes, how and on what granilarity you 
>> interleave and on and on...
> 
> Yep. Could you give a few pointers to Andi where exactly you'd like to see the 
> Intel Xeon functionality added to the EDAC code? There is some Intel 
> functionality there already, but the current upstream code does not look very 
> uptodate. I've looked at e752x_edac.c. (there's some Corei7 work pending, 
> right?) In any case there's a lot of fixing to be done to the Intel code 
> there.

The i7core_edac driver covers the Nehalem chipsets. It is at:
	http://git.kernel.org/?p=linux/kernel/git/mchehab/i7core.git

The error decoding is done by i7core_mce_output_error(). If Xeon 75xx needs to do
something different, it is just a matter of calling a function there, to retrieve
the values from the proper registers.

In order to avoid duplication at the code, the driver is receiving the error events
from the mcelog driver, and having two drivers fighting to access the same error
registers at the same time, this driver relies on mce driver to send the events.

I expect to allocate some time to put the driver into a better shape for
upstream submission soon.

> Memory controller functionality integrated into the kernel proper is a good 
> idea partly for similar reasons an on-die memory controller is a good idea in 
> the hardware space.

I agree. The EDAC module handles memory errors for several memory controllers,
including some on non-x86 architectures. Letting this decode to happen outside
the kernel, just for a very few set of memory controllers, seems a bad idea.

Cheers,
Mauro.
