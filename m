Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0CJERH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 23:17:07 -0500
Received: from mail.openrapids.net ([64.15.138.104]:35095 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756244Ab0CJERE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 23:17:04 -0500
Date: Tue, 9 Mar 2010 23:16:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, Chris Friesen <cfriesen@nortel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip] introduce sys_membarrier(): process-wide memory
	barrier (v9)
Message-ID: <20100310041658.GA11667@Krystal>
References: <20100225232316.GA30196@Krystal> <20100304122304.GA6864@elte.hu> <alpine.LFD.2.00.1003040827100.7046@localhost.localdomain> <20100304202304.GA13718@elte.hu> <alpine.LFD.2.00.1003061135160.31447@localhost.localdomain> <20100309065957.GY8653@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309065957.GY8653@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 21:42:28 up 46 days,  5:19,  4 users,  load average: 1.72, 1.31,
	1.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Piggin (npiggin@suse.de) wrote:
[...]
> The library is librcu, which I suspect will become quite important for
> parallel programming in future (maybe I hope for too much).
> 
> But maybe it's better to not merge _any_ librcu special case until
> we see results from programs using it. More general speedups or features
> (that also help librcu) is a different story.
> 

Hi Nick,

So, about the current state of liburcu and its users:

It is currently packaged in Debian, Ubuntu, Gentoo, and it is also being
packaged for Fedora. It is already being used by a few programs/libraries, and
given it's wide availability, we can expect more in a near future.

The first user of this library is the UST (Userspace Tracing) library; a port of
LTTng to a userspace.

  http://lttng.org/ust

Modulo a few changes to port it to userspace, the kernel and user-space LTTng
should be expected to have similar performance, because they use essentially the
same lockless buffering scheme, described in chapter 5 of my thesis:

http://www.lttng.org/pub/thesis/desnoyers-dissertation-2009-12.pdf

Here is the impact of two additional memory barriers on the LTTng tracer fast
path:

Intel Core Xeon 2.0 GHz
LTTng probe writing 16-byte worth of data to the trace (+4 byte event header)
(execution of 200000 loops, therefore trace buffers are cache-hot)

119 ns per event

adding 2 memory barriers, one before and one after the tracepoint:

155 ns per event

So we have a 25% slowdown on the tracer fast path, which is quite significant
when it comes to trace heavy workloads. The slowdown ratio may change slightly
for non cache-hot scenarios, but I expect it to stay in the same range. Section
8.4 of my thesis discusses the overhead of cache-cold buffers (around 333 ns per
event rather than 119 ns). I expect the cost of the memory barriers to increase
too in a cache-cold scenario.

If you want to have an insight on the class of applications that can be improved
with the userspace RCU library, you can have a look at Section 6.3 "User-Space
RCU Usage Scenarios" of my dissertation.

If you still wonder "who is using/contributing to LTTng ?", see section 9.2 of
my thesis. Or here is a quick list, taken from our website:

Google, IBM, Ericsson, Autodesk, Wind River, Fujitsu, Monta Vista, ST
Microelectronics, C2 Microsystems, Sony, Siemens, Nokia, Defence Research and
Development Canada.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
