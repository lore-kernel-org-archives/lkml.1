Return-Path: <linux-kernel-owner+w=401wt.eu-S933234AbYBOGgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbYBOGgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 01:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762291AbYBOGgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 01:36:12 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:51664 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167AbYBOGgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 01:36:11 -0500
X-Greylist: delayed 1682 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Feb 2008 01:36:11 EST
Message-Id: <6.0.0.20.2.20080215132604.06091618@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Fri, 15 Feb 2008 13:36:32 +0900
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [RESEND] [PATCH] fix invalidate_inode_pages2_range not to
  clear ret
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew.

DIO invalidates page cache through invalidate_inode_pages2_range().
invalidate_inode_pages2_range() sets ret=-EIO when invalidate_complete_page2()
fails, but this ret is cleared if do_launder_page() succeed on a page of next index. 
In this case, dio is carried out even if invalidate_complete_page2() fails on some pages.
This can cause inconsistency between memory and blocks on HDD because the page
cache still exists.

Following patch fixes this issue.

Thanks.

Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.25-rc1.org/mm/truncate.c linux-2.6.25-rc1/mm/truncate.c
--- linux-2.6.25-rc1.org/mm/truncate.c	2008-02-12 13:37:41.000000000 +0900
+++ linux-2.6.25-rc1/mm/truncate.c	2008-02-15 11:24:33.000000000 +0900
@@ -392,6 +392,7 @@ int invalidate_inode_pages2_range(struct
 	pgoff_t next;
 	int i;
 	int ret = 0;
+	int ret2 = 0;
 	int did_range_unmap = 0;
 	int wrapped = 0;
 
@@ -439,9 +440,11 @@ int invalidate_inode_pages2_range(struct
 				}
 			}
 			BUG_ON(page_mapped(page));
-			ret = do_launder_page(mapping, page);
-			if (ret == 0 && !invalidate_complete_page2(mapping, page))
-				ret = -EIO;
+			ret2 = do_launder_page(mapping, page);
+			if (ret2 == 0 && !invalidate_complete_page2(mapping, page))
+				ret2 = -EIO;
+			if (ret2 < 0)
+				ret = ret2;
 			unlock_page(page);
 		}
 		pagevec_release(&pvec);


