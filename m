Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZFAAZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZFAAZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 20:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZFAAZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 20:25:50 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:59781 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZFAAZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 20:25:49 -0400
Message-Id: <6.0.0.20.2.20090529142527.071669e0@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Fri, 29 May 2009 14:35:55 +0900
To: Andrew Morton <akpm@linux-foundation.org>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [RESEND] [PATCH] readahead:add blk_run_backing_dev
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew.

I added blk_run_backing_dev on page_cache_async_readahead
so readahead I/O is unpluged to improve throughput on 
especially RAID environment. 

The normal case is, if page N become uptodate at time T(N), then
T(N) <= T(N+1) holds. With RAID (and NFS to some degree), there 
is no strict ordering, the data arrival time depends on
runtime status of individual disks, which breaks that formula. So
in do_generic_file_read(), just after submitting the async readahead IO
request, the current page may well be uptodate, so the page won't be locked,
and the block device won't be implicitly unplugged:

               if (PageReadahead(page))
                        page_cache_async_readahead()
                if (!PageUptodate(page))
                                goto page_not_up_to_date;
                //...
page_not_up_to_date:
                lock_page_killable(page);

Therefore explicit unplugging can help.

Following is the test result with dd.

#dd if=testdir/testfile of=/dev/null bs=16384

-2.6.30-rc6
1048576+0 records in
1048576+0 records out
17179869184 bytes (17 GB) copied, 224.182 seconds, 76.6 MB/s

-2.6.30-rc6-patched
1048576+0 records in
1048576+0 records out
17179869184 bytes (17 GB) copied, 206.465 seconds, 83.2 MB/s

(7Disks RAID-0 Array)

-2.6.30-rc6
1054976+0 records in
1054976+0 records out
17284726784 bytes (17 GB) copied, 212.233 seconds, 81.4 MB/s

-2.6.30-rc6-patched
1054976+0 records out
17284726784 bytes (17 GB) copied, 198.878 seconds, 86.9 MB/s

(7Disks RAID-5 Array)

Thanks.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Acked-by: Wu Fengguang <fengguang.wu@intel.com> 


 mm/readahead.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- linux.orig/mm/readahead.c
+++ linux/mm/readahead.c
@@ -490,5 +490,15 @@ page_cache_async_readahead(struct addres
 
 	/* do read-ahead */
 	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
+
+	/*
+	* Normally the current page is !uptodate and lock_page() will be
+	* immediately called to implicitly unplug the device. However this
+	* is not always true for RAID conifgurations, where data arrives
+	* not strictly in their submission order. In this case we need to
+	* explicitly kick off the IO.
+	*/
+	if (PageUptodate(page))
+		blk_run_backing_dev(mapping->backing_dev_info, NULL);
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead); 

