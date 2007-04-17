Return-Path: <linux-kernel-owner+w=401wt.eu-S1031307AbXDQXwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031307AbXDQXwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 19:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031306AbXDQXwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 19:52:11 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:15430 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031307AbXDQXwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 19:52:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cVY64bzGsTsUL5dicqc4gj9WvXltJbe6D5mdWr9M72rrmDbdY+sKI6cWnFtJ/PNHzeLyJoLnkW/eHJhINfjr1pYg7GJy8Pwb3e43wOCWGBwr7u4iovhgmHViP9hwJ/b+d5hySY80u/vxVYcnIZgaRVa45cFBi9MS8lcBrKjO8T8=
Message-ID: <f2b55d220704171652s2474744p8c7d797f9264eceb@mail.gmail.com>
Date: Tue, 17 Apr 2007 16:52:08 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "William Lee Irwin III" <wli@holomorphy.com>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Cc: "Peter Williams" <pwil3058@bigpond.net.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Nick Piggin" <npiggin@suse.de>, "Mike Galbraith" <efault@gmx.de>,
       "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       "Bill Huey" <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070417230754.GR2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704151327.13589.kernel@kolivas.org>
	 <46240F98.3020800@bigpond.net.au>
	 <1176776941.6222.21.camel@Homer.simpson.net>
	 <20070417034050.GD25513@wotan.suse.de>
	 <1176782489.13059.15.camel@Homer.simpson.net>
	 <20070417041420.GF25513@wotan.suse.de>
	 <20070417095140.GB22626@elte.hu> <4624CF3B.6040704@bigpond.net.au>
	 <f2b55d220704171600w2de57cafhc1b2d8d7df67cc6b@mail.gmail.com>
	 <20070417230754.GR2986@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/07, William Lee Irwin III <wli@holomorphy.com> wrote:
> The ongoing scheduler work is on a much more basic level than these
> affairs I'm guessing you googled. When the basics work as intended it
> will be possible to move on to more advanced issues.

OK, let me try this in smaller words for people who can't tell bitter
experience from Google hits.  CPU clock scaling for power efficiency
is already the only thing that matters about the Linux scheduler in my
world, because battery-powered device vendors in their infinite wisdom
are abandoning real RTOSes in favor of Linux now that WiFi is the "in"
thing (again).  And on the timescale that anyone will actually be
_using_ this shiny new scheduler of Ingo's, it'll be nearly the only
thing that matters about the Linux scheduler in anyone's world,
because the amount of work the CPU can get done in a given minute will
depend mostly on how intelligently it can spend its heat dissipation
budget.

Clock scaling schemes that aren't integral to the scheduler design
make a bad situation (scheduling embedded loads with shotgun
heuristics tuned for desktop CPUs) worse, because the opaque
heuristics are now being applied to distorted data.  Add a "smoothing"
scheme for the distorted data, and you may find that you have
introduced an actual control-path instability.  A small fluctuation in
the data (say, two bursts of interrupt traffic at just the right
interval) can result in a long-lasting oscillation in some task's
"dynamic priority" -- and, on a fully loaded CPU, in the time that
task actually gets.  If anything else depends on how much work this
task gets done each time around, the oscillation can easily propagate
throughout the system.  Thrash city.

(If you haven't seen this happen on real production systems under what
shouldn't be a pathological load, you haven't been around long.  The
classic mechanisms that triggered oscillations in, say, early SMP
Solaris boxes haven't bitten recently, perhaps because most modern
CPUs don't lose their marbles so comprehensively on context switch.
But I got to live this nightmare again recently on ARM Linux, due to
some impressively broken application-level threading/locking "design",
whose assumptions about scheduler behavior got broken when I switched
to an NPTL toolchain.)

I don't have the training to design a scheduler that isn't vulnerable
to control-feedback oscillations.  Neither do you, if you haven't
taken (and excelled at) a control theory course, which nowadays seems
to be taught by applied math and ECE departments and too often skipped
by CS types.  But I can recognize an impending train wreck when I see
it.

Cheers,
- Michael
