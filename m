Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbZGCGzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbZGCGzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZGCGzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:55:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbZGCGzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:55:31 -0400
Date: Thu, 2 Jul 2009 23:55:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Menage <menage@google.com>
Cc: Benjamin Blum <bblum@google.com>, lizf@cn.fujitzu.com, serue@us.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks"
 that  shows only unique tgids
Message-Id: <20090702235527.7ddc873c.akpm@linux-foundation.org>
In-Reply-To: <6599ad830907022116n7a711c7fs52ff9b400ec8797f@mail.gmail.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	<20090702232620.3969.16680.stgit@menage.mtv.corp.google.com>
	<20090702164649.303c4952.akpm@linux-foundation.org>
	<2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
	<20090702175341.fd2e26d5.akpm@linux-foundation.org>
	<6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
	<2f86c2480907021817o79fce75yd9785aab682f7bb4@mail.gmail.com>
	<20090702190845.0cafc46a.akpm@linux-foundation.org>
	<6599ad830907022116n7a711c7fs52ff9b400ec8797f@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009 21:16:15 -0700 Paul Menage <menage@google.com> wrote:

> On Thu, Jul 2, 2009 at 7:08 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
> >
> > Why are we doing all this anyway? __To avoid presenting duplicated pids
> > to userspace? __Nothing else?
> 
> To present the pids or tgids in sorted order. Removing duplicates is
> only for the case of the "procs" file; that could certainly be left to
> userspace, but it wouldn't by itself remove the existing requirement
> for a contiguous array.
> 
> The seq_file iterator for these files relies on them being sorted so
> that it can pick up where it left off even in the event of the pid set
> changing between reads - it does a binary search to find the first pid
> greater than the last one that was returned, so as to guarantee that
> we return every pid that was in the cgroup before the scan started and
> remained in the cgroup until after the scan finished; there are no
> guarantees about pids that enter/leave the cgroup during the scan.

OIC.  Gee we made it hard for ourselves.  That tears it.

> > Or we can do it the other way? __Create an initially-empty local IDR
> > tree or radix tree and, within that, mark off any pids which we've
> > already emitted? __That'll have a worst-case memory consumption of
> > approximately PID_MAX_LIMIT bits -- presently that's half a megabyte.
> > With no large allocations needed?
> >
> 
> But that would be half a megabyte per open fd?

worst-case, assuming that there are 4,000,000/64 pids, spread evenly
across the pid space.

> That's a lot of memory
> that userspace can pin down by opening fds.

yup.

> The reason for the current
> pid array approach is to mean that there's only ever one pid array
> allocated at a time per cgroup, rather than per open fd.

Oh.  Didn't know that.  That would have been an interesting thing to
have documeted, but the sorry little comment which tried to explain
this got deleted by this patch :(

> There's actually a structure already for doing that - cgroup_scanner,
> which uses a high-watermark and a priority heap to provide a similar
> guarantee, with a constant memory size overhead (typically one page).
> But it can take O(n^2) time to scan a large cgroup, as would, I
> suspect, using an IDR, so it's only used for cases where we really
> can't avoid it due to locking reasons. I'd rather have something that
> accumulates unsorted pids in page-size chunks as we iterate through
> the cgroup, and then sorts them using something like Lai Jiangshan's
> patch did.

Was it a mistake to try to present an ordered, dupes-removed view of a
large amount of data from the kernel?
 
> >
> > btw, did pidlist_uniq() actually needs to allocate new memory for the
> > output array? __Could it have done the filtering in-place?
> 
> Yes - or just omit duplicates in the seq_file iterator, I guess

OK.


So now what?  lib/dynarray.c?
