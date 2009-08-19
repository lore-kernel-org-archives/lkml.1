Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbZHSNB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbZHSNB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbZHSNBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:01:55 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54803 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbZHSNBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:01:55 -0400
Date: Wed, 19 Aug 2009 15:01:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-kernel@vger.kernel.org, zach.brown@oracle.com, hch@infradead.org
Subject: Re: [PATCH 0/4] Page based O_DIRECT v2
Message-ID: <20090819130156.GD12579@kernel.dk>
References: <1250584501-31140-1-git-send-email-jens.axboe@oracle.com> <4A8BF396.2060607@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8BF396.2060607@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19 2009, Boaz Harrosh wrote:
> On 08/18/2009 11:34 AM, Jens Axboe wrote:
> > Hi,
> > 
> > Updated patchset for page based O_DIRECT. I didn't include the
> > loop bits this time, lets focus on getting these core bits into
> > shape and then loop is easily patchable on top of this.
> > 
> > Changes since last post:
> > 
> > - Changed do_dio() to generic_file_direct_IO() as per Christophs
> >   suggestion.
> > - Split the first patch into two parts. One simply adds dio_args
> >   and maintains the current code, the next has the functional change
> >   but without changing file systems (except NFS).
> > - Add ->rw to dio_args (Christoph).
> > - A locking fixup. Not really related, but should be fixed up anyways.
> > 
> > There are at least two pending things to work on:
> > 
> > 1) NFS is still broken, I get a crash in freeing some data that
> >    is not related to the pages. Will debug this.
> > 2) As Christoph suggested, we need some way to wait for a dio
> >    when all segments are submitted. Currently it waits for each
> >    segment. Not sure how best to solve this issue, will think a
> >    bit more about this. Basically we need to pass down the wait
> >    list to the generic_file_direct_IO() and have that do the
> >    queue kick and wait.
> > 
> 
> Jens hi.
> 
> I please have some basic question on the subject?
> 
> [1]
> So before, the complete iovec from user mode could potentially be
> submitted in a single request, depending on the implementor.
> With new code, each iovec entry is broken to it's few pages and
> is submitted as a separate request. This might not be bad for
> block based devices that could see these segments merged back by the
> IO elevator. But what about the other implementers that see a
> grate performance boost in the current scatter-gather nature of the
> iovec API. It's almost as if the application was calling the kernel
> for each segment separately.
> 
> I wish you would use a more generic page carrier then page-* array.
> and submit the complete iovec at once.
> 
> We used to use scatter-lists but these are best only used inside DMA
> engines and Drivers as they are more then 2 times too big. The ideal for
> me is the bio_vec array as used inside a bio. scatter-list has all these
> helpers, iterators, and wrappers, which bio_vec do not, so I don't know
> what the best choice is.
> 
> But your current solution, (from inspection only I have not tested any of
> this), might mean a grate performance degradation for some work scenarios.
> For example a user-mode app the gathers lots of small memory sources and
> hopes to write it as a single very large on-the-wire-NFS-write , might find
> itself writing lots of small on-the-wire-NFS-writes.

I fully agree, see also the discussion with Christoph. One way would
indeed be to pass in an array of page map + offset, another would be to
pass something back to enable kicking + waiting on the IO. Haven't
looked in either direction yet, but I hope to do so Very Soon.

> [2]
> Please address linux-fsdevel on these patches. lkml is so crowded and after
> all these files do sit in fs/

Sure, will CC linux-fsdevel next time too.

-- 
Jens Axboe

