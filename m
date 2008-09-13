Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbYIMPzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbYIMPzN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 11:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYIMPy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 11:54:59 -0400
Received: from main.gmane.org ([80.91.229.2]:59303 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbYIMPy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 11:54:58 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Partition check considered as error is breaking mounting in 
  2.6.27
Date: Sat, 13 Sep 2008 11:54:44 -0400
Message-ID: <gagno4$pp9$1@ger.gmane.org>
References: <200809121356.50628.herton@mandriva.com.br> <20080912163416.112152e5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-71-245-142-197.albyny.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080716 Fedora/1.1.11-1.fc9 SeaMonkey/1.1.11
In-Reply-To: <20080912163416.112152e5.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 12 Sep 2008 13:56:49 -0300
> Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
> 
>> Recently I found a problem with a buggy camera that doesn't mount anymore with 
>> 2.6.27 (its memory is available via usb-storage), since commit 
>> 04ebd4aee52b06a2c38127d9208546e5b96f3a19
>>
>> The camera is an Olympus X-840. The original issue comes from the camera 
>> itself: its format program creates a partition with an off by one error, 
>> while the device reports that its memory has 42079 sectors, the partition 
>> table reports also that the only partition on the disk has the size of 42079, 
>> but it fails to account for the first sector in the memory that contains the 
>> partition table, so in the end the partition exceeds the limit of the device 
>> size (42080, first sector plus 42079 from the first partition).
>>
>> In previous kernels (2.6.26 and before), I still could mount and access the 
>> device (/dev/sdb1), although with the following errors:
> 
> Yeah.
> 
> Can you test this please?
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
I really like the patch Herton posted, with the big comment on why you don't 
want continue, to avoid repeating this conversation in a few years.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

