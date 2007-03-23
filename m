Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbXCWSXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbXCWSXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 14:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbXCWSXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 14:23:31 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33739 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbXCWSX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 14:23:29 -0400
Date: Fri, 23 Mar 2007 11:24:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kyle@canonical.com
Subject: Re: HPA patches
Message-Id: <20070323112411.f6a8a762.randy.dunlap@oracle.com>
In-Reply-To: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 19:13:21 +0000 Alan Cox wrote:

> For reference this is what I am currently using with 2.6.21-rc4-mm1 and
> it is working for all my test cases so far: Its basically Kyle's patch
> with a libata switch to turn it on/off and some minor fixups from
> the original patch as posted
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc4-mm1/drivers/ata/libata-core.c linux-2.6.21-rc4-mm1/drivers/ata/libata-core.c
> --- linux.vanilla-2.6.21-rc4-mm1/drivers/ata/libata-core.c	2007-03-23 11:49:49.000000000 +0000
> +++ linux-2.6.21-rc4-mm1/drivers/ata/libata-core.c	2007-03-23 13:05:15.000000000 +0000
> @@ -89,6 +89,10 @@
>  module_param_named(fua, libata_fua, int, 0444);
>  MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on)");
>  
> +static int ata_ignore_hpa = 0;

Don't init to 0.  Not needed, bloats binary files.

> +module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
> +MODULE_PARM_DESC(ignore_hpa, "Ignore HPA (0=off 1=on)");

So 1 = on = ignore, right?

