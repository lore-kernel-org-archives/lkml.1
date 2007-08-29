Return-Path: <linux-kernel-owner+w=401wt.eu-S1760316AbXH2Dmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316AbXH2Dmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 23:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757726AbXH2Dmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 23:42:39 -0400
Received: from mail.tmr.com ([64.65.253.246]:34883 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759197AbXH2Dmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 23:42:38 -0400
Message-ID: <46D4EB2E.9000300@tmr.com>
Date: Tue, 28 Aug 2007 23:42:38 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Al Boldi <a1426z@gawab.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
References: <200708111344.42934.a1426z@gawab.com> <200708220127.30698.a1426z@gawab.com> <20070824134510.GA21382@elte.hu> <200708260127.32238.a1426z@gawab.com> <20070825231525.GA334@elte.hu>
In-Reply-To: <20070825231525.GA334@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Al Boldi <a1426z@gawab.com> wrote:
> 
>>> ok. I think i might finally have found the bug causing this. Could 
>>> you try the fix below, does your webserver thread-startup test work 
>>> any better?
>> It seems to help somewhat, but the problem is still visible.  Even 
>> v20.3 on 2.6.22.5 didn't help.
>>
>> It does look related to ia-boosting, so I turned off __update_curr 
>> like Roman mentioned, which had an enormous smoothing effect, but then 
>> nice levels completely break down and lockup the system.
> 
> you can turn sleeper-fairness off via:
> 
>    echo 28 > /proc/sys/kernel/sched_features
> 
> another thing to try would be:
> 
>    echo 12 > /proc/sys/kernel/sched_features

14, and drop the granularity to 500000.
> 
> (that's the new-task penalty turned off.)
> 
> Another thing to try would be to edit this:
> 
>         if (sysctl_sched_features & SCHED_FEAT_START_DEBIT)
>                 p->se.wait_runtime = -(sched_granularity(cfs_rq) / 2);
> 
> to:
> 
>         if (sysctl_sched_features & SCHED_FEAT_START_DEBIT)
>                 p->se.wait_runtime = -(sched_granularity(cfs_rq);
> 
> and could you also check 20.4 on 2.6.22.5 perhaps, or very latest -git? 
> (Peter has experienced smaller spikes with that.)
> 
> 	Ingo


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
