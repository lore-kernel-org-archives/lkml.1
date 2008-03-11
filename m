Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbYCKWlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbYCKWlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 18:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbYCKWk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 18:40:58 -0400
Received: from ozlabs.org ([203.10.76.45]:49532 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbYCKWk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 18:40:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] aio_write should tell userspace about partial writes
Date: Wed, 12 Mar 2008 09:39:59 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Zach Brown <zach.brown@oracle.com>, bcrl@kvack.org, linux-aio@kvack.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803120939.59915.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Linus, please apply.  This patch was discussed and acked before,
  but somehow got lost. ]

When an AIO write gets a non-retry error after writing some data
(eg. ENOSPC), it should return the amount written already, not the
error.  Just like write() is supposed to.

This was found by the libaio test suite.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-By: Zach Brown <zach.brown@oracle.com>
---
 fs/aio.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -r c36fc295bb75 fs/aio.c
--- a/fs/aio.c	Tue Mar 11 09:04:47 2008 +1100
+++ b/fs/aio.c	Tue Mar 11 09:05:54 2008 +1100
@@ -1358,6 +1358,13 @@ static ssize_t aio_rw_vect_retry(struct 
 	    && iocb->ki_nbytes - iocb->ki_left)
 		ret = iocb->ki_nbytes - iocb->ki_left;
 
+	/* If we managed to write some out we return that, rather than
+	 * the eventual error. */
+	if (opcode == IOCB_CMD_PWRITEV
+	    && ret < 0 && ret != -EIOCBQUEUED && ret != -EIOCBRETRY
+	    && iocb->ki_nbytes - iocb->ki_left)
+		ret = iocb->ki_nbytes - iocb->ki_left;
+
 	return ret;
 }
 
