Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbZCBCPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbZCBCPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 21:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759309AbZCBCPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 21:15:22 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:50626 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759141AbZCBCPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 21:15:19 -0500
Message-Id: <200903020215.n222FBpu067502@www262.sakura.ne.jp>
Subject: Re: linux-next-20090225: ide-cd triggers BUG at arch/x86/mm/ioremap.c:80!
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: bzolnier@gmail.com, petkovbb@gmail.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Mar 2009 11:15:11 +0900
References: <200902260229.n1Q2T2lY006773@www262.sakura.ne.jp> <200902261529.43554.bzolnier@gmail.com> <9ea470500902260751t4221d04cm839765a93300d861@mail.gmail.com>
In-Reply-To: <9ea470500902260751t4221d04cm839765a93300d861@mail.gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 02032009 #1679932, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:
> Could you try to narrow down the issue by bisecting linux-next?
Below is what I tried.

# git bisect start next-20090227 v2.6.29-rc6 -- drivers/ide/
Bisecting: 82 revisions left to test after this
[014d273312ccf10311f8a95263330b20684936bc] au1xxx-ide: auide_dma_end() cleanup
# git bisect good
Bisecting: 41 revisions left to test after this
[3ddb800f6e42c0c3f9d172d50250b0c678f2baea] ide-cd: use ide_end_rq() also for failed non-fs requests
# git bisect good
Bisecting: 20 revisions left to test after this
[edf7ed742637b50e4977d7331d411fee79d2ddaf] ide: destroy DMA mappings after ending DMA (v2)
# git bisect bad
Bisecting: 10 revisions left to test after this
[cba1f97899c72442600464aaae5a24c7e0b65656] ide-cd: cleanup ide_cd_do_request()
# git bisect good
Bisecting: 5 revisions left to test after this
[7a4366a812ec85b9fb6e2d1dcc3d5b5265c1b529] ide-cd: use common completion path for DMA requests in cdrom_newpc_intr()
# git bisect bad
Bisecting: 2 revisions left to test after this
[9c23f4e08167015bcd889a1af64f751cfd67098f] ide-cd: fix non-SECTOR_SIZE-multiples PIO transfers for fs requests
# git bisect good
Bisecting: 1 revisions left to test after this
[09ba9b1c0591203d1e18821dfbc6748f6bc6c87d] ide-cd: use scatterlists for PIO transfers (non-fs requests)
# git bisect bad
Bisecting: 0 revisions left to test after this
[5057301c48092007e9f1892a8de94d1091a86517] ide-cd: merge ide_cd_prepare_rw_request() into cdrom_start_rw()
# git bisect good
09ba9b1c0591203d1e18821dfbc6748f6bc6c87d is first bad commit
commit 09ba9b1c0591203d1e18821dfbc6748f6bc6c87d
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Fri Feb 27 09:15:51 2009 +1100

    ide-cd: use scatterlists for PIO transfers (non-fs requests)

    Convert ide-cd to use scatterlists for PIO transfers and get rid of
    partial completions (except on error) also for non-fs requests.

    Cc: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

:040000 040000 ed031364d219241aabb64458023e7b212166df72 c384309fff17ce6004f3348d6c8be94375e9f372 M      drivers

Borislav Petkov wrote:
> Can you also apply the following patch and send us the output?
I applied the patch after "git bisect reset" since I couldn't apply from this
state.

