Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZBSANV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZBSANV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 19:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZBSAMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 19:12:49 -0500
Received: from kroah.org ([198.145.64.141]:38029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756652AbZBSAMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:12:47 -0500
Date: Wed, 18 Feb 2009 16:07:48 -0800
From: Greg KH <greg@kroah.com>
To: tom.leiming@gmail.com
Cc: kay.sievers@vrfy.org, cornelia.huck@de.ibm.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RESEND] driver core: remove polling for
	driver_probe_done(v3)
Message-ID: <20090219000748.GC5181@kroah.com>
References: <1234882444-6862-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234882444-6862-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This conflicts with a patch from Arjan in this same area that I've now
applied to my tree (used to be in the -mm tree).

Care to rebase it on the next linux-next release?

thanks,

greg k-h

On Tue, Feb 17, 2009 at 10:54:04PM +0800, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch adds a function : driver_wait_probe_done,
> which waits on condition of probing done to replace
> polling for driver_probe_done in fs initialization.
> 
> There is no better way to avoid polling for
> driver_probe_done _and_ existence of the root device,
> so we does not replace the driver_probe_done with
> driver_wait_probe_done in such special case.
> 
> Removing polling in fs initialization may lead to
> a faster boot.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  drivers/base/dd.c      |   12 ++++++++++++
>  include/linux/device.h |    1 +
>  init/do_mounts.c       |    4 ++--
>  init/do_mounts_md.c    |    3 +--
>  4 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 9b721d3..8f9f6fb 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -168,6 +168,18 @@ int driver_probe_done(void)
>  }
>  
>  /**
> + * driver_wait_probe_done
> + * Wait until the probe sequence is finished.
> + *
> + */
> +void driver_wait_probe_done(void)
> +{
> +	pr_debug("%s: probe_count = %d\n", __func__,
> +		 atomic_read(&probe_count));
> +	wait_event(probe_waitqueue, atomic_read(&probe_count) == 0);
> +}
> +
> +/**
>   * driver_probe_device - attempt to bind device & driver together
>   * @drv: driver to bind a device to
>   * @dev: device to try to bind to the driver
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 45e5b19..c53cdbf 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -147,6 +147,7 @@ extern void put_driver(struct device_driver *drv);
>  extern struct device_driver *driver_find(const char *name,
>  					 struct bus_type *bus);
>  extern int driver_probe_done(void);
> +extern void driver_wait_probe_done(void);
>  
>  /* sysfs interface for exporting driver attributes */
>  
> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index 708105e..9cb1985 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -371,8 +371,8 @@ void __init prepare_namespace(void)
>  	}
>  
>  	/* wait for the known devices to complete their probing */
> -	while (driver_probe_done() != 0)
> -		msleep(100);
> +	driver_wait_probe_done();
> +
>  	async_synchronize_full();
>  
>  	md_run_setup();
> diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
> index ff95e31..63b77f0 100644
> --- a/init/do_mounts_md.c
> +++ b/init/do_mounts_md.c
> @@ -281,8 +281,7 @@ static void __init autodetect_raid(void)
>  	 */
>  	printk(KERN_INFO "md: Waiting for all devices to be available before autodetect\n");
>  	printk(KERN_INFO "md: If you don't use raid, use raid=noautodetect\n");
> -	while (driver_probe_done() < 0)
> -		msleep(100);
> +	driver_wait_probe_done();
>  	fd = sys_open("/dev/md0", 0, 0);
>  	if (fd >= 0) {
>  		sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
> -- 
> 1.6.0
