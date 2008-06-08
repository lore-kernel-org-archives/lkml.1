Return-Path: <linux-kernel-owner+w=401wt.eu-S1760060AbYFHBqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060AbYFHBqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 21:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756257AbYFHBqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 21:46:24 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:7091 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbYFHBqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 21:46:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KdIydGFG4i6FT7l+v7AZHAg0+1L63gJj5Bh0lK3KFs5I+ZR1C2ye+u4xmbaIbkj7qy
         4aajnqxC/+jWLIn4fkYd48miHrIAuYkJXyJ5ENJZkOF3FO8KIfxsMEPg9KXysJeHvDvO
         nSLh7e/NEw8e78hf0xbZIR3PVtAu7xBCCs60Q=
Message-ID: <e9c3a7c20806071846w60b74aeegdf3e39afb36b5d9a@mail.gmail.com>
Date: Sat, 7 Jun 2008 18:46:20 -0700
From: "Dan Williams" <dan.j.williams@gmail.com>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte Veliciraptors
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com,
       "Alan Piszcz" <ap@solarrain.com>
In-Reply-To: <alpine.DEB.1.10.0806071015110.23323@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0806071015110.23323@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 7:22 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> First, the original benchmarks with 6-SATA drives with fixed formatting,
> using
> right justification and the same decimal point precision throughout:
> http://home.comcast.net/~jpiszcz/20080607/raid-benchmarks-decimal-fix-and-right-justified/disks.html
>
> Now for for veliciraptors!  Ever wonder what kind of speed is possible with
> 3 disk, 4,5,6,7,8,9,10-disk RAID5s?  I ran a loop to find out, each run is
> executed three times and the average is taken of all three runs per each
> RAID5 disk set.
>
> In short? The 965 no longer does justice with faster drives, a new chipset
> and motherboard are needed.  After reading or writing to 4-5 veliciraptors
> it saturates the bus/965 chipset.
>
> Here is a picture of the 12 veliciraptors I tested with:
> http://home.comcast.net/~jpiszcz/20080607/raid5-benchmarks-3to10-veliciraptors/raptors.jpg
>
> Here are the bonnie++ results:
> http://home.comcast.net/~jpiszcz/20080607/raid5-benchmarks-3to10-veliciraptors/veliciraptor-raid.html
>
> For those who want the results in text:
> http://home.comcast.net/~jpiszcz/20080607/raid5-benchmarks-3to10-veliciraptors/veliciraptor-raid.txt
>
> System used, same/similar as before:
> Motherboard: Intel DG965WH
> Memory: 8GiB
> Kernel: 2.6.25.4
> Distribution: Debian Testing x86_64
> Filesystem: XFS with default mkfs.xfs parameters [auto-optimized for SW
> RAID]
> Mount options: defaults,noatime,nodiratime,logbufs=8,logbsize=262144 0 1
> Chunk size: 1024KiB
> RAID5 Layout: Default (left-symmetric)
> Mdadm Superblock used: 0.90
>
> Optimizations used (last one is for the CFQ scheduler), it improves
> performance by a modest 5-10MiB/s:
> http://home.comcast.net/~jpiszcz/raid/20080601/raid5.html
>
> # Tell user what's going on.
> echo "Optimizing RAID Arrays..."
>
> # Define DISKS.
> cd /sys/block
> DISKS=$(/bin/ls -1d sd[a-z])
>
> # Set read-ahead.
> # > That's actually 65k x 512byte blocks so 32MiB
> echo "Setting read-ahead to 32 MiB for /dev/md3"
> blockdev --setra 65536 /dev/md3
>
> # Set stripe-cache_size for RAID5.
> echo "Setting stripe_cache_size to 16 MiB for /dev/md3"

Sorry to sound like a broken record,  16MiB is not correct.

size=$((num_disks * 4 * 16384 / 1024))
echo "Setting stripe_cache_size to $size MiB for /dev/md3"

...and commit 8b3e6cdc should improve the performance / stripe_cache_size ratio.

> echo 16384 > /sys/block/md3/md/stripe_cache_size
>
> # Disable NCQ on all disks.
> echo "Disabling NCQ on all disks..."
> for i in $DISKS
> do
>  echo "Disabling NCQ on $i"
>  echo 1 > /sys/block/"$i"/device/queue_depth
> done
>
> # Fix slice_idle.
> # See http://www.nextre.it/oracledocs/ioscheduler_03.html
> echo "Fixing slice_idle to 0..."
> for i in $DISKS
> do
>  echo "Changing slice_idle to 0 on $i"
>  echo 0 > /sys/block/"$i"/queue/iosched/slice_idle
> done
>

Thanks for putting this data together.

Regards,
Dan
