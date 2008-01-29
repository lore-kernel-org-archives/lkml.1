Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbYA2La0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbYA2La0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 06:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbYA2LaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 06:30:16 -0500
Received: from relay2.sgi.com ([192.48.171.30]:51153 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754278AbYA2LaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 06:30:14 -0500
Date: Tue, 29 Jan 2008 05:30:05 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, sgrubb@redhat.com,
       rostedt@goodmis.org, ghaskins@novell.com, dmitry.adamushko@gmail.com,
       tong.n.li@intel.com, tglx@linutronix.de, menage@google.com,
       rientjes@google.com
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
Message-Id: <20080129053005.bc7a11d7.pj@sgi.com>
In-Reply-To: <1201604243.28547.101.camel@lappy>
References: <1201600428.28547.87.camel@lappy>
	<1201604243.28547.101.camel@lappy>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter wrote, in reply to Peter ;):
> > [ It looks to me it balances a group over the largest SD the current cpu
> >   has access to, even though that might be larger than the SD associated
> >   with the cpuset of that particular cgroup. ]
> 
> Hmm, with a bit more thought I think that does indeed DTRT. Because, if
> the cpu belongs to a disjoint cpuset, the highest sd (with
> load-balancing enabled) would be that. Right?

The code that defines sched domains, kernel/sched.c partition_sched_domains(),
as called from the cpuset code in kernel/cpuset.c rebuild_sched_domains(),
does not make use of the full range of sched_domain possibilities.

In particular, it only sets up some non-overlapping set of sched domains.
Every CPU ends up in at most a single sched domain.

The original reason that one can't define overlapping sched domains via
this cpuset interface (based off the cpuset 'sched_load_balance' flag)
is that I didn't realize it was even possible to overlap sched domains
when I wrote the cpuset code defining sched domains.  And then when I
later realized one could overlap sched domains, I (a) didn't see a need
to do so, and (b) couldn't see how to do so via the cpuset interface
without causing my brain to explode.

Now, back to Peter's question, being a bit pedantic, CPUs don't belong
to disjoint cpusets, except in the most minimal situation that there is
only one cpuset covering all CPUs.

Rather what happens, when you have need for some realtime CPUs, is that:
 1) you turn off sched_load_balance on the top cpuset,
 2) you setup your realtime cpuset as a child cpuset of the top cpuset
    such that its CPUs doesn't overlap any of its siblings, and
 3) you turn off sched_load_balance in that realtime cpuset.

At that point, sched domains are rebuilt, including providing a
sched domain that just contains the CPUs in that realtime cpuset, and
normal scheduler load balancing ceases on the CPUs in that realtime
cpuset.

> [ Just a bit of a shame we have all cgroups represented on each cpu. ]

Could you restate this -- I suspect it's obvious, but I'm oblivious ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
