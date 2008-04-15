Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbYDOHYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbYDOHYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbYDOHYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:24:07 -0400
Received: from brick.kernel.dk ([87.55.233.238]:13965 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbYDOHYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:24:06 -0400
Date: Tue, 15 Apr 2008 09:24:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] increment nr_tasks in io_context when CLONE_IO is set
Message-ID: <20080415072400.GA12774@kernel.dk>
References: <1208231425.27984.9.camel@zero100.blr.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208231425.27984.9.camel@zero100.blr.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15 2008, Nikanth Karthikesan wrote:
> Increment the nr_tasks associated with the io_context when CLONE_IO flag
> is set.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> --
> diff --git a/kernel/fork.c b/kernel/fork.c
> index dd249c3..01e843b 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -812,6 +812,7 @@ static int copy_io(unsigned long clone_f
>  		tsk->io_context = ioc_task_link(ioc);
>  		if (unlikely(!tsk->io_context))
>  			return -ENOMEM;
> +		atomic_inc(&tsk->io_context->nr_tasks);
>  	} else if (ioprio_valid(ioc->ioprio)) {
>  		tsk->io_context = alloc_io_context(GFP_KERNEL, -1);
>  		if (unlikely(!tsk->io_context))

Fix is correct, however it would be more appropriate in ioc_task_link()
instead.

diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index cac4b36..2b7a118 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -91,8 +91,10 @@ static inline struct io_context *ioc_task_link(struct io_context *ioc)
 	 * if ref count is zero, don't allow sharing (ioc is going away, it's
 	 * a race).
 	 */
-	if (ioc && atomic_inc_not_zero(&ioc->refcount))
+	if (ioc && atomic_inc_not_zero(&ioc->refcount)) {
+		atomic_inc(&ioc->nr_tasks);
 		return ioc;
+	}
 
 	return NULL;
 }

-- 
Jens Axboe

