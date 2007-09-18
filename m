Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbXIRXCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbXIRXCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 19:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbXIRXCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 19:02:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbXIRXCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 19:02:19 -0400
Message-ID: <46F058EE.1080408@redhat.com>
Date: Tue, 18 Sep 2007 19:02:06 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Antoine Martin <antoine@nagafix.co.uk>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: CFS: some bad numbers with Java/database threading [FIXED]
References: <46E871FE.9010908@nagafix.co.uk> <20070913112427.GA20686@elte.hu> <20070914083246.GA20514@elte.hu> <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com> <46EAA7E4.8020700@nagafix.co.uk> <20070914153216.GA27213@elte.hu> <46F00417.7080301@redhat.com> <20070918224656.GA26719@elte.hu>
In-Reply-To: <20070918224656.GA26719@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2007 06:46 PM, Ingo Molnar wrote:
>>> We need a (tested) 
>>> solution for 2.6.23 and the CFS-devel patches are not for 2.6.23. I've 
>>> attached below the latest version of the -rc6 yield patch - the switch 
>>> is not dependent on SCHED_DEBUG anymore but always available.
>>>
>> Is this going to be merged? And will you be making the default == 1 or 
>> just leaving it at 0, which forces people who want the older behavior 
>> to modify the default?
> 
> not at the moment - Antoine suggested that the workload is probably fine 
> and the patch against -rc6 would have no clear effect anyway so we have 
> nothing to merge right now. (Note that there's no "older behavior" 
> possible, unless we want to emulate all of the O(1) scheduler's 
> behavior.) But ... we could still merge something like that patch, but a 
> clearer testcase is needed. The JVM's i have access to work fine.

I just got a bug report today:

https://bugzilla.redhat.com/show_bug.cgi?id=295071

==================================================

Description of problem:

The CFS scheduler does not seem to implement sched_yield correctly. If one
program loops with a sched_yield and another program prints out timing
information in a loop. You will see that if both are taskset to the same core
that the timing stats will be twice as long as when they are on different cores.
This problem was not in 2.6.21-1.3194 but showed up in 2.6.22.4-65 and continues
in the newest released kernel 2.6.22.5-76. 

Version-Release number of selected component (if applicable):

2.6.22.4-65 through 2.6.22.5-76

How reproducible:

Very

Steps to Reproduce:
compile task1
int main() {
        while (1) {
            sched_yield();
        }
        return 0;
}

and compile task2

#include <stdio.h>
#include <sys/time.h>
int main() {
    while (1) {
        int i;
        struct timeval t0,t1;
        double usec;

        gettimeofday(&t0, 0);
        for (i = 0; i < 100000000; ++i)
            ;
        gettimeofday(&t1, 0);

        usec = (t1.tv_sec * 1e6 + t1.tv_usec) - (t0.tv_sec * 1e6 + t0.tv_usec);
        printf ("%8.0f\n", usec);
    }
    return 0;
}

Then run:
"taskset -c 0 ./task1"
"taskset -c 0 ./task2"

You will see that both tasks use 50% of the CPU. 
Then kill task2 and run:
"taskset -c 1 ./task2"

Now task2 will run twice as fast verifying that it is not some anomaly with the
way top calculates CPU usage with sched_yield.
  
Actual results:
Tasks with sched_yield do not yield like they are suppose to.

Expected results:
The sched_yield task's CPU usage should go to near 0% when another task is on
the same CPU.
