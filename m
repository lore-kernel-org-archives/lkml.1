Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYJIXAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYJIXAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYJIXAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:00:30 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:42040 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYJIXAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:00:30 -0400
Message-ID: <48EE8D06.9060503@nortel.com>
Date: Thu, 09 Oct 2008 17:00:22 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: cgroup task groups appears sensitive to absolute magnitude of shares
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2008 23:00:26.0401 (UTC) FILETIME=[D1561110:01C92A62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When using cgroups-based task groups, the amount of cpu time for each 
class should be based on the relative shares of the different groups.

However, my testing shows that the absolute value of the shares matters 
as well, with larger shares values giving more accurate results (to a 
point).  Consider the two testcases below, where the only difference is 
that in the second case all the shares are increased by a factor of 10. 
  Notice that the accuracy in group 4 is significantly improved.


[root@localhost schedtest]#  ./fairtest  test5.dat
using settling delay of 1 sec, runtime of 2 sec
group hierarchy (name, weight, hogs, expected usage):
1,    40,   2, 55.555553
2,    20,   2, 27.777777
3,    10,   2, 13.888888
4,     2,   2, 2.777778
group       actual(%)    expected(%)   avg latency(ms)  max_latency(ms)
       1        54.90         55.56               5/5              6/57
       2        27.43         27.78               8/7              63/8
       3        13.71         13.89             12/13            18/379
       4         3.96          2.78               7/7             57/57



[root@localhost schedtest]# ./fairtest  test3.dat
using settling delay of 1 sec, runtime of 10 sec
group hierarchy (name, weight, hogs, expected usage):
1,   400,   2, 55.555557
2,   200,   2, 27.777779
3,   100,   2, 13.888889
4,    20,   2, 2.777778
group      actual(%)    expected(%)   avg latency(ms)  max_latency(ms)
       1        55.20         55.56               5/5             22/31
       2        28.02         27.78               7/8             23/21
       3        14.00         13.89             12/11             20/33
       4         2.78          2.78               9/9             24/20


I suspect that this is due to the following calculation in 
__update_group_shares_cpu():

shares = (sd_shares * rq_weight) / (sd_rq_weight + 1);

Because these are integers, the result will give greater rounding error 
when sd_shares is small.

Going to 4000/2000/1000/200 doesn't seem to give noticeable 
improvements, and going to 40000/20000/10000/2000 causes the test to 
behave unpredictably, either taking abnormally long to complete or else 
not completing at all.

Is it worth doing anything about this (automatic normalization of group 
shares?), or should we just document this behaviour somewhere and live 
with it?

Chris
