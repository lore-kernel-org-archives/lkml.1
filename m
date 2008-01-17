Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbYAQRai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbYAQRai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 12:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYAQRaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:30:25 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:45876 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861AbYAQRaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:30:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FACofj0dMROHU/2dsb2JhbACBV6w4
Date: Wed, 16 Jan 2008 23:25:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>, john stultz <johnstul@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
Message-ID: <20080117042503.GD9513@Krystal>
References: <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal> <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com> <1200523867.6127.5.camel@localhost.localdomain> <Pine.LNX.4.58.0801161827450.17781@gandalf.stny.rr.com> <1200536889.6127.52.camel@localhost.localdomain> <20080117024000.GD2322@Krystal> <20080117025004.GE2322@Krystal> <18318.51622.37470.246611@cargo.ozlabs.ibm.com> <Pine.LNX.4.58.0801162234340.21116@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801162234340.21116@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:24:07 up 74 days,  9:29,  4 users,  load average: 0.94, 0.78,
	0.56
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Thu, 17 Jan 2008, Paul Mackerras wrote:
> >
> > It's very hard to do a per-thread counter in the VDSO, since threads
> > in the same process see the same memory, by definition.  You'd have to
> > have an array of counters and have some way for each thread to know
> > which entry to read.  Also you'd have to find space for tens or
> > hundreds of thousands of counters, since there can be that many
> > threads in a process sometimes.
> 
> I was thinking about this. What would also work is just the ability to
> read the schedule counter for the current cpu. Now this would require that
> the task had a way to know which CPU it was currently on.
> 
> -- Steve
> 

The problem with the per cpu schedule counter would be to deal with
stopped tasks that would wake up at the exact wrong moment. With a 32
bits counter, it could happen.

At 1000HZ, given the scheduler is only called once per tick
(approximation, it can also be called explicitly) it would happen after
49.7 days. But then, if the kernel calls schedule() too often, this can
be sooner than that.

Having a per-thread variable would make sure we don't have this problem.

By the way, a task cannot "really know" which CPU it is on : it could be
migrated between the cpu ID read and the moment it uses it as an array
index. Actually, knowing the schedule count would help to implement
algorithms that helps getting the cpu id and knowing it's been valid for
a period of time without pinning to a particular CPU.

Mathieu

(sorry for repost, messed up with my mail client)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
