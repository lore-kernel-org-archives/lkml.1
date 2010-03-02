Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab0CBXHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:07:15 -0500
Received: from mail.openrapids.net ([64.15.138.104]:59453 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751787Ab0CBXHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:07:13 -0500
Date: Tue, 2 Mar 2010 18:07:10 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: mingo@elte.hu, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Chris Friesen <cfriesen@nortel.com>
Subject: Re: [PATCH -tip] introduce sys_membarrier(): process-wide memory
	barrier (v9)
Message-ID: <20100302230709.GB23645@Krystal>
References: <20100225232316.GA30196@Krystal> <20100302175200.GC7057@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302175200.GC7057@feather>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:59:09 up 39 days,  1:36,  3 users,  load average: 1.46, 0.98,
	0.78
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Josh Triplett (josh@joshtriplett.org) wrote:
> On Thu, Feb 25, 2010 at 06:23:16PM -0500, Mathieu Desnoyers wrote:
> > I am proposing this patch for the 2.6.34 merge window, as I think it is ready
> > for inclusion.
> > 
> > Here is an implementation of a new system call, sys_membarrier(), which
> > executes a memory barrier on all threads of the current process.
> [...] 
> 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Acked-by: Steven Rostedt <rostedt@goodmis.org>
> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > CC: Nicholas Miell <nmiell@comcast.net>
> > CC: Linus Torvalds <torvalds@linux-foundation.org>
> > CC: mingo@elte.hu
> > CC: laijs@cn.fujitsu.com
> > CC: dipankar@in.ibm.com
> > CC: akpm@linux-foundation.org
> > CC: josh@joshtriplett.org
> 
> Acked-by: Josh Triplett <josh@joshtriplett.org>
> 
> I agree that v9 seems ready for inclusion.

Thanks!

> 
> Out of curiosity, do you have any benchmarks for the case of not
> detecting sys_membarrier dynamically?  Detecting it at library
> initialization time, for instance, or even just compiling to assume its
> presence?  I'd like to know how much that would improve the numbers.

Citing the patch changelog:

Results in liburcu:

Operations in 10s, 6 readers, 2 writers:

(what we previously had)
memory barriers in reader: 973494744 reads, 892368 writes
signal-based scheme:      6289946025 reads,   1251 writes

(what we have now, with dynamic sys_membarrier check, expedited scheme)
memory barriers in reader: 907693804 reads, 817793 writes
sys_membarrier scheme:    4316818891 reads, 503790 writes

So basically, yes, there is a significant overhead on the read-side if we
compare the dynamic check (0.39 ns/read per reader) to the signal-based scheme
(0.26 ns/read per reader) (which only needs the barrier()). On the update-side,
we cannot care less though.

> 
> If significant, it might make sense to try to have a mechanism similar
> to SMP alternatives, to have different code in either case.  dlopen,
> function pointers, runtime code patching (nop out the rmb), or similar.

Yes, definitely. It could also be useful to switch between UP and SMP primitives
dynamically when spawning the second thread in a process. We should be careful
when sharing memory maps between processes though.

Thanks,

Mathieu

> 
> - Josh Triplett

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
