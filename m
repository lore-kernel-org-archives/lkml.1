Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbZGOWOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbZGOWOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbZGOWOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:14:16 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:5696 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753260AbZGOWON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:14:13 -0400
Date: Wed, 15 Jul 2009 18:14:11 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Raistlin <raistlin@linux.it>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Message-ID: <20090715221410.GE14993@cs.fsu.edu>
References: <200907102350.47124.henrik@austad.us> <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com> <1247590112.9086.936.camel@Palantir> <4A5CCD5A.80108@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4A5CCD5A.80108@nortel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 12:24:26PM -0600, Chris Friesen wrote:

> > - that A's budget is not diminished.
> 
> If we're running B with A's priority, presumably it will get some amount
> of cpu time above and beyond what it would normally have gotten during a
> particular scheduling interval.  Perhaps it would make sense to charge B
> what it would normally have gotten, and charge the excess amount to A?

First, why will B get any excess time, if is charged?  There will
certainly be excess time used in any context switch, including
premptions and blocking/unblocking for locks, but that will come
out of some task's budget. Given the realities of the scheduler,
the front-end portion of the context-switch will be charged to the
preempted or blocking task, and the back-end portion of the
context-switch cost will be charged to the task to which the CPU
is switched.  In a cross-processor proxy situation like the one
above we have four switches: (1) from A to C on processor #1; (2)
from whatever else (call it D) that was running on processor #2 to
B, when B receives A's priority; (3) from B back to D when B
releasse the lock; (4) from C to A when A gets the lock.  A will
naturally be charged for the front-end cost of (1) and the
back-end cost of (4), and B will naturally be charged for the
back-end cost of (2) and the front-end cost of (3).

The budget of each task must be over-provisioned enough to
allow for these additional costs.  This is messy, but seems
unavoidable, and is an important reason for using scheduling
policies that minimize context switches.

Back to the original question, of who should be charged for
the actual critical section.

>From the schedulability analysis point of view, B is getting
higher priority time than it normally would be allowed to execute,
potentially causing priority inversion (a.k.a. "interference" or
"blocking") to a higher priority task D (which does not even share
a need for the lock that B is holding) that would otherwise run on
the same processor as B.  Without priority inheritance this kind
of interferfence would not happen.  So, we are benefiting A at the
expense of D. In the analysis, we can either allow for all such
interference in a "blocking term" in the analysis for D, or we
might call it "preemption" in the analysis of D and charge it to A
(if A has higher priority than D).  Is the latter any better?  I
think not, since we now have to inflate the nominal WCET of A to
include all of the critical sections that block it.

So, it seems most logical and simplest to leave the charges where
they naturally occur, on B.  That is, if you allow priority
inheritance, you allow tasks to sometimes run at higher priority
than they originally were allocated, but not to execute more 
than originally budgeted.

Ted

