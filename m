Return-Path: <linux-kernel-owner+w=401wt.eu-S1759081AbYF0MeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081AbYF0MeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbYF0MeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:34:14 -0400
Received: from saeurebad.de ([85.214.36.134]:39346 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756000AbYF0MeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:34:13 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] softlockup: fix watchdog task wakeup frequency
References: <20080627000445.346130358@saeurebad.de>
	<20080627000805.504878592@saeurebad.de>
	<20080627120350.GB30872@elte.hu>
Date: Fri, 27 Jun 2008 14:33:40 +0200
In-Reply-To: <20080627120350.GB30872@elte.hu> (Ingo Molnar's message of "Fri,
	27 Jun 2008 14:03:50 +0200")
Message-ID: <87prq3xdjv.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Johannes Weiner <hannes@saeurebad.de> wrote:
>
>> Wake up the watchdog every second instead of every second. [...]
>
> now _that_ is a real improvement ;-)
>
>>  	/* Wake up the high-prio watchdog task every second: */
>> -	if (now > (touch_timestamp + 1))
>> +	if (now > touch_timestamp)
>>  		wake_up_process(per_cpu(watchdog_task, this_cpu));
>
> you mean wake up every second instead of every two seconds?

Every second second :D The second `second' [adjective] refers to the
first `second' [noun].

> i think the best sleep period for the watchdog is half of the threshold. 
> It makes no point to check sooner than that. I.e. softlockup_thresh/2 
> would be better?

Hm, it updates the timestamp, so it makes only sense if it runs at a
maximum every second (timestamp granularity) or even less.  The check
for hung tasks uses the cpu timestamp as well for comparison, so that
would be okay too.

Like this?

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index c828c23..b884546 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -106,8 +106,9 @@ void softlockup_tick(void)
 
 	now = get_timestamp(this_cpu);
 
-	/* Wake up the high-prio watchdog task every second: */
-	if (now > (touch_timestamp + 1))
+	/* Wake up the high-prio watchdog task twice per
+	 * threshold timespan. */
+	if (now > (touch_timestamp + softlockup_thresh / 2))
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable delays: */
