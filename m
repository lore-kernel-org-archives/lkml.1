Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbZDOEnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbZDOEnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 00:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZDOEn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 00:43:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:44883 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbZDOEn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 00:43:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,190,1239001200"; 
   d="scan'208";a="131578711"
Date: Wed, 15 Apr 2009 12:43:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] readahead: introduce context readahead algorithm
Message-ID: <20090415044301.GB9948@localhost>
References: <20090412071950.166891982@intel.com> <20090412072052.686760755@intel.com> <x49k55mintn.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49k55mintn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 11:43:32AM +0800, Jeff Moyer wrote:
> Wu Fengguang <fengguang.wu@intel.com> writes:
> 
> > Introduce page cache context based readahead algorithm.
> > This is to better support concurrent read streams in general.
> >
> > RATIONALE
> > ---------
> > The current readahead algorithm detects interleaved reads in a _passive_ way.
> > Given a sequence of interleaved streams 1,1001,2,1002,3,4,1003,5,1004,1005,6,...
> > By checking for (offset == prev_offset + 1), it will discover the sequentialness
> > between 3,4 and between 1004,1005, and start doing sequential readahead for the
> > individual streams since page 4 and page 1005.
> >
> > The context readahead algorithm guarantees to discover the sequentialness no
> > matter how the streams are interleaved. For the above example, it will start
> > sequential readahead since page 2 and 1002.
> >
> > The trick is to poke for page @offset-1 in the page cache when it has no other
> > clues on the sequentialness of request @offset: if the current requenst belongs
> > to a sequential stream, that stream must have accessed page @offset-1 recently,
> > and the page will still be cached now. So if page @offset-1 is there, we can
> > take request @offset as a sequential access.
> >
> > BENEFICIARIES
> > -------------
> > - strictly interleaved reads  i.e. 1,1001,2,1002,3,1003,...
> >   the current readahead will take them as silly random reads;
> >   the context readahead will take them as two sequential streams.
> >
> > - cooperative IO processes   i.e. NFS and SCST
> >   They create a thread pool, farming off (sequential) IO requests to different
> >   threads which will be performing interleaved IO.
> >
> >   It was not easy(or possible) to reliably tell from file->f_ra all those
> >   cooperative processes working on the same sequential stream, since they will
> >   have different file->f_ra instances. And NFSD's file->f_ra is particularly
> >   unusable, since their file objects are dynamically created for each request.
> >   The nfsd does have code trying to restore the f_ra bits, but not satisfactory.
> 
> Hi, Wu,
> 
> I tested out your patches.  Below are some basic iozone numbers for a
> single NFS client reading a file.  The iozone command line is:
> 
>   iozone -s 2000000 -r 64 -f /mnt/test/testfile -i 1 -w

Jeff, thank you very much for the testing out!

> The file system is unmounted after each run to flush the cache.  The
> numbers below reflect only a single run each.  The file system was also
> unmounted on the NFS client after each run.
> 
> KEY
> ---
> vanilla:	   2.6.30-rc1
> readahead:	   2.6.30-rc1 + your 10 readahead patches
> context readahead: 2.6.30-rc1 + your 10 readahead patches + the 3
> 		   context readahead patches.
> nfsd's:		   number of NFSD threads on the server

I guess you are applying the readahead patches to the server side?

What's the NFS mount options and client/server side readahead size?
The context readahead is pretty sensible to these parameters.

> I'll note that the cfq in 2.6.30-rc1 is crippled, and that Jens has a
> patch posted that makes the numbers look at least a little better, but
> that's immaterial to this discussion, I think.
> 
>                 vanilla
> 
> nfsd's  |   1   |   2   |   4   |   8
> --------+---------------+-------+------
> cfq     | 43127 | 22354 | 20858 | 21179
> deadline| 43732 | 68059 | 76659 | 83231
> 
>                 readahead
> 
> nfsd's  |   1   |   2   |   4   |   8
> --------+---------------+-------+------
> cfq     | 42471 | 21913 | 21252 | 20979
> deadline| 42801 | 70158 | 82068 | 82406
> 
>            context readahead
> 
> nfsd's  |   1   |   2   |   4   |   8
> --------+---------------+-------+------
> cfq     | 42827 | 21882 | 20678 | 21508
> deadline| 43040 | 71173 | 82407 | 86583

Let me transform them into relative numbers:

             A     B     C      A..B      A..C         
cfq-1      43127 42471 42827    -1.5%     -0.7%         
cfq-2      22354 21913 21882    -2.0%     -2.1%         
cfq-4      20858 21252 20678    +1.9%     -0.9%         
cfq-8      21179 20979 21508    -0.9%     +1.6%         
           
deadline-1 43732 42801 43040    -2.1%     -1.6%         
deadline-2 68059 70158 71173    +3.1%     +4.6%         
deadline-4 76659 82068 82407    +7.1%     +7.5%         
deadline-8 83231 82406 86583    -1.0%     +4.0%         

Summaries:
1) the overall numbers are slightly negative for CFQ and looks better
   with deadline.

Anyway we have the io context problem for CFQ.  And I'm planning to
dive into the CFQ code and your patch on that :-)

2) the single thread case performance consistently dropped by 1-2%.

It seems not related to the behavior changes introduced by the mmap
readahead patches and context readahead patches. And looks more like
some overheads created by the code reorganization and the patch
"readahead: apply max_sane_readahead() limit in ondemand_readahead()"
which adds a bit overhead with the call max_sane_readahead().

I'll try to root cause it.

Thanks again for the numbers!

Regards,
Fengguang
