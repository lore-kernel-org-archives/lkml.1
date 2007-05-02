Return-Path: <linux-kernel-owner+w=401wt.eu-S1766933AbXEBRsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766933AbXEBRsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766949AbXEBRsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:48:10 -0400
Received: from holomorphy.com ([66.93.40.71]:37423 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766933AbXEBRsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:48:08 -0400
Date: Wed, 2 May 2007 10:48:29 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Ting Yang <tingy@cs.umass.edu>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502174829.GX19966@holomorphy.com>
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu> <20070502173634.GA11308@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502173634.GA11308@in.ibm.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 10:57:14PM -0400, Ting Yang wrote:
>>  "A Proportional Share REsource Allocation Algorithm for Real-Time, 
>> Time-Shared Systems", by Ion Stoica. You can find the paper here: 
>> http://citeseer.ist.psu.edu/37752.html

On Wed, May 02, 2007 at 11:06:34PM +0530, Srivatsa Vaddagiri wrote:
> Good paper ..thanks for the pointer.
> I briefly went thr' the paper and my impression is it expect each task
> to specify the length of each new request it initiates. Is that correct?
> If we have to apply EEVDF to SCHED_NORMAL task scheduling under CFS, how
> would we calculate that "length of each new request" (which is reqd
> before we calculate its virtual deadline)?

l_i and w_i are both functions of the priority. You essentially arrange
l_i to express QoS wrt. latency, and w_i to express QoS wrt. bandwidth.


On Tue, May 01, 2007 at 10:57:14PM -0400, Ting Yang wrote:
>>  EXAMPLE: assume the system runs at 1000 tick/second, i.e. 1ms a tick, 
>> and the granularity of pre-exemption for CFS is 5 virtual ticks (the 
>> current setting). If, at time t=0, we start 2 tasks: p1 and p2, both 
>> have nice value 0 (weight 1024), and rq->fair_clock is initialized to 0. 
>> Now we have: 
>>        p1->fair_key = p2->fair_key = rq->fair_clock = 0.
>> CFS breaks the tie arbitrarily, say it executes p1. After 1 system tick 
>> (1ms later) t=1, we have:
>>        rq->fair_clock = 1/2, p1->fair_key = 1,  p2->fair_key = 0.
>> Suppose, a new task p3 starts with nice value -10 at this moment, that 
>> is p3->fair_key=1/2. In this case, CFS will not schedule p3 for 
>> execution until the fair_keys of p1 and p2 go beyond 5+1/2 (which 
>> translates to about 10ms later in this setting), _regardless_ the 
>> priority (weight) of p3.

On Wed, May 02, 2007 at 11:06:34PM +0530, Srivatsa Vaddagiri wrote:
> There is also p->wait_runtime which is taken into account when
> calculating p->fair_key. So if p3 had waiting in runqueue for long
> before, it can get to run quicker than 10ms later.

Virtual time is time from the task's point of view, which it has spent
executing. ->wait_runtime is a device to subtract out time spent on the
runqueue but not running from what would otherwise be virtual time to
express lag, whether deliberately or coincidentally. ->wait_runtime
would not be useful for EEVDF AFAICT, though it may be interesting to
report.


-- wli
