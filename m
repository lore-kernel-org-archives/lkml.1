Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbZCPDVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbZCPDVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 23:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZCPDVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 23:21:07 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:50445
	"EHLO QMTA15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbZCPDVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 23:21:06 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Mar 2009 23:21:06 EDT
Message-ID: <49BDC438.6080900@comcast.net>
Date: Sun, 15 Mar 2009 20:15:04 -0700
From: don fisher <hdf3@comcast.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nick Andrew <nick@nick-andrew.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH try #1] Kconfig: cleanup block/Kconfig help descriptions
References: <20080223225640.20233.12405.stgit@marcab.local.tull.net>
In-Reply-To: <20080223225640.20233.12405.stgit@marcab.local.tull.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick,

I am trying to configure a linux-2.6.28.7 kernel.

Please explain why the switch for large block devices should be !64BIT. 
I have a 64BIT system and currently cannot generate files greater than 
2TB. Is this the problem? Should this be true for 64BIT systems?

Thanks,
don

Nick Andrew wrote:
> Modify the help descriptions of block/Kconfig for clarity, accuracy and consistency.
> 
> Refactor the BLOCK description a bit. The wording "This permits ... to be
> removed" isn't quite right; the block layer is removed when the option
> is disabled, whereas most descriptions talk about what happens when the
> option is enabled. Reformat the list of what is affected by disabling the
> block layer.
> 
> Add more examples of large block devices to LBD and strive for technical
> accuracy; block devices of size _exactly_ 2TB require CONFIG_LBD,
> not only "bigger than 2TB". Also try to say (perhaps not very clearly)
> that the config option is only needed when you want to have individual
> block devices of size >= 2TB, for example if you had 3 x 1TB disks in
> your computer you'd have a total storage size of 3TB but you wouldn't
> need the option unless you want to aggregate those disks into a RAID
> or LVM.
> 
> Improve terminology and grammar on BLK_DEV_IO_TRACE.
> 
> I also added the boilerplate "If unsure, say N" to most options.
> 
> Precisely say "2TB and larger" for LSF.
> 
> Indent the help text for BLK_DEV_BSG by 2 spaces in accordance with
> the standard.
> 
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>
> ---
> I'm not sure why LSF has "If unsure, say Y." I would have thought it
> pretty uncommon to have such large files. Also if you need LSF, you
> probably need LBD (can NFS handle 2TB+ files?). Is this a safety
> feature? How often is Grandma going to mount a filesystem containing
> 2TB+ sized files?
> 
> Also the description for BLK_DEV_BSG is pretty obscure. Can anybody
> suggest why you'd want to do this or what tools you can use or even
> some documentation?
> 
> 
>  block/Kconfig |   65 +++++++++++++++++++++++++++++++++++++--------------------
>  1 files changed, 42 insertions(+), 23 deletions(-)
> 
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index 9bda7bc..a3d8509 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -5,14 +5,18 @@ menuconfig BLOCK
>         bool "Enable the block layer" if EMBEDDED
>         default y
>         help
> -	 This permits the block layer to be removed from the kernel if it's not
> -	 needed (on some embedded devices for example).  If this option is
> -	 disabled, then blockdev files will become unusable and some
> -	 filesystems (such as ext3) will become unavailable.
> +	 Provide block layer support for the kernel.
>  
> -	 This option will also disable SCSI character devices and USB storage
> -	 since they make use of various block layer definitions and
> -	 facilities.
> +	 Disable this option to remove the block layer support from the
> +	 kernel. This may be useful for embedded devices.
> +
> +	 If this option is disabled:
> +
> +	   - block device files will become unusable
> +	   - some filesystems (such as ext3) will become unavailable.
> +
> +	 Also, SCSI character devices and USB storage will be disabled since
> +	 they make use of various block layer definitions and facilities.
>  
>  	 Say Y here unless you know you really don't want to mount disks and
>  	 suchlike.
> @@ -23,9 +27,20 @@ config LBD
>  	bool "Support for Large Block Devices"
>  	depends on !64BIT
>  	help
> -	  Say Y here if you want to attach large (bigger than 2TB) discs to
> -	  your machine, or if you want to have a raid or loopback device
> -	  bigger than 2TB.  Otherwise say N.
> +	  Enable block devices of size 2TB and larger.
> +
> +	  This option is required to support the full capacity of large
> +	  (2TB+) block devices, including RAID, disk, Network Block Device,
> +	  Logical Volume Manager (LVM) and loopback.
> +
> +	  For example, RAID devices are frequently bigger than the capacity
> +	  of the largest individual hard drive.
> +
> +	  This option is not required if you have individual disk drives
> +	  which total 2TB+ and you are not aggregating the capacity into
> +	  a large block device (e.g. using RAID or LVM).
> +
> +	  If unsure, say N.
>  
>  config BLK_DEV_IO_TRACE
>  	bool "Support for tracing block io actions"
> @@ -33,19 +48,21 @@ config BLK_DEV_IO_TRACE
>  	select RELAY
>  	select DEBUG_FS
>  	help
> -	  Say Y here, if you want to be able to trace the block layer actions
> +	  Say Y here if you want to be able to trace the block layer actions
>  	  on a given queue. Tracing allows you to see any traffic happening
> -	  on a block device queue. For more information (and the user space
> -	  support tools needed), fetch the blktrace app from:
> +	  on a block device queue. For more information (and the userspace
> +	  support tools needed), fetch the blktrace tools from:
>  
>  	  git://brick.kernel.dk/data/git/blktrace.git
>  
> +	  If unsure, say N.
> +
>  config LSF
>  	bool "Support for Large Single Files"
>  	depends on !64BIT
>  	help
> -	  Say Y here if you want to be able to handle very large files (bigger
> -	  than 2TB), otherwise say N.
> +	  Say Y here if you want to be able to handle very large files (2TB
> +	  and larger), otherwise say N.
>  
>  	  If unsure, say Y.
>  
> @@ -53,14 +70,16 @@ config BLK_DEV_BSG
>  	bool "Block layer SG support v4 (EXPERIMENTAL)"
>  	depends on EXPERIMENTAL
>  	---help---
> -	Saying Y here will enable generic SG (SCSI generic) v4 support
> -	for any block device.
> -
> -	Unlike SG v3 (aka block/scsi_ioctl.c drivers/scsi/sg.c), SG v4
> -	can handle complicated SCSI commands: tagged variable length cdbs
> -	with bidirectional data transfers and generic request/response
> -	protocols (e.g. Task Management Functions and SMP in Serial
> -	Attached SCSI).
> +	  Saying Y here will enable generic SG (SCSI generic) v4 support
> +	  for any block device.
> +
> +	  Unlike SG v3 (aka block/scsi_ioctl.c drivers/scsi/sg.c), SG v4
> +	  can handle complicated SCSI commands: tagged variable length cdbs
> +	  with bidirectional data transfers and generic request/response
> +	  protocols (e.g. Task Management Functions and SMP in Serial
> +	  Attached SCSI).
> +
> +	  If unsure, say N.
>  
>  endif # BLOCK
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
-----------------------------------------------------------------
|    Don Fisher                         hdf3@comcast.net        |
|    865 W. Cresta Loma Dr.             VOICE: (520)888-7613    |
|    Tucson, AZ. 85704-3705                                     | 

-----------------------------------------------------------------

