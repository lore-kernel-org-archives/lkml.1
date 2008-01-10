Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbYAJNrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbYAJNrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 08:47:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbYAJNqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 08:46:52 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:64672 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbYAJNqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 08:46:51 -0500
Date: Thu, 10 Jan 2008 08:46:18 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080110084618.6ca457f8@think.oraclecorp.com>
In-Reply-To: <20080110130324.GZ6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk>
	<200801101242.25671.nickpiggin@yahoo.com.au>
	<20080110083753.GB10745@infradead.org>
	<20080110084457.GT6258@kernel.dk>
	<20080110085459.GA11966@infradead.org>
	<20080110075359.18622548@think.oraclecorp.com>
	<20080110130324.GZ6258@kernel.dk>
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

On Thu, 10 Jan 2008 14:03:24 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Jan 10 2008, Chris Mason wrote:
> > On Thu, 10 Jan 2008 08:54:59 +0000
> > Christoph Hellwig <hch@infradead.org> wrote:
> > 
> > > On Thu, Jan 10, 2008 at 09:44:57AM +0100, Jens Axboe wrote:
> > > > > IMHO this shouldn't be done in the loop driver anyway.
> > > > > Filesystems have their own effricient extent lookup trees
> > > > > (well, at least xfs and btrfs do), and we should leverage
> > > > > that instead of reinventing it.
> > > > 
> > > > Completely agree, it's just needed right now for this solution
> > > > since all we have is a crappy bmap() interface to get at those
> > > > mappings.
> > > 
> > > So let's fix the interface instead of piling crap ontop of it.
> > > As I said I think Peter has something to start with so let's beat
> > > on it until we have something suitable.   If we aren't done by
> > > end of Feb I'm happy to host a hackfest to get it sorted around
> > > the fs/storage summit..
> > > 
> > 
> > Ok, I've been meaning to break my extent_map code up, and this is a
> > very good reason.  I'll work up a sample today based on Jens' code.
> 
> Great!

Grin, we'll see how the sample looks.

> 
> > The basic goals:
> > 
> > * Loop (swap) calls into the FS for each mapping. Any caching
> > happens on the FS side.
> > * The FS returns an extent, filling any holes
> 
> We don't want to fill holes for a read, but I guess that's a given?

Right.

> 
> > Swap would need to use an extra call early on for preallocation.
> > 
> > Step two is having a call back into the FS allow the FS to delay the
> > bios until commit completion so that COW and delalloc blocks can be
> > fully on disk when the bios are reported as done.  Jens, can you add
> > some way to queue the bio completions up?
> 
> Sure, a function to save a completed bio and a function to execute
> completions on those already stored?
> 

Sounds right, I'm mostly looking for a way to aggregate a few writes to
make the commits a little larger.

-chris
