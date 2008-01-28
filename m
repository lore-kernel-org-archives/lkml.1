Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYA1VnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYA1VnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYA1VnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:43:17 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:43141 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbYA1VnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:43:16 -0500
Message-ID: <479E4C5E.3010804@qualcomm.com>
Date: Mon, 28 Jan 2008 13:42:54 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Steven Rostedt <rostedt@goodmis.org>, Paul Jackson <pj@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [CPUISOL] CPU isolation extensions
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>	 <1201511305.6149.30.camel@lappy> <20080128085910.7d38e9f5.pj@sgi.com>	 <20080128163450.GC12598@goodmis.org> <479E2305.3040408@qualcomm.com>	 <Pine.LNX.4.58.0801281358070.10419@gandalf.stny.rr.com> <1201551730.28547.54.camel@lappy>
In-Reply-To: <1201551730.28547.54.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-01-28 at 14:00 -0500, Steven Rostedt wrote:
>> On Mon, 28 Jan 2008, Max Krasnyanskiy wrote:
>>>>>   [PATCH] [CPUISOL] Support for workqueue isolation
>>>> The thing about workqueues is that they should only be woken on a CPU if
>>>> something on that CPU accessed them. IOW, the workqueue on a CPU handles
>>>> work that was called by something on that CPU. Which means that
>>>> something that high prio task did triggered a workqueue to do some work.
>>>> But this can also be triggered by interrupts, so by keeping interrupts
>>>> off the CPU no workqueue should be activated.
>>> No no no. That's what I though too ;-). The problem is that things like NFS and friends
>>> expect _all_ their workqueue threads to report back when they do certain things like
>>> flushing buffers and stuff. The reason I added this is because my machines were getting
>>> stuck because CPU0 was waiting for CPU1 to run NFS work queue threads even though no IRQs
>>> or other things are running on it.
>> This sounds more like we should fix NFS than add this for all workqueues.
>> Again, we want workqueues to run on the behalf of whatever is running on
>> that CPU, including those tasks that are running on an isolcpu.
> 
> agreed, by looking at my top output (and not the nfs code) it looks like
> it just spawns a configurable number of active kernel threads which are
> not cpu bound by in any way. I think just removing the isolated cpus
> from their runnable mask should take care of them.

Actually NFS was just one example. I cannot remember of a top of my head what else was there
but there are definitely other users of work queues that expect all the threads to run at
some point in time.
Also if you think about it. The patch does _exactly_ what you propose. It removes workqueue 
threads from isolated CPUs. But instead of doing just for NFS and/or other subsystems 
separately it just does it in a generic way by simply not starting those threads in first 
place.
 
>>>>>   [PATCH] [CPUISOL] Isolated CPUs should be ignored by the "stop machine"
>>>> This I find very dangerous. We are making an assumption that tasks on an
>>>> isolated CPU wont be doing things that stopmachine requires. What stops
>>>> a task on an isolated CPU from calling something into the kernel that
>>>> stop_machine requires to halt?
>>> I agree in general. The thing is though that stop machine just kills any kind of latency
>>> guaranties. Without the patch the machine just hangs waiting for the stop-machine to run
>>> when module is inserted/removed. And running without dynamic module loading is not very
>>> practical on general purpose machines. So I'd rather have an option with a big red warning
>>> than no option at all :).
>> Well, that's something one of the greater powers (Linus, Andrew, Ingo)
>> must decide. ;-)
> 
> I'm in favour of better engineered method, that is, we really should try
> to solve these problems in a proper way. Hacks like this might be fine
> for custom kernels, but I think we should have a higher standard when it
> comes to upstream - we all have to live many years with whatever we put
> in there, we'd better think well about it.

100% agree. That's why I said mentioned that this patches is controversial in the first place. 
Right now those short from rewriting module loading to not use stop machine there is no other 
option. I'll think some more about it. If you guys have other ideas please drop me a note.

Thanx
Max
