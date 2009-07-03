Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZGCF4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZGCF4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 01:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbZGCF42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 01:56:28 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34784 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZGCF41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 01:56:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 3 Jul 2009 14:54:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>, Benjamin Blum <bblum@google.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       lizf@cn.fujitzu.com
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks"
 that  shows only unique tgids
Message-Id: <20090703145441.f526793f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090702183004.1e3f4315.akpm@linux-foundation.org>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	<20090702232620.3969.16680.stgit@menage.mtv.corp.google.com>
	<20090702164649.303c4952.akpm@linux-foundation.org>
	<2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
	<20090702175341.fd2e26d5.akpm@linux-foundation.org>
	<6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
	<20090702183004.1e3f4315.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009 18:30:04 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 2 Jul 2009 18:08:29 -0700 Paul Menage <menage@google.com> wrote:
> 
> > On Thu, Jul 2, 2009 at 5:53 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> > >> In the first snippet, count will be at most equal to length. As length
> > >> is determined from cgroup_task_count, it can be no greater than the
> > >> total number of pids on the system.
> > >
> > > Well that's a problem, because there can be tens or hundreds of
> > > thousands of pids, and there's a fairly low maximum size for kmalloc()s
> > > (include/linux/kmalloc_sizes.h).
> > >
> > > And even if this allocation attempt doesn't exceed KMALLOC_MAX_SIZE,
> > > large allocations are less unreliable. __There is a large break point at
> > > 8*PAGE_SIZE (PAGE_ALLOC_COSTLY_ORDER).
> > 
> > This has been a long-standing problem with the tasks file, ever since
> > the cpusets days.
> > 
> > There are ways around it - Lai Jiangshan <laijs@cn.fujitsu.com> posted
> > a patch that allocated an array of pages to store pids in, with a
> > custom sorting function that let you specify indirection rather than
> > assuming everything was in one contiguous array. This was technically
> > the right approach in terms of not needing vmalloc and never doing
> > large allocations, but it was very complex; an alternative that was
> > mooted was to use kmalloc for small cgroups and vmalloc for large
> > ones, so the vmalloc penalty wouldn't be paid generally. The thread
> > fizzled AFAICS.
> 
> It's a problem which occurs fairly regularly.  Some sites are fairly
> busted.  Many gave up and used vmalloc().  Others use an open-coded
> array-of-pages thing.
> 
> This happens enough that I expect the kernel would benefit from a
> general dynamic-array library facility.  Something whose interface
> mimics the C-level array operations but which is internally implemented
> via some data structure which uses PAGE_SIZE allocations.  Probably a
> simple two-level thing would suffice.
> 
I think both of kmalloc usage here are very bad.

Why we can't do what readdir(/proc) does ? I'm sorry I misunderstand.
Following is an easy example.


0. at open, inilialize f_pos to 0. f_pos is used as "pid"
   remember "css_set with hole" as template in f_private?(or somewhere) at open
   ...like this.
--
   struct cgroupfs_root *root = cgrp->root;
   struct cgroup *template = kzalloc(sizeof(void*) * CGROUP_SUBSYS_COUNT);

   for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
	if (root->subsys_bits & (1UL << i))
		template[i] =  cgrp->subsys[i];
--


1. at read(), find task_struct of "pid" in f_pos.
2. look up task_struct of "pid" and compare with f_private
--
   struct cgroup *template = f_private;

   for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
	if (!template[i])
		contiue;
	if (template[i] != task_subsys_state(task, i))
		break;
   }
   if (i == CGROUP_SUBSYS_COUNT)
	print task;
 --
   
4. f_pos++ until filling seq_buffer.


Thanks,
-Kame





