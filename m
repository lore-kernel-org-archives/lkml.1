Return-Path: <linux-kernel-owner+w=401wt.eu-S1946088AbXBIE3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946088AbXBIE3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 23:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946091AbXBIE3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 23:29:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:20290 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946088AbXBIE3l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 23:29:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,304,1167638400"; 
   d="scan'208"; a="179423711:sNHT25959843"
Content-class: urn:content-classes:message
Subject: [PATCH] aio: fix kernel bug when page is  temporally busy
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Date: Fri, 9 Feb 2007 07:29:31 +0300
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <B41635854730A14CA71C92B36EC22AAC8048C3@mssmsx411>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio: fix kernel bug when page is  temporally busy
Thread-Index: AcdMAuUDCeoetW/ZQ+6aifBmyDKgUA==
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: <linux-kernel@vger.kernel.org>
Cc: "linux-aio" <linux-aio@kvack.org>, "Andrew Morton" <akpm@osdl.org>,
       "Zach Brown" <zach.brown@oracle.com>, <suparna@in.ibm.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Badari Pulavarty" <pbadari@us.ibm.com>
X-OriginalArrivalTime: 09 Feb 2007 04:29:39.0619 (UTC) FILETIME=[E99A2F30:01C74C02]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From Leonid Ananiev

Fix "Kernel BUG at fs/aio.c:509". Return EIOCBRETRY but not  EIO if page
is busy.

Signed-off-by: Leonid Ananiev <leonid.i.ananiev@intel.com>

"Kernel BUG at fs/aio.c:509"
http://marc.theaimsgroup.com/?l=linux-kernel&m=117031052517746&w=2 
is present in 2.6.20 as well as 2.6.19.
The investigation shows that the bug's panic occurs when aio_complete()
is called with argument ret=EIO which is returned from
invalidate_inode_pages2_range() because the page is temporally busy.
Call Trace:
 [<ffffffff802573c3>] invalidate_inode_pages2_range+0x236/0x26b
 [<ffffffff802af77b>] ext3_direct_IO+0x16c/0x19e
 [<ffffffff802adc1d>] ext3_get_block+0x0/0xe2
 [<ffffffff802518c0>] generic_file_direct_IO+0xb9/0xcf
 [<ffffffff8025193d>] generic_file_direct_write+0x67/0x10e
 [<ffffffff80252308>] __generic_file_aio_write_nolock+0x2d6/0x3fe
 [<ffffffff802082c0>] __switch_to+0x26f/0x27e
 [<ffffffff8047b8e9>] thread_return+0x0/0xd8
 [<ffffffff80252497>] generic_file_aio_write+0x67/0xc7
 [<ffffffff802ab2cc>] ext3_file_write+0x0/0x8f
 [<ffffffff802ab2e2>] ext3_file_write+0x16/0x8f
 [<ffffffff802ab2cc>] ext3_file_write+0x0/0x8f
 [<ffffffff80283f61>] aio_rw_vect_retry+0x72/0x14f
 [<ffffffff80284ad9>] aio_run_iocb+0xe6/0x187
 [<ffffffff802853e2>] io_submit_one+0x296/0x2e3
 [<ffffffff80285979>] sys_io_submit+0x9b/0x108
 [<ffffffff80229b49>] default_wake_function+0x0/0xe
 [<ffffffff8020983e>] system_call+0x7e/0x83

As a result aio_complete() is called while it should not be.
When IO is finished  aio_complete() is called once more
and iocb->ki_users becomes negative.

Taking into account aio.c lines in aio_run_iocb()
        if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED) {
                aio_complete(iocb, ret, 0);

proposed patch makes function invalidate_inode_pages2_range()
to return EIOCBRETRY but not  EIO if page is busy.
The patch is tested on 2.6.20.

--- linux-2.6.20/mm/truncate.c  2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20p/mm/truncate.c 2007-02-08 11:38:11.000000000 -0800
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
-                               ret = -EIO;
+                               ret = -EIOCBRETRY;
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
