Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbZDTTuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbZDTTuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZDTTuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:50:06 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59802 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062AbZDTTuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:50:05 -0400
Subject: Re: [PATCH V3] Fix Committed_AS underflow
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mel@linux.vnet.ibm.com,
       cl@linux-foundation.org
In-Reply-To: <1240244120.32604.278.camel@nimitz>
References: <1240218590-16714-1-git-send-email-ebmunson@us.ibm.com>
	 <1240244120.32604.278.camel@nimitz>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 12:49:59 -0700
Message-Id: <1240256999.32604.330.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 09:15 -0700, Dave Hansen wrote:
> On Mon, 2009-04-20 at 10:09 +0100, Eric B Munson wrote:
> > 1. Change NR_CPUS to min(64, NR_CPUS)
> >    This will limit the amount of possible skew on kernels compiled for very
> >    large SMP machines.  64 is an arbitrary number selected to limit the worst
> >    of the skew without using more cache lines.  min(64, NR_CPUS) is used
> >    instead of nr_online_cpus() because nr_online_cpus() requires a shared
> >    cache line and a call to hweight to make the calculation.  Its runtime
> >    overhead and keeping this counter accurate showed up in profiles and it's
> >    possible that nr_online_cpus() would also show.

Wow, that empty reply was really informative, wasn't it? :)

My worry with this min(64, NR_CPUS) approach is that you effectively
ensure that you're going to be doing a lot more cacheline bouncing, but
it isn't quite as explicit.

Now, every time there's a mapping (or set of them) created or destroyed
that nets greater than 64 pages, you've got to go get a r/w cacheline to
a possibly highly contended atomic.  With a number this low, you're
almost guaranteed to hit it at fork() and exec().  Could you
double-check that this doesn't hurt any of the fork() AIM tests?

Another thought is that, instead of trying to fix this up in meminfo, we
could do this in a way that is guaranteed to never skew the global
counter negative: we always keep the *percpu* skew negative.  This
should be the same as what's in the kernel now:

void vm_acct_memory(long pages)
{
        long *local;
	long local_min = -ACCT_THRESHOLD;
	long local_max = ACCT_THRESHOLD;
	long local_goal = 0;

        preempt_disable();
        local = &__get_cpu_var(committed_space);
        *local += pages;
        if (*local > local_max || *local < local_min) {
                atomic_long_add(*local - local_goal, &vm_committed_space);
                *local = local_goal;
        }
        preempt_enable();
}

But now consider if we changed the local_* variables a bit:

	long local_min = -(ACCT_THRESHOLD*2);
	long local_max = 0
	long local_goal = -ACCT_THRESHOLD;

We'll get some possibly *large* numbers in meminfo, but it will at least
never underflow.

-- Dave

