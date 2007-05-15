Return-Path: <linux-kernel-owner+w=401wt.eu-S1761455AbXEOR0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455AbXEOR0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbXEOR0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:26:12 -0400
Received: from brick.kernel.dk ([80.160.20.94]:8155 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058AbXEOR0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:26:11 -0400
Date: Tue, 15 May 2007 19:24:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fix section conflict of current_io_context
Message-ID: <20070515172448.GC23798@kernel.dk>
References: <20070515171540.GA20425@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515171540.GA20425@deprecation.cyrius.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15 2007, Martin Michlmayr wrote:
> Building with GCC 4.2, I get the following error:
> 
>   CC      block/ll_rw_blk.o
> block/ll_rw_blk.c:3751: error: __ksymtab_current_io_context causes a section type conflict
> 
> This is because current_io_context is both declared static and exported.
> 
> Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
> 
> --- a/block/ll_rw_blk.c
> +++ b/block/ll_rw_blk.c
> @@ -41,7 +41,7 @@ static void blk_unplug_timeout(unsigned long data);
>  static void drive_stat_acct(struct request *rq, int nr_sectors, int new_io);
>  static void init_request_from_bio(struct request *req, struct bio *bio);
>  static int __make_request(request_queue_t *q, struct bio *bio);
> -static struct io_context *current_io_context(gfp_t gfp_flags, int node);
> +struct io_context *current_io_context(gfp_t gfp_flags, int node);
>  
>  /*
>   * For the allocated request tables
> @@ -3723,7 +3723,7 @@ void exit_io_context(void)
>   * but since the current task itself holds a reference, the context can be
>   * used in general code, so long as it stays within `current` context.
>   */
> -static struct io_context *current_io_context(gfp_t gfp_flags, int node)
> +struct io_context *current_io_context(gfp_t gfp_flags, int node)
>  {
>  	struct task_struct *tsk = current;
>  	struct io_context *ret;

There are no users outside ll_rw_blk.c, so the export just needs to be
removed.

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 1e853f4..b085d0e 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -3807,7 +3807,6 @@ static struct io_context *current_io_context(gfp_t gfp_flags, int node)
 
 	return ret;
 }
-EXPORT_SYMBOL(current_io_context);
 
 /*
  * If the current task has no IO context then create one and initialise it.

-- 
Jens Axboe

