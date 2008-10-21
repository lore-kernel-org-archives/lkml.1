Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbYJUNZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbYJUNZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 09:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYJUNZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 09:25:22 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:57562 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYJUNZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 09:25:21 -0400
Message-ID: <48FDD815.2080609@fr.ibm.com>
Date: Tue, 21 Oct 2008 15:24:37 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Oren Laadan <orenl@cs.columbia.edu>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, Louis.Rilling@kerlabs.com,
       containers@lists.linux-foundation.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrey Mirkin <major@openvz.org>
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org> <1224286383.1848.65.camel@nimitz> <20081020111002.GQ15171@hawkmoon.kerlabs.com> <48FC86B2.8000606@fr.ibm.com> <48FCA97C.1040108@cs.columbia.edu> <48FCB3CC.9030804@fr.ibm.com> <20081020172358.GA29092@us.ibm.com> <48FD1FBC.5050408@cs.columbia.edu>
In-Reply-To: <48FD1FBC.5050408@cs.columbia.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oren Laadan wrote:
> 
> Serge E. Hallyn wrote:
>> Quoting Daniel Lezcano (dlezcano@fr.ibm.com):
>>> Oren Laadan wrote:
>>>> Daniel Lezcano wrote:
>>>>> Louis Rilling wrote:
>>>>>> On Fri, Oct 17, 2008 at 04:33:03PM -0700, Dave Hansen wrote:
>>>>>>> On Wed, 2008-09-03 at 14:57 +0400, Andrey Mirkin wrote:
>>>>>>>> This patchset introduces kernel based checkpointing/restart as it is
>>>>>>>> implemented in OpenVZ project. This patchset has limited functionality and
>>>>>>>> are able to checkpoint/restart only single process. Recently Oren Laaden
>>>>>>>> sent another kernel based implementation of checkpoint/restart. The main
>>>>>>>> differences between this patchset and Oren's patchset are:
>>>>>>> Hi Andrey,
>>>>>>>
>>>>>>> I'm curious what you want to happen with this patch set.  Is there
>>>>>>> something specific in Oren's set that deficient which you need
>>>>>>> implemented?  Are there some technical reasons you prefer this code?
>>>>>> To be fair, and since (IIRC) the initial intent was to start with OpenVZ's
>>>>>> approach, shouldn't Oren answer the same questions with respect to Andrey's
>>>>>> patchset?
>>>>>>
>>>>>> I'm afraid that we are forgetting to take the best from both approaches...
>>>>> I agree with Louis.
>>>>>
>>>>> I played with Oren's patchset and tryed to port it on x86_64. I was able 
>>>>> to sys_checkpoint/sys_restart but if you remove the restoring of the 
>>>>> general registers, the restart still works. I am not an expert on asm, 
>>>>> but my hypothesis is when we call sys_checkpoint the registers are saved 
>>>>> on the stack by the syscall and when we restore the memory of the 
>>>>> process, we restore the stack and the stacked registers are restored 
>>>>> when exiting the sys_restart. That make me feel there is an important 
>>>>> gap between external checkpoint and internal checkpoint.
>>>> This is a misconception: my patches are not "internal checkpoint". My
>>>> patches are basically "external checkpoint" by design, which *also*
>>>> accommodates self-checkpointing (aka internal). The same holds for the
>>>> restart. The implementation is demonstrated with "self-checkpoint" to
>>>> avoid complicating things at this early stage of proof-of-concept.
>>> Yep, I read your patchset :)
>>>
>>> I just want to clarify what we want to demonstrate with this patchset 
>>> for the proof-of-concept ? A self CR does not show what are the 
>>> complicate parts of the CR, we are just showing we can dump the memory 
>>> from the kernel and do setcontext/getcontext.
>>>
>>> We state at the container mini-summit on an approach:
>>>
>>>     1. Pre-dump
>>>     2. Freeze the container
>>>     3. Dump
>>>     4. Thaw/Kill the container
>>>     5. Post-dump
>>>
>>> We already have the freezer, and we can forget for now pre-dump and 
>>> post-dump.
>>>
>>> IMHO, for the proof-of-concept we should do a minimal CR (like you did), 
>>> but conforming with these 5 points, but that means we have to do an 
>>> external checkpoint.
>> Right, Oren, iiuc you are insisting that 'external checkpoint' and
>> 'multiple task checkpoint' are the same thing.  But they aren't.
>> Rather, I think that what we say is 'multiple tasks c/r' is what you say
>> should be done from user-space :)
> 
> Then I don't explain myself clearly :)
> 
> The only thing I consider doing in user space is the creation of
> the container, the namespaces and the processes.
> 
> I argue that "external checkpoint of a single process" is very few
> lines of code away from "self checkpoint" that is in v7.
> 
> I'm not sure how you define "external restart" ?  eventually, the
> processes restart themselves. It is a question of how the processes
> are created to begin with.
> 
>> So particularly given that your patchset seems to be in good shape,
>> I'd like to see external checkpoint explicitly supported.  Please
>> just call me a dunce if v7 already works for that.
>>
> 
> It seems like you want a single process to checkpoint a single (other)
> process, and then a single process to start a single (other) process.
> 
> I tried to explicitly avoid dealing with the container (user space ?
> kernel space ?) and with creating new processes (user space ? kernel
> space ?).
> 
> Nevertheless, it's the _same_ code. All that is needed is to make the
> checkpoint syscall refer to the other task instead of self, and the
> restart should create a container and fork there, then call sys_restart.
> 
> I guess instead of repeating this argument over, I will go ahead and
> post a patch on top of v7 to demonstrate this (without a container,
> therefore without preserving the original pid).

Cedric made a patch for the external checkpoint:

http://lxc.sourceforge.net/patches/2.6.27/2.6.27-rc8-lxc1/0035-enable-external-checkpoint.patch

The main difference is you will need to freeze the process because it 
will not block itself via a syscall (there is the freezer patchset).

For the restart, perhaps you can just do a process calling sys_restart 
and so we delay the fork from user/kernel discussion, no ?

