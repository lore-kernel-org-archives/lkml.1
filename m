Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbYHKMtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbYHKMtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 08:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYHKMtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 08:49:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42419 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYHKMtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 08:49:10 -0400
Date: Mon, 11 Aug 2008 14:48:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [revert] mysql+oltp regression
Message-ID: <20080811124857.GD10082@elte.hu>
References: <1218454322.25098.24.camel@marge.simson.net> <20080811114324.GA23529@elte.hu> <48A03049.202@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A03049.202@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

> Ingo Molnar wrote:
>> * Mike Galbraith <efault@gmx.de> wrote:
>>
>>   
>>> Greetings,
>>>
>>> During regression testing of tip/sched/clock fixes, a regression in  
>>> low client count throughput turned up, which I traced this back to 
>>> the commit below.  I don't see anything wrong with it, but suspect 
>>> that it is preventing client/server pairs from staying together on 
>>> the same CPU as buddies, which mysql definitely likes quite a lot.  
>>> (I suspect that this is the case, because I've seen this same 
>>> performance curve while tinkering with wakeup affinity and breaking 
>>> it all to pieces;)
>>>
>>> Changelog and test results below in case nobody sees a problem with  
>>> the commit itself.
>>>     
>>
>> i've applied your fix to tip/sched/urgent for the time being, thanks  
>> Mike for tracking it down. We can re-try newer iterations of Greg's  
>> patch in tip/sched/devel.
>>
>>   
>
> Hmm..  The patch still looks correct afaict.  I fear we are just 
> papering over some other issue by reverting it, but I will try to see 
> if I can track this down.  We will, of course, now be skipping trying 
> to balance the (effectively random) last task in the queue which may 
> or may not result in better performance on sheer luck instead of 
> algorithmic intelligence.  This makes me nervous.

yeah - but we had that behavior for quite some time.

This is how the patch cycle works normally: we had a fair chance to 
discover this problem in your testing then in -tip testing and then in 
linux-next or -mm but we didnt find it at any stage.

Now we are in the upstream release cycle so unless there's some 
immediate fix available (or there are _really_ strong reasons against 
the revert) doing the revert is the right approach.

A revert is not necessarily the indicator of the quality of the change 
in question, it is a tester-driven exception event that guarantees that 
the kernel improves in a monotonic way. (for all testers who opt to help 
us in doing so)

And given that the problem was readily reproducible for Mike, it should 
be reproducible for you as well - so we dont actually make the bug 
harder to fix by doing the revert.

Perhaps we should introduce the notion of "Defer-to-next-release" 
reverts - which this really is - in contrast to "Revert-because-bad", 
which your change definitely is not.

> Speaking of this: Another patch I submitted to you Ingo (had to do 
> with updating the load_weight inside task_setprio) seems to also have 
> this phenomenon: e.g. its technically correct but further testing has 
> revealed negative repercussions elsewhere.  So please ignore that 
> patch (or revert if you already pulled in, but I don't think you 
> have).  Ill try to look into this issue as well.

ok, under which thread/subject is that? Not queued in tip/sched/* yet, 
correct?

	Ingo
