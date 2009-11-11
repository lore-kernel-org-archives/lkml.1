Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbZKKKer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbZKKKer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 05:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZKKKeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 05:34:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49686 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbZKKKep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 05:34:45 -0500
Date: Wed, 11 Nov 2009 11:34:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Romit Dasgupta <romit@ti.com>
Cc: jens.axboe@oracle.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 1/1]: Thaws refrigerated bdi flusher threads before
 invoking kthread_stop on them
Message-ID: <20091111103444.GD26423@elf.ucw.cz>
References: <1257928216.15415.57.camel@boson>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257928216.15415.57.camel@boson>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-11-11 14:00:16, Romit Dasgupta wrote:
> Kicks out frozen bdi flusher task out of the refrigerator when the flusher task
> needs to exit.


> Signed-off-by: Romit Dasgupta <romit@ti.com>

Ok, its slightly "interesting", but better than modifying common
code. Looks ok to me.

ACK.
								Pavel

> ---
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 5a37e20..c757b05 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -606,8 +606,11 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
>  	 * Finally, kill the kernel threads. We don't need to be RCU
>  	 * safe anymore, since the bdi is gone from visibility.
>  	 */
> -	list_for_each_entry(wb, &bdi->wb_list, list)
> +	list_for_each_entry(wb, &bdi->wb_list, list) {
> +		if (unlikely(frozen(wb->task)))
> +			wb->task->flags &= ~PF_FROZEN;
>  		kthread_stop(wb->task);
> +	}
>  }
>  
>  void bdi_unregister(struct backing_dev_info *bdi)
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
