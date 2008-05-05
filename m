Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbYEES17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbYEES17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760226AbYEESZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:25:44 -0400
Received: from nonada.if.usp.br ([143.107.131.169]:46830 "EHLO
	nonada.if.usp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760217AbYEESZj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:25:39 -0400
From: Joao Luis Meloni Assirati <assirati@nonada.if.usp.br>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Software RAID partitions not detected at boot time with linux 2.6.25.1.
Date: Mon, 5 May 2008 15:22:02 -0300
User-Agent: KMail/1.9.5
Cc: Neil Brown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
References: <200805032245.57084.assirati@nonada.if.usp.br> <18461.45667.588613.443564@notabene.brown> <1209990570.6975.5.camel@linux.site>
In-Reply-To: <1209990570.6975.5.camel@linux.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805051522.03079.assirati@nonada.if.usp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Segunda 05 Maio 2008 09:29, Kay Sievers escreveu:
> Care to test/fix/improve the following. I just booted a normal disk,
> didn't test a partitioned md device.

It works!:

md: Autodetecting RAID arrays.
md: Scanned 3 and added 3 devices.
md: autorun ...
md: considering sdc2 ...
md:  adding sdc2 ...
md:  adding sdb2 ...
md:  adding sda2 ...
md: created md_d0
md: bind<sda2>
md: bind<sdb2>
md: bind<sdc2>
md: running: <sdc2><sdb2><sda2>
raid5: device sdc2 operational as raid disk 2
raid5: device sdb2 operational as raid disk 1
raid5: device sda2 operational as raid disk 0
raid5: allocated 3224kB for md_d0
raid5: raid level 5 set md_d0 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda2
 disk 1, o:1, dev:sdb2
 disk 2, o:1, dev:sdc2
md: ... autorun DONE.
 md_d0: p1 p2 p3 p4 < p5 p6 p7 >

I will test it in another machine with raid1 later. If something
goes wrong there, I will report.

> Thanks,
> Kay

Thank you,
João Luis.

> 
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: block: do_mounts - accept root=<non-existant partition>
> 
> Some devices, like md, may create partitions only at first access,
> so allow root= to be set to a valid non-existant partition of an
> existing disk. This applies only to non-initramfs root mounting.
> 
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index fda9c7a..129ad93 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -653,7 +653,7 @@ void genhd_media_change_notify(struct gendisk *disk)
>  EXPORT_SYMBOL_GPL(genhd_media_change_notify);
>  #endif  /*  0  */
>  
> -dev_t blk_lookup_devt(const char *name)
> +dev_t blk_lookup_devt(const char *name, int part)
>  {
>  	struct device *dev;
>  	dev_t devt = MKDEV(0, 0);
> @@ -661,7 +661,11 @@ dev_t blk_lookup_devt(const char *name)
>  	mutex_lock(&block_class_lock);
>  	list_for_each_entry(dev, &block_class.devices, node) {
>  		if (strcmp(dev->bus_id, name) == 0) {
> -			devt = dev->devt;
> +			struct gendisk *disk = dev_to_disk(dev);
> +
> +			if (part < disk->minors)
> +				devt = MKDEV(MAJOR(dev->devt),
> +					     MINOR(dev->devt) + part);
>  			break;
>  		}
>  	}
> @@ -669,7 +673,6 @@ dev_t blk_lookup_devt(const char *name)
>  
>  	return devt;
>  }
> -
>  EXPORT_SYMBOL(blk_lookup_devt);
>  
>  struct gendisk *alloc_disk(int minors)
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index ecd2bf6..612a790 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -524,7 +524,7 @@ struct unixware_disklabel {
>  #define ADDPART_FLAG_RAID	1
>  #define ADDPART_FLAG_WHOLEDISK	2
>  
> -extern dev_t blk_lookup_devt(const char *name);
> +extern dev_t blk_lookup_devt(const char *name, int part);
>  extern char *disk_name (struct gendisk *hd, int part, char *buf);
>  
>  extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
> @@ -552,7 +552,7 @@ static inline struct block_device *bdget_disk(struct gendisk *disk, int index)
>  
>  static inline void printk_all_partitions(void) { }
>  
> -static inline dev_t blk_lookup_devt(const char *name)
> +static inline dev_t blk_lookup_devt(const char *name, int part)
>  {
>  	dev_t devt = MKDEV(0, 0);
>  	return devt;
> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index 3885e70..660c1e5 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -76,6 +76,7 @@ dev_t name_to_dev_t(char *name)
>  	char s[32];
>  	char *p;
>  	dev_t res = 0;
> +	int part;
>  
>  	if (strncmp(name, "/dev/", 5) != 0) {
>  		unsigned maj, min;
> @@ -106,7 +107,31 @@ dev_t name_to_dev_t(char *name)
>  	for (p = s; *p; p++)
>  		if (*p == '/')
>  			*p = '!';
> -	res = blk_lookup_devt(s);
> +	res = blk_lookup_devt(s, 0);
> +	if (res)
> +		goto done;
> +
> +	/*
> +	 * try non-existant, but valid partition, which may only exist
> +	 * after revalidating the disk, like partitioned md devices
> +	 */
> +	while (p > s && isdigit(p[-1]))
> +		p--;
> +	if (p == s || !*p || *p == '0')
> +		goto fail;
> +
> +	/* try disk name without <part number> */
> +	part = simple_strtoul(p, NULL, 10);
> +	*p = '\0';
> +	res = blk_lookup_devt(s, part);
> +	if (res)
> +		goto done;
> +
> +	/* try disk name without p<part number> */
> +	if (p < s + 2 || !isdigit(p[-2]) || p[-1] != 'p')
> +		goto fail;
> +	p[-1] = '\0';
> +	res = blk_lookup_devt(s, part);
>  	if (res)
>  		goto done;
>  
> 
> 
> 
