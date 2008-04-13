Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbYDMM34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbYDMM34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 08:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbYDMM3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 08:29:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:6458 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798AbYDMM3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 08:29:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OQI9sDviefrWVvfpGkgrZSMnda5WY0jhxQjbgb9mhJvjIzWM+TbWrT81W9KyNuquRPspsj5nMrhD1euxC6hqLjsRkkA2z+QTT6/i1MhBa3Ko/DIXKb3N8IC3KBXw6IQO0cqfV4ETVzO1yXcbgIQ2vt/hMj/YP/ceKExAh77R5YE=
Message-ID: <6101e8c40804130529k353a46a9h8ed1b5fbf6451297@mail.gmail.com>
Date: Sun, 13 Apr 2008 14:29:46 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch] eventfd/kaio integration fix
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Jeff Roberson" <jroberson@chesapeake.net>
In-Reply-To: <Pine.LNX.4.64.0804091138050.7000@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0804091138050.7000@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for 2.6.22.y ?

On 4/9/08, Davide Libenzi <davidel@xmailserver.org> wrote:
> Jeff Roberson discovered a race when using kaio eventfd based
> notifications. This patch fixes the race by moving the notification inside
> the spinlocked section of kaio. The operation is safe since eventfd
> spinlock and kaio one are unrelated.
>
>
>
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
>
>
> - Davide
>
>
> ---
>  fs/aio.c |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> Index: linux-2.6.mod/fs/aio.c
> ===================================================================
> --- linux-2.6.mod.orig/fs/aio.c	2008-04-08 16:25:27.000000000 -0700
> +++ linux-2.6.mod/fs/aio.c	2008-04-09 11:37:10.000000000 -0700
> @@ -936,14 +936,6 @@
>  		return 1;
>  	}
>
> -	/*
> -	 * Check if the user asked us to deliver the result through an
> -	 * eventfd. The eventfd_signal() function is safe to be called
> -	 * from IRQ context.
> -	 */
> -	if (!IS_ERR(iocb->ki_eventfd))
> -		eventfd_signal(iocb->ki_eventfd, 1);
> -
>  	info = &ctx->ring_info;
>
>  	/* add a completion event to the ring buffer.
> @@ -992,6 +984,15 @@
>  	kunmap_atomic(ring, KM_IRQ1);
>
>  	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
> +
> +	/*
> +	 * Check if the user asked us to deliver the result through an
> +	 * eventfd. The eventfd_signal() function is safe to be called
> +	 * from IRQ context.
> +	 */
> +	if (!IS_ERR(iocb->ki_eventfd))
> +		eventfd_signal(iocb->ki_eventfd, 1);
> +
>  put_rq:
>  	/* everything turned out well, dispose of the aiocb. */
>  	ret = __aio_put_req(ctx, iocb);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
