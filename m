Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbZJBTrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbZJBTrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 15:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756610AbZJBTrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 15:47:14 -0400
Received: from smtp241.iad.emailsrvr.com ([207.97.245.241]:59696 "EHLO
	smtp241.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550AbZJBTrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 15:47:13 -0400
Message-ID: <4AC658C2.6070406@librato.com>
Date: Fri, 02 Oct 2009 15:47:14 -0400
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, jeff@garzik.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH 01/19] freezer: don't get over-anxious while waiting
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-2-git-send-email-tj@kernel.org> <20091001183655.GA9995@atrey.karlin.mff.cuni.cz> <200910012304.00720.rjw@sisk.pl>
In-Reply-To: <200910012304.00720.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Rafael J. Wysocki wrote:
> On Thursday 01 October 2009, Pavel Machek wrote:
>>> Freezing isn't exactly the most latency sensitive operation and
>>> there's no reason to burn cpu cycles and power waiting for it to
>>> complete.  msleep(10) instead of yield().  This should improve
>>> reliability of emergency hibernation.
>> i don't see how it improves reliability, but its probably ok.
>>
>> Well... for hibernation anyway. I can imagine cgroup users where
>> freeze is so fast that this matters. rjw cc-ed.		pavel
> 
> Thanks.  I'd like to hear from the cgroup freezer people about that.
> 

[Adding Matt Helsley to the CC list]

To checkpoint or migrate an application, the cgroup to which it belongs
must be frozen first.

It's a bit down the road, but if one seeks minimum application downtime
during application checkpoint and/or migration, then a (minimum of)
10ms - or multiples of it - may result in a visible/undesired hick-up.

Perhaps avoid it when freezing a cgroup ?  or maybe a way for the user
to control this behavior per cgroup ?

Oren.

>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>> ---
>>>  kernel/power/process.c |   13 +++++++++----
>>>  1 files changed, 9 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/kernel/power/process.c b/kernel/power/process.c
>>> index cc2e553..9d26a0a 100644
>>> --- a/kernel/power/process.c
>>> +++ b/kernel/power/process.c
>>> @@ -41,7 +41,7 @@ static int try_to_freeze_tasks(bool sig_only)
>>>  	do_gettimeofday(&start);
>>>  
>>>  	end_time = jiffies + TIMEOUT;
>>> -	do {
>>> +	while (true) {
>>>  		todo = 0;
>>>  		read_lock(&tasklist_lock);
>>>  		do_each_thread(g, p) {
>>> @@ -62,10 +62,15 @@ static int try_to_freeze_tasks(bool sig_only)
>>>  				todo++;
>>>  		} while_each_thread(g, p);
>>>  		read_unlock(&tasklist_lock);
>>> -		yield();			/* Yield is okay here */
>>> -		if (time_after(jiffies, end_time))
>>> +		if (!todo || time_after(jiffies, end_time))
>>>  			break;
>>> -	} while (todo);
>>> +
>>> +		/*
>>> +		 * We need to retry.  There's no reason to be
>>> +		 * over-anxious about it and waste power.
>>> +		 */
> 
> The comment above looks like it's only meaningful in the context of the patch.
> After it's been applied the meaning of the comment won't be so obvious, I'm
> afraid.
> 
>>> +		msleep(10);
>>> +	}
>>>  
>>>  	do_gettimeofday(&end);
>>>  	elapsed_csecs64 = timeval_to_ns(&end) - timeval_to_ns(&start);
> 
> Thanks,
> Rafael
