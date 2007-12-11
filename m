Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbXLKKwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbXLKKwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 05:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbXLKKwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 05:52:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55503 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbXLKKwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 05:52:03 -0500
Date: Tue, 11 Dec 2007 11:51:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jie Chen <chen@jlab.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
Message-ID: <20071211105149.GA24250@elte.hu>
References: <20071205200343.GA14570@elte.hu> <475708A7.4030708@jlab.org> <20071205204645.GC25694@elte.hu> <47570F83.6040601@jlab.org> <20071205210222.GA30089@elte.hu> <47572353.4040606@jlab.org> <20071206104318.GB30838@elte.hu> <47582367.6060602@jlab.org> <20071210105943.GA5370@elte.hu> <475D9BB5.20808@jlab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475D9BB5.20808@jlab.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jie Chen <chen@jlab.org> wrote:

>> and then you use this in the measurement loop:
>>
>>    for (k=0; k<=OUTERREPS; k++){
>>      start  = getclock();
>>      for (j=0; j<innerreps; j++){
>>  #ifdef _QMT_PUBLIC
>>        delay((void *)0, 0);
>>  #else
>>        delay(0, 0, 0, (void *)0);
>>  #endif
>>      }
>>      times[k] = (getclock() - start) * 1.0e6 / (double) innerreps;
>>    }
>>
>> the problem is, this does not take the overhead of gettimeofday into 
>> account - which overhead can easily reach 10 usecs (the observed 
>> regression). Could you try to eliminate the gettimeofday overhead from 
>> your measurement?
>>
>> gettimeofday overhead is something that might have changed from .21 to .22 
>> on your box.
>>
>> 	Ingo
>
> Hi, Ingo:
>
> In my pthread_sync code, I first call refer () subroutine which 
> actually establishes the elapsed time (reference time) for 
> non-synchronized delay() using the gettimeofday. Then each 
> synchronization overhead value is obtained by subtracting the 
> reference time from the elapsed time with introduced synchronization. 
> The effect of gettimeofday() should be minimal if the time difference 
> (overhead value) is the interest here. Unless the gettimeofday behaves 
> differently in the case of running 8 threads .vs. running 2 threads.
>
> I will try to replace gettimeofday with a lightweight timer call in my 
> test code. Thank you very much.

gettimeofday overhead is around 10 usecs here:

 2740  1197359374.873214 gettimeofday({1197359374, 873225}, NULL) = 0 <0.000010>
 2740  1197359374.970592 gettimeofday({1197359374, 970608}, NULL) = 0 <0.000010>

and that's the only thing that is going on when computing the reference 
time - and i see a similar syscall pattern in the PARALLEL and BARRIER 
calculations as well (with no real scheduling going on).

	Ingo
