Return-Path: <linux-kernel-owner+w=401wt.eu-S932399AbZKCByO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbZKCByO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 20:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbZKCByN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 20:54:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754282AbZKCByN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 20:54:13 -0500
Date: Mon, 2 Nov 2009 17:54:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pps: locking scheme fix up for PPS_GETPARAMS.
Message-Id: <20091102175409.3fad4d64.akpm@linux-foundation.org>
In-Reply-To: <1257005003-9889-1-git-send-email-giometti@linux.it>
References: <1257005003-9889-1-git-send-email-giometti@linux.it>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Oct 2009 17:03:23 +0100
Rodolfo Giometti <giometti@linux.it> wrote:

> Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> Tested-by: Reg Clemens <clemens@dwf.com>

Please don't send unchangelogged patches.

> 
> diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
> index fea17e7..ca5183b 100644
> --- a/drivers/pps/pps.c
> +++ b/drivers/pps/pps.c
> @@ -71,9 +71,14 @@ static long pps_cdev_ioctl(struct file *file,
>  	case PPS_GETPARAMS:
>  		pr_debug("PPS_GETPARAMS: source %d\n", pps->id);
>  
> -		/* Return current parameters */
> -		err = copy_to_user(uarg, &pps->params,
> -						sizeof(struct pps_kparams));
> +		spin_lock_irq(&pps->lock);
> +
> +		/* Get the current parameters */
> +		params = pps->params;
> +
> +		spin_unlock_irq(&pps->lock);
> +
> +		err = copy_to_user(uarg, &params, sizeof(struct pps_kparams));
>  		if (err)
>  			return -EFAULT;
>  

OK, I can see what the patch does and I can guess what sort of
situations would trigger it.  But that's really not good enough.

Put yourself in the position of someone who is hitting a PPS bug and
wants to work out if your patch might fix it.  Because the patch fails
to describe the user-visible symptoms (ie: the bug) then that person is
in the dark.

Also, someone (ie: me) needs to decide if this fix is to be backported
into earlier kernels.  With no description of the end-user impact, how
can I possibly do that?
