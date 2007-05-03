Return-Path: <linux-kernel-owner+w=401wt.eu-S376148AbXECQA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376148AbXECQA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 12:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162157AbXECQA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 12:00:58 -0400
Received: from dodo.cs.umass.edu ([128.119.242.12]:63432 "EHLO
	dodo.cs.umass.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162158AbXECQA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 12:00:57 -0400
Message-ID: <463A0734.6090408@cs.umass.edu>
Date: Thu, 03 May 2007 12:00:52 -0400
From: Ting Yang <tingy@cs.umass.edu>
Reply-To: tingy@cs.umass.edu
Organization: ALI Lab, CS Dept, UMASS
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v7
References: <200704300820.49078.a1426z@gawab.com> <20070503074552.GA14960@elte.hu> <4639F970.5080701@cs.umass.edu> <20070503151741.GC1812@elte.hu>
In-Reply-To: <20070503151741.GC1812@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo

    I wrote that email in a hurry, therefore might not explain the 
problem clearly. However I do think there is a problem for this part, 
after I carefully read the code again. Now I want to try again :-) 
Hopefully, this time I will do a right job.

Starting from the following code:

+    if (__delta > niced_granularity(rq, curr, granularity))
+        resched_task(curr);


Suppose, "curr" has nice value -10, then curr->load_shift = 15.  
Granularity passed into this function is
fixed 2,000,000 (for CFS -v8). Let's just divide everything by 1,000,000 
for simplicity, say granularity used is 2.

Now, we look at how granularity is rescaled:

+    int load_shift = p->load_shift;
+
+    if (load_shift == SCHED_LOAD_SHIFT)
+        return value;
+
+    return (value << load_shift) >> SCHED_LOAD_SHIFT;

it returns (2  << 15) >> 10 = 2 * 32 = 64, therefore __delta has to be 
larger than 64 so that the current process can be preempted.

Suppose, "curr" executes for 1 tick, an timer interrupts comes. It 
executes about 1,000,000 (roughly speaking, since timer interrupts come 
1000/second). Since we divided everything by 1,000,000, it becomes 1 in 
this discussion. After this execution, how much will "curr" increments 
its fair_key?
It is weighted: 1/32.

then how much time is needed for "curr" to build a 2 * 32 difference on 
fair_key, with every 1 ms it updates fair_key by 1/32 ?    2 * 32 * 32 !
On the other hand, for a task  has nice value 1, the amount work needed 
to preemption is 2 * 1 *1.
If we have only 2 task running, p1 with nice value -10, p2 with nice 
value 0.
           p1 get cup share:  (32 * 32) / (32 * 32 + 1 *1)
           p2 get cpu share:  ( 1* 1) / (32 * 32 + 1 * 1)

I do see a quadratic effect here. Did I missed anything? sorry to bother 
you again, I just want to help :-)

Thanks a lot !

Ting




