Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbXFGKTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbXFGKTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbXFGKT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:19:26 -0400
Received: from ms-smtp-03.tampabay.rr.com ([65.32.5.133]:59623 "EHLO
	ms-smtp-03.tampabay.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbXFGKTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:19:25 -0400
Message-ID: <4667DB8C.4040803@cfl.rr.com>
Date: Thu, 07 Jun 2007 06:18:52 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>, markh@compro.net,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: floppy.c soft lockup
References: <20070601151605.GA108@tv-sign.ru> <4660534E.6050903@cfl.rr.com> <20070601183642.GA92@tv-sign.ru> <466078FF.2080508@cfl.rr.com> <20070602123030.GA719@tv-sign.ru> <4661D698.5040009@cfl.rr.com> <20070603081417.GA81@tv-sign.ru> <46641B16.9090701@compro.net> <4666B2A4.7090603@compro.net> <20070606102828.752bf955.akpm@linux-foundation.org> <20070607013128.GW11166@waste.org>
In-Reply-To: <20070607013128.GW11166@waste.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Wed, Jun 06, 2007 at 10:28:28AM -0700, Andrew Morton wrote:
>> On Wed, 06 Jun 2007 09:12:04 -0400 Mark Hounschell <markh@compro.net> wrote:
>>
>>>> As far as a 100% CPU bound task being a valid thing to do, it has been 
>>>> done for many years on SMP machines. Any kernel limitation on this 
>>>> surely must be considered a bug? 
>>>>
>>> Could someone authoritatively comment on this? Is a SCHED_RR/SCHED_FIFO
>>> 100% Cpu bound process supported in an SMP env on Linux? (vanilla or -rt)
>> It will kill the kernel, sorry.
>>
>> The only way in which we can fix that is to allow kernel threads to preempt
>> rt-priority userspace threads.  But if we were to do that (to benefit the
>> few) it would cause _all_ people's rt-prio processes to experience glitches
>> due to kernel activity, which we believe to be worse.
>>
>> So we're between a rock and a hard place here.
>>
>> If we really did want to solve this then I guess the kernel would need some
>> new code to detect a 100%-busy rt-prio process and to then start premitting
>> preemption of it for kernel thread activity.  That detector would need to
>> be smart enough to detect a number of 100%-busy rt-prio processes which are
>> yielding to each other, and one rt-prio process which keeps forking others,
>> etc.  It might get tricky.
> 
> The usual alternative is to manually chrt the relevant kernel threads
> to RT priority and adjust the priority scheme of their processes appropriately.
> 

>From an earlier thread member:

>> Mark writes:
>> Again I don't understand why flush_scheduled_work() running on behalf
>> of a process affinitized to processor-1 requires cooperation from
>> events/2 (affinitized to processor-2)
>> when there is an events/1 already affinitized to processor 1?

>Oleg write:
>flush_workqueue() blocks until any scheduled work on any CPU has run to
>completion. If we have some work_struct pending on CPU 2, it can be
>completed only when events/2 executes it.

Could not flush_scheduled_work() just follow the affinity mask of the
task that caused the call to begin with. If calling task had a cpu-mask
of 3 then flush_scheduled_work() would do the events/0 and events/1
thing and if the calling task had an affinity mask of 1 then only
events/0 would be done?

In other words changing what Oleg says above just slightly:

flush_workqueue() blocks until any scheduled work on any CPU in the
calling tasks affinity mask has run to completion?

Thanks
Mark

