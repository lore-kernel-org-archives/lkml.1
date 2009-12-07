Return-Path: <linux-kernel-owner+w=401wt.eu-S935238AbZLGPJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935238AbZLGPJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935190AbZLGPJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:09:06 -0500
Received: from gir.skynet.ie ([193.1.99.77]:60322 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935186AbZLGPJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:09:05 -0500
Date: Mon, 7 Dec 2009 15:09:06 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: arayananu Gopalakrishnan <narayanan.g@samsung.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
	due to "e084b - page-allocator: preserve PFN ordering when
	__GFP_COLD is set"
Message-ID: <20091207150906.GC14743@csn.ul.ie>
References: <4B1D13B5.9020802@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4B1D13B5.9020802@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 03:39:49PM +0100, Christian Ehrhardt wrote:
> Hi,
> I tracked a huge performance regression for a while and got it bisected  
> down to commit "e084b2d95e48b31aa45f9c49ffc6cdae8bdb21d4 -  
> page-allocator: preserve PFN ordering when __GFP_COLD is set".
>

Darn. That is related to IO controllers being able to automatically merge
requests. The problem it was fixing was that pages were arriving in reverse
PFN order, the controller was unable to merge and performance was impaired. Any
controller that can merge should be faster as a result of the patch.

> The scenario I'm running is a low memory system (256M total), that does  
> sequential I/O with parallel iozone processes.
> One process per disk, each process reading a 2Gb file. The disks I use  
> are fcp scsi disks attached to a s390 host. File system is ext2.
>

I don't know what controller is in use there but does it
opportunistically merge requests if they are on physically contiguous
pages? If so, can it be disabled?

> The regression appears as up to 76% loss in throughput at 16 processes  
> (processes are scaled from 1 to 64, performance is bad everywhere - 16  
> is just the peak - avg loss is about 40% throughput).
> I already know that giving the system just a bit (~64m+) more memory  
> solves the issue almost completely, probably because there is almost no  
> "memory pressure" left in that cases.
> I also know that using direct-I/O instead of I/O through page cache  
> doesn't have the problem at all.

This makes sense because it's a sequentual read load, so readahead is a
factor and that is why __GFP_COLD is used - the data is not for
immediate use so doesn't need to be cache hot.

> Comparing sysstat data taken while running with the kernels just with &  
> without the bisected patch shows nothing obvious except that I/O seems  
> to take much longer (lower interrupt ratio etc).
>

Maybe the controller is spending an age trying to merge requests because
it should be able to but takes a long time figuring it out?

> The patch alone looks very reasonable, so I'd prefer understanding and  
> fixing the real issue instead of getting it eventually reverted due to  
> this regression being larger than the one it was intended to fix.
> In the patch it is clear that hot pages (cold==0) freed in rmqueue_bulk  
> should behave like before. So maybe the question is "are our pages cold  
> while they shouldn't be"?
> Well I don't really have a clue yet to explain how patch e084b exactly  
> causes that big regression, ideas welcome :-)
>

Only theory I have at the moment is that the controller notices it can
merge requests and either spends a long time figuring out how to do the
merging or performs worse with merged IO requests.

If the problem is in the driver, oprofile might show where the problem lies.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
