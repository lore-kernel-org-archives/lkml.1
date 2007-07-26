Return-Path: <linux-kernel-owner+w=401wt.eu-S1765908AbXGZJE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765908AbXGZJE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 05:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbXGZJEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 05:04:21 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55703 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbXGZJEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 05:04:21 -0400
Date: Thu, 26 Jul 2007 17:04:00 +0800
From: Joe Jin <joe.jin@oracle.com>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, gurudas.pai@oracle.com,
       wen.gang.wang@oracle.com, joe.jin@oracle.com
Subject: [PATCH] add check do_direct_IO() return val
Message-ID: <20070726090400.GA18640@joejin-pc.cn.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the patch for check do_direct_IO() return val.

At do_direct_IO(), sometimes dio_get_page() will return -EFAULT/-ENOMEM,
according to orig source, it will go on left work. buf for dio_get_page()
return a error will made many useful member of dio not initialized like
dio->map_bh and others, at this point, kernel will panic.

Signed-off-by: Joe Jin <joe.jin@oracle.com>


---
--- linux-2.6.22/fs/direct-io.c.orig	2007-07-26 11:32:27.000000000 +0800
+++ linux-2.6.22/fs/direct-io.c	2007-07-26 11:33:58.000000000 +0800
@@ -1031,7 +1031,9 @@ direct_io_worker(int rw, struct kiocb *i
 			((dio->final_block_in_request - dio->block_in_file) <<
 					blkbits);
 
-		if (ret) {
+		if (ret == -EFAULT || ret == -ENOMEM) 
+			goto out;
+		else if (ret) {
 			dio_cleanup(dio);
 			break;
 		}
@@ -1113,6 +1115,7 @@ direct_io_worker(int rw, struct kiocb *i
 	} else
 		BUG_ON(ret != -EIOCBQUEUED);
 
+out:
 	return ret;
 }
 
