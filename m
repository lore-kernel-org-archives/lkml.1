Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbXCLViK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbXCLViK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932536AbXCLViK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:38:10 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:45604 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386AbXCLViI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AlgkBYOUWNd2/+OCFIh2mABWaAlCG/uHC97b67xuWcMf1syEskqGP2x3wo6rNmjATJIQlc0s5zOv+Q9Iu39pEXjwpBDBiFEP/l6EbHzxAH1D7KC8/P+9xxu7g2NRl1Ff/S3gXTBFAy8JUWIw+KtEaB/FFhOk0pGzH+zsX6iEAXk=
Message-ID: <b14e81f00703121438q6cdaffd0vdb08e0386961f057@mail.gmail.com>
Date: Mon, 12 Mar 2007 17:38:06 -0400
From: "michael chang" <thenewme91@gmail.com>
To: "Con Kolivas" <kernel@kolivas.org>, "Mike Galbraith" <efault@gmx.de>
Subject: Re: [ck] Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Cc: "ck list" <ck@vds.kolivas.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200703130738.19034.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703111457.17624.kernel@kolivas.org>
	 <200703130549.47058.kernel@kolivas.org>
	 <1173730314.6431.30.camel@Homer.simpson.net>
	 <200703130738.19034.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, Con Kolivas <kernel@kolivas.org> wrote:
> On Tuesday 13 March 2007 07:11, Mike Galbraith wrote:
> > On Tue, 2007-03-13 at 05:49 +1100, Con Kolivas wrote:
> > > On Tuesday 13 March 2007 01:34, Mike Galbraith wrote:
> > > > On Mon, 2007-03-12 at 22:23 +1100, Con Kolivas wrote:
> > > > > Mike the cpu is being proportioned out perfectly according to
> > > > > fairness as I mentioned in the prior email, yet X is getting the
> > > > > lower latency scheduling. I'm not sure within the bounds of fairness
> > > > > what more would you have happen to your liking with this test case?
> > > >
> > > > It has been said that "perfection is the enemy of good".  The two
> > > > interactive tasks receiving 40% cpu while two niced background jobs
> > > > receive 60% may well be perfect, but it's damn sure not good.
> > >
> > > Again I think your test is not a valid testcase. Why use two threads for
> > > your encoding with one cpu? Is that what other dedicated desktop OSs
> > > would do?
> >
> > The testcase is perfectly valid.  My buddies box has two full cores, so
> > we used two encoders such that whatever bandwidth is not being actively
> > consumed by more important things gets translated into mp3 encoding.
> >
> > How would you go about ensuring that there won't be any cycles wasted?
> >
> > _My_ box has 1 core that if fully utilized translates to 1.2 cores.. or
> > whatever, depending on the phase of the moon.  But no matter, logical vs
> > physical cpu argument is pure hand-waving.  What really matters here is
> > the bottom line: your fair scheduler ignores the very real requirements
> > of interactivity.
>
> Definitely not. It does not give unfair cpu towards interactive tasks. That's
> a very different argument.

I think the issue here is that the scheduler is doing what Con expects
it to do, but not what Mike Galbraith here feels it should do. Maybe
Con and Mike here are using different definitions, as such, for
"interactivity", or at least have different ideas of how this is
supposed to be accomplished. Does that sound right?

I've begun using RSDL on my machines here, and so far there haven't
been any issues with it, in my opinion. From a feel standpoint, it's
not what I would call perfectly smooth, but it is better than the
other schedulers I've seen (and the one case where there are still
problems it is an issue of I/O contention, not CPU -- using RSDL has
made a surprisingly large impact regardless).

Perhaps, Mike Galbraith, do you feel that it should be possible to use
the CPU at 100% for some task and still maintain excellent
interactivity? (It has always seemed to me that if you wanted
interactivity, you had to have the CPU idle at least a couple percent
of the time. How much or how little that many percent had to be was
usually affected by how much preempting you put in the kernel, and
what CPU scheduler was in it at the time.)

Considering the concepts put out by projects such as BOINC and
SETI@Home, I wouldn't be thoroughly surprised by this ideology,
although I do question the particular way this test case is being run.

That said, I haven't run the test case in particular yet, although I
will see if I can get the time to do so soon. In any case, I
personally do have a few qualms about this test case being run on HT
virtual cores:

