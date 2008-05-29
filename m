Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbYE2Va7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbYE2Va7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756615AbYE2Vaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:30:52 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:57861 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbYE2Vav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:30:51 -0400
Message-ID: <483F207D.4010908@nortel.com>
Date: Thu, 29 May 2008 15:30:37 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       pj@sgi.com, Balbir Singh <balbir@in.ibm.com>,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com
Subject: Re: fair group scheduler not so fair?
References: <4834B75A.40900@nortel.com> <20080527171528.GD30285@linux.vnet.ibm.com> <483C4F5A.2010104@nortel.com> <20080528163318.GG30285@linux.vnet.ibm.com> <483DA5E7.5050600@nortel.com> <20080529164607.GC12836@linux.vnet.ibm.com>
In-Reply-To: <20080529164607.GC12836@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2008 21:30:45.0322 (UTC) FILETIME=[4105D2A0:01C8C1D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:

> In summary, can you do this before running your tests:
> 
> 1. Apply updated patch below on top of 2.6.26-rc3 + Peter's patches
> (http://programming.kicks-ass.net/kernel-patches/sched-smp-group-fixes/)

I updated with the old set of patches you sent me, plus your patch.

> 2. Setup test env as below:

Done.

Overall the group scheduler results look better, but I'm seeing an odd 
scenario within a single group where sometimes I get a 67/67/66 
breakdown but sometimes it gives 100/50/50.

Also, although the long-term results are good, the shorter-term fairness 
isn't great.  Is there a tuneable that would allow for a tradeoff 
between performance and fairness?  I have people that are looking for 
within 4% fairness over a 1sec interval.


Initially I tried a simple setup with three hogs all in the default 
"sys" group.  Over multiple retries using 10-sec intervals, sometimes it 
gave roughly 67% for each task, other times it settled into a 100/50/50 
split that remained stable over time.

3 tasks in sys
  2471 cfriesen  20   0  3800  392  336 R 99.9  0.0   0:29.97 cat
  2470 cfriesen  20   0  3800  392  336 R 50.3  0.0   0:17.83 cat
  2469 cfriesen  20   0  3800  392  336 R 49.6  0.0   0:17.96 cat

retry
  2475 cfriesen  20   0  3800  392  336 R 68.3  0.0   0:28.46 cat
  2476 cfriesen  20   0  3800  392  336 R 67.3  0.0   0:28.24 cat
  2474 cfriesen  20   0  3800  392  336 R 64.3  0.0   0:28.73 cat

  2476 cfriesen  20   0  3800  392  336 R 67.1  0.0   0:41.79 cat
  2474 cfriesen  20   0  3800  392  336 R 66.6  0.0   0:41.96 cat
  2475 cfriesen  20   0  3800  392  336 R 66.1  0.0   0:41.67 cat

retry
  2490 cfriesen  20   0  3800  392  336 R 99.7  0.0   0:22.23 cat
  2489 cfriesen  20   0  3800  392  336 R 49.9  0.0   0:21.02 cat
  2491 cfriesen  20   0  3800  392  336 R 49.9  0.0   0:13.94 cat


With three groups, one task in each, I tried both 10 and 60 second 
intervals.  The longer interval looked better but was still up to 0.8% off:
10-sec
  2490 cfriesen  20   0  3800  392  336 R 68.9  0.0   1:35.13 cat
  2491 cfriesen  20   0  3800  392  336 R 65.8  0.0   1:04.65 cat
  2489 cfriesen  20   0  3800  392  336 R 64.5  0.0   1:26.48 cat

60-sec
  2490 cfriesen  20   0  3800  392  336 R 67.5  0.0   3:19.85 cat
  2491 cfriesen  20   0  3800  392  336 R 66.3  0.0   2:48.93 cat
  2489 cfriesen  20   0  3800  392  336 R 66.2  0.0   3:10.86 cat


Finally, a more complicated scenario.  three tasks in A, two in B, and 
one in C.  The 60-sec trial was up to 0.8 off, while a 3-second trial 
(just for fun) was 8.5% off.

60-sec
2491 cfriesen  20   0  3800  392  336 R 65.9  0.0   5:06.69 cat
  2499 cfriesen  20   0  3800  392  336 R 33.6  0.0   0:55.35 cat
  2490 cfriesen  20   0  3800  392  336 R 33.5  0.0   4:47.94 cat
  2497 cfriesen  20   0  3800  392  336 R 22.6  0.0   0:38.76 cat
  2489 cfriesen  20   0  3800  392  336 R 22.2  0.0   4:28.03 cat
  2498 cfriesen  20   0  3800  392  336 R 22.2  0.0   0:35.13 cat

3-sec
2491 cfriesen  20   0  3800  392  336 R 58.2  0.0  13:29.60 cat
  2490 cfriesen  20   0  3800  392  336 R 34.8  0.0   9:07.73 cat
  2499 cfriesen  20   0  3800  392  336 R 31.0  0.0   5:15.69 cat
  2497 cfriesen  20   0  3800  392  336 R 29.4  0.0   3:37.25 cat
  2489 cfriesen  20   0  3800  392  336 R 23.3  0.0   7:26.25 cat
  2498 cfriesen  20   0  3800  392  336 R 23.0  0.0   3:33.24 cat


Chris
