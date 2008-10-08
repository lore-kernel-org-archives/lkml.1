Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYJHQBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYJHQBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 12:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYJHQBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 12:01:23 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:23179 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYJHQBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 12:01:21 -0400
Message-ID: <ac3eb2510810080901g3c3ae2d6l1dd247ed2a1837af@mail.gmail.com>
Date: Wed, 8 Oct 2008 18:01:19 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Partition check considered as error is breaking mounting in 2.6.27
Cc: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>, me@bobcopeland.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, bogdano@mandriva.com.br,
       lcapitulino@mandriva.com.br, draconux@gmail.com,
       dlallement@mandriva.com, pterjan@mandriva.com, axboe@kernel.dk
In-Reply-To: <20080912163650.0f85a759.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0809121423030.14509-100000@iolanthe.rowland.org>
	 <200809121714.05443.herton@mandriva.com.br>
	 <b6c5339f0809121327k5fd6c980le0ec5d46be089af2@mail.gmail.com>
	 <200809121807.28345.herton@mandriva.com.br>
	 <20080912163650.0f85a759.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2008 at 1:36 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 12 Sep 2008 18:07:27 -0300
> Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
>
>> Yes, here goes a new version:
>
> Well gee.  Given a choice, I went and replied to the wrong thread.
> Here's what I think:
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
>                if (from + size > get_capacity(disk)) {
>                        printk(KERN_ERR " %s: p%d exceeds device capacity\n",
>                                disk->disk_name, p);
> -                       continue;
>                }
>                res = add_partition(disk, p, from, size, state->parts[p].flags);
>                if (res) {

I was happy to see the original fix, as if causes real problems for
userspace, that the kernel creates invalid block devices with a size
that exceeds the physical disk. So, if we can not make that partition
to skip, like original patch did, because of broken hardware we don't
want to break, can we make it at least do the obvious thing, and limit
the partition with the broken entry to the size of the underlying
hardware. So that the kernel does no longer pretend to have devices of
a size which the hardware does not have.

It breaks all sort of userspace tools which read the "size" file in
sysfs, or do BLKGETSIZE and we get, if we are lucky, only:
  attempt to access beyond end of device
  sda: rw=0, want=1953535936, limit=976773168
in other cases it might cause corruption, or lead mkfs to create
devices which will fail when they get used.

Thanks,
Kay
