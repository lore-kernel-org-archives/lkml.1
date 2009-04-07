Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbZDGIXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbZDGIXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZDGIXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:23:06 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:56955 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbZDGIXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:23:03 -0400
Date: Tue, 7 Apr 2009 13:52:53 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 00/11] Hardware Breakpoint interfaces
Message-ID: <20090407082253.GB22500@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090328084647.GB5297@in.ibm.com> <Pine.LNX.4.44L0.0904011216460.3736-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904011216460.3736-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 12:22:08PM -0400, Alan Stern wrote:
> On Sat, 28 Mar 2009, K.Prasad wrote:
> 
> > On Wed, Mar 25, 2009 at 03:48:31PM -0400, Alan Stern wrote:
> > > > +
> > > > +/*
> > > > + * Handle debug exception notifications.
> > > > + */
> > > > +int __kprobes hw_breakpoint_handler(struct die_args *args)
> > > > +{
> > > > +	int i, rc = NOTIFY_DONE;
> > > > +	struct hw_breakpoint *bp;
> > > > +	/* The DR6 value is stored in args->err */
> > > > +	unsigned long dr7, dr6 = args->err;
> > > 
> > > Please change this.  (I should have changed it long ago, but I never
> > > got around to it.)  Instead of passing the DR6 value in args->err,
> > > pass a pointer to the dr6 variable in do_debug().  That way the
> > > handler routines can turn off bits in that variable and do_debug() can
> > > see which bits remain set at the end.
> > > 
> > > Of course, this will require a corresponding change to the
> > > post_kprobe_handler() routine.
> > >
> > 
> > As I looked at the code with an intention of changing it, I don't find a
> > place - in hw_breakpoint_handler() and in functions called by
> > kprobe_exceptions_notify() where bits in dr6 are written into.
> 
> That's because such writes wouldn't do any good in the old code!  :-)
> 
> > The thread-specific thread->debugreg6 is updated with causative bits in
> > ptrace_triggered() to help send signals to the user-space. I don't see a
> > user for the change you propose.
> 
> For each breakpoint where we decide it's a case of lazy DR switching or
> we invoke a "triggered" callback, the corresponding bit in dr6 should
> be cleared.  This is a way of indicating to do_debug() that the handler 
> has taken care of these causes of the exception.
> 
> Similarly, the kprobe routine should clear the single-step bit in dr6 
> when it handles a single-step exception.  When the notifier chain 
> completes, the only bits remaining in dr6 should be for events that 
> still need to be handled.
> 
> Alan Stern
>

This does sound like good design, but unfortunately there are pieces in
do_debug() which rely upon bits in dr6 being set even after the actual
breakpoint is handled (the get_si_code() is one such example).

Do we go about changing them to use thread->debugreg6 instead of dr6? If
yes, wouldn't that be better done outside the HW Breakpoint patches as a
part of some cleanup initiative?

Thanks,
K.Prasad


 
