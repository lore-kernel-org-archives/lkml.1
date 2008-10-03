Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbYJCNvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbYJCNvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 09:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYJCNvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 09:51:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbYJCNvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 09:51:44 -0400
Date: Fri, 3 Oct 2008 09:50:17 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH] Memory management livelock
In-Reply-To: <200810032231.03985.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0810030941480.27239@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <200810031254.29121.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0810030716310.4875@hs20-bc2-1.build.redhat.com>
 <200810032231.03985.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > LVM does (that is where the bug was discovered). Basically, it scans all
> > the block devices with direct IO and if someone else does buffered IO on
> > any device simultaneously, it locks up.
> 
> Scans all block devices with direct IO? Hmm, why, I wonder? Should
> really consider using buffered (posix_fadvise to readahead/dropbehind).

LVM must not allocate any memory when doing IO because it suspends the 
block device and memory allocation could trigger writeback on the 
suspended device and deadlock.

So it preallocates heap and stack, mlockall()s itself and does direct IO.

Well, there are still two allocations on direct IO path --- one in 
__blockdev_direct_IO and the other in dio_bio_alloc. If you have an idea 
how to get rid of them (especially that kzalloc(sizeof(*dio), GFP_KERNEL), 
that bio allocation would be quite easy to avoid), it would be benefical.

Mikulas
