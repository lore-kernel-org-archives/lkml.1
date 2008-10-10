Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbYJJKHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbYJJKHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYJJKHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:07:20 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39029 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbYJJKHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:07:19 -0400
Date: Fri, 10 Oct 2008 12:06:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: torvalds@linux-foundation.org, stable@kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: splice vs O_APPEND
Message-ID: <20081010100643.GZ19428@kernel.dk>
References: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org> <E1Knxzm-0003y2-Jy@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090908200.3210@nehalem.linux-foundation.org> <E1KnyOw-00044y-K4@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810091218300.3210@nehalem.linux-foundation.org> <E1Ko1Xu-0004vP-EX@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810091411520.3210@nehalem.linux-foundation.org> <E1KoEZM-0007Fb-5i@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KoEZM-0007Fb-5i@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10 2008, Miklos Szeredi wrote:
> On Thu, 9 Oct 2008, Linus Torvalds wrote:
> > On Thu, 9 Oct 2008, Miklos Szeredi wrote:
> > > 
> > > The thing is, the append-only attribute is absolutely useless without
> > > being able to depend on it.  So in that sense I think the IS_APPEND
> > > issue is important, and I'm fine with your original proposal for that
> > > (except we don't need the IS_IMMUTABLE check).
> > 
> > Heh. In the meantime, I had grown to hate that more complex patch.
> > 
> > So because I do see your point with IS_APPEND (being different from 
> > O_APPEND), but because I also think that O_APPEND itself is a gray and 
> > murky area, I just committed the following. I doubt anybody will ever even 
> > notice it, but while I think it's all debatable, we might as well debate 
> > it with this in place. I do agree that it's "safer" behaviour.
> 
> Thanks.
> 
> I suspect this qualifies for stable kernels too.  Stable team, can you
> please add this to your queue?
> 
> The final commit is:
> 
> commit efc968d450e013049a662d22727cf132618dcb2f
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
>     Acked-by: Jens Axboe <ens.axboe@oracle.com>

And lets then change this to <jens.axboe@oracle.com>

:-)


>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
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

