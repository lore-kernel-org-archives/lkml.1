Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbYHTL4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbYHTL4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 07:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYHTL4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 07:56:14 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:23634 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752527AbYHTL4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 07:56:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qnJI0HJdvwljUAc7iFgopHmRO4UVnVyjngBGBR/r6EDUDIyEH4QXn40EY4TIGjgMBmVcaStSKoOKwBujclGVgXgvUwZDZF7GBf9GiUpICJ6GtthwJ/axpR1V6FR3a+hLHhffg7pbySW3wlDFjSfgwa9nil3QmjMuTKkSgobz7Kw=  ;
X-YMail-OSG: JVreYiwVM1kHncixmrOqI7G8AVo_j6QwQ.jij3flT7dVFKmV9UWoOuPd17cu4EV24liv_m0nGek5TlEisT2Uwz.HGNVGBV3TNYbfBG2AMtXAI7G6zbintSJklNA.Wu8f5.Izpj3A3mTJ3UR3.Vey1SZphAMvwdcVF91paMxEvoh0fywK1SxvvInagIIzwmtE
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Date: Wed, 20 Aug 2008 21:56:04 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080819103301.787700742@chello.nl> <200808192117.52070.nickpiggin@yahoo.com.au> <20080819125954.GA20210@elte.hu>
In-Reply-To: <20080819125954.GA20210@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808202156.05024.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 August 2008 22:59, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > [...] Let's retain our API specifications and backwards compatibilty
> > by default. [...]
>
> I agree with you that the 1 second default was a bit too tight - and we
> should definitely change that (and it's changed already).

I do not agree that it is too tight, it is just plain wrong.


> So changing the "allow RT tasks up to 10 seconds uninterrupted CPU
> monopolization" is OK to me - it still keeps runaway CPU loops (which
> are in the vast majority) debuggable, while allowing common-sense RT
> task usage.


RT tasks have always been debuggable by using a simple watchdog thread.
As I said before, someone who develops a non-trivial RT app without a
watchdog thread or isolated CPU basically doesn't deserve the honour of
us breaking our API to cater for their idiocity.

But even for those people, we now have the sysrq trigger too. And also
we'll still have the rt throttle sysctl that can be changed at runtime.

There are so many options... "oh but maybe they didn't research the
options either so let's break our APIs instead" is not common sense
IMO.


> But changing that back to the other extreme: "allow lockups by default"
> is unreasonable IMO - especially in the face of rtlimit that allows
> unprivileged tasks to gain RT privileges.

No, it's not "allow lockups by default". It is "follow the API and
backwards compatibility by default".

If some distro has gone and given all users RTPRIO rlimit by default
and allowed unprivileged users to lock up the system, it is not the
problem of the upstream kernel. That distro can set the rt throttle
default if it wants to. Or provide a watchdog thread for debugging
RT tasks.


> As an experiment try running a 100% CPU using SCHED_FIFO:99 RT task. It
> does not result in a usable Linux system - it interacts with too many
> normal system activities. It is a very, very special mode of operation
> and anyone using Linux in such a way has to take precautions and has to
> tune things specially anyway. (has to turn off the softlockup watchdog,
> has to make sure IO requests do not time out artificially, etc.) You
> wont even get normal keyboard or console behavior in most cases.

This is exactly what *real* RT app/system developers do. I'm not
talking about an untuned desktop system!!


> Furthermore, if by "API specifications" you mean POSIX - to get a
> conformant POSIX run one has to change a lot of things on a typical
> Linux system anyway. APIs and utilities have to be crippled to be "POSIX
> compliant".

By that argument we can break any userspace API for any reason.


> In other words: we use common sense when thinking about specifications.
> The kernel's defaults are about being reasonable by default.

It's not common sense to change this. It would be perfectly valid to
engineer a realtime process that uses a peak of say 90% of the CPU with
a 10% margin for safety and other services. Now they only have 5%.

Or a realtime app could definitely use the CPU adaptively up to 100% but
still unable to tolerate an unexpected preemption.

I don't know how you can change this so significantly and be so sure of
yourself that you won't break anything (actually you already have one
reported breakage in this thread).


> I have no _strong_ feelings about it, but i dont see the practical value
> in going beyond 10 seconds - as it turns a rather useful robustness
> feature off by default (and keeps it untested, etc.).

I feel strongly about it.

The primary issue is that we have broken the API from both specification
and previous implementation, the answer is yes. That *you* can't see any
reason to use the API in that way kind of pales in comparison with all
due respect. Especially as you already got a counter example of someone's
app that broke.
