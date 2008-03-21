Return-Path: <linux-kernel-owner+w=401wt.eu-S1764155AbYCUXtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764155AbYCUXtB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYCUXpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:45:34 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60176 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbYCUXpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:45:25 -0400
Message-Id: <20080321224346.221996338@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:09 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nick Piggin <npiggin@suse.de>, "Alexey Dobriyan" <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 19/76] iov_iter_advance() fix
Content-Disposition: inline; filename=iov_iter_advance-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Nick Piggin <npiggin@suse.de>

iov_iter_advance() skips over zero-length iovecs, however it does not properly
terminate at the end of the iovec array.  Fix this by checking against
i->count before we skip a zero-length iov.

The bug was reproduced with a test program that continually randomly creates
iovs to writev.  The fix was also verified with the same program and also it
could verify that the correct data was contained in the file after each
writev.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Tested-by: "Kevin Coffman" <kwc@citi.umich.edu>
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/filemap.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1725,21 +1725,27 @@ size_t iov_iter_copy_from_user(struct pa
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
@@ -1751,14 +1757,6 @@ static void __iov_iter_advance_iov(struc
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

-- 
