Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547Ab0AZUrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab0AZUrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 15:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446Ab0AZUrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 15:47:12 -0500
Received: from mail.windriver.com ([147.11.1.11]:54492 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0AZUrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 15:47:11 -0500
Message-ID: <4B5F54AC.9010200@windriver.com>
Date: Tue, 26 Jan 2010 14:46:36 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] clocksource: Prevent potential kgdb dead
 lock
References: <1264480000-6997-4-git-send-email-jason.wessel@windriver.com><tip-7b7422a566aa0dc1e582ce263d4c7ff4a772700a@git.kernel.org> <20100126121458.43055709.akpm@linux-foundation.org>
In-Reply-To: <20100126121458.43055709.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2010 20:46:31.0201 (UTC) FILETIME=[A3C95910:01CA9EC8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 26 Jan 2010 14:09:45 GMT tip-bot for Thomas Gleixner <tglx@linutronix.de> wrote:
>
>   
>> --- a/kernel/time/clocksource.c
>> +++ b/kernel/time/clocksource.c
>> @@ -343,7 +343,19 @@ static void clocksource_resume_watchdog(void)
>>  {
>>  	unsigned long flags;
>>  
>> -	spin_lock_irqsave(&watchdog_lock, flags);
>> +	/*
>> +	 * We use trylock here to avoid a potential dead lock when
>> +	 * kgdb calls this code after the kernel has been stopped with
>> +	 * watchdog_lock held. When watchdog_lock is held we just
>> +	 * return and accept, that the watchdog might trigger and mark
>> +	 * the monitored clock source (usually TSC) unstable.
>> +	 *
>> +	 * This does not affect the other caller clocksource_resume()
>> +	 * because at this point the kernel is UP, interrupts are
>> +	 * disabled and nothing can hold watchdog_lock.
>> +	 */
>> +	if (!spin_trylock_irqsave(&watchdog_lock, flags))
>> +		return;
>>  	clocksource_reset_watchdog();
>>  	spin_unlock_irqrestore(&watchdog_lock, flags);
>>  }
>>
>> @@ -458,8 +470,8 @@ void clocksource_resume(void)
>>   * clocksource_touch_watchdog - Update watchdog
>>   *
>>   * Update the watchdog after exception contexts such as kgdb so as not
>> - * to incorrectly trip the watchdog.
>> - *
>> + * to incorrectly trip the watchdog. This might fail when the kernel
>> + * was stopped in code which holds watchdog_lock.
>>   */
>>  void clocksource_touch_watchdog(void)
>>  {
>>     
>
> It would be neater and a shade more reliable to add a separate
> clocksource_try_touch_watchdog() for kgdb's use.  Which could be inside
> #ifdef CONFIG_KGDB.
>
>   

The kernel debugger is the only user of this API function so
realistically you do not need a new function, and could simply rename
this one, if the name does not fit.

-- more notes on the problem --

I further diagnosed the problem, and it is reasonably rare that it
happens in the first place.  I had an instrumented version of the kernel
debugger which showed the problem happening quite frequently, while
trying to fix hw breakpoints.

The problem is not actually an interprocessor deadlock, but that of
re-entering the spin_lock() when it is already held by the interrupted
task on the same cpu.  There is no obvious way that I could see to check
for this specific condition and to abort.

For now the patch Thomas created is sufficient, and given some time
we'll decide how to best live with the side effects or to consider any
further changes.

Jason.

Tested-by: Jason Wessel <jason.wessel@windriver.com>


