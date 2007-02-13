Return-Path: <linux-kernel-owner+w=401wt.eu-S1751112AbXBMGCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112AbXBMGCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 01:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXBMGCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 01:02:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbXBMGCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 01:02:18 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 13 Feb 2007 17:01:31 +1100
Message-Id: <1070213060131.3560@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Norman Weathers <norman.r.weathers@conocophillips.com>
Cc: Vladimir V "." Saveliev <vs@namesys.com>
Subject: [PATCH] knfsd: Stop NFSD writes from being broken into lots of little writes to filesystem.
References: <20070213170049.3488.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Another nfsd patch for 2.6.21...

### Comments for Changeset

When NFSD receives a write request, the data is typically in a number
of 1448 byte segments and writev is used to collect them together.

Unfortunately, generic_file_buffered_write passes these to the filesystem
one at a time, so an e.g. 32K over-write becomes a series of partial-page
writes to each page, causing the filesystem to have to pre-read those
pages - wasted effort.

generic_file_buffered_write handles one segment of the vector at a
time as it has to pre-fault in each segment to avoid deadlocks.  When
writing from kernel-space (and nfsd does) this is not an issue, so
generic_file_buffered_write does not need to break and iovec from nfsd
into little pieces.

This patch avoids the splitting when  get_fs is KERNEL_DS as it is
from NFSd.

This issue was introduced by commit 6527c2bdf1f833cc18e8f42bd97973d583e4aa83

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Norman Weathers <norman.r.weathers@conocophillips.com>
Cc: Vladimir V. Saveliev <vs@namesys.com>

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./mm/filemap.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff .prev/mm/filemap.c ./mm/filemap.c
--- .prev/mm/filemap.c	2007-02-13 16:53:19.000000000 +1100
+++ ./mm/filemap.c	2007-02-13 16:52:51.000000000 +1100
@@ -2160,21 +2160,27 @@ generic_file_buffered_write(struct kiocb
 		/* Limit the size of the copy to the caller's write size */
 		bytes = min(bytes, count);
 
-		/*
-		 * Limit the size of the copy to that of the current segment,
-		 * because fault_in_pages_readable() doesn't know how to walk
-		 * segments.
+		/* We only need to worry about prefaulting when writes are from
+		 * user-space.  NFSd uses vfs_writev with several non-aligned
+		 * segments in the vector, and limiting to one segment a time is
+		 * a noticeable performance for re-write
 		 */
-		bytes = min(bytes, cur_iov->iov_len - iov_base);
-
-		/*
-		 * Bring in the user page that we will copy from _first_.
-		 * Otherwise there's a nasty deadlock on copying from the
-		 * same page as we're writing to, without it being marked
-		 * up-to-date.
-		 */
-		fault_in_pages_readable(buf, bytes);
+		if (!segment_eq(get_fs(), KERNEL_DS)) {
+			/*
+			 * Limit the size of the copy to that of the current
+			 * segment, because fault_in_pages_readable() doesn't
+			 * know how to walk segments.
+			 */
+			bytes = min(bytes, cur_iov->iov_len - iov_base);
 
+			/*
+			 * Bring in the user page that we will copy from
+			 * _first_.  Otherwise there's a nasty deadlock on
+			 * copying from the same page as we're writing to,
+			 * without it being marked up-to-date.
+			 */
+			fault_in_pages_readable(buf, bytes);
+		}
 		page = __grab_cache_page(mapping,index,&cached_page,&lru_pvec);
 		if (!page) {
 			status = -ENOMEM;
