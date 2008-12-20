Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbYLTEdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbYLTEdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 23:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYLTEdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 23:33:38 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:51024 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYLTEdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 23:33:37 -0500
Date: Sat, 20 Dec 2008 10:06:38 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       venkatesh.pallipadi@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
       dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, ego@in.ibm.com, andi@firstfloor.org,
       davecb@sun.com, tconnors@astro.swin.edu.au, maxk@qualcomm.com,
       gregory.haskins@gmail.com, pavel@suse.cz,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v7 4/8] sched: nominate preferred wakeup cpu
Message-ID: <20081220043638.GA24181@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <20081218175622.29812.69201.stgit@drishya.in.ibm.com> <20081219135508.9c6217ba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081219135508.9c6217ba.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2008-12-19 13:55:08]:

> On Thu, 18 Dec 2008 23:26:22 +0530
> Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> > When the system utilisation is low and more cpus are idle,
> > then the process waking up from sleep should prefer to
> > wakeup an idle cpu from semi-idle cpu package (multi core
> > package) rather than a completely idle cpu package which
> > would waste power.
> > 
> > Use the sched_mc balance logic in find_busiest_group() to
> > nominate a preferred wakeup cpu.
> > 
> > This info can be sored in appropriate sched_domain, but
> > updating this info in all copies of sched_domain is not
> > practical.  Hence this information is stored in root_domain
> > struct which is one copy per partitioned sched domain.
> > The root_domain can be accessed from each cpu's runqueue
> > and there is one copy per partitioned sched domain.
> > 
> 
> kernel/sched.c: In function 'find_busiest_group':
> kernel/sched.c:3403: warning: passing argument 1 of '__first_cpu' from incompatible pointer type
> 
> Due to
> 
> 	first_cpu(group_leader->cpumask);
> 
> apparently because Rusty changed sched_group.cpumask into a plain old
> array and nobody tests their stuff against the tree into which it is
> actually integrated :(

Hi Andrew,

I agree.  These are integration issues and I will test better next time.

There were two such bugs which Ingo fixed in the tip.

commit 220e7f617826e0527bbc523ba859f6a4bae0bfe1
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Dec 19 00:53:40 2008 +0100

    sched: fix warning in kernel/sched.c
    
    Impact: fix cpumask conversion bug
    
    this warning:
    
      kernel/sched.c: In function find_busiest_group:
      kernel/sched.c:3429: warning: passing argument 1 of __first_cpu from incompatible pointer type
    
    shows that we forgot to convert a new patch to the new cpumask APIs.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>


commit edb4c71953409c1deac1a80528ac0aa768762b33
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Dec 18 21:30:23 2008 +0100

    sched: move test_sd_parent() to an SMP section of sched.h
    
    Impact: build fix
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

I have tested the sched-tip with these fixes.

> 
> kernel/sched.c: In function 'schedule':
> kernel/sched.c:3679: warning: 'active_balance' may be used uninitialized in this function
> 
> This warning is correct - the code is buggy.

Yes this is my code bug.  I did not see the warning in sched.c.  Is
there any build option that I need to pass in order to get -Wall
effect?

Here is the fix to initialise the active_balance=0.

Thanks for the detailed review.  I will work to improve the quality of
my submission.

--Vaidy

    sched: bug fix -- initialise active_balance variable
    
    In sched.c load_balance_newidle, potential use of uninitialised
    variable.
    
    Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index e6a88bf..a21fe6d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3692,7 +3692,7 @@ redo:
 	}
 
 	if (!ld_moved) {
-		int active_balance;
+		int active_balance = 0;
 
 		schedstat_inc(sd, lb_failed[CPU_NEWLY_IDLE]);
 		if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
