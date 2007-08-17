Return-Path: <linux-kernel-owner+w=401wt.eu-S1759763AbXHQTIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763AbXHQTIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 15:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXHQTIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 15:08:30 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:56750 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbXHQTI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 15:08:29 -0400
Message-ID: <46C5F226.8050603@linux.vnet.ibm.com>
Date: Sat, 18 Aug 2007 00:38:22 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michael Neuling <mikey@neuling.org>, Jay Lan <jlan@engr.sgi.com>,
       Benjamin@ozlabs.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/2] Add scaled time to taskstats based process accounting
References: <20070816070922.37B5370074@localhost.localdomain> <46C3FC41.4000609@linux.vnet.ibm.com> <19998.1187312981@neuling.org> <20070817115951.e1368a7d.akpm@linux-foundation.org>
In-Reply-To: <20070817115951.e1368a7d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 17 Aug 2007 11:09:41 +1000
> Michael Neuling <mikey@neuling.org> wrote:
> 
>> This adds items to the taststats struct to account for user and system
>> time based on scaling the CPU frequency and instruction issue rates.
>>
>> Adds account_(user|system)_time_scaled callbacks which architectures
>> can use to account for time using this mechanism.
>>
>> ...
>>
>> Index: linux-2.6-ozlabs/include/linux/kernel_stat.h
>> ===================================================================
>> --- linux-2.6-ozlabs.orig/include/linux/kernel_stat.h
>> +++ linux-2.6-ozlabs/include/linux/kernel_stat.h
>> @@ -52,7 +52,9 @@ static inline int kstat_irqs(int irq)
>>  }
>>  
>>  extern void account_user_time(struct task_struct *, cputime_t);
>> +extern void account_user_time_scaled(struct task_struct *, cputime_t);
>>  extern void account_system_time(struct task_struct *, int, cputime_t);
>> +extern void account_system_time_scaled(struct task_struct *, cputime_t);
>>  extern void account_steal_time(struct task_struct *, cputime_t);
>>  
>>  #endif /* _LINUX_KERNEL_STAT_H */
>> Index: linux-2.6-ozlabs/include/linux/sched.h
>> ===================================================================
>> --- linux-2.6-ozlabs.orig/include/linux/sched.h
>> +++ linux-2.6-ozlabs/include/linux/sched.h
>> @@ -1020,7 +1020,7 @@ struct task_struct {
>>  	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
>>  
>>  	unsigned int rt_priority;
>> -	cputime_t utime, stime;
>> +	cputime_t utime, stime, utimescaled, stimescaled;
> 
> Adding 8 or 16 bytes to the task_struct for all architectures for something
> which only powerpc uses?
> 
> Is there any prospect that other CPUs can use this?
> 
>>  	unsigned long nvcsw, nivcsw; /* context switch counts */
>>  	struct timespec start_time; 		/* monotonic time */
>>  	struct timespec real_start_time;	/* boot based time */
>> Index: linux-2.6-ozlabs/include/linux/taskstats.h
>> ===================================================================
>> --- linux-2.6-ozlabs.orig/include/linux/taskstats.h
>> +++ linux-2.6-ozlabs/include/linux/taskstats.h
>> @@ -31,7 +31,7 @@
>>   */
>>  
>>  
>> -#define TASKSTATS_VERSION	5
>> +#define TASKSTATS_VERSION	6
>>  #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
>>  					 * in linux/sched.h */
>>  
>> @@ -85,9 +85,12 @@ struct taskstats {
>>  	 * On some architectures, value will adjust for cpu time stolen
>>  	 * from the kernel in involuntary waits due to virtualization.
>>  	 * Value is cumulative, in nanoseconds, without a corresponding count
>> -	 * and wraps around to zero silently on overflow
>> +	 * and wraps around to zero silently on overflow.  The
>> +	 * _scaled_ version accounts for cpus which can scale the
>> +	 * number of instructions executed each cycle.
>>  	 */
>>  	__u64	cpu_run_real_total;
>> +	__u64	cpu_scaled_run_real_total;
>>  
>>  	/* cpu "virtual" running time
>>  	 * Uses time intervals seen by the kernel i.e. no adjustment
>> @@ -142,6 +145,10 @@ struct taskstats {
>>  	__u64	write_char;		/* bytes written */
>>  	__u64	read_syscalls;		/* read syscalls */
>>  	__u64	write_syscalls;		/* write syscalls */
>> +
>> +	/* time accounting for SMT machines */
>> +	__u64	ac_utimescaled;		/* utime scaled on frequency etc */
>> +	__u64	ac_stimescaled;		/* stime scaled on frequency etc */
>>  	/* Extended accounting fields end */
> 
> umm, should we be adding new fields in the middle of this message?  I
> thought we should only add to the end, for back-compatibility, but maybe I
> misremember.
> 


You remember correctly, I've asked Michael to make those changes.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
