Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbYG0U3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbYG0U3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 16:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758062AbYG0U27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 16:28:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38025 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840AbYG0U25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 16:28:57 -0400
Date: Sun, 27 Jul 2008 21:23:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, tim@physik3.uni-rostock.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nwflash: fix build errors and warning
Message-ID: <20080727202325.GJ32366@flint.arm.linux.org.uk>
References: <200807250848.m6P8mIWF001718@imap1.linux-foundation.org> <20080726141808.GB8871@flint.arm.linux.org.uk> <20080726150155.GA3562@localhost.localdomain> <20080726165258.2dacff67@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726165258.2dacff67@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 04:52:58PM +0100, Alan Cox wrote:
> 
> > Sorry. I'm preparing cross compiler. But this patch should fix this
> > problem.
> 
> nwflash is a flash programming driver. Any changes to it should be
> rigorously tested or obviously correct because you can brick a netwindup
> if you get it wrong.

Well, Ralph volunteered to test the changes to nwflash.c, but it seems
something is buggered with the kernel at the moment - it doesn't seem
to want to mount a rootfs, or even enter prepare_namespace().

[NeTTrom] Second level jump mode
   [FB B0=0x00000045][FB B1=0x01000045][FB B2=0x00000000][FB B3=0x00000000]
   [Kern loc=0x01C00000]
   [VGA_30=0x02][VGA_71=0x50][VGA_72=0x06]
   [VGA_B2=0xDB][VGA_B3=0x54]
[CMD=ide0=autotune console=ttyS0,115200 noinitrd keepinitrd root=/dev/sda1 rootwait rootdelay=5 netconfig_eth0=disk netconfig_eth1=disk ]
Assuming A.OUT kernel
Copying 0x0027EA00 bytes from 0x01C00200 to 0x0000C000
Initrd: scan 0x0027E7FC bytes @ 0x01C00204.
Found CRAMdisk at 0x01C03454.
CRAMdisk image @0xC0400000, size 0x0027B7B0.
Kernel entry point 0x0000C000

Press '*' TWICE to enter debug......Booting kernel...
Uncompressing Linux............................................................................................................................................. done, booting the kernel.
...
Kernel command line: ide0=autotune console=ttyS0,115200 noinitrd keepinitrd root=/dev/sda1 rootwait rootdelay=5 netconfig_eth0=disk netconfig_eth1=disk
...
NET: Registered protocol family 1
checking if image is initramfs...it isn't (bad gzip magic numbers); looks like an initrd
NetWinder Floating Point Emulator V0.97 (double precision)
...
pata_sl82c105 0000:00:0c.1: pata_sl82c105: Early bridge revision, no DMA available.
scsi0 : pata_sl82c105
scsi1 : pata_sl82c105
ata1: PATA max PIO4 cmd 0x10c0 ctl 0x10d0 bmdma 0x10a0 irq 14
ata2: PATA max PIO4 cmd 0x10c8 ctl 0x10d1 bmdma 0x10a8 irq 14
ata1.00: ATA-4: TOSHIBA MK4006MAV, F2.03 A, max UDMA/33
ata1.00: 8007552 sectors, multi 16: LBA
ata1.00: configured for PIO4
scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK4006MA F2.0 PQ: 0 ANSI: 5
...
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 5
mice: PS/2 mouse device common for all mice
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
Freeing init memory: 940K
Failed to execute /init
Kernel panic - not syncing: No init found.  Try passing init= option to kernel.

Note that we've passed rootdelay, which should print
"Waiting 5sec before mounting root device..." on entry to
prepare_namespace().  This implies that in init/main.c:


        if (!ramdisk_execute_command)
                ramdisk_execute_command = "/init";

        if (sys_access((const char __user *) ramdisk_execute_command, 0) != 0) {                ramdisk_execute_command = NULL;
                prepare_namespace();
        }

is somehow finding a /init.

I wonder if (because of the Nettrom deciding the kernel image is a CRAMfs
image) whether the kernel is somehow decoding itself and finding a /init
inside somehow...

In any case, the kernel seems rather broken on Netwinders at present, so
changes to nwflash.c won't corrupt anyones flash until whatever's causing
this no-rootfs problem is fixed.
