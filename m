Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbYCQB6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbYCQB6b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 21:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbYCQB6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:58:17 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:65447 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbYCQB6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:58:16 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20080317258.659191058@firstfloor.org>
To: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: [PATCH] [0/18] GB pages hugetlb support
Date: Mon, 17 Mar 2008 02:58:13 +0100 (CET)
X-OriginalArrivalTime: 17 Mar 2008 01:51:39.0595 (UTC) FILETIME=[7120D1B0:01C887D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchkit supports GB pages for hugetlb on x86-64 in addition to 
2MB pages.   This is the sucessor of an earlier much simpler
patchkit that allowed to set the hugepagesz globally at boot
to 1GB pages. The advantage of this more complex patchkit
is that it allows 2MB page users and 1GB page users to 
coexist (although not on the same hugetlbfs mount points) 

It first adds some straight-forward infrastructure 
to hugetlbfs to support multiple page sizes. Then it uses that
infrastructure to implement support for huge pages > MAX_ORDER 
(which can be allocated at boot with bootmem only). Then 
the x86-64 port is extended to support 1GB pages on CPUs
that support them (AMD Quad Cores)

There is no support for i386 because GB pages are only available in
long mode.

The variable page size support is currently limited to the
specific use case of the single additional 1GB page size.
Using it for more page sizes (especially those < MAX_ORDER)
would require some more work, although the basic infrastructure
is all in place and the incremental work will be small.
But I didn't bother to implement some corner cases not needed
for the GB page case. I usually added comments so they
should be easy to find (and fix) later however :)

I hacked in also cpuset support. It would be good if 
Paul double checked that.

GB pages are only intended to be used in special situations, like
dedicated databases where complicated configuration does not matter. 
That is why they have some limitations:
- Can be only allocated at boot (using hugepagesz=1G hugepages=...) 
- Can't be freed at runtime
- One hugetlbfs mount per page size (using the pagesize=... mount 
option). This is a little awkward, but greatly simplified the
code.
- No IPC SHM support currently (would not be very hard to do, 
but it is unclear what the best API for this is. Suggestions
welcome)

Some of this would be fixable later.

Known issues:
- GB pages are not reported in total memory, which gives
confusing free(1) output
- I have still to explain myself how and if free_pgd_pages works
on hugetlb, both with 1GB and with 2MB pages. 
- cpuset support is a little dubious, but the code was 
even before quite strange.
- lockdep sometimes complains about recursive page_table_locks
for shared hugetlb memory, but as far as I can see I didn't
actually change this area. Looks a little dubious, might
be a false positive too.
- hugemmap04 from LTP fails. Cause unknown currently

-Andi
