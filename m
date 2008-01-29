Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbYA2Lcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbYA2Lcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 06:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYA2Lcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 06:32:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47439 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbYA2Lcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 06:32:42 -0500
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, sgrubb@redhat.com,
       rostedt@goodmis.org, ghaskins@novell.com, dmitry.adamushko@gmail.com,
       tong.n.li@intel.com, tglx@linutronix.de, menage@google.com,
       rientjes@google.com
In-Reply-To: <20080129051353.4628c9eb.pj@sgi.com>
References: <1201600428.28547.87.camel@lappy>
	 <20080129040130.7b2904b6.pj@sgi.com> <1201603816.28547.94.camel@lappy>
	 <20080129051353.4628c9eb.pj@sgi.com>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 12:31:24 +0100
Message-Id: <1201606284.28547.114.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 05:13 -0600, Paul Jackson wrote:
> Peter wrote:
> > Thanks for the link. Yes I think your last suggestion of creating
> > rt-domains ( http://lkml.org/lkml/2007/10/23/419 ) is a good one.
> 
> We now have a per-cpuset Boolean flag file called 'sched_load_balance'.

SD_LOAD_BALANCE, right?

> In the default case, this flag is set on, and the kernel does its
> usual load balancing across all CPUs in that cpuset.  This means, under
> the covers, that there exists some sched domain such that all CPUs in
> that cpuset are in that same sched domain.  That sched domain might
> contain additional CPUs from outside that cpuset as well.  Indeed,
> in the default vanilla configuration, that sched domain contains all
> CPUs in the system.
> 
> If we turn the sched_load_balance flag off for some cpuset, we are
> telling the kernel it's ok not to load balance on the CPUs in that
> cpuset (unless those CPUs are in some other cpuset that needed load
> balancing anyway.)
> 
> This 'sched_load_balance' flag is, thus far, "the" cpuset hook
> supporting realtime.  One can use it to configure a system so that
> the kernel does not do normal load balancing on select CPUs, such
> as those CPUs dedicated to realtime use.

Ah, here I disagree, it is possible to do (hard) realtime scheduling
over multiple cpus, the only draw back is that it requires a very strong
load-balancer, making it unsuitable for large number of cpus.

( of course, having a strong rt load balancer on a large cpuset doesn't
  harm, as long as there are no rt tasks to balance )

So if we have a system like so:

             __A__
            /  |  \
          B1  B2  B3
          /\
         /  \
       C1   C2

A comprises of cpus 0-127, !SD_LOAD_BALANCE

B1 comprises of cpus 0-63, !SD_LOAD_BALANCE
B2 comprises of cpus 64-119
B3                   120-127

C1                   0-3
C2                   5-63

We end up with 4 disjoint load-balanced sets.

I would then attach the rt balance information to: C1, C2, B2, B3.

If, for example, B1 would be load-balanced, we'd only have 3 disjoint
sets left: B1, B2 and B3, and the rt balance data would be there.

> It sounds like Peter is reminding us that we really have three choices
> for a handling a given CPU's load balancing:
>  1) normal kernel scheduler load balancing,
>  2) RT load balancing, or
>  3) no load balancing whatsoever.
> 
> If that's the case (if we really need choice 3) then a single Boolean
> flag, such as sched_load_balance, is not sufficient to select from
> the three choices, and it might make sense to add a second per-cpuset
> Boolean flag, say "sched_rt_balance", default off, which if turned on,
> enabled choice 2.
> 
> If that's not the case (we only need choices 1 and 2) then -logically-
> we could overload the meaning of the current sched_load_balance,
> to mean, if turned off, not only to stop doing normal balancing, but
> to further mean that we should commence RT balancing.  However bits
> aren't -that- precious here, and this sounds unnecessarily confusing.
> 
> So ... would a new per-cpuset Boolean flag such as sched_rt_balance be
> appropriate and sufficient to mark those cpusets whose set of CPUs
> required RT balancing?

So, I don't think we need that, I think we can do with the single flag,
we just need to find these disjoint sets and stick our rt-domain there. 


