Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbXKNJWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbXKNJWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 04:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXKNJWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 04:22:36 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:48493 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750816AbXKNJWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 04:22:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fyvk7VvzGj8zawsI7u/LO1a3jIcLj+mIgq8ADgfqofpoGsN8mTkzTw0p5COe1UjCN5mUIaxA6X9U1QHDVO8yc+CgQcAZ8Alts+u2AdTzocY2ItVYPnChe/+4IO+jwWhkFXfvgk/JlyUJvJccuywnS5AfVnVF2d1I4UFmFrCzx+M=  ;
X-YMail-OSG: WUA66dIVM1nHnC7N6DpPg1CoIUWLRNxNFCUXJDvYZGmkjEBd
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Wed, 14 Nov 2007 08:18:59 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <200711091136.20051.david-b@pacbell.net> <200711132325.53846.nickpiggin@yahoo.com.au> <200711140020.46764.david-b@pacbell.net>
In-Reply-To: <200711140020.46764.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711140818.59714.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007 19:20, David Brownell wrote:
> On Tuesday 13 November 2007, Nick Piggin wrote:

> > I mean, if you have a
> > timing critical operation, then you should ensure you have priorities
> > set correctly so that you simply don't get preempted.
>
> Which is why bitops like <asm-generic/bitops/atomic.h> use
> normal spinlocks.  Oh, wait, no they don't ...

No it isn't. It's nothing to do with that because upstream raw
spinlocks disable preemption as well; the reason for using raw
spinlocks in atomic.h is completely different.

Anyway, this whole line of argument is flawed. Even if the atomic.h
code is crap, that doesn't give any license to introduce more bad
code.


> > By using a raw_spinlock_t, you're saying that you're more important
> > than anyone else (for the period of the critical section) including
> > processes which the user has explicitly set to a higher priority.
>
> Nope.  Just saying that the relevant instructions (three, in the
> hot path I looked at, and not a case where priority inversion
> scenarios should be a concern) shouldn't be forcibly morphed into
> preemption points.  Any more than other bitops were (not).

Don't raw_spinlock_t's quite explictly disallow preemption in the
critical section? Eg. as opposed to spinlock_t, which does not, in 
-rt.


> If a higher priority task needs that CPU, nothing prevents it
> from being immediately descheduled.  Ditto handling a hardirq.
>
> All this does is prevent constant and needless checking for
> "do you want to preempt me now?" "now?" "now?" in "now?" the
> middle "now?" of "now?" i/o "now?" loops.

Actually that's wrong. By disabling preemption, you have to
explicitly check whether you should be preempted when you enable
it again. If you don't disable preemption then you don't have to
check anything -- you'll simply be preempted by asynchronous
events.

> > > Any reason that stuff shouldn't move into mainline?
> >
> > This sort of raw_spinlock_t arms race throughout drivers/ would be
> > a huge reason not to move it into mainline.
>
> This isn't driver code...

Semantics. It's not something like the scheduler or interrupt handler
or something that might have real reasons to use raw locks.


> I think you've just presented an argument why that stuff
> shouldn't really exist in -rt either... :)

Anyway, I'm not going to argue about -rt specific stuff any longer.
Whatever. It shouldn't go upstream like this though.
