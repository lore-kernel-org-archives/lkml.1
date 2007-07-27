Return-Path: <linux-kernel-owner+w=401wt.eu-S934448AbXG0HQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934448AbXG0HQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 03:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbXG0HPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 03:15:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:35303 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbXG0HPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 03:15:41 -0400
Date: Fri, 27 Jul 2007 15:15:47 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Jin <joe.jin@oracle.com>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       gurudas.pai@oracle.com, wen.gang.wang@oracle.com,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] add check do_direct_IO() return val
Message-ID: <20070727071547.GA25084@joejin-pc.cn.oracle.com>
References: <20070726090400.GA18640@joejin-pc.cn.oracle.com> <20070726221307.3d7b3446.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726221307.3d7b3446.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I think we still want to run dio_cleanup() if do_direct_IO() failed? 
> Otherwise we can leak pages.
> 
> And there's nothing special about EFAULT or ENOMEM here: if do_direct_IO()
> returns any error then that's it: we bale out, yes?
> 

Yes, I think we'll out from here if get EFAULT/ENOMEM error, also maybe -EIO
return, return diretly should ok.

> In fact I'm suspecting that this is what the code in there used to do. 
> Something like:
> 
> 	for (...) {
> 		...
> 		ret = do_direct_IO(...);
> 		...
> 		if (ret) {
> 			dio_dleanup(dio);
> 			break
> 		}
> 	}
> 	return ret;
> 

Yes, we need call dio_cleanup() to release page cache, I lost it.

However, we need do more while return -ENOTBLK, right?
so I think the patch maybe like following:


--- linux-2.6.22/fs/direct-io.c.orig	2007-07-27 14:39:15.000000000 +0800
+++ linux-2.6.22/fs/direct-io.c	2007-07-27 15:08:58.000000000 +0800
@@ -1032,18 +1032,19 @@ direct_io_worker(int rw, struct kiocb *i
 					blkbits);
 
 		if (ret) {
+			if (ret == -ENOTBLK && (rw & WRITE)) {
+				/*
+				 * The remaining part of the request will be
+				 * be handled by buffered I/O when we return
+				 */
+				ret = 0;
+				break;
+			}
 			dio_cleanup(dio);
-			break;
+			goto out;
 		}
 	} /* end iovec loop */
 
-	if (ret == -ENOTBLK && (rw & WRITE)) {
-		/*
-		 * The remaining part of the request will be
-		 * be handled by buffered I/O when we return
-		 */
-		ret = 0;
-	}
 	/*
 	 * There may be some unwritten disk at the end of a part-written
 	 * fs-block-sized block.  Go zero that now.




> _
> 
> However I'd like to ask you guys to carefully review and test that please.
> 
Gurudas, would you please give more test of this patch?

Thanks, 
Joe
