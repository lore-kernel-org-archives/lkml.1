Return-Path: <linux-kernel-owner+w=401wt.eu-S1750962AbXCRFA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962AbXCRFA7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 01:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbXCRFA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 01:00:59 -0400
Received: from mtaout1.012.net.il ([84.95.2.1]:49941 "EHLO mtaout1.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbXCRFA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 01:00:58 -0400
Date: Sun, 18 Mar 2007 07:00:53 +0200
From: Avi Kivity <avi@argo.co.il>
Subject: Re: is RSDL an "unfair" scheduler too?
In-reply-to: <20070318012533.GB2986@holomorphy.com>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <45FCC785.9060804@argo.co.il>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Sun,
 18 Mar 2007 07:00:54 +0200 (IST)
References: <200703042335.26785.a1426z@gawab.com>
 <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru>
 <200703172048.46267.kernel@kolivas.org> <20070317114903.GA20673@elte.hu>
 <45FC525D.5000708@argo.co.il> <20070318012533.GB2986@holomorphy.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Sat, Mar 17, 2007 at 10:41:01PM +0200, Avi Kivity wrote:
>   
>> Well, the heuristic here is that process == job.  I'm not sure heuristic 
>> is the right name for it, but it does point out a deficieny.
>> A cpu-bound process with many threads will overwhelm a cpu-bound single 
>> threaded threaded process.
>> A job with many processes will overwhelm a job with a single process.
>> A user with many jobs can starve a user with a single job.
>> I don't think the problem here is heuristics, rather that the 
>> scheduler's manages cpu quotas at the task level rather than at the user 
>> visible level.  If scheduling were managed at all three hierarchies I 
>> mentioned ('job' is a bit artificial, but process and user are not) then:
>> - if N users are contending for the cpu on a multiuser machine, each 
>> should get just 1/N of available cpu power.  As it is, a user can run a 
>> few of your #1 workloads (or a make -j 20) and slow every other user down
>> - your example would work perfectly (if we can communicate to the kernel 
>> what a job is)
>> - multi-threaded processes would not get an unfair advantage
>>     
>
> I like this notion very much. I should probably mention pgrp's' typical
> association with the notion of "job," at least as far as shells go.
>
>   

One day I might understand what pgrp, sessions, and all that stuff is.

> One issue this raises is prioritizing users on a system, threads within
> processes, jobs within users, etc. Maybe sessions would make sense, too,
> and classes of users, and maybe whatever they call the affairs that pid
> namespaces are a part of (someone will doubtless choke on the hierarchy
> depth implied here but it doesn't bother me in the least). It's not a
> deep or difficult issue. There just needs to be some user API to set the
> relative scheduling priorities of all these affairs within the next higher
> level of hierarchy, regardless of how many levels of hierarchy (aleph_0?).
>   

I think it follows naturally.

Note that more than the scheduler needs to be taught about this.  The 
page cache and swapper should prevent a user from swapping out too many 
of another user's pages when there is contention for memory; there 
should be per-user quotas for network and disk bandwidth, etc.  Until 
then people who want true multiuser with untrusted users will be forced 
to use ugly hacks like virtualization.  Fortunately it seems the 
container people are addressing at least a part of this.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

