Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbXLKP2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbXLKP2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXLKP2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:28:07 -0500
Received: from ccs17.jlab.org ([129.57.35.82]:49550 "EHLO ccs17.jlab.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbXLKP2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:28:06 -0500
Message-ID: <475EAC81.1020408@jlab.org>
Date: Tue, 11 Dec 2007 10:28:01 -0500
From: Jie Chen <chen@jlab.org>
Organization: Jefferson Lab
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
References: <20071205200343.GA14570@elte.hu> <475708A7.4030708@jlab.org> <20071205204645.GC25694@elte.hu> <47570F83.6040601@jlab.org> <20071205210222.GA30089@elte.hu> <47572353.4040606@jlab.org> <20071206104318.GB30838@elte.hu> <47582367.6060602@jlab.org> <20071210105943.GA5370@elte.hu> <475D9BB5.20808@jlab.org> <20071211105149.GA24250@elte.hu>
In-Reply-To: <20071211105149.GA24250@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jie Chen <chen@jlab.org> wrote:
> 
>>> and then you use this in the measurement loop:
>>>
>>>    for (k=0; k<=OUTERREPS; k++){
>>>      start  = getclock();
>>>      for (j=0; j<innerreps; j++){
>>>  #ifdef _QMT_PUBLIC
>>>        delay((void *)0, 0);
>>>  #else
>>>        delay(0, 0, 0, (void *)0);
>>>  #endif
>>>      }
>>>      times[k] = (getclock() - start) * 1.0e6 / (double) innerreps;
>>>    }
>>>
>>> the problem is, this does not take the overhead of gettimeofday into 
>>> account - which overhead can easily reach 10 usecs (the observed 
>>> regression). Could you try to eliminate the gettimeofday overhead from 
>>> your measurement?
>>>
>>> gettimeofday overhead is something that might have changed from .21 to .22 
>>> on your box.
>>>
>>> 	Ingo
>> Hi, Ingo:
>>
>> In my pthread_sync code, I first call refer () subroutine which 
>> actually establishes the elapsed time (reference time) for 
>> non-synchronized delay() using the gettimeofday. Then each 
>> synchronization overhead value is obtained by subtracting the 
>> reference time from the elapsed time with introduced synchronization. 
>> The effect of gettimeofday() should be minimal if the time difference 
>> (overhead value) is the interest here. Unless the gettimeofday behaves 
>> differently in the case of running 8 threads .vs. running 2 threads.
>>
>> I will try to replace gettimeofday with a lightweight timer call in my 
>> test code. Thank you very much.
> 
> gettimeofday overhead is around 10 usecs here:
> 
>  2740  1197359374.873214 gettimeofday({1197359374, 873225}, NULL) = 0 <0.000010>
>  2740  1197359374.970592 gettimeofday({1197359374, 970608}, NULL) = 0 <0.000010>
> 
> and that's the only thing that is going on when computing the reference 
> time - and i see a similar syscall pattern in the PARALLEL and BARRIER 
> calculations as well (with no real scheduling going on).
> 
> 	Ingo

Hi, Ingo:

I guess it is a good news. I did patch 2.6.21.7 kernel using your cfs 
patch. The results of pthread_sync is the same as the non-patched 2.6.21 
kernel. This means the performance of is not related to the scheduler. 
As for overhead of the gettimeofday, there is no difference between 
2.6.21 and 2.6.24-rc4. The reference time is around 10.5 us for both 
kernel.

So what is changed between 2.6.21 and 2.6.22? Any hints :-). Thank you 
very much for all your help.

-- 
###############################################
Jie Chen
Scientific Computing Group
Thomas Jefferson National Accelerator Facility
12000, Jefferson Ave.
Newport News, VA 23606

(757)269-5046 (office) (757)269-6248 (fax)
chen@jlab.org
###############################################

