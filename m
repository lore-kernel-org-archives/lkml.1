Return-Path: <linux-kernel-owner+w=401wt.eu-S932603AbYDQRn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbYDQRn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYDQRnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:43:49 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:47869 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYDQRns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:43:48 -0400
Message-ID: <48078B9B.9070508@linux.vnet.ibm.com>
Date: Thu, 17 Apr 2008 23:10:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       serue@us.ibm.com, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
References: <48036677.3010807@linux.vnet.ibm.com> <20080414170709.736819b6.akpm@linux-foundation.org> <20080415171359.GA352@tv-sign.ru> <6599ad830804151113i73010bb4x48e658195f295d41@mail.gmail.com> <20080415195950.GA113@tv-sign.ru> <4806C633.3000302@linux.vnet.ibm.com> <20080417113000.GB103@tv-sign.ru> <6599ad830804170934i6df9fe42kd979492babe03be@mail.gmail.com> <20080417161936.GB4482@tv-sign.ru>
In-Reply-To: <20080417161936.GB4482@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Oleg,

I've been slow in responding and I expect that situation to continue till the
weekend. I hope to respond to your queries sooner

Oleg Nesterov wrote:
> On 04/17, Paul Menage wrote:
>> On Thu, Apr 17, 2008 at 4:30 AM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
>>>  >
>>>  > I had this loop earlier (inspired from zap_threads()), is this loop more
>>>  > efficient than what we have?
>>>
>>>  All sub-threads have the same ->mm. Once we see that c->mm != mm, we don't
>>>  need to waste CPU iterating over the all other threads in the thread group.
>> Technically they don't have to have the same mm, right? You can use
>> CLONE_THREAD without CLONE_VM when creating a new subthread.
> 
> No, no, this is not possible/allowed.
> 
> Please look at copy_process, CLONE_THREAD requires CLONE_SIGHAND,
> CLONE_SIGHAND needs CLONE_VM.
> 

What about the other way round, CLONE_VM without CLONE_THREAD?


>>>  chance you have the "for dummies" explanation what mm->owner is?
>>>  I mean, I can't understand how it is possible that 2 CLONE_VM tasks
>>>  are not equal wrt "ownering".
>> The idea is to be able to get from an mm to a task, where that task is
>> representative of the tasks using the mm. Uses include:
> 
> Thanks! but...
> 
> Let's suppose 2 task belongs to different cgroups, but share ->mm,
> 
>> - swap cgroup - when swapping from an mm, find a task whose swap
>> cgroup we can charge the swap page to
> 
> now we will charge the somewhat "random" cgroup. The one to which
> the result of the last "find the next suitable owner" belongs.
> 

Basically, with mm->owner and prior to that with the memory controller, we group
tasks by mm_struct instead of by task (virtually). Earlier, we had a hook in
mm_struct to tell us where the mm_struct belonged (to which cgroup). With
mm->owner, we can figure out where each subsystem belongs without having hooks
in mm_struct for each memory based controller subsystem.

When the owner exits (mm->owner), we pick the next owner and tell the tasks via
notification that the cgroup has changed (if it does). This does bring about
some issues, where without control accounting can move to a different cgroup all
of a sudden. To avoid that

We would recommend that the memory based controllers be mounted separately and
all related threads be put in the same cgroup


> This looks a bit strange to me... but OK, as I said, I don't know
> what cgroup is, please ignore me ;)
> 
> Oleg.
> 

Thanks for your review!

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
