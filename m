Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab0BYRvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:51:25 -0500
Received: from mail.openrapids.net ([64.15.138.104]:52525 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932888Ab0BYRvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:51:23 -0500
Date: Thu, 25 Feb 2010 12:51:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Nick Piggin <npiggin@suse.de>, Chris Friesen <cfriesen@nortel.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: Re: [RFC patch] introduce sys_membarrier(): process-wide memory
	barrier (v9)
Message-ID: <20100225175121.GA6658@Krystal>
References: <20100212224606.GA30280@Krystal> <4B82CF1A.3010501@nortel.com> <20100222212321.GA2573@Krystal> <20100224091052.GY9738@laptop> <20100224152251.GA16295@Krystal> <20100225053310.GA9738@laptop> <20100225165301.GF24052@Krystal> <1267118726.6328.20.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267118726.6328.20.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:36:20 up 33 days, 20:13,  4 users,  load average: 0.74, 0.81,
	0.54
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-02-25 at 11:53 -0500, Mathieu Desnoyers wrote:
> 
> > > It would be very trivial compared to the process-private case. Just IPI
> > > all CPUs. It would allow older kernels to work with newer process based
> > > apps as they get implemented. But... not a really big deal I suppose.
> > 
> > This is actually what I did in v1 of the patch, but this implementation met
> > resistance from the RT people, who were concerned about the impact on RT tasks
> > of a lower priority process doing lots of sys_membarrier() calls. So if we want
> > to do other-process-aware sys_membarrier(), we would have to iterate on all
> > cpus, for every running process shared memory maps and see if there is something
> > shared with all shm of the current process. This is clearly not as trivial as
> > just broadcasting the IPI to all cpus.
> 
> Right, it may require another syscall or parameter to let the tasks
> register a shared page. Then have some mechanism to find a way to
> quickly check if a CPU is running a process with that page.

Well, either we explicitly require the task to register its shared pages, which
could be error-prone in terms of API, or simply consider all pages that are
shared between the current process and every process running on other CPUs. That
would be much simpler to use from a user-level perspective I think.  The
downside is that it may generate a few IPIs to processes that happen not to need
them, but we are talking of a relatively small overhead to processes that we are
interacting with anyway. It's not like we would be interrupting completely
unrelated RT threads. I'm just not sure if it would be valid to exclude COW and
RO shared pages from that check. For instance, if a pages is mapped as RO on one
process and RW on another, then we have to synchronize these processes. Similar
weird cases could happen if a memory map is changed from RW to RO right after
the content is modified, and then we need to execute sys_membarrier: we might
miss a memory map that actually needs to be synchronized.

And yes, as you say, we'd have to find a way to quickly compare shared-memory
maps from two processes. The dumb approach, O(n^2), would be to compare these
entries element by element. Assuming a relatively low amount of shared mmaps,
this could make sense, otherwise we'd have to construct a lookup hash table to
accelerate the lookup, but it adds either a basic runtime overhead if we
construct it within sys_membarrier() or a memory overhead if we choose to add it
to the task struct (which I'd really like to avoid).

But... either way we chose, we can extend the system call flags and parameters
as needed, so I think it really should not be part of this initial
implementation.

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
