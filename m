Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbXFNWuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbXFNWuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbXFNWtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:49:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51448 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756385AbXFNWtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:49:45 -0400
Date: Thu, 14 Jun 2007 15:49:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
 Blocksize support
Message-Id: <20070614154939.c94b097f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706141517120.2240@schroedinger.engr.sgi.com>
References: <20070614193839.878721298@sgi.com>
	<20070614130645.cabdff1b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
	<20070614143248.736312f8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141436030.1797@schroedinger.engr.sgi.com>
	<20070614150417.c73fb6b9.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141517120.2240@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 14 Jun 2007 15:22:46 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> On Thu, 14 Jun 2007, Andrew Morton wrote:
> 
> > With 64k pagesize the amount of memory required to hold a kernel tree (say)
> > will go from 270MB to 1400MB.   This is not an optimisation.
> 
> I do not think that the 100% users will do kernel compiles all day like 
> we do. We likely would prefer 4k page size for our small text files.

There are many, many applications which use small files.

> > Several 64k pagesize people have already spent time looking at various
> > tail-packing schemes to get around this serious problem.  And that's on
> > _server_ class machines.  Large ones.  I don't think
> > laptop/desktop/samll-server machines would want to go anywhere near this.
> 
> I never understood the point of that exercise. If you have variable page 
> size then the 64k page size can be used specific to files that benefit 
> from it. Typically usage scenarios are video audio streaming I/O, large 
> picture files, large documents with embedded images. These are the major
> usage scenarioes today and we suck the. Our DVD/CD subsystems are 
> currently not capable of directly reading from these devices into the page 
> cache since they do not do I/O in 4k chunks.

So with sufficient magical kernel heuristics or operator intervention, some
people will gain some benefit from 64k pagesize.  Most people with most
workloads will remain where they are: shoving zillions of physically
discontiguous pages into fixed-size sg lists.

Whereas with contig-pagecache, all users on all machines with all workloads
will benefit from the improved merging.

> > > fsck times etc etc are becoming an issue for desktop 
> > > systems
> > 
> > I don't see what fsck has to do with it.
> > 
> > fsck is single-threaded (hence no locking issues) and operates against the
> > blockdev pagecache and does a _lot_ of small reads (indirect blocks,
> > especially).  If the memory consumption for each 4k read jumps to 64k, fsck
> > is likely to slow down due to performing a lot more additional IO and due
> > to entering page reclaim much earlier.
> 
> Every 64k block contains more information and the number of pages managed
> is reduced by a factor of 16. Less seeks , less tlb pressure , less reads, 
> more cpu cache and cpu cache prefetch friendly behavior.

argh.  Everything you say is just wrong.  A fsck involves zillions of
discontiguous small reads.  It is largely seek-bound, so there is no
benefit to be had here.  Your proposed change will introduce regressions by
causing larger amounts of physical reading and large amounts of memory
consumption.


