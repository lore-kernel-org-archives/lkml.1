Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYACJEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYACJEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 04:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYACJEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 04:04:40 -0500
Received: from ozlabs.org ([203.10.76.45]:37760 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYACJEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 04:04:38 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: bcrl@kvack.org
Subject: [PATCH] aio: partial write should not return error code.
Date: Thu, 3 Jan 2008 20:04:08 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-aio@kvack.org, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801032004.08907.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an AIO write gets an error after writing some data (eg. ENOSPC),
it should return the amount written already, not the error.  Just like
write() is supposed to.

This was found by the libaio test suite.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 18802689361a fs/aio.c
--- a/fs/aio.c	Thu Jan 03 15:22:24 2008 +1100
+++ b/fs/aio.c	Thu Jan 03 18:05:25 2008 +1100
@@ -1346,6 +1350,13 @@ static ssize_t aio_rw_vect_retry(struct 
 	/* This means we must have transferred all that we could */
 	/* No need to retry anymore */
 	if ((ret == 0) || (iocb->ki_left == 0))
+		ret = iocb->ki_nbytes - iocb->ki_left;
+
+	/* If we managed to write some out we return that, rather than
+	 * the eventual error. */
+	if (opcode == IOCB_CMD_PWRITEV
+	    && ret < 0
+	    && iocb->ki_nbytes - iocb->ki_left)
 		ret = iocb->ki_nbytes - iocb->ki_left;
 
 	return ret;
