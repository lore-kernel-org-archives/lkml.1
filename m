Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYJIVVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYJIVVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbYJIVV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:21:29 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57896 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432AbYJIVV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:21:28 -0400
Date: Thu, 9 Oct 2008 23:20:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: splice vs O_APPEND
Message-ID: <20081009212052.GS19428@kernel.dk>
References: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org> <E1Knxzm-0003y2-Jy@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090908200.3210@nehalem.linux-foundation.org> <E1KnyOw-00044y-K4@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810091218300.3210@nehalem.linux-foundation.org> <E1Ko1Xu-0004vP-EX@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810091411520.3210@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810091411520.3210@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09 2008, Linus Torvalds wrote:
> 
> 
> On Thu, 9 Oct 2008, Miklos Szeredi wrote:
> > 
> > The thing is, the append-only attribute is absolutely useless without
> > being able to depend on it.  So in that sense I think the IS_APPEND
> > issue is important, and I'm fine with your original proposal for that
> > (except we don't need the IS_IMMUTABLE check).
> 
> Heh. In the meantime, I had grown to hate that more complex patch.
> 
> So because I do see your point with IS_APPEND (being different from 
> O_APPEND), but because I also think that O_APPEND itself is a gray and 
> murky area, I just committed the following. I doubt anybody will ever even 
> notice it, but while I think it's all debatable, we might as well debate 
> it with this in place. I do agree that it's "safer" behaviour.
> 
> 		Linus
> 
> ---
> commit a05b4085484ac45558810e4c5928e5a291c20f65
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Thu Oct 9 14:04:54 2008 -0700
> 
>     Don't allow splice() to files opened with O_APPEND
>     
>     This is debatable, but while we're debating it, let's disallow the
>     combination of splice and an O_APPEND destination.
>     
>     It's not entirely clear what the semantics of O_APPEND should be, and
>     POSIX apparently expects pwrite() to ignore O_APPEND, for example.  So
>     we could make up any semantics we want, including the old ones.
>     
>     But Miklos convinced me that we should at least give it some thought,
>     and that accepting writes at arbitrary offsets is wrong at least for
>     IS_APPEND() files (which always have O_APPEND set, even if the reverse
>     isn't true: you can obviously have O_APPEND set on a regular file).
>     
>     So disallow O_APPEND entirely for now.  I doubt anybody cares, and this
>     way we have one less gray area to worry about.
>     
>     Reported-and-argued-for-by: Miklos Szeredi <miklos@szeredi.hu>
>     Cc: Jens Axboe <ens.axboe@oracle.com>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

A little late I see, but FWIW I agree. I doubt that anyone uses splice
with O_APPEND anyways, so should be zero-impact on that account at
least.


> 
> diff --git a/fs/splice.c b/fs/splice.c
> index 1bbc6f4..a1e701c 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -898,6 +898,9 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
>  	if (unlikely(!(out->f_mode & FMODE_WRITE)))
>  		return -EBADF;
>  
> +	if (unlikely(out->f_flags & O_APPEND))
> +		return -EINVAL;
> +
>  	ret = rw_verify_area(WRITE, out, ppos, len);
>  	if (unlikely(ret < 0))
>  		return ret;

-- 
Jens Axboe

