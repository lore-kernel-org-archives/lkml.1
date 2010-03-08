Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab0CHHyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 02:54:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40506 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab0CHHyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 02:54:40 -0500
Message-ID: <4B94ACE8.4060400@zytor.com>
Date: Sun, 07 Mar 2010 23:53:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, mkp@mkp.net
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <1268031640.4389.11.camel@mulgrave.site>
In-Reply-To: <1268031640.4389.11.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2010 11:00 PM, James Bottomley wrote:
> Just a quick note:
>
> The 2TB size for msdos partitions is a problem independent of the 4k
> sector issue.  Traditional 512 byte sector drives are now available in
> those sizes.  It looks like we're going to have to move to a new
> partitioning label to solve this.
>
> There's actually another barrier at 8 or 16TB, which is where a 4k
> logical sector filesystem tops out using 32 bit block offsets (it's 8TB
> if the fs hasn't been proof checked against sign extension problems).
>
> However, for 4k sectors, the main issues which have shown up in testing
> by others (mostly Martin) are
>
>       1. In native 4k mode, we work perfectly fine.  *however*, most
>          BIOSs can't boot native 4k drives.
>       2. Even if the BIOS can boot native 4k, our own boot loaders seem
>          to be hard coded for 512 byte sectors in several places.
>       3. If we run in the 512 byte sector emulation mode, we end up with
>          the partition alignment problems you allude to.
>       4. The aligment problem is made more complex by drives that make
>          use of the offset exponent feature (what you refer to as offset
>          by one) ... fortunately very few of these have been seen in the
>          wild and we're hopeful they can be shot before they breed.
>       5. I'm really, really sorry to have to mention it, but it looks
>          like uefi is going to be the only way we can boot non-msdos
>          partitioned devices with native 4k sectors.
>
> so the bottom line seems to be that if you want the device as a non boot
> disk, use native 4k sectors and a non-msdos partition label.  If you
> want to boot from the drive and your bios won't book 4k natively,
> partition everything using the 512 emulation and try to align the
> partitions correctly.  If your bios/uefi will boot 4k natively, just use
> it and whatever partition label the bios/uefi supports.
>
> Martin can fill in the pieces I've left out.
>

I would very much like a reference for a platform which has firmware 
which can successfully boot from 4K-logical media.  It would be very 
useful for bootloader testing.

Aligning partitions is something we should have done long ago.  It 
affects RAID and many flash drives just as much or more than 4K-sectored 
disks.

Legacy BIOS doesn't care at all how the disk is partitioned, so as long 
as the BIOS can read the disk at all the rest is up to the bootloader. 
Of course, since there hasn't been the opportunity to test, bootloaders 
generally don't handle it correctly (early versions of Syslinux 
supported any sector size, but that bitrotted, and for the lack of 
testing I eventually ended up hard-coding the number.  Now I'd like to 
get it working properly.)

As far as partitioning... I believe we should be using GPT partition 
tables where possible.  Even on non-EFI systems, it's simply a much 
better partition table format.

	-hpa
