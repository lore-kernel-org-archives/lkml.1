Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbYLLJmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbYLLJmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYLLJmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:42:11 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:40514 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbYLLJmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:42:09 -0500
Date: Fri, 12 Dec 2008 10:41:54 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Fix LSF default inconsistency
Message-ID: <20081212104154.0206d8a9@hyperion.delvare>
In-Reply-To: <20081212075431.GG23742@kernel.dk>
References: <20081211111614.493d2a62@hyperion.delvare>
	<20081211104109.GF23742@kernel.dk>
	<20081211115844.1b1dbf49@hyperion.delvare>
	<20081211110839.GH23742@kernel.dk>
	<20081211134438.6d871834@hyperion.delvare>
	<20081211125000.GL23742@kernel.dk>
	<20081212084850.1b56529f@hyperion.delvare>
	<20081212075431.GG23742@kernel.dk>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On Fri, 12 Dec 2008 08:54:33 +0100, Jens Axboe wrote:
> Agree, it's pretty ugly. Modified patch below, it drops CONFIG_LSF
> completely as it's basically only used in a single spot.

> On Fri, Dec 12 2008, Jean Delvare wrote:
> > As a side note, someone will have to tell me why changing the value of
> > option LSF triggers a full kernel rebuild.
> 
> It changes types.h, I guess pretty much everything has that included :-)

Indeed, that was the reason.

> diff --git a/block/Kconfig b/block/Kconfig
> index 1ab7c15..195968e 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -24,21 +24,17 @@ menuconfig BLOCK
>  if BLOCK
>  
>  config LBD
> -	bool "Support for Large Block Devices"
> +	bool "Support for large block devices and files"
>  	depends on !64BIT
>  	help
> -	  Enable block devices of size 2TB and larger.
> +	  Enable block devices or files of size 2TB and larger.
>  
>  	  This option is required to support the full capacity of large
>  	  (2TB+) block devices, including RAID, disk, Network Block Device,
>  	  Logical Volume Manager (LVM) and loopback.
> -
> -	  For example, RAID devices are frequently bigger than the capacity
> -	  of the largest individual hard drive.
> -
> -	  This option is not required if you have individual disk drives
> -	  which total 2TB+ and you are not aggregating the capacity into
> -	  a large block device (e.g. using RAID or LVM).
> +	
> +	  This option also enables support for single files larger than
> +	  2TB.
>  
>  	  If unsure, say N.
>  
> @@ -57,15 +53,6 @@ config BLK_DEV_IO_TRACE
>  
>  	  If unsure, say N.
>  
> -config LSF
> -	bool "Support for Large Single Files"
> -	depends on !64BIT
> -	help
> -	  Say Y here if you want to be able to handle very large files (2TB
> -	  and larger), otherwise say N.
> -
> -	  If unsure, say Y.
> -
>  config BLK_DEV_BSG
>  	bool "Block layer SG support v4 (EXPERIMENTAL)"
>  	depends on EXPERIMENTAL
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e4a241c..04158ad 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1721,7 +1721,7 @@ static loff_t ext4_max_size(int blkbits, int has_huge_files)
>  	/* small i_blocks in vfs inode? */
>  	if (!has_huge_files || sizeof(blkcnt_t) < sizeof(u64)) {
>  		/*
> -		 * CONFIG_LSF is not enabled implies the inode
> +		 * CONFIG_LBD is not enabled implies the inode
>  		 * i_block represent total blocks in 512 bytes
>  		 * 32 == size of vfs inode i_blocks * 8
>  		 */
> @@ -1764,7 +1764,7 @@ static loff_t ext4_max_bitmap_size(int bits, int has_huge_files)
>  
>  	if (!has_huge_files || sizeof(blkcnt_t) < sizeof(u64)) {
>  		/*
> -		 * !has_huge_files or CONFIG_LSF is not enabled
> +		 * !has_huge_files or CONFIG_LBD is not enabled
>  		 * implies the inode i_block represent total blocks in
>  		 * 512 bytes 32 == size of vfs inode i_blocks * 8
>  		 */
> @@ -2021,13 +2021,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	if (has_huge_files) {
>  		/*
>  		 * Large file size enabled file system can only be
> -		 * mount if kernel is build with CONFIG_LSF
> +		 * mount if kernel is build with CONFIG_LBD
>  		 */
>  		if (sizeof(root->i_blocks) < sizeof(u64) &&
>  				!(sb->s_flags & MS_RDONLY)) {
>  			printk(KERN_ERR "EXT4-fs: %s: Filesystem with huge "
>  					"files cannot be mounted read-write "
> -					"without CONFIG_LSF.\n", sb->s_id);
> +					"without CONFIG_LBD.\n", sb->s_id);
>  			goto failed_mount;
>  		}
>  	}
> diff --git a/include/linux/types.h b/include/linux/types.h
> index 1d98330..121f349 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -135,19 +135,14 @@ typedef		__s64		int64_t;
>   *
>   * Linux always considers sectors to be 512 bytes long independently
>   * of the devices real block size.
> + *
> + * blkcnt_t is the type of the inode's block count.
>   */

You might want to edit the start of this comment a bit, as it currently
says "The type used for...". You probably want instead "sector_t is the
type...". And drop the extra "*" while you're here, as this is a
regular comment and not a kerneldoc thing.

>  #ifdef CONFIG_LBD
>  typedef u64 sector_t;
> -#else
> -typedef unsigned long sector_t;
> -#endif
> -
> -/*
> - * The type of the inode's block count.
> - */
> -#ifdef CONFIG_LSF
>  typedef u64 blkcnt_t;
>  #else
> +typedef unsigned long sector_t;
>  typedef unsigned long blkcnt_t;
>  #endif
>  

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
