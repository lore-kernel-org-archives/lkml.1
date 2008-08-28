Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbYH1MEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbYH1MEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 08:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYH1MD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 08:03:58 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:22253 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751997AbYH1MD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 08:03:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WcfTt6ie0xDkocJ61yaxsngxrQu/f9aGQSXYaz/wf6Mh77FT3EjIj1ZjcbM5Ua+tCOAJ22pK+dfhucqsM6FcP0X0rMZOJgy1+W6/dFYqWZdOichs7PMPvZ7SsjIADXHkcagyDopAVMPEgscAYe9yxR7hMHUSxjCmoWQ6TRaPkDg=  ;
X-YMail-OSG: JrvRS9IVM1m2TikebVgnUsYM.vTZWMA.gv2qr0H.TCSdhFP8kE0td7oQLAwOiTUA9bzic5qLolG.nE9cRqj2ngX6LeYG9G_Xe2WJ5whLoiD2FAmtp6PucXJLJ8xJJexYO1QtmyCOCHeW.0btCz.v_JIt
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Date: Thu, 28 Aug 2008 22:03:48 +1000
User-Agent: KMail/1.9.5
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080819103301.787700742@chello.nl> <200808272008.16106.nickpiggin@yahoo.com.au> <20080828105408.GA4488@elte.hu>
In-Reply-To: <20080828105408.GA4488@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808282203.48396.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008 20:54, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Wednesday 27 August 2008 08:49, Andi Kleen wrote:
> > > Thomas Gleixner <tglx@linutronix.de> writes:
> > > > Well, we might have a public opinion poll, whether a system is
> > > > declared frozen after 1, 10 or 100 seconds. Even a one second
> > > > unresponsivness shows up on the kernel bugzilla and you request that
> > > > unlimited unresponsivness w/o a chance to debug it is the sane
> > > > default.
> > >
> > > That assumes single CPU. With multiple CPUs and not
> > > all hogged the system should be still responsive?
> >
> > Right.
>
> Wrong.
>
> Even if the system has multiple CPUs, and even if just a single CPU is
> fully utilized by an RT task, without the rt-limit the system will still
> lock up in practice due to various other factors: workqueues and tasks
> being 'stuck' on CPUs that host an RT hog. While there's obviously CPU
> time available on other CPUs, you cannot run 'top', the desktop will
> freeze, work flows of the system can be stuck, etc, etc..

No, it is right. With caveats. Because you can pretty well isolate a
CPU from running kernel threads or work. At any rate, I don't think it
is your decision to just mandate this.


> With the rt limit in place, it's all pretty smooth and debuggable. Even
> with all CPUs hogged by SCHED_FIFO prio 99 the system is laggy but
> debuggable - the user can run 'top' and can resolve the situation.

When I write rt apps, I run a watchdog thread which detects a hang
task and kills it.


> Really, this reply of yours shows something startling: that despite this
> many mails you still have never actually tried to run the scenario you
> are complaining about: you have never tried to run a CPU hog high-prio
> RT task on a Linux system before, and you have never observed the
> effects it has on general system stability and debuggability.

Of course I have and of course I know what it does if you run a
for (;;) rt thread on an ordinary Linux desktop system. Trying to
"fix" that for people is not a good reason to break the API.


> This fundamental lack of experience weakens all your arguments and i
> dont even know why you are arguing about it. Do you perhaps have some
> customer application/workload you are worried about? If you have then
> please tell us about the exact specifics - this handwaving about
> compliance really makes little sense.

You're continually ignoring all of my arguments and instead raising
irrelvant things like this.

You ignored others in this thread who replied with real uses of the
rt scheduling that is being prevented by this API breakage, and
you're ignoring my examples of how it could be used and just keep
asserting that "anybody who does that is broken anyway".

You also ignored when I told you how you can fix this correctly by
introducing new SCHED_xxx scheduling policies that won't break
backwards compatibility and will be defined from the outset to be
throttled as such.

There is no customer issue and there is no handwaving about compliance;
it is a black and white issue: this behaviour breaks all documentation,
previous Linux behaviour, other systems.


> In other words: in our car the air-bag continues to be enabled by
> default, and if someone wants to use the car for stunts the air-bag can
> be disabled via that handy sysctl.

How am I supposed to respond to that? My car doesn't have an air bag
but it's breaks don't stop working every 10 seconds.

Can we stop with the car and gun analogies now?


> In any case i think i'm going to ignore this thread from now on, nothing
> new has been said really, just the general tone of discussion is
> deteriorating.

OK, if you don't wish to have further discussion then I will submit a
patch to Linus and I'll see what he says.


> You are also very late with raising objections in any 
> case - the rt-limit feature has been posted 10 months ago and went
> upstream 8 months ago - two full kernel cycles have been completed with
> this change in place and a third one has almost been finished.

So what?
