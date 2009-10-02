Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbZJBWpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbZJBWpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbZJBWpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:45:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36912 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbZJBWpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:45:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] SWSUSP: fix blkdev refleaks
Date: Sat, 3 Oct 2009 00:47:11 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: len.brown@intel.com, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <1254499966-4806-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1254499966-4806-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200910030047.11643.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, Jiri Slaby wrote:
> While cruising through the swsusp code I found few blkdev reference
> leaks of resume_bdev.
> 
> swsusp_read: remove blkdev_put altogether. Some fail paths do
>              not do that.
> swsusp_check: make sure we always put a reference on fail paths
> software_resume: all fail paths between swsusp_check and swsusp_read
>                  omit swsusp_close. Add it in those cases. And since
>                  swsusp_read doesn't drop the reference anymore, do
>                  it here unconditionally.

Looks good.

I guess it's not a big deal if it goes into .33, though, since these bugs has
been there like forever.

I'm going to put it into suspend-2.6/linux-next in a while.

Thanks,
Rafael


> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/power/hibernate.c |   11 ++++++++---
>  kernel/power/swap.c      |   10 ++++------
>  2 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index 04b3a83..04a9e90 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -693,21 +693,22 @@ static int software_resume(void)
>  	/* The snapshot device should not be opened while we're running */
>  	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
>  		error = -EBUSY;
> +		swsusp_close(FMODE_READ);
>  		goto Unlock;
>  	}
>  
>  	pm_prepare_console();
>  	error = pm_notifier_call_chain(PM_RESTORE_PREPARE);
>  	if (error)
> -		goto Finish;
> +		goto close_finish;
>  
>  	error = usermodehelper_disable();
>  	if (error)
> -		goto Finish;
> +		goto close_finish;
>  
>  	error = create_basic_memory_bitmaps();
>  	if (error)
> -		goto Finish;
> +		goto close_finish;
>  
>  	pr_debug("PM: Preparing processes for restore.\n");
>  	error = prepare_processes();
> @@ -719,6 +720,7 @@ static int software_resume(void)
>  	pr_debug("PM: Reading hibernation image.\n");
>  
>  	error = swsusp_read(&flags);
> +	swsusp_close(FMODE_READ);
>  	if (!error)
>  		hibernation_restore(flags & SF_PLATFORM_MODE);
>  
> @@ -737,6 +739,9 @@ static int software_resume(void)
>  	mutex_unlock(&pm_mutex);
>  	pr_debug("PM: Resume from disk failed.\n");
>  	return error;
> +close_finish:
> +	swsusp_close(FMODE_READ);
> +	goto Finish;
>  }
>  
>  late_initcall(software_resume);
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index b101cdc..cccea0b 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -572,8 +572,6 @@ int swsusp_read(unsigned int *flags_p)
>  		error = load_image(&handle, &snapshot, header->pages - 1);
>  	release_swap_reader(&handle);
>  
> -	blkdev_put(resume_bdev, FMODE_READ);
> -
>  	if (!error)
>  		pr_debug("PM: Image successfully loaded\n");
>  	else
> @@ -596,16 +594,16 @@ int swsusp_check(void)
>  		error = bio_read_page(swsusp_resume_block,
>  					swsusp_header, NULL);
>  		if (error)
> -			return error;
> +			goto put;
>  
>  		if (!memcmp(SWSUSP_SIG, swsusp_header->sig, 10)) {
>  			memcpy(swsusp_header->sig, swsusp_header->orig_sig, 10);
>  			/* Reset swap signature now */
>  			error = bio_write_page(swsusp_resume_block,
>  						swsusp_header, NULL);
> -		} else {
> -			return -EINVAL;
> -		}
> +		} else
> +			error = -EINVAL;
> +put:
>  		if (error)
>  			blkdev_put(resume_bdev, FMODE_READ);
>  		else
> 

