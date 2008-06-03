Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbYFCWTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbYFCWTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbYFCWTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:19:19 -0400
Received: from relay1.sgi.com ([192.48.171.29]:44664 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755330AbYFCWTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:19:17 -0400
Date: Tue, 3 Jun 2008 17:17:59 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: sivanich@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG] hotplug cpus on ia64
Message-ID: <20080603221759.GA19039@sgi.com>
References: <E1K1l2y-0007bu-44@eag09.americas.sgi.com> <1212154614.12349.244.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212154614.12349.244.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, May 30, 2008 at 03:36:54PM +0200, Peter Zijlstra wrote:
> On Thu, 2008-05-29 at 11:32 -0500, Cliff Wickman wrote:
> > >> I built an ia64 kernel from Andrew's tree (2.6.26-rc2-mm1)
> > >> and get a very predictable hotplug cpu problem.
> > >> billberry1:/tmp/cpw # ./dis
> > >> disabled cpu 17
> > >> enabled cpu 17
> > >> billberry1:/tmp/cpw # ./dis
> > >> disabled cpu 17
> > >> enabled cpu 17
> > >> billberry1:/tmp/cpw # ./dis
> > >> 
> > >> The script that disables the cpu always hangs (unkillable)
> > >> on the 3rd attempt.
> > 
> > > And a bit further:
> > > The kstopmachine thread always sits on the run queue (real time) for about
> > > 30 minutes before running.
> > 
> > And a bit further:
> > 
> > The kstopmachine thread is queued as real-time on the downed cpu:
> > >> rq -f 17
> > CPU#       runq address size Lock     current task         time name
> > ==========================================================================
> >   17 0xe000046003059540    3  U 0xe0000360f06f8000            0 swapper
> >         Total of 3 queued:
> >         3 real time tasks:  px *(rt_rq *)0xe000046003059608
> >         exclusive queue:
> >         slot 0
> >         0xe0000760f4628000            0 migration/17
> >         0xe0000760f4708000            0 kstopmachine
> >         0xe0000760f6678000            0 watchdog/17
> > 
> > I put in counters and see that schedule() is never again entered by cpu 17
> > after it is downed the 3rd time.
> > (it is entered after being up'd the first two times)
> > 
> > The kstopmachine thread is bound to cpu 17 by __stop_machine_run()'s call
> > to kthread_bind().
> > 
> > A cpu does not schedule after being downed, of course.  But it does again
> > after being up'd.  
> > Why would the second up be different?  Following it, if the cpu is
> > downed it never schedules again.
> > 
> > If I always bind kstopmachine to cpu 0 the problem disappears.
> 
> does:
> 
> echo -1 > /proc/sys/kernel/sched_rt_runtime_us
> 
> fix the problem?

Yes! It does. 

Dimitri Sivanich has run into what looks like a similar problem.
Hope the above workaround is a good clue to its solution.

-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
