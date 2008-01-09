Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYAILBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYAILBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 06:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYAILBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 06:01:07 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:54862 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYAILBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 06:01:05 -0500
Date: Wed, 9 Jan 2008 06:00:45 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080109060045.1a0c4862@think.oraclecorp.com>
In-Reply-To: <20080109094320.GA6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk>
	<20080109093107.GA5023@infradead.org>
	<20080109094320.GA6258@kernel.dk>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 10:43:21 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Jan 09 2008, Christoph Hellwig wrote:
> > On Wed, Jan 09, 2008 at 09:52:32AM +0100, Jens Axboe wrote:
> > > - The file block mappings must not change while loop is using the
> > > file. This means that we have to ensure exclusive access to the
> > > file and this is the bit that is currently missing in the
> > > implementation. It would be nice if we could just do this via
> > > open(), ideas welcome...
> > 
> > And the way this is done is simply broken.  It means you have to get
> > rid of things like delayed or unwritten hands beforehand, it'll be
> > a complete pain for COW or non-block backed filesystems.
> 
> COW is not that hard to handle, you just need to be notified of moving
> blocks. If you view the patch as just a tighter integration between
> loop and fs, I don't think it's necessarily that broken.
> 
Filling holes (delayed allocation) and COW are definitely a problem.
But at least for the loop use case, most non-cow filesystems will want
to preallocate the space for loop file and be done with it.  Sparse
loop definitely has uses, but generally those users are willing to pay
a little performance.

Jens' patch falls back to buffered writes for the hole case and
pretends cow doesn't exist.  It's a good starting point that I hope to
extend with something like the extent_map apis.

> I did consider these cases, and it can be done with the existing
> approach.
> 
> > The right way to do this is to allow direct I/O from kernel sources
> > where the filesystem is in-charge of submitting the actual I/O after
> > the pages are handed to it.  I think Peter Zijlstra has been looking
> > into something like that for swap over nfs.
> 
> That does sound like a nice approach, but a lot more work. It'll
> behave differently too, the advantage of what I proposed is that it
> behaves like a real device.

The problem with O_DIRECT (or even O_SYNC) loop is that every write
into loop becomes synchronous, and it really changes the performance of
things like filemap_fdatawrite.

If we just hand ownership of the file over to loop entirely and prevent
other openers (perhaps even forcing backups through the loop device),
we get fewer corner cases and much better performance.

-chris
