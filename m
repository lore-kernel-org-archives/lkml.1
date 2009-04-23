Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbZDWEzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbZDWEzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 00:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbZDWEzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 00:55:32 -0400
Received: from cobra.newdream.net ([66.33.216.30]:53009 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZDWEzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 00:55:31 -0400
X-Greylist: delayed 1905 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Apr 2009 00:55:31 EDT
Date: Wed, 22 Apr 2009 21:23:44 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
cc: jeff@garzik.org, neilb@suse.de, yehuda@newdream.net
Subject: [PATCH] umem: fix request_queue lock warning
Message-ID: <Pine.LNX.4.64.0904222037350.29656@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The umem driver issues two warnings on boot, due to blk_plug_device() and 
blk_remove_plug() being called without q->queue_lock held.  Starting with 
e48ec690 (block: extend queue_flag bitops), the queue_flag_* functions 
warn if q->queue_lock doesn't appear to be locked.  In fact, q->queue_lock 
is NULL (though that apparently isn't otherwise a problem as the driver is 
using card->lock for everything).

Although blk_init_queue() with take a request_fn_proc and spinlock_t*, 
there isn't a corresponding init helper that takes a make_request_fn. 
Setting queue_lock to &card->lock explicitly seems to work fine for me.  
The warning goes away and the device appears to behave.

If there is a better solution, I'd be happy to test it out.  It looks like 
this problem showed up in 2.6.27.  There clearly aren't too many people 
using these NVRAM cards, but it'd be nice to see this fixed.

Thanks-
sage


[    1.531881] v2.3 : Micro Memory(tm) PCI memory board block driver
[    1.538136] umem 0000:02:01.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.545018] umem 0000:02:01.0: Micro Memory(tm) controller found (PCI Mem Module (Battery Backup))
[    1.554176] umem 0000:02:01.0: CSR 0xfc9ffc00 -> 0xffffc200013d0c00 (0x100)
[    1.561279] umem 0000:02:01.0: Size 1048576 KB, Battery 1 Disabled (FAILURE), Battery 2 Disabled (FAILURE)
[    1.571114] umem 0000:02:01.0: Window size 16777216 bytes, IRQ 20
[    1.577304] umem 0000:02:01.0: memory NOT initialized. Consider over-writing whole device.
[    1.585989]  umema:<4>------------[ cut here ]------------
[    1.591775] WARNING: at include/linux/blkdev.h:492 blk_plug_device+0x6d/0x106()
[    1.592025] Hardware name: H8SSL
[    1.592025] Modules linked in:
[    1.592025] Pid: 1, comm: swapper Not tainted 2.6.29 #8
[    1.592025] Call Trace:
[    1.592025]  [<ffffffff8023c994>] warn_slowpath+0xd3/0xf2
[    1.592025]  [<ffffffff8025a5b5>] ? save_trace+0x3f/0x9b
[    1.592025]  [<ffffffff8025a68b>] ? add_lock_to_list+0x7a/0xba
[    1.592025]  [<ffffffff8025e609>] ? validate_chain+0xb3b/0xce8
[    1.592025]  [<ffffffff80441556>] ? mm_make_request+0x27/0x59
[    1.592025]  [<ffffffff80441556>] ? mm_make_request+0x27/0x59
[    1.592025]  [<ffffffff8025ef04>] ? __lock_acquire+0x74e/0x7b9
[    1.592025]  [<ffffffff8025a70e>] ? get_lock_stats+0x34/0x5e
[    1.592025]  [<ffffffff8025a746>] ? put_lock_stats+0xe/0x27
[    1.592025]  [<ffffffff80441556>] ? mm_make_request+0x27/0x59
[    1.592025]  [<ffffffff803ad165>] blk_plug_device+0x6d/0x106
[    1.592025]  [<ffffffff80441575>] mm_make_request+0x46/0x59
[    1.592025]  [<ffffffff803ac2d9>] generic_make_request+0x335/0x3cf
[    1.592025]  [<ffffffff8027fcc7>] ? mempool_alloc_slab+0x11/0x13
[    1.592025]  [<ffffffff8027fdce>] ? mempool_alloc+0x45/0x101
[    1.592025]  [<ffffffff8025a746>] ? put_lock_stats+0xe/0x27
[    1.592025]  [<ffffffff803adda5>] submit_bio+0x10a/0x119
[    1.592025]  [<ffffffff802c8d00>] submit_bh+0xe5/0x109
[    1.592025]  [<ffffffff802cbf43>] block_read_full_page+0x2aa/0x2cb
[    1.592025]  [<ffffffff802cf4c4>] ? blkdev_get_block+0x0/0x4c
[    1.592025]  [<ffffffff805c90a8>] ? _spin_unlock_irq+0x36/0x51
[    1.592025]  [<ffffffff80286836>] ? __lru_cache_add+0x92/0xb2
[    1.592025]  [<ffffffff802cf008>] blkdev_readpage+0x13/0x15
[    1.592025]  [<ffffffff8027de06>] read_cache_page_async+0x90/0x134
[    1.592025]  [<ffffffff802ceff5>] ? blkdev_readpage+0x0/0x15
[    1.592025]  [<ffffffff802f5f1c>] ? adfspart_check_ICS+0x0/0x16c
[    1.592025]  [<ffffffff8027deb8>] read_cache_page+0xe/0x45
[    1.592025]  [<ffffffff802f5170>] read_dev_sector+0x2e/0x93
[    1.592025]  [<ffffffff802f5f44>] adfspart_check_ICS+0x28/0x16c
[    1.592025]  [<ffffffff8025d427>] ? trace_hardirqs_on+0xd/0xf
[    1.592025]  [<ffffffff802f5f1c>] ? adfspart_check_ICS+0x0/0x16c
[    1.592025]  [<ffffffff802f59c5>] rescan_partitions+0x168/0x2fb
[    1.592025]  [<ffffffff802ceae9>] __blkdev_get+0x259/0x336
[    1.592025]  [<ffffffff803ca1e2>] ? kobject_put+0x47/0x4b
[    1.592025]  [<ffffffff802cebd1>] blkdev_get+0xb/0xd
[    1.592025]  [<ffffffff802f5773>] register_disk+0xc4/0x12b
[    1.592025]  [<ffffffff803b2a7b>] add_disk+0xc3/0x12d
[    1.592025]  [<ffffffff808a1d4a>] ? mm_init+0x0/0x1a5
[    1.592025]  [<ffffffff808a1e73>] mm_init+0x129/0x1a5
[    1.592025]  [<ffffffff808a1d4a>] ? mm_init+0x0/0x1a5
[    1.592025]  [<ffffffff80209056>] _stext+0x56/0x130
[    1.592025]  [<ffffffff80274932>] ? register_irq_proc+0xae/0xca
[    1.592025]  [<ffffffff802f0000>] ? proc_pid_lookup+0xb4/0x18b
[    1.592025]  [<ffffffff8087f975>] kernel_init+0x132/0x18b
[    1.592025]  [<ffffffff8020d17a>] child_rip+0xa/0x20
[    1.592025]  [<ffffffff8020cb40>] ? restore_args+0x0/0x30
[    1.592025]  [<ffffffff8087f843>] ? kernel_init+0x0/0x18b
[    1.592025]  [<ffffffff8020d170>] ? child_rip+0x0/0x20
[    1.592025] ---[ end trace 7150b3b86da74e1e ]---
[    1.889858] ------------[ cut here ]------------[ve_plug+0x5f/0x91()
[    1.893848] Hardware name: H8SSL
[    1.893848] Modules linked in:
[    1.893848] Pid: 1, comm: swapper Tainted: G        W  2.6.29 #8
[    1.893848] Call Trace:
[    1.893848]  [<ffffffff8023c994>] warn_slowpath+0xd3/0xf2
[    1.893848]  [<ffffffff805c8411>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    1.893848]  [<ffffffff8020cb40>] ? restore_args+0x0/0x30
[    1.893848]  [<ffffffff80254245>] ? __atomic_notifier_call_chain+0x0/0xb2
[    1.893848]  [<ffffffff805c90a3>] ? _spin_unlock_irq+0x31/0x51
[    1.893848]  [<ffffffff805c90bf>] ? _spin_unlock_irq+0x4d/0x51
[    1.893848]  [<ffffffff8044157d>] ? mm_make_request+0x4e/0x59
[    1.893848]  [<ffffffff8025a70e>] ? get_lock_stats+0x34/0x5e
[    1.893848]  [<ffffffff8025a75d>] ? put_lock_stats+0x25/0x27
[    1.893848]  [<ffffffff80441504>] ? mm_unplug_device+0x25/0x50
[    1.893848]  [<ffffffff803acf23>] blk_remove_plug+0x5f/0x91
[    1.893848]  [<ffffffff8044150f>] mm_unplug_device+0x30/0x50
[    1.893848]  [<ffffffff803ab74a>] blk_unplug+0x78/0x7d
[    1.893848]  [<ffffffff803ab75c>] blk_backing_dev_unplug+0xd/0xf
[    1.893848]  [<ffffffff802c853c>] block_sync_page+0x4a/0x4c
[    1.893848]  [<ffffffff8027da1c>] sync_page+0x44/0x4d
[    1.893848]  [<ffffffff805c66fd>] __wait_on_bit_lock+0x42/0x8a
[    1.893848]  [<ffffffff8027d9d8>] ? sync_page+0x0/0x4d
[    1.893848]  [<ffffffff8027d9c4>] __lock_page+0x64/0x6b
[    1.893848]  [<ffffffff802508db>] ? wake_bit_function+0x0/0x2a
[    1.893848]  [<ffffffff8027de4a>] read_cache_page_async+0xd4/0x134
[    1.893848]  [<ffffffff802ceff5>] ? blkdev_readpage+0x0/0x15
[    1.893848]  [<ffffffff802f5f1c>] ? adfspart_check_ICS+0x0/0x16c
[    1.893848]  [<ffffffff8027deb8>] read_cache_page+0xe/0x45
[    1.893848]  [<ffffffff802f5170>] read_dev_sector+0x2e/0x93
[    1.893848]  [<ffffffff802f5f44>] adfspart_check_ICS+0x28/0x16c
[    1.893848]  [<ffffffff8025d427>] ? trace_hardirqs_on+0xd/0xf
[    1.893848]  [<ffffffff802f5f1c>] ? adfspart_check_ICS+0x0/0x16c
[    1.893848]  [<ffffffff802f59c5>] rescan_partitions+0x168/0x2fb
[    1.893848]  [<ffffffff802ceae9>] __blkdev_get+0x259/0x336
[    1.893848]  [<ffffffff803ca1e2>] ? kobject_put+0x47/0x4b
[    1.893848]  [<ffffffff802cebd1>] blkdev_get+0xb/0xd
[    1.893848]  [<ffffffff802f5773>] register_disk+0xc4/0x12b
[    1.893848]  [<ffffffff803b2a7b>] add_disk+0xc3/0x12d
[    1.893848]  [<ffffffff808a1d4a>] ? mm_init+0x0/0x1a5
[    1.893848]  [<ffffffff808a1e73>] mm_init+0x129/0x1a5
[    1.893848]  [<ffffffff808a1d4a>] ? mm_init+0x0/0x1a5
[    1.893848]  [<ffffffff80209056>] _stext+0x56/0x130
[    1.893848]  [<ffffffff80274932>] ? register_irq_proc+0xae/0xca
[    1.893848]  [<ffffffff802f0000>] ? proc_pid_lookup+0xb4/0x18b
[    1.893848]  [<ffffffff8087f975>] kernel_init+0x132/0x18b
[    1.893848]  [<ffffffff8020d17a>] child_rip+0xa/0x20
[    1.893848]  [<ffffffff8020cb40>] ? restore_args+0x0/0x30
[    1.893848]  [<ffffffff8087f843>] ? kernel_init+0x0/0x18b
[    1.893848]  [<ffffffff8020d170>] ? child_rip+0x0/0x20
[    1.893848] ---[ end trace 7150b3b86da74e1f ]---


Signed-off-by: Sage Weil <sage@newdream.net>
---
 drivers/block/umem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index c24e1bd..de669fb 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -906,6 +906,7 @@ static int __devinit mm_pci_probe(struct pci_dev *dev,
 		goto failed_alloc;
 
 	blk_queue_make_request(card->queue, mm_make_request);
+	card->queue->queue_lock = &card->lock;
 	card->queue->queuedata = card;
 	card->queue->unplug_fn = mm_unplug_device;
 
-- 
1.5.6.5

