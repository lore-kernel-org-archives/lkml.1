Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZIVUz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZIVUz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 16:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZIVUz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 16:55:27 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57062 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZIVUz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 16:55:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XBMHPvPAP48lxKXClvkO8LPBPokQT56mXGCNDhHx8ti4UEQmEkpeep4yr5UKQPl3+F
         yDTOfaQR0RnGocD0bxkPoMUqNSd4Lhh0yWnnwIIH8lHCw+jGRU1tMqvIV710JSkzMPwA
         nFyk7UOWCE6d6E9Gf9ZLPwQgj1uDoPbHrH0CA=
MIME-Version: 1.0
In-Reply-To: <1253615424.20345.76.camel@Palantir>
References: <1253615424.20345.76.camel@Palantir>
Date: Tue, 22 Sep 2009 22:55:28 +0200
Message-ID: <63386a3d0909221355o45cccdf2j707a5cb4cf36754b@mail.gmail.com>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Raistlin <raistlin@linux.it>
Cc: Peter Zijlstra <peterz@infradead.org>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Raistlin,

it's great fun to see this scheduler materialize, I was present at the
workshop in Kaiserslautern and waited for the code since. What I'm
interested in getting a briefing on right now is what practical use EDF
schedulers have, since I think this is what many people will ask for.

I think actually the answers are the same as when I asked at Meld
(of all places) what HRtimers are actually for. And I I got the non-all
inclusive answer that they're for Flight simulators.
Which is obviously in the domain of automatic control.
http://en.wikipedia.org/wiki/Automatic_control

So one application of HRTimers has been to trigger events in
userspace programs, especially when your dealing with issues
related to automatic control. Automatic control is also
mentioned throughout this patch. (Yes, I know HRtimers
have other great uses also, especially in-kernel, those will
remain.)

I am very interested in if you or someone else
could elaborate on the relation between HRtimers and deadline
scheduling. To my untrained mind it looks like HRtimers will
fire events to your task in a very precise manner, but
you cannot currently guarantee that they will then proceed to
process their target task in time (meet a deadline).

I'm under the impression that some people currently use
some periodic HRtimers (through either the timerfd_create system
call I guess, or POSIX timer_create(CLOCK_REALTIME_HR...)
timers combined with some SHED_FIFO or so to achieve the same
thing a deadline scheduler would do, but since SCHED_FIFO cannot
really guarantee that this will work, you simply underutilize
the system a bit, add the CONFIG_PREEMPT_RT patch so the
timers are not blocked by things like slow interrupthandlers or
starvation (priority inversion) and then hope for the best. It turns
out to work. You measure on the system and it has the desired
"hard realtime" characteristics.

Do people do such things? I haven't seen those applications,
they all tend to be closed-source really. I would assume the
vxWorks/pSOS/etc compatibility wrapper libraries do things
like this, do they not?

But let us assume these applications really exist. tglx will probably
tell if I'm totally off track here.

So from here it looks like a problem that was previously solved by
fireing a periodic HRtimer is now better suited to be solved
by scheduling it with a periodic deadlined scheduling policy.
It will be done better, easier and with a guaranteed result.
Is this reasoning generally speaking correct?

Now since that example up there included the RTOS replacement
case, that means the list of possible applications utilizing these very
responsive control systems would be the same as any good old
so-called RTOS and include user-space applications for:

* Any interactive simulations and games
* Industrial automation including robotics
* Process industry applications (e.g. chemical processing, power
  plants, paper/car/textile/etc manufacturing)
* Various weapons including missiles
* Medical equipment
* The above will sooner or later include a dataflow which
  need some processing on it which leads to thinking of
  data (token) flows leading up to:
* Massive parallelization of FunnyStuff like the models found
  in OpenDF (also part of the ACTORS project):
  http://opendf.svn.sourceforge.net/viewvc/opendf/trunk/models/
  here (correct me if I'm wrong) the deadline scheduling
  will be used to construct timewise predictable flows in massively
  parallel threadpools distributed over several processing nodes etc.
  Illustrations include MPEG4 decoding, FIR, FFT so let's
  say real-time constrained signal processing on some
  time-critical dataflow.
  (Don't know the deadline-critical parts of the Mandelbrot
  set or the Game of Life though, hehe.)

This sounds a lot like a nail in the coffin for the RTOS and all
its virtualized variants (running Linux inside an RTOS etc).

(Please excuse my bastardized condensed-form popular science
version of the noble goals of the ACTORS project, I only observed
it at a distance so my vision was dimmed.)

Linus Walleij
