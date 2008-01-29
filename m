Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbYA2Lxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbYA2Lxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 06:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYA2Lx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 06:53:28 -0500
Received: from relay1.sgi.com ([192.48.171.29]:54228 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750727AbYA2Lx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 06:53:27 -0500
Date: Tue, 29 Jan 2008 05:53:18 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, sgrubb@redhat.com,
       rostedt@goodmis.org, ghaskins@novell.com, dmitry.adamushko@gmail.com,
       tong.n.li@intel.com, tglx@linutronix.de, menage@google.com,
       rientjes@google.com
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
Message-Id: <20080129055318.5b669847.pj@sgi.com>
In-Reply-To: <1201606284.28547.114.camel@lappy>
References: <1201600428.28547.87.camel@lappy>
	<20080129040130.7b2904b6.pj@sgi.com>
	<1201603816.28547.94.camel@lappy>
	<20080129051353.4628c9eb.pj@sgi.com>
	<1201606284.28547.114.camel@lappy>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter wrote;
> So, I don't think we need that, I think we can do with the single flag,
> we just need to find these disjoint sets and stick our rt-domain there. 

Ah - perhaps you don't need that flag - but my other cpuset users do ;).

You see, there are two very different ways that 'sched_load_balance' is
used in practice.

The other way is by big batch schedulers.  They may be placed in charge
of managing a few hundred CPUs on a system, and might be running a mix
of many small jobs each covering only a few CPUs.  They routinely setup
one cpuset for each job, to contain that job to the CPUs and memory
nodes assigned to it.  This is actually the original motivating use for
cpusets.

As a bit of optimization, batch schedulers desire to tell the normal
kernel scheduler -not- to bother load balancing across the big set of
CPUs controlled by the batch scheduler, but only to load balance within
each of the smaller per-job cpusets.  Load balancing across hundreds
of CPUs when the batch scheduler knows such efforts would be fruitless
is a waste of good CPU cycles in kernel/sched.c.

I really doubt we'd want to have such systems triggering the hard RT
scheduler on whatever CPUs were in the batch schedulers big cpuset
that didn't happened to have an active job currently assigned to them.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
