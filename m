Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYAJMzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYAJMzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYAJMy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:54:58 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:38619 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbYAJMy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:54:56 -0500
Date: Thu, 10 Jan 2008 07:53:59 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080110075359.18622548@think.oraclecorp.com>
In-Reply-To: <20080110085459.GA11966@infradead.org>
References: <20080109085231.GE6650@kernel.dk>
	<200801101242.25671.nickpiggin@yahoo.com.au>
	<20080110083753.GB10745@infradead.org>
	<20080110084457.GT6258@kernel.dk>
	<20080110085459.GA11966@infradead.org>
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

On Thu, 10 Jan 2008 08:54:59 +0000
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Jan 10, 2008 at 09:44:57AM +0100, Jens Axboe wrote:
> > > IMHO this shouldn't be done in the loop driver anyway.
> > > Filesystems have their own effricient extent lookup trees (well,
> > > at least xfs and btrfs do), and we should leverage that instead
> > > of reinventing it.
> > 
> > Completely agree, it's just needed right now for this solution
> > since all we have is a crappy bmap() interface to get at those
> > mappings.
> 
> So let's fix the interface instead of piling crap ontop of it.  As I
> said I think Peter has something to start with so let's beat on it
> until we have something suitable.   If we aren't done by end of Feb
> I'm happy to host a hackfest to get it sorted around the fs/storage
> summit..
> 

Ok, I've been meaning to break my extent_map code up, and this is a
very good reason.  I'll work up a sample today based on Jens' code.

The basic goals:

* Loop (swap) calls into the FS for each mapping. Any caching happens
on the FS side.
* The FS returns an extent, filling any holes

Swap would need to use an extra call early on for preallocation.

Step two is having a call back into the FS allow the FS to delay the
bios until commit completion so that COW and delalloc blocks can be
fully on disk when the bios are reported as done.  Jens, can you add
some way to queue the bio completions up?

-chris
