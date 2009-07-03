Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZGCCI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZGCCI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZGCCIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:08:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752350AbZGCCIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:08:48 -0400
Date: Thu, 2 Jul 2009 19:08:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Blum <bblum@google.com>
Cc: Paul Menage <menage@google.com>, lizf@cn.fujitzu.com, serue@us.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks"
 that  shows only unique tgids
Message-Id: <20090702190845.0cafc46a.akpm@linux-foundation.org>
In-Reply-To: <2f86c2480907021817o79fce75yd9785aab682f7bb4@mail.gmail.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	<20090702232620.3969.16680.stgit@menage.mtv.corp.google.com>
	<20090702164649.303c4952.akpm@linux-foundation.org>
	<2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
	<20090702175341.fd2e26d5.akpm@linux-foundation.org>
	<6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
	<2f86c2480907021817o79fce75yd9785aab682f7bb4@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009 18:17:56 -0700 Benjamin Blum <bblum@google.com> wrote:

> On Thu, Jul 2, 2009 at 6:08 PM, Paul Menage<menage@google.com> wrote:
> > On Thu, Jul 2, 2009 at 5:53 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> >>> In the first snippet, count will be at most equal to length. As length
> >>> is determined from cgroup_task_count, it can be no greater than the
> >>> total number of pids on the system.
> >>
> >> Well that's a problem, because there can be tens or hundreds of
> >> thousands of pids, and there's a fairly low maximum size for kmalloc()s
> >> (include/linux/kmalloc_sizes.h).
> >>
> >> And even if this allocation attempt doesn't exceed KMALLOC_MAX_SIZE,
> >> large allocations are less unreliable. __There is a large break point at
> >> 8*PAGE_SIZE (PAGE_ALLOC_COSTLY_ORDER).
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
> As it is currently, the kmalloc call will simply fail if there are too
> many pids, correct? Do we prefer not being able to read the file in
> this case, or would we rather use vmalloc?

We'd prefer that we not use vmalloc and that the reads not fail!



Why are we doing all this anyway?  To avoid presenting duplicated pids
to userspace?  Nothing else?

If so, why not stop doing that - userspace can remove dupes (if it
cares) more easily than the kernel can?


Or we can do it the other way?  Create an initially-empty local IDR
tree or radix tree and, within that, mark off any pids which we've
already emitted?  That'll have a worst-case memory consumption of
approximately PID_MAX_LIMIT bits -- presently that's half a megabyte. 
With no large allocations needed?


btw, did pidlist_uniq() actually needs to allocate new memory for the
output array?  Could it have done the filtering in-place?

