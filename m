Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbZASKQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbZASKQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 05:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758297AbZASKQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 05:16:39 -0500
Received: from brick.kernel.dk ([93.163.65.50]:4840 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386AbZASKQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 05:16:39 -0500
Date: Mon, 19 Jan 2009 11:15:10 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 1/1] relay: fix lock imbalance in relay_late_setup_files
Message-ID: <20090119101509.GG30821@kernel.dk>
References: <1232190276-21200-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232190276-21200-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17 2009, Jiri Slaby wrote:
> One fail path in relay_late_setup_files() omits
> mutex_unlock(&relay_channels_mutex);
> Add it.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> Cc: Jens Axboe <axboe@suse.de>
> ---
>  kernel/relay.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)

Looks good, applied!

> 
> diff --git a/kernel/relay.c b/kernel/relay.c
> index 8ca1587..738bc85 100644
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -714,8 +714,10 @@ int relay_late_setup_files(struct rchan *chan,
>  
>  	mutex_lock(&relay_channels_mutex);
>  	/* Is chan already set up? */
> -	if (unlikely(chan->has_base_filename))
> +	if (unlikely(chan->has_base_filename)) {
> +		mutex_unlock(&relay_channels_mutex);
>  		return -EEXIST;
> +	}
>  	chan->has_base_filename = 1;
>  	chan->parent = parent;
>  	curr_cpu = get_cpu();
> -- 
> 1.6.1
> caught by stanse
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jens Axboe

