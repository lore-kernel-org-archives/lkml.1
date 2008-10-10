Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYJJFof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYJJFof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 01:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYJJFo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 01:44:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47808 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYJJFo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 01:44:26 -0400
Subject: Re: cgroup task groups appears sensitive to absolute magnitude of
	shares
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <48EE8D06.9060503@nortel.com>
References: <48EE8D06.9060503@nortel.com>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 07:44:21 +0200
Message-Id: <1223617461.7382.57.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 17:00 -0600, Chris Friesen wrote:
> When using cgroups-based task groups, the amount of cpu time for each 
> class should be based on the relative shares of the different groups.
> 
> However, my testing shows that the absolute value of the shares matters 
> as well, with larger shares values giving more accurate results (to a 
> point).  Consider the two testcases below, where the only difference is 
> that in the second case all the shares are increased by a factor of 10. 
>   Notice that the accuracy in group 4 is significantly improved.
> 
> 
> [root@localhost schedtest]#  ./fairtest  test5.dat
> using settling delay of 1 sec, runtime of 2 sec
> group hierarchy (name, weight, hogs, expected usage):
> 1,    40,   2, 55.555553
> 2,    20,   2, 27.777777
> 3,    10,   2, 13.888888
> 4,     2,   2, 2.777778
> group       actual(%)    expected(%)   avg latency(ms)  max_latency(ms)
>        1        54.90         55.56               5/5              6/57
>        2        27.43         27.78               8/7              63/8
>        3        13.71         13.89             12/13            18/379
>        4         3.96          2.78               7/7             57/57
> 
> 
> 
> [root@localhost schedtest]# ./fairtest  test3.dat
> using settling delay of 1 sec, runtime of 10 sec
> group hierarchy (name, weight, hogs, expected usage):
> 1,   400,   2, 55.555557
> 2,   200,   2, 27.777779
> 3,   100,   2, 13.888889
> 4,    20,   2, 2.777778
> group      actual(%)    expected(%)   avg latency(ms)  max_latency(ms)
>        1        55.20         55.56               5/5             22/31
>        2        28.02         27.78               7/8             23/21
>        3        14.00         13.89             12/11             20/33
>        4         2.78          2.78               9/9             24/20
> 
> 
> I suspect that this is due to the following calculation in 
> __update_group_shares_cpu():
> 
> shares = (sd_shares * rq_weight) / (sd_rq_weight + 1);
> 
> Because these are integers, the result will give greater rounding error 
> when sd_shares is small.
> 
> Going to 4000/2000/1000/200 doesn't seem to give noticeable 
> improvements, and going to 40000/20000/10000/2000 causes the test to 
> behave unpredictably, either taking abnormally long to complete or else 
> not completing at all.
> 
> Is it worth doing anything about this (automatic normalization of group 
> shares?), or should we just document this behaviour somewhere and live 
> with it?

I'm afraid this is one of the things we'll have to live with. Esp. the
group scheduler runs into the limits of fixed point math, and I'm afraid
I've not yet found a way around that :/

