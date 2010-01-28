Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258Ab0A1Uah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab0A1Uah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968Ab0A1Uag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:30:36 -0500
Received: from mail.windriver.com ([147.11.1.11]:52691 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0A1Uag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:30:36 -0500
Message-ID: <4B61F34A.20305@windriver.com>
Date: Thu, 28 Jan 2010 14:27:54 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/4] x86,hw_breakpoint,kgdb: kgdb to usehw_breakpointAPI
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com> <1264480000-6997-2-git-send-email-jason.wessel@windriver.com> <20100128171050.GA18683@nowhere> <4B61CD14.7000901@windriver.com> <20100128200418.GC18683@nowhere>
In-Reply-To: <20100128200418.GC18683@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2010 20:27:53.0864 (UTC) FILETIME=[5EA0C080:01CAA058]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Jan 28, 2010 at 11:44:52AM -0600, Jason Wessel wrote:
>   
>> Frederic Weisbecker wrote:
>>     
>>> Good simplification, but that doesn't appear related to kgdb,
>>> this should be done in a separate patch, for the perf/core tree.
>>>
>>>   
>>>       
>> Specifically this is required so that kgdb can modify the state of dr7
>> by installing and removing breakpoints.  Without this change, on return
>> from the callback the dr7 was not correct.
>>
>> As far as I know, only kgdb was altering the dr registers during a call
>> back..
>>     
>
>
>
> Ok. Well not sure how/where it needs to modify dr7 directly.
>
>   

This is not needed any more with the patch I already followed up with. 


To provide an explanation though, dr7 got updated as a result of
installing some breakpoints while in kgdb while in the call back.   And
that value got squashed by what ever was saved on the stack as a local
in the perf breakpoint handler.

>  
>   
>> I admit I did not test running a kvm instance, so I don't know what kind
>> of conflict there would be here.  I went and further looked at the kvm
>> code, and they call the function for the same reason kgdb does.  They
>> want the original system values back on resuming normal kernel
>> execution.  KVM can modify dr7 or other regs directly on entry for its
>> guest execution.  Kgdb does the same sort of thing so as to prevent the
>> debugger from interrupting itself.
>>     
>
>
>
> You mean kgdb needs to disable dr7 while handling a breakpoint to
> avoid recursion? In this case this is something already done
> from the x86 breakpoint handler.
>
>
>   

True, that is done for the master core, but not the slave cores, which
we stop dead in their tracks with a nmi, so they have not had dr7 zeroed
out.

Obviously we restore it on resume.

>  
>   
>>> Would be nice to have bptype set to the generic flags
>>> we have already in linux/hw_breakpoint.h:
>>>
>>> enum {
>>> 	HW_BREAKPOINT_R = 1,
>>> 	HW_BREAKPOINT_W = 2,
>>> 	HW_BREAKPOINT_X = 4,
>>> };
>>>
>>>
>>>   
>>>       
>> These numbers have to get translated somewhere from the GDB version
>> which it handed off via the gdb serial protocol.  They could be
>> translated in the gdb stub, but for now they are in the arch specific
>> stub.  Or you can choose to use the same numbering scheme as gdb for the
>> breakpoint types and the values could be used directly.
>>     
>
>
>
> Ah ok. Well, translating gdb <-> generic values will make you
> move this code from x86 to core at least.
>
>   


I'll move this to the gdbstub in the next merge window, because it looks
like there might also be other archs that gain the
arch/*/kernel/hw_breakpoint.c.

I can also move the logic for the install / remove to be owned by either
hw_breakpoint.c or the debug core because that will become arch
independent as well as more archs pickup the hw_breakpoint.c methodology.


Thanks,
Jason.
