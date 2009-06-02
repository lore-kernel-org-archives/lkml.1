Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbZFBSys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbZFBSys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 14:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZFBSyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 14:54:40 -0400
Received: from h155.mvista.com ([63.81.120.155]:27556 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750776AbZFBSyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:54:39 -0400
Message-ID: <4A2575BC.9000805@ru.mvista.com>
Date: Tue, 02 Jun 2009 22:55:56 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH 3/4] ide-gd: implement block device ->set_capacity method
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain> <20090531143931.7164.96956.sendpatchset@localhost.localdomain> <200906012332.31628.bzolnier@gmail.com>
In-Reply-To: <200906012332.31628.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>Subject: [PATCH] ide-gd: implement block device ->set_capacity method

>>* Use ->probed_capacity to store native device capacity for ATA disks.

>>* Add ->set_capacity method to struct ide_disk_ops.

>>* Implement disk device ->set_capacity method for ATA disks.

>>* Implement block device ->set_capacity method.

>>Together with the previous patch adding ->set_capacity block device
>>method this allows automatic disabling of Host Protected Area (HPA)
>>if any partitions overlapping HPA are detected.

>>Cc: Robert Hancock <hancockrwd@gmail.com>
>>Cc: Frans Pop <elendil@planet.nl>
>>Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
>>Cc: Al Viro <viro@zeniv.linux.org.uk>
>>Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> v2 interdiff

> v2:
> * Check if LBA and HPA are supported in ide_disk_set_capacity().

> * According to the spec the SET MAX ADDRESS command shall be
>   immediately preceded by a READ NATIVE MAX ADDRESS command.

> * Add ide_disk_hpa_{get_native,set}_capacity() helpers.

    One of them seem to me pretty useless...

> diff -u b/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
> --- b/drivers/ide/ide-disk.c
> +++ b/drivers/ide/ide-disk.c
> @@ -302,14 +302,12 @@
>  	{ NULL,		NULL }
>  };
>  
> -static void idedisk_check_hpa(ide_drive_t *drive)
> +static u64 ide_disk_hpa_get_native_capacity(ide_drive_t *drive, int lba48)

    Frankly speaking, I don't see what you've bought with factoring out this 
function...

>  {
> -	unsigned long long capacity, set_max;
> -	int lba48 = ata_id_lba48_enabled(drive->id);
> +	u64 capacity, set_max;
>  
>  	capacity = drive->capacity64;
> -
> -	set_max = idedisk_read_native_max_address(drive, lba48);
> +	set_max  = idedisk_read_native_max_address(drive, lba48);
>  
>  	if (ide_in_drive_list(drive->id, hpa_list)) {
>  		/*
> @@ -320,6 +318,26 @@
>  			set_max--;
>  	}
>  
> +	return set_max;
> +}
> +
> +static u64 ide_disk_hpa_set_capacity(ide_drive_t *drive, u64 set_max, int lba48)
> +{
> +	set_max = idedisk_set_max_address(drive, set_max, lba48);
> +	if (set_max)
> +		drive->capacity64 = set_max;
> +
> +	return set_max;
> +}
> +
> +static void idedisk_check_hpa(ide_drive_t *drive)
> +{
> +	u64 capacity, set_max;
> +	int lba48 = ata_id_lba48_enabled(drive->id);
> +
> +	capacity = drive->capacity64;
> +	set_max  = ide_disk_hpa_get_native_capacity(drive, lba48);
> +
>  	if (set_max <= capacity)
>  		return;
>  
> @@ -332,13 +350,10 @@
>  			 capacity, sectors_to_MB(capacity),
>  			 set_max, sectors_to_MB(set_max));
>  
> -	set_max = idedisk_set_max_address(drive, set_max, lba48);
> -
> -	if (set_max) {
> -		drive->capacity64 = set_max;
> +	set_max = ide_disk_hpa_set_capacity(drive, set_max, lba48);
> +	if (set_max)
>  		printk(KERN_INFO "%s: Host Protected Area disabled.\n",
>  				 drive->name);
> -	}
>  }
>  
>  static int ide_disk_get_capacity(ide_drive_t *drive)
> @@ -399,12 +414,25 @@
>  static u64 ide_disk_set_capacity(ide_drive_t *drive, u64 capacity)
>  {
>  	u64 set = min(capacity, drive->probed_capacity);
> -	int lba48 = ata_id_lba48_enabled(drive->id);
> -
> -	capacity = idedisk_set_max_address(drive, set, lba48);
> -	if (capacity)
> -		drive->capacity64 = capacity;
> +	u16 *id = drive->id;
> +	int lba48 = ata_id_lba48_enabled(id);
>  
> +	if ((drive->dev_flags & IDE_DFLAG_LBA) == 0 ||
> +	    ata_id_hpa_enabled(id) == 0)
> +		goto out;
> +
> +	/*
> +	 * according to the spec the SET MAX ADDRESS command shall be
> +	 * immediately preceded by a READ NATIVE MAX ADDRESS command
> +	 */
> +	capacity = ide_disk_hpa_get_native_capacity(drive, lba48);

    Might as well just call idedisk_read_native_max_address() -- we don't 
need to lookup hpa_list[] if we're only checking whether we can read native 
max address or not afterwards:

> +	if (capacity == 0)
> +		goto out;
> +
> +	set = ide_disk_hpa_set_capacity(drive, set, lba48);
> +	if (set)
> +		return set;

    Why bother doing that again if the function itself does such check and 
sets drive->capacity64 to the returned value on success? It should be as 
simple as:

	ide_disk_hpa_set_capacity(drive, set, lba48);

> +out:
>  	return drive->capacity64;
>  }

    Label/gotos unnecessary in this case -- we have *return*...

MBR, Sergei
