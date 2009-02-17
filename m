Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbZBQWdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbZBQWdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZBQWcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:32:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbZBQWcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:32:54 -0500
Date: Tue, 17 Feb 2009 17:32:47 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       Alasdair G Kergon <agk@redhat.com>
Subject: A suggestion to preserve bio vector
Message-ID: <Pine.LNX.4.64.0902171707001.28612@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

We have found a bio bug in device mapper raid1 and multipath.

When processing a request, dm-raid1 and dm-multipath record the fields 
bi_sector, bi_bdev, bi_size, bi_idx, bi_flags. If the bio fails, it 
restores these fields and resubmits the same bio to the other device.

The problem is that when the driver reports partial completions with 
__blk_end_request having nr_bytes less than the total request size, the 
bio layer will patch the bi_sector, bi_size and bio vector to reflect the 
progress.

If the request later fails, device mapper will resubmit the request to the 
other device --- but the bio vector was modified, this new request has 
mismatching bi_size and total request length, and it causes crashes on 
BUG().

Could it be possible to modify the bio layer so that it doesn't modify the 
bio vector? Does anything need to modify the vector while the request is 
being processed?

There are alternate approaches, but they are not as good:

- copy and restore the vector for each request in dm-raid1 and 
dm-multipath - needless memory allocation and performance degradation per 
request.

- when request fails, resubmit only that part that reflects the failed 
data. - this would need to recheck all drivers that handle bios that they 
produce sensible bios on errors (if we change semantics from "bio contains 
junk on error" to "bio must reflect progress on error", this would need 
extensive review). Also, there's an experimental patch on device mapper 
that makes it to share bio vector when splitting the request to multiple 
targets (it saves memory and improves performance) and this approach would 
break the patch.

So, redefine semantics to "bio vector is not modified" looks like a best 
solution to me. I'd like to know what do you think about it.

Mikulas