> +
>  static int ata_probe_timeout = ATA_TMOUT_INTERNAL / HZ;
>  module_param(ata_probe_timeout, int, 0444);
>  MODULE_PARM_DESC(ata_probe_timeout, "Set ATA probing timeout (seconds)");
> @@ -808,6 +812,202 @@
>  	*p = '\0';
>  }
>  
> +
> +/**
> + *	ata_read_native_max_address_ext	-	LBA48 native max query
> + *	@dev: Device to query
> + *
> + *	Performa an LBA48 size query upon the device in question. Return the

	Perform

> + *	actual LBA48 size or zero if the command fails.
> + */
> +
> +static u64 ata_read_native_max_address_ext(struct ata_device *dev)
> +{
> +	unsigned int err;
> +	struct ata_taskfile tf;
> +
> +	ata_tf_init(dev, &tf);
> +
> +	tf.command = ATA_CMD_READ_NATIVE_MAX_EXT;
> +	tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48 | ATA_TFLAG_ISADDR;
> +	tf.protocol |= ATA_PROT_NODATA;
> +	tf.device = 0x40;

What is 0x40?  can it be #defined (or enum-ed) instead of a magic
value?  please?  (more of same below)

> +
> +	err = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
> +	if (err)
> +		return 0;
> +
> +	return ata_tf_to_lba48(&tf);
> +}
> +
> +/**
> + *	ata_read_native_max_address	-	LBA28 native max query
> + *	@dev: Device to query
> + *
> + *	Performa an LBA28 size query upon the device in question. Return the

	Perform

> + *	actual LBA28 size or zero if the command fails.
> + */
> +
> +static u64 ata_read_native_max_address(struct ata_device *dev)
> +{
> +	unsigned int err;
> +	struct ata_taskfile tf;
> +
> +	ata_tf_init(dev, &tf);
> +
> +	tf.command = ATA_CMD_READ_NATIVE_MAX;
> +	tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
> +	tf.protocol |= ATA_PROT_NODATA;
> +	tf.device = 0x40;
> +
> +	err = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
> +	if (err)
> +		return 0;
> +
> +	return ata_tf_to_lba(&tf);
> +}
> +
> +/**
> + *	ata_set_native_max_address_ext	-	LBA48 native max set
> + *	@dev: Device to query
> + *
> + *	Perform an LBA48 size set max upon the device in question. Return the
> + *	actual LBA48 size or zero if the command fails.
> + */
> +
> +static u64 ata_set_native_max_address_ext(struct ata_device *dev, u64 new_sectors)
> +{
...
> +}
> +
> +/**
> + *	ata_set_native_max_address	-	LBA28 native max set
> + *	@dev: Device to query
> + *
> + *	Perform an LBA28 size set max upon the device in question. Return the
> + *	actual LBA28 size or zero if the command fails.
> + */
> +
> +static u64 ata_set_native_max_address(struct ata_device *dev, u64 new_sectors)
> +{
...
> +}
> +
> +/**
> + *	ata_hpa_resize		-	Resize a device with an HPA set
> + *	@dev: Device to resize
> + *
> + *	Read the size of an LBA28 or LBA48 disk with HPA features and resize
> + *	it if required to the full size of the media. The caller must check
> + *	the drive has the HPA feature set enabled.
> + */
> +
> +static u64 ata_hpa_resize(struct ata_device *dev)
> +{
> +	u64 sectors = dev->n_sectors;
> +	u64 hpa_sectors;
> +	
> +	if (ata_id_has_lba48(dev->id))
> +		hpa_sectors = ata_read_native_max_address_ext(dev);
> +	else
> +		hpa_sectors = ata_read_native_max_address(dev);
> +
> +	/* if no hpa, both should be equal */
> +	ata_dev_printk(dev, KERN_INFO, "%s 1: sectors = %lld, hpa_sectors = %lld\n",
> +		__FUNCTION__, sectors, hpa_sectors);

(long long) or (unsigned long long) on sectors and hpa_sectors...

> +
> +	if (hpa_sectors > sectors) {
> +		ata_dev_printk(dev, KERN_INFO,
> +			"Host Protected Area detected:\n"
> +			"\tcurrent size: %lld sectors\n"
> +			"\tnative size: %lld sectors\n",
> +			sectors, hpa_sectors);

printk format types ok?

> +
> +		if (ata_ignore_hpa) {
> +			if (ata_id_has_lba48(dev->id))
> +				hpa_sectors = ata_set_native_max_address_ext(dev, hpa_sectors);
> +			else
> +				hpa_sectors = ata_set_native_max_address(dev, hpa_sectors);
> +
> +			if (hpa_sectors) {
> +				ata_dev_printk(dev, KERN_INFO,
> +					"native size increased to %lld sectors\n", hpa_sectors);

Line lengths < 80 and printk format types?

> +				return hpa_sectors;
> +			}
> +		}
> +	}
> +	return sectors;
> +}
> +
>  static u64 ata_id_n_sectors(const u16 *id)
>  {
>  	if (ata_id_has_lba(id)) {
> @@ -1658,6 +1858,7 @@
>  			snprintf(revbuf, 7, "ATA-%d",  ata_id_major_version(id));
>  
>  		dev->n_sectors = ata_id_n_sectors(id);
> +		dev->n_sectors_boot = dev->n_sectors;
>  
>  		/* SCSI only uses 4-char revisions, dump full 8 chars from ATA */
>  		ata_id_c_string(dev->id, fwrevbuf, ATA_ID_FW_REV,
> @@ -1684,6 +1885,9 @@
>  					dev->flags |= ATA_DFLAG_FLUSH_EXT;
>  			}
>  
> +			if (ata_id_hpa_enabled(dev->id))
> +				dev->n_sectors = ata_hpa_resize(dev);
> +
>  			/* config NCQ */
>  			ata_dev_config_ncq(dev, ncq_desc, sizeof(ncq_desc));
>  
> @@ -3384,6 +3595,11 @@
>  			       "%llu != %llu\n",
>  			       (unsigned long long)dev->n_sectors,
>  			       (unsigned long long)new_n_sectors);
> +		/* Are we the boot time size - if so we appear to be the
> +		   same disk at this point and our HPA got reapplied */
> +		if (ata_ignore_hpa && dev->n_sectors_boot == new_n_sectors 
> +		    && ata_id_hpa_enabled(new_id))
> +			return 1;
>  		return 0;
>  	}


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
