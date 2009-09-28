Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZI1SUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZI1SUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 14:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZI1SUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 14:20:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbZI1SUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 14:20:37 -0400
Date: Mon, 28 Sep 2009 14:18:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com,
       jens.axboe@oracle.com, Tobias Oetiker <tobi@oetiker.ch>
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20090928181846.GC3643@redhat.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com> <4ABC28DE.7050809@datenparkplatz.de> <20090925202636.GC15007@redhat.com> <4e5e476b0909271000u69d79346s27cccad219e49902@mail.gmail.com> <20090928145655.GB8192@redhat.com> <4e5e476b0909280835w3410d58aod93a29d1dcda8909@mail.gmail.com> <1254160274.9820.25.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254160274.9820.25.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 07:51:14PM +0200, Mike Galbraith wrote:
> On Mon, 2009-09-28 at 17:35 +0200, Corrado Zoccolo wrote:
> 
> > Great.
> > Can you try the attached patch (on top of 2.6.31)?
> > It implements the alternative approach we discussed privately in july,
> > and it addresses the possible latency increase that could happen with
> > your patch.
> > 
> > To summarize for everyone, we separate sync sequential queues, sync
> > seeky queues and async queues in three separate RR strucutres, and
> > alternate servicing requests between them.
> > 
> > When servicing seeky queues (the ones that are usually penalized by
> > cfq, for which no fairness is usually provided), we do not idle
> > between them, but we do idle for the last queue (the idle can be
> > exited when any seeky queue has requests). This allows us to allocate
> > disk time globally for all seeky processes, and to reduce seeky
> > processes latencies.
> > 
> > I tested with 'konsole -e exit', while doing a sequential write with
> > dd, and the start up time reduced from 37s to 7s, on an old laptop
> > disk.
> 
> I was fiddling around trying to get IDLE class to behave at least, and
> getting a bit frustrated.  Class/priority didn't seem to make much if
> any difference for konsole -e exit timings, and now I know why.

You seem to be testing kconsole timings against a writer. In case of a 
writer prio will not make much of a difference as prio only adjusts length
of slice given to process and writers rarely get to use their slice
length. Reader immediately preemtps it...

I guess changing class to IDLE should have helped a bit as now this is
equivalent to setting the quantum to 1 and after dispatching one request
to disk, CFQ will always expire the writer once. So it might happen that
by the the reader preempted writer, we have less number of requests in
disk and lesser latency for this reader.

> I saw
> the reference to Vivek's patch, and gave it a shot.  Makes a large
> difference.
>                                                            Avg
> perf stat     12.82     7.19     8.49     5.76     9.32    8.7     anticipatory
>               16.24   175.82   154.38   228.97   147.16  144.5     noop
>               43.23    57.39    96.13   148.25   180.09  105.0     deadline
>                9.15    14.51     9.39    15.06     9.90   11.6     cfq fairness=0 dd=nice 0
>               12.22     9.85    12.55     9.88    15.06   11.9     cfq fairness=0 dd=nice 19
>                9.77    13.19    11.78    17.40     9.51   11.9     cfq fairness=0 dd=SCHED_IDLE
>                4.59     2.74     4.70     3.45     4.69    4.0     cfq fairness=1 dd=nice 0
>                3.79     4.66     2.66     5.15     3.03    3.8     cfq fairness=1 dd=nice 19
>                2.79     4.73     2.79     4.02     2.50    3.3     cfq fairness=1 dd=SCHED_IDLE
> 

Hmm.., looks like average latency went down only in  case of fairness=1
and not in case of fairness=0. (Looking at previous mail, average vanilla
cfq latencies were around 12 seconds).

Are you running all this in root group or have you put writers and readers
into separate cgroups?

If everything is running in root group, then I am curious why latency went
down in case of fairness=1. The only thing fairness=1 parameter does is
that it lets complete all the requests from previous queue before start
dispatching from next queue. On top of this is valid only if no preemption
took place. In your test case, konsole should preempt the writer so
practically fairness=1 might not make much difference.

In fact now Jens has committed a patch which achieves the similar effect as
fairness=1 for async queues.

commit 5ad531db6e0f3c3c985666e83d3c1c4d53acccf9
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Jul 3 12:57:48 2009 +0200

    cfq-iosched: drain device queue before switching to a sync queue
    
    To lessen the impact of async IO on sync IO, let the device drain of
    any async IO in progress when switching to a sync cfqq that has idling
    enabled.


If everything is in separate cgroups, then we should have seen latency 
improvements in case of fairness=0 case also. I am little perplexed here..

Thanks
Vivek
