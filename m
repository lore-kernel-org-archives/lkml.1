Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbYF0NIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbYF0NIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYF0NHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:07:55 -0400
Received: from saeurebad.de ([85.214.36.134]:39656 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbYF0NHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:07:54 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] softlockup: fix watchdog task wakeup frequency
References: <20080627000445.346130358@saeurebad.de>
	<20080627000805.504878592@saeurebad.de>
	<20080627120350.GB30872@elte.hu>
	<87prq3xdjv.fsf@skyscraper.fehenstaub.lan>
	<20080627124329.GA14576@elte.hu>
Date: Fri, 27 Jun 2008 15:07:21 +0200
In-Reply-To: <20080627124329.GA14576@elte.hu> (Ingo Molnar's message of "Fri,
	27 Jun 2008 14:43:29 +0200")
Message-ID: <87d4m3xbzq.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo Molnar <mingo@elte.hu> writes:

> * Johannes Weiner <hannes@saeurebad.de> wrote:
>
>> Hm, it updates the timestamp, so it makes only sense if it runs at a 
>> maximum every second (timestamp granularity) or even less.  The check 
>> for hung tasks uses the cpu timestamp as well for comparison, so that 
>> would be okay too.
>> 
>> Like this?
>> 
>> diff --git a/kernel/softlockup.c b/kernel/softlockup.c
>> index c828c23..b884546 100644
>> --- a/kernel/softlockup.c
>> +++ b/kernel/softlockup.c
>> @@ -106,8 +106,9 @@ void softlockup_tick(void)
>>  
>>  	now = get_timestamp(this_cpu);
>>  
>> -	/* Wake up the high-prio watchdog task every second: */
>> -	if (now > (touch_timestamp + 1))
>> +	/* Wake up the high-prio watchdog task twice per
>> +	 * threshold timespan. */
>> +	if (now > (touch_timestamp + softlockup_thresh / 2))
>>  		wake_up_process(per_cpu(watchdog_task, this_cpu));
>
> yeah - but please use the best possible coding style. Two-line comments 
> should be in the:
>
>   /*
>    * Here we ......................
>    * ........................ come:
>    */
>
> ... format.

Alright, that looks much better.


> And the arithmetics should be:
>
> 	if (now > touch_timestamp + softlockup_thresh/2)
>
> (the unnecessary paranthesis was a small style mistake in the original 
> too)

I tried to fit it into the rest of the code but also prefer the one
without parens.

Thanks for the suggestions, update appended.

	Hannes

---
From: Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH 3/3] softlockup: wake up watchdog twice per threshold timespan

Updating the timestamp more often is pointless as we print the warnings
only if we exceed the threshold.  And the check for hung tasks relies on
the last timestamp, so it will keep working correctly, too.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 kernel/softlockup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -107,8 +107,11 @@ void softlockup_tick(void)
 
 	now = get_timestamp(this_cpu);
 
-	/* Wake up the high-prio watchdog task every second: */
-	if (now > (touch_timestamp + 1))
+	/*
+	 * Wake up the high-prio watchdog task twice per
+	 * threshold timespan.
+	 */
+	if (now > touch_timestamp + softlockup_thresh/2)
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable delays: */
