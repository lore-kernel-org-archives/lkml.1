Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbYJTQjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbYJTQjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYJTQjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:39:44 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:37850 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYJTQjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:39:43 -0400
Message-ID: <48FCB3CC.9030804@fr.ibm.com>
Date: Mon, 20 Oct 2008 18:37:32 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Oren Laadan <orenl@cs.columbia.edu>
CC: Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, Andrey Mirkin <major@openvz.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org>	<1224286383.1848.65.camel@nimitz>	<20081020111002.GQ15171@hawkmoon.kerlabs.com> <48FC86B2.8000606@fr.ibm.com> <48FCA97C.1040108@cs.columbia.edu>
In-Reply-To: <48FCA97C.1040108@cs.columbia.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oren Laadan wrote:
> 
> Daniel Lezcano wrote:
>> Louis Rilling wrote:
>>> On Fri, Oct 17, 2008 at 04:33:03PM -0700, Dave Hansen wrote:
>>>> On Wed, 2008-09-03 at 14:57 +0400, Andrey Mirkin wrote:
>>>>> This patchset introduces kernel based checkpointing/restart as it is
>>>>> implemented in OpenVZ project. This patchset has limited functionality and
>>>>> are able to checkpoint/restart only single process. Recently Oren Laaden
>>>>> sent another kernel based implementation of checkpoint/restart. The main
>>>>> differences between this patchset and Oren's patchset are:
>>>> Hi Andrey,
>>>>
>>>> I'm curious what you want to happen with this patch set.  Is there
>>>> something specific in Oren's set that deficient which you need
>>>> implemented?  Are there some technical reasons you prefer this code?
>>> To be fair, and since (IIRC) the initial intent was to start with OpenVZ's
>>> approach, shouldn't Oren answer the same questions with respect to Andrey's
>>> patchset?
>>>
>>> I'm afraid that we are forgetting to take the best from both approaches...
>> I agree with Louis.
>>
>> I played with Oren's patchset and tryed to port it on x86_64. I was able 
>> to sys_checkpoint/sys_restart but if you remove the restoring of the 
>> general registers, the restart still works. I am not an expert on asm, 
>> but my hypothesis is when we call sys_checkpoint the registers are saved 
>> on the stack by the syscall and when we restore the memory of the 
>> process, we restore the stack and the stacked registers are restored 
>> when exiting the sys_restart. That make me feel there is an important 
>> gap between external checkpoint and internal checkpoint.
> 
> This is a misconception: my patches are not "internal checkpoint". My
> patches are basically "external checkpoint" by design, which *also*
> accommodates self-checkpointing (aka internal). The same holds for the
> restart. The implementation is demonstrated with "self-checkpoint" to
> avoid complicating things at this early stage of proof-of-concept.

Yep, I read your patchset :)

I just want to clarify what we want to demonstrate with this patchset 
for the proof-of-concept ? A self CR does not show what are the 
complicate parts of the CR, we are just showing we can dump the memory 
from the kernel and do setcontext/getcontext.

We state at the container mini-summit on an approach:

    1. Pre-dump
    2. Freeze the container
    3. Dump
    4. Thaw/Kill the container
    5. Post-dump

We already have the freezer, and we can forget for now pre-dump and 
post-dump.

IMHO, for the proof-of-concept we should do a minimal CR (like you did), 
but conforming with these 5 points, but that means we have to do an 
external checkpoint.

If the POC conforms with that, the patchset will be a little different 
and that will show what are the difficult part for restarting a process, 
especially to restart it at the frozen state :) and that will give an 
idea from 10000 feets of the big picture.

> For multiple processes all that is needed is a container and a loop
> on the checkpoint side, and a method to recreate processes on the
> restart side. Andrew suggests to do it in kernel space, I still have
> doubts.

A question to Andrey, do you, in OpenVZ, restart "externally" or it is 
the first process of the pid namespace which calls sys_restart and then 
  populates the pid namespace ?

> While I held out the multi-process part of the patch so far because I
> was explicitly asked to do it, it seems like this would be a good time
> to push it out and get feedback.

IMHO it is too soon...

