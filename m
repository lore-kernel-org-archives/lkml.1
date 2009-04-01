Return-Path: <linux-kernel-owner+w=401wt.eu-S1760408AbZDAQWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408AbZDAQWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765148AbZDAQWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:22:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56525 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1764024AbZDAQWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:22:10 -0400
Date: Wed, 1 Apr 2009 12:22:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, <maneesh@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 00/11] Hardware Breakpoint interfaces
In-Reply-To: <20090328084647.GB5297@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0904011216460.3736-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Mar 2009, K.Prasad wrote:

> On Wed, Mar 25, 2009 at 03:48:31PM -0400, Alan Stern wrote:
> > > +
> > > +/*
> > > + * Handle debug exception notifications.
> > > + */
> > > +int __kprobes hw_breakpoint_handler(struct die_args *args)
> > > +{
> > > +	int i, rc = NOTIFY_DONE;
> > > +	struct hw_breakpoint *bp;
> > > +	/* The DR6 value is stored in args->err */
> > > +	unsigned long dr7, dr6 = args->err;
> > 
> > Please change this.  (I should have changed it long ago, but I never
> > got around to it.)  Instead of passing the DR6 value in args->err,
> > pass a pointer to the dr6 variable in do_debug().  That way the
> > handler routines can turn off bits in that variable and do_debug() can
> > see which bits remain set at the end.
> > 
> > Of course, this will require a corresponding change to the
> > post_kprobe_handler() routine.
> >
> 
> As I looked at the code with an intention of changing it, I don't find a
> place - in hw_breakpoint_handler() and in functions called by
> kprobe_exceptions_notify() where bits in dr6 are written into.

That's because such writes wouldn't do any good in the old code!  :-)

> The thread-specific thread->debugreg6 is updated with causative bits in
> ptrace_triggered() to help send signals to the user-space. I don't see a
> user for the change you propose.

For each breakpoint where we decide it's a case of lazy DR switching or
we invoke a "triggered" callback, the corresponding bit in dr6 should
be cleared.  This is a way of indicating to do_debug() that the handler 
has taken care of these causes of the exception.

Similarly, the kprobe routine should clear the single-step bit in dr6 
when it handles a single-step exception.  When the notifier chain 
completes, the only bits remaining in dr6 should be for events that 
still need to be handled.

Alan Stern

