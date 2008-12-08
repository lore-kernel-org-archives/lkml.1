Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYLHDZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYLHDZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 22:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYLHDZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 22:25:09 -0500
Received: from ozlabs.org ([203.10.76.45]:36228 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066AbYLHDZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 22:25:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18748.37739.383961.318233@drongo.ozlabs.ibm.com>
Date: Mon, 8 Dec 2008 14:24:27 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v2
In-Reply-To: <20081208012211.GA23106@elte.hu>
References: <20081208012211.GA23106@elte.hu>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> There's a new "counter group record" facility that is a straightforward 
> extension of the existing "irq record" notification type. This record 
> type can be set on a 'master' counter, and if the master counter triggers 
> an IRQ or an NMI, all the 'secondary' counters are read out atomically 
> and are put into the counter-group record. The result can then be read() 
> out by userspace via a single system call. (Based on extensive feedback 
> from Paul Mackerras and David Miller, thanks guys!)
> 
> The other big change is the support of virtual task counters via counter 
> scheduling: a task can specify more counters than there are on the CPU, 
> the kernel will then schedule the counters periodically to spread out hw 
> resources.

Still not good enough, I'm sorry.

* I have no guarantee that the secondary counters were all counting
  at the same time(s) as the master counter, so the numbers are
  virtually useless.

* I might legitimately want to be notified based on any of the
  "secondary" counters reaching particular values.  The "master"
  vs. "secondary" distinction is an artificial one that is going to
  make certain reasonable use-cases impossible.

These things are both symptoms of the fact that you still have the
abstraction at the wrong level.  The basic abstraction really needs to
be a counter-set, not an individual counter.

I think your patch can be extended to do counter-sets without
complicating the interface too much.  We could have:

struct event_spec {
	u32 hw_event_type;
	u32 hw_event_period;
	u64 hw_raw_ctrl;
};

int perf_counterset_open(u32 n_counters,
    			 struct event_spec *counters,
			 u32 record_type,
			 pid_t pid,
			 int cpu);

and then you could have perf_counter_open as a simple wrapper around
perf_counterset_open.

With an approach like this we can also provide an "exclusive" mode for
the PMU (e.g. with a flag bit in record_type or n_counters), which
means that the counter-set occupies the whole PMU.  That will give a
way for userspace to specify all the details of how the PMU is to be
programmed, which in turn means that the kernel doesn't need to know
all the arcane details of every event on every processor; it just
needs to know the common events.

I notice the implementation also still assumes it can add any counter
at any time subject only to a limit on the number of counters in use.
That will have to be fixed before it is usable on powerpc (and
apparently on some x86 processors too).

Paul.
