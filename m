Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZKINIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZKINIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 08:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbZKINIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 08:08:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826AbZKINIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 08:08:41 -0500
Date: Mon, 9 Nov 2009 14:08:27 +0100
From: Karel Zak <kzak@redhat.com>
To: Andries Brouwer <aeb@cwi.nl>, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] partitions: use sector size for EFI GPT
Message-ID: <20091109130827.GO5610@nb.net.home>
References: <1256294176-32113-1-git-send-email-kzak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256294176-32113-1-git-send-email-kzak@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 12:36:15PM +0200, Karel Zak wrote:
> Currently, kernel uses strictly 512-byte sectors for EFI GPT parsing.
> That's wrong.

 Ping? Does anyone care about new disks with non-512byte sectors? 
 (or fs/partitions is unmaintained area? ;-)

 Note that since 2.6.31 kernel properly reports topology information
 to userspace and many userspace tools (fdisk, parted, anaconda,
 libblkid, mkfs.xfs, mkfs.ext, ...) are able to follow such information.
 
 The current kernel EFI GPT code in not compatible with the latest 
 userspace and GPT partitions on disks with >512byte sectors will be 
 *invisible* for Linux kernel.

    Karel

> UEFI standard (version 2.3, May 2009, 5.3.1 GUID Format overview, page
> 95) defines that LBA is always based on the logical block size. It
> means bdev_logical_block_size() (aka BLKSSZGET) for Linux.
> 
> This patch removes static sector size from EFI GPT parser.
> 
> The problem is reproducible with the latest GNU Parted:
> 
>  # modprobe scsi_debug dev_size_mb=50 sector_size=4096
> 
>   # ./parted /dev/sdb print
>   Model: Linux scsi_debug (scsi)
>   Disk /dev/sdb: 52.4MB
>   Sector size (logical/physical): 4096B/4096B
>   Partition Table: gpt
> 
>   Number  Start   End     Size    File system  Name     Flags
>    1      24.6kB  3002kB  2978kB               primary
>    2      3002kB  6001kB  2998kB               primary
>    3      6001kB  9003kB  3002kB               primary
> 
>   # blockdev --rereadpt /dev/sdb
>   # dmesg | tail -1
>    sdb: unknown partition table      <---- !!!
> 
> with this patch:
> 
>   # blockdev --rereadpt /dev/sdb
>   # dmesg | tail -1
>    sdb: sdb1 sdb2 sdb3

-- 
 Karel Zak  <kzak@redhat.com>
