Return-Path: <linux-kernel-owner+w=401wt.eu-S1762660AbXGXHDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762660AbXGXHDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbXGXHDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:03:48 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42070 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbXGXHDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:03:47 -0400
Date: Tue, 24 Jul 2007 12:43:20 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: System hangs on running kernbench
Message-ID: <20070724071320.GA12169@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070718075648.GA4235@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718075648.GA4235@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 01:26:48PM +0530, Dhaval Giani wrote:
> Hi Andrew,
> 
> I was running kernbench on top of 2.6.22-rc6-mm1 and I got a Hangcheck
> alert (This is when kernbench reached make -j).
> 
> Also make -j is hanging.

[refer http://marc.info/?l=linux-kernel&m=118474574807055 for complete
report of this bug]

Ingo,
	Dhaval tracked the root cause of this problem to be in cfs (btw
cfs patches weren't git-bisect safe).

Basically, "make -s -j" workload hanged the machine, leading to lot of
OOM killings. This was on a 8-cpu machine with no swap space configured and
4GB RAM. The same workload works "fine" (runs to completion) on 2.6.22.

I played with the scheduler tunables a bit and found that the problem
goes away if I set sched_granularity_ns to 100ms (default value 32ms).

So my theory is this: 32ms preemption granularity is too low value for
any compile thread to make "usefull" progress. As a result of this rapid
context switch, job retiral rate slows down compared to job arrival
rate. This builds up job pressure on the system very quickly (than may
have happened with 100ms default granularity_ns or 2.6.22 kernel),
leading to OOM killings (and hang).

>From a user perspective, who is running with default granularity_ns
value, this may be seen as a regression.

Perhaps, these new tunables in cfs are something for users to become used to
and tune it to approp setting for their system. It would have been
nice for kernel to auto-tune the settings based on workload, but I guess
that's harder.

--
Regards,
vatsa
