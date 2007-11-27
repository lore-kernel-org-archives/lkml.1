Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbXK0BSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbXK0BSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 20:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbXK0BRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 20:17:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:31162 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbXK0BRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 20:17:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q9Ux+KJ2KHi/+ecKyXjHPKyFT38MU1KFNa5C3b2GVNJYKwWHU0HwUZI3JYHClJ7qrlsM/0bJ55lGIvzIKa7i/OGLW0k74aQo+o9NZy3dCJi73DNBiV4w8/rGQrjqRUyjKw+N+JRDumgqYtYcbVPu8tWBtYP9/JCN8uIuCM40Hcc=
Message-ID: <d82e647a0711261717s12fdfd13q4961294cd957d7af@mail.gmail.com>
Date: Tue, 27 Nov 2007 09:17:52 +0800
From: "ming lei" <tom.leiming@gmail.com>
To: "Josh Goldsmith" <joshin@hotmail.com>
Subject: Re: Small System Paging Problem - OOM-killer goes nuts
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BLU103-DAV550703C13BE5EF0DDF51AD6740@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <BLU103-DAV550703C13BE5EF0DDF51AD6740@phx.gbl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems  oom happenes when VM(page frame reclaim) try to reclaim much
more memory by writing back dirty pages, but  there is not enough ram
for usb disk  related driver to finish the writeback operation. (usb
disk related driver: scsi_mod, usb mass storage, usbcore and uhci or
ehci )

You can try to set  much value to /proc/sys/vm/min_free_kbytes to
verify the above guess.

