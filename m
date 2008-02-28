Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbYB1Rhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbYB1Rhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYB1Rhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:37:32 -0500
Received: from relay1.sgi.com ([192.48.171.29]:50012 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752355AbYB1Rhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:37:31 -0500
Date: Thu, 28 Feb 2008 11:37:28 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Message-Id: <20080228113728.7b8e5811.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802280212070.23040@chino.kir.corp.google.com>
References: <20080227222103.673194000@chello.nl>
	<20080228075010.GA28781@elte.hu>
	<20080228020808.3fd22f77.pj@sgi.com>
	<20080228090847.GA1133@elte.hu>
	<20080228031710.3405e405.pj@sgi.com>
	<alpine.DEB.1.00.0802280129580.15900@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802280212070.23040@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have strong opinions either way on this patch; it adds an error
check that makes sense.  I haven't seen much problem not having this check,
nor do I know of any code that depends on doing what this check prohibits.

Except for three details:

 1) +	if (unlikely((p->flags & PF_CPU_BOUND) && p != current &&
    +	    	     !cpus_equal(p->cpus_allowed, new_mask))) {
    +		ret = -EINVAL;

    The check for equal cpus allowed seems too strong.  Shouldn't you be
    checking that all of task p's cpus_allowed would still be allowed in
    the new mask:

    +	if (unlikely((p->flags & PF_CPU_BOUND) && p != current &&
    +	    	     !cpus_subset(p->cpus_allowed, new_mask))) {
    +		ret = -EINVAL;

 2) Doesn't this leave out a check for the flip side -- shrinking
    the cpus allowed by a cpuset so that it no longer contains those
    required by any PF_CPU_BOUND tasks in that cpuset?  I'm not sure
    if this second check is a good idea or not.

 3) Could we call this PF_CPU_PINNED instead?  I tend to use "cpu
    bound" to refer to tasks that consume alot of CPU cycles (which
    these pinned tasks rarely do), and "pinned" to refer to what is
    done to confine a task to a particular subset of all possible CPUs.
    It looks to me like some code in kernel/sched.c already uses the
    word pinned in this same way, so PF_CPU_PINNED would be more
    consistent terminology.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
