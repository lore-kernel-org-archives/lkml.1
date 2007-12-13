Return-Path: <linux-kernel-owner+w=401wt.eu-S1761043AbXLMEyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761043AbXLMEyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 23:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757679AbXLMEx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 23:53:59 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:48634 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbXLMEx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 23:53:58 -0500
Message-Id: <6.0.0.20.2.20071213133952.03e19d70@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Thu, 13 Dec 2007 13:50:41 +0900
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] fix invalidate_inode_pages2_range not to clear ret
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

DIO invalidates page cache through invalidate_inode_pages2_range().
invalidate_inode_pages2_range() sets ret=-EIO when invalidate_complete_page2()
fails, but this ret is cleared if do_launder_page() succeed on a page of 
next index.
In this case, dio is carried out even if invalidate_complete_page2() fails 
on some pages.
This can cause inconsistency between memory and blocks on HDD because the page
cache still exists.

Following patch fixes this issue.

Thanks.

Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.24-rc5.org/mm/truncate.c linux-2.6.24-rc5/mm/truncate.c
--- linux-2.6.24-rc5.org/mm/truncate.c	2007-12-12 16:32:45.000000000 +0900
+++ linux-2.6.24-rc5/mm/truncate.c	2007-12-13 11:45:29.000000000 +0900
@@ -392,6 +392,7 @@ int invalidate_inode_pages2_range(struct
  	pgoff_t next;
  	int i;
  	int ret = 0;
+	int ret2 = 0;
  	int did_range_unmap = 0;
  	int wrapped = 0;

@@ -441,13 +442,13 @@ int invalidate_inode_pages2_range(struct
  			BUG_ON(page_mapped(page));
  			ret = do_launder_page(mapping, page);
  			if (ret == 0 && !invalidate_complete_page2(mapping, page))
-				ret = -EIO;
+				ret2 = -EIO;
  			unlock_page(page);
  		}
  		pagevec_release(&pvec);
  		cond_resched();
  	}
-	return ret;
+	return !ret ? ret2 : ret;
  }
  EXPORT_SYMBOL_GPL(invalidate_inode_pages2_range);
  

