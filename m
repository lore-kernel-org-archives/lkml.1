Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442Ab0A1RuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab0A1RuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 12:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414Ab0A1RuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 12:50:17 -0500
Received: from mail.windriver.com ([147.11.1.11]:53768 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab0A1RuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 12:50:16 -0500
Message-ID: <4B61CE1A.8090001@windriver.com>
Date: Thu, 28 Jan 2010 11:49:14 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 3/3] perf,hw_breakpoint,kgdb: No mutex taken for kerneldebugger
References: <1264631124-4837-1-git-send-email-jason.wessel@windriver.com> <1264631124-4837-4-git-send-email-jason.wessel@windriver.com> <20100128173307.GB18683@nowhere>
In-Reply-To: <20100128173307.GB18683@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2010 17:49:14.0304 (UTC) FILETIME=[34872C00:01CAA042]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Wed, Jan 27, 2010 at 04:25:24PM -0600, Jason Wessel wrote:
>   
>> The kernel debugger cannot use any mutex_lock() calls because it can
>> start the kernel running from an invalid context.
>>
>> The possibility for a breakpoint reservation to be concurrently
>> processed at the time that kgdb interrupts the system is improbable.
>> As a safety check against this condition the kernel debugger will
>> prohibit updating the hardware breakpoint reservations and an error
>> will be returned to the end user.
>>
>> Any time the kernel debugger reserves a hardware breakpoint it will be
>> a system wide reservation.
>>
>> CC: Frederic Weisbecker <fweisbec@gmail.com>
>> CC: Ingo Molnar <mingo@elte.hu>
>> CC: K.Prasad <prasad@linux.vnet.ibm.com>
>> CC: Peter Zijlstra <peterz@infradead.org>
>> CC: Alan Stern <stern@rowland.harvard.edu>
>> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>> ---
>>  arch/x86/kernel/kgdb.c        |   49 +++++++++++++++++++++++++++++++++++++-
>>  include/linux/hw_breakpoint.h |    2 +
>>  kernel/hw_breakpoint.c        |   52 +++++++++++++++++++++++++++++++++--------
>>  3 files changed, 92 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
>> index 9f47cd3..7c3e929 100644
>> --- a/arch/x86/kernel/kgdb.c
>> +++ b/arch/x86/kernel/kgdb.c
>> @@ -239,6 +239,45 @@ static void kgdb_correct_hw_break(void)
>>  	hw_breakpoint_restore();
>>  }
>>  
>> +static int hw_break_reserve_slot(int breakno)
>> +{
>> +	int cpu;
>> +	int cnt = 0;
>> +	struct perf_event **pevent;
>> +
>> +	for_each_online_cpu(cpu) {
>> +		cnt++;
>> +		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
>> +		if (dbg_reserve_bp_slot(*pevent))
>> +			goto fail;
>> +	}
>> +
>> +	return 0;
>> +
>> +fail:
>> +	for_each_online_cpu(cpu) {
>> +		cnt--;
>> +		if (!cnt)
>> +			break;
>> +		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
>> +		dbg_release_bp_slot(*pevent);
>> +	}
>> +	return -1;
>> +}
>> +
>> +static int hw_break_release_slot(int breakno)
>> +{
>> +	struct perf_event **pevent;
>> +	int ret;
>> +	int cpu;
>> +
>> +	for_each_online_cpu(cpu) {
>> +		pevent = per_cpu_ptr(breakinfo[breakno].pev, cpu);
>> +		ret = dbg_release_bp_slot(*pevent);
>>     
>
>
>
> So, you are missing some return errors there. Actually, a slot
> release shouldn't return an error.
>
>
>   

This is a trick so to speak.   Either all the slot releases will return
0 or -1 depending on if the mutex is available, so it is not really
missed. 

Certainly I can change this to just quit immediately on error.

>   
>> +/*
>> + * Allow the kernel debugger to reserve breakpoint slots without
>> + * taking a lock using the dbg_* variant of for the reserve and
>> + * release breakpoint slots.
>> + */
>> +int dbg_reserve_bp_slot(struct perf_event *bp)
>> +{
>> +	if (mutex_is_locked(&nr_bp_mutex))
>> +		return -1;
>> +
>> +	return __reserve_bp_slot(bp);
>> +}
>> +
>> +int dbg_release_bp_slot(struct perf_event *bp)
>> +{
>> +	if (mutex_is_locked(&nr_bp_mutex))
>> +		return -1;
>> +
>> +	__release_bp_slot(bp);
>> +
>> +	return 0;
>> +}
>>     
>
>
>
> Ok, best effort fits well for reserve, but is certainly not
> suitable for release. We can't leave a fake occupied slot like
> this. If it fails, we should do this asynchronously, using the
> usual release_bp_slot, may be toward the workqueues.
>
>
>
>   

If it fails the debugger tried to remove it again later.   It seems to
me like it is a don't care corner case.   You get a printk if it ever
does happen (which it really shouldn't).


>   
>>  
>>  int register_perf_hw_breakpoint(struct perf_event *bp)
>>  {
>> -- 
>> 1.6.4.rc1
>>
>>     
>
>   

