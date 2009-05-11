Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbZEKOvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbZEKOvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZEKOvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:51:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40242 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbZEKOvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:51:39 -0400
Message-ID: <4A083B69.6010702@redhat.com>
Date: Mon, 11 May 2009 17:51:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM][retry 1] Add support for Pause Filtering to AMD
 SVM
References: <200905050909.58583.mark.langsdorf@amd.com> <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com> <4A02FECC.6060609@redhat.com> <20090511141503.GC6175@elte.hu> <4A083539.407@redhat.com> <20090511143320.GE6175@elte.hu>
In-Reply-To: <20090511143320.GE6175@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@redhat.com> wrote:
>
>   
>>> I.e. this is a somewhat poor solution as far as scheduling goes. 
>>> But i'm wondering what the CPU side does. Can REP-NOP really take 
>>> thousands of cycles? If yes, under what circumstances?
>>>       
>> The guest is running rep-nop in a loop while trying to acquire a 
>> spinlock.  The hardware detects this (most likely, repeated 
>> rep-nop with the same rip) and exits.  We can program the loop 
>> count; obviously if we're spinning for only a short while it's 
>> better to keep spinning while hoping the lock will be released 
>> soon.
>>
>> The idea is to detect that the guest is not making forward 
>> progress and yield.  If I could tell the scheduler, you may charge 
>> me a couple of milliseconds, I promise not to sue, that would be 
>> ideal. [...]
>>     
>
> Ok, with such a waiver, who could refuse?
>
> This really needs a new kernel-internal scheduler API though, which 
> does a lot of fancy things to do:
>
>         se->vruntime += 1000000;
>
> i.e. add 1 msec worth of nanoseconds to the task's timeline. (first 
> remove it from the rbtree, then add it back, and nice-weight it as 
> well) 

I suspected it would be as simple as this.

> And only do it if there's other tasks running on this CPU or 
> so.
>   

What would happen if there weren't?  I'd guess the task would continue 
running (but with a warped vruntime)?

> _That_ would be pretty efficient, and would do the right thing when 
> two (or more) vcpus run on the same CPU, and it would also do the 
> right thing if there are repeated VM-exits due to pause filtering.
>
> Please dont even think about using yield for this though - that will 
> just add a huge hit to this task and wont result in any sane 
> behavior - and yield is bound to some historic user-space behavior 
> as well.
>
> A gradual and linear back-off from the current timeline is more of a 
> fair negotiation process between vcpus and results in more or less 
> sane (and fair) scheduling, and no unnecessary looping.
>
> You could even do an exponential backoff up to a limit of 1-10 msecs 
> or so, starting at 100 usecs.
>   

Good idea, it eliminates another variable to be tuned.

-- 
error compiling committee.c: too many arguments to function

