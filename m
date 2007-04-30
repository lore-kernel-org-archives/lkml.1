Return-Path: <linux-kernel-owner+w=401wt.eu-S1161649AbXD3Gxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161649AbXD3Gxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 02:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161651AbXD3Gxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 02:53:53 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:53689 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161649AbXD3Gxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 02:53:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qsJ0bLCPqLPgn4wHMQZWB9ZCi4dC7yw8r4I8jkzEoflSlSnKh0K4m1EPVoCUzPwJBxb2PkGwYYZYTIBdAomaADWBc2qsvaSHVqLIIJph1ROsJfWAmZjG3636pnm6I8fNTuW0bTvy63tpgEeU6LB+BotMcan/k+O14W0fTCiVnjI=
Message-ID: <a781481a0704292353v34ea217fpbbf732465dd652e8@mail.gmail.com>
Date: Mon, 30 Apr 2007 12:23:50 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH] zero_user_page uses in fs/buffer.c and fs/libfs.c
Cc: akpm@linux-foundation.org, "Nate Diller" <nate.diller@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704292313060.3018@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704292313060.3018@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/07, Christoph Lameter <clameter@sgi.com> wrote:
> There are a couple of places where kmap_atomic is surrounding two
> memory operations. Usually only one of them is performed. So it is
> possible to also use zero_user_page there.

I do like the patch, but would prefer if you'd give a better/correct
rationale here. "Usually only one of them is performed" is not exactly
correct to say, as it is perfectly (and frequently so) possible for
both of (block_end > to) and (block_start < from) to be true for the
same page for the prepare_write cases.

A simple "Replace open-coded kmap_atomic() and kunmap_atomic()
surrounding two memory clear operations with zero_user_page(), as both
memory operations act on the same page" would have been better.

Perhaps you were more worried with the additional overhead of two
successive kmap_atomic() and kunmap_atomic() calls for the same page
in the two resulting zero_user_page()'s (if both conditions evaluate
to true for the same page), but that would still be a price to pay to
replace the current open-coding.

> --- linux-2.6.21-rc7-mm1.orig/fs/libfs.c        2007-04-25 00:24:10.000000000 -0700
> +++ linux-2.6.21-rc7-mm1/fs/libfs.c     2007-04-25 00:25:56.000000000 -0700
> @@ -337,12 +337,12 @@ int simple_prepare_write(struct file *fi
>                         unsigned from, unsigned to)
>  {
>         if (!PageUptodate(page)) {
> -               if (to - from != PAGE_CACHE_SIZE) {
> -                       void *kaddr = kmap_atomic(page, KM_USER0);
> -                       memset(kaddr, 0, from);
> -                       memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
> -                       flush_dcache_page(page);
> -                       kunmap_atomic(kaddr, KM_USER0);
> +               if (to - from != PAGE_CACHE_SIZE)
> +                       if (from)
> +                               zero_user_page(page, 0, from, KM_USER0);
> +                       if (to < PAGE_CACHE_SIZE)
> +                               zero_user_page(page, to,
> +                                       PAGE_CACHE_SIZE - to, KM_USER0);

Why the two additional condition checks? The previous code didn't have
(or need) them, so this patch clearly does something more than simply
replacing open-coding with zero_user_page().

Either you've fixed an issue (in which case this should've been a
different patch with the accompanying explanation) or else I don't see
what we gain with the additional if's. Again, we still do incur the
overhead of two successive kmap_atomic() / kunmap_atomic() calls for
the same page in order to replace the open-coding.
