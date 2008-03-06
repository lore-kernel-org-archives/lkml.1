Return-Path: <linux-kernel-owner+w=401wt.eu-S932287AbYCFFkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbYCFFkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 00:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbYCFFjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 00:39:55 -0500
Received: from cantor.suse.de ([195.135.220.2]:36885 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051AbYCFFjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 00:39:54 -0500
Date: Thu, 6 Mar 2008 06:39:50 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@kernel.org, Kevin Coffman <kwc@citi.umich.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] iov_iter_advance fix
Message-ID: <20080306053950.GA28803@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


iov_iter_advance skips over zero-length iovecs, however it does not properly
terminate at the end of the iovec array. Fix this by checking against
i->count before we skip a zero-length iov.

The bug was reproduced with a test program that continually randomly creates
iovs to writev. The fix was also verified with the same program and also it
could verify that the correct data was contained in the file after each
writev.

2.6.25 and 2.6.24.stable requires this fix.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: stable@kernel.org
---
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2008-03-06 08:46:38.000000000 +1100
+++ linux-2.6/mm/filemap.c	2008-03-06 08:48:00.000000000 +1100
@@ -1743,21 +1743,27 @@
 }
 EXPORT_SYMBOL(iov_iter_copy_from_user);
 
-static void __iov_iter_advance_iov(struct iov_iter *i, size_t bytes)
+void iov_iter_advance(struct iov_iter *i, size_t bytes)
 {
+	BUG_ON(i->count < bytes);
+
 	if (likely(i->nr_segs == 1)) {
 		i->iov_offset += bytes;
+		i->count -= bytes;
 	} else {
 		const struct iovec *iov = i->iov;
 		size_t base = i->iov_offset;
 
 		/*
 		 * The !iov->iov_len check ensures we skip over unlikely
-		 * zero-length segments.
+		 * zero-length segments (without overruning the iovec).
 		 */
-		while (bytes || !iov->iov_len) {
-			int copy = min(bytes, iov->iov_len - base);
+		while (bytes || unlikely(!iov->iov_len && i->count)) {
+			int copy;
 
+			copy = min(bytes, iov->iov_len - base);
+			BUG_ON(!i->count || i->count < copy);
+			i->count -= copy;
 			bytes -= copy;
 			base += copy;
 			if (iov->iov_len == base) {
@@ -1769,14 +1775,6 @@
 		i->iov_offset = base;
 	}
 }
-
-void iov_iter_advance(struct iov_iter *i, size_t bytes)
-{
-	BUG_ON(i->count < bytes);
-
-	__iov_iter_advance_iov(i, bytes);
-	i->count -= bytes;
-}
 EXPORT_SYMBOL(iov_iter_advance);
 
 /*
