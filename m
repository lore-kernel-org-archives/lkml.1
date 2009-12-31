Return-Path: <linux-kernel-owner+w=401wt.eu-S1752349AbZLaFy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbZLaFy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 00:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbZLaFy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 00:54:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61611 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbZLaFyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 00:54:55 -0500
Message-ID: <4B3C3C9B.7090605@cn.fujitsu.com>
Date: Thu, 31 Dec 2009 13:54:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: prasad@linux.vnet.ibm.com
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ksym_tracer: Fix to make the tracer work
References: <4B3AF19E.1010201@cn.fujitsu.com> <20091230150530.GA3401@in.ibm.com>
In-Reply-To: <20091230150530.GA3401@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K.Prasad wrote:
> On Wed, Dec 30, 2009 at 02:22:22PM +0800, Li Zefan wrote:
>> ksym tracer doesn't work:
>>
>>  # echo tasklist_lock:rw- > ksym_trace_filter
>>  -bash: echo: write error: No such device
>>
>> It's because we pass to perf_event_create_kernel_counter()
>> a cpu number which is not present.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  kernel/hw_breakpoint.c    |   10 +++++++---
>>  kernel/trace/trace_ksym.c |    1 -
>>  2 files changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
>> index dbcbf6a..50dbd59 100644
>> --- a/kernel/hw_breakpoint.c
>> +++ b/kernel/hw_breakpoint.c
>> @@ -40,6 +40,7 @@
>>  #include <linux/percpu.h>
>>  #include <linux/sched.h>
>>  #include <linux/init.h>
>> +#include <linux/cpu.h>
>>  #include <linux/smp.h>
>>
>>  #include <linux/hw_breakpoint.h>
>> @@ -388,7 +389,8 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
>>  	if (!cpu_events)
>>  		return ERR_PTR(-ENOMEM);
>>
>> -	for_each_possible_cpu(cpu) {
>> +	get_online_cpus();
>> +	for_each_online_cpu(cpu) {
>>  		pevent = per_cpu_ptr(cpu_events, cpu);
>>  		bp = perf_event_create_kernel_counter(attr, cpu, -1, triggered);
>>
> 
> Frederic must have used for_each_possible_cpu() to account for CPUs that
> are offline at the time of registration, but may eventually turn online.
> Since register_wide_hw_breakpoint() interface is designed to deliver
> system-wide breakpoints, the debug registers of a new online CPU will
> should have the breakpoints populated to comprehensively notify all
> memory accesses over target address.
> 
> I'd rather wait to hear from Frederic to know why
> perf_event_create_kernel_counter() returns an error when run for an
> offline cpu and how it can be solved.
> 

See the comment in find_get_context() in kernel/perf_event.c:

                /*
                 * We could be clever and allow to attach a event to an
                 * offline CPU and activate it when the CPU comes up, but
                 * that's for later.
                 */
                if (!cpu_online(cpu))
                        return ERR_PTR(-ENODEV);

So I think we can use for_each_possible_cpu() in the future, but not now.

