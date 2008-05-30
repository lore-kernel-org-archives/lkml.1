Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbYE3L15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbYE3L15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 07:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbYE3L1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 07:27:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54123 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbYE3L1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 07:27:46 -0400
Date: Fri, 30 May 2008 17:06:53 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       pj@sgi.com, Balbir Singh <balbir@in.ibm.com>,
       aneesh.kumar@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com
Subject: Re: fair group scheduler not so fair?
Message-ID: <20080530113653.GI12836@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <4834B75A.40900@nortel.com> <20080527171528.GD30285@linux.vnet.ibm.com> <483C4F5A.2010104@nortel.com> <20080528163318.GG30285@linux.vnet.ibm.com> <483DA5E7.5050600@nortel.com> <20080529164607.GC12836@linux.vnet.ibm.com> <483F207D.4010908@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483F207D.4010908@nortel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 03:30:37PM -0600, Chris Friesen wrote:
> Overall the group scheduler results look better, but I'm seeing an odd 
> scenario within a single group where sometimes I get a 67/67/66 breakdown 
> but sometimes it gives 100/50/50.

Hmm ..I cant recreate this 100/50/50 situation (tried about 10 times).

> Also, although the long-term results are good, the shorter-term fairness 
> isn't great.  Is there a tuneable that would allow for a tradeoff between 
> performance and fairness?

The tuneables I can think of are:

- HZ (higher the better)
- min/max_interval and imbalance_pct for each domain (lower the better)

> I have people that are looking for within 4% fairness over a 1sec interval.

That seems to be pretty difficult to achieve with the per-cpu runqueue
and smpnice based load balancing approach we have now.

> Initially I tried a simple setup with three hogs all in the default "sys" 
> group.  Over multiple retries using 10-sec intervals, sometimes it gave 
> roughly 67% for each task, other times it settled into a 100/50/50 split 
> that remained stable over time.

Was this with imbalance_pct set to 105? Does it make any difference if
you change imbalance_pct to say 102?

> 3 tasks in sys
>  2471 cfriesen  20   0  3800  392  336 R 99.9  0.0   0:29.97 cat
>  2470 cfriesen  20   0  3800  392  336 R 50.3  0.0   0:17.83 cat
>  2469 cfriesen  20   0  3800  392  336 R 49.6  0.0   0:17.96 cat
>
> retry
>  2475 cfriesen  20   0  3800  392  336 R 68.3  0.0   0:28.46 cat
>  2476 cfriesen  20   0  3800  392  336 R 67.3  0.0   0:28.24 cat
>  2474 cfriesen  20   0  3800  392  336 R 64.3  0.0   0:28.73 cat
>
>  2476 cfriesen  20   0  3800  392  336 R 67.1  0.0   0:41.79 cat
>  2474 cfriesen  20   0  3800  392  336 R 66.6  0.0   0:41.96 cat
>  2475 cfriesen  20   0  3800  392  336 R 66.1  0.0   0:41.67 cat
>
> retry
>  2490 cfriesen  20   0  3800  392  336 R 99.7  0.0   0:22.23 cat
>  2489 cfriesen  20   0  3800  392  336 R 49.9  0.0   0:21.02 cat
>  2491 cfriesen  20   0  3800  392  336 R 49.9  0.0   0:13.94 cat
>
>
> With three groups, one task in each, I tried both 10 and 60 second 
> intervals.  The longer interval looked better but was still up to 0.8% off:

I honestly don't know if we can do better than 0.8%! In any case, I'd
expect that it would require more drastic changes.

> 10-sec
>  2490 cfriesen  20   0  3800  392  336 R 68.9  0.0   1:35.13 cat
>  2491 cfriesen  20   0  3800  392  336 R 65.8  0.0   1:04.65 cat
>  2489 cfriesen  20   0  3800  392  336 R 64.5  0.0   1:26.48 cat
>
> 60-sec
>  2490 cfriesen  20   0  3800  392  336 R 67.5  0.0   3:19.85 cat
>  2491 cfriesen  20   0  3800  392  336 R 66.3  0.0   2:48.93 cat
>  2489 cfriesen  20   0  3800  392  336 R 66.2  0.0   3:10.86 cat
>
>
> Finally, a more complicated scenario.  three tasks in A, two in B, and one 
> in C.  The 60-sec trial was up to 0.8 off, while a 3-second trial (just for 
> fun) was 8.5% off.
>
> 60-sec
> 2491 cfriesen  20   0  3800  392  336 R 65.9  0.0   5:06.69 cat
>  2499 cfriesen  20   0  3800  392  336 R 33.6  0.0   0:55.35 cat
>  2490 cfriesen  20   0  3800  392  336 R 33.5  0.0   4:47.94 cat
>  2497 cfriesen  20   0  3800  392  336 R 22.6  0.0   0:38.76 cat
>  2489 cfriesen  20   0  3800  392  336 R 22.2  0.0   4:28.03 cat
>  2498 cfriesen  20   0  3800  392  336 R 22.2  0.0   0:35.13 cat
>
> 3-sec
> 2491 cfriesen  20   0  3800  392  336 R 58.2  0.0  13:29.60 cat
>  2490 cfriesen  20   0  3800  392  336 R 34.8  0.0   9:07.73 cat
>  2499 cfriesen  20   0  3800  392  336 R 31.0  0.0   5:15.69 cat
>  2497 cfriesen  20   0  3800  392  336 R 29.4  0.0   3:37.25 cat
>  2489 cfriesen  20   0  3800  392  336 R 23.3  0.0   7:26.25 cat
>  2498 cfriesen  20   0  3800  392  336 R 23.0  0.0   3:33.24 cat

I ran with this configuration:

	HZ = 1000, 
	min/max_interval = 1
	imbalance_pct = 102

My 10-sec fairness looks like below (Error = 1.5%):

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  #C COMMAND
 4549 root      20   0  1384  228  176 R 65.2  0.0   0:36.02  0 hogc
 4547 root      20   0  1384  228  176 R 32.8  0.0   0:17.87  0 hogb
 4548 root      20   0  1384  228  176 R 32.6  0.0   0:18.28  1 hogb
 4546 root      20   0  1384  232  176 R 22.9  0.0   0:11.82  1 hoga
 4545 root      20   0  1384  228  176 R 22.3  0.0   0:11.74  1 hoga
 4544 root      20   0  1384  232  176 R 22.1  0.0   0:11.93  1 hoga

3-sec fairness (error = 2.3% ..sometimes went upto 6.7%)

 4549 root      20   0  1384  228  176 R 69.0  0.0   1:33.56  1 hogc
 4548 root      20   0  1384  228  176 R 32.7  0.0   0:46.74  1 hogb
 4547 root      20   0  1384  228  176 R 29.3  0.0   0:47.16  0 hogb
 4546 root      20   0  1384  232  176 R 22.3  0.0   0:30.80  0 hoga
 4544 root      20   0  1384  232  176 R 20.3  0.0   0:30.95  0 hoga
 4545 root      20   0  1384  228  176 R 19.4  0.0   0:31.17  0 hoga

-- 
Regards,
vatsa
