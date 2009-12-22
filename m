Return-Path: <linux-kernel-owner+w=401wt.eu-S1751632AbZLVFSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbZLVFSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 00:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZLVFSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 00:18:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59034 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbZLVFSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 00:18:07 -0500
Message-ID: <4B305680.4090304@cn.fujitsu.com>
Date: Tue, 22 Dec 2009 13:17:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: Fix lockdep warning in global_clock()
References: <4B2F1543.8020300@cn.fujitsu.com>	 <20091221064356.GA2378@elte.hu>  <4B2F2588.8070501@cn.fujitsu.com>	 <1261406427.4314.155.camel@laptop> <1261410984.25193.8.camel@gandalf.stny.rr.com>
In-Reply-To: <1261410984.25193.8.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 2009-12-21 at 15:40 +0100, Peter Zijlstra wrote:
>> On Mon, 2009-12-21 at 15:36 +0800, Li Zefan wrote:
>>
>>> +++ b/kernel/sched_clock.c
>>> @@ -250,9 +250,9 @@ unsigned long long cpu_clock(int cpu)
>>>         unsigned long long clock;
>>>         unsigned long flags;
>>>
>>> -       raw_local_irq_save(flags);
>>> +       local_irq_save(flags);
>>>         clock = sched_clock_cpu(cpu);
>>> -       raw_local_irq_restore(flags);
>>> +       local_irq_restore(flags);
>>>
>>>         return clock;
>>>  }
>>> ===============================================
>>>
>>> I guess it's still true that lower level functions can take locks?
>> No, I removed the locks from cpu_clock a while back.
>>
> 
> The problem isn't with locks, it's with disabling interrupts. Lockdep
> keeps track of every time interrupts are disabled. If something disables
> interrupts with raw_* but then calls something that disables interrupts
> the normal way, lockdep will detect that interrupts are being disabled
> but they already are disabled. The internal irq disabled variable in
> lockdep wont match reality, and this will blow up (well, disable
> lockdep).
> 
> So if cpu_clock disables interrupts with local_irq_* then so must
> trace_clock_global.
> 

Looking into sched_clock.c, seems the only place that can trigger lockdep
is the local_irq_* in cpu_clock(), though I'm not sure for architecture-
specific sched_clock().

If so, I think we can use raw_local_irq_* in cpu_clock(). Actually I
tried it and the warning is gone.

