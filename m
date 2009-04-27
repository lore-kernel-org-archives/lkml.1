Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbZD0Lqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbZD0Lqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbZD0Lqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:46:34 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47780 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbZD0Lqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:46:34 -0400
Date: Mon, 27 Apr 2009 13:46:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cleanup: Remove unused __REQ_NR_BITS from enum
	rq_flag_bits
Message-ID: <20090427114633.GA4593@kernel.dk>
References: <200904271705.30550.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904271705.30550.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27 2009, Nikanth Karthikesan wrote:
> The __REQ_NR_BITS  was being used by blk_dump_rq_flags() long back, while 
> printing the individual request flag bits as strings to limit to the used 
> bits. But it does not use it now. Remove unused enum.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> ---
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index ba54c83..f41abbb 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -118,7 +118,6 @@ enum rq_flag_bits {
>  	__REQ_COPY_USER,	/* contains copies of user pages */
>  	__REQ_INTEGRITY,	/* integrity metadata has been remapped */
>  	__REQ_NOIDLE,		/* Don't anticipate more IO after this one */
> -	__REQ_NR_BITS,		/* stops here */
>  };
>  
>  #define REQ_RW		(1 << __REQ_RW)

Lets turn it into something useful instead. It's meant to catch someone
adding too many flags, how about something like this:

Untested ;-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d73eb76..e62ef94 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2159,6 +2159,8 @@ EXPORT_SYMBOL(kblockd_schedule_work);
 
 int __init blk_dev_init(void)
 {
+	BUILD_BUG_ON(__REQ_NR_BITS > 8 * sizeof(int));
+
 	kblockd_workqueue = create_workqueue("kblockd");
 	if (!kblockd_workqueue)
 		panic("Failed to create kblockd\n");

-- 
Jens Axboe

