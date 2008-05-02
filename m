Return-Path: <linux-kernel-owner+w=401wt.eu-S937298AbYEBXFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937298AbYEBXFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759612AbYEBXFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:05:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760589AbYEBXFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:05:21 -0400
Date: Fri, 2 May 2008 16:04:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balaji Rao <balajirrao@gmail.com>
Cc: dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, menage@google.com, balbir@in.ibm.com,
       vatsa@linux.vnet.ibm.com, a.p.zijlstra@chello.nl
Subject: Re: [RFC][-mm] Simple stats for cpu resource controller v3
Message-Id: <20080502160434.2dfb7ff4.akpm@linux-foundation.org>
In-Reply-To: <200805030417.07794.balajirrao@gmail.com>
References: <200804052339.46632.balajirrao@gmail.com>
	<200805030110.29511.balajirrao@gmail.com>
	<20080502125304.77dd38ba.akpm@linux-foundation.org>
	<200805030417.07794.balajirrao@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008 04:17:03 +0530
Balaji Rao <balajirrao@gmail.com> wrote:

> On Saturday 03 May 2008 01:23:04 am Andrew Morton wrote:
> > On Sat, 3 May 2008 01:10:28 +0530
> >
> > Balaji Rao <balajirrao@gmail.com> wrote:
> > > On Friday 02 May 2008 02:30:26 am Andrew Morton wrote:
> > > <snip>
> > >
> > > Hi Andrew,
> > >
> > > Thank you for the review.
> > >
> > > > Did you consider using include/linux/percpu_counter.h?
> > > >
> > > > If so, what was wrong with it?
> > > >
> > > > Because it would be much better to fix per-cpu counters than to invent
> > > > new stuff.
> > >
> > > No, I hadn't consider using the percpu_counters infrastructure. But today
> > > when I tried using it, I got an early exception.I guess its because I
> > > tried calling percpu_counter_init from within sched_init, which I perhaps
> > > shouldn't do, because percpu_counter_init expects cpu hotplug code to be
> > > initialized by then. Right ? Correct me if I'm wrong.
> >
> > I don't see any reason why we cannot run percpu_counter_init() prior to
> > running percpu_counter_startup().  And it is desirable that we be able to
> > start using the percpu-counters quite early.
> >
> > Can you debug it a bit please?  It's probably some silly little thing,
> > perhaps fixable by calling percpu_counter_startup() earlier.
> >
> percpu_counter_init uses kmalloc to create percpu counters. This raises an 
> early exception as kmem_cache is not initialized that early.

whaa?  kmalloc is ready to be used quite early in boot.  It's a bit of a
concern that the CPU resource controller is doing stuff before even kmalloc
is ready to go.

What's the call path here?  Via cgroup_init_early()?  Does it need to run
that early?

> It worked for me if we statically allocate memory for the counters. But its 
> not at all a nice thing to do and I don't see another way to make it fit for 
> early use.
> 
> I'm beginning to run out of ideas! Why not do what I earlier suggested - begin 
> collecting statistics once we are able to safely use percpu_counters ? This 
> now seems to be the best alternative IMHO.

I'd need to see the code.  If we end up doing

	if (counters_are_ready)
		increment_counter();

all over then place then we need to think harder.

Maybe we need a cgroup_init_late(), which can do memory allocations.  If
nothing actually needs to touch the counters before cgroup_init_late() runs
then that might be OK.

