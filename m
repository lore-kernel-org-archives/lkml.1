Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbZG0VZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbZG0VZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZG0VZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:25:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:61748 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbZG0VZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:25:47 -0400
Message-ID: <4A6E1B4C.1050903@windriver.com>
Date: Mon, 27 Jul 2009 16:25:32 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       "Deng, Dongdong" <Dongdong.Deng@windriver.com>
Subject: Re: [PATCH] softlockup: fix problem with long kernel pauses from
 kgdb
References: <4A6E0825.3020604@windriver.com> <1248725893.6987.2055.camel@twins>
In-Reply-To: <1248725893.6987.2055.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jul 2009 21:25:32.0776 (UTC) FILETIME=[C5E11680:01CA0F00]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-07-27 at 15:03 -0500, Jason Wessel wrote:
>   
>> The fix is to simply invoke sched_clock_tick() to update "cpu sched
>> clock" on exit from kgdb_handle_exception.
>>     
>
> Is that a regular IRQ context, or is that NMI context?
>
>   

The patch text there is incorrect (which I can fix), because there were
3 other versions of this particular patch.  The version of this patch
that tried to use sched_clock_tick() from the exception context hung the
system because there was lock contention for CPUs that were not in the
running state.

In this version, the sched_clock_tick() added in the softlockup_tick(),
which did not result in a hard hang.  I am pretty sure that
softlockup_tick() runs as a part of the timer interrupt processing from
run_local_timers(), so there was no further need to turn off the interrupts.

Jason.

>> Signed-off-by: Dongdong Deng <Dongdong.Deng@windriver.com>
>> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: peterz@infradead.org
>> ---
>>  kernel/softlockup.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> --- a/kernel/softlockup.c
>> +++ b/kernel/softlockup.c
>> @@ -118,6 +118,9 @@ void softlockup_tick(void)
>>         }
>>  
>>         if (touch_timestamp == 0) {
>> +               /* If the time stamp was touched externally make sure the
>> +                * scheduler tick is up to date as well */
>> +               sched_clock_tick();
>>                 __touch_softlockup_watchdog();
>>                 return;
>>         }
>>
>>     
>
> Aside from the funny comment style (please fix) the fix does look
> sensible.
>   

No problem.

Thanks,
Jason.
