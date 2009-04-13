Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbZDMJ7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbZDMJ7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 05:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbZDMJ73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 05:59:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55153 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841AbZDMJ72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 05:59:28 -0400
Date: Mon, 13 Apr 2009 10:59:25 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: How movable is zone movable?
Message-ID: <20090413095924.GA15333@csn.ul.ie>
References: <200904121129.09851.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200904121129.09851.edt@aei.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 12, 2009 at 11:29:09AM -0400, Ed Tomlinson wrote:
> Hi,
> 
> How dependable should zone movable be? 

It should be quite dependable for resizing the static hugepage pool,
particularly if you are willing to wait. However, with latest
libhugetlbfs, the hugeadm utility still has a --hard option incase you
need to wait a long time for the resize to occur.

> After a boot kvm is able to get enough hugepages to 
> back the session.  After a day or two it becomes a lot less predictable.  Sometimes it will swap out for 30 seconds
> and then succeed other times it will fail. 

Unfortunately, that sounds about right. If there is significant
fragmentation, it takes time to find out a contiguous area that can be
reclaimed. mlock() if it's a factor will complicate things further.

> Interestingly, it sometimes works if I cancel the kvm session after
> it tells me it cannot allocate the hugepages and immediatly restart.  It there some way to determine what
> is not respecting zone moveable? 

Ok, that is odd. Are base pages being mlocked()? If they are, they could be
the problem as the patches to move those pages around were never merged.

> Or is zone moveable just a suggestion and not expected to really be 
> moveable?
> 

They are expected to be movable, but pages that get locked do not get
moved at the moment.

> I have the following set in sysctl.conf
> 
> # huge_pages with movablecore set to 3G
> kernel.shmmax = 8589934592
> vm.nr_hugepages = 128
> vm.nr_overcommit_hugepages = 1408
> vm.hugepages_treat_as_movable = 1
> vm.hugetlb_shm_group = 1005

How big did you make the movable zone and what is the hugepage size? I'm
guessing the hugepage size is 2MB but no harm in being sure. If that's
the case, the movable zone should be at least 2816MB to maximise success
rates when resizing.

> 
> This is with any recient kernel release (2.6.28 and later)
> 

That's pretty recent. /proc/vmstat will also tell you how many
allocations are actually failing.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
