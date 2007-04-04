Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbXDDGrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbXDDGrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbXDDGri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:47:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbXDDGri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:47:38 -0400
Date: Wed, 4 Apr 2007 02:47:32 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Paul Jackson <pj@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, drepper@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: getting processor numbers
Message-ID: <20070404064732.GF355@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <461286D6.2040407@redhat.com> <20070403131623.c6831607.akpm@linux-foundation.org> <20070403190458.18165884.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403190458.18165884.pj@sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 07:04:58PM -0700, Paul Jackson wrote:
> Andrew wrote:
> > I'd have thought that in general an application should be querying its
> > present affinity mask - something like sched_getaffinity()?  That fixes the
> > CPU hotplug issues too, of course.
> 
> The sched_getaffinity call is quick, too, and it nicely reflects any
> cpuset constraints, while still working on kernels which don't have
> CPUSETs configured.
> 
> There are really at least four "number of CPUs" answers here, and we
> should be aware of which we are providing.  There are, in order of
> decreasing size:
>  1) the size of the kernels cpumask_t (NR_CPUS),
>  2) the maximum number of CPUs that might ever be hotplugged into a
>     booted system,
>  3) the current number of CPUs online in that system, and
>  4) the number of CPUs that the current task is allowed to use.
> 
> I would suggest that (4) is what we should typically return.
> Certainly it would seem that the use that Ulrich is concerned with,
> by OpenMP, wants (4).
> 
> Currently, the sysconf(_SC_NPROCESSORS_CONF) returns (3), by counting
> the CPUs in /proc/stat, which is rather bogus on cpuset, or even
> sched_setaffinity, constrained systems.

OpenMP wants (4) and I'll change it that way.

sysconf(_SC_NPROCESSORS_ONLN) must return (3) (this currently scans /proc/stat)
and
sysconf(_SC_NPROCESSORS_CONF) should IMHO return (2) (this currently
scans /proc/cpuinfo on alpha and sparc{,64} for ((ncpus|CPUs) probed|cpus detected)
and for the rest just returns sysconf(_SC_NPROCESSORS_ONLN)).
Neither of the sysconf returned values should be affected by affinity.

	Jakub
