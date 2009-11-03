Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZKCQ6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZKCQ6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZKCQ6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:58:15 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:64997 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728AbZKCQ6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:58:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap0EAILq70pGGN1W/2dsb2JhbACBUN1shD0E
Date: Tue, 3 Nov 2009 11:53:14 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Jon Bernard <jbernard@debian.org>,
       Jan Blunck <jblunck@suse.de>, Pierre Habouzit <madcoder@debian.org>,
       Steven Munroe <munroesj@linux.vnet.ibm.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       ltt-dev@lists.casi.polymtl.ca, rp@svcs.cs.pdx.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [RELEASE] Userspace RCU 0.3.0
Message-ID: <20091103165314.GD27775@Krystal>
References: <20091103150234.GA20060@Krystal> <20091103155028.GC6726@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091103155028.GC6726@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:38:36 up 77 days,  3:28,  3 users,  load average: 0.89, 0.40,
	0.33
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Tue, Nov 03, 2009 at 10:02:34AM -0500, Mathieu Desnoyers wrote:
> > Hi everyone,
> > 
> > I released userspace RCU 0.3.0, which includes a small API change for
> > the "deferred work" interface. After discussion with Paul, I decided to
> > drop the support for call_rcu() and only provide defer_rcu(), to make
> > sure I don't provide an API with the same name as the kernel RCU but
> > with different arguments and semantic. It will generate the following
> > linker error if used:
> > 
> > file.c:240: undefined reference to 
> >    `__error_call_rcu_not_implemented_please_use_defer_rcu'
> > 
> > Note that defer_rcu() should *not* be used in RCU read-side C.S.,
> > because it calls synchronize_rcu() if the queue is full. This is a major
> > distinction from call_rcu(). (note to self: eventually we should add
> > some self-check code to detect defer_rcu() nested within RCU read-side
> > C.S.).
> > 
> > I plan to eventually implement a proper call_rcu() within the userspace
> > RCU library. It's not, however, a short-term need for me at the moment.
> 
> I can tell that we need to get you going on some real-time work.  ;-)
> 

:-)

> (Sorry, but I really couldn't resist!)
> 

It's true that it becomes important when real-time behavior is required
at the call_rcu() execution site. However, even typical use of
call_rcu() has some limitations in this area: in a scenario where the
struct rcu_head passed to call_rcu() is allocated dynamically, kmalloc
and friends do not offer any kind of wait-free/lock-free guarantees. So
the way call_rcu() works is to push the burden of RT impact on the
original struct rcu_head allocation. But I agree that it makes
out-of-memory/queue full error handling much easier, because all the
allocation is done at the same site.

The main disadvantage of the call_rcu() approach though is that I cannot
see any clean way to perform call_rcu() rate-limitation on a per-cpu
basis. This would basically imply that we have to stop providing RT
call_rcu() at some point to ensure we do not go over a certain
threshold.

A possible solution would be to make call_rcu() return an error when it
goes over some threshold. The caller would have to deal with the error,
possibly by rejecting the whole operation (so maybe another CPU/cloud
node could take over the work). This seems cleaner than delaying
execution of the call_rcu() site. The caller could actually decide to
either reject the whole operation or to delay its execution.

Mathieu


> 							Thanx, Paul

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
