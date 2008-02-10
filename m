Return-Path: <linux-kernel-owner+w=401wt.eu-S1751861AbYBJNsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbYBJNsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 08:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbYBJNsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 08:48:45 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:40957 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbYBJNso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 08:48:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sfka5mXz9wPlBhYExX51lKRYkMn6PjfChT2v0LOTe7Vl+euL+/VNeQcQso0RXeJoUfH4UuLhREeUkoDg+oxwc+EC4WfVZXAkcHADI2IV42+4TIasy7G5BD2n17XxiFaa+nLEsCd2E6CJy6hnEwqlNo+mes1PHRCXOFTz+XHNLgc=
Message-ID: <2e77fc10802100548y4b78ba3fy7e6ef7855b246bed@mail.gmail.com>
Date: Sun, 10 Feb 2008 13:48:39 +0000
From: "Niki Denev" <ndenev@gmail.com>
To: "Bastian Blank" <bastian@waldi.eu.org>, linux-kernel@vger.kernel.org
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

As far as i can see, at least on x86 and x86_64 the first argument to
access_ok : (VERIFY_READ|VERIFY_WRITE) is ignored.
Also even if it is used on different arch, using WRITE instead of READ
should be safe because WRITE is a superset of READ.

You are right that it only catches the first entry.

--Niki
