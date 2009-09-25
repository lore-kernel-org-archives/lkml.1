Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbZIYIpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbZIYIpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZIYIpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:45:02 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:46742 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZIYIo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:44:59 -0400
Date: Fri, 25 Sep 2009 17:44:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Rob Landley <rob@landley.net>
Cc: kernel list <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] 2.6.31 kernel built for sh4 doesn't boot under qemu-system-sh4.
Message-ID: <20090925084430.GA14363@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
References: <200909201919.17990.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909201919.17990.rob@landley.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 07:19:17PM -0500, Rob Landley wrote:
> The 2.6.30 kernel in the system image at
> http://impactlinux.com/fwl/downloads/binaries/system-image-sh4.tar.bz2
> boots to a shell prompt under a reasonably current qemu-git snapshot (sometime 
> Tuesday I think).
> 
In the future please make sure to cc the linux-sh@vger.kernel.org list, I
only stumbled across this by chance.

> >Kernel command line: root=/dev/sda rw init=/usr/sbin/init.sh panic=1
> > PATH=/usr/distcc:/usr/bin console=ttySC0 DISTCC_HOSTS=10.0.2.2:28739/4
> > CPUS=4 NR_IRQS:256
> >Using R2D-PLUS interrupt controller.
> >PID hash table entries: 256 (order: 8, 1024 bytes)
> >Console: colour dummy device 80x25
> >Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
> >Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
> >Memory: 61072k/65536k available (2306k kernel code, 598k data, 116k init)
> >PVR=04050005 CVR=00110000 PRR=00000113
> >I-cache : n_ways=2 n_sets=64 way_incr=2048
> >I-cache : entry_mask=0x000007e0 alias_mask=0x00000000 n_aliases=0
> >D-cache : n_ways=2 n_sets=64 way_incr=2048
> >D-cache : entry_mask=0x000007e0 alias_mask=0x00000000 n_aliases=0
> >Calibrating delay loop (skipped)... 120.00 BogoMIPS PRESET (lpj=240000)
> >Mount-cache hash table entries: 512
> >CPU: SH7751R
> >net_namespace: 520 bytes
> >NET: Registered protocol family 16
> >PCI: Starting intialization.
> >PCI: Using configuration type 1
> >registering PCI controller with io_map_base unset
> >bio: create slab <bio-0> at 0
> >SCSI subsystem initialized
> >usbcore: registered new interface driver usbfs
> >usbcore: registered new interface driver hub
> >usbcore: registered new device driver usb
> >NET: Registered protocol family 2
> >IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
> >TCP established hash table entries: 2048 (order: 2, 16384 bytes)
> >TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
> >TCP: Hash tables configured (established 2048 bind 2048)
> >TCP reno registered
> >NET: Registered protocol family 1
> >trapped io 0xc0000000 overrides mmio 0xb4001000
> >trapped io 0xc0001000 overrides mmio 0xb400080c

Also, you do not want to be using trapped io with qemu, it is only there
to aid broken hardware, and degrades performance under emulation. Boot
with the "noiotrap" argument on the kernel command line, documented in
Documentation/kernel-parameters.txt.

> >squashfs: version 4.0 (2009/01/31) Phillip Lougher
> >msgmni has been set to 119
> >io scheduler noop registered
> >io scheduler anticipatory registered (default)
> >io scheduler deadline registered
> >io scheduler cfq registered
> >pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> >Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> >SuperH SCI(F) driver initialized
> >sh-sci: ttySC0 at MMIO 0xffe80000 (irq = 40) is a scif
> >console [ttySC0] enabled
> >brd: module loaded
> >sm501 sm501: SM501 At b3e00000: Version 050100a0, 8 Mb, IRQ 100
> 
> And hangs at that point.
> 
Well, the fact you have no clocksource or clockevent messages in this
log explains why you're hanging..

> I've managed to bisect it to kernel commit 
> 8be5f1a68f2c14082939dd54e7037dcee2eb54f8 which is messing around with the 
> timer code.
> 
It's not so much "messing around" as it is "moving to new
infrastructure". I can guess what happened. You probably ran through
oldconfig across these versions, the old TMU config option went away, and
the new one was default-disabled, leaving you without clockevents. Lets
see..

> #
> # Timer and clock configuration
> #
> # CONFIG_SH_TIMER_TMU is not set
> CONFIG_SH_PCLK_FREQ=60000000
> CONFIG_SH_CLK_CPG=y
> CONFIG_SH_CLK_CPG_LEGACY=y
> # CONFIG_NO_HZ is not set
> # CONFIG_HIGH_RES_TIMERS is not set
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> 
And here we can see that the TMU option is unset. Fix this up and
everything should be fine. It's actually quite remarkable how far you
made it in the boot process without a timer interrupt.

I'm running current git with qemu and the kernel without any issue,
except for the aforementioned libata stuff.
