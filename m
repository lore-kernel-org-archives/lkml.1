Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbYJJKYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbYJJKYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYJJKYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:24:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:14288 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYJJKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Oshc7CInVyFnDpxZ+0faw9gLy7E02boEaQXJTJLdQ8Sgje0KH1yILMJk+//NO9Moe2
         d9bPTpkkCXTsdOy43DzMZsSS1KXxUYgsZpobykQvXEEIK0a5/X8HqCmX1jeiTwwTIw35
         GafcIP4Q/uv5VMOreMgcfKTCFeNFwQGHXAMgY=
Message-ID: <517f3f820810100323l1cc4c361g25f17ebc1461b6bb@mail.gmail.com>
Date: Fri, 10 Oct 2008 12:23:58 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: splice vs O_APPEND
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-api@vger.kernel.org, mtk.manpages@gmail.com
In-Reply-To: <alpine.LFD.2.00.0810091411520.3210@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu>
	 <alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org>
	 <E1Knxzm-0003y2-Jy@pomaz-ex.szeredi.hu>
	 <alpine.LFD.2.00.0810090908200.3210@nehalem.linux-foundation.org>
	 <E1KnyOw-00044y-K4@pomaz-ex.szeredi.hu>
	 <alpine.LFD.2.00.0810091218300.3210@nehalem.linux-foundation.org>
	 <E1Ko1Xu-0004vP-EX@pomaz-ex.szeredi.hu>
	 <alpine.LFD.2.00.0810091411520.3210@nehalem.linux-foundation.org>
X-Google-Sender-Auth: 28677548e8012a13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

On Thu, Oct 9, 2008 at 11:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 9 Oct 2008, Miklos Szeredi wrote:
>>
>> The thing is, the append-only attribute is absolutely useless without
>> being able to depend on it.  So in that sense I think the IS_APPEND
>> issue is important, and I'm fine with your original proposal for that
>> (except we don't need the IS_IMMUTABLE check).
>
> Heh. In the meantime, I had grown to hate that more complex patch.
>
> So because I do see your point with IS_APPEND (being different from
> O_APPEND), but because I also think that O_APPEND itself is a gray and
> murky area, I just committed the following. I doubt anybody will ever even
> notice it, but while I think it's all debatable, we might as well debate
> it with this in place. I do agree that it's "safer" behaviour.

Please do CC linux-api@vger (and if you are kind, me, in case
something needs to go into man-pages) on interface changes.

Cheers,

Michael

> ---
> commit a05b4085484ac45558810e4c5928e5a291c20f65
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Thu Oct 9 14:04:54 2008 -0700
>
>    Don't allow splice() to files opened with O_APPEND
>
>    This is debatable, but while we're debating it, let's disallow the
>    combination of splice and an O_APPEND destination.
>
>    It's not entirely clear what the semantics of O_APPEND should be, and
>    POSIX apparently expects pwrite() to ignore O_APPEND, for example.  So
>    we could make up any semantics we want, including the old ones.
>
>    But Miklos convinced me that we should at least give it some thought,
>    and that accepting writes at arbitrary offsets is wrong at least for
>    IS_APPEND() files (which always have O_APPEND set, even if the reverse
>    isn't true: you can obviously have O_APPEND set on a regular file).
>
>    So disallow O_APPEND entirely for now.  I doubt anybody cares, and this
>    way we have one less gray area to worry about.
>
>    Reported-and-argued-for-by: Miklos Szeredi <miklos@szeredi.hu>
>    Cc: Jens Axboe <ens.axboe@oracle.com>
>    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> diff --git a/fs/splice.c b/fs/splice.c
> index 1bbc6f4..a1e701c 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -898,6 +898,9 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
>        if (unlikely(!(out->f_mode & FMODE_WRITE)))
>                return -EBADF;
>
> +       if (unlikely(out->f_flags & O_APPEND))
> +               return -EINVAL;
> +
>        ret = rw_verify_area(WRITE, out, ppos, len);
>        if (unlikely(ret < 0))
>                return ret;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/ Found a documentation bug?
http://www.kernel.org/doc/man-pages/reporting_bugs.html
