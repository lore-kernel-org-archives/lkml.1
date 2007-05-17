Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbXEQPOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbXEQPOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 11:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXEQPOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 11:14:33 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59723 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbXEQPOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 11:14:32 -0400
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
From: Badari Pulavarty <pbadari@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, bhalevy@panasas.com,
       Andrew Morton <akpm@linux-foundation.org>,
       fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu
In-Reply-To: <20070517062742.GW23798@kernel.dk>
References: <20070511135108.GF4629@kernel.dk>
	 <1179249337.2836.110.camel@dyn9047017100.beaverton.ibm.com>
	 <20070515172001.GB23798@kernel.dk>
	 <1179251020.2836.118.camel@dyn9047017100.beaverton.ibm.com>
	 <20070515175025.GE23798@kernel.dk>
	 <1179349294.16195.6.camel@dyn9047017100.beaverton.ibm.com>
	 <20070517062742.GW23798@kernel.dk>
Content-Type: text/plain
Date: Thu, 17 May 2007 08:15:10 -0700
Message-Id: <1179414911.23725.7.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 08:27 +0200, Jens Axboe wrote:
> On Wed, May 16 2007, Badari Pulavarty wrote:
> > On Tue, 2007-05-15 at 19:50 +0200, Jens Axboe wrote:
> > > On Tue, May 15 2007, Badari Pulavarty wrote:
> > > > On Tue, 2007-05-15 at 19:20 +0200, Jens Axboe wrote:
> > > > > On Tue, May 15 2007, Badari Pulavarty wrote:
> > > > > > On Fri, 2007-05-11 at 15:51 +0200, Jens Axboe wrote:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > Updated version of the patch - this time I'll just attach the patch
> > > > > > > file...
> > > > > > 
> > > > > > Missing scatterlist.h inclusions..
> > > > > > 
> > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c: In function ???sym_scatter???:
> > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: warning: implicit declaration
> > > > > > of function ???for_each_sg???
> > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c:385: error: expected ???;??? before ???{???
> > > > > > token
> > > > > > drivers/scsi/sym53c8xx_2/sym_glue.c:375: warning: unused variable ???tp???
> > > > > > make[3]: *** [drivers/scsi/sym53c8xx_2/sym_glue.o] Error 1
> > > > > > 
> > > > > > 
> > > > > > drivers/scsi/qla2xxx/qla_iocb.c: In function ???qla24xx_build_scsi_iocbs???:
> > > > > > drivers/scsi/qla2xxx/qla_iocb.c:678: warning: implicit declaration of
> > > > > > function ???for_each_sg???
> > > > > > drivers/scsi/qla2xxx/qla_iocb.c:678: error: expected ???;??? before ???{???
> > > > > > token
> > > > > 
> > > > > Thanks, will fix those. What arch? I tested it here.
> > > > 
> > > > I am playing with them on ppc64.
> > > 
> > > Ah ok, you need the updated patch series for ppc64 support. Builds fine
> > > here on ppc64. See the #sglist branch of the block repo:
> > > 
> > > git://git.kernel.dk/data/git/linux-2.6-block.git
> > > 
> > > I can mail you an updated patch, if you want.
> > 
> > 
> > Here is the whole panic stack..
> 
> Thanks will fix that up, the IDE part is totally untested. Can you try
> and backout this patch and see if it boots?

I increased max_segments to 1024 on my qla2200 attached disks and
simple "dd" (direct read) resulted in following:

elm3b29:/sys/block/sdd/queue # echo 1024 > max_segments
elm3b29:/sys/block/sdd/queue # cat max_hw_sectors_kb > max_sectors_kb
elm3b29:/mnt # dd iflag=direct if=./z of=/dev/null bs=512M

Unable to handle kernel paging request at 0000000000001008 RIP:
 [<ffffffff8025e7af>] __rmqueue+0x6f/0x120
PGD 100921067 PUD 1057f9067 PMD 0
Oops: 0002 [1] SMP
CPU 0
Modules linked in: jfs hfs vfat fat sg sd_mod qla2xxx firmware_class
scsi_transport_fc scsi_mod ipv6 thermal processor fan button battery ac
dm_mod floppy parport_pc lp parport
Pid: 4329, comm: dd Tainted: G   M   2.6.22-rc1 #4
RIP: 0010:[<ffffffff8025e7af>]  [<ffffffff8025e7af>] __rmqueue
+0x6f/0x120
RSP: 0018:ffff8101bdcab948  EFLAGS: 00010093
RAX: ffff81017e644148 RBX: 0000000000000002 RCX: 0000000000001000
RDX: ffff810000011c80 RSI: 0000000000000000 RDI: ffff810000011a00
RBP: ffff8101bdcab968 R08: ffff81017a801142 R09: 0000000000000000
R10: 0000000000078e7a R11: 0000000000000002 R12: ffff810000011c80
R13: 0000000000000000 R14: ffff81017e644120 R15: ffff810000011a00
FS:  00002b53c78cef20(0000) GS:ffffffff8063b000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000001008 CR3: 0000000102707000 CR4: 00000000000006e0
Process dd (pid: 4329, threadinfo ffff8101bdcaa000, task
ffff8101bf4ff440)
Stack:  ffff81017a801110 0000000000000012 0000000000000012
ffff81017a801100
 ffff8101bdcaba08 ffffffff8025f47d 0000000000000001 ffff810000012e68
 000000445f7ebe38 ffff810000012e60 000280d200000000 ffff810000012e68
Call Trace:
 [<ffffffff8025f47d>] get_page_from_freelist+0x31d/0x510
 [<ffffffff8025f7ae>] __alloc_pages+0x6e/0x330
 [<ffffffff80278b4a>] alloc_page_vma+0x4a/0xa0
 [<ffffffff802698e7>] __handle_mm_fault+0x9b7/0xba0
 [<ffffffff80268086>] follow_page+0x1b6/0x250
 [<ffffffff80269bdc>] get_user_pages+0x10c/0x3d0
 [<ffffffff802aee8e>] bio_add_page+0x2e/0x30
 [<ffffffff802b144b>] dio_get_page+0xbb/0x1b0
 [<ffffffff802b2148>] __blockdev_direct_IO+0x478/0xc20
 [<ffffffff881812e0>] :jfs:jfs_direct_IO+0x50/0x60
 [<ffffffff881818d0>] :jfs:jfs_get_block+0x0/0x230
 [<ffffffff8025b793>] generic_file_direct_IO+0x73/0x150
 [<ffffffff8025ce81>] generic_file_aio_read+0x131/0x170
 [<ffffffff802717b0>] page_add_new_anon_rmap+0x10/0x20
 [<ffffffff80269997>] __handle_mm_fault+0xa67/0xba0
 [<ffffffff802867d1>] do_sync_read+0xf1/0x130
 [<ffffffff80247fe9>] up_read+0x9/0x10
 [<ffffffff80244fc0>] autoremove_wake_function+0x0/0x40
 [<ffffffff80392a80>] __up_write+0xd0/0x130
 [<ffffffff80287101>] vfs_read+0xe1/0x190
 [<ffffffff802875b0>] sys_read+0x50/0x90
 [<ffffffff80209b0e>] system_call+0x7e/0x83


Code: 48 89 51 08 48 89 0a 48 c7 40 08 00 02 20 00 48 c7 00 00 01
RIP  [<ffffffff8025e7af>] __rmqueue+0x6f/0x120
 RSP <ffff8101bdcab948>
CR2: 0000000000001008
Unable to handle kernel paging request<0>Eeek! page_mapcount(page) went
negative! (-1)
  page pfn = 10a738
  page->flags = 14
  page->count = 80287910
  page->mapping = 0000000000000000
  vma->vm_ops = _stext+0x7fdf9000/0x60
 at 0000200000000018 RIP:
 [<ffffffff80227485>] task_rq_lock+0x35/0x90
PGD 0
Oops: 0000 [2] SMP
CPU 2
Modules linked in: jfs hfs vfat fat sg sd_mod qla2xxx firmware_class
scsi_transport_fc scsi_mod ipv6 thermal processor fan button battery ac
dm_mod floppy parport_pc lp parport
Pid: 0, comm: swapper Tainted: G   M   2.6.22-rc1 #4
RIP: 0010:[<ffffffff80227485>]  [<ffffffff80227485>] task_rq_lock
+0x35/0x90
RSP: 0018:ffff810180247dc0  EFLAGS: 00010086
RAX: 0000200000000000 RBX: ffffffff80701780 RCX: ffff8101d9639cc8
RDX: 0000000000000000 RSI: ffff810180247e28 RDI: ffff8101dc810000
RBP: ffff810180247de0 R08: 0000000000000000 R09: ffffffff80701780
R10: ffff81021f90c000 R11: 0000000000000246 R12: ffffffff80701780
R13: ffff8101dc810000 R14: ffff810180247e28 R15: 0000000000000001
FS:  00002ae1c3672400(0000) GS:ffff8101a0220300(0000)
knlGS:00000000f7dfb6b0
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000200000000018 CR3: 000000019e8f4000 CR4: 00000000000006e0
Process swapper (pid: 0, threadinfo ffff81017ab6c000, task
ffff8101c025a000)
Stack:  000000000000000f ffff8101dc810000 ffff8101a0011328
ffff8101a00112e0
 ffff810180247e60 ffffffff80229b3f 0000000100000002 0000000000000000
 0000000000000000 ffffffffffffffff 0000000000000000 0000000000000000
Call Trace:
 <IRQ>  [<ffffffff80229b3f>] try_to_wake_up+0x2f/0x4b0
 [<ffffffff802477a0>] hrtimer_wakeup+0x0/0x30
 [<ffffffff80229ff0>] wake_up_process+0x10/0x20
 [<ffffffff802477bd>] hrtimer_wakeup+0x1d/0x30
 [<ffffffff802479b4>] hrtimer_run_queues+0x114/0x180
 [<ffffffff80238ee8>] run_timer_softirq+0x28/0x1d0
 [<ffffffff80235734>] __do_softirq+0x74/0xf0
 [<ffffffff8020ac9c>] call_softirq+0x1c/0x30
 [<ffffffff8020ca1d>] do_softirq+0x3d/0x90
 [<ffffffff802355e5>] irq_exit+0x45/0x50
 [<ffffffff80216e15>] smp_apic_timer_interrupt+0x55/0x70
 [<ffffffff80208c60>] default_idle+0x0/0x50
 [<ffffffff8020a746>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff80208c8d>] default_idle+0x2d/0x50
 [<ffffffff80208532>] enter_idle+0x22/0x30
 [<ffffffff80208d0c>] cpu_idle+0x5c/0x80
 [<ffffffff806bbdd6>] start_secondary+0x256/0x360
 [<ffffffff80244bbd>] kthread+0x4d/0x80


Code: 8b 40 18 48 8b 04 c5 c0 fa 68 80 48 03 58 08 48 89 df e8 94
RIP  [<ffffffff80227485>] task_rq_lock+0x35/0x90
 RSP <ffff810180247dc0>
CR2: 0000200000000018
Kernel panic - not syncing: Aiee, killing interrupt handler!



