Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbXF0Fc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbXF0Fc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 01:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbXF0Fcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 01:32:51 -0400
Received: from ns2.suse.de ([195.135.220.15]:42869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbXF0Fcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 01:32:50 -0400
Date: Wed, 27 Jun 2007 07:32:45 +0200
From: Nick Piggin <npiggin@suse.de>
To: Chris Mason <chris.mason@oracle.com>
Cc: David Chinner <dgc@sgi.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] fsblock
Message-ID: <20070627053245.GA6033@wotan.suse.de>
References: <20070624014528.GA17609@wotan.suse.de> <20070626030640.GM989688@sgi.com> <46808E1F.1000509@yahoo.com.au> <20070626092309.GF31489@sgi.com> <20070626123449.GM14224@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626123449.GM14224@think.oraclecorp.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 08:34:49AM -0400, Chris Mason wrote:
> On Tue, Jun 26, 2007 at 07:23:09PM +1000, David Chinner wrote:
> > On Tue, Jun 26, 2007 at 01:55:11PM +1000, Nick Piggin wrote:
> 
> [ ... fsblocks vs extent range mapping ]
> 
> > iomaps can double as range locks simply because iomaps are
> > expressions of ranges within the file.  Seeing as you can only
> > access a given range exclusively to modify it, inserting an empty
> > mapping into the tree as a range lock gives an effective method of
> > allowing safe parallel reads, writes and allocation into the file.
> > 
> > The fsblocks and the vm page cache interface cannot be used to
> > facilitate this because a radix tree is the wrong type of tree to
> > store this information in. A sparse, range based tree (e.g. btree)
> > is the right way to do this and it matches very well with
> > a range based API.
> 
> I'm really not against the extent based page cache idea, but I kind of
> assumed it would be too big a change for this kind of generic setup.  At
> any rate, if we'd like to do it, it may be best to ditch the idea of
> "attach mapping information to a page", and switch to "lookup mapping
> information and range locking for a page".

Well the get_block equivalent API is extent based one now, and I'll
look at what is required in making map_fsblock a more generic call
that could be used for an extent-based scheme.

An extent based thing IMO really isn't appropriate as the main generic
layer here though. If it is really useful and popular, then it could
be turned into generic code and sit along side fsblock or underneath
fsblock...

It definitely isn't trivial to drive the IO directly from something
like that which doesn't correspond to filesystem block size. Splitting
parts of your extent tree when things go dirty or uptodate or partially
under IO, etc.. joining things back up again when they are mergable.
Not that it would be impossible, but it would be a lot more heavyweight
than fsblock.

I think using fsblock to drive the IO and keep the pagecache flags
uptodate and using a btree in the filesystem to manage extents of block
allocations wouldn't be a bad idea though. Do any filesystems actually
do this?
