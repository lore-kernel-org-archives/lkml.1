Return-Path: <linux-kernel-owner+w=401wt.eu-S933980AbXC0R1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980AbXC0R1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934015AbXC0R1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:27:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933980AbXC0R1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:27:53 -0400
Message-ID: <46095274.7050502@redhat.com>
Date: Tue, 27 Mar 2007 13:20:52 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@xensource.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Rick Lindsley <ricklind@us.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] Ignore stolen time in the softlockup watchdog
References: <20070327053816.881735237@goop.org>	<20070327054106.664262413@goop.org>	<46092C9B.4030700@redhat.com> <46094861.7080400@goop.org> <46094C02.9050702@redhat.com> <46095006.2000306@xensource.com>
In-Reply-To: <46095006.2000306@xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Jeremy Fitzhardinge wrote:
> Prarit Bhargava wrote:
>   
>> Jeremy Fitzhardinge wrote:
>>   
>>     
>>> Prarit Bhargava wrote:
>>>   
>>>     
>>>       
>>>> I'd like to see this patch implement/fix touch_cpu_softlockup_watchdog
>>>> and touch_softlockup_watchdog to mimic touch_nmi_watchdog's behaviour.
>>>>     
>>>>       
>>>>         
>>> Why?  Is that more correct?  It seems to me that you're interested in
>>> whether a specific CPU has gone and locked up.  If touching the watchdog
>>>   
>>> makes it update all CPU timestamps, then you'll hide the fact that other
>>> CPUs have locked up, won't it?
>>>
>>>   
>>>     
>>>       
>> In case of misuse, yes.  But there are cases where we know that all CPUs 
>> will have softlockup issues, such as when doing a "big" sysrq-t dump.  
>> When doing the sysrq-t we take the tasklist_lock which prevents all 
>> other CPUs from scheduling -- this leads to bogus softlockup messages, 
>> so we need to reset everyone's watchdog just before releasing the 
>> tasklist_lock.
>>
>> Another question -- are you going to expose disable/enable_watchdog to 
>> other subsystems?  Or are you going to expose touch_softlockup_watchdog?
>>     
>
> Well, it depends on who turns up. 
>
> My first thought is to export both the global enable/disable interfaces
> and touch_softlockup_watchdog.  But on second thoughts maybe
> touch_softlockup_watchdog is completely redundant, since you'd only do
>   

IMO, if you export enable/disable you should drop touch_softlockup_watchdog.

> it if you're holding off timer interrupts, but the lockup only gets
> reported if timer interrupts are enabled (in other words, the best it
> can tell you is "you locked up for a while there", which isn't terribly
> useful).  
I like to think of the softlockup watchdog letting me know that a cpu 
hasn't scheduled in a long time.

> So perhaps this can just be dropped.  I haven't looked at the
> users to see what they're really trying to achieve.
>   

I've looked through much of that code for my previous patch ;)

AFAICT the uses appear to be cases where we _know_ that  we've gone away 
for a while and need to reset the timer.

But there were some exceptions:  touch_nmi_watchdog erroneously calls 
touch_softlockup_watchdog.  In fact, touch_nmi_watchdog is trying to 
touch all cpus softlockup watchdogs, not just one.

IIRC, There was an extra call to touch_softlockup_watchdog which wasn't 
necessary IIRC...

Look at my previous patch where I replaced touch_softlockup_watchdog 
with touch_cpu_softlockup_watchdog ...

> The enable/disable interfaces are more generally useful in that you can
> say "I *know* I'm going to go away for a while, so don't bother
> reporting it".
>
>     J
>   
