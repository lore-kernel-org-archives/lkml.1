Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbZIWX2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbZIWX2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 19:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZIWX2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 19:28:53 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:60610 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbZIWX2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:28:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar4EAN9LukpMROOX/2dsb2JhbACBUdVIhBsF
Date: Wed, 23 Sep 2009 19:28:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Chris Friesen <cfriesen@nortel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Userspace RCU: (ab)using futexes to save cpu cycles and
	energy
Message-ID: <20090923232855.GB9621@Krystal>
References: <20090923174820.GA12827@Krystal> <4ABA631A.8030306@nortel.com> <20090923190337.GA16983@Krystal> <20090923223204.GA2921@Krystal> <4ABAAB4F.2060905@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4ABAAB4F.2060905@nortel.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 19:25:09 up 36 days, 10:14,  2 users,  load average: 0.07, 0.14,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Friesen (cfriesen@nortel.com) wrote:
> On 09/23/2009 04:32 PM, Mathieu Desnoyers wrote:
> 
> 
> > /*
> >  * Defer thread waiting. Single thread.
> >  */
> > static void wait_defer(void)
> > {
> >         atomic_dec(&defer_thread_futex);
> >         smp_mb();       /* Write futex before read queue */
> >         if (rcu_defer_num_callbacks()) {
> >                 smp_mb();       /* Read queue before write futex */
> >                 /* Callbacks are queued, don't wait. */
> >                 atomic_set(&defer_thread_futex, 0);
> >         } else {
> >                 smp_rmb();      /* Read queue before read futex */
> >                 if (atomic_read(&defer_thread_futex) == -1)
> >                         futex(&defer_thread_futex, FUTEX_WAIT, -1,
> >                               NULL, NULL, 0);
> >         }
> > }
> 
> > The goal here is that if call_rcu() enqueues a callback (even if it
> > races with defer thread going to sleep), there should not be a
> > potentially infinite delay before it gets executed.
> 
> It doesn't seem like the test for the number of callbacks should be
> necessary.  I don't see anything like that in the glibc code, nor do I
> remember anything like that in the futex sample code.
> 

The mutex code (and usual futex users) use futex to implement mutual
exclusion.  My goal is to send a wakeup signal to a thread waiting for
work to perform when adding such work. But without any mutual exclusion.

So it is understandable that glibc code or futex sample code does not
cover that, given this use is, well, creative. ;)

> I'm still not totally convinced that you can avoid race conditions
> without using atomic test-and-set or compare-and-exchange.  I haven't
> sat down and worked it out completely though.
> 

Yes.. this is heavily dependent on the states and values which can be
reached. I should probably take time to create a promela model and run
that though the spin model checker to be sure.

Thanks for the comments,

Mathieu

> Chris

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
