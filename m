Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbZDXRnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbZDXRnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZDXRnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:43:06 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48246 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbZDXRnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:43:04 -0400
Date: Fri, 24 Apr 2009 10:43:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       torvalds@osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       serue@us.ibm.com, viro@zeniv.linux.org.uk,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] It may not be assumed that wake_up(), finish_wait()
	and co. imply a memory barrier
Message-ID: <20090424174301.GB6754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com> <21209.1240504344@redhat.com> <26028.1240573601@redhat.com> <20090424150809.GA6754@linux.vnet.ibm.com> <20090424170830.GA13026@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424170830.GA13026@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 07:08:30PM +0200, Oleg Nesterov wrote:
> On 04/24, Paul E. McKenney wrote:
> >
> > One question, assuming that this documentation intends to guide the
> > reader on where to put the locking and/or memory-barrier primitives...
> >
> > Suppose we have the following sequence of events:
> >
> > 1.	The waiter does "set_current_state(TASK_UNINTERRUPTIBLE);".
> > 	This implies a full memory barrier.
> >
> > 2.	The awakener updates some shared state.
> >
> > 3.	The awakener does "event_indicated = 1;".
> >
> > 4.	The waiter does "if (event_indicated)", and, finding that
> > 	the event has in fact been indicated, does "break".
> >
> > 5.	The waiter accesses the shared state set in #2 above.
> >
> > 6.	Some time later, the awakener does "wake_up(&event_wait_queue);"
> > 	This does not awaken anyone, so no memory barrier.
> >
> > Because there is no memory barrier between #2 and #3, reordering by
> > either the compiler or the CPU might cause the awakener to update the
> > event_indicated flag in #3 -before- completing its update of shared
> > state in #2.  Less likely (but still possible) optimizations might
> > cause the waiter to access the shared state in #5 before checking
> > the event_indicated flag in #4.
> 
> Do you mean something like
> 
> 	awakener:
> 
> 		DATA = value;
> 		DATA_IS_READY = true;
> 		wake_up(wq);
> 
> 
> 	waiter:
> 
> 		set_current_state(UNINTERRUPTIBLE);
> 		if (DATA_IS_READY)
> 			do_something(DATA);
> 
> ?
> 
> Imho, the code above is just buggy and should be ignored by documentation ;)
> 
> Or do I miss your point?

I was hoping that this sort of code might be actively discouraged by the
documentation.  ;-)

							Thanx, Paul
