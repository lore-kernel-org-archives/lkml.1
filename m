Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753164AbYLRGQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbYLRGQT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 01:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYLRGQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 01:16:06 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:61129 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYLRGQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 01:16:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YQkS1hK4bxLMsYqN9vJD1yTxYn0qdby2qxYvTa7nWaLAcYVQM7AGvcRQzo5ZfKm6HD
         jupYlLd/TFhaehjPhFFVXz9ZUZ6TJZsvDr/8CIwslL3Y499voTNOG1gheShHJpFpz8zC
         YymeSIWzr5F5uc4QYyowXoCVMeRWMJFwsaVbc=
Message-ID: <47ed01bd0812172216n1f8a82ao660424750c349dcb@mail.gmail.com>
Date: Thu, 18 Dec 2008 01:16:02 -0500
From: "Dylan Taft" <d13f00l@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: MDADM Software Raid Woes
In-Reply-To: <47ed01bd0812172033p1065b472t62491e4f2eed901@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47ed01bd0812172033p1065b472t62491e4f2eed901@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok...this is really bad.  I just lost data...

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xa6caa6dd

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1          63      506016   fd  Linux raid autodetect
/dev/sda2              64        3711    29302560   fd  Linux raid autodetect
/dev/sda3            3712        3836     1004062+  fd  Linux raid autodetect
/dev/sda4            3837      121601   945947362+  fd  Linux raid autodetect


cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md1 : active raid0 sdb2[1] sda2[0]
      58604928 blocks 64k chunks

md2 : active raid0 sdb3[1] sda3[0]
      2007936 blocks 64k chunks

md3 : active raid0 sdb4[1] sda4[0]
      1891894528 blocks 64k chunks

md0 : active raid1 sdb1[1] sda1[0]
      505920 blocks [2/2] [UU]

md3 is huge according to mdstat, like it's supposed to be.
Fdisk says it's md3: 29.0 GB, 29011435520 bytes
I did a mkfs.ext3 on it, and it's now a 30gb filesystem, which
methinks is part of md1...which is supposed to be 2 30 gb raid0
partitions, so I probably just lost data....?

The booting issue I was able to resolve by reading md.txt in
Documentation, apparently the md kernel option is required if you're
using raid for a root partition....

Is this raid array autodetection supposed to work like this, though?

Thanks

