Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbYE1NcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbYE1NcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYE1Nb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:31:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:47719 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbYE1Nb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:31:56 -0400
Message-ID: <483D5EA5.7020600@windriver.com>
Date: Wed, 28 May 2008 08:31:17 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] softlockup: fix NMI hangs due to lock race - 2.6.26-rc
 regression
References: <483C4391.8040002@windriver.com> <1211909335.6463.296.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1211909335.6463.296.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2008 13:31:11.0597 (UTC) FILETIME=[182211D0:01C8C0C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-05-27 at 12:23 -0500, Jason Wessel wrote:
>> The touch_nmi_watchdog() routine on x86 ultimately calls
>> touch_softlockup_watchdog().  The problem is that to touch the
>> softlockup watchdog, the cpu_clock code has to be called which could
>> involve multiple cpu locks and can lead to a hard hang if one of the
>> locks is held by a processor that is not going to return anytime soon
>> (such as could be the case with kgdb or perhaps even with some other
>> kind of exception).
>>
>> This patch causes the public version of the
>> touch_softlockup_watchdog() to defer the cpu clock access to a later
>> point.
>>
>> The test case for this problem is to use the following kernel config
>> options:
>>
>> CONFIG_KGDB_TESTS=y
>> CONFIG_KGDB_TESTS_ON_BOOT=y
>> CONFIG_KGDB_TESTS_BOOT_STRING="V1F100I100000"
>>
>> It should be noted that kgdb test suite and these options were not
>> available until 2.6.26-rc2, so it was necessary to patch the kgdb
>> test suite during the bisection.
>>
>> I would consider this patch a regression fix because the problem first
>> appeared in commit 27ec4407790d075c325e1f4da0a19c56953cce23 when some
>> logic was added to try to periodically sync the clocks.  It was
>> possible to work around this particular problem by simply not
>> performing the sync anytime the system was in a critical context.
>> This was ok until commit 3e51f33fcc7f55e6df25d15b55ed10c8b4da84cd,
>> which added config option CONFIG_HAVE_UNSTABLE_SCHED_CLOCK and some
>> multi-cpu locks to sync the clocks.  It became clear that accessing
>> this code from an nmi was the source of the lockups.  Avoiding the
>> access to the low level clock code from an code inside the NMI
>> processing also fixed the problem with the 27ec44... commit.
>
>
> While I do not object to this approach, I ran into something similar
> while poking at .25-rt.
>
> How about we make sched_clock_cpu() use trylocks to update the ->clock
> value, and on failure just return the ->clock without updating it?
>


If the try locks are used it will certainly solve the NMI problem, but
it seems that the probability that lock could not be obtained would
increase for the "normal" operation case.  In the "normal" operation
case the lock would generally be available in a few more cpu ticks and
the update would proceed correctly.  It is not clear to me if there is
some ramification of returning the ->clock without the update in this
case, which is why I opted for deferring the update in the NMI case.

Perhaps if you return the clock without updating the unstable clock
source is more unstable?  It would be best to figure out how to
address regression so as to observe the intent of seemly more complex
clock logic.

Jason.
