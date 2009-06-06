Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZFFKFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZFFKFo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 06:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZFFKFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 06:05:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60970 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbZFFKFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 06:05:30 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A2A3F36.4070408@s5r6.in-berlin.de>
Date: Sat, 06 Jun 2009 12:04:38 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David VomLehn <dvomlehn@cisco.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 7/7] initdev:kernel:Await block device discovery
References: <20090606023416.GA5798@cuplxvomd02.corp.sa.net>
In-Reply-To: <20090606023416.GA5798@cuplxvomd02.corp.sa.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David VomLehn wrote:
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -358,6 +358,18 @@ void __init mount_root(void)
>  #endif
>  }
>  
> +/**
> + * root_present - determine whether the root device is available yet
> + *
> + * Returns true if the root device is available, false if not. The check to
> + * see if the root device is available is done by check to see whether it
> + * has been assigned a major/minor device number.
> + */
> +static bool root_present(void)
> +{
> +	return name_to_dev_t(saved_root_name) != 0;
> +}
> +
>  /*
>   * Prepare the namespace - decide what/where to mount, load ramdisks, etc.
>   */
> @@ -398,12 +410,21 @@ void __init prepare_namespace(void)
>  		goto out;
>  
>  	/* wait for any asynchronous scanning to complete */
> -	if ((ROOT_DEV == 0) && root_wait) {
> +	if (ROOT_DEV == 0) {
>  		printk(KERN_INFO "Waiting for root device %s...\n",
>  			saved_root_name);
> -		while (driver_probe_done() != 0 ||
> -			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
> -			msleep(100);
> +		if (root_wait) {
> +			while (driver_probe_done() != 0 ||
> +				(ROOT_DEV = name_to_dev_t(saved_root_name)) ==
> +					0)
> +				msleep(100);
> +		}
> +
> +		else {
> +			initdev_wait(INITDEV_BLOCK_TYPE, root_present);
> +			ROOT_DEV = name_to_dev_t(saved_root_name);
> +		}
> +
>  		async_synchronize_full();
>  	}
>  

This together with 1/7, 5/7, 6/7 looks seriously flawed, if not broken.

1.)  It depends on the rootdelay so big that it is guaranteed that one 
or more initdev_found() have been called before prepare_namespace()'s 
ssleep(root_delay) is over.  This is because initdev_wait() does not 
wait at all if called when the number of pending initdevs is 0.

Hence the whole thing, as currently implemented, is quite useless:  The 
user/admin has to guess what a safe rootdelay value is, and then the 
kernel will always be delayed for >= rootdelay.

2.)  The fact that initdev_wait() does not wait at all when there are no 
pending initdevs causes another failure.  If there are sequences of the 
following type:

	initdev_found(INITDEV_BLOCK_TYPE);
	initdev_probe_done(INITDEV_BLOCK_TYPE); /* found other dev */
	initdev_found(INITDEV_BLOCK_TYPE);
	initdev_probe_done(INITDEV_BLOCK_TYPE); /* found root dev */

then prepare_namespace() will fall through without ROOT_DEV found and 
booting will fail, won't it?

I suspect that there are similar problems with the console and 
networking parts of the patch series.
-- 
Stefan Richter
-=====-==--= -==- --==-
http://arcgraph.de/sr/
