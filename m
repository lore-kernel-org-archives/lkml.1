Return-Path: <linux-kernel-owner+w=401wt.eu-S1763022AbXG0BPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763022AbXG0BPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 21:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759287AbXG0BPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 21:15:36 -0400
Received: from mail.suse.de ([195.135.220.2]:38311 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758431AbXG0BPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 21:15:35 -0400
Date: Fri, 27 Jul 2007 03:15:33 +0200
From: Nick Piggin <npiggin@suse.de>
To: Chris Mason <chris.mason@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC] extent mapped page cache
Message-ID: <20070727011533.GA13939@wotan.suse.de>
References: <20070724160032.7a7097db@think.oraclecorp.com> <1185307985.6586.50.camel@localhost> <1185312343.5535.5.camel@lappy> <20070724192509.5bc9b3fe@think.oraclecorp.com> <20070725023217.GA32076@wotan.suse.de> <20070725081853.4b325e7f@think.oraclecorp.com> <20070726013728.GB20727@wotan.suse.de> <20070725221007.0edcc2dc@think.oraclecorp.com> <20070726023639.GD20727@wotan.suse.de> <20070726090515.5fd198d1@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726090515.5fd198d1@think.oraclecorp.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 09:05:15AM -0400, Chris Mason wrote:
> On Thu, 26 Jul 2007 04:36:39 +0200
> Nick Piggin <npiggin@suse.de> wrote:
> 
> [ are state trees a good idea? ]
> 
> > > One thing it gains us is finding the start of the cluster.  Even if
> > > called by kswapd, the state tree allows writepage to find the start
> > > of the cluster and send down a big bio (provided I implement
> > > trylock to avoid various deadlocks).
> > 
> > That's very true, we could potentially also do that with the block
> > extent tree that I want to try with fsblock.
> 
> If fsblock records and extent of 200MB, and writepage is called on a
> page in the middle of the extent, how do you walk the radix backwards
> to find the first dirty & up to date page in the range?

I mean if we also have a block extent tree between fsblock and the
filesystem's get_block (which I think could be a good idea).

So you would use that tree to find the block extent that you're in,
then use the pagecache tree dirty tag lookup from the start of that
block extent (or you could add a backward tag lookup if you just wanted
to gather a small range around the given offset). I think (haven't got
any code for this yet, mind you).


> > > I put the placeholder patches on hold because handling a corner case
> > > where userland did O_DIRECT from a mmap'd region of the same file
> > > (Linus pointed it out to me).  Basically my patches had to work in
> > > 64k chunks to avoid a deadlock in get_user_pages.  With the state
> > > tree, I can allow the page to be faulted in but still properly deal
> > > with it.
> > 
> > Oh right, I didn't think of that one. Would you still have similar
> > issues with the external state tree? I mean, the filesystem doesn't
> > really know why the fault is taken. O_DIRECT read from a file into
> > mmapped memory of the same block in the file is almost hopeless I
> > think.
> 
> Racing is fine as long as we don't deadlock or expose garbage from disk.

Hmm, OK you're probably right. I'll have to see how it looks.


> > > I'm sure we can find some river in Cambridge, winner gets to throw
> > > Axboe in.
> > 
> > Very noble of you to donate your colleage to such a worthy cause.
> 
> Jens is always interested in helping solve such debates.  It's a
> fantastic service he provides to the community.

;)
