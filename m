Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897Ab0CJXMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 18:12:51 -0500
Received: from wdscspam2.wdc.com ([129.253.170.131]:51177 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847Ab0CJXMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 18:12:50 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] fs/partitions/msdos: add support for large disks
Date: Wed, 10 Mar 2010 15:12:48 -0800
Message-ID: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD86@wdscexbe01.sc.wdc.com>
In-Reply-To: <87wrxkw52s.fsf_-_@devron.myhome.or.jp>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] fs/partitions/msdos: add support for large disks
Thread-Index: AcrAaSNTUmbm4buvRiewTFGWnSgoNwAOE8mQ
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com><20100301141335.395dc4c3.akpm@linux-foundation.org><873a0h1p2c.fsf@devron.myhome.or.jp><876358iehd.fsf@devron.myhome.or.jp> <4B9430B6.701@zytor.com><87pr3fd68r.fsf@devron.myhome.or.jp> <4B9440FC.3090502@zytor.com><87zl2j9muz.fsf@devron.myhome.or.jp> <87wrxkw52s.fsf_-_@devron.myhome.or.jp>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Mar 2010 23:12:49.0111 (UTC) FILETIME=[33975E70:01CAC0A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Thank you for the review/fixes.

Regards,

Dan

> -----Original Message-----
> From: OGAWA Hirofumi [mailto:hirofumi@mail.parknet.co.jp] 
> Sent: Wednesday, March 10, 2010 7:48 AM
> To: Andrew Morton
> Cc: H. Peter Anvin; Daniel Taylor; linux-kernel@vger.kernel.org
> Subject: [PATCH 1/2] fs/partitions/msdos: add support for large disks
> 
> Hi,
> 
> This is rediff with fix of "Daniel Taylor" <Daniel.Taylor@wdc.com>.
> Daniel, please check I'm breaking your patch.
> 
> 
> 
> From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
> 
> In order to use disks larger than 2TiB on Windows XP, it is necessary
> to use 4096-byte logical sectors in an MBR.
> 
> Although the kernel storage and functions called from msdos.c used
> "sector_t" internally, msdos.c still used u32 variables, which results
> in the ability to handle XP-compatible large disks.
> 
> This patch changes the internal variables to "sector_t".
> 
> Signed-off-by: Daniel Taylor <daniel.taylor@wdc.com>
> [tweaks and fix]
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> 
>  fs/partitions/msdos.c |   74 
> +++++++++++++++++++++++++------------------------
>  1 file changed, 39 insertions(+), 35 deletions(-)
> 
> diff -puN fs/partitions/msdos.c~part-support-4k-block 
> fs/partitions/msdos.c
> --- linux-2.6/fs/partitions/msdos.c~part-support-4k-block	
> 2010-03-07 04:10:48.000000000 +0900
> +++ linux-2.6-hirofumi/fs/partitions/msdos.c	2010-03-07 
> 19:41:56.000000000 +0900
> @@ -31,14 +31,17 @@
>   */
>  #include <asm/unaligned.h>
>  
> -#define SYS_IND(p)	(get_unaligned(&p->sys_ind))
> -#define NR_SECTS(p)	({ __le32 __a =	
> get_unaligned(&p->nr_sects);	\
> -				le32_to_cpu(__a); \
> -			})
> -
> -#define START_SECT(p)	({ __le32 __a =	
> get_unaligned(&p->start_sect);	\
> -				le32_to_cpu(__a); \
> -			})
> +#define SYS_IND(p)	get_unaligned(&p->sys_ind)
> +
> +static inline sector_t nr_sects(struct partition *p)
> +{
> +	return (sector_t)get_unaligned_le32(&p->nr_sects);
> +}
> +
> +static inline sector_t start_sect(struct partition *p)
> +{
> +	return (sector_t)get_unaligned_le32(&p->start_sect);
> +}
>  
>  static inline int is_extended_partition(struct partition *p)
>  {
> @@ -104,13 +107,13 @@ static int aix_magic_present(unsigned ch
>  
>  static void
>  parse_extended(struct parsed_partitions *state, struct 
> block_device *bdev,
> -			u32 first_sector, u32 first_size)
> +			sector_t first_sector, sector_t first_size)
>  {
>  	struct partition *p;
>  	Sector sect;
>  	unsigned char *data;
> -	u32 this_sector, this_size;
> -	int sector_size = bdev_logical_block_size(bdev) / 512;
> +	sector_t this_sector, this_size;
> +	sector_t sector_size = bdev_logical_block_size(bdev) / 512;
>  	int loopct = 0;		/* number of links followed
>  				   without finding a data partition */
>  	int i;
> @@ -145,14 +148,14 @@ parse_extended(struct parsed_partitions
>  		 * First process the data partition(s)
>  		 */
>  		for (i=0; i<4; i++, p++) {
> -			u32 offs, size, next;
> -			if (!NR_SECTS(p) || is_extended_partition(p))
> +			sector_t offs, size, next;
> +			if (!nr_sects(p) || is_extended_partition(p))
>  				continue;
>  
>  			/* Check the 3rd and 4th entries -
>  			   these sometimes contain random garbage */
> -			offs = START_SECT(p)*sector_size;
> -			size = NR_SECTS(p)*sector_size;
> +			offs = start_sect(p)*sector_size;
> +			size = nr_sects(p)*sector_size;
>  			next = this_sector + offs;
>  			if (i >= 2) {
>  				if (offs + size > this_size)
> @@ -179,13 +182,13 @@ parse_extended(struct parsed_partitions
>  		 */
>  		p -= 4;
>  		for (i=0; i<4; i++, p++)
> -			if (NR_SECTS(p) && is_extended_partition(p))
> +			if (nr_sects(p) && is_extended_partition(p))
>  				break;
>  		if (i == 4)
>  			goto done;	 /* nothing left to do */
>  
> -		this_sector = first_sector + START_SECT(p) * 
> sector_size;
> -		this_size = NR_SECTS(p) * sector_size;
> +		this_sector = first_sector + start_sect(p) * 
> sector_size;
> +		this_size = nr_sects(p) * sector_size;
>  		put_dev_sector(sect);
>  	}
>  done:
> @@ -197,7 +200,7 @@ done:
>  
>  static void
>  parse_solaris_x86(struct parsed_partitions *state, struct 
> block_device *bdev,
> -			u32 offset, u32 size, int origin)
> +			sector_t offset, sector_t size, int origin)
>  {
>  #ifdef CONFIG_SOLARIS_X86_PARTITION
>  	Sector sect;
> @@ -244,7 +247,7 @@ parse_solaris_x86(struct parsed_partitio
>   */
>  static void
>  parse_bsd(struct parsed_partitions *state, struct block_device *bdev,
> -		u32 offset, u32 size, int origin, char *flavour,
> +		sector_t offset, sector_t size, int origin, 
> char *flavour,
>  		int max_partitions)
>  {
>  	Sector sect;
> @@ -263,7 +266,7 @@ parse_bsd(struct parsed_partitions *stat
>  	if (le16_to_cpu(l->d_npartitions) < max_partitions)
>  		max_partitions = le16_to_cpu(l->d_npartitions);
>  	for (p = l->d_partitions; p - l->d_partitions < 
> max_partitions; p++) {
> -		u32 bsd_start, bsd_size;
> +		sector_t bsd_start, bsd_size;
>  
>  		if (state->next == state->limit)
>  			break;
> @@ -290,7 +293,7 @@ parse_bsd(struct parsed_partitions *stat
>  
>  static void
>  parse_freebsd(struct parsed_partitions *state, struct 
> block_device *bdev,
> -		u32 offset, u32 size, int origin)
> +		sector_t offset, sector_t size, int origin)
>  {
>  #ifdef CONFIG_BSD_DISKLABEL
>  	parse_bsd(state, bdev, offset, size, origin,
> @@ -300,7 +303,7 @@ parse_freebsd(struct parsed_partitions *
>  
>  static void
>  parse_netbsd(struct parsed_partitions *state, struct 
> block_device *bdev,
> -		u32 offset, u32 size, int origin)
> +		sector_t offset, sector_t size, int origin)
>  {
>  #ifdef CONFIG_BSD_DISKLABEL
>  	parse_bsd(state, bdev, offset, size, origin,
> @@ -310,7 +313,7 @@ parse_netbsd(struct parsed_partitions *s
>  
>  static void
>  parse_openbsd(struct parsed_partitions *state, struct 
> block_device *bdev,
> -		u32 offset, u32 size, int origin)
> +		sector_t offset, sector_t size, int origin)
>  {
>  #ifdef CONFIG_BSD_DISKLABEL
>  	parse_bsd(state, bdev, offset, size, origin,
> @@ -324,7 +327,7 @@ parse_openbsd(struct parsed_partitions *
>   */
>  static void
>  parse_unixware(struct parsed_partitions *state, struct 
> block_device *bdev,
> -		u32 offset, u32 size, int origin)
> +		sector_t offset, sector_t size, int origin)
>  {
>  #ifdef CONFIG_UNIXWARE_DISKLABEL
>  	Sector sect;
> @@ -348,7 +351,8 @@ parse_unixware(struct parsed_partitions
>  
>  		if (p->s_label != UNIXWARE_FS_UNUSED)
>  			put_partition(state, state->next++,
> -						START_SECT(p), 
> NR_SECTS(p));
> +				      le32_to_cpu(p->start_sect),
> +				      le32_to_cpu(p->nr_sects));
>  		p++;
>  	}
>  	put_dev_sector(sect);
> @@ -363,7 +367,7 @@ parse_unixware(struct parsed_partitions
>   */
>  static void
>  parse_minix(struct parsed_partitions *state, struct 
> block_device *bdev,
> -		u32 offset, u32 size, int origin)
> +		sector_t offset, sector_t size, int origin)
>  {
>  #ifdef CONFIG_MINIX_SUBPARTITION
>  	Sector sect;
> @@ -390,7 +394,7 @@ parse_minix(struct parsed_partitions *st
>  			/* add each partition in use */
>  			if (SYS_IND(p) == MINIX_PARTITION)
>  				put_partition(state, state->next++,
> -					      START_SECT(p), 
> NR_SECTS(p));
> +					      start_sect(p), 
> nr_sects(p));
>  		}
>  		printk(" >\n");
>  	}
> @@ -401,7 +405,7 @@ parse_minix(struct parsed_partitions *st
>  static struct {
>  	unsigned char id;
>  	void (*parse)(struct parsed_partitions *, struct block_device *,
> -			u32, u32, int);
> +			sector_t, sector_t, int);
>  } subtypes[] = {
>  	{FREEBSD_PARTITION, parse_freebsd},
>  	{NETBSD_PARTITION, parse_netbsd},
> @@ -415,7 +419,7 @@ static struct {
>   
>  int msdos_partition(struct parsed_partitions *state, struct 
> block_device *bdev)
>  {
> -	int sector_size = bdev_logical_block_size(bdev) / 512;
> +	sector_t sector_size = bdev_logical_block_size(bdev) / 512;
>  	Sector sect;
>  	unsigned char *data;
>  	struct partition *p;
> @@ -483,8 +487,8 @@ int msdos_partition(struct parsed_partit
>  
>  	state->next = 5;
>  	for (slot = 1 ; slot <= 4 ; slot++, p++) {
> -		u32 start = START_SECT(p)*sector_size;
> -		u32 size = NR_SECTS(p)*sector_size;
> +		sector_t start = start_sect(p)*sector_size;
> +		sector_t size = nr_sects(p)*sector_size;
>  		if (!size)
>  			continue;
>  		if (is_extended_partition(p)) {
> @@ -513,7 +517,7 @@ int msdos_partition(struct parsed_partit
>  		unsigned char id = SYS_IND(p);
>  		int n;
>  
> -		if (!NR_SECTS(p))
> +		if (!nr_sects(p))
>  			continue;
>  
>  		for (n = 0; subtypes[n].parse && id != 
> subtypes[n].id; n++)
> @@ -521,8 +525,8 @@ int msdos_partition(struct parsed_partit
>  
>  		if (!subtypes[n].parse)
>  			continue;
> -		subtypes[n].parse(state, bdev, 
> START_SECT(p)*sector_size,
> -						
> NR_SECTS(p)*sector_size, slot);
> +		subtypes[n].parse(state, bdev, 
> start_sect(p)*sector_size,
> +						
> nr_sects(p)*sector_size, slot);
>  	}
>  	put_dev_sector(sect);
>  	return 1;
> _
> 
> -- 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> 
