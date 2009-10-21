Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbZJUUWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbZJUUWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZJUUWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:22:12 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:34333 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbZJUUWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:22:11 -0400
Message-id: <4ADF6D76.7070409@acm.org>
Date: Wed, 21 Oct 2009 15:22:14 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "discuss@LessWatts.org" <discuss@LessWatts.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Discuss] [PATCH] ipmi: use round_jiffies on timers to reduce
 timer overhead/wakeups
References: <20091021102822.5b32b2dc.randy.dunlap@oracle.com>
 <20091021114210.4d7e1ea9@linux.intel.com>	<4ADF57D7.7010808@intel.com>
 <20091021130348.cd521b0c.randy.dunlap@oracle.com>
In-reply-to: <20091021130348.cd521b0c.randy.dunlap@oracle.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Wed, 21 Oct 2009 11:49:59 -0700 Kok, Auke wrote:
>
>   
>> Arjan van de Ven wrote:
>>     
>>> On Wed, 21 Oct 2009 10:28:22 -0700
>>> Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>
>>>       
>>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>>
>>>> Use a round_jiffies() variant to reduce overhead of timer
>>>> wakeups.  This causes the ipmi timers to occur at the same
>>>> time as other timers (per CPU).
>>>>
>>>> Typical powertop for /ipmi/ (2.6.31, before patch):
>>>>   11.4% (247.4)            kipmi0 : __mod_timer (process_timeout) 
>>>>    0.6% ( 13.1)       <interrupt> : ipmi_si 
>>>>    0.5% ( 10.0)     <kernel core> : __mod_timer (ipmi_timeout) 
>>>>
>>>> powertop for /ipmi/, 2.6.31, after patch:
>>>>   10.8% (247.6)            kipmi0 : __mod_timer (process_timeout) 
>>>>    0.3% (  6.9)       <interrupt> : ipmi_si 
>>>>    0.0% (  1.0)     <kernel core> : __mod_timer (ipmi_timeout)
>>>>         
>>> while it is nice that ipmi_si ande the timer wake up less now.... it's
>>> still rather sad that the 247.6 from kipmi0 are still there..... those
>>> are a much much bigger issue
>>>       
>> obviously :)
>>
>> Randy, any idea where those are coming from ?
>>     
>
>
> obviously from kipmi thread :(
>
> drivers/char/ipmi/ipmi_si_intf.c::ipmi_thread():
>
> static int ipmi_thread(void *data)
> {
> 	struct smi_info *smi_info = data;
> 	unsigned long flags;
> 	enum si_sm_result smi_result;
>
> 	set_user_nice(current, 19);
> 	while (!kthread_should_stop()) {
> 		spin_lock_irqsave(&(smi_info->si_lock), flags);
> 		smi_result = smi_event_handler(smi_info, 0);
> 		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
> 		if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
> 			; /* do nothing */
> 		else if (smi_result == SI_SM_CALL_WITH_DELAY)
> 			schedule();
> 		else
> 			schedule_timeout_interruptible(1); <-----
> 	}
> 	return 0;
> }
>
>
> calls setup_timer_on_stack(), which calls process_timeout().
>
> From what I recall (probably 2 years ago), [older] ipmi hardware does not
> generate event interrupts, so it has to be polled.
>
> Corey, can you elaborate on this?
>   
Certainly.  Yes, some (probably most) IPMI hardware does not use
interrupts, and unfortunately, it's not just older machines.  The driver
used to poll more slowly, but in many cases the performance was
unacceptable.

kipmid is only started if the hardware doesn't support interrupts, so
only users with sub-standard hardware have to suffer with this problem.

Thanks for the patch, Randy.

-corey
