Return-Path: <linux-kernel-owner+w=401wt.eu-S966277AbXDDCFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966277AbXDDCFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966281AbXDDCFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:05:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44128 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966277AbXDDCE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:04:59 -0400
Date: Tue, 3 Apr 2007 19:04:58 -0700
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: drepper@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: getting processor numbers
Message-Id: <20070403190458.18165884.pj@sgi.com>
In-Reply-To: <20070403131623.c6831607.akpm@linux-foundation.org>
References: <461286D6.2040407@redhat.com>
	<20070403131623.c6831607.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew wrote:
> I'd have thought that in general an application should be querying its
> present affinity mask - something like sched_getaffinity()?  That fixes the
> CPU hotplug issues too, of course.

The sched_getaffinity call is quick, too, and it nicely reflects any
cpuset constraints, while still working on kernels which don't have
CPUSETs configured.

There are really at least four "number of CPUs" answers here, and we
should be aware of which we are providing.  There are, in order of
decreasing size:
 1) the size of the kernels cpumask_t (NR_CPUS),
 2) the maximum number of CPUs that might ever be hotplugged into a
    booted system,
 3) the current number of CPUs online in that system, and
 4) the number of CPUs that the current task is allowed to use.

I would suggest that (4) is what we should typically return.
Certainly it would seem that the use that Ulrich is concerned with,
by OpenMP, wants (4).

Currently, the sysconf(_SC_NPROCESSORS_CONF) returns (3), by counting
the CPUs in /proc/stat, which is rather bogus on cpuset, or even
sched_setaffinity, constrained systems.

> But we discussed this all a couple years back and it was decided that
> sched_getaffinity() was unsuitable.  I remember at the time not really
> understanding why?

Perhaps it was because a robust invocation of sched_getaffinity takes
a page of code to write, as Andi Kleen noticed in his libnuma coding of
"static int number_of_cpus(void)".  One has to size the mask passed in,
in case the kernel was compiled with a larger cpumask_t size than you
guessed up front.  In other words, to get (4) using sched_getaffinity,
one first needs an upper bound on (1), above, the kernels configured
NR_CPUS.

One can either size it by repeatedly invoking sched_getaffinity with
larger masks until it stops failing EINVAL, or one can examine the
length of the "Cpus_allowed" mask displayed in /proc/self/status
(it takes 9 ascii chars, if you include the commas and trailing
newline, to display each 32 bits of cpumask_t.)  There may be other
ways as well; those seem to be the most common.

At least the kernel cpumask_t size can be cached for the life of the
process and any descendents, so the cost of obtaining it should be less
critical.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
