Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbZFIMb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbZFIMb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZFIMbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:31:17 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:38279 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbZFIMbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:31:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ukig/QSMpDhREwQ6JSJv36ngNYe51v+LA2wOwJgnUf+cIiLHgz6Q8FhRAb7iVaAkNF
         kzGYhiw/BkYq8WNgnG0LFppK+Ks2MMZFLN4iQggMbfz6o1VkldL0X/QxAMU+WfpXg8i8
         m/oftl8wS3hMOcl/R4PO/AXEm2SD9CNTo+DVM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH next] ide: fix PowerMac bootup oops
Date: Tue, 9 Jun 2009 14:36:19 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: Joao Ramos <joao.ramos@inov.pt>,
       Sergei Shtylyov <sshtylyov@ru.montavista.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <Pine.LNX.4.64.0906082137120.22183@sister.anvils> <200906082328.02729.bzolnier@gmail.com> <Pine.LNX.4.64.0906091237290.14065@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0906091237290.14065@sister.anvils>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906091436.19710.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009 13:44:25 Hugh Dickins wrote:
> Hi Bart,
> 
> On Mon, 8 Jun 2009, Bartlomiej Zolnierkiewicz wrote:
> > 
> > After auditing some other host drivers I see that drive->id can be used
> > also directly in ->set_pio_mode methods..
> > 
> > Could you please instead try moving ->id allocation from probe_for_drive()
> > to ide_port_alloc_devices() (this would fix all such issues for good) and
> > verify that it also fixes the oops?
> 
> Okay, that makes sense: here's a patch which fixes the oops that way;
> but it didn't work first time - see save_id!  I'm not entirely happy
> with the memsetting, as I comment in the patch, but I don't really
> know what reuse these get: please check the decisions I made,
> you may well want to change it around a bit.
> 
> 
> [PATCH next] ide: fix PowerMac bootup oops
> 
> PowerMac bootup with CONFIG_IDE=y oopses in ide_pio_cycle_time():
> because "ide: try to use PIO Mode 0 during probe if possible" causes
> pmac_ide_set_pio_mode() to be called before drive->id has been set.
> 
> Bart points out other places which now need drive->id set earlier,
> so follow his advice to allocate it in ide_port_alloc_devices()
> (using kzalloc_node, without error message, as when allocating drive).
> 
> But memset id in probe_for_drive() when it might be being reused -
> or would it be better to memset it wherever it used to be kfreed?

Please memset() it in ide_port_init_devices_data() -- this function
is called before IDE device structure is going to be (re-)used.

The rest of patch looks good, thanks for fixing this bug!

> Fixed in passing: ide_host_alloc() was missing ide_port_free_devices()
> from an error path.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
> 
>  drivers/ide/ide-probe.c |   47 ++++++++++++++++----------------------
>  1 file changed, 21 insertions(+), 26 deletions(-)
> 
> --- lnext/drivers/ide/ide-probe.c	2009-06-03 11:45:13.000000000 +0100
> +++ linux/drivers/ide/ide-probe.c	2009-06-09 12:03:55.000000000 +0100
> @@ -465,23 +465,9 @@ static u8 probe_for_drive(ide_drive_t *d
>  	int rc;
>  	u8 cmd;
>  
> -	/*
> -	 *	In order to keep things simple we have an id
> -	 *	block for all drives at all times. If the device
> -	 *	is pre ATA or refuses ATA/ATAPI identify we
> -	 *	will add faked data to this.
> -	 *
> -	 *	Also note that 0 everywhere means "can't do X"
> -	 */
> - 
>  	drive->dev_flags &= ~IDE_DFLAG_ID_READ;
>  
> -	drive->id = kzalloc(SECTOR_SIZE, GFP_KERNEL);
> -	if (drive->id == NULL) {
> -		printk(KERN_ERR "ide: out of memory for id data.\n");
> -		return 0;
> -	}
> -
> +	memset(drive->id, 0, SECTOR_SIZE);
>  	m = (char *)&drive->id[ATA_ID_PROD];
>  	strcpy(m, "UNKNOWN");
>  
> @@ -497,7 +483,7 @@ static u8 probe_for_drive(ide_drive_t *d
>  		}
>  
>  		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
> -			goto out_free;
> +			return 0;
>  
>  		/* identification failed? */
>  		if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
> @@ -521,7 +507,7 @@ static u8 probe_for_drive(ide_drive_t *d
>  	}
>  
>  	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
> -		goto out_free;
> +		return 0;
>  
>  	/* The drive wasn't being helpful. Add generic info only */
>  	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
> @@ -535,9 +521,6 @@ static u8 probe_for_drive(ide_drive_t *d
>  	}
>  
>  	return 1;
> -out_free:
> -	kfree(drive->id);
> -	return 0;
>  }
>  
>  static void hwif_release_dev(struct device *dev)
> @@ -817,8 +800,6 @@ static int ide_port_setup_devices(ide_hw
>  		if (ide_init_queue(drive)) {
>  			printk(KERN_ERR "ide: failed to init %s\n",
>  					drive->name);
> -			kfree(drive->id);
> -			drive->id = NULL;
>  			drive->dev_flags &= ~IDE_DFLAG_PRESENT;
>  			continue;
>  		}
> @@ -947,9 +928,6 @@ static void drive_release_dev (struct de
>  	blk_cleanup_queue(drive->queue);
>  	drive->queue = NULL;
>  
> -	kfree(drive->id);
> -	drive->id = NULL;
> -
>  	drive->dev_flags &= ~IDE_DFLAG_PRESENT;
>  
>  	complete(&drive->gendev_rel_comp);
> @@ -1132,8 +1110,10 @@ static void ide_port_init_devices_data(i
>  
>  	ide_port_for_each_dev(i, drive, hwif) {
>  		u8 j = (hwif->index * MAX_DRIVES) + i;
> +		u16 *saved_id = drive->id;
>  
>  		memset(drive, 0, sizeof(*drive));
> +		drive->id = saved_id;
>  
>  		drive->media			= ide_disk;
>  		drive->select			= (i << 4) | ATA_DEVICE_OBS;
> @@ -1240,8 +1220,10 @@ static void ide_port_free_devices(ide_hw
>  	ide_drive_t *drive;
>  	int i;
>  
> -	ide_port_for_each_dev(i, drive, hwif)
> +	ide_port_for_each_dev(i, drive, hwif) {
> +		kfree(drive->id);
>  		kfree(drive);
> +	}
>  }
>  
>  static int ide_port_alloc_devices(ide_hwif_t *hwif, int node)
> @@ -1255,6 +1237,18 @@ static int ide_port_alloc_devices(ide_hw
>  		if (drive == NULL)
>  			goto out_nomem;
>  
> +		/*
> +		 * In order to keep things simple we have an id
> +		 * block for all drives at all times. If the device
> +		 * is pre ATA or refuses ATA/ATAPI identify we
> +		 * will add faked data to this.
> +		 *
> +		 * Also note that 0 everywhere means "can't do X"
> +		 */
> +		drive->id = kzalloc_node(SECTOR_SIZE, GFP_KERNEL, node);
> +		if (drive->id == NULL)
> +			goto out_nomem;
> +
>  		hwif->devices[i] = drive;
>  	}
>  	return 0;
> @@ -1296,6 +1290,7 @@ struct ide_host *ide_host_alloc(const st
>  		if (idx < 0) {
>  			printk(KERN_ERR "%s: no free slot for interface\n",
>  					d ? d->name : "ide");
> +			ide_port_free_devices(hwif);
>  			kfree(hwif);
>  			continue;
>  		}
