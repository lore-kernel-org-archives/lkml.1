Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbYHAVN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbYHAVN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760412AbYHAVKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:10:09 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48990 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760895AbYHAVKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:10:07 -0400
Date: Fri, 1 Aug 2008 14:09:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.26-rc9-git4: Reported regressions from 2.6.25
Message-ID: <20080801210958.GL14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4yrA-dRoNlD.A.jcB.ny-cIB@albercik> <20080710173459.GA11648@elte.hu> <20080710180620.GA30844@elte.hu> <200807111412.00084.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807111412.00084.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 02:11:59PM +1000, Nick Piggin wrote:
> On Friday 11 July 2008 04:06, Ingo Molnar wrote:
> 
> > i'm wondering why rcutorture didnt trigger it. I do run !HOTPLUG +
> > RCU_PREEMPT kernels and never saw this. Nor did Paul. That aspect is
> > weird.
> 
> It basically requires an active rcu reader to be preempted (preferably
> by something doing a lot of call_rcu or other activity ie. the writer
> so it can tick along the different states quickly).
> 
> I found just 2 threads (reader and writer) bound to the same CPU would
> trigger it fastest, my reader has quite a long rcu read section.
> 
> I'm not sure why rcutorture doesn't trigger for everyone. I'm surprised
> it does not have much longer maximum read delays -- several ms I would
> have thought should be useful to have a crticial section open while the
> rcu engine can run through a number of states...

Hit it in 10 seconds once I actually got HOTPLUG_CPU disabled.

The theory behind the default settings for rcutorture are as follows:

o	Having two reader threads for each CPU helps ensure interactions
	between those threads.

o	The writer is normally going to have to share a CPU with a
	reader or two, maybe three.  This should force reader-writer
	interactions.

o	The read-hold time needs to be long enough to ensure interactions
	with the writer, but if it is too long, there are too few
	rcu_read_lock() and rcu_read_unlock() events to really stress
	the read-side processing.

o	The four fakewriters ensure interaction between multiple
	writers.

To Nick's point, I did use a hacked-up rcutorture with millisecond
read-side delays when debugging preemptable RCU, but I also used stock
rcutorture.

I will give this some thought and see if the defaults should change or
if more knobs are needed.

							Thanx, Paul
