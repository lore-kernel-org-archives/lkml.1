Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZDOR5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZDOR5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 13:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZDOR5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 13:57:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36248 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbZDOR5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 13:57:09 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] readahead: introduce context readahead algorithm
References: <20090412071950.166891982@intel.com>
	<20090412072052.686760755@intel.com>
	<x49k55mintn.fsf@segfault.boston.devel.redhat.com>
	<20090415044301.GB9948@localhost>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 15 Apr 2009 13:55:48 -0400
In-Reply-To: <20090415044301.GB9948@localhost> (Wu Fengguang's message of
	"Wed, 15 Apr 2009 12:43:01 +0800")
Message-ID: <x49r5ztg5sr.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Fengguang,

Wu Fengguang <fengguang.wu@intel.com> writes:

>> I tested out your patches.  Below are some basic iozone numbers for a
>> single NFS client reading a file.  The iozone command line is:
>> 
>>   iozone -s 2000000 -r 64 -f /mnt/test/testfile -i 1 -w
>
> Jeff, thank you very much for the testing out!
>
>> The file system is unmounted after each run to flush the cache.  The
>> numbers below reflect only a single run each.  The file system was also
>> unmounted on the NFS client after each run.
>> 
>> KEY
>> ---
>> vanilla:	   2.6.30-rc1
>> readahead:	   2.6.30-rc1 + your 10 readahead patches
>> context readahead: 2.6.30-rc1 + your 10 readahead patches + the 3
>> 		   context readahead patches.
>> nfsd's:		   number of NFSD threads on the server
>
> I guess you are applying the readahead patches to the server side?

That's right.

> What's the NFS mount options and client/server side readahead size?
> The context readahead is pretty sensible to these parameters.

Default options everywhere.

>> I'll note that the cfq in 2.6.30-rc1 is crippled, and that Jens has a
>> patch posted that makes the numbers look at least a little better, but
>> that's immaterial to this discussion, I think.
>> 
>>                 vanilla
>> 
>> nfsd's  |   1   |   2   |   4   |   8
>> --------+---------------+-------+------
>> cfq     | 43127 | 22354 | 20858 | 21179
>> deadline| 43732 | 68059 | 76659 | 83231
>> 
>>                 readahead
>> 
>> nfsd's  |   1   |   2   |   4   |   8
>> --------+---------------+-------+------
>> cfq     | 42471 | 21913 | 21252 | 20979
>> deadline| 42801 | 70158 | 82068 | 82406
>> 
>>            context readahead
>> 
>> nfsd's  |   1   |   2   |   4   |   8
>> --------+---------------+-------+------
>> cfq     | 42827 | 21882 | 20678 | 21508
>> deadline| 43040 | 71173 | 82407 | 86583
>
> Let me transform them into relative numbers:
>
>              A     B     C      A..B      A..C         
> cfq-1      43127 42471 42827    -1.5%     -0.7%         
> cfq-2      22354 21913 21882    -2.0%     -2.1%         
> cfq-4      20858 21252 20678    +1.9%     -0.9%         
> cfq-8      21179 20979 21508    -0.9%     +1.6%         
>            
> deadline-1 43732 42801 43040    -2.1%     -1.6%         
> deadline-2 68059 70158 71173    +3.1%     +4.6%         
> deadline-4 76659 82068 82407    +7.1%     +7.5%         
> deadline-8 83231 82406 86583    -1.0%     +4.0%         
>
> Summaries:
> 1) the overall numbers are slightly negative for CFQ and looks better
>    with deadline.

The variance is probably 1-2%.  I'll try to quantify that for you.

> Anyway we have the io context problem for CFQ.  And I'm planning to
> dive into the CFQ code and your patch on that :-)

Jens already reworked the patch and included it in his for-linus branch
of the block tree.  So, you can start there.  ;-)

> 2) the single thread case performance consistently dropped by 1-2%.

> It seems not related to the behavior changes introduced by the mmap
> readahead patches and context readahead patches. And looks more like
> some overheads created by the code reorganization and the patch
> "readahead: apply max_sane_readahead() limit in ondemand_readahead()"
> which adds a bit overhead with the call max_sane_readahead().
>
> I'll try to root cause it.
>
> Thanks again for the numbers!

No problem.

Cheers,
Jeff
