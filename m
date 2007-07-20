Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbXGTKNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbXGTKNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 06:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbXGTKLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 06:11:33 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:59133 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752277AbXGTKLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 06:11:30 -0400
Message-ID: <384926280.23246@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070720101124.350754890@mail.ustc.edu.cn>
References: <20070720100740.106917381@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Fri, 20 Jul 2007 18:07:44 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] remove the limit max_sectors_kb imposed on max_readahead_kb
Content-Disposition: inline; filename=remove-readahead-size-limit.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the size limit max_sectors_kb imposed on max_readahead_kb.

max_sectors_kb cannot grow larger than max_hw_sectors_kb, which can be
rather small for some disk drives.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 block/ll_rw_blk.c |    9 ---------
 1 file changed, 9 deletions(-)

--- linux-2.6.22-rc6-mm1.orig/block/ll_rw_blk.c
+++ linux-2.6.22-rc6-mm1/block/ll_rw_blk.c
@@ -3945,7 +3945,6 @@ queue_max_sectors_store(struct request_q
 			max_hw_sectors_kb = q->max_hw_sectors >> 1,
 			page_kb = 1 << (PAGE_CACHE_SHIFT - 10);
 	ssize_t ret = queue_var_store(&max_sectors_kb, page, count);
-	int ra_kb;
 
 	if (max_sectors_kb > max_hw_sectors_kb || max_sectors_kb < page_kb)
 		return -EINVAL;
@@ -3954,14 +3953,6 @@ queue_max_sectors_store(struct request_q
 	 * values synchronously:
 	 */
 	spin_lock_irq(q->queue_lock);
-	/*
-	 * Trim readahead window as well, if necessary:
-	 */
-	ra_kb = q->backing_dev_info.ra_pages << (PAGE_CACHE_SHIFT - 10);
-	if (ra_kb > max_sectors_kb)
-		q->backing_dev_info.ra_pages =
-				max_sectors_kb >> (PAGE_CACHE_SHIFT - 10);
-
 	q->max_sectors = max_sectors_kb << 1;
 	spin_unlock_irq(q->queue_lock);
 

--