* I am curious about why splitting a task and running them on separate
HT virtual cores improves interactivity any. (If it was Amarok on one
virtual CPU and one lame on the other, I would get it. But I see two
lame processes here -- wouldn't they just be allocated one to each
virtual CPU, leaving Amarok out most of the time? How do you get
interactivity with that?) Does using HT really fill up the CPU better
than having the CPU announce itself as the single core it is? My
understanding is that throughput goes down somewhat even just by using
multiple threads with HT, compared to the single thread on the single
core, and why would you use more than one lame thread unless you seek
throughput?

* Where are the lame processes encoding to/from? For example, are the
results for both being sent to /dev/null? To a hard drive? etc. etc.
In a real-world test case, I would imagine a user running TWO lame
processes would be encoding from two sources to the same hard drive.
(Or, they might even be both encoding FROM that same hard drive. Or
both.) The need for the single HD to seek so much reduces throughput
on most of these cases in HT, IIRC, which may be a factor that would
probably defeat the point of this case for most users. Of course, my
point is negated if they have multiple drives for their use of lame,
and/or if they have sufficient memory and bandwidth to handle the
issue, or if encoding throughput isn't their aim.

The only reason I can think of that running two lame processes would
improve "interactivity" would be so that if one particular portion
gets stuck, then there's a chance the other thread will be working on
an easier portion, making it appear like more is being done.  This
occurs, for example, with POV-Ray and Blender, where some parts of the
image may require more time to render than others due to the variable
complexity of various portions of a 3D image. In this case, using HT
or multiple threads makes it more likely that at least one thread will
be working on an "easy" spot, which would increase the number of
pixels on screen in e.g. the middle of the render. However, the
overall render usually wouldn't speed up on HT. In fact, the whole
image may even take slightly longer due to the overhead of the
threading, although that overhead is trivial for most users when they
are using it. (And of course, the overhead would be negligible when
you had two or more actual cores, because the increase would be more
like 1.85x when you factored out the overhead. HT, by contrast, would
give you, maybe 0.97x. Or whatever.)

As for the realism of the scenario, maybe one might have a Linux
server that is broadcasting/encoding the same source for multiple bit
rates (e.g. Internet Radio) might run multiple lame instances... on a
single core with HT. Not the most common thing in the world, but there
are still quite a few of these guys out there. Enough to be of
concern, IMO.

Con has indicated somewhere recently he has an idea about improving
negative nice; among other things -- maybe RSDL isn't capable of
handling this test case yet, but it might very soon. Considering that
any process not run at the top nice level ends up with pockets of
smoothness followed by pauses of a determinable size, processes like
lame that handle bits and pieces as fast at they come but need to do
so at a steady rate may act peculiarly (not smoothly?) under RSDL.

One last thing I'm not sure about: Mike, are you upset about lame
interfering with Amarok, or lame in and of itself? Which process do
you feel is getting too much or too little CPU? Why?

> > > And let's not lose sight of things with this one testcase.
> > >
> > > RSDL fixes
> > > - every starvation case
> > > - all fairness isssues
> > > - is better 95% of the time on the desktop
> >
> > I don't know where you got that 95% number from.  For the most part, the
> > existing scheduler does well.  If it sucked 95% of the time, it would
> > have been shredded a long time ago.
>
> Check the number of feedback reports. I don't feel petty enough to count them
> personally to give you an accuracte percentage.

I think Con is saying here that Mike, you are one of two or so people
so far to have given a primarily negative feedback report on RSDL. (I
think akpm hit a snag on some PPC box with -mm a while back, IIRC, and
then there's you. I'm only on -ck, though, so there may be others I
haven't heard about. But these two pale in comparison to the
complements I've seen on-list.) Of course, it's still important that
we see WHY it doesn't work well for you, while everyone else is having
fewer (or no) issues.

> > > If we fix 95% of the desktop and worsen 5% is that bad given how much
> > > else we've gained in the process?
> >
> > Killing the known corner case starvation scenarios is wonderful, but
> > let's not just pretend that interactive tasks don't have any special
> > requirements.
>
> Now you're really making a stretch of things. Where on earth did I say that
> interactive tasks don't have special requirements? It's a fundamental feature
> of this scheduler that I go to great pains to get them as low latency as
> possible and their fair share of cpu despite having a completely fair cpu
> distribution.

This seems to me like he's saying that there has to be a mechanism
(outside of nice) that can be used to treat processes that "I" want to
be interactive all special-like. It feels like something that would
have been said in the design of what the scheduler was in -ck and is
currently in vanilla.

To me, that fundamentally clashes with the design behind RSDL. That
said, I could be wrong -- Con appears to have something that could be
very promising up his sleeve that could come out sooner or later. Once
he's written it, of course. In any case, RSDL seems very promising,
for the most part.

--
Michael Chang
