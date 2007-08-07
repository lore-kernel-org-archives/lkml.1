Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbXHGTPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbXHGTPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 15:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXHGTPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 15:15:31 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57812 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbXHGTPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 15:15:30 -0400
Date: Wed, 8 Aug 2007 00:44:30 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, josht@linux.vnet.ibm.com,
       tytso@us.ibm.com, dvhltc@us.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH 4/4 RFC] RCU: synchronize_sched() without migration
Message-ID: <20070807191429.GA31719@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20070807183946.GA32110@linux.vnet.ibm.com> <20070807185226.GD10068@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807185226.GD10068@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 11:52:26AM -0700, Paul E. McKenney wrote:
> The combination of CPU hotplug and PREEMPT_RCU has resulted in deadlocks
> due to the migration-based implementation of synchronize_sched() in -rt.
> This experimental patch maps synchronize_sched() back onto Classic RCU,
> eliminating the migration, thus hopefully also eliminating the deadlocks.
> It is not clear that this is a good long-term approach, but it will at
> least permit people doing CPU hotplug in -rt kernels additional wiggle
> room in their design and implementation.
> 
> The basic approach is to cause the -rt kernel to incorporate rcuclassic.c
> as well as rcupreempt.c, but to #ifdef out the conflicting portions of
> rcuclassic.c so that only the code needed to implement synchronize_sched()
> remains in a PREEMPT_RT build.  Invocations of grace-period detection
> from the scheduling-clock interrupt go to rcuclassic.c, which then invokes
> the corresponding functions in rcupreempt.c (with _rt suffix added to
> keep the linker happy).  Also applies the RCU_SOFTIRQ to classic RCU.
> The bulk of this patch just moves code around.
> 
> If this patch does turn out to be the right approach, the #ifdefs in
> kernel/rcuclassic.c might be dealt with.  ;-)

I think the right thing to do would be to fix cpu hotplug to
use a simple reference count, as the latest patches Gautham
is working on. That simplifies the implementation from the
earlier version with a per-cpu reference counter with RCU.
No freezer, no lock.

Thanks
Dipankar
