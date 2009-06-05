Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbZFESxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbZFESxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZFESxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:53:23 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:38714 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbZFESxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=dMHo1yEl6YQx3Zb2X6mdlQfUoJIZYq50E8XxV7QGlUK9x7C4UTNXO3DojZa8wNfez4
         tyc3+8iC8AjBB7K2pDxfe/NjWrGePNUbc08HBl746MG/S3pQHQYdBL94FV89kT4Yxtrd
         Vuqz0zMg0BoyJ89JDvtEK7TRwwYUM2PVrikFA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 3/4] ide-gd: implement block device ->set_capacity method
Date: Fri, 5 Jun 2009 20:38:02 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Frans Pop <elendil@planet.nl>
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain> <200906012332.31628.bzolnier@gmail.com> <4A2575BC.9000805@ru.mvista.com>
In-Reply-To: <4A2575BC.9000805@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906052038.08080.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 June 2009 20:55:56 Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> >>From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >>Subject: [PATCH] ide-gd: implement block device ->set_capacity method
> 
> >>* Use ->probed_capacity to store native device capacity for ATA disks.
> 
> >>* Add ->set_capacity method to struct ide_disk_ops.
> 
> >>* Implement disk device ->set_capacity method for ATA disks.
> 
> >>* Implement block device ->set_capacity method.
> 
> >>Together with the previous patch adding ->set_capacity block device
> >>method this allows automatic disabling of Host Protected Area (HPA)
> >>if any partitions overlapping HPA are detected.
> 
> >>Cc: Robert Hancock <hancockrwd@gmail.com>
> >>Cc: Frans Pop <elendil@planet.nl>
> >>Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
> >>Cc: Al Viro <viro@zeniv.linux.org.uk>
> >>Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> > v2 interdiff
> 
> > v2:
> > * Check if LBA and HPA are supported in ide_disk_set_capacity().
> 
> > * According to the spec the SET MAX ADDRESS command shall be
> >   immediately preceded by a READ NATIVE MAX ADDRESS command.
> 
> > * Add ide_disk_hpa_{get_native,set}_capacity() helpers.
> 
>     One of them seem to me pretty useless...
> 
> > diff -u b/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
> > --- b/drivers/ide/ide-disk.c
> > +++ b/drivers/ide/ide-disk.c
> > @@ -302,14 +302,12 @@
> >  	{ NULL,		NULL }
> >  };
> >  
> > -static void idedisk_check_hpa(ide_drive_t *drive)
> > +static u64 ide_disk_hpa_get_native_capacity(ide_drive_t *drive, int lba48)
> 
>     Frankly speaking, I don't see what you've bought with factoring out this 
> function...

Saner abstractions and increased code clarity.

[ Makes long-term maintenance easier. ]

> >  {
> > -	unsigned long long capacity, set_max;
> > -	int lba48 = ata_id_lba48_enabled(drive->id);
> > +	u64 capacity, set_max;
> >  
> >  	capacity = drive->capacity64;
> > -
> > -	set_max = idedisk_read_native_max_address(drive, lba48);
> > +	set_max  = idedisk_read_native_max_address(drive, lba48);
> >  
> >  	if (ide_in_drive_list(drive->id, hpa_list)) {
> >  		/*
> > @@ -320,6 +318,26 @@
> >  			set_max--;
> >  	}
> >  
> > +	return set_max;
> > +}
> > +
> > +static u64 ide_disk_hpa_set_capacity(ide_drive_t *drive, u64 set_max, int lba48)
> > +{
> > +	set_max = idedisk_set_max_address(drive, set_max, lba48);
> > +	if (set_max)
> > +		drive->capacity64 = set_max;
> > +
> > +	return set_max;
> > +}
> > +
> > +static void idedisk_check_hpa(ide_drive_t *drive)
> > +{
> > +	u64 capacity, set_max;
> > +	int lba48 = ata_id_lba48_enabled(drive->id);
> > +
> > +	capacity = drive->capacity64;
> > +	set_max  = ide_disk_hpa_get_native_capacity(drive, lba48);
> > +
> >  	if (set_max <= capacity)
> >  		return;
> >  
> > @@ -332,13 +350,10 @@
> >  			 capacity, sectors_to_MB(capacity),
> >  			 set_max, sectors_to_MB(set_max));
> >  
> > -	set_max = idedisk_set_max_address(drive, set_max, lba48);
> > -
> > -	if (set_max) {
> > -		drive->capacity64 = set_max;
> > +	set_max = ide_disk_hpa_set_capacity(drive, set_max, lba48);
> > +	if (set_max)
> >  		printk(KERN_INFO "%s: Host Protected Area disabled.\n",
> >  				 drive->name);
> > -	}
> >  }
> >  
> >  static int ide_disk_get_capacity(ide_drive_t *drive)
> > @@ -399,12 +414,25 @@
> >  static u64 ide_disk_set_capacity(ide_drive_t *drive, u64 capacity)
> >  {
> >  	u64 set = min(capacity, drive->probed_capacity);
> > -	int lba48 = ata_id_lba48_enabled(drive->id);
> > -
> > -	capacity = idedisk_set_max_address(drive, set, lba48);
> > -	if (capacity)
> > -		drive->capacity64 = capacity;
> > +	u16 *id = drive->id;
> > +	int lba48 = ata_id_lba48_enabled(id);
> >  
> > +	if ((drive->dev_flags & IDE_DFLAG_LBA) == 0 ||
> > +	    ata_id_hpa_enabled(id) == 0)
> > +		goto out;
> > +
> > +	/*
> > +	 * according to the spec the SET MAX ADDRESS command shall be
> > +	 * immediately preceded by a READ NATIVE MAX ADDRESS command
> > +	 */
> > +	capacity = ide_disk_hpa_get_native_capacity(drive, lba48);
> 
>     Might as well just call idedisk_read_native_max_address() -- we don't 
> need to lookup hpa_list[] if we're only checking whether we can read native 
> max address or not afterwards:

ditto :)

None of this code is performance critical or adds significant footprint to
the resulting binary size..
