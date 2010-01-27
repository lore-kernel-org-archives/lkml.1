Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512Ab0A0LWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab0A0LWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294Ab0A0LWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:22:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53471 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab0A0LWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:22:17 -0500
Date: Wed, 27 Jan 2010 12:22:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 1/2] PM: remove deprecated user ioctls
Message-ID: <20100127112215.GA11551@atrey.karlin.mff.cuni.cz>
References: <1264589875-17045-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264589875-17045-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> They were deprecated and removed from exported headers more than 2
> years ago.

Should not this go through feature removal schedule etc...? Add
printks when someone uses deprecated ioctl?
									Pavel

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Pavel Machek <pavel@ucw.cz>
> ---
>  kernel/power/user.c |   73 ---------------------------------------------------
>  1 files changed, 0 insertions(+), 73 deletions(-)
> 
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index bf0014d..d7d6347 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -29,29 +29,6 @@
>  
>  #include "power.h"
>  
> -/*
> - * NOTE: The SNAPSHOT_SET_SWAP_FILE and SNAPSHOT_PMOPS ioctls are obsolete and
> - * will be removed in the future.  They are only preserved here for
> - * compatibility with existing userland utilities.
> - */
> -#define SNAPSHOT_SET_SWAP_FILE	_IOW(SNAPSHOT_IOC_MAGIC, 10, unsigned int)
> -#define SNAPSHOT_PMOPS		_IOW(SNAPSHOT_IOC_MAGIC, 12, unsigned int)
> -
> -#define PMOPS_PREPARE	1
> -#define PMOPS_ENTER	2
> -#define PMOPS_FINISH	3
> -
> -/*
> - * NOTE: The following ioctl definitions are wrong and have been replaced with
> - * correct ones.  They are only preserved here for compatibility with existing
> - * userland utilities and will be removed in the future.
> - */
> -#define SNAPSHOT_ATOMIC_SNAPSHOT	_IOW(SNAPSHOT_IOC_MAGIC, 3, void *)
> -#define SNAPSHOT_SET_IMAGE_SIZE		_IOW(SNAPSHOT_IOC_MAGIC, 6, unsigned long)
> -#define SNAPSHOT_AVAIL_SWAP		_IOR(SNAPSHOT_IOC_MAGIC, 7, void *)
> -#define SNAPSHOT_GET_SWAP_PAGE		_IOR(SNAPSHOT_IOC_MAGIC, 8, void *)
> -
> -
>  #define SNAPSHOT_MINOR	231
>  
>  static struct snapshot_data {
> @@ -247,7 +224,6 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
>  		break;
>  
>  	case SNAPSHOT_CREATE_IMAGE:
> -	case SNAPSHOT_ATOMIC_SNAPSHOT:
>  		if (data->mode != O_RDONLY || !data->frozen  || data->ready) {
>  			error = -EPERM;
>  			break;
> @@ -276,7 +252,6 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
>  		break;
>  
>  	case SNAPSHOT_PREF_IMAGE_SIZE:
> -	case SNAPSHOT_SET_IMAGE_SIZE:
>  		image_size = arg;
>  		break;
>  
> @@ -291,14 +266,12 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
>  		break;
>  
>  	case SNAPSHOT_AVAIL_SWAP_SIZE:
> -	case SNAPSHOT_AVAIL_SWAP:
>  		size = count_swap_pages(data->swap, 1);
>  		size <<= PAGE_SHIFT;
>  		error = put_user(size, (loff_t __user *)arg);
>  		break;
>  
>  	case SNAPSHOT_ALLOC_SWAP_PAGE:
> -	case SNAPSHOT_GET_SWAP_PAGE:
>  		if (data->swap < 0 || data->swap >= MAX_SWAPFILES) {
>  			error = -ENODEV;
>  			break;
> @@ -320,26 +293,6 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
>  		free_all_swap_pages(data->swap);
>  		break;
>  
> -	case SNAPSHOT_SET_SWAP_FILE: /* This ioctl is deprecated */
> -		if (!swsusp_swap_in_use()) {
> -			/*
> -			 * User space encodes device types as two-byte values,
> -			 * so we need to recode them
> -			 */
> -			if (old_decode_dev(arg)) {
> -				data->swap = swap_type_of(old_decode_dev(arg),
> -							0, NULL);
> -				if (data->swap < 0)
> -					error = -ENODEV;
> -			} else {
> -				data->swap = -1;
> -				error = -EINVAL;
> -			}
> -		} else {
> -			error = -EPERM;
> -		}
> -		break;
> -
>  	case SNAPSHOT_S2RAM:
>  		if (!data->frozen) {
>  			error = -EPERM;
> @@ -361,32 +314,6 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
>  			error = hibernation_platform_enter();
>  		break;
>  
> -	case SNAPSHOT_PMOPS: /* This ioctl is deprecated */
> -		error = -EINVAL;
> -
> -		switch (arg) {
> -
> -		case PMOPS_PREPARE:
> -			data->platform_support = 1;
> -			error = 0;
> -			break;
> -
> -		case PMOPS_ENTER:
> -			if (data->platform_support)
> -				error = hibernation_platform_enter();
> -			break;
> -
> -		case PMOPS_FINISH:
> -			if (data->platform_support)
> -				error = 0;
> -			break;
> -
> -		default:
> -			printk(KERN_ERR "SNAPSHOT_PMOPS: invalid argument %ld\n", arg);
> -
> -		}
> -		break;
> -
>  	case SNAPSHOT_SET_SWAP_AREA:
>  		if (swsusp_swap_in_use()) {
>  			error = -EPERM;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
