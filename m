Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbYGFNra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbYGFNra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 09:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbYGFNrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 09:47:21 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:22106 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672AbYGFNrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 09:47:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=sg8Ps2vhCiirVBTIfCzAkehMwe+9+2ivxninqhjw1FRffqpZd6RlP5mYkF0RM8a7Bn
         7314AX2TaCuQqs6ffozPmPwuzwTbfunMnFAQRWd5JmbEAQmttpVOHqHMtPrN860v9170
         lNj923voGBB+IguX5e1mnCSyoWMMk2k/5HAZI=
Message-ID: <19f34abd0807060647k54490088uf8859d8a1646fd41@mail.gmail.com>
Date: Sun, 6 Jul 2008 15:47:19 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Thomas Gleixner" <tglx@linutronix.de>, venkatesh.pallipadi@intel.com,
       "Huang Ying" <ying.huang@intel.com>, "Andi Kleen" <andi@firstfloor.org>
Subject: v2.6.26-rc9: ACPI PCI irq routing on NUMA? + early_ioremap trouble
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have produced a config which doesn't boot correctly on either of my
computers with v2.6.26-rc9.

The first problem is with my laptop, which hangs on boot, see
screenshot (sorry for the bad quality, I was in a hurry):
http://folk.uio.no/vegardno/linux/DSCF3026.JPG

I figured there's something wrong with ACPI PCI irq routing as I'm
missing a message that shows up in my usual configs:

calling  ide_scan_pcibus+0x0/0xf0
ICH8M: IDE controller (0x8086:0x2850 rev 0x03) at  PCI slot 0000:00:1f.1
    --- HERE: ---
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
    ----
ICH8M: not 100% native mode: will probe irqs later

...and as can be seen in the screenshot, ide-cd "lost interrupt".
Unfortunately, I don't have a serial line on this machine, so it's
hard to get the full log. (Maybe I can try netconsole, it seems to be
up by the time this happens.)

(I also tried booting with acpi=off, acpi=noirq, pci=noacpi, to no avail.)

Note that this does not seem to be a regression; I get the same thing
with -rc8 as well. I'm guessing it's config-induced, here are my
config changes that triggered it:
http://folk.uio.no/vegardno/linux/config-diff

I'll make a guess for the NUMA/ACPI stuff. And this is the full
config: http://folk.uio.no/vegardno/linux/config-bisect

I decided to also try this kernel with my desktop machine. This one
boots (probably because ACPI is disabled?), but I get the following
warning:

[    0.000000] Begin SRAT table scan....
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/mm/ioremap.c:553 early_ioremap+0x1c1/0x200()
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.26-rc9 #201
[    0.000000]  [<c0157d6f>] warn_on_slowpath+0x4f/0x70
[    0.000000]  [<c01708db>] ? up+0x2b/0x40
[    0.000000]  [<c01586f1>] ? release_console_sem+0x1c1/0x1f0
[    0.000000]  [<c05c0132>] ? _spin_unlock_irqrestore+0x32/0x70
[    0.000000]  [<c05c0143>] ? _spin_unlock_irqrestore+0x43/0x70
[    0.000000]  [<c0158705>] ? release_console_sem+0x1d5/0x1f0
[    0.000000]  [<c0158aff>] ? vprintk+0x1cf/0x430
[    0.000000]  [<c0158b0b>] ? vprintk+0x1db/0x430
[    0.000000]  [<c07c0b24>] ? __early_set_fixmap+0xb4/0xd0
[    0.000000]  [<c07c1231>] early_ioremap+0x1c1/0x200
[    0.000000]  [<c07bd48e>] get_memcfg_from_srat+0x15e/0x6d0
[    0.000000]  [<c01314be>] ? post_set+0x4e/0x50
[    0.000000]  [<c01315fa>] ? generic_get_mtrr+0x2a/0x100
[    0.000000]  [<c07c154d>] setup_memory+0xd/0x280
[    0.000000]  [<c07b3c7e>] setup_arch+0x2ee/0x4e0
[    0.000000]  [<c0158d7b>] ? printk+0x1b/0x20
[    0.000000]  [<c07ab842>] start_kernel+0x82/0x390
[    0.000000]  [<c07ab028>] i386_start_kernel+0x8/0x10
[    0.000000]  =======================
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] failed to get NUMA memory information from SRAT table
[    0.000000] NUMA - single node, flat memory mode

What really puzzles me is the line number of the WARN -- it says
arch/x86/mm/ioremap.c:553. But this line does not contain any WARNs.
In fact, it's not even the right function. But this is a clean
v2.6.26-rc9 compile, as can be seen from the kernel version above.

There's also one a bit later:

[    7.746346] please boot with early_ioremap_debug and report the dmesg.
[    7.746460] ------------[ cut here ]------------
[    7.746569] WARNING: at arch/x86/mm/ioremap.c:524
check_early_ioremap_leak+0x3f/0x50()

See full dmesg at: http://folk.uio.no/vegardno/linux/dmesg-2.6.26-rc9
With early_ioremap_debug enabled:
http://folk.uio.no/vegardno/linux/dmesg-early_ioremap_debug

My apologies if I got the recipients wrong; I picked them off the
git-log for relevant files. Please Cc in the right direction if needed
:-)

Thanks!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
