Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYE0AcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYE0AcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 20:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYE0AcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 20:32:04 -0400
Received: from westnet.com ([216.187.52.2]:59486 "EHLO westnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbYE0AcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 20:32:03 -0400
Date: Mon, 26 May 2008 20:28:58 -0400 (EDT)
From: Greg Smith <gsmith@gregsmith.com>
X-X-Sender: gsmith@westnet.com
To: Mike Galbraith <efault@gmx.de>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
In-Reply-To: <1211586407.4786.5.camel@marge.simson.net>
Message-ID: <Pine.GSO.4.64.0805260851510.24771@westnet.com>
References: <1211440207.5733.8.camel@marge.simson.net> 
 <20080522082814.GA4499@linux.vnet.ibm.com>  <1211447105.4823.7.camel@marge.simson.net>
  <1211452465.7606.8.camel@marge.simson.net>  <1211455553.4381.9.camel@marge.simson.net>
  <1211456659.29104.20.camel@twins>  <1211458176.5693.6.camel@marge.simson.net>
  <1211459081.29104.40.camel@twins>  <Pine.GSO.4.64.0805230232190.28654@westnet.com>
  <1211536814.5851.18.camel@marge.simson.net>  <20080523101000.GA13964@elte.hu>
  <1211537717.5851.22.camel@marge.simson.net>  <Pine.GSO.4.64.0805231907150.25273@westnet.com>
 <1211586407.4786.5.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After spending a whole day testing various scheduler options, I've got a 
pretty good idea how possible improvements here might map out.  Let's 
start with Mike's results (slightly reformatted), from his "grocery store 
Q6600 box" similar to the one my results in this message come from:

 	.22.18	.22.18b	.26.git	.26.git.batch
1	7487	7644	9999	9916
2	17075	15360	14043	14958
3	25073	24802	15621	25047
4	24236	26126	16436	25007
5	26367	28298	19927	27853
6	24696	30787	22376	28119
8	21021	31974	25825	31071
10	22792	31775	26754	31596
15	21202	30389	28712	30963
20	21204	29317	28512	30128
30	18520	27253	26683	28185
40	17936	25671	24965	26282
50	16248	25089	21079	25357

I couldn't replicate that batch mode improvement in 2.6.22 or 2.6.26.git, 
so I asked Mike for some clarification about how he did the batch testing 
here:

> I used a tool someone posted (quite a) a few years ago, which I added
> batch support to.  I just start the script ala
>   schedctl -B ./selecttest.sh.
> I put server startup and shutdown into the script as well, and that's
> the important bit you're missing methinks - postgress must be run as
> SCHED_BATCH, lest each and every instance attain max dynamic priority,
> and preempt pgbench.

Which explains the difference:  I was just running pgbench as "chrt -b cmd 
pgbench ..." which doesn't help at all.  I am uncomfortable with the idea 
of running the database server itself as a batch process.  While it may be 
effective for optimizing this benchmark, I think it's in general a bad 
idea because it may de-tune it for more real-world workloads like web 
applications.  Also, that requires being intrusive into people's setup 
scripts, which bothers me a lot more than doing a bit of kernel tuning at 
system startup.

Mike also suggested a patch that adjusted se.load.weight.  That didn't 
seem helpful in any of the cases I tested, presumably it helps with the 
all batch-mode setup I didn't try properly.

I did again get useful results here with the stock 2.6.26.git kernel and 
default parameters using Peter's small patch to adjust se.waker.

What I found most interesting was how the results changed when I set 
/proc/sys/kernel/sched_features = 0, without doing anything with batch 
mode.  The default for that is 1101111111=895. What I then did was run 
through setting each of those bits off one by one to see which feature(s) 
were getting in the way here.  The two that mattered a lot were 895-32=863 
(no SCHED_FEAT_SYNC_WAKEUPS ) and 895-2=893 (no 
SCHED_FEAT_WAKEUP_PREEMPT).  Combining those two but keeping the rest of 
the features on (895-32-2=861) actually gave the best result I've ever 
seen here, better than with all the features disabled.  Tossing out all 
the tests I did that didn't show anything useful, here's my table of the 
interesting results.

Clients	.22.19	.26.git	waker	f=0	f=893	f=863	f=861
1	7660	11043	11041	9214	11204	9232	9433
2	17798	11452	16306	16916	11165	16686	16097
3	29612	13231	18476	24202	11348	26210	26906
4	25584	13053	17942	26639	11331	25094	25679
6	25295	12263	18472	28918	11761	30525	33297
8	24344	11748	19109	32730	12190	31775	35912
10	23963	11612	19537	31688	12331	29644	36215
15	23026	11414	19518	33209	13050	28651	36452
20	22549	11332	19029	32583	13544	25776	35707
30	22074	10743	18884	32447	14191	21772	33501
40	21495	10406	18609	31704	11017	20600	32743
50	20051	10534	17478	29483	14683	19949	31047
60	18690	9816	17467	28614	14817	18681	29576

Note that compared to earlier test runs, I replaced the 5 client case with 
a 60 client one to get more data on the top end.  I also wouldn't pay too 
much attention to the single client case; that one really bounces around a 
lot on most of the kernel revs, even with me doing 5 runs and using the 
median.

These results give me a short-term answer I can move forward with for now: 
if people want to know how to get useful select-only pgbench results using 
2.6.26-git, I can suggest "echo 861 > /proc/sys/kernel/sched_features" and 
know that will give results that crush the older scheduler without making 
any additional changes.  That's great progress and I appreciate all of 
Mike's work in particular to reaching this point.

Some still open questions after this long investigation that I'd like to 
know the answers to are:

1) Why are my 2.6.26.git results so dramatically worse than the ones Mike 
posted?  I'm not sure what was different about his test setup here.  The 
2.6.22 results are pretty similar, and the fully tuned ones as well, so 
the big difference on that column bugs me.

2) Mike suggested a patch to 2.6.25 in this thread that backports the 
feature for disabling SCHED_FEAT_SYNC_WAKEUPS.  Would it be reasonable to 
push that into 2.6.25.5?  It's clearly quite useful for this load and 
therefore possibly others.

3) Peter's se.waker patch is a big step forward on this workload without 
any tuning, closing a significant amount of the gap between the default 
setup and what I get with the two troublesome features turned off 
altogether.  What issues might there be with pushing that into the stock 
{2.6.25|2.6.26} kernel?

4) What known workloads are there that suffer if SCHED_FEAT_SYNC_WAKEUPS 
and SCHED_FEAT_WAKEUP_PREEMPT are disabled?  I'd think that any attempt to 
tune those code paths would need my case for "works better when 
SYNC/PREEMPT wakeups disabled" as well as a case that works worse to 
balance modifications against.

5) Once (4) has identified some tests cases, what else might be done to 
make the default behavior better without killing the situations it's 
intended for?

--
* Greg Smith gsmith@gregsmith.com http://www.gregsmith.com Baltimore, MD