[    3.419143] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    3.424508] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    3.429658] ide-gd driver 1.18
[    3.433879] ide-cd driver 5.00
[    3.440135] mapping rq to sg: dev hda: type=a, flags=82640
[    3.441873]   sector 4294967295, nr/cnr 0/0
[    3.445288]   bio (null), biotail (null), buffer (null), data f700fbc4, len 24
[    3.452602] ide-cd: hda: ATAPI 1X CD-ROM drive, 32kB Cache
[    3.456659] Uniform CD-ROM driver Revision: 3.20
[    3.460913] mapping rq to sg: dev hda: type=a, flags=8a640
[    3.464697]   sector 4294967295, nr/cnr 0/0
[    3.465881]   bio (null), biotail (null), buffer (null), data (null), len 0
[    3.472354] Pid: 1, comm: swapper Not tainted 2.6.29-rc6-next-20090227-dirty #10
[    3.476790] Call Trace:
[    3.477860]  [<c02ef9bd>] ide_cd_do_request+0x12d/0x170
[    3.480496]  [<c02e1d28>] start_request+0xa8/0x160
[    3.481883]  [<c015d92b>] ? trace_hardirqs_on+0xb/0x10
[    3.485680]  [<c02e1f7b>] do_ide_request+0x16b/0x250
[    3.489231]  [<c025e5a5>] ? blk_remove_plug+0x75/0xf0
[    3.492817]  [<c025f770>] blk_start_queueing+0x20/0x30
[    3.495475]  [<c025d2be>] elv_insert+0x17e/0x1b0
[    3.497088]  [<c025e458>] ? blk_plug_device+0x88/0x120
[    3.499681]  [<c025d372>] __elv_add_request+0x82/0xc0
[    3.501428]  [<c0263ad0>] blk_execute_rq_nowait+0x60/0xb0
[    3.504214]  [<c0263bb6>] blk_execute_rq+0x96/0xd0
[    3.505802]  [<c0263a40>] ? blk_end_sync_rq+0x0/0x30
[    3.508392]  [<c025f59c>] ? get_request_wait+0x2c/0x160
[    3.509883]  [<c0160429>] ? __lock_acquired+0x109/0x1c0
[    3.512691]  [<c025f6f4>] ? blk_get_request+0x24/0x80
[    3.515239]  [<c02ef196>] ide_cd_queue_pc+0xb6/0x140
[    3.516904]  [<c01a9614>] ? trace+0x14/0x90
[    3.519311]  [<c01a920a>] ? check_object+0xaa/0x1c0
[    3.521082]  [<c01a8e34>] ? init_object+0x14/0x90
[    3.523696]  [<c01a9854>] ? alloc_debug_processing+0xf4/0x120
[    3.525670]  [<c02efac7>] cdrom_check_status+0x87/0x90
[    3.528380]  [<c015d92b>] ? trace_hardirqs_on+0xb/0x10
[    3.529883]  [<c02efc76>] ide_cd_read_toc+0x46/0x430
[    3.532577]  [<c02ebe61>] ? ide_add_proc_entries+0x31/0x60
[    3.535498]  [<c02f08a4>] ? ide_cdrom_setup+0x104/0x140
[    3.537249]  [<c02f0d7b>] ide_cd_probe+0x11b/0x170
[    3.539689]  [<c01fb9f0>] ? sysfs_do_create_link+0xc0/0x150
[    3.541533]  [<c015a4f4>] ? lock_release_holdtime+0x74/0xc0
[    3.544319]  [<c01fba97>] ? sysfs_create_link+0x17/0x20
[    3.545883]  [<c02e0ba4>] generic_ide_probe+0x24/0x30
[    3.548642]  [<c02be6ac>] really_probe+0x8c/0x110
[    3.551114]  [<c02be81c>] driver_probe_device+0x1c/0x30
[    3.552862]  [<c01516af>] ? down+0x2f/0x50
[    3.555169]  [<c02be964>] __driver_attach+0x74/0x80
[    3.556805]  [<c02bd625>] bus_for_each_dev+0x55/0x70
[    3.559303]  [<c02be98e>] driver_attach+0x1e/0x30
[    3.560885]  [<c02be8f0>] ? __driver_attach+0x0/0x80
[    3.563395]  [<c02bdda6>] bus_add_driver+0xb6/0x1a0
[    3.565049]  [<c02e0be0>] ? generic_ide_shutdown+0x0/0x30
[    3.567763]  [<c02e0be0>] ? generic_ide_shutdown+0x0/0x30
[    3.569625]  [<c02bee30>] driver_register+0x70/0xd0
[    3.572256]  [<c0137fcd>] ? printk+0x1d/0x30
[    3.573718]  [<c0574c80>] ? ide_cdrom_init+0x0/0x20
[    3.576207]  [<c0574c9c>] ide_cdrom_init+0x1c/0x20
[    3.577771]  [<c0101042>] do_one_initcall+0x32/0x1d0
[    3.580310]  [<c011f61f>] ? __change_page_attr_set_clr+0x2f/0x70
[    3.583259]  [<c015cb5c>] ? validate_chain+0x3fc/0x540
[    3.584968]  [<c015cb5c>] ? validate_chain+0x3fc/0x540
[    3.587568]  [<c015ea2c>] ? __lock_acquire+0x29c/0x8b0
[    3.589353]  [<c01a8eb8>] ? check_bytes+0x8/0x20
[    3.591841]  [<c01a8f49>] ? check_bytes_and_report+0x29/0xc0
[    3.593802]  [<c0198424>] ? page_address+0x14/0xe0
[    3.596285]  [<c01a9046>] ? check_pad_bytes+0x66/0x80
[    3.597887]  [<c0198424>] ? page_address+0x14/0xe0
[    3.600524]  [<c01a9614>] ? trace+0x14/0x90
[    3.601873]  [<c01a920a>] ? check_object+0xaa/0x1c0
[    3.604398]  [<c015cb5c>] ? validate_chain+0x3fc/0x540
[    3.607023]  [<c015ea2c>] ? __lock_acquire+0x29c/0x8b0
[    3.608794]  [<c015a4f4>] ? lock_release_holdtime+0x74/0xc0
[    3.611679]  [<c01f340c>] ? proc_register+0x9c/0x140
[    3.613707]  [<c015fc17>] ? __lock_release+0x47/0x70
[    3.616361]  [<c03e4c02>] ? _spin_unlock+0x22/0x30
[    3.617890]  [<c01f340c>] ? proc_register+0x9c/0x140
[    3.620617]  [<c01f3799>] ? create_proc_entry+0x69/0xa0
[    3.623493]  [<c01730f4>] ? register_irq_proc+0x14/0xd0
[    3.625260]  [<c0553a6a>] do_initcalls+0x2a/0x40
[    3.627647]  [<c0553ad0>] ? kernel_init+0x0/0xa0
[    3.629374]  [<c0553a9c>] do_basic_setup+0x1c/0x20
[    3.631837]  [<c0553b25>] kernel_init+0x55/0xa0
[    3.633475]  [<c0103d33>] kernel_thread_helper+0x7/0x10
[    3.636655] ------------[ cut here ]------------
[    3.639236] kernel BUG at arch/x86/mm/ioremap.c:80!
[    3.640100] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[    3.640100] last sysfs file: 
[    3.640100] Modules linked in:
[    3.640100] 
[    3.640100] Pid: 1, comm: swapper Not tainted (2.6.29-rc6-next-20090227-dirty #10) VMware Virtual Platform
[    3.640100] EIP: 0060:[<c011e4d2>] EFLAGS: 00010213 CPU: 0
[    3.640100] EIP is at __phys_addr+0x52/0x70
[    3.640100] EAX: 00000000 EBX: 00000000 ECX: 00000018 EDX: 00000000
[    3.640100] ESI: f69f4060 EDI: 00000000 EBP: f700f92c ESP: f700f92c
[    3.640100]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    3.640100] Process swapper (pid: 1, ti=f700f000 task=f7030000 task.ti=f700f000)
[    3.640100] Stack:
[    3.640100]  f700f940 c0277c23 f69f4060 f700f95c f700f99c f700f950 c02e1b62 f629b840
[    3.640100]  f700f95c f700f9a8 c02ef9a9 f6b86180 00000000 00000000 00000000 00000000
[    3.640100]  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    3.640100] Call Trace:
[    3.640100]  [<c0277c23>] ? sg_init_one+0x23/0x90
[    3.640100]  [<c02e1b62>] ? ide_map_sg+0x42/0x70
[    3.640100]  [<c02ef9a9>] ? ide_cd_do_request+0x119/0x170
[    3.640100]  [<c02e1d28>] ? start_request+0xa8/0x160
[    3.640100]  [<c015d92b>] ? trace_hardirqs_on+0xb/0x10
[    3.640100]  [<c02e1f7b>] ? do_ide_request+0x16b/0x250
[    3.640100]  [<c025e5a5>] ? blk_remove_plug+0x75/0xf0
[    3.640100]  [<c025f770>] ? blk_start_queueing+0x20/0x30
[    3.640100]  [<c025d2be>] ? elv_insert+0x17e/0x1b0
[    3.640100]  [<c025e458>] ? blk_plug_device+0x88/0x120
[    3.640100]  [<c025d372>] ? __elv_add_request+0x82/0xc0
[    3.640100]  [<c0263ad0>] ? blk_execute_rq_nowait+0x60/0xb0
[    3.640100]  [<c0263bb6>] ? blk_execute_rq+0x96/0xd0
[    3.640100]  [<c0263a40>] ? blk_end_sync_rq+0x0/0x30
[    3.640100]  [<c025f59c>] ? get_request_wait+0x2c/0x160
[    3.640100]  [<c0160429>] ? __lock_acquired+0x109/0x1c0
[    3.640100]  [<c025f6f4>] ? blk_get_request+0x24/0x80
[    3.640100]  [<c02ef196>] ? ide_cd_queue_pc+0xb6/0x140
[    3.640100]  [<c01a9614>] ? trace+0x14/0x90
[    3.640100]  [<c01a920a>] ? check_object+0xaa/0x1c0
[    3.640100]  [<c01a8e34>] ? init_object+0x14/0x90
[    3.640100]  [<c01a9854>] ? alloc_debug_processing+0xf4/0x120
[    3.640100]  [<c02efac7>] ? cdrom_check_status+0x87/0x90
[    3.640100]  [<c015d92b>] ? trace_hardirqs_on+0xb/0x10
[    3.640100]  [<c02efc76>] ? ide_cd_read_toc+0x46/0x430
[    3.640100]  [<c02ebe61>] ? ide_add_proc_entries+0x31/0x60
[    3.640100]  [<c02f08a4>] ? ide_cdrom_setup+0x104/0x140
[    3.640100]  [<c02f0d7b>] ? ide_cd_probe+0x11b/0x170
[    3.640100]  [<c01fb9f0>] ? sysfs_do_create_link+0xc0/0x150
[    3.640100]  [<c015a4f4>] ? lock_release_holdtime+0x74/0xc0
[    3.640100]  [<c01fba97>] ? sysfs_create_link+0x17/0x20
[    3.640100]  [<c02e0ba4>] ? generic_ide_probe+0x24/0x30
[    3.640100]  [<c02be6ac>] ? really_probe+0x8c/0x110
[    3.640100]  [<c02be81c>] ? driver_probe_device+0x1c/0x30
[    3.640100]  [<c01516af>] ? down+0x2f/0x50
[    3.640100]  [<c02be964>] ? __driver_attach+0x74/0x80
[    3.640100]  [<c02bd625>] ? bus_for_each_dev+0x55/0x70
[    3.640100]  [<c02be98e>] ? driver_attach+0x1e/0x30
[    3.640100]  [<c02be8f0>] ? __driver_attach+0x0/0x80
[    3.640100]  [<c02bdda6>] ? bus_add_driver+0xb6/0x1a0
[    3.640100]  [<c02e0be0>] ? generic_ide_shutdown+0x0/0x30
[    3.640100]  [<c02e0be0>] ? generic_ide_shutdown+0x0/0x30
[    3.640100]  [<c02bee30>] ? driver_register+0x70/0xd0
[    3.640100]  [<c0137fcd>] ? printk+0x1d/0x30
[    3.640100]  [<c0574c80>] ? ide_cdrom_init+0x0/0x20
[    3.640100]  [<c0574c9c>] ? ide_cdrom_init+0x1c/0x20
[    3.640100]  [<c0101042>] ? do_one_initcall+0x32/0x1d0
[    3.640100]  [<c011f61f>] ? __change_page_attr_set_clr+0x2f/0x70
[    3.640100]  [<c015cb5c>] ? validate_chain+0x3fc/0x540
[    3.640100]  [<c015cb5c>] ? validate_chain+0x3fc/0x540
[    3.640100]  [<c015ea2c>] ? __lock_acquire+0x29c/0x8b0
[    3.640100]  [<c01a8eb8>] ? check_bytes+0x8/0x20
[    3.640100]  [<c01a8f49>] ? check_bytes_and_report+0x29/0xc0
[    3.640100]  [<c0198424>] ? page_address+0x14/0xe0
[    3.640100]  [<c01a9046>] ? check_pad_bytes+0x66/0x80
[    3.640100]  [<c0198424>] ? page_address+0x14/0xe0
[    3.640100]  [<c01a9614>] ? trace+0x14/0x90
[    3.640100]  [<c01a920a>] ? check_object+0xaa/0x1c0
[    3.640100]  [<c015cb5c>] ? validate_chain+0x3fc/0x540
[    3.640100]  [<c015ea2c>] ? __lock_acquire+0x29c/0x8b0
[    3.640100]  [<c015a4f4>] ? lock_release_holdtime+0x74/0xc0
[    3.640100]  [<c01f340c>] ? proc_register+0x9c/0x140
[    3.640100]  [<c015fc17>] ? __lock_release+0x47/0x70
[    3.640100]  [<c03e4c02>] ? _spin_unlock+0x22/0x30
[    3.640100]  [<c01f340c>] ? proc_register+0x9c/0x140
[    3.640100]  [<c01f3799>] ? create_proc_entry+0x69/0xa0
[    3.640100]  [<c01730f4>] ? register_irq_proc+0x14/0xd0
[    3.640100]  [<c0553a6a>] ? do_initcalls+0x2a/0x40
[    3.640100]  [<c0553ad0>] ? kernel_init+0x0/0xa0
[    3.640100]  [<c0553a9c>] ? do_basic_setup+0x1c/0x20
[    3.640100]  [<c0553b25>] ? kernel_init+0x55/0xa0
[    3.640100]  [<c0103d33>] ? kernel_thread_helper+0x7/0x10
[    3.640100] Code: 05 00 00 80 00 39 c2 72 ea a1 c4 34 51 c0 2d 00 30 60 00 25 00 00 c0 ff 2d 00 20 00 00 39 c2 73 d2 0f 0b 8d b6 00 00 00 00 eb fe <0f> 0b 8d b6 00 00 00 00 8d bf 00 00 00 00 eb fe 8d b4 26 00 00 
[    3.640100] EIP: [<c011e4d2>] __phys_addr+0x52/0x70 SS:ESP 0068:f700f92c
[    3.901567] ---[ end trace 62bacdc937c3e403 ]---

Full log is at http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.29-rc6-next-20090227-dirty.txt

Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.29-rc6-next-20090227-dirty

Regards.
