Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbYBTKHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbYBTKHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 05:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758013AbYBTKHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 05:07:44 -0500
Received: from mail.gmx.net ([213.165.64.20]:39867 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751984AbYBTKHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 05:07:43 -0500
X-Authenticated: #36809985
X-Provags-ID: V01U2FsdGVkX18zPLlz56IzbI8rG11EN5WnCuDyhYeiV7FqujkNNR
	K+6qPF6eb7vjC9
Date: Wed, 20 Feb 2008 11:07:26 +0100
From: "Johann Felix v. Soden-Fr." <johfel@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Johann Felix Soden <johfel@gmx.de>, Patrick McManus <mcmanus@ducksong.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splice: fix problem with sys_tee and SPLICE_F_NONBLOCK
Message-ID: <20080220100726.GA18161@LAPJFS>
References: <1203452091.7758.5.camel@localhost> <20080219202543.GK23197@kernel.dk> <1203455538.7758.17.camel@localhost> <20080219212530.GN23197@kernel.dk> <1203457661.7758.31.camel@localhost> <20080220093528.GU23197@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220093528.GU23197@kernel.dk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 10:35:28AM +0100, Jens Axboe wrote:
> On Tue, Feb 19 2008, Johann Felix Soden wrote:
> > 
> > Am Dienstag, den 19.02.2008, 22:25 +0100 schrieb Jens Axboe:
> > > On Tue, Feb 19 2008, Johann Felix Soden wrote:
> > > > > On Tue, Feb 19 2008, Johann Felix Soden wrote:
> > > > > > From: Johann Felix Soden <johfel@users.sourceforge.net>
> > > > > > 
> > > > > > With SPLICE_F_NONBLOCK sys_tee should return number of duplicated bytes,
> > > > > > not only -EAGAIN on success.
> > > > > 
> > > > > ?
> > > > > 
> > > > > The current behaviour is to return bytes tee'd, or return -EAGAIN for
> > > > > zero bytes if SPLICE_F_NONBLOCK is set. It doesn't return "-EAGAIN on
> > > > > success", not sure what you mean there.
> > > > > 
> > > > Sorry, my patch description was not correct. 
> > > > 
> > > > The new behavior of sys_tee with my patch is: 
> > > > 	- return -EAGAIN if there are no data in the pipe, but writer
> > > > 	  connected to the pipe, 
> > > > 	- return 0 if there are not writers connected
> > > > 	- else return number of duplicated byte 
> > > > 
> > > > The old behavior was: return -EAGAIN or the number (>0) of duplicated
> > > > bytes.
> > > 
> > > Your patch has an odd way of achieving that goal, modify the real
> > > location of the assignment instead of overriding something. That has the
> > > potential to turn into another confusing bug later on, wondering why the
> > > heck your return value isn't being passed back.
> > > 
> > > Improvement is welcome though, you can't distuingish -EAGAIN on the
> > > input side from the output side currently.
> > > 
> When non-blocking is set, ideally we want to return 0 if there's no hope
> of anymore data and EAGAIN if trying later may yield some data. So how
> about this instead?
> 
> diff --git a/fs/splice.c b/fs/splice.c
> index 9b559ee..0670c91 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -1669,6 +1669,13 @@ static int link_pipe(struct pipe_inode_info *ipipe,
>  		i++;
>  	} while (len);
>  
> +	/*
> +	 * return EAGAIN if we have the potential of some data in the
> +	 * future, otherwise just return 0
> +	 */
> +	if (!ret && ipipe->waiting_writers && (flags & SPLICE_F_NONBLOCK))
> +		ret = -EAGAIN;
> +
>  	inode_double_unlock(ipipe->inode, opipe->inode);
>  
>  	/*
> @@ -1709,11 +1716,8 @@ static long do_tee(struct file *in, struct file *out, size_t len,
>  		ret = link_ipipe_prep(ipipe, flags);
>  		if (!ret) {
>  			ret = link_opipe_prep(opipe, flags);
> -			if (!ret) {
> +			if (!ret)
>  				ret = link_pipe(ipipe, opipe, len, flags);
> -				if (!ret && (flags & SPLICE_F_NONBLOCK))
> -					ret = -EAGAIN;
> -			}
>  		}
>  	}
> 

Thanks! This works great.
Add if you want: Tested-by: Johann Felix Soden <johfel@users.sourceforge.net>

---
Johann Felix Soden

