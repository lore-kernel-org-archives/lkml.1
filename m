Return-Path: <linux-kernel-owner+w=401wt.eu-S1030362AbXCFWBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030362AbXCFWBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 17:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030352AbXCFWBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 17:01:48 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:58351 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030317AbXCFWBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 17:01:45 -0500
To: a.p.zijlstra@chello.nl
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, staubach@redhat.com, hugh@veritas.com
In-reply-to: <1173217621.4718.27.camel@lappy> (message from Peter Zijlstra on
	Tue, 06 Mar 2007 22:47:01 +0100)
Subject: Re: [patch 2/8] update ctime and mtime for mmaped write
References: <20070306180443.669036741@szeredi.hu>
	 <20070306180549.312408559@szeredi.hu> <1173213151.4718.16.camel@lappy>
	 <E1HOh8r-0006Sp-00@dorka.pomaz.szeredi.hu> <1173217621.4718.27.camel@lappy>
Message-Id: <E1HOhhp-0006YZ-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 06 Mar 2007 23:00:25 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I can understand you wanting to avoid the overhead of the minor faults
> > > resulting from using page_mkclean(), but I'm not sure its worth it.
> > 
> > It would be nice if the cost of MS_ASYNC wouldn't be too high.  And I
> > do have the feeling that minor faults are far more expensive than
> > cleaning the dirty bit in the ptes.
> > 
> > Do you have any numbers?
> 
> None what so ever, but I always think of msync as a rare function
> (infrequent when compared to (minor) faults overall). But I don't have
> numbers backing that up either.

It depends entirely on the usage pattern.  I can imagine this sort of
use:

  mmap
  write lots of data to memory
  msync(MS_ASYNC)
  overwrite previous data
  msync(MS_ASYNC)
  ...

In this case write protecting and faulting the pages will be slower,
than just checking the page tables.

> Also, the radix tree scan you do isn't exactly cheap either. 
> 
> So what I was wondering is whether its worth optimizing this at the cost
> of another rmap walker. (one with very dubious semantics at that - it
> clears the pte dirty bit but doesn't particularly care about that nor
> does it respect the PG_dirty / PTE dirty relation)

I don't think this is dubious.  The pte dirty bit in this case means,
that the page was modified _since_the_last_call_ of this function.

The PG_dirty on the other hand means, that the page will need to be
written back.  So they have completely different meanings.

Thanks,
Miklos
