Return-Path: <linux-kernel-owner+w=401wt.eu-S1751799AbXBJTgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbXBJTgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 14:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbXBJTgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 14:36:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:23586 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbXBJTgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 14:36:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,310,1167638400"; 
   d="scan'208"; a="180067332:sNHT20844103"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH] aio: fix kernel bug when page is temporally busy
Date: Sat, 10 Feb 2007 22:36:29 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC804B00@mssmsx411>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: RE: [PATCH] aio: fix kernel bug when page is temporally busy
Thread-Index: AcdMHN5A7nTRScwQS2KMt5WT3om+pgBKu8Lw
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Ken Chen" <kenchen@google.com>, <suparna@in.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Badari Pulavarty" <pbadari@us.ibm.com>
X-OriginalArrivalTime: 10 Feb 2007 19:36:15.0025 (UTC) FILETIME=[BA343210:01C74D4A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If invalidate_inode_pages2_range() says it can not invalidate pages,
> while dio to the same file offset range is in flight, something is
> really wrong there.

If invalidate_inode_pages2_range() says it can not invalidate pages
It means that soft_irq does completing IO now on other cpu.
Next retry() call in aio_run_iocb() will see the IO well completed.

The patch is updated: invalidate_inode_pages2() returns EIO as earlier
for
nfs and other.
But  invalidate_inode_pages2_range() returns EIOCBRETRY for aio and dio.

The patch against 2.6.20.

>From Leonid Ananiev

Fix kernel bug when IO page is temporally busy:
 invalidate_inode_pages2_range() returns EIOCBRETRY but not  EIO.

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
