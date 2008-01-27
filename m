Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbYA1BHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbYA1BHH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 20:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbYA1BGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 20:06:32 -0500
Received: from ozlabs.org ([203.10.76.45]:34649 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbYA1BGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 20:06:30 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] aio: -EINVAL on negative read/write offset
Date: Mon, 28 Jan 2008 09:55:39 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Zach Brown <zach.brown@oracle.com>
References: <200801280953.20406.rusty@rustcorp.com.au>
In-Reply-To: <200801280953.20406.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801280955.39493.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An AIO read or write should return -EINVAL if the offset is negative.
This check matches the one in pread and pwrite.

This was found by the libaio test suite.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 fs/aio.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -r 18802689361a fs/aio.c
--- a/fs/aio.c	Thu Jan 03 15:22:24 2008 +1100
+++ b/fs/aio.c	Thu Jan 03 18:05:25 2008 +1100
@@ -1330,6 +1330,10 @@ static ssize_t aio_rw_vect_retry(struct 
 		opcode = IOCB_CMD_PWRITEV;
 	}
 
+	/* This matches the pread()/pwrite() logic */
+	if (iocb->ki_pos < 0)
+		return -EINVAL;
+
 	do {
 		ret = rw_op(iocb, &iocb->ki_iovec[iocb->ki_cur_seg],
 			    iocb->ki_nr_segs - iocb->ki_cur_seg,
