Return-Path: <linux-kernel-owner+w=401wt.eu-S1760144AbYBSU0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144AbYBSU0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbYBSUZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:25:50 -0500
Received: from brick.kernel.dk ([87.55.233.238]:11882 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbYBSUZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:25:49 -0500
Date: Tue, 19 Feb 2008 21:25:44 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Johann Felix Soden <johfel@gmx.de>
Cc: Patrick McManus <mcmanus@ducksong.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splice: fix problem with sys_tee and SPLICE_F_NONBLOCK
Message-ID: <20080219202543.GK23197@kernel.dk>
References: <1203452091.7758.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203452091.7758.5.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19 2008, Johann Felix Soden wrote:
> From: Johann Felix Soden <johfel@users.sourceforge.net>
> 
> With SPLICE_F_NONBLOCK sys_tee should return number of duplicated bytes,
> not only -EAGAIN on success.

?

The current behaviour is to return bytes tee'd, or return -EAGAIN for
zero bytes if SPLICE_F_NONBLOCK is set. It doesn't return "-EAGAIN on
success", not sure what you mean there.

> This patch also solves the problem, which is described on
> http://article.gmane.org/gmane.linux.kernel/642502.
> 
> Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
> ---
>  fs/splice.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/splice.c b/fs/splice.c
> index 9b559ee..184fd66 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -1711,7 +1711,7 @@ static long do_tee(struct file *in, struct file *out, size_t len,
>  			ret = link_opipe_prep(opipe, flags);
>  			if (!ret) {
>  				ret = link_pipe(ipipe, opipe, len, flags);
> -				if (!ret && (flags & SPLICE_F_NONBLOCK))
> +				if (ret < 0 && (flags & SPLICE_F_NONBLOCK))
>  					ret = -EAGAIN;
>  			}
>  		}

Perhaps it's just me, but this doesn't make a lot of sense. You override
any other error with EAGAIN, hm? In fact the only < 0 value that
link_pipe() will return is -EPIPE, which is perfectly in sync with that
a pipe write will return if there are no readers attached.

-- 
Jens Axboe

