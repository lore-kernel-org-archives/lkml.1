Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbZDXSGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbZDXSGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 14:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZDXSGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 14:06:14 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35214 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbZDXSGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 14:06:13 -0400
Date: Fri, 24 Apr 2009 11:06:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       torvalds@osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       serue@us.ibm.com, viro@zeniv.linux.org.uk,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] It may not be assumed that wake_up(), finish_wait()
	and co. imply a memory barrier
Message-ID: <20090424180612.GC6754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com> <21209.1240504344@redhat.com> <26028.1240573601@redhat.com> <27891.1240595286@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27891.1240595286@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 06:48:06PM +0100, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Because there is no memory barrier between #2 and #3, reordering by
> > either the compiler or the CPU might cause the awakener to update the
> > event_indicated flag in #3 -before- completing its update of shared
> > state in #2.
> 
> If the ordering of #2 and #3 is important with respect to each other, then the
> awakener must manually interpolate a barrier of some sort between the two
> _before_ calling wake_up() (or it should wrap them in a lock).
> 
> As I've tried to make clear in my documentation:
> 
> 	Sleeping and waking on an event flagged in global data can be viewed as
> 	an interaction between two pieces of data: ===> the task state of the
> 	task waiting for the event and the global data used to indicate the
> 	event <===.
> 
> the barrier in wake_up() is only concerned with the ordering of #3 vs #6.  That
> is all it _can_ impose an order upon, since #2 and #3 both happen before
> wake_up() is called, and #3 is what causes the sleeper to break out of the
> sleep loop.
> 
> > So, for this to work correctly, don't we need at least an smp_wmb()
> > between #2 and #3 and at least an smp_rmb() between #4 and #5?  And if
> > #2 does reads (but not writes) at least one variable in the shared state
> > that #5 writes to, don't both barriers need to be smp_mb()?
> 
> Yes, but that's beyond the scope of this section.  set_current_state() imposes
> the partial ordering { #1, #4 } and wake_up() the partial ordering { #3, #6 }
> because those are the controlling features of the loop.
> 
> Managing the data beyond that is up to the caller of set_current_state() and
> the caller of wake_up().

Fair enough!

But I would strongly suggest at least a note calling this out, preferably a
"don't do this" example.

							Thanx, Paul
