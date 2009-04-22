Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZDVRR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZDVRR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZDVRRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:17:49 -0400
Received: from gw.goop.org ([64.81.55.164]:49673 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbZDVRRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:17:48 -0400
Message-ID: <49EF5138.3030408@goop.org>
Date: Wed, 22 Apr 2009 10:17:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: various bug fixes
References: <20090420222257.267399830@goodmis.org> <20090421082354.GC12512@elte.hu> <20090421094616.GA14561@elte.hu> <alpine.DEB.2.00.0904220237330.9714@gandalf.stny.rr.com> <20090422114750.GA14202@nowhere> <alpine.DEB.2.00.0904220943280.24310@gandalf.stny.rr.com> <20090422171047.GA5975@nowhere>
In-Reply-To: <20090422171047.GA5975@nowhere>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Wed, Apr 22, 2009 at 09:49:14AM -0400, Steven Rostedt wrote:
>   
>>
>> On Wed, 22 Apr 2009, Frederic Weisbecker wrote:
>>     
>>>> I spent the entire day (and half the night) debugging this. I was fighting 
>>>> a case where the hardirqs_enabled flag in the task struct (lockdep flag) 
>>>> was mysteriously being set and cleared. I stepped through the entire 
>>>> kernel thread fork process (that was an exercise) and could not find 
>>>> anything wrong.
>>>>
>>>> Sometimes it would go away with printk's sometimes it would not. This was 
>>>> driving me crazy, until I noticed that paravirt was enabled.
>>>>
>>>> Turning off paravirtualization here (so far) makes everything run 
>>>> smoothly.
>>>>
>>>> Thus my theory is that there's something fishy with the modifying of the 
>>>> irq enable/disable code when the system detects that it is running on bare 
>>>> hardware.
>>>>
>>>> I'm too tired to look at this more. Ingo supplied a config to play with. 
>>>> You can disable VSMP too and it will still trigger the crash.
>>>>
>>>> -- Steve
>>>>
>>>>         
>>> It's indeed a tricky one. I can reproduce it too, I will
>>> try to manage having an irqsoff trace at this point, hopefully I
>>> could get the source of this irq disabling...
>>>       
>> It doesn't disable interrupts :-/
>>
>> It is the hardirqs_enabled flag in the task struct that mysteriously turns 
>> off and back on. I put in printks when it is off in fork, and the next 
>> printk shows that it turns back on (between the printks!!!).
>>
>> I printed the output of "irqs_disabled()" on each of these printks and 
>> interrupts are always enabled. It is only the hardirqs_enabled flag that 
>> is giving strange outputs.
>>     
>
>
> Oh, weird...
>
>  
>   
>> Do you have CONFIG_PARAVIRT on?  When I disabled it, I have yet to 
>> reproduce the bug. But I've only rebooted a few times. I'm going to 
>> continue to reboot to see if I can trigger it.
>>     
>
>
> Yes it is enabled.
>
>
>
>   
>> I'm thinking that the paravirt alternative code may have clobbered a 
>> register in either the enable or disabling of interrupts. This might cause 
>> a strange value to go into the hardirqs_enabled flag.
>>     
>
>
>
> Ok I will try it without PARAVIRT and tell you if I can reproduce it.
>   

Interesting.  What code is generated for native_irq_enable/disable?

    J
