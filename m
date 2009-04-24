Return-Path: <linux-kernel-owner+w=401wt.eu-S1761259AbZDXRvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761259AbZDXRvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761023AbZDXRvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:51:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35207 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760818AbZDXRvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:51:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090424150809.GA6754@linux.vnet.ibm.com>
References: <20090424150809.GA6754@linux.vnet.ibm.com> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com> <21209.1240504344@redhat.com> <26028.1240573601@redhat.com> 
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, serue@us.ibm.com,
       viro@zeniv.linux.org.uk, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] It may not be assumed that wake_up(), finish_wait() and co. imply a memory barrier
Date: Fri, 24 Apr 2009 18:48:06 +0100
Message-ID: <27891.1240595286@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Because there is no memory barrier between #2 and #3, reordering by
> either the compiler or the CPU might cause the awakener to update the
> event_indicated flag in #3 -before- completing its update of shared
> state in #2.

If the ordering of #2 and #3 is important with respect to each other, then the
awakener must manually interpolate a barrier of some sort between the two
_before_ calling wake_up() (or it should wrap them in a lock).

As I've tried to make clear in my documentation:

	Sleeping and waking on an event flagged in global data can be viewed as
	an interaction between two pieces of data: ===> the task state of the
	task waiting for the event and the global data used to indicate the
	event <===.

the barrier in wake_up() is only concerned with the ordering of #3 vs #6.  That
is all it _can_ impose an order upon, since #2 and #3 both happen before
wake_up() is called, and #3 is what causes the sleeper to break out of the
sleep loop.

> So, for this to work correctly, don't we need at least an smp_wmb()
> between #2 and #3 and at least an smp_rmb() between #4 and #5?  And if
> #2 does reads (but not writes) at least one variable in the shared state
> that #5 writes to, don't both barriers need to be smp_mb()?

Yes, but that's beyond the scope of this section.  set_current_state() imposes
the partial ordering { #1, #4 } and wake_up() the partial ordering { #3, #6 }
because those are the controlling features of the loop.

Managing the data beyond that is up to the caller of set_current_state() and
the caller of wake_up().

David
