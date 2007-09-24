Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbXIXI0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbXIXI0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 04:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbXIXI0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 04:26:13 -0400
Received: from www.osadl.org ([213.239.205.134]:36538 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751811AbXIXI0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 04:26:12 -0400
Subject: Re: [patch 1/3] new timerfd API - new timerfd API
From: Thomas Gleixner <tglx@linutronix.de>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <send-serie.davidel@xmailserver.org.19354.1190587749.1>
References: <send-serie.davidel@xmailserver.org.19354.1190587749.1>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 10:26:04 +0200
Message-Id: <1190622364.4035.182.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide,

On Sun, 2007-09-23 at 15:49 -0700, Davide Libenzi wrote:
> This is the new timerfd API as it is implemented by the following patch:
> ---
>  fs/compat.c              |   32 ++++++-
>  fs/timerfd.c             |  199 ++++++++++++++++++++++++++++++-----------------
>  include/linux/compat.h   |    7 +
>  include/linux/syscalls.h |    7 +
>  4 files changed, 168 insertions(+), 77 deletions(-)
> 
> Index: linux-2.6.mod/fs/timerfd.c
> ===================================================================
> --- linux-2.6.mod.orig/fs/timerfd.c	2007-09-23 15:18:09.000000000 -0700
> +++ linux-2.6.mod/fs/timerfd.c	2007-09-23 15:25:55.000000000 -0700
> @@ -23,15 +23,17 @@
>  
>  struct timerfd_ctx {
>  	struct hrtimer tmr;
> +	int clockid;
>  	ktime_t tintv;
>  	wait_queue_head_t wqh;
>  	int expired;
> +	u64 ticks;
>  };

Can you please restructure the struct in a way which does not result in
padding by the compiler ?

struct timerfd_ctx {
	struct hrtimer tmr;
	ktime_t tintv;
	wait_queue_head_t wqh;
	u64 ticks;
	int expired;
	int clockid;
};

> +			ticks += (u64)
>  				hrtimer_forward(&ctx->tmr,
>  						hrtimer_cb_get_time(&ctx->tmr),

You need to use ctx->tmr.base->get_time() here, otherwise you might read
a stale time value (in case that CONFIG_HIGH_RES_TIMERS is off).

> -						ctx->tintv);
> +						ctx->tintv) - 1;
>  			hrtimer_restart(&ctx->tmr);
>
> +asmlinkage long sys_timerfd_create(int clockid)
>  {
> -	int error;
> +	int error, ufd;
>  	struct timerfd_ctx *ctx;
>  	struct file *file;
>  	struct inode *inode;
> -	struct itimerspec ktmr;
> -
> -	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
> -		return -EFAULT;
>  
>  	if (clockid != CLOCK_MONOTONIC &&
>  	    clockid != CLOCK_REALTIME)
>  		return -EINVAL;
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	init_waitqueue_head(&ctx->wqh);
> +	ctx->clockid = clockid;
> +	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
> +
> +	error = anon_inode_getfd(&ufd, &inode, &file, "[timerfd]",
> +				 &timerfd_fops, ctx);
> +	if (error)
> +		goto err_kfree_ctx;
> +
> +	return ufd;
> +
> +err_kfree_ctx:
> +	kfree(ctx);
> +	return error;

You really can avoid the goto here.

	tglx


