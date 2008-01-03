Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbYACUE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbYACUE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 15:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYACUEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 15:04:47 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:55664 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbYACUEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 15:04:43 -0500
Message-ID: <477D3FCE.6080005@oracle.com>
Date: Thu, 03 Jan 2008 12:04:30 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: bcrl@kvack.org, linux-aio@kvack.org, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: partial write should not return error code.
References: <200801032004.08907.rusty@rustcorp.com.au>
In-Reply-To: <200801032004.08907.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> When an AIO write gets an error after writing some data (eg. ENOSPC),
> it should return the amount written already, not the error.  Just like
> write() is supposed to.

Andrew, please don't queue this fix.  I think the bug is valid but the
patch is subtly dangerous.

> diff -r 18802689361a fs/aio.c
> --- a/fs/aio.c	Thu Jan 03 15:22:24 2008 +1100
> +++ b/fs/aio.c	Thu Jan 03 18:05:25 2008 +1100
> @@ -1346,6 +1350,13 @@ static ssize_t aio_rw_vect_retry(struct 
>  	/* This means we must have transferred all that we could */
>  	/* No need to retry anymore */
>  	if ((ret == 0) || (iocb->ki_left == 0))
> +		ret = iocb->ki_nbytes - iocb->ki_left;
> +
> +	/* If we managed to write some out we return that, rather than
> +	 * the eventual error. */
> +	if (opcode == IOCB_CMD_PWRITEV
> +	    && ret < 0
> +	    && iocb->ki_nbytes - iocb->ki_left)
>  		ret = iocb->ki_nbytes - iocb->ki_left;

This doesn't account for the (sigh) -EIOCB* error codes.  They must be
returned to the caller so that it can properly handle the iocb reference
counting.  Failure to do so can lead to oopses.

To be fair, I think you'll have a really hard time finding an
->aio_write() implementation which would return partial progress and
*then* one of the magical errnos.  But the infrastructure does allow it.

So maybe we could get a helper in aio.h that abstracts out the

	(ret < 0 && ret != -EIOCBQUEUED && ret != -EIOCBRETRY)

condition.  Then I think this patch would be fine.

I assigned a bug to remind myself to revisit this if you aren't excited
by continuing with the patch:

  http://bugzilla.kernel.org/show_bug.cgi?id=9681

- z
