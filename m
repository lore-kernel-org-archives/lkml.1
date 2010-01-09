Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606Ab0AIBCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab0AIBCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 20:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219Ab0AIBCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 20:02:34 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:50714 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781Ab0AIBCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 20:02:34 -0500
Date: Fri, 8 Jan 2010 20:02:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100109010231.GA25368@Krystal>
References: <1262852862.4049.78.camel@laptop> <20100107183010.GA14980@redhat.com> <20100107183946.GL6764@linux.vnet.ibm.com> <1262890782.28171.3738.camel@gandalf.stny.rr.com> <20100107191657.GN6764@linux.vnet.ibm.com> <1262893243.28171.3753.camel@gandalf.stny.rr.com> <20100107205830.GR6764@linux.vnet.ibm.com> <1262900140.28171.3773.camel@gandalf.stny.rr.com> <20100108235338.GA18050@Krystal> <20100109002043.GD6816@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100109002043.GD6816@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 19:58:31 up 23 days,  9:16,  6 users,  load average: 0.25, 0.20,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Fri, Jan 08, 2010 at 06:53:38PM -0500, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > Well, if we just grab the task_rq(task)->lock here, then we should be
> > > OK? We would guarantee that curr is either the task we want or not.
> > 
> > Hrm, I just tested it, and there seems to be a significant performance
> > penality involved with taking these locks for each CPU, even with just 8
> > cores. So if we can do without the locks, that would be preferred.
> 
> How significant?  Factor of two?  Two orders of magnitude?
> 

On a 8-core Intel Xeon (T is the number of threads receiving the IPIs):

Without runqueue locks:

T=1: 0m13.911s
T=2: 0m20.730s
T=3: 0m21.474s
T=4: 0m27.952s
T=5: 0m26.286s
T=6: 0m27.855s
T=7: 0m29.695s

With runqueue locks:

T=1: 0m15.802s
T=2: 0m22.484s
T=3: 0m24.751s
T=4: 0m29.134s
T=5: 0m30.094s
T=6: 0m33.090s
T=7: 0m33.897s

So on 8 cores, taking spinlocks for each of the 8 runqueues adds about
15% overhead when doing an IPI to 1 thread. Therefore, that won't be
pretty on 128+-core machines.

Thanks,

Mathieu



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
