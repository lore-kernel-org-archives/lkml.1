Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbYBJMjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbYBJMjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 07:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbYBJMjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 07:39:09 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:7833 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbYBJMjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 07:39:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CmRdA8wd9J6xoM8f7cwjIf+qP3s2Pv0oaymSVtJEr3vhUcTghLEBTGmJzRO8vtP1dSiM98dbSNDy+k4i31TdxKQMvKt5LOlUpAOmzD7uA90150b4kAlOcO/SAStXp+EAQXm1ezGxEbLU2Q2sYprxNtc4ZPu5m8/9CGfxvvHoMb0=
Message-ID: <2e77fc10802100439u18e89008j9181f3b445daa231@mail.gmail.com>
Date: Sun, 10 Feb 2008 12:39:05 +0000
From: "Niki Denev" <ndenev@gmail.com>
To: "Bastian Blank" <bastian@waldi.eu.org>, "Willy Tarreau" <w@1wt.eu>,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] kernel 2.6.24.1 still vulnerable to the vmsplice local root exploit
In-Reply-To: <20080210122250.GA24048@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2e77fc10802092204t7764ff12s65304f70500e2090@mail.gmail.com>
	 <20080210063247.GQ8953@1wt.eu>
	 <2e77fc10802092238k13efb111ifcd298daaf7b4aba@mail.gmail.com>
	 <2e77fc10802100140q5c8adfb4k7db88d48cbd5f8b2@mail.gmail.com>
	 <20080210122250.GA24048@wavehammer.waldi.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 12:22 PM, Bastian Blank <bastian@waldi.eu.org> wrote:
> On Sun, Feb 10, 2008 at 04:40:53AM -0500, Niki Denev wrote:
> > this fixed the problem for me (kernel 2.6.24.1) :
> > It appears that the initial patch checked the input to vmsplice_to_user,
> > but the exploit used vmsplice_to_pipe which remained open to the attack.
>
> This patch is broken. It opens the old hole again.
>
> > @@ -1450,6 +1454,31 @@
> >               .ops = &user_page_pipe_buf_ops,
> >       };
> >
> > +     error = ret = 0;
> > +
> > +     /*
> > +      * Get user address base and length for this iovec.
> > +      */
> > +     error = get_user(base, &iov->iov_base);
> > +     if (unlikely(error))
> > +             return error;
> > +     error = get_user(len, &iov->iov_len);
> > +     if (unlikely(error))
> > +             return error;
>
> iov is unchecked.
>
> > +     if (unlikely(!access_ok(VERIFY_WRITE, base, len))) {
> > +             return -EFAULT;
> > +     }
>
> Use VERIFY_READ and this only checks the first entry.
>
> I checked the following patch and it at least fixes the known exploit.
>
> diff --git a/fs/splice.c b/fs/splice.c
> index 14e2262..80beb2b 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -1237,6 +1237,11 @@ static int get_iovec_page_array(const struct iovec __user *iov,
>                 if (unlikely(!base))
>                         break;
>
> +               if (!access_ok(VERIFY_READ, base, len)) {
> +                       error = -EFAULT;
> +                       break;
> +               }
> +
>                 /*
>                  * Get this base offset and number of pages, then map
>                  * in the user pages.
> --
> Even historians fail to learn from history -- they repeat the same mistakes.
>                 -- John Gill, "Patterns of Force", stardate 2534.7
>

This patch is against 2.6.24.1 which has already the fix to vmsplice_to_user
With it i can't exploit the hole, and it is returns "invalid address"
