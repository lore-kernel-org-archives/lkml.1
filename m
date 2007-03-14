Return-Path: <linux-kernel-owner+w=401wt.eu-S1751090AbXCNVSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbXCNVSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 17:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbXCNVSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 17:18:42 -0400
Received: from gw.goop.org ([64.81.55.164]:52628 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbXCNVSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 17:18:41 -0400
Message-ID: <45F866AF.9060609@goop.org>
Date: Wed, 14 Mar 2007 14:18:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dan Hecht <dhecht@vmware.com>
CC: dwalker@mvista.com, cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, paulus@au.ibm.com,
       schwidefsky@de.ibm.com, Rik van Riel <riel@redhat.com>
Subject: Re: Stolen and degraded time and schedulers
References: <45F6D1D0.6080905@goop.org>	 <1173816769.22180.14.camel@localhost>	<45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org> <45F846AB.6060200@vmware.com> <45F84E39.7030507@goop.org> <45F85A62.8050001@vmware.com> <45F85BBB.70707@goop.org> <45F85F43.9030803@vmware.com>
In-Reply-To: <45F85F43.9030803@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Hecht wrote:
> On 03/14/2007 01:31 PM, Jeremy Fitzhardinge wrote:
>> Dan Hecht wrote:
>>> Sounds good.  I don't see this in your patchset you sent yesterday
>>> though; did you add it after sending out those patches?
>>
>> Yes.
>>
>>>   if so, could you forward the new patch?  does it explicitly prevent
>>> stolen time from getting accounted as  user/system time or does it
>>> just rely on NO_HZ mode sort of happening to work that way (since the
>>> one shot timer is skipped ahead for missed ticks)?
>>
>> Hm, not sure.  It doesn't care how often it gets called; it just
>> accumulates results up to that point, but I'm not sure if the time would
>> get double accounted.  Perhaps it doesn't matter when using
>> xen_sched_clock().
>>
>
> I think you might be double counting time in some cases. 
> sched_clock() isn't really relevant to stolen time accounting (i.e.
> cpustat->steal).
>
> I think what you want is to make sure that the sum of the cputime
> passed to all of:
>
> account_user_time
> account_system_time
> account_steal_time
>
> adds up to the total amount of time that has passed.  I think it is
> sort of working for you (i.e. doesn't always double count stolen
> ticks) since in NO_HZ mode, update_process_time (which calls
> account_user_time & account_system_time) happens to be skipped during
> periods of stolen time due to the hrtimer_forward()'ing of the one
> shot expiry. 

OK, this will need a closer look.

BTW, what are the properties of the vmi read_available_cycles()?  Is
that a per-cpu timer?  If its used as the timebase for sched_clock, how
does recalc_task_prio not get a -ve sleep time?


    J
