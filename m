Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbXJASGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbXJASGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXJASGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:06:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37782 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbXJASGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:06:40 -0400
Subject: Re: [PATCH 24/25] r/o bind mounts: track number of mount writers
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070924124233.9197d6b6.akpm@linux-foundation.org>
References: <20070920195249.852667D5@kernel>
	 <20070920195320.38C8E20D@kernel> <20070924175411.GA2314@infradead.org>
	 <1190662091.26982.246.camel@localhost>
	 <20070924124233.9197d6b6.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 11:06:37 -0700
Message-Id: <1191261997.6024.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 12:42 -0700, Andrew Morton wrote: 
> On Mon, 24 Sep 2007 12:28:11 -0700
> Dave Hansen <haveblue@us.ibm.com> wrote:
> > On Mon, 2007-09-24 at 18:54 +0100, Christoph Hellwig wrote:
> > > As we already say in various messages the percpu counters in here
> > > look rather fishy.  I'd recomment to take a look at the per-cpu
> > > superblock counters in XFS as they've been debugged quite well
> > > now and could probably be lifted into a generic library for this
> > > kind of think.  The code is mostly in fs/xfs/xfs_mount.c can
> > > can be spotted by beeing under #ifdef HAVE_PERCPU_SB.
> > > 
> > > It also handles cases like hotplug cpu nicely that this code
> > > seems to work around by always iterating over all possible cpus
> > > which might not be nice on a dual core laptop with a distro kernel
> > > that also has to support big iron.
> > 
> > I'll take a look at xfs to see what I can get out of it.
> 
> And at include/linux/percpu_counter.h, please.

The basic incompatibility with what that provides and what I need is
that percpu_counters allow some fuzziness in the numbers.  One cpu can
be summing the numbers up while another is still adding to the local
percpu counters.  That's fine for statistics, but horrible for questions
like, "can anybody write to and corrupt my FS right now?"

It could probably be modified to do what I want, but it would still have
a the "invented your own lock" problem, and would likely impact the
scalability of the existing "fuzzy" users.

We could introduce fuzzy and coherent variants of the function calls,
but that would probably introduce more code than what I have now for the
very specific mnt_writer_lock.

> > There are basically two times when you have to do this
> > for_each_possible_cpu() stuff:
> > 1. when doing a r/w->r/o transition, which is rare, and
> >    certainly not a fast path
> > 2. Where the per-cpu writer count underflows.  This requires
> >    a _minimum_ of 1<<16 file opens (configurable) each of which
> >    is closed on a different cpu than it was opened on.  Even
> >    if you were trying, I'm not sure you'd notice the overhead.
> > 
> 
> Sounds like what you're doing is more akin to the local_t-based module
> refcounting.  `grep local_ kernel/module.c'.
> 
> That code should be converted from NR_CPUS to for_each_possible_cpu()..

I think that can get converted to use the percpu_counters pretty easily.
I've coded that up, and sent it [RFC] to lkml.  Rusty will forward on
into mainline.

-- Dave

