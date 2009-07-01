Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbZGAFkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbZGAFkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 01:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZGAFkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 01:40:12 -0400
Received: from plexity.net ([206.123.115.38]:36160 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbZGAFkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 01:40:11 -0400
Date: Tue, 30 Jun 2009 22:37:47 -0700
From: Deepak Saxena <dsaxena@plexity.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <HaraldWelte@viatech.com>
Subject: CONFIG_VMSPLIT_3G_OPT=y && viafb && newer GCC == hang
Message-ID: <20090701053747.GA5066@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Plexity, LLC
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



During bring up of the OLPC XO-1.5 board, I am seeing an issue where if I
enable CONFIG_VMSPLIT_3G_OPT (board has 1GiB RAM) and build a kernel with 
gcc 4.2.4 on Ubuntu 8.0.4 or gcc 4.4 on F11, the kernel hangs on a call to 
acquire_console_sem() from the viafbdev driver during device probe. If I
use gcc 4.1.2 on FC6, everything works OK.

I am still working on tracking down exactly what's happening but the
function trace is as follows and the .config is at [1]. If I disable
the viafb driver, the boot goes OK. I will continue to debug this but
wondering if anyone else seen a similar lockup with another driver
 when combining 3G_OPT and newer gccs?

Thanks,
~Deepak

[1] http://dev.laptop.org/~dsaxena/dumping_ground/viafb_gcc_lockup.config


[    0.584952]  [<b04168f8>] acquire_console_sem+0x8/0x45
[    0.590135]  [<b05b2780>] register_con_driver+0x6a/0x126
[    0.595477]  [<b05b4f50>] take_over_console+0x15/0x2f6
[    0.600659]  [<b07118a4>] ? _spin_unlock_irqrestore+0x17/0x2c
[    0.606433]  [<b0547108>] ? __debug_check_no_obj_freed+0xec/0x145
[    0.612573]  [<b0560563>] fbcon_takeover+0x62/0x9a
[    0.617390]  [<b0561f27>] fbcon_event_notify+0x1f1/0x58f
[    0.622756]  [<b07118a4>] ? _spin_unlock_irqrestore+0x17/0x2c
[    0.628527]  [<b0547108>] ? __debug_check_no_obj_freed+0xec/0x145
[    0.634664]  [<b0466ada>] ? cache_free_debugcheck+0x1a3/0x1ae
[    0.640449]  [<b053f3a2>] ? kobject_uevent_env+0x35d/0x380
[    0.645964]  [<b053dcd1>] ? idr_get_empty_slot+0x145/0x208
[    0.651488]  [<b053de84>] ? ida_get_new_above+0xf0/0x16b
[    0.656821]  [<b04a7d24>] ? sysfs_ilookup_test+0x0/0x11
[    0.662082]  [<b04a82a0>] ? sysfs_addrm_finish+0x16/0x1e1
[    0.667506]  [<b04a7f9a>] ? __sysfs_add_one+0x57/0x60
[    0.672598]  [<b071324f>] notifier_call_chain+0x2b/0x4a
[    0.677849]  [<b042957b>] __blocking_notifier_call_chain+0x37/0x4c
[    0.684074]  [<b042959c>] blocking_notifier_call_chain+0xc/0xe
[    0.689934]  [<b055796d>] fb_notifier_call_chain+0x11/0x13
[    0.695457]  [<b05596a2>] register_framebuffer+0x23a/0x24e
[    0.700980]  [<b070ba40>] via_pci_probe+0xad0/0xc88
[    0.705885]  [<b0554368>] local_pci_probe+0xe/0x10
[    0.710717]  [<b05549f2>] pci_device_probe+0x48/0x66
[    0.715711]  [<b05bf824>] driver_probe_device+0x78/0xeb
[    0.720979]  [<b05bf8da>] __driver_attach+0x43/0x5f
[    0.725882]  [<b05bee96>] bus_for_each_dev+0x39/0x5a
[    0.730883]  [<b05bf6fc>] driver_attach+0x14/0x16
[    0.735613]  [<b05bf897>] ? __driver_attach+0x0/0x5f
[    0.740616]  [<b05bf3a8>] bus_add_driver+0xf9/0x219
[    0.745517]  [<b05bfb0b>] driver_register+0x7b/0xd7
[    0.750434]  [<b0889d2f>] ? viafb_init+0x1d3/0x36a
[    0.755248]  [<b0554d44>] __pci_register_driver+0x44/0x98
[    0.760686]  [<b0889eb8>] viafb_init+0x35c/0x36a
[    0.765326]  [<b0401131>] _stext+0x49/0x10b
[    0.769536]  [<b0889b5c>] ? viafb_init+0x0/0x36a
[    0.774199]  [<b043ed10>] ? register_irq_proc+0x6a/0x83
[    0.779449]  [<b08796d1>] kernel_init+0x6b/0xb9
[    0.784021]  [<b0879666>] ? kernel_init+0x0/0xb9
[    0.788667]  [<b0403003>] kernel_thread_helper+0x7/0x10

Thanks,
~Deepak
