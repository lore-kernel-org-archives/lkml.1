Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbYIHOyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbYIHOyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYIHOyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:54:14 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35159 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752238AbYIHOyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:54:12 -0400
Message-ID: <48C53C91.70604@sgi.com>
Date: Mon, 08 Sep 2008 07:54:09 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 07/13] sched: Reduce stack size requirements in kernel/sched.c
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>	 <20080906235037.880702000@polaris-admin.engr.sgi.com> <1220783087.8687.73.camel@twins.programming.kicks-ass.net>
In-Reply-To: <1220783087.8687.73.camel@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Sat, 2008-09-06 at 16:50 -0700, Mike Travis wrote:
>> plain text document attachment (stack-hogs-kernel_sched_c)
>> * Make the following changes to kernel/sched.c functions:
>>
>>     - use node_to_cpumask_ptr in place of node_to_cpumask
>>     - use get_cpumask_var for temporary cpumask_t variables
>>     - use alloc_cpumask_ptr where available
>>
>>   * Remove special code for SCHED_CPUMASK_ALLOC and use CPUMASK_ALLOC
>>     from linux/cpumask.h.
>>
>>   * The resultant stack savings are:
>>
>>     ====== Stack (-l 100)
>>
>> 	1 - initial
>> 	2 - stack-hogs-kernel_sched_c
>> 	'.' is less than the limit(100)
>>
>>        .1.    .2.    ..final..
>>       2216  -1536 680   -69%  __build_sched_domains
>>       1592  -1592   .  -100%  move_task_off_dead_cpu
>>       1096  -1096   .  -100%  sched_balance_self
>>       1032  -1032   .  -100%  sched_setaffinity
>>        616   -616   .  -100%  rebalance_domains
>>        552   -552   .  -100%  free_sched_groups
>>        512   -512   .  -100%  cpu_to_allnodes_group
>>       7616  -6936 680   -91%  Totals
>>
>>
>> Applies to linux-2.6.tip/master.
>>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> ---
>>  kernel/sched.c |  151 ++++++++++++++++++++++++++++++---------------------------
>>  1 file changed, 81 insertions(+), 70 deletions(-)
>>
>> --- linux-2.6.tip.orig/kernel/sched.c
>> +++ linux-2.6.tip/kernel/sched.c
>> @@ -70,6 +70,7 @@
>>  #include <linux/bootmem.h>
>>  #include <linux/debugfs.h>
>>  #include <linux/ctype.h>
>> +#include <linux/cpumask_ptr.h>
>>  #include <linux/ftrace.h>
>>  #include <trace/sched.h>
>>  
>> @@ -117,6 +118,12 @@
>>   */
>>  #define RUNTIME_INF	((u64)~0ULL)
>>  
>> +/*
>> + * temp cpumask variables
>> + */
>> +static DEFINE_PER_CPUMASK(temp_cpumask_1);
>> +static DEFINE_PER_CPUMASK(temp_cpumask_2);
> 
> Yuck, that relies on turning preemption off everywhere you want to use
> those.
> 
> 
>> @@ -5384,11 +5400,14 @@ out_unlock:
>>  
>>  long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
>>  {
>> -	cpumask_t cpus_allowed;
>> -	cpumask_t new_mask = *in_mask;
>> +	cpumask_ptr cpus_allowed;
>> +	cpumask_ptr new_mask;
>>  	struct task_struct *p;
>>  	int retval;
>>  
>> +	get_cpumask_var(cpus_allowed, temp_cpumask_1);
>> +	get_cpumask_var(new_mask, temp_cpumask_2);
>> +	*new_mask = *in_mask;
>>  	get_online_cpus();
>>  	read_lock(&tasklist_lock);
> 
> BUG!
> 
> get_online_cpus() can sleep, but you just disabled preemption with those
> get_cpumask_var() horribles!
> 
> Couldn't be arsed to look through the rest, but I really hate this
> cpumask_ptr() stuff that relies on disabling preemption.
> 
> NAK

Yeah, I really agree as well.  But I wanted to start playing with using
cpumask_t pointers in some fairly straight forward manner.  Linus's and
Ingo's suggestion to just bite the bullet and redefine the cpumask_t 
would force a lot of changes to be made, but perhaps that's really the
way to go.

As to obtaining temp cpumask_t's (both early and late), perhaps a pool of
them would be better?  I believe it could be done similar to alloc_bootmem
(but much simpler), and I don't think there's enough nesting to require a
very large pool.  (4 was the largest depth I could find in io_apic.c.)  Of
course, with preemption enabled then other problems arise...

One other really big use was for the "allbutself" cpumask in the send_IPI
functions.  I think here, preemption is ok because the ownership of the
cpumask temp is very short lived.

But thanks for pointing out the get_online_cpus problem.  I did try and
chase down as many call trees as I could, but I obviously missed one
important one.

And thanks for looking it over!
Mike

