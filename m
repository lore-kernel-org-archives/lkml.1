Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbZDODo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbZDODo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZDODoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:44:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39575 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZDODoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:44:18 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] readahead: introduce context readahead algorithm
References: <20090412071950.166891982@intel.com>
	<20090412072052.686760755@intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 14 Apr 2009 23:43:32 -0400
In-Reply-To: <20090412072052.686760755@intel.com> (Wu Fengguang's message of
	"Sun, 12 Apr 2009 15:19:53 +0800")
Message-ID: <x49k55mintn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang <fengguang.wu@intel.com> writes:

> Introduce page cache context based readahead algorithm.
> This is to better support concurrent read streams in general.
>
> RATIONALE
> ---------
> The current readahead algorithm detects interleaved reads in a _passive_ way.
> Given a sequence of interleaved streams 1,1001,2,1002,3,4,1003,5,1004,1005,6,...
> By checking for (offset == prev_offset + 1), it will discover the sequentialness
> between 3,4 and between 1004,1005, and start doing sequential readahead for the
> individual streams since page 4 and page 1005.
>
> The context readahead algorithm guarantees to discover the sequentialness no
> matter how the streams are interleaved. For the above example, it will start
> sequential readahead since page 2 and 1002.
>
> The trick is to poke for page @offset-1 in the page cache when it has no other
> clues on the sequentialness of request @offset: if the current requenst belongs
> to a sequential stream, that stream must have accessed page @offset-1 recently,
> and the page will still be cached now. So if page @offset-1 is there, we can
> take request @offset as a sequential access.
>
> BENEFICIARIES
> -------------
> - strictly interleaved reads  i.e. 1,1001,2,1002,3,1003,...
>   the current readahead will take them as silly random reads;
>   the context readahead will take them as two sequential streams.
>
> - cooperative IO processes   i.e. NFS and SCST
>   They create a thread pool, farming off (sequential) IO requests to different
>   threads which will be performing interleaved IO.
>
>   It was not easy(or possible) to reliably tell from file->f_ra all those
>   cooperative processes working on the same sequential stream, since they will
>   have different file->f_ra instances. And NFSD's file->f_ra is particularly
>   unusable, since their file objects are dynamically created for each request.
>   The nfsd does have code trying to restore the f_ra bits, but not satisfactory.

Hi, Wu,

I tested out your patches.  Below are some basic iozone numbers for a
single NFS client reading a file.  The iozone command line is:

  iozone -s 2000000 -r 64 -f /mnt/test/testfile -i 1 -w

The file system is unmounted after each run to flush the cache.  The
numbers below reflect only a single run each.  The file system was also
unmounted on the NFS client after each run.

KEY
---
vanilla:	   2.6.30-rc1
readahead:	   2.6.30-rc1 + your 10 readahead patches
context readahead: 2.6.30-rc1 + your 10 readahead patches + the 3
		   context readahead patches.
nfsd's:		   number of NFSD threads on the server

I'll note that the cfq in 2.6.30-rc1 is crippled, and that Jens has a
patch posted that makes the numbers look at least a little better, but
that's immaterial to this discussion, I think.

                vanilla

nfsd's  |   1   |   2   |   4   |   8
--------+---------------+-------+------
cfq     | 43127 | 22354 | 20858 | 21179
deadline| 43732 | 68059 | 76659 | 83231

                readahead

nfsd's  |   1   |   2   |   4   |   8
--------+---------------+-------+------
cfq     | 42471 | 21913 | 21252 | 20979
deadline| 42801 | 70158 | 82068 | 82406

           context readahead

nfsd's  |   1   |   2   |   4   |   8
--------+---------------+-------+------
cfq     | 42827 | 21882 | 20678 | 21508
deadline| 43040 | 71173 | 82407 | 86583

Cheers,
Jeff
