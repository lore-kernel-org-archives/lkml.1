Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419Ab0BRQ2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:28:32 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59424 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756980Ab0BRQ2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:28:31 -0500
Message-ID: <4B7D6AAB.5080602@austin.ibm.com>
Date: Thu, 18 Feb 2010 10:28:27 -0600
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       ego@in.ibm.com
Subject: Re: [PATCHv4 2/2] powerpc: implement arch_scale_smt_power for Power7
References: <1264017638.5717.121.camel@jschopp-laptop>	 <1264017847.5717.132.camel@jschopp-laptop>	 <1264548495.12239.56.camel@jschopp-laptop>	 <1264720855.9660.22.camel@jschopp-laptop>	 <1264721088.10385.1.camel@jschopp-laptop>	 <1265403478.6089.41.camel@jschopp-laptop>	 <1266142340.5273.418.camel@laptop>  <25851.1266445258@neuling.org> <1266499023.26719.597.camel@laptop>
In-Reply-To: <1266499023.26719.597.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the slow reply, was on vacation.  Mikey seems to have answered 
pretty well though.

>>> That is, unless these threads 2 and 3 really are _that_ weak, at which
>>> point one wonders why IBM bothered with the silicon ;-)
>>>       
>> Peter,
>>
>> 2 & 3 aren't weaker than 0 & 1 but.... 
>>
>> The core has dynamic SMT mode switching which is controlled by the
>> hypervisor (IBM's PHYP).  There are 3 SMT modes:
>> 	SMT1 uses thread  0
>> 	SMT2 uses threads 0 & 1
>> 	SMT4 uses threads 0, 1, 2 & 3
>> When in any particular SMT mode, all threads have the same performance
>> as each other (ie. at any moment in time, all threads perform the same).  
>>
>> The SMT mode switching works such that when linux has threads 2 & 3 idle
>> and 0 & 1 active, it will cede (H_CEDE hypercall) threads 2 and 3 in the
>> idle loop and the hypervisor will automatically switch to SMT2 for that
>> core (independent of other cores).  The opposite is not true, so if
>> threads 0 & 1 are idle and 2 & 3 are active, we will stay in SMT4 mode.
>>
>> Similarly if thread 0 is active and threads 1, 2 & 3 are idle, we'll go
>> into SMT1 mode.  
>>
>> If we can get the core into a lower SMT mode (SMT1 is best), the threads
>> will perform better (since they share less core resources).  Hence when
>> we have idle threads, we want them to be the higher ones.
>>     
>
> Just out of curiosity, is this a hardware constraint or a hypervisor
> constraint?
>   
hardware
>   
>> So to answer your question, threads 2 and 3 aren't weaker than the other
>> threads when in SMT4 mode.  It's that if we idle threads 2 & 3, threads
>> 0 & 1 will speed up since we'll move to SMT2 mode.
>>
>> I'm pretty vague on linux scheduler details, so I'm a bit at sea as to
>> how to solve this.  Can you suggest any mechanisms we currently have in
>> the kernel to reflect these properties, or do you think we need to
>> develop something new?  If so, any pointers as to where we should look?
>>     
>
>   
Since the threads speed up we'd need to change their weights at runtime 
regardless of placement.  It just seems to make sense to let the changed 
weights affect placement naturally at the same time.

> Well there currently isn't one, and I've been telling people to create a
> new SD_flag to reflect this and influence the f_b_g() behaviour.
>
> Something like the below perhaps, totally untested and without comments
> so that you'll have to reverse engineer and validate my thinking.
>
> There's one fundamental assumption, and one weakness in the
> implementation.
>   
I'm going to guess the weakness is that it doesn't adjust the cpu power 
so tasks running in SMT1 mode actually get more than they account for?  
What's the assumption?
