Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbYJTP43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbYJTP43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 11:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYJTP4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 11:56:21 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:42267 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYJTP4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 11:56:20 -0400
Message-ID: <48FCA97C.1040108@cs.columbia.edu>
Date: Mon, 20 Oct 2008 11:53:32 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Daniel Lezcano <dlezcano@fr.ibm.com>
CC: Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, Andrey Mirkin <major@openvz.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org>	<1224286383.1848.65.camel@nimitz>	<20081020111002.GQ15171@hawkmoon.kerlabs.com> <48FC86B2.8000606@fr.ibm.com>
In-Reply-To: <48FC86B2.8000606@fr.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Daniel Lezcano wrote:
> Louis Rilling wrote:
>> On Fri, Oct 17, 2008 at 04:33:03PM -0700, Dave Hansen wrote:
>>> On Wed, 2008-09-03 at 14:57 +0400, Andrey Mirkin wrote:
>>>> This patchset introduces kernel based checkpointing/restart as it is
>>>> implemented in OpenVZ project. This patchset has limited functionality and
>>>> are able to checkpoint/restart only single process. Recently Oren Laaden
>>>> sent another kernel based implementation of checkpoint/restart. The main
>>>> differences between this patchset and Oren's patchset are:
>>> Hi Andrey,
>>>
>>> I'm curious what you want to happen with this patch set.  Is there
>>> something specific in Oren's set that deficient which you need
>>> implemented?  Are there some technical reasons you prefer this code?
>> To be fair, and since (IIRC) the initial intent was to start with OpenVZ's
>> approach, shouldn't Oren answer the same questions with respect to Andrey's
>> patchset?
>>
>> I'm afraid that we are forgetting to take the best from both approaches...
> 
> I agree with Louis.
> 
> I played with Oren's patchset and tryed to port it on x86_64. I was able 
> to sys_checkpoint/sys_restart but if you remove the restoring of the 
> general registers, the restart still works. I am not an expert on asm, 
> but my hypothesis is when we call sys_checkpoint the registers are saved 
> on the stack by the syscall and when we restore the memory of the 
> process, we restore the stack and the stacked registers are restored 
> when exiting the sys_restart. That make me feel there is an important 
> gap between external checkpoint and internal checkpoint.

This is a misconception: my patches are not "internal checkpoint". My
patches are basically "external checkpoint" by design, which *also*
accommodates self-checkpointing (aka internal). The same holds for the
restart. The implementation is demonstrated with "self-checkpoint" to
avoid complicating things at this early stage of proof-of-concept.

For multiple processes all that is needed is a container and a loop
on the checkpoint side, and a method to recreate processes on the
restart side. Andrew suggests to do it in kernel space, I still have
doubts.

While I held out the multi-process part of the patch so far because I
was explicitly asked to do it, it seems like this would be a good time
to push it out and get feedback.

> 
> Dmitry's patchset is nice too, but IMO, it goes too far from what we 
> decided to do at the container mini-summit. I think there are a lot of 
> design questions to be solved before going further.
> 
> IMHO we should look at Dmitry patchset and merge the external checkpoint 
> code to Oren's patchset in order to checkpoint *one* process and have 
> the process to restart itself. At this point, we can begin to talk about 
> the restart itself, shall we have the kernel to fork the processes to be 
> restarted ? shall we fork from userspace and implement some mechanism to 
> have each processes to restart themselves ? etc...
> 

In both approaches, processes restart themselves, in the sense that a
process to be restarted eventually calls "do_restart()" (or equivalent).

The only question is how processes are created. Andrew's patch creates
everything inside the kernel. I would like to still give it a try outside
the kernel. Everything is ready, except that we need a way to pre-select
a PID for the new child... we never agreed on that one, did we ?

If we go ahead with the kernel-based process creation, it's easy to merge
it to the current patch-set.

Oren.

