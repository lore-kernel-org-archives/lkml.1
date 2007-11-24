Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbXKXFPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbXKXFPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 00:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbXKXFPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 00:15:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:4455 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbXKXFPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 00:15:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=u7GC3OMnG70cWpGPaDUlyL1xuxMXmk44ybjbp+ev04nD+tyUsSk+UhKIR4jroQKK6yUKgY/W4AfxD/AmrlDbwM/mac0lcYScT3wN31DUquIH+zm76ers/3oOeZXx+/z6idbSjimamBuoza32BhpmbC2bVlQFhg2/oELnbVRGJeg=
Message-ID: <4747B3F0.2020705@gmail.com>
Date: Sat, 24 Nov 2007 06:17:36 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/4] Timerfd v2 - new timerfd API
References: <send-serie.davidel@xmailserver.org.6855.1195854702.2>
In-Reply-To: <send-serie.davidel@xmailserver.org.6855.1195854702.2>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

[...]

> +asmlinkage long sys_timerfd_create(int clockid, int flags)
>  {
> -	int error;
> +	int error, ufd;
>  	struct timerfd_ctx *ctx;
>  	struct file *file;
>  	struct inode *inode;
> -	struct itimerspec ktmr;
> -
> -	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
> -		return -EFAULT;
>  
>  	if (clockid != CLOCK_MONOTONIC &&
>  	    clockid != CLOCK_REALTIME)
>  		return -EINVAL;

Could I suggest here, the following placeholder addition:

	if (flags != 0)
		return -EINVAL;

Later than can replaced with something like:

	if (flags & ~(O_NONBLOCK | O_CLOEXEC))
		return -EINVAL;

Having the first of the checks above will allow userland to determine what
is implemented, rather than having non-zero flags silently ignored.

Cheers,

Michael

> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	init_waitqueue_head(&ctx->wqh);
> +	ctx->clockid = clockid;
> +	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
> +
> +	error = anon_inode_getfd(&ufd, &inode, &file, "[timerfd]",
> +				 &timerfd_fops, ctx);
> +	if (error) {
> +		kfree(ctx);
> +		return error;
> +	}
> +
> +	return ufd;
> +}

