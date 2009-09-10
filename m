Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZIJBe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZIJBe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZIJBeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:34:25 -0400
Received: from home.kolivas.org ([59.167.196.135]:37173 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbZIJBeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:34:25 -0400
X-Greylist: delayed 1876 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2009 21:34:24 EDT
From: Con Kolivas <kernel@kolivas.org>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Thu, 10 Sep 2009 11:02:56 +1000
User-Agent: KMail/1.9.9
Cc: Nikos Chantziaras <realnc@arcor.de>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
References: <20090908091304.GQ18599@kernel.dk> <4AA80C1E.2080901@arcor.de> <20090909205043.GI18599@kernel.dk>
In-Reply-To: <20090909205043.GI18599@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 5565
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909101102.56615.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009 06:50:43 Jens Axboe wrote:
> On Wed, Sep 09 2009, Nikos Chantziaras wrote:
> > On 09/09/2009 09:04 PM, Ingo Molnar wrote:
> >> [...]
> >>
> >> * Jens Axboe<jens.axboe@oracle.com>  wrote:
> >>> On Wed, Sep 09 2009, Jens Axboe wrote:
> >>>  [...]
> >>> BFS210 runs on the laptop (dual core intel core duo). With make -j4
> >>> running, I clock the following latt -c8 'sleep 10' latencies:
> >>>
> >>> -rc9
> >>>
> >>>          Max                17895 usec
> >>>          Avg                 8028 usec
> >>>          Stdev               5948 usec
> >>>          Stdev mean           405 usec
> >>>
> >>>          Max                17896 usec
> >>>          Avg                 4951 usec
> >>>          Stdev               6278 usec
> >>>          Stdev mean           427 usec
> >>>
> >>>          Max                17885 usec
> >>>          Avg                 5526 usec
> >>>          Stdev               6819 usec
> >>>          Stdev mean           464 usec
> >>>
> >>> -rc9 + mike
> >>>
> >>>          Max                 6061 usec
> >>>          Avg                 3797 usec
> >>>          Stdev               1726 usec
> >>>          Stdev mean           117 usec
> >>>
> >>>          Max                 5122 usec
> >>>          Avg                 3958 usec
> >>>          Stdev               1697 usec
> >>>          Stdev mean           115 usec
> >>>
> >>>          Max                 6691 usec
> >>>          Avg                 2130 usec
> >>>          Stdev               2165 usec
> >>>          Stdev mean           147 usec
> >>
> >> At least in my tests these latencies were mainly due to a bug in
> >> latt.c - i've attached the fixed version.
> >>
> >> The other reason was wakeup batching. If you do this:
> >>
> >>     echo 0>  /proc/sys/kernel/sched_wakeup_granularity_ns
> >>
> >> ... then you can switch on insta-wakeups on -tip too.
> >>
> >> With a dual-core box and a make -j4 background job running, on
> >> latest -tip i get the following latencies:
> >>
> >>   $ ./latt -c8 sleep 30
> >>   Entries: 656 (clients=8)
> >>
> >>   Averages:
> >>   ------------------------------
> >>   	Max	      158 usec
> >> 	Avg	       12 usec
> >> 	Stdev	       10 usec
> >
> > With your version of latt.c, I get these results with 2.6-tip vs
> > 2.6.31-rc9-bfs:
> >
> >
> > (mainline)
> > Averages:
> > ------------------------------
> >         Max            50 usec
> >         Avg            12 usec
> >         Stdev           3 usec
> >
> >
> > (BFS)
> > Averages:
> > ------------------------------
> >         Max           474 usec
> >         Avg            11 usec
> >         Stdev          16 usec
> >
> >
> > However, the interactivity problems still remain.  Does that mean it's
> > not a latency issue?
>
> It probably just means that latt isn't a good measure of the problem.
> Which isn't really too much of a surprise.

And that's a real shame because this was one of the first real good attempts 
I've seen to actually measure the difference, and I thank you for your 
efforts Jens. I believe the reason it's limited is because all you're 
measuring is time from wakeup and the test app isn't actually doing any work. 
The issue is more than just waking up as fast as possible, it's then doing 
some meaningful amount of work within a reasonable time frame as well. What 
the "meaningful amount of work" and "reasonable time frame" are, remains a 
mystery, but I guess could be added on to this testing app.

What does please me now, though, is that this message thread is finally 
concentrating on what BFS was all about. The fact that it doesn't scale is no 
mystery whatsoever. The fact that that throughput and lack of scaling was 
what was given attention was missing the point entirely. To point that out I 
used the bluntest response possible, because I know that works on lkml (does 
it not?). Unfortunately I was so blunt that I ended up writing it in another 
language; Troll. So for that, I apologise.

The unfortunate part is that BFS is still far from a working, complete state, 
yet word got out that I had "released" something, which I had not, but 
obviously there's no great distinction between putting something on a server 
for testing, and a real release with an announce.

BFS is a scheduling experiment to demonstrate what effect the cpu scheduler 
really has on the desktop and how it might be able to perform if we design 
the scheduler for that one purpose.

It pleases me immensely to see that it has already spurred on a flood of 
changes to the interactivity side of mainline development in its few days of 
existence, including some ideas that BFS uses itself. That in itself, to me, 
means it has already started to accomplish its goal, which ultimately, one 
way or another, is to improve what the CPU scheduler can do for the linux 
desktop. I can't track all the sensitive areas of the mainline kernel 
scheduler changes without getting involved more deeply than I care to so it 
would be counterproductive of me to try and hack on mainline. I much prefer 
the quieter inbox.

If people want to use BFS for their own purposes or projects, or even better 
help hack on it, that would make me happy for different reasons. I will 
continue to work on my little project -in my own time- and hope that it 
continues to drive further development of the mainline kernel in its own way. 
We need more experiments like this to question what we currently have and 
accept. Other major kernel subsystems are no exception.

Regards,
-- 
-ck

<code before rhetoric>
