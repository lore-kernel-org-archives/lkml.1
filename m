Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbZEKPNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbZEKPNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbZEKPMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:12:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36315 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813AbZEKPMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:12:48 -0400
Message-ID: <4A08405E.3070709@redhat.com>
Date: Mon, 11 May 2009 18:12:30 +0300
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
References: <200905050909.58583.mark.langsdorf@amd.com> <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com> <4A02FECC.6060609@redhat.com> <20090511141503.GC6175@elte.hu> <4A083539.407@redhat.com> <20090511143320.GE6175@elte.hu> <4A083B69.6010702@redhat.com> <20090511145903.GB737@elte.hu>
In-Reply-To: <20090511145903.GB737@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@redhat.com> wrote:
>
>   
>>> And only do it if there's other tasks running on this CPU or so.
>>>       
>> What would happen if there weren't?  I'd guess the task would 
>> continue running (but with a warped vruntime)?
>>     
>
> We dont want that warping to occur - we just want to go back and 
> burn CPU time in VM context. The problem is (as Peter pointed it 
> out) that this hw facility is incomplete and does not give us any 
> event (interrupt) and does not give us any event key (address we are 
> waiting for) either.
>
> So the next best thing to do is to go back to the guest, because 
> that is where we make the most progress, more likely, and that is 
> where we want to be to make progress immediately, with the shortest 
> latency.
>   

Right, but I thought vruntime += blah would go back into the guest if 
there were no other runnable tasks.

Oh I see -- we'd exit immediately and warp vruntime very fast as long as 
we're spinning.

> ( Perhaps we could also increase vruntime beyond the standard 
>   latency value to make sure any freshly woken task gets executed 
>   first if we are still looping. )
>   

We could be halfway through our remaining time.  We could set it to the 
next task + epsilon.

But that may be too aggressive.  If the lock holder is on another cpu, 
it may well complete before the standard latency value expires.  Since 
we're giving up cpu time potentially to other guests, we don't want to 
give too much.

If we wake up too soon, we'll spin for a few microseconds and yield 
again.  So I think your 100 us + exponential backoff is best.

>>> _That_ would be pretty efficient, and would do the right thing when  
>>> two (or more) vcpus run on the same CPU, and it would also do the  
>>> right thing if there are repeated VM-exits due to pause filtering.
>>>
>>> Please dont even think about using yield for this though - that will  
>>> just add a huge hit to this task and wont result in any sane behavior - 
>>> and yield is bound to some historic user-space behavior as well.
>>>
>>> A gradual and linear back-off from the current timeline is more of a  
>>> fair negotiation process between vcpus and results in more or less  
>>> sane (and fair) scheduling, and no unnecessary looping.
>>>
>>> You could even do an exponential backoff up to a limit of 1-10 msecs  
>>> or so, starting at 100 usecs.
>>>   
>>>       
>> Good idea, it eliminates another variable to be tuned.
>>     
>
> It could be made fully self-tuning, if the filter threshold can be 
> tuned fast enough. (an MSR write? A VM context field update?)
>   

The latter.

> I.e. the 3000 cycles value itself could be eliminated as well. (with 
> just a common-sense max of say 100,000 cycles enforced)
>   

Yeah, though that has a much smaller effect as it's only responsible for 
a few microseconds of spinning.

-- 
error compiling committee.c: too many arguments to function

