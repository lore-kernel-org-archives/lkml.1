Return-Path: <linux-kernel-owner+w=401wt.eu-S1030194AbXCFVhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030194AbXCFVhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030220AbXCFVhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:37:00 -0500
Received: from mail.tmr.com ([64.65.253.246]:59048 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030194AbXCFVg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:36:59 -0500
Message-ID: <45EDDF21.7090602@tmr.com>
Date: Tue, 06 Mar 2007 16:37:37 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Con Kolivas <kernel@kolivas.org>, jos poortvliet <jos@mijnkamer.nl>,
       ck@vds.kolivas.org, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free   interactive
 cpu scheduler
References: <200703041800.53360.kernel@kolivas.org> <200703041708.54953.jos@mijnkamer.nl> <45ECA239.5000306@tmr.com> <200703061118.44616.kernel@kolivas.org> <20070306044112.GA10707@1wt.eu>
In-Reply-To: <20070306044112.GA10707@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Tue, Mar 06, 2007 at 11:18:44AM +1100, Con Kolivas wrote:
>   
>> On Tuesday 06 March 2007 10:05, Bill Davidsen wrote:
>>     
>>> jos poortvliet wrote:
>>>       
>>>> Well, imho his current staircase scheduler already does a better job
>>>> compared to mainline, but it won't make it in (or at least, it's not
>>>> likely). So we can hope this WILL make it into mainline, but I wouldn't
>>>> count on it.
>>>>         
>>> Wrong problem, what is really needed is to get CPU scheduler choice into
>>> mainline, just as i/o scheduler finally did. Con has noted that for some
>>> loads this will present suboptimal performance, as will his -ck patches,
>>> as will the default scheduler. Instead of trying to make ANY one size
>>> fit all, we should have a means to select, at runtime, between any of
>>> the schedulers, and preferably to define an interface by which a user
>>> can insert a new scheduler in the kernel (compile in, I don't mean
>>> plugable) with clear and well defined rules for how that can be done.
>>>       
>> Been there, done that. Wli wrote the infrastructure for plugsched; I took his 
>> code and got it booting and ported 3 or so different scheduler designs. It 
>> allowed you to build as few or as many different schedulers into the kernel 
>> and either boot the only one you built into your kernel, or choose a 
>> scheduler at boot time. That code got permavetoed by both Ingo and Linus. 
>> After that I gave up on that code and handed it over to Peter Williams who 
>> still maintains it. So please note that I pushed the plugsched barrow 
>> previously and still don't think it's a bad idea, but the maintainers think 
>> it's the wrong approach.
>>     
>
> In a way, I think they are right. Let me explain. Pluggable schedulers are
> useful when you want to switch away from the default one. This is very useful
> during development of a new scheduler, as well as when you're not satisfied
> with the default scheduler. Having this feature will incitate many people to
> develop their own scheduler for their very specific workload, and nothing
> generic. It's a bit what happened after all : you, Peter, Nick, and Mike
> have worked a lot trying to provide alternative solutions.
>
> But when you think about it, there are other OSes which have only one scheduler
> and which behave very well with tens of thousands of tasks and scale very well
> with lots of CPUs (eg: solaris). So there is a real challenge here to try to
> provide something at least as good and universal because we know that it can
> exist. And this is what you finally did : work on a scheduler which ought to be
> good with any workload.
>
>   
The problem is not with "any workload," because that's not the issue, 
the issue is the definition of "good" matching the administrator's 
policy. And that's where the problem comes in. We have the default 
scheduler, which favors interactive jobs. We have Con's staircase 
scheduler which is part of an interactivity package. We have the 
absolutely fair scheduler which is, well... fair, and keeps things 
smooth and under reasonable load crisp.

There are other schedulers in the pluggable package, I did a doorknob 
scheduler for 2.2 (everybody gets a turn, special case of round-robin). 
I'm sure people have quietly hacked many more, which have never been 
presented to public view.

The point is that no one CPU scheduler will satisfy the policy needs of 
all users, any more than one i/o scheduler does so. We have realtime 
scheduling, preempt both voluntary and involuntary, why should we not 
have multiple CPU schedulers. If Linus has an objection to plugable 
schedulers, then let's identify what the problem is and address it. If 
that means one scheduler or the other must be compiled in, or all 
compiled in and selected, so be it.

> Then, when we have a generic, good enough scheduler for most situations, I
> think that it could be good to get the plugsched for very specific usages.
> People working in HPC may prefer to allocate ressource differently for
> instance. There may also be people refusing to mix tasks from different users
> on two different siblings of one CPU for security reasons, etc... All those
> would justify a plugable scheduler. But it should not be an excuse to provide
> a set of bad schedulers and no good one.
>
>   
Unless you force the the definition of "good" to "what the default 
scheduler does," there can be no "one" good one. Choice is good, no one 
is calling for bizarre niche implementations, but we have at minimum 
three CPU schedulers which as "best" for a large number of users. 
(current default, and Con's fair and interactive flavors, before you ask).
> The CPU scheduler is often compared to the I/O schedulers while in fact this
> is a completely different story. The I/O schedulers are needed because the
> hardware and filesystems may lead to very different behaviours, and the
> workload may vary a lot (eg: news server, ftp server, cache, desktop, real
> time streaming, ...). But at least, the default I/O scheduler was good enough
> for most usages, and alternative ones are here to provide optimal solutions
> to specific needs.
And multiple schedulers are needed because the type of load, mix of 
loads, and admin preference all require decisions at the policy which 
can't be covered by a single solution. Or at least none of the existing 
solutions, and I think letting people tune the guts of scheduler policy 
is more dangerous than giving a selection of solutions. Linux has been 
about choice all along, I hope it's nearly time for a solution better 
than patches to be presented.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

