Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbXJYDoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbXJYDoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbXJYDoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:44:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57386 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669AbXJYDoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:44:09 -0400
Date: Wed, 24 Oct 2007 20:43:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       "linux-aio@kvack.org" <linux-aio@kvack.org>
Subject: Re: [PATCH 5/5] Make wait_on_retry_sync_kiocb killable
Message-Id: <20071024204357.d71e8ad4.akpm@linux-foundation.org>
In-Reply-To: <11932286982021-git-send-email-matthew@wil.cx>
References: <11932286982175-git-send-email-matthew@wil.cx>
	<11932286982021-git-send-email-matthew@wil.cx>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 08:24:58 -0400 Matthew Wilcox <matthew@wil.cx> wrote:

> Use TASK_KILLABLE to allow wait_on_retry_sync_kiocb to return -EINTR.
> All callers then check the return value and break out of their loops.
> 

Let's cc the AIO list on AIO patches, please.

> ---
>  fs/read_write.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 124693e..3196a3b 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -218,14 +218,15 @@ Einval:
>  	return -EINVAL;
>  }
>  
> -static void wait_on_retry_sync_kiocb(struct kiocb *iocb)
> +static int wait_on_retry_sync_kiocb(struct kiocb *iocb)
>  {
> -	set_current_state(TASK_UNINTERRUPTIBLE);
> +	set_current_state(TASK_KILLABLE);
>  	if (!kiocbIsKicked(iocb))
>  		schedule();
>  	else
>  		kiocbClearKicked(iocb);
>  	__set_current_state(TASK_RUNNING);
> +	return fatal_signal_pending(current) ? -EINTR : 0;
>  }
>  
>  ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos)
> @@ -242,7 +243,9 @@ ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *pp
>  		ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
>  		if (ret != -EIOCBRETRY)
>  			break;
> -		wait_on_retry_sync_kiocb(&kiocb);
> +		ret = wait_on_retry_sync_kiocb(&kiocb);
> +		if (ret)
> +			break;
>  	}
>  
>  	if (-EIOCBQUEUED == ret)
> @@ -300,7 +303,9 @@ ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, lof
>  		ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
>  		if (ret != -EIOCBRETRY)
>  			break;
> -		wait_on_retry_sync_kiocb(&kiocb);
> +		ret = wait_on_retry_sync_kiocb(&kiocb);
> +		if (ret)
> +			break;
>  	}
>  
>  	if (-EIOCBQUEUED == ret)
> @@ -466,7 +471,9 @@ ssize_t do_sync_readv_writev(struct file *filp, const struct iovec *iov,
>  		ret = fn(&kiocb, iov, nr_segs, kiocb.ki_pos);
>  		if (ret != -EIOCBRETRY)
>  			break;
> -		wait_on_retry_sync_kiocb(&kiocb);
> +		ret = wait_on_retry_sync_kiocb(&kiocb);
> +		if (ret)
> +			break;
>  	}
>  
>  	if (ret == -EIOCBQUEUED)
> -- 
> 1.4.4.2
