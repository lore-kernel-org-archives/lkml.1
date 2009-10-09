Return-Path: <linux-kernel-owner+w=401wt.eu-S933696AbZJIPuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696AbZJIPuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933516AbZJIPuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:50:12 -0400
Received: from omr15.networksolutionsemail.com ([205.178.146.65]:50337 "EHLO
	omr15.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933464AbZJIPuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:50:11 -0400
Message-Id: <BD8F08D3-871B-45CF-B588-489E09ADA70C@kayser.net>
From: Donald Kayser <linux@kayser.net>
To: linuxppc-dev@ozlabs.org, linuxkernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200910091550.25032.arnd@arndb.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: ppc_md.SMI replacement for 2.6
Date: Fri, 9 Oct 2009 10:49:24 -0500
References: <61241B44-32BD-4708-954F-AEE7560382DE@kayser.net> <7AD77164-8476-4138-A390-B604CD18A221@kayser.net> <449C2FDE-42DD-490C-8288-CF03224BDA34@kayser.net> <200910091550.25032.arnd@arndb.de>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have more information on this PPC HPPB target. I compared the  
EXCEPTION macro between 2.4 and 2.6 with respect to SMI Exceptions. I  
noticed that in the 2.4 kernel a macro named STD_EXCEPTION was used  
and in the 2.6 kernel their is a new EXCEPTION macro structure. In the  
2.6 kernel, it is much different, but with the TAUException I noticed  
that it used an EXC_XFER_STD instead of EXC_XFER_EE, so I tried it and  
with great news, I am actually getting the exceptions correctly now.

My question to anyone who understands is: is it OK to change the line  
in arch/powerpc/kernel/head_32.S from

EXCEPTION(0x1400, SMI, SMIException, EXC_XFER_EE)

to

EXCEPTION(0x1400, SMI, SMIException, EXC_XFER_STD)

I have not decoded assembler to determine the exact differences, and I  
will do so, but I wanted to know if there was anyone who knew why this  
would make my SMI interrupt behave correctly.

Also, as noted earlier in this post, there is no hook for notification  
of the SMI. The vendor who did the 2.4 port provided his own hook  
through ppc_md global variable. Would anyone care to suggest the 'best/ 
preferred' method to provide a callback to the SMI Exception.

Thanks
Donald
linux@kayser.net

On Oct 9, 2009, at 8:50 AM, Arnd Bergmann wrote:

> On Friday 09 October 2009, Donald Kayser wrote:
>> On further comparison, this section of code has been added by the
>> vendor that actually ported linux 2.4 to this PPC HPPB target. So, if
>> anyone would like to lend a thought towards System Managment
>> Exceptions on PPC, please cc me at linux@kayser.net. I will be
>> stopping the subscription to this list shortly. Regards, Donald
>
> Hi Donald,
>
> You should ask ppc specific questions on the linuxppc-dev@ozlabs.org
> mailing list instead of the global linux-kernel list to increase the
> chances of someone reading it who knows the answer.
>
> The world of powerpc linux has changed a lot since 2.4, as you
> undoubtedly found out. You are certainly encouraged to submit
> your platform code for inclusion in the mainline kernel (if you
> can do the usual cleanups necessary to do that), even for
> old code.
>
> I don't know a specific reason why the SMI callback was removed,
> but I would guess that if you have a platform that requires it
> and want it in the mainline kernel, a callback for it can be
> added back, either through ppc_md or some other method.
>
> 	Arnd <><
>
>> On Oct 8, 2009, at 8:37 AM, Donald Kayser wrote:
>>
>>> I have found the differences between the 2.4 and 2.6 kernel. It is
>>> in linux-2.4/arch/ppc/kernel/traps.c and linux-2.6/arch/powerpc/
>>> kernel/traps.c in the function SMIException(). There is no longer
>>> the code segment
>>>
>>> if (ppc_md.SMI)
>>> {
>>> ppc_md.SMI(regs);
>>> return;
>>> }
>>>
>>> There is now only a
>>>
>>> die("System Management Interrupt", regs, SIGABRT);
>>>
>>> I am guessing that the SMI callback is no longer needed by the linux
>>> community at large, so I modified the code for my specific hardware
>>> (HPPB) and acknowledged the exception as in the 2.4 kernel, and
>>> returned from the exception without the call to die(). My problem
>>> now is that it doesn't seem to work. Does anyone have a reason why
>>> the SMI exception might hang the system when it has been provided a
>>> handler?
>>>
>>> Thanks in advance.
>>>
>>> Donald Kayser
>>>
>>> On Oct 7, 2009, at 10:06 AM, Donald Kayser wrote:
>>>
>>>> I have ported the 2.6 kernel to an embedded PPC target (old stuff).
>>>> I have managed to figure everything out, but can't find any
>>>> replacement for a SMI handler. The original 2.4 version for this
>>>> target has a bit of code ppc_md.SMI == SmiFuncHandler; I have not
>>>> been able to find in the current source anything like this. I am
>>>> not certain that I need to provide a handler at all, but the
>>>> original developers saw some reason for including it. The
>>>> particular handler does not do anything more than cancel a watchdog
>>>> listener for this specific target. I have been living without the
>>>> handler, but would like to find any kind of replacement if it is
>>>> supported.
>>>>
>>>> Thanks,
>>>> Donald Kayser
>>>> linux@kayser.net
>
>

