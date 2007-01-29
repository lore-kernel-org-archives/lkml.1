Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbXA2XrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbXA2XrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbXA2XrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:47:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34048 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXA2XrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:47:08 -0500
Date: Mon, 29 Jan 2007 15:47:06 -0800
From: Andrew Morton <akpm@osdl.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC] sd: spin down disks on removal or power-down
Message-Id: <20070129154706.dfb3edab.akpm@osdl.org>
In-Reply-To: <45BD522F.3070706@shaw.ca>
References: <45BD522F.3070706@shaw.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jan 2007 19:47:27 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> Here's a patch for sd.c I've cooked up which issues a START STOP UNIT
> command to stop the drive when the SCSI disk is removed or the machine
> is powered down. The rationale behind this is that apparently on many
> drives, simply cutting power to the spinning disk forces it to do an
> emergency head park/unload which creates more wear on the drive then a
> controlled park/unload with power still applied. This change ensures
> that the drive will be spun down if the user shuts down the machine or
> if they are about to hot-unplug the drive and have done "scsiadd -r" first.
> 
> The main potential concern I have about this implementation is that if
> the drive is used in a multi-initiator, iSCSI, etc. environment,
> stopping the drive may be undesirable as another initiator may still be
> accessing it. I'm not familiar enough with these setups to know if this
> problem is likely to come up or not. For this and other reasons we may
> want to make this behavior controllable - I'm open to suggestions on how
> to do this or whether it's needed.
> 
> I've tested that this does work on SATA disks through libata (with my
> patch "libata: fix translation for START STOP UNIT" applied). I also
> tested with some external USB-to-IDE drive enclosures. The support for
> START STOP UNIT on those seems rather poor though, on one enclosure with
> a Genesys bridge chip it returned a check condition with "Invalid field
> in CDB", and on another with a JMicron chip the request succeeded but it
> didn't actually spin the drive down.
> 

What we don't want to happen is for those disks to spin down during a reboot.
It seems that this is OK with this patch.

Also, we probably don't want them to be spun down during a kexec_load, but
I expect that's OK too.

triviata:

> --- linux-2.6.20-rc6nv/drivers/scsi/sd.c	2007-01-28 17:00:00.000000000 -0600
> +++ linux-2.6.20-rc6nvedit/drivers/scsi/sd.c	2007-01-28 18:08:53.000000000 -0600
> @@ -821,6 +821,39 @@ static int sd_sync_cache(struct scsi_dev
>  	return res;
>  }
>  
> +static int sd_stop_unit(struct scsi_device *sdp, struct scsi_disk* sdkp)

s/* / */

> +{
> +	int res;
> +	struct scsi_sense_hdr sshdr;
> +	unsigned char cmd[10] = { 0 };

I don't think this initialisation-to-all-zeroes is needed, is it?

> +	if (!scsi_device_online(sdp))
> +		return -ENODEV;
> +
> +	cmd[0] = START_STOP;
> +	/*
> +	 * Leave the rest of the command zero to indicate
> +	 * transition to stopped power condition and return
> +	 * on completion.
> +	 */
> +	printk(KERN_NOTICE "Stopping SCSI disk %s\n",
> +		sdkp->disk->disk_name);
> +	res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
> +			       SD_TIMEOUT, SD_MAX_RETRIES);
> +
> +	if (res) {
> +		printk(KERN_WARNING "sd stop failed: status = %x, message = %02x, "
> +				    "host = %d, driver = %02x\n",
> +				    status_byte(res), msg_byte(res),
> +				    host_byte(res), driver_byte(res));
> +		if (driver_byte(res) & DRIVER_SENSE)
> +			scsi_print_sense_hdr("sd", &sshdr);
> +	}
> +	
> +	return res;
> +}
> +
> +
>  static int sd_issue_flush(struct device *dev, sector_t *error_sector)
>  {
>  	int ret = 0;
> @@ -1727,11 +1760,13 @@ static int sd_probe(struct device *dev)
>   **/
>  static int sd_remove(struct device *dev)
>  {
> +	struct scsi_device *sdp = to_scsi_device(dev);
>  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
>  
>  	class_device_del(&sdkp->cdev);
>  	del_gendisk(sdkp->disk);
>  	sd_shutdown(dev);
> +	sd_stop_unit(sdp,sdkp);
>  
>  	mutex_lock(&sd_ref_mutex);
>  	dev_set_drvdata(dev, NULL);
> @@ -1784,6 +1819,9 @@ static void sd_shutdown(struct device *d
>  				sdkp->disk->disk_name);
>  		sd_sync_cache(sdp);
>  	}
> +	if(system_state == SYSTEM_POWER_OFF)

s/if(/if (/

> +		sd_stop_unit(sdp,sdkp);
> +		
>  	scsi_disk_put(sdkp);
>  }
>  
> 
> 
> 
> 
> 