On Wed, Dec 17, 2008 at 11:33 PM, Dylan Taft <d13f00l@gmail.com> wrote:
> Hi all, apologies ahead of time if this mailing list isn't the correct one...
>
> I'm having two issues here...
>
> I've been trying to configure sofrware raid on my system
>
> Kernel Version: 2.6.28-rc7
>
> cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md1 : active raid0 sdc2[1] sdb2[0]
>      1952507776 blocks 64k chunks
>
> md0 : active raid1 sdc1[1] sdb1[0]
>      505920 blocks [2/2] [UU]
>
> /dev/sdb and sdc are set up identically, both paritition types set to
> "fd" so raid autodetect should work, md and related modules are built
> into my kernel
>
> /dev/sdb1               1          63      506016   fd  Linux raid autodetect
> /dev/sdb2              64      121601   976253985   fd  Linux raid autodetect
>
> I created the raids with the mdadm tool, originally configured manually
> /dev/md0 for sdb1/sdc1 raid1 to be mounted as /boot
> /dev/md1 for sdb2/sdc2 raid0
>
> I created 3 partitions on md1, one for future /, one for swap, one for
> future /home.
> So I had /dev/md0, md1, and /dev/md1p1,/dev/md1p2/dev/md1p3
>
> Upon rebooting, I end up with
>
> d13f00l-desktop proc # ls /dev/md* -al
> lrwxrwxrwx 1 root root   4 Dec 17 19:13 /dev/md0 -> md/0
> lrwxrwxrwx 1 root root   4 Dec 17 19:13 /dev/md1 -> md/1
> lrwxrwxrwx 1 root root   4 Dec 17 19:13 /dev/md1p1 -> md/1
> lrwxrwxrwx 1 root root   4 Dec 17 19:13 /dev/md1p2 -> md/2
> lrwxrwxrwx 1 root root   4 Dec 17 19:13 /dev/md1p3 -> md/3
>
> /dev/md:
> total 0
> drwxr-xr-x  2 root root    120 Dec 17 19:13 .
> drwxr-xr-x 18 root root  14680 Dec 17 19:13 ..
> brw-r-----  1 root disk   9, 0 Dec 17 19:13 0
> brw-r-----  1 root disk 259, 0 Dec 17 19:13 1
> brw-r-----  1 root disk 259, 1 Dec 17 19:13 2
> brw-r-----  1 root disk 259, 2 Dec 17 19:13 3
>
>
> md1 is seen as the first partition on md1, instead of as the physical
> raid with the additional partitions on it.
> Even if i mdadm --stop md1, and do mdadm -A /dev/md1 /dev/sdb2
> /dev/sdc2, md1 is seen as the first partition instead of as the whole
> raid
>
> fdisk:
> Disk /dev/md1: 30.0 GB, 30000003072 bytes
> 2 heads, 4 sectors/track, 7324219 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
> Disk identifier: 0x609b513e
>
>
> If I do mdadm -A /dev/md4 /dev/sdb2 /dev/sdc2
> and then fdisk md4, I see the partitions.
> Disk /dev/md4: 1999.3 GB, 1999367962624 bytes
> 2 heads, 4 sectors/track, 488126944 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
> Disk identifier: 0xe96a943b
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/md4p1               1     7324220    29296878   83  Linux
> /dev/md4p2         7324221     7568362      976568   82  Linux swap / Solaris
> /dev/md4p3         7568363   488126944  1922234328   83  Linux
>
>
>
> Is something being autodetected wrong here, or am I doing something
> wrong?  Should I not be creating partitions on a software raid device?
>
>
> The other issue is that I can't get my system to boot off the raid.
> cat lilo.conf
> # $Header: /var/cvsroot/gentoo-x86/sys-boot/lilo/files/lilo.conf,v 1.2
> 2004/07/18 04:42:04 dragonheart Exp $
> # Author: Ultanium
>
> #
> # Start LILO global section
> #
>
> # Faster, but won't work on all systems:
> #compact
> # Should work for most systems, and do not have the sector limit:
> lba32
> # If lba32 do not work, use linear:
> #linear
>
> # MBR to install LILO to:
> boot = /dev/md0
> raid-extra-boot=/dev/sdb,/dev/sdc
> map = /boot/.map
>
> # If you are having problems booting from a hardware raid-array
> # or have a unusual setup, try this:
> #disk=/dev/ataraid/disc0/disc bios=0x80  # see this as the first BIOS disk
> #disk=/dev/sda bios=0x80                 # see this as the second BIOS disk
> #disk=/dev/hda bios=0x82                 # see this as the third BIOS disk
>
> # Here you can select the secondary loader to install.  A few
> # examples is:
> #
> #    boot-text.b
> #    boot-menu.b
> #    boot-bmp.b
> #
> install = /boot/boot-menu.b   # Note that for lilo-22.5.5 or later you
>                              # do not need boot-{text,menu,bmp}.b in
>                              # /boot, as they are linked into the lilo
>                              # binary.
>
> menu-scheme=Wb
> prompt
> # If you always want to see the prompt with a 15 second timeout:
> #timeout=150
> delay = 50
> # Normal VGA console
> vga = normal
> # VESA console with size 1024x768x16:
> #vga = 791
>
> #
> # End LILO global section
> #
>
> #
> # Linux bootable partition config begins
> #
> image = /boot/bzImage
>        root = /dev/md/1
>        #root = /devices/discs/disc0/part3
>        label = Gentoo
>        #append = "irqpoll"
> #append = "mtrr_chunk_size=2048M mtrr_gran_size=16M"
>        read-only # read-only for checking
>
> image  = /boot/memtest86plus/memtest.bin
> label  = Memtest86Plus
>
> #
> # Linux bootable partition config ends
> #
>
> #
> # DOS bootable partition config begins
> #
> #other = /dev/hda1
> #       #other = /devices/discs/disc0/part1
> #       label = Windows
> #       table = /dev/hda
> #
> # DOS bootable partition config ends
> #
>
> At boot, /dev/md/1 is my root device.  It's an ext3 filesystem.  Ext3
> is built into the kernel and all, as is the raid stuff.  When I boot
> off sdb, i get a VFS panic, please append correct root= boot option,.
> Cannot open device 0x10300
>
> Am I doing something wrong here?
>
> Thanks!
>
> Dylan
>
