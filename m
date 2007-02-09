Return-Path: <linux-kernel-owner+w=401wt.eu-S1946121AbXBIFl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946121AbXBIFl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 00:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946122AbXBIFl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 00:41:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:41001 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946121AbXBIFl4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 00:41:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,304,1167638400"; 
   d="scan'208"; a="194791829:sNHT20719923"
Content-class: urn:content-classes:message
Subject: RE: [PATCH] aio: fix kernel bug when page is  temporally busy
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Date: Fri, 9 Feb 2007 08:41:41 +0300
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <B41635854730A14CA71C92B36EC22AAC8048E2@mssmsx411>
In-Reply-To: <20070208203507.347cff98.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio: fix kernel bug when page is  temporally busy
Thread-Index: AcdMA7nhwdnvOFVLT9GWg/E4VeIXvAAA9KgA
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Zach Brown" <zach.brown@oracle.com>, <suparna@in.ibm.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Badari Pulavarty" <pbadari@us.ibm.com>
X-OriginalArrivalTime: 09 Feb 2007 05:41:47.0962 (UTC) FILETIME=[FD7EE9A0:01C74C0C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> invalidate_inode_pages2() has other callers.  I suspect with this
change
> we'll end up leaking EIOCBRETRY back to userspace.

EIOCBRETRY is used and caught already in do_sync_read() and
do_sync_readv_writev().

Below fixed patch against kernel 2.6.20.

>From Leonid Ananiev

Fix kernel bug when IO page is temporally busy:
invalidate_inode_pages2() returns EIOCBRETRY but not  EIO..

Signed-off-by: Leonid Ananiev <leonid.i.ananiev@intel.com>
---
--- linux-2.6.20/mm/truncate.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20p/mm/truncate.c	2007-02-08 11:38:11.000000000 -0800
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
@@ -440,7 +440,7 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
  * Any pages which are found to be mapped into pagetables are unmapped
prior to
  * invalidation.
  *
- * Returns -EIO if any pages could not be invalidated.
+ * Returns -EIOCBRETRY if any pages could not be invalidated.
  */
 int invalidate_inode_pages2(struct address_space *mapping)
 {
