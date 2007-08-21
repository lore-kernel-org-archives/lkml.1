Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbXHUW3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbXHUW3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 18:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbXHUW2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 18:28:55 -0400
Received: from [212.12.190.80] ([212.12.190.80]:32918 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752631AbXHUW2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 18:28:55 -0400
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CFS review
Date: Wed, 22 Aug 2007 01:27:30 +0300
User-Agent: KMail/1.5
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200708111344.42934.a1426z@gawab.com> <200708122243.05191.a1426z@gawab.com> <20070821105858.GC26598@elte.hu>
In-Reply-To: <20070821105858.GC26598@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708220127.30698.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Al Boldi <a1426z@gawab.com> wrote:
> > There is one workload that still isn't performing well; it's a
> > web-server workload that spawns 1K+ client procs.  It can be emulated
> > by using this:
> >
> >   for i in `seq 1 to 3333`; do ping 10.1 -A > /dev/null & done
>
> on bash i did this as:
>
>   for ((i=0; i<3333; i++)); do ping 10.1 -A > /dev/null & done
>
> and this quickly creates a monster-runqueue with tons of ping tasks
> pending. (i replaced 10.1 with the IP of another box on the same LAN as
> the testbox) Is this what should happen?

Yes, sometimes they start pending and sometimes they run immediately.

> > The problem is that consecutive runs don't give consistent results and
> > sometimes stalls.  You may want to try that.
>
> well, there's a natural saturation point after a few hundred tasks
> (depending on your CPU's speed), at which point there's no idle time
> left. From that point on things get slower progressively (and the
> ability of the shell to start new ping tasks is impacted as well), but
> that's expected on an overloaded system, isnt it?

Of course, things should get slower with higher load, but it should be 
consistent without stalls.

To see this problem, make sure you boot into /bin/sh with the normal VGA 
console (ie. not fb-console).  Then try each loop a few times to show 
different behaviour; loops like:

# for ((i=0; i<3333; i++)); do ping 10.1 -A > /dev/null & done

# for ((i=0; i<3333; i++)); do nice -99 ping 10.1 -A > /dev/null & done

# { for ((i=0; i<3333; i++)); do
        ping 10.1 -A > /dev/null &
    done } > /dev/null 2>&1

Especially the last one sometimes causes a complete console lock-up, while 
the other two sometimes stall then surge periodically.

BTW, I am also wondering how one might test threading behaviour wrt to 
startup and sync-on-exit with parent thread.  This may not show any problems 
with small number of threads, but how does it scale with 1K+?


Thanks!

--
Al

