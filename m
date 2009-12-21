Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbZLUHg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbZLUHg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 02:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZLUHg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 02:36:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65278 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbZLUHg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 02:36:56 -0500
Message-ID: <4B2F2588.8070501@cn.fujitsu.com>
Date: Mon, 21 Dec 2009 15:36:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: Fix lockdep warning in global_clock()
References: <4B2F1543.8020300@cn.fujitsu.com> <20091221064356.GA2378@elte.hu>
In-Reply-To: <20091221064356.GA2378@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>>  # echo 1 > events/enable
>>  # echo global > trace_clock
>>
>> ------------[ cut here ]------------
>> WARNING: at kernel/lockdep.c:3162 check_flags+0xb2/0x190()
>> ...
>> ---[ end trace 3f86734a89416623 ]---
>> possible reason: unannotated irqs-on.
>> ...
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  kernel/trace/trace_clock.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
>> index 84a3a7b..11563c9 100644
>> --- a/kernel/trace/trace_clock.c
>> +++ b/kernel/trace/trace_clock.c
>> @@ -83,7 +83,7 @@ u64 notrace trace_clock_global(void)
>>  	int this_cpu;
>>  	u64 now;
>>  
>> -	raw_local_irq_save(flags);
>> +	local_irq_save(flags);
> 
> Hm, wont this cause problems when we trace inside lockdep? Have you tried the 
> lockdep events - do they still work?
> 

Yes, they still work.

trace_clock_global() calls cpu_clock() which calls local_irq_save(),
which causes this lockdep warning.

And I noticed this commit:

===============================================
commit 2d452c9b10caeec455eb5e56a0ef4ed485178213
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sun Jun 29 15:01:59 2008 +0200

    sched: sched_clock_cpu() based cpu_clock(), lockdep fix

    Vegard Nossum reported:

    > WARNING: at kernel/lockdep.c:2738 check_flags+0x142/0x160()

    which happens due to:

     unsigned long long cpu_clock(int cpu)
     {
             unsigned long long clock;
             unsigned long flags;

             raw_local_irq_save(flags);

    as lower level functions can take locks, we must not do that, use
    proper lockdep-annotated irq save/restore.

    Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index ed5a8c4..60094e2 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -250,9 +250,9 @@ unsigned long long cpu_clock(int cpu)
        unsigned long long clock;
        unsigned long flags;

-       raw_local_irq_save(flags);
+       local_irq_save(flags);
        clock = sched_clock_cpu(cpu);
-       raw_local_irq_restore(flags);
+       local_irq_restore(flags);

        return clock;
 }
===============================================

I guess it's still true that lower level functions can take locks?
