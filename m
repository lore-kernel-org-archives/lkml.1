Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbYA2LOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbYA2LOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 06:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbYA2LOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 06:14:07 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42454 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753979AbYA2LOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 06:14:05 -0500
Date: Tue, 29 Jan 2008 05:13:53 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, sgrubb@redhat.com,
       rostedt@goodmis.org, ghaskins@novell.com, dmitry.adamushko@gmail.com,
       tong.n.li@intel.com, tglx@linutronix.de, menage@google.com,
       rientjes@google.com
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
Message-Id: <20080129051353.4628c9eb.pj@sgi.com>
In-Reply-To: <1201603816.28547.94.camel@lappy>
References: <1201600428.28547.87.camel@lappy>
	<20080129040130.7b2904b6.pj@sgi.com>
	<1201603816.28547.94.camel@lappy>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter wrote:
> Thanks for the link. Yes I think your last suggestion of creating
> rt-domains ( http://lkml.org/lkml/2007/10/23/419 ) is a good one.

We now have a per-cpuset Boolean flag file called 'sched_load_balance'.

In the default case, this flag is set on, and the kernel does its
usual load balancing across all CPUs in that cpuset.  This means, under
the covers, that there exists some sched domain such that all CPUs in
that cpuset are in that same sched domain.  That sched domain might
contain additional CPUs from outside that cpuset as well.  Indeed,
in the default vanilla configuration, that sched domain contains all
CPUs in the system.

If we turn the sched_load_balance flag off for some cpuset, we are
telling the kernel it's ok not to load balance on the CPUs in that
cpuset (unless those CPUs are in some other cpuset that needed load
balancing anyway.)

This 'sched_load_balance' flag is, thus far, "the" cpuset hook
supporting realtime.  One can use it to configure a system so that
the kernel does not do normal load balancing on select CPUs, such
as those CPUs dedicated to realtime use.

It sounds like Peter is reminding us that we really have three choices
for a handling a given CPU's load balancing:
 1) normal kernel scheduler load balancing,
 2) RT load balancing, or
 3) no load balancing whatsoever.

If that's the case (if we really need choice 3) then a single Boolean
flag, such as sched_load_balance, is not sufficient to select from
the three choices, and it might make sense to add a second per-cpuset
Boolean flag, say "sched_rt_balance", default off, which if turned on,
enabled choice 2.

If that's not the case (we only need choices 1 and 2) then -logically-
we could overload the meaning of the current sched_load_balance,
to mean, if turned off, not only to stop doing normal balancing, but
to further mean that we should commence RT balancing.  However bits
aren't -that- precious here, and this sounds unnecessarily confusing.

So ... would a new per-cpuset Boolean flag such as sched_rt_balance be
appropriate and sufficient to mark those cpusets whose set of CPUs
required RT balancing?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
