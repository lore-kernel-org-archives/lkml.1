Return-Path: <linux-kernel-owner+w=401wt.eu-S1760413AbYBZA67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413AbYBZA67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYBZA6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:58:50 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:17752 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYBZA6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:58:49 -0500
Message-Id: <47C31C65.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 25 Feb 2008 17:52:05 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <bill.huey@gmail.com>,
       <rostedt@goodmis.org>, <kevin@hilman.org>, <tglx@linutronix.de>,
       <cminyard@mvista.com>, <dsingleton@mvista.com>, <dwalker@mvista.com>,
       "Moiz Kohari" <MKohari@novell.com>,
       "Peter Morreale" <PMorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, <dsaxena@plexity.net>,
       <acme@redhat.com>, <ak@suse.de>, <gregkh@suse.de>, <npiggin@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [(RT RFC) PATCH v2 7/9] adaptive mutexes
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
 <20080225160113.11268.538.stgit@novell1.haskins.net>
 <20080225220950.GI2659@elf.ucw.cz>
In-Reply-To: <20080225220950.GI2659@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Mon, Feb 25, 2008 at  5:09 PM, in message
<20080225220950.GI2659@elf.ucw.cz>, Pavel Machek <pavel@ucw.cz> wrote: 
> Hi!
> 
>> From: Peter W.Morreale <pmorreale@novell.com>
>> 
>> This patch adds the adaptive spin lock busywait to rtmutexes.  It adds
>> a new tunable: rtmutex_timeout, which is the companion to the
>> rtlock_timeout tunable.
>> 
>> Signed-off-by: Peter W. Morreale <pmorreale@novell.com>
> 
> Not signed off by you?

I wasn't sure if this was appropriate for me to do.  This is the first time I was acting as "upstream" to someone.  If that is what I am expected to do, consider this an "ack" for your remaining comments related to this.

> 
>> diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
>> index ac1cbad..864bf14 100644
>> --- a/kernel/Kconfig.preempt
>> +++ b/kernel/Kconfig.preempt
>> @@ -214,6 +214,43 @@ config RTLOCK_DELAY
>>  	 tunable at runtime via a sysctl.  A setting of 0 (zero) disables
>>  	 the adaptive algorithm entirely.
>>  
>> +config ADAPTIVE_RTMUTEX
>> +        bool "Adaptive real-time mutexes"
>> +        default y
>> +        depends on ADAPTIVE_RTLOCK
>> +        help
>> +         This option adds the adaptive rtlock spin/sleep algorithm to
>> +         rtmutexes.  In rtlocks, a significant gain in throughput
>> +         can be seen by allowing rtlocks to spin for a distinct
>> +         amount of time prior to going to sleep for deadlock avoidence.
>> + 
>> +         Typically, mutexes are used when a critical section may need to
>> +         sleep due to a blocking operation.  In the event the critical 
>> +	 section does not need to sleep, an additional gain in throughput 
>> +	 can be seen by avoiding the extra overhead of sleeping.
> 
> Watch the whitespace. ... and do we need yet another config options?
> 
>> +config RTMUTEX_DELAY
>> +        int "Default delay (in loops) for adaptive mutexes"
>> +        range 0 10000000
>> +        depends on ADAPTIVE_RTMUTEX
>> +        default "3000"
>> +        help
>> +         This allows you to specify the maximum delay a task will use
>> +	 to wait for a rt mutex before going to sleep.  Note that that
>> +	 although the delay is implemented as a preemptable loop, tasks
>> +	 of like priority cannot preempt each other and this setting can
>> +	 result in increased latencies.
>> +	 
>> +         The value is tunable at runtime via a sysctl.  A setting of 0
>> +	 (zero) disables the adaptive algorithm entirely.
> 
> Ouch.

?  Is this reference to whitespace damage, or does the content need addressing?

> 
>> +#ifdef CONFIG_ADAPTIVE_RTMUTEX
>> +
>> +#define mutex_adaptive_wait         adaptive_wait
>> +#define mutex_prepare_adaptive_wait prepare_adaptive_wait
>> +
>> +extern int rtmutex_timeout;
>> +
>> +#define DECLARE_ADAPTIVE_MUTEX_WAITER(name) \
>> +     struct adaptive_waiter name = { .owner = NULL,               \
>> +                                     .timeout = rtmutex_timeout, }
>> +
>> +#else
>> +
>> +#define DECLARE_ADAPTIVE_MUTEX_WAITER(name)
>> +
>> +#define mutex_adaptive_wait(lock, intr, waiter, busy) 1
>> +#define mutex_prepare_adaptive_wait(lock, busy) {}
> 
> More evil macros. Macro does not behave like a function, make it
> inline function if you are replacing a function.

Ok


> 								Pavel



