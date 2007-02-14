Return-Path: <linux-kernel-owner+w=401wt.eu-S932399AbXBNR4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbXBNR4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 12:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932402AbXBNR4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 12:56:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:12679 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399AbXBNR4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 12:56:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,170,1170662400"; 
   d="scan'208"; a="199676814:sNHT27606775"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] aio: fix kernel bug when page is temporally busy
Date: Wed, 14 Feb 2007 20:51:33 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC83F228@mssmsx411>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio: fix kernel bug when page is temporally busy
Thread-Index: AcdQYMOxK88NmtSDQU+yCzWod/bKMw==
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Feb 2007 17:56:15.0104 (UTC) FILETIME=[6B9FE800:01C75061]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-wrap lines are fixed. Sorry.

>From Leonid Ananiev

Fix kernel bug if IO page is temporally busy:
invalidate_inode_pages2_range() returns EIOCBRETRY but not  EIO.
invalidate_inode_pages2() returns EIO as earlier.

Signed-off-by: Leonid Ananiev <leonid.i.ananiev@intel.com>
---
--- linux-2.6.20/mm/truncate.c  2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20p/mm/truncate.c 2007-02-08 22:56:52.000000000 -0800
@@ -366,7 +366,7 @@ static int do_launder_page(struct addres
  * Any pages which are found to be mapped into pagetables are unmapped prior to
  * invalidation.
  *This is path is modified so that invalidate_inode_pages2()
returns EIO as earlier.
Wrap lines are fixed

- From Leonid Ananiev

Fix kernel bug when IO page is temporally busy:
invalidate_inode_pages2_range() returns EIOCBRETRY but not  EIO.
invalidate_inode_pages2() returns EIO as earlier.

Signed-off-by: Leonid Ananiev <leonid.i.ananiev@intel.com>
---
--- linux-2.6.20/mm/truncate.c  2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20p/mm/truncate.c 2007-02-08 22:56:52.000000000 -0800
@@ -366,7 +366,7 @@ static int do_launder_page(struct addres
  * Any pages which are found to be mapped into pagetables are unmapped prior to
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
                        if (ret == 0 && !invalidate_complete_page2(mapping, page))
-                               ret = -EIO;
+                               ret = -EIOCBRETRY;
                        unlock_page(page);
                }
                pagevec_release(&pvec);
@@ -444,6 +444,7 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
  */
 int invalidate_inode_pages2(struct address_space *mapping)
 {
-       return invalidate_inode_pages2_range(mapping, 0, -1);
+       int ret =  invalidate_inode_pages2_range(mapping, 0, -1);
+       return (ret < 0)?-EIO:ret;
 }
 EXPORT_SYMBOL_GPL(invalidate_inode_pages2);

- * Returns -EIO if any pages could not be invalidated.
+ * Returns -EIOCBRETRY if any pages could not be invalidated.
  */
 int invalidate_inode_pages2_range(struct address_space *mapping,
                                  pgoff_t start, pgoff_t end)
@@ -423,7 +423,7 @@ int invalidate_inode_pages2_range(struct
                        }
                        ret = do_launder_page(mapping, page);
                        if (ret == 0 && !invalidate_complete_page2(mapping, page))
-                               ret = -EIO;
+                               ret = -EIOCBRETRY;
                        unlock_page(page);
                }
                pagevec_release(&pvec);
@@ -444,6 +444,7 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
  */
 int invalidate_inode_pages2(struct address_space *mapping)
 {
-       return invalidate_inode_pages2_range(mapping, 0, -1);
+       int ret =  invalidate_inode_pages2_range(mapping, 0, -1);
+       return (ret < 0)?-EIO:ret;
 }
 EXPORT_SYMBOL_GPL(invalidate_inode_pages2);



