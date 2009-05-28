Return-Path: <linux-kernel-owner+w=401wt.eu-S1761701AbZE1BZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761701AbZE1BZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 21:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbZE1BZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 21:25:28 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:52299 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbZE1BZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 21:25:27 -0400
Message-Id: <6.0.0.20.2.20090528095927.06dfc1c8@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Thu, 28 May 2009 10:20:32 +0900
To: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] readahead:add blk_run_backing_dev
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <20090527043601.GA26361@localhost>
References: <20090526193601.b825af5f.akpm@linux-foundation.org>
 <20090527035505.GA16916@localhost>
 <20090527130358.689C.A69D9226@jp.fujitsu.com>
 <20090527043601.GA26361@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>To make the reasoning more obvious:
>
>Assume we just submitted readahead IO request for pages N ~ N+M, then
>        T(N) <= T(N+1)
>        T(N) <= T(N+2)
>        T(N) <= T(N+3)
>        ...
>        T(N) <= T(N+M)   (M = readahead size)
>So if the reader is going to block on any page in the above chunk,
>it is going to first block on page N.
>
>With RAID (and NFS to some degree), there is no strict ordering,
>so the reader is more likely to block on some random pages.
>
>In the first case, the effective async_size = M, in the second case,
>the effective async_size <= M. The more async_size, the more degree of
>readahead pipeline, hence the more low level IO latencies are hidden
>to the application.
>
>Thanks,
>Fengguang
>
>> 
>> > 
>> >                if (PageReadahead(page))
>> >                         page_cache_async_readahead()
>> >                 if (!PageUptodate(page))
>> >                                 goto page_not_up_to_date;
>> >                 //...
>> > page_not_up_to_date:
>> >                 lock_page_killable(page);
>> > 
>> > 
>> > Therefore explicit unplugging can help, so
>> > 
>> >         Acked-by: Wu Fengguang <fengguang.wu@intel.com> 
>> > 
>> > The only question is, shall we avoid the double unplug by doing this?
>> > 


Hi Andrew.
Please merge following patch.
Thanks.

---

I added blk_run_backing_dev on page_cache_async_readahead
so readahead I/O is unpluged to improve throughput on 
especially RAID environment. 

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

My testing environment is as follows:
Hardware: HP DL580 
CPU:Xeon 3.2GHz *4 HT enabled
Memory:8GB
Storage: Dothill SANNet2 FC (7Disks RAID-0 Array)

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

