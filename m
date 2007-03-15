Return-Path: <linux-kernel-owner+w=401wt.eu-S932574AbXCOTJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbXCOTJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932801AbXCOTJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:09:15 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:47970 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932750AbXCOTJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:09:05 -0400
Message-ID: <45F999D4.6080602@vmware.com>
Date: Thu, 15 Mar 2007 12:09:08 -0700
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: dwalker@mvista.com, cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, paulus@au.ibm.com,
       schwidefsky@de.ibm.com, Rik van Riel <riel@redhat.com>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>	<45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org> <45F846AB.6060200@vmware.com> <45F84E39.7030507@goop.org> <45F85A62.8050001@vmware.com> <45F85BBB.70707@goop.org> <45F85F43.9030803@vmware.com> <45F866AF.9060609@goop.org>
In-Reply-To: <45F866AF.9060609@goop.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Mar 2007 19:09:03.0961 (UTC) FILETIME=[65A55490:01C76735]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2007 02:18 PM, Jeremy Fitzhardinge wrote:
> Dan Hecht wrote:
>> On 03/14/2007 01:31 PM, Jeremy Fitzhardinge wrote:
>>> Dan Hecht wrote:
>>>> Sounds good.  I don't see this in your patchset you sent yesterday
>>>> though; did you add it after sending out those patches?
>>> Yes.
>>>
>>>>   if so, could you forward the new patch?  does it explicitly prevent
>>>> stolen time from getting accounted as  user/system time or does it
>>>> just rely on NO_HZ mode sort of happening to work that way (since the
>>>> one shot timer is skipped ahead for missed ticks)?
>>> Hm, not sure.  It doesn't care how often it gets called; it just
>>> accumulates results up to that point, but I'm not sure if the time would
>>> get double accounted.  Perhaps it doesn't matter when using
>>> xen_sched_clock().
>>>
>> I think you might be double counting time in some cases. 
>> sched_clock() isn't really relevant to stolen time accounting (i.e.
>> cpustat->steal).
>>
>> I think what you want is to make sure that the sum of the cputime
>> passed to all of:
>>
>> account_user_time
>> account_system_time
>> account_steal_time
>>
>> adds up to the total amount of time that has passed.  I think it is
>> sort of working for you (i.e. doesn't always double count stolen
>> ticks) since in NO_HZ mode, update_process_time (which calls
>> account_user_time & account_system_time) happens to be skipped during
>> periods of stolen time due to the hrtimer_forward()'ing of the one
>> shot expiry. 
> 
> OK, this will need a closer look.
> 
> BTW, what are the properties of the vmi read_available_cycles()?  Is
> that a per-cpu timer?  If its used as the timebase for sched_clock, how
> does recalc_task_prio not get a -ve sleep time?
> 

Available time is defined to be (real_time - stolen_time).  i.e. time in 
which the vcpu is either running or not ready to run [because it is 
halted, and nothing is pending]).

So, yes, it is per-vcpu.  But, the sched_clock() samples are rebased 
when processes are migrated between runqueues; search sched.c for 
most_recent_timestamp.  It's not perfect since most_recent_timestamp 
between cpu0 and cpu1 do not correspond to the exact same instant, but 
does prevent negative sleep time and is fairly close.

Dan
