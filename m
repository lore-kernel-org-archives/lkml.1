Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbYIMW4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbYIMW4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 18:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYIMW4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 18:56:35 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:57818 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYIMW4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 18:56:34 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Partition check considered as error is breaking mounting in 2.6.27
Date: Sat, 13 Sep 2008 19:56:30 -0300
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, inux-usb@vger.kernel.org,
       bogdano@mandriva.com.br, lcapitulino@mandriva.com.br
References: <200809121356.50628.herton@mandriva.com.br> <20080912163416.112152e5.akpm@linux-foundation.org>
In-Reply-To: <20080912163416.112152e5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809131956.30304.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 September 2008 20:34:16 Andrew Morton wrote:
> On Fri, 12 Sep 2008 13:56:49 -0300
> Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
> 
> > Recently I found a problem with a buggy camera that doesn't mount anymore with 
> > 2.6.27 (its memory is available via usb-storage), since commit 
> > 04ebd4aee52b06a2c38127d9208546e5b96f3a19
> > 
> > The camera is an Olympus X-840. The original issue comes from the camera 
> > itself: its format program creates a partition with an off by one error, 
> > while the device reports that its memory has 42079 sectors, the partition 
> > table reports also that the only partition on the disk has the size of 42079, 
> > but it fails to account for the first sector in the memory that contains the 
> > partition table, so in the end the partition exceeds the limit of the device 
> > size (42080, first sector plus 42079 from the first partition).
> > 
> > In previous kernels (2.6.26 and before), I still could mount and access the 
> > device (/dev/sdb1), although with the following errors:
> 
> Yeah.
> 
> Can you test this please?

I have seen your reply on the other thread, but just to confirm yes, I tested
yesterday the same change that fixed the problem. I saw that the commit is
now on mainline, so regression fixed, thanks.

> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Herton Krzesinski reports that the error-checking changes in
> 04ebd4aee52b06a2c38127d9208546e5b96f3a19 ("block/ioctl.c and
> fs/partition/check.c: check value returned by add_partition") cause his
> buggy USB camera to no longer mount.  "The camera is an Olympus X-840. 
> The original issue comes from the camera itself: its format program
> creates a partition with an off by one error".
> 
> Buggy devices happen.  It is better for the kernel to warn and to proceed
> with the mount.
> 
> Reported-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> Cc: Abdel Benamrouche <draconux@gmail.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/partitions/check.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff -puN fs/partitions/check.c~rescan_partitions-make-device-capacity-errors-non-fatal fs/partitions/check.c
> --- a/fs/partitions/check.c~rescan_partitions-make-device-capacity-errors-non-fatal
> +++ a/fs/partitions/check.c
> @@ -540,7 +540,6 @@ int rescan_partitions(struct gendisk *di
>  		if (from + size > get_capacity(disk)) {
>  			printk(KERN_ERR " %s: p%d exceeds device capacity\n",
>  				disk->disk_name, p);
> -			continue;
>  		}
>  		res = add_partition(disk, p, from, size, state->parts[p].flags);
>  		if (res) {
> _
> 
> 

-- 
[]'s
Herton
