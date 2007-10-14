Return-Path: <linux-kernel-owner+w=401wt.eu-S1764268AbXJNXeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764268AbXJNXeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 19:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758349AbXJNXeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 19:34:01 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33605 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754218AbXJNXeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 19:34:00 -0400
Date: Mon, 15 Oct 2007 09:33:40 +1000
From: David Chinner <dgc@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten =?iso-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com, nickpiggin@yahoo.com.au
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071014233340.GQ23367404@sgi.com>
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com> <4712A254.4090604@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4712A254.4090604@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 04:12:20PM -0700, Jeremy Fitzhardinge wrote:
> David Chinner wrote:
> > You mean xfs_buf.c.
> >   
> 
> Yes, sorry.
> 
> > And yes, we delay unmapping pages until we have a batch of them
> > to unmap. vmap and vunmap do not scale, so this is batching helps
> > alleviate some of the worst of the problems.
> >   
> 
> How much performance does it cost?

Every vunmap() cal causes a global TLB sync, and the region lists
are globl with a spin lock protecting them. I thin kNick has shown
a 64p altix with ~60 cpus spinning on the vmap locks under a
simple workload....

> What kind of workloads would it show
> up under?

A directory traversal when using large directory block sizes
with large directories....


> > Realistically, if this delayed release of vmaps is a problem for
> > Xen, then I think that some generic VM solution is needed to this
> > problem as vmap() is likely to become more common in future (think
> > large blocks in filesystems). Nick - any comments?
> >   
> 
> Well, the only real problem is that the pages are returned to the free
> pool and reallocated while still being part of a mapping.  If the pages
> are still owned by the filesystem/pagecache, then there's no problem.

The pages are still attached to the blockdev address space mapping,
but there's nothing stopping them from being reclaimed before they are
unmapped.

> What's the lifetime of things being vmapped/unmapped in xfs?  Are they
> necessarily being freed when they're unmapped, or could unmapping of
> freed memory be more immediate than other memory?

It's all "freed memory". At the time we pull the buffer down, there are
no further references to the buffer. the pages are released and the mapping
is never used again until it is torn down. it is torn down either on the
next xfsbufd run (either memory pressure or every 15s) or every 64th
new vmap() call to map new buffers.

> Maybe it just needs a notifier chain or something.

We've already got a memroy shrinker hook that triggers this reclaim.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
