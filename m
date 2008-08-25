Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbYHYQfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbYHYQfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 12:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYHYQfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 12:35:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:44916 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbYHYQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 12:35:33 -0400
Subject: Re: [PATCH RFC] pm_qos_requirement might sleep
From: Peter Zijlstra <peterz@infradead.org>
To: mgross@linux.intel.com
Cc: John Kacur <jkacur@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, arjan <arjan@infradead.org>
In-Reply-To: <20080825163412.GA21910@linux.intel.com>
References: <520f0cf10808041352h78bd4319x1802f018aeffe6dc@mail.gmail.com>
	 <1217921101.3589.98.camel@twins> <20080805204901.GA31132@linux.intel.com>
	 <1217970588.29415.36.camel@lappy.programming.kicks-ass.net>
	 <520f0cf10808051518h1459d353r8de78e98f79ec57c@mail.gmail.com>
	 <20080812224926.GA20652@linux.intel.com>
	 <520f0cf10808130124o301b6691ra37ac9007120b9df@mail.gmail.com>
	 <20080814155241.GA31050@linux.intel.com> <1218736137.10800.234.camel@twins>
	 <520f0cf10808141551k283aecb8y647d0f5ae321b81f@mail.gmail.com>
	 <20080825163412.GA21910@linux.intel.com>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 18:35:29 +0200
Message-Id: <1219682129.8515.81.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-25 at 09:34 -0700, mark gross wrote:
> On Fri, Aug 15, 2008 at 12:51:11AM +0200, John Kacur wrote:
> > On Thu, Aug 14, 2008 at 7:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Thu, 2008-08-14 at 08:52 -0700, mark gross wrote:
> > >
> > >> Keeping a lock around the different "target_value"s may not be so
> > >> important.  Its just a 32bit scaler value, and perhaps we can make it an
> > >> atomic type?  That way we loose the raw_spinlock.
> > >
> > > My suggestion was to keep the locking for the write side - so as to
> > > avoid stuff stomping on one another, but drop the read side as:
> > >
> > >  spin_lock
> > >  foo = var;
> > >  spin_unlock
> > >  return foo;
> > >
> > > is kinda useless, it doesn't actually serialize against the usage of
> > > foo, that is, once it gets used, var might already have acquired a new
> > > value.
> > >
> > > The only thing it would protect is reading var, but since that is a
> > > machine sized read, its atomic anyway (assuming its naturally aligned).
> > >
> > > So no need for atomic_t (its read-side is just a read too), just drop
> > > the whole lock usage from pq_qos_requirement().
> > >
> > 
> > Thanks Peter.
> > 
> > Mark, is the following patch ok with you? This should be applied to
> > mainline, and then after that no special patches are necessary for
> > real-time.
> 
> I've been thinking about this patch and I worry that the readability
> from making the use of this lock asymmetric WRT reads and writes to the
> storage address is bothersome.
> 
> I would rather make the variable an atomic.  What do you think about
> that?

It would make the write side more expensive, as we already have the two
atomic operations for the lock and unlock, this would add a third.

Then again, I doubt that this is really a fast path.

OTOH, a simple comment could clarify the situation for the reader.

Up to you I guess ;-)