2007/11/26, Josh Goldsmith <joshin@hotmail.com>:
> Hi,
>
>  I have a Linksys NSLU2 running 2.6.21 (I can replicate the problem on
> 2.6.23 but it isn't fully supported on SlugOS).  It is a armv5teb device
> with 32MB of RAM, 400+ MB swap on its 160GB USB2 root disk.  The machine is
> used as a fileserver and to build packages for other ARM devices.  It may be
> underpowered by today's standard but is a whole lot faster than my first
> Linux system (386sx20 with 4MB RAM) but the whole system with disk uses <8
> watts and is silent.
>
>  The problem comes when I try to untar a large file (in this case
> linux-2.6.23.tar.bz2).  Regardless if I kill off every other process,
> eventually the oom-killer will appear and kill either the tar or the shell.
> I've tried every tuning option I and my buddy Google could find including
> (/proc/sys/vm/overcommit*) with no success.  I'm not worried about paging
> impacting performance.
>
>  I'd appreciate any help, pointers, or gentle taps with the cluebat.
>
> -Josh
>
> Error output to console: http://www.pastebin.ca/797155
>
> config ->  http://www.pastebin.ca/797206
>
> slug2>$ uname -a
> Linux slug2 2.6.21 #1 PREEMPT Fri Nov 9 11:54:06 MST 2007 armv5teb unknown
>
> slug2:~$ free
>             total       used       free     shared    buffers     cached
> Mem:         30352      29124       1228          0      10196       9468
> -/+ buffers/cache:       9460      20892
> Swap:       465876          0     465876
>
> cat /proc/swaps
> Filename                                Type            Size    Used
> Priority
> /dev/sda4                               partition       465876  0       -1
>
> slug2:~$ lsmod
> Module                  Size  Used by
> nfsd                  186556  8
> exportfs                4320  1 nfsd
> lockd                  51416  2 nfsd
> sunrpc                131952  2 nfsd,lockd
> reiserfs              255380  1
> ixp4xx_mac             14644  0
> ixp4xx_qmgr             5388  5 ixp4xx_mac
> mii                     3424  1 ixp4xx_mac
> ext3                  110472  2
> jbd                    47784  1 ext3
> mbcache                 5604  1 ext3
> ohci_hcd               16804  0
> ehci_hcd               30252  0
>
> slug2>$ dmesg
> <5>Linux version 2.6.21 (josh@styx) (gcc version 4.1.1) #1 PREEMPT Fri Nov 9
> 11:54:06 MST 2007
> <4>CPU: XScale-IXP42x Family [690541f1] revision 1 (ARMv5TE), cr=000039ff
> <4>Machine: Linksys NSLU2
> <4>Memory policy: ECC disabled, Data cache writeback
> <7>On node 0 totalpages: 8192
> <7>  DMA zone: 64 pages used for memmap
> <7>  DMA zone: 0 pages reserved
> <7>  DMA zone: 8128 pages, LIFO batch:0
> <7>  Normal zone: 0 pages used for memmap
> <4>CPU0: D VIVT undefined 5 cache
> <4>CPU0: I cache: 32768 bytes, associativity 32, 32 byte lines, 32 sets
> <4>CPU0: D cache: 32768 bytes, associativity 32, 32 byte lines, 32 sets
> <4>Built 1 zonelists.  Total pages: 8128
> <5>Kernel command line: rtc-x1205.probe=0,0x6f console=ttyS0,115200n8
> root=/dev/mtdblock4 rootfstype=jffs2 rw init=/linuxrc noirqdebug
> <6>IRQ lockup detection disabled
> <4>PID hash table entries: 128 (order: 7, 512 bytes)
> <4>Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
> <4>Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
> <6>Memory: 32MB = 32MB total
> <5>Memory: 30268KB available (1940K code, 154K data, 84K init)
> <7>Calibrating delay loop... 266.24 BogoMIPS (lpj=1331200)
> <4>Mount-cache hash table entries: 512
> <6>CPU: Testing write buffer coherency: ok
> <6>NET: Registered protocol family 16
> <4>IXP4xx: Using 16MiB expansion bus window size
> <4>PCI: IXP4xx is host
> <4>PCI: IXP4xx Using direct access for memory space
> <6>PCI: bus0: Fast back to back transfers disabled
> <6>dmabounce: registered device 0000:00:01.0 on pci bus
> <6>dmabounce: registered device 0000:00:01.1 on pci bus
> <6>dmabounce: registered device 0000:00:01.2 on pci bus
> <5>SCSI subsystem initialized
> <6>usbcore: registered new interface driver usbfs
> <6>usbcore: registered new interface driver hub
> <6>usbcore: registered new device driver usb
> <6>Time: OSTS clocksource has been installed.
> <6>NET: Registered protocol family 2
> <4>IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
> <4>TCP established hash table entries: 1024 (order: 1, 8192 bytes)
> <4>TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
> <6>TCP: Hash tables configured (established 1024 bind 1024)
> <6>TCP reno registered
> <4>NetWinder Floating Point Emulator V0.97 (double precision)
> <6>JFFS2 version 2.2. (NAND) (C) 2001-2006 Red Hat, Inc.
> <6>io scheduler noop registered
> <6>io scheduler deadline registered (default)
> <6>Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
> <6>serial8250.0: ttyS0 at MMIO 0xc8000000 (irq = 15) is a XScale
> <6>serial8250.0: ttyS1 at MMIO 0xc8001000 (irq = 13) is a XScale
> <4>RAMDISK driver initialized: 4 RAM disks of 10240K size 1024 blocksize
> <6>IXP4XX NPE driver Version 0.3.0 initialized
> <6>NFTL driver: nftlcore.c $Revision: 1.98 $, nftlmount.c $Revision: 1.41 $
> <6>IXP4XX-Flash.0: Found 1 x16 devices at 0x0 in 16-bit bank
> <7>IXP4XX-Flash.0: Found an alias at 0x800000 for the chip at 0x0
> <4> Intel/Sharp Extended Query Table at 0x0031
> <6>Using buffer write method
> <5>cfi_cmdset_0001: Erase suspend on write enabled
> <7>erase region 0: offset=0x0,size=0x20000,blocks=64
> <5>Searching for RedBoot partition table in IXP4XX-Flash.0 at offset
> 0x7e0000
> <5>6 RedBoot partitions found on MTD device IXP4XX-Flash.0
> <5>Creating 6 MTD partitions on "IXP4XX-Flash.0":
> <5>0x00000000-0x00040000 : "RedBoot"
> <6>nslu2 mac: 00:0f:66:7c:14:23
> <5>0x00040000-0x00060000 : "SysConf"
> <5>0x00060000-0x00080000 : "Loader"
> <5>0x00080000-0x00180000 : "Kernel"
> <5>0x00180000-0x007e0000 : "Flashdisk"
> <5>0x007e0000-0x00800000 : "FIS directory"
> <4>npe: searching for firmware...
> <6>npe: found at 0x1c010, IXP425/NPE-B func: 00, rev: 2.1, size: 11964, id:
> 01000201
> <6>Image loaded to NPE-B Func:0, Rel: 2:1, Status: 80800000
> <6>Initializing USB Mass Storage driver...
> <6>usbcore: registered new interface driver usb-storage
> <6>USB Mass Storage support registered.
> <6>input: ixp4xx beeper as /class/input/input0
> <6>i2c /dev entries driver
> <6>x1205 0-006f: chip found, driver version 1.0.7
> <6>x1205 0-006f: rtc core: registered x1205 as rtc0
> <6>Registered led device: ready
> <6>Registered led device: status
> <6>Registered led device: disk-1
> <6>Registered led device: disk-2
> <6>TCP cubic registered
> <6>NET: Registered protocol family 1
> <6>NET: Registered protocol family 17
> <6>XScale DSP coprocessor detected.
> <6>x1205 0-006f: setting the system clock to 2007-11-25 20:35:07
> (1196022907)
> <4>VFS: Mounted root (jffs2 filesystem).
> <6>Freeing init memory: 84K
> <4>PCI: enabling device 0000:00:01.2 (0140 -> 0142)
> <6>ehci_hcd 0000:00:01.2: EHCI Host Controller
> <6>ehci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
> <6>ehci_hcd 0000:00:01.2: irq 26, io mem 0x48002000
> <6>ehci_hcd 0000:00:01.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> <6>usb usb1: configuration #1 chosen from 1 choice
> <6>hub 1-0:1.0: USB hub found
> <6>hub 1-0:1.0: 5 ports detected
> <7>ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> <4>PCI: enabling device 0000:00:01.0 (0140 -> 0142)
> <6>ohci_hcd 0000:00:01.0: OHCI Host Controller
> <6>ohci_hcd 0000:00:01.0: new USB bus registered, assigned bus number 2
> <6>ohci_hcd 0000:00:01.0: irq 28, io mem 0x48000000
> <6>usb usb2: configuration #1 chosen from 1 choice
> <6>hub 2-0:1.0: USB hub found
> <6>hub 2-0:1.0: 3 ports detected
> <4>PCI: enabling device 0000:00:01.1 (0140 -> 0142)
> <6>ohci_hcd 0000:00:01.1: OHCI Host Controller
> <6>usb 1-1: new high speed USB device using ehci_hcd and address 2
> <6>ohci_hcd 0000:00:01.1: new USB bus registered, assigned bus number 3
> <6>ohci_hcd 0000:00:01.1: irq 27, io mem 0x48001000
> <6>usb usb3: configuration #1 chosen from 1 choice
> <6>hub 3-0:1.0: USB hub found
> <6>hub 3-0:1.0: 2 ports detected
> <6>usb 1-1: configuration #1 chosen from 1 choice
> <6>scsi0 : SCSI emulation for USB Mass Storage devices
> <7>usb-storage: device found at 2
> <7>usb-storage: waiting for device to settle before scanning
> <5>scsi 0:0:0:0: Direct-Access     Maxtor   3200             0344 PQ: 0
> ANSI: 4
> <5>SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
> <5>sda: Write Protect is off
> <7>sda: Mode Sense: 17 00 00 00
> <3>sda: assuming drive cache: write through
> <5>SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
> <5>sda: Write Protect is off
> <7>sda: Mode Sense: 17 00 00 00
> <3>sda: assuming drive cache: write through
> <6> sda: sda1 sda2 sda3 sda4
> <5>sd 0:0:0:0: Attached scsi disk sda
> <7>usb-storage: device scan complete
> <6>kjournald starting.  Commit interval 60 seconds
> <6>EXT3 FS on sda1, internal journal
> <6>EXT3-fs: recovery complete.
> <6>EXT3-fs: mounted filesystem with journal data mode.
> <6>IXP4XX Q Manager 0.2.1 initialized.
> <6>ixp4xx_mac driver 0.3.1: eth0 on NPE-B with PHY[1] initialized
> <5>ReiserFS: sda3: found reiserfs format "3.6" with standard journal
> <5>ReiserFS: sda3: using ordered data mode
> <5>ReiserFS: sda3: journal params: device sda3, size 8192, journal first
> block 18, max trans len 1024, max batch 900, max commit age 30, max trans
> age 30
> <5>ReiserFS: sda3: checking transaction log (sda3)
> <6>kjournald starting.  Commit interval 5 seconds
> <4>EXT3-fs warning: maximal mount count reached, running e2fsck is
> recommended
> <6>EXT3 FS on sda2, internal journal
> <6>EXT3-fs: recovery complete.
> <6>EXT3-fs: mounted filesystem with journal data mode.
> <5>ReiserFS: sda3: replayed 237 transactions in 21 seconds
> <5>ReiserFS: sda3: Using r5 hash to sort names
> <6>Adding 465876k swap on /dev/sda4.  Priority:-1 extents:1 across:465876k
> <6>eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
> <7>Link of eth0 is full-duplex
> <6>Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> <4>NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> <4>NFSD: starting 90-second grace period
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
