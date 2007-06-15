Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbXFOBlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbXFOBlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbXFOBk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:40:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52737 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338AbXFOBkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:40:55 -0400
Date: Thu, 14 Jun 2007 18:40:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
 Blocksize support
Message-Id: <20070614184013.1ff51d34.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706141742580.3220@schroedinger.engr.sgi.com>
References: <20070614193839.878721298@sgi.com>
	<20070614130645.cabdff1b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
	<20070614143248.736312f8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141436030.1797@schroedinger.engr.sgi.com>
	<20070614150417.c73fb6b9.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141517120.2240@schroedinger.engr.sgi.com>
	<20070614154939.c94b097f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141742580.3220@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007 17:45:43 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Thu, 14 Jun 2007, Andrew Morton wrote:
> 
> > > I do not think that the 100% users will do kernel compiles all day like 
> > > we do. We likely would prefer 4k page size for our small text files.
> > 
> > There are many, many applications which use small files.
> 
> There is no problem with them using 4k page size concurrently to a higher 
> page size for other files.

There will be files which should use 64k but which instead end up using 4k.

There will be files which should use 4k but which instead end up using 64k.

Because determining which size to use requires either operator intervention
or kernel heuristics, both of which will be highly unreliable.

It's better to just make 4k pages go faster.

> > > I never understood the point of that exercise. If you have variable page 
> > > size then the 64k page size can be used specific to files that benefit 
> > > from it. Typically usage scenarios are video audio streaming I/O, large 
> > > picture files, large documents with embedded images. These are the major
> > > usage scenarioes today and we suck the. Our DVD/CD subsystems are 
> > > currently not capable of directly reading from these devices into the page 
> > > cache since they do not do I/O in 4k chunks.
> > 
> > So with sufficient magical kernel heuristics or operator intervention, some
> > people will gain some benefit from 64k pagesize.  Most people with most
> > workloads will remain where they are: shoving zillions of physically
> > discontiguous pages into fixed-size sg lists.
> 
> Magical? There is nothing magical about doing transfers in the size that 
> is supported by a device. That is good sense.

By magical heuristics I'm referring to the (required) tricks and guesses
which the kernel will need to deploy to be able to guess which page-size it
should use for each file.

Because without such heuristics, none of this new stuff which you're
proposing would ever get used by 90% of apps on 90% of machines.

> > > Every 64k block contains more information and the number of pages managed
> > > is reduced by a factor of 16. Less seeks , less tlb pressure , less reads, 
> > > more cpu cache and cpu cache prefetch friendly behavior.
> > 
> > argh.  Everything you say is just wrong.  A fsck involves zillions of
> > discontiguous small reads.  It is largely seek-bound, so there is no
> > benefit to be had here.  Your proposed change will introduce regressions by
> > causing larger amounts of physical reading and large amounts of memory
> > consumption.
> 
> Of course there is. The seeks are reduced since there are an factor 
> of 16 less metadata blocks. fsck does not read files. It just reads 
> metadata structures. And the larger contiguous areas the faster.

Some metadata is contiguous: inode tables, some directories (if they got
lucky), bitmap tables.  But fsck surely reads them in a single swoop
anyway, so there's no gain there.

Other metadata (indirect blocks) are 100% discontiguous, and reading those
with a 64k IO into 64k of memory is completely dumb.

And yes, I'm referring to the 90% case again.  The one we want to
optimise for.



