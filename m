Return-Path: <linux-kernel-owner+w=401wt.eu-S933664AbZGPXyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664AbZGPXyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 19:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933648AbZGPXyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 19:54:32 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:2020 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933641AbZGPXyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 19:54:31 -0400
Date: Thu, 16 Jul 2009 19:54:29 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Noah Watkins <jayhawk@soe.ucsc.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Message-ID: <20090716235429.GG27757@cs.fsu.edu>
References: <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <1247505941.7500.39.camel@twins> <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu> <20090713201305.GA25386@cs.fsu.edu> <4A5BAAE7.5020906@nortel.com> <20090715231109.GH14993@cs.fsu.edu> <4A5F448C.2050909@nortel.com> <20090716212603.GB27757@cs.fsu.edu> <4A5FA4EF.6000506@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5FA4EF.6000506@nortel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 04:08:47PM -0600, Chris Friesen wrote:

> > However, there is still a difference in context-switching
> > overhead.  Worst-case, you have twice as many context switches
> > per critical section with PIP as with PP.
> 
> On the other hand, with PI the uncontended case can be implemented as
> atomic operations in userspace.  With PP we need to issue at least two
> syscalls per lock/unlock cycle even in the uncontended case (to handle
> the priority manipulations).

Needing syscalls to change the priority of a thread may be an
artifact of system design, that might be correctable.

Suppose you put the effective priority of each thread in a
per-thread page that is mapped into a fixed location in the
thread's address space (and different locations in the kernel
memory).  It is nice to have such a page for each thread
in any case.  I don't recall whether Linux already does this,
but it is a well proven technique.

Taking a PP lock then involves:

1) push old priority on the thread's stack
2) overwrite thread's priority with max of the lock priority
   and the thread priority
3) try to grab the lock (test-and-set, etc.)
... conditionally queue, etc.

Releasing the PP lock then involves:

1) conditionally find another thread to grant the lock to,
   call scheduler, etc., otherwise
2) give up the actual lock (set bit, etc.)
3) pop the old priority from the stack, and
   write it back into the per-thread location

Of course you also have explicit priority changes.  The way we
handled those was to defer the effect until the lock release
point.  This means keeping two priority values (the nominal one,
and the effective one).  Just as you need conditional
code to do the ugly stuff that requires a kernel trap
in the case that the lock release requires unblocking
a task, you need conditional code to copy the copy the
new nominal priority to the effective priority, if that
is called for.  We were able to combine these two conditions
into a single bit test, which then branched out to handle
each of the cases, if necessary.

I can't swerar there are nocomplexities in Linux that might break
this scheme, since we were not trying to support all the
functionality now in Linux.

Ted


