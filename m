Return-Path: <linux-kernel-owner+w=401wt.eu-S1761671AbXEORea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761671AbXEORea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757515AbXEOReW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:34:22 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:2270 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279AbXEOReV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:34:21 -0400
Date: Tue, 15 May 2007 19:15:40 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Fix section conflict of current_io_context
Message-ID: <20070515171540.GA20425@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Building with GCC 4.2, I get the following error:

  CC      block/ll_rw_blk.o
block/ll_rw_blk.c:3751: error: __ksymtab_current_io_context causes a section type conflict

This is because current_io_context is both declared static and exported.

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>

--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -41,7 +41,7 @@ static void blk_unplug_timeout(unsigned long data);
 static void drive_stat_acct(struct request *rq, int nr_sectors, int new_io);
 static void init_request_from_bio(struct request *req, struct bio *bio);
 static int __make_request(request_queue_t *q, struct bio *bio);
-static struct io_context *current_io_context(gfp_t gfp_flags, int node);
+struct io_context *current_io_context(gfp_t gfp_flags, int node);
 
 /*
  * For the allocated request tables
@@ -3723,7 +3723,7 @@ void exit_io_context(void)
  * but since the current task itself holds a reference, the context can be
  * used in general code, so long as it stays within `current` context.
  */
-static struct io_context *current_io_context(gfp_t gfp_flags, int node)
+struct io_context *current_io_context(gfp_t gfp_flags, int node)
 {
 	struct task_struct *tsk = current;
 	struct io_context *ret;

-- 
Martin Michlmayr
http://www.cyrius.com/
