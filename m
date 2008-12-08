Return-Path: <linux-kernel-owner+w=401wt.eu-S1752337AbYLHIQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbYLHIQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 03:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbYLHIQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 03:16:43 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:39103 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYLHIQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 03:16:42 -0500
Date: Mon, 8 Dec 2008 09:16:37 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Mark Jackson <mpfj@mimc.co.uk>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: Badness at mm/backing-dev.c:179
In-Reply-To: <ac3eb2510812030422n15f1be2cn77aa5f66f1046933@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0812080915120.14941@anakin>
References: <49367691.5060007@mimc.co.uk> <ac3eb2510812030422n15f1be2cn77aa5f66f1046933@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008, Kay Sievers wrote:
> On Wed, Dec 3, 2008 at 13:07, Mark Jackson <mpfj@mimc.co.uk> wrote:
> > The following commit causes a "Badness at mm/backing-dev.c:179":-
> >
> > f1d0b063d993527754f062c589b73f125024d216 is first bad commit
> > commit f1d0b063d993527754f062c589b73f125024d216
> > Author: Kay Sievers <kay.sievers@vrfy.org>
> > Date:   Tue Dec 2 10:31:50 2008 -0800
> >
> >    bdi: register sysfs bdi device only once per queue
> 
> > Below is the extract from dmesg:-
> >
> > ------------[ cut here ]------------
> > Badness at mm/backing-dev.c:179
> 
> That's a known issue, and will not cause any harm besides printing
> this warning. Andrew added the warning to catch drivers who use one
> single request queue for multiple devices. Currently known are mtd and
> floppy (triggers only if you have more than one device per driver).
> The drivers need to be changed to use a separate queue per device, to
> get rid of this warning.

I guess this one (introduced after 2.6.28-rc7) is an incarnation of the same
issue?

WARNING: at mm/backing-dev.c:179 0x2069cb()
Modules linked in:
Call Trace: [<000273ee>] warn_on_slowpath+0x44/0x60
 [<001be5b0>] mutex_lock+0x0/0x24
 [<00075d1e>] ifind+0x16/0x5c
 [<000a0844>] sysfs_ilookup_test+0x0/0x18
 [<00075d92>] ilookup5+0x2e/0x38
 [<000a0e70>] sysfs_addrm_finish+0x1c/0x200
 [<000a047e>] sysfs_create_file+0x0/0x44
 [<000a0432>] sysfs_add_file_mode+0x5a/0x84
 [<000efc5a>] kobject_uevent_env+0x46/0x30c
 [<000a047e>] sysfs_create_file+0x0/0x44
 [<000a0478>] sysfs_add_file+0x1c/0x22
 [<000eff30>] kobject_uevent+0x10/0x16
 [<000e1332>] elv_register_queue+0x64/0x6e
 [<000eff20>] kobject_uevent+0x0/0x16
 [<000e450e>] blk_register_queue+0x56/0x94
 [<00051684>] bdi_register+0x54/0x5e
 [<000f4040>] sprintf+0x0/0x26
 [<000516b4>] bdi_register_dev+0x26/0x2c
 [<000e7e70>] add_disk+0xb8/0x12c
 [<000e7db8>] add_disk+0x0/0x12c
 [<0027e424>] atari_floppy_init+0x14c/0x6e4
 [<0027e2d8>] atari_floppy_init+0x0/0x6e4
 [<00002008>] do_one_initcall+0x0/0x19a
 [<002781ce>] __alloc_bootmem+0x0/0x1a
 [<00002024>] do_one_initcall+0x1c/0x19a
 [<001be5b0>] mutex_lock+0x0/0x24
 [<00075d1e>] ifind+0x16/0x5c
 [<000a0844>] sysfs_ilookup_test+0x0/0x18
 [<00075d92>] ilookup5+0x2e/0x38
 [<000a0e70>] sysfs_addrm_finish+0x1c/0x200
 [<002781ce>] __alloc_bootmem+0x0/0x1a
 [<000a0432>] sysfs_add_file_mode+0x5a/0x84
 [<001244aa>] sysdev_class_create_file+0x0/0x16
 [<000a0478>] sysfs_add_file+0x1c/0x22
 [<000a04bc>] sysfs_create_file+0x3e/0x44
 [<001244bc>] sysdev_class_create_file+0x12/0x16
 [<0027e102>] cpu_dev_init+0x4e/0x6c
 [<0026eaa8>] kernel_init+0x6e/0xc2
 [<0027e2d8>] atari_floppy_init+0x0/0x6e4
 [<0026ea3a>] kernel_init+0x0/0xc2
 [<00027902>] printk+0x0/0x1a
 [<00002ada>] kernel_thread+0x3a/0x4e

---[ end trace 7d0e1e0e92952ce0 ]---

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
