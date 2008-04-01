Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbYDAWyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbYDAWyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYDAWyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 18:54:24 -0400
Received: from relay2.sgi.com ([192.48.171.30]:39587 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751398AbYDAWyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 18:54:23 -0400
Message-Id: <20080401225422.064890000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 15:54:22 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>
Subject: [PATCH 0/3] x86: add cpuset_scnprintf function
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


*  Add a new cpuset_scnprintf and a sysctl flag to control how cpumask sets
   are printed.  The default is to use the current cpumask_scnprintf.  If
   kernel.compat_cpuset_printf is '0' (default 1), then cpulist_scnprintf
   is used.  In addition, a nodeset_scnprintf is provided for compatibilty.

   This is introduced with a CONFIG_KERN_COMPAT_CPUSET_PRINTF flag which
   currently is only defined for X86_64_SMP architecture.  For all other
   architectures the current cpumask_scnprintf() is used.

*  Modify usages of cpumask_scnprintf to use the new cpuset_scnprintf where
   appropriate.  The list of files affected are:

	arch/x86/kernel/cpu/intel_cacheinfo.c
	drivers/base/node.c
	drivers/base/topology.c
	drivers/pci/pci-sysfs.c
	drivers/pci/probe.c
	kernel/irq/proc.c
	kernel/profile.c
	kernel/sched_stats.h
	kernel/sysctl.c
	kernel/sysctl_check.c
	kernel/trace/trace.c

Note that kernel/sched.c is not in this patchset as it has many other changes,
so the change to use cpuset_scnprintf is in another patchset.

For inclusion in x86/latest.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Cc: Bert Wesarg <bert.wesarg@googlemail.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---

The discussion that led up to this...

On Fri, Mar 28, 2008 at 3:40 PM, Mike Travis <travis@sgi.com> wrote:
> >
> > Bert Wesarg wrote:
> >  > On Fri, Mar 28, 2008 at 12:16 AM, Mike Travis <travis@sgi.com> wrote:
...
>  >>  +       /*
> >  >>  +        * cpulist_scnprintf() has the advantage of compressing
> >  >>  +        * consecutive cpu numbers into a single range which seems
> >  >>  +        * appropriate for cpus on a leaf.  This will change what is
> >  >>  +        * output so scripts that process the output will have to change.
> >  > So this breaks user space?
> >  >
> >  > Bert
> >
> >  Potentially, yes.  But I suspect with 4096 cpus, user scripts will have
> >  to change anyways.  Currently it is represented as sets of 32 bit mask
> >  outputs with comma separators, so 1152 characters would be output.
But you can declare it as a programming error on user space side. If
you change the format, the brown-paper-bag is yours.


On Mon, Mar 31, 2008 at 6:35 PM, Mike Travis <travis@sgi.com> wrote:
> > Bert Wesarg wrote:
> >  > On Fri, Mar 28, 2008 at 7:19 PM, Mike Travis <travis@sgi.com> wrote:
> >  >>  > Aren't the most cpumaps (like cpu/cpu*/topology/*_siblings or
> >  >>  > node/node*/cpumap) bitmasks?
> >  >>
> >  >>  I did an informal survey and you are right, the majority of references do use
> >  >>  cpumask_scnprintf instead of cpulist_scnprintf.  Maybe the later function was
> >  >>  added later?
> >  >>
> >  >>  To me though, it would seem that:
> >  >>
> >  >>  240-255
> >  >>
> >  >>  is more readable than:
> >  >>
> >  >>  00000000,00000000,00000000,00000000,00000000,00000000,00000000,0000ffff
> >  >>
> >  >>  And as I mentioned, bitmask_parselist() [libbitmask(3)] does parse the output.
> >  > But libbitmask has a bitmask_parsehex() too. (but thanks for the
> >  > pointer to this code).
> >  >
> >  > Anyway, your above example is wrong, the most significant bits comes first:
> >  >
> >  > ffff0000,00000000,00000000,00000000,00000000,00000000,00000000,00000000
> >  >
> >  > This makes it not more readable, but I think readability isn't in this
> >  > case of that much importance.
> >
> >  The original problem was how to avoid allocating a large stack space to display
> >  cpu ids.  By using cpulist_scnprintf, it accomplishes this without, what I think
> >  is too much pain.  If it's really that much of a problem, I will rework this patch.
> >  But the length of the line with 4096 cpus will be 1152 bytes  Is this really
> >  better?
I ask myself, why is there a temporary buffer allocation in the first
place? In the end it is copied unbounded into the provided buf
argument. Sure your list is mostly shorter than a hex mask, but you
can also not be sure that it fit into the provided buffer. So you can
also use cpumask_scnprintf directly with the buf argument, and provide
a good known upper bound for the size (ie.
cpumask_scnprintf_len(nr_cpu_ids)).

-- 
