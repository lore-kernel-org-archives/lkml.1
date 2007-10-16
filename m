Return-Path: <linux-kernel-owner+w=401wt.eu-S1762213AbXJPNAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762213AbXJPNAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 09:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbXJPM75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 08:59:57 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:56464 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbXJPM74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 08:59:56 -0400
Message-ID: <4714B5BF.1090001@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2007 18:29:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Chuck Ebbert <cebbert@redhat.com>, Frans Pop <elendil@planet.nl>,
       Greg KH <greg@kroah.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
References: <200710122231.50739.elendil@planet.nl> <200710161029.27132.borntraeger@de.ibm.com> <471484B3.9010903@linux.vnet.ibm.com> <200710161234.35529.borntraeger@de.ibm.com>
In-Reply-To: <200710161234.35529.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Am Dienstag, 16. Oktober 2007 schrieb Balbir Singh:
>> I am trying to think out loud as to what the root cause of the problem
>> might be. In one of the discussion threads, I saw utime going backwards,
>> which seemed very odd, I suspect that those are rounding errors.
>>
>> I don't understand your explanation below
>>
>> Initially utime = 9, stime = 0, sum_exec_runtime = S1
>>
>> Later
>>
>> utime = 9, stime = 1, sum_exec_runtime = S2
>>
>> We can be sure that S >= (utime + stime)
> 
> I think here is the problem. How can we be sure? We cant. utime and stime
> are sampled, so they can be largely off in any direction,if the program
> sleeps often and manages to synchronize itself to the timer tick. Lets say
> a program only does a simple system call and then sleeps. So sum_exec_runtime
> is increased by lets say 1000 cycles on a 1Ghz box which means 1000ns. If now 
> the timer tick happens exactly at this moment, stime is increased by 1 tick
> = 1000000ns. 
> 

Yes, I thought of that just after I sent out my email. In the case that
you mention, the utime and stime accounting is incorrect anyway :-)
I think we need to find a better solution. I was going to propose that
we round correctly in (the divisions in)

1. task_utime()
2. clock_t_to_cputime()

I suspect we'll need to round task_utime() to p->utime if the value of
task_utime() < p->utime and the same thing for task_stime(). I've tried
reproducing the problem on my UML setup without any success. Let me
try and grab an x86 box.

> Maybe there is some magic in the code which I did not see, but obviously
> the problem exists and looking at Frans data (stime+utime) are not decreasing,
> but stime isnt and utime is. If you look at Frans data you see:
> Oct 16 11:54:48 8 10
> Oct 16 11:54:49 6 12  <-- utime
> Oct 16 11:54:50 6 12
> Oct 16 11:54:51 6 12
> Oct 16 11:54:52 8 10  <-- stime
> Oct 16 11:54:53 8 10
> Oct 16 11:54:54 8 10
> Oct 16 11:54:55 8 12
> Oct 16 11:54:56 8 12
> 
> (stime+utime) is constant. That means that S2-S1 is obviously smaller than
> one tick (See the calculation in task_stime). I am quite sure it is caused
> by changes in the sampled values p->utime and p->stime.
> 

Yes, very interesting observation.

[snip]


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
