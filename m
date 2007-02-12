Return-Path: <linux-kernel-owner+w=401wt.eu-S1030438AbXBLWxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030438AbXBLWxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030442AbXBLWxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:53:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:46515 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030438AbXBLWxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:53:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,160,1170662400"; 
   d="scan'208"; a="45755585:sNHT19791234"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH] aio: fix kernel bug when page is  temporally busy
Date: Tue, 13 Feb 2007 01:52:50 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC804E8D@mssmsx411>
In-Reply-To: <20070208215237.e5a48659.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio: fix kernel bug when page is  temporally busy
Thread-Index: AcdMDohwu7ojHva3QiiXuxcxPkrLrwC6DZsg
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>
X-OriginalArrivalTime: 12 Feb 2007 22:53:03.0059 (UTC) FILETIME=[8D2AB230:01C74EF8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,
You wrote on Friday, February 09, 2007 8:53 AM
> invalidate_inode_pages2() has other callers.  I suspect with this
change
> we'll end up leaking EIOCBRETRY back to userspace.

The path is modified so that invalidate_inode_pages2() returns EIO as
earlier.
could you consider modified patch
The patch against 2.6.20.

Long story: The kernel panic is happening after hours of AIO benchmark
running in mcp.
First of all it was found that the kernel panic happens if IO error is
reported.
But later it was found that the actual reason is not in real IO error
but in a busy page.
While the current CPU tests if IO is completed it happens that another
CPU
at the same time processes IO completion in soft_irq.
The considered buffer page is busy now by second CPU and
invalidate_inode_pages2_range() returns EIO in this case.
First CPU reports EIO to caller ; completes IO and frees control block
in aio_complete().
Second CPU frees the same control block once more. 
The patch makes invalidate_inode_pages2_range() to return EIOCBRETRY
which is tested just in aio_run_iocb(). It retries IO competition check
if EIOCBRETRY is got.
EIOCBRETRY is tested in do_sync_read/write() functions as well.
And direct IO competition will be retested "instead of dropping it to
the floor".

>From Leonid Ananiev

Fix kernel bug when IO page is temporally busy:
invalidate_inode_pages2_range() returns EIOCBRETRY but not  EIO.
invalidate_inode_pages2() returns EIO as earlier.

Signed-off-by: Leonid Ananiev <leonid.i.ananiev@intel.com>
---
--- linux-2.6.20/mm/truncate.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20p/mm/truncate.c	2007-02-08 22:56:52.000000000 -0800
@@ -366,7 +366,7 @@ static int do_launder_page(struct addres
  * Any pages which are found to be mapped into pagetables are unmapped
prior to
  * invalidation.
  *
- * Returns -EIO if any pages could not be invalidated.
+ * Returns -EIOCBRETRY if any pages could not be invalidated.
  */
 int invalidate_inode_pages2_range(struct address_space *mapping,
 				  pgoff_t start, pgoff_t end)
@@ -423,7 +423,7 @@ int invalidate_inode_pages2_range(struct
 			}
 			ret = do_launder_page(mapping, page);
 			if (ret == 0 &&
!invalidate_complete_page2(mapping, page))
-				ret = -EIO;
+				ret = -EIOCBRETRY;
 			unlock_page(page);
 		}
 		pagevec_release(&pvec);
@@ -444,6 +444,7 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
  */
 int invalidate_inode_pages2(struct address_space *mapping)
 {
-	return invalidate_inode_pages2_range(mapping, 0, -1);
+	int ret =  invalidate_inode_pages2_range(mapping, 0, -1);
+	return (ret < 0)?-EIO:ret;
 }
 EXPORT_SYMBOL_GPL(invalidate_inode_pages2);
