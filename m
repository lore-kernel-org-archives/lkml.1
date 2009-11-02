Return-Path: <linux-kernel-owner+w=401wt.eu-S932221AbZKBSlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbZKBSlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbZKBSlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:41:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39271 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788AbZKBSly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:41:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Dasgupta, Romit" <romit@ti.com>
Subject: Re: [PATCH 1/1] PM: Making bdi threads non-freezable
Date: Mon, 2 Nov 2009 19:43:49 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <B85A65D85D7EB246BE421B3FB0FBB59301DE1EBC66@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59301DE1EBC66@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911021943.49943.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 November 2009, Dasgupta, Romit wrote:
> Fixes the case when bdi threads are in the refrigerator but file system sync
> can happen after this. This is possible in MMC when CONFIG_MMC_UNSAFE_RESUME is
> not set.

What's going to happen if we attemt to suspend the underlying block device(s)
when the bdi thread are doing their job?  Is there any synchronisation
mechanism for that?

Rafael


> Signed-off-by: Romit Dasgupta <romit@ti.com>
> ---
>  
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 9d5360c..661229d 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -956,7 +956,6 @@ int bdi_writeback_task(struct bdi_writeback *wb)
>  
>  		wait_jiffies = msecs_to_jiffies(dirty_writeback_interval * 10);
>  		schedule_timeout_interruptible(wait_jiffies);
> -		try_to_freeze();
>  	}
>  
>  	return 0;
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 5a37e20..9383271 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -273,7 +273,6 @@ static void bdi_task_init(struct backing_dev_info *bdi,
>  	spin_unlock(&bdi->wb_lock);
>  
>  	tsk->flags |= PF_FLUSHER | PF_SWAPWRITE;
> -	set_freezable();
>  
>  	/*
>  	 * Our parent may run at a different priority, just set us to normal
> @@ -419,7 +418,6 @@ static int bdi_forker_task(void *ptr)
>  			spin_unlock_bh(&bdi_lock);
>  			wait = msecs_to_jiffies(dirty_writeback_interval * 10);
>  			schedule_timeout(wait);
> -			try_to_freeze();
>  			continue;
>  		}
