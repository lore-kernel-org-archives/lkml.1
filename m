Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbXCRDTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbXCRDTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 23:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbXCRDTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 23:19:40 -0400
Received: from mail.tmr.com ([64.65.253.246]:42049 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbXCRDTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 23:19:38 -0400
Message-ID: <45FCB0A4.8070205@tmr.com>
Date: Sat, 17 Mar 2007 22:23:16 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Con Kolivas <kernel@kolivas.org>,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, vishpat@gmail.com
Subject: Re: is RSDL an "unfair" scheduler too?
References: <200703042335.26785.a1426z@gawab.com> <200703172302.10819.kernel@kolivas.org> <20070317122831.GA28429@elte.hu> <200703172343.53480.kernel@kolivas.org> <20070317163434.GB30162@elte.hu>
In-Reply-To: <20070317163434.GB30162@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> * Con Kolivas <kernel@kolivas.org> wrote:
> 
>> Ok but please look at how it appears from my end (illness aside).
> 
> ( i really think we should continue this debate after you get better. 
>   Everything looks much darker when you are ill! )
> 
>> You initially said you were pleased with this design.
> 
> I said that 2 years ago about the staircase scheduler and i am still 
> saying this about RSDL today. That doesnt make my position automatically 
> correct though :-) For example i wrote and maintained the 4g:4g patchset 
> for over 2 years and still that was no guarantee of it making sense 
> upstream ;) And it was a hell of a lot of work (much uglier and nastier 
> work than any scheduler hacking and tuning, believe me), and it was 
> thrown away as a cute but unnecessary complication we dont need. So 
> what? To me what matters is the path you walk, not the destination you 
> reach.
> 
> in terms of RSDL design, i like it, still i'm kind of asking myself 
> 'couldnt something in this direction be done in a much simpler and less 
> revolutionary way'? For example couldnt we introduce per-priority level 
> timeslice quotas in the current scheme as well, instead of the very 
> simplistic and crude STARVATION_LIMIT approach? Furthermore, couldnt we 
> make the timeslices become smaller as the runqueue length increases, to 
> make starvation less of a problem? It seems like the problem cases with 
> the current scheduler arent so much centered around the interactivity 
> estimator, it is more that timeslices get distributed too coarsely, 
> while RSDL distributes timeslices in a more finegrained way and is thus 
> less suspect to starvation under certain workloads.

Yes. The "doorknob scheduler" was a scheduler which worked as follows: 
the runnable processes in the system were put in a priority sorted list 
and counted. Then the length of one cycle (turn) was divided by the 
number of processes and that was the timeslice. In the next version 
upper and lower limits were put on the length of a timeslice, so the 
system didn't get eaten by context switches under load or be jerky under 
light load. That worked fairly well.

Then people got into creating unfairness to address what they thought 
were corner cases, the code turned into a plumber's nightmare, and 
occasional jackpot cases created occasional (non-reproducible) hangs.

Finally management noted that the peripherals cost three times as much 
as the CPU, so jobs doing i/o should run first. That made batch run like 
the clappers of hell, and actually didn't do all the bad things you 
might expect. User input was waitio, disk was waitio, response was about 
as good as it could be for that hardware.

===> it might be useful to give high priority to a process going from 
waitio to runable state, once only.

The "doorknob" term came from "everybody gets a turn" and the year was 1970.

Avi Kivity wrote:
> Well, the heuristic here is that process == job. I'm not sure
> heuristic is the right name for it, but it does point out a
> deficieny.
 >
> A cpu-bound process with many threads will overwhelm a cpu-bound
> single threaded threaded process.
 >
 > A job with many processes will overwhelm a job with a single process.
 >
 > A user with many jobs can starve a user with a single job.
 >
> I don't think the problem here is heuristics, rather that the 
> scheduler's manages cpu quotas at the task level rather than at the
> user visible level. If scheduling were managed at all three
> hierarchies I mentioned ('job' is a bit artificial, but process and
> user are not) then:
 >
> - if N users are contending for the cpu on a multiuser machine, each 
> should get just 1/N of available cpu power. As it is, a user can run
> a few of your #1 workloads (or a make -j 20) and slow every other
> user down - your example would work perfectly (if we can communicate
> to the kernel what a job is)
 >
 > - multi-threaded processes would not get an unfair advantage

If we wanted to do this, a job would be defined as all children or 
threads of the oldest parent process with a PPID of one. So if I logged 
on  and did
   make -j4
on a kernel, and someone else did:
   find /var -type f | xargs grep -l zumblegarfe
and someone else was doing:
   foo & mumble & barfe

We would all be equal. That's good! And there would be some recursive 
scheduler which would pick a "job" and then a process, and run it. That 
too is good!

But we have a mail server, and there are 671 threads with a socket and 
POP3 user on each one, and they only get 1/N of a job worth of CPU 
between them, and that sucks rocks off the bottom of the ocean. So 
pretty soon the code gets some "fixes" to make POP3 work, and X work, 
and the code once again becomes plumber's nightmare... Then you start 
playing with process groups to address some of this, and address exec() 
corner cases, and complexity goes way up again. This is NOT an easy problem!

I think Con has done a good job, I think in most cases (heresy) the 
current mainline scheduler does a pretty good job. I'm in favor of 
having several schedulers, because I don't believe any one can match the 
behavior goals of all users.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
