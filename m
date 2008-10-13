Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbYJMQPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbYJMQPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbYJMQPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:15:06 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:36825 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbYJMQPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:15:04 -0400
Message-ID: <48F3737B.6070904@cs.columbia.edu>
Date: Mon, 13 Oct 2008 12:12:43 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Dave Hansen <dave@linux.vnet.ibm.com>,
       jeremy@goop.org, arnd@arndb.de, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrey Mirkin <major@openvz.org>
Subject: Re: [RFC v6][PATCH 0/9] Kernel based checkpoint/restart
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu>	<20081009124658.GE2952@elte.hu> <1223557122.11830.14.camel@nimitz>	<20081009131701.GA21112@elte.hu> <1223559246.11830.23.camel@nimitz>	<20081009134415.GA12135@elte.hu> <1223571036.11830.32.camel@nimitz> <20081010153951.GD28977@elte.hu> <48F30315.1070909@fr.ibm.com>
In-Reply-To: <48F30315.1070909@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Cedric Le Goater wrote:
> Ingo Molnar wrote:
>> * Dave Hansen <dave@linux.vnet.ibm.com> wrote:
>>
>>> On Thu, 2008-10-09 at 15:44 +0200, Ingo Molnar wrote:
>>>> there might be races as well, especially with proxy state - and 
>>>> current->flags updates are not serialized.
>>>>
>>>> So maybe it should be a completely separate flag after all? Stick it 
>>>> into the end of task_struct perhaps.
>>> What do you mean by proxy state?  nsproxy?
>> it's a concept: one task installing some state into another task (which 
>> state must be restored after a checkpoint event), while that other task 
>> is running. Such as a pi-futex state for example.
>>
>> So a task can acquire state not just by its own doing, but via some 
>> other task too.
> 
> thinking aloud,
> 
> hmm, that's rather complex, because we have to take into account the 
> kernel stack, no ? This is what Andrey was trying to solve in his patchset 
> back in September :
> 
> 	http://lkml.org/lkml/2008/9/3/96
> 
> the restart phase simulates a clone and switch_to to (not) restore the kernel 
> stack. right ? 
> 
> the self checkpoint and self restore syscalls, like Oren is proposing, are 
> simpler but they require the process cooperation to be triggered. we could
> image doing that in a special signal handler which would allow us to jump
> in the right task context. 

This description is not accurate:

For checkpoint, both implementations use an "external" task to read the state
from other tasks. (In my implementation that "other" task can be self).

For restart, both implementation expect the restarting process to restore its
own state. They differ in that Andrew's patchset also creates that process
while mine (at the moment) relies on the existing (self) task.

In other words, none of them will require any cooperation on part of the
checkpointed tasks, and both will require cooperation on part of the restarting
tasks (the latter is easy since we create and fully control these tasks).

> 
> I don't have any preference but looking at the code of the different patchsets
> there are some tricky areas and I'm wondering which path is easier, safer, 
> and portable. 

I am thinking which path is preferred: create the processes in kernel space
(like Andrew's patch does) or in user space (like Zap does). In the mini-summit
we agreed in favor of kernel space, but I can still see arguments why user space
may be better. (note: I refer strictly to the creation of the processes during
restart, not how their state is restored).

any thoughts ?

Oren.

