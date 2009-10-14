Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbZJNVvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbZJNVvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZJNVvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:51:15 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:63117 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbZJNVvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:51:14 -0400
To: catalin.marinas@arm.com
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.32-rc3 kmemleak] WARNING: at kernel/lockdep.c:3161 check_flags+0xbe/0x180()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200910140025.CAJ82820.MOtOFOLVFFSHJQ@I-love.SAKURA.ne.jp>
	<200910142055.HJH56741.FLOFSJOQHtFVMO@I-love.SAKURA.ne.jp>
	<1255522972.15103.8.camel@pc1117.cambridge.arm.com>
	<200910142212.IEI69780.MOtQOJHVSLOFFF@I-love.SAKURA.ne.jp>
	<1255532113.15103.36.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1255532113.15103.36.camel@pc1117.cambridge.arm.com>
Message-Id: <200910150650.JFC10892.QVLJMOOOFFSHFt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 15 Oct 2009 06:50:36 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> Could you check the object_cache->obj_size/buffer_size and
> scan_area_cache->obj_size/buffer_size in mm/kmemleak.c? The first
> impression is that these somehow are too big when they shouldn't.
OK. I'll check it later.

> >From your .config, you have DEBUG_PAGEALLOC enabled which may set
> buffer_size to a full PAGE_SIZE. This size also enables the off slab
> mgmt data.
> 
> If that's the case, my patch is still correct to avoid the recursive
> call but OOM is quite plausible (every object allocated needs another
> page for the kmemleak metadata).
Indeed. After applying http://lkml.org/lkml/2009/10/14/235 ,
I increased RAM from 512MB to 1736MB, and the system booted without OOM.

[    8.381581] kmemleak: Kernel memory leak detector initialized
[    8.436724] kmemleak: Automatic memory scanning thread started
[   88.765791] kmemleak: 275 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

I get some reports from /sys/kernel/debug/kmemleak .

unreferenced object 0xf703a430 (size 24):
  comm "swapper", pid 0, jiffies 4294892296
  hex dump (first 24 bytes):
    00 00 00 00 00 a4 03 f7 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00                          ........
  backtrace:
    [<c10c7260>] create_object+0xe0/0x240
    [<c13076ba>] kmemleak_alloc+0x6a/0xe0
    [<c10c25d8>] kmem_cache_alloc+0x138/0x1c0
    [<c14c42c6>] debug_objects_mem_init+0x86/0x520
    [<c14a57c2>] start_kernel+0x232/0x340
    [<c14a507f>] i386_start_kernel+0x7f/0xb0
    [<ffffffff>] 0xffffffff

unreferenced object 0xce8d6850 (size 24):
  comm "hald", pid 3483, jiffies 4294905535
  hex dump (first 24 bytes):
    00 00 00 00 f8 74 c4 c1 02 00 00 00 c4 59 49 c1  .....t.......YI.
    84 95 47 c1 00 00 00 00                          ..G.....
  backtrace:
    [<c10c7260>] create_object+0xe0/0x240
    [<c13076ba>] kmemleak_alloc+0x6a/0xe0
    [<c10c25d8>] kmem_cache_alloc+0x138/0x1c0
    [<c11a699d>] __debug_object_init+0x22d/0x2e0
    [<c11a6a97>] debug_object_init+0x17/0x20
    [<c1047c74>] init_timer_key+0x24/0x70
    [<c127c012>] sock_init_data+0xb2/0x220
    [<c12e6388>] unix_create1+0x78/0x160
    [<c12e820a>] unix_stream_connect+0x6a/0x3b0
    [<c1279ef2>] sys_connect+0x62/0x90
    [<c127a5d8>] sys_socketcall+0xb8/0x270
    [<c1002d38>] sysenter_do_call+0x12/0x36
    [<ffffffff>] 0xffffffff

unreferenced object 0xd49e8b78 (size 32):
  comm "insmod", pid 985, jiffies 4294894679
  hex dump (first 32 bytes):
    30 3a 30 3a 31 35 3a 30 00 5a 5a 5a 5a 5a 5a 5a  0:0:15:0.ZZZZZZZ
    5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a a5  ZZZZZZZZZZZZZZZ.
  backtrace:
    [<c10c7260>] create_object+0xe0/0x240
    [<c13076ba>] kmemleak_alloc+0x6a/0xe0
    [<c10c3e50>] __kmalloc+0x1c0/0x230
    [<c1199105>] kvasprintf+0x35/0x60
    [<c1190f91>] kobject_set_name_vargs+0x21/0x60
    [<c11e476f>] dev_set_name+0x1f/0x30
    [<c12161be>] scsi_sysfs_device_initialize+0xbe/0x120
    [<c1212d39>] scsi_alloc_sdev+0x189/0x210
    [<c1212e9b>] scsi_probe_and_add_lun+0xdb/0xc10
    [<c12140dc>] __scsi_scan_target+0xdc/0x680
    [<c12146fc>] scsi_scan_channel+0x7c/0x90
    [<c121479b>] scsi_scan_host_selected+0x8b/0x150
    [<c12148d9>] do_scsi_scan_host+0x79/0x80
    [<c1214ba3>] scsi_scan_host+0x163/0x200
    [<f809656c>] mptspi_probe+0x37c/0x400 [mptspi]
    [<c11b4583>] local_pci_probe+0x13/0x20

Regards.
