Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYLJN6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYLJN6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYLJN6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:58:03 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:40235 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbYLJN6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:58:00 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: mmotm 2008-12-09-15-24: memory corruption (bio slab)
Date: Wed, 10 Dec 2008 14:57:21 +0100
Message-Id: <1228917441-830-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on every bootup of this kernel, I get this (not sure if it is right after the moment when / gets mounted from md1):

wlan0 renamed to wlan1
udev: renamed network interface wlan0 to wlan1
swap_cgroup: uses 7848 bytes of vmalloc for pointer array space and 4018176 bytes to hold mem_cgroup pointers on swap
swap_cgroup can be disabled by noswapaccount boot option.
Adding 2008084k swap on /dev/sdb6.  Priority:-1 extents:1 across:2008084k 
EXT3 FS on md1, internal journal
bio: create slab <bio-1> at 1
=============================================================================
BUG bio-1: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88007bacf068-0xffff88007bacf06f. First byte 0x68 instead of 0xcc
INFO: Allocated in 0x6b6b6b6b6b6b6b6b age=10706345584330245030 cpu=1802201963 pid=1802201963
INFO: Freed in 0x6b6b6b6b6b6b6b6b age=6527005130130424742 cpu=1802201963 pid=1802201963
INFO: Slab 0xffffe20001b0dd48 objects=21 used=4 fp=0xffff88007bacf300 flags=0x40000000000000c3
INFO: Object 0xffff88007bacf000 @offset=0 fp=0x0000000000001000

  Object 0xffff88007bacf000:  fd 6f 57 04 00 00 00 00 00 00 00 00 00 00 00 00 375oW.............
  Object 0xffff88007bacf010:  80 86 c2 7c 00 88 ff ff 19 00 00 00 00 00 00 00 ..302|..377377........
  Object 0xffff88007bacf020:  00 00 00 00 00 00 00 00 01 00 00 00 01 00 00 00 ................
  Object 0xffff88007bacf030:  00 00 00 00 00 10 00 00 00 10 00 00 04 00 00 00 ................
  Object 0xffff88007bacf040:  ff ff ff ff 00 00 00 00 68 f0 ac 7b 00 88 ff ff 377377377377....h360254{..377377
  Object 0xffff88007bacf050:  b0 ad 49 80 ff ff ff ff 58 99 b7 7a 00 88 ff ff 260255I.377377377377X.267z..377377
  Object 0xffff88007bacf060:  10 98 49 80 ff ff ff ff                         ..I.377377377377        
 Redzone 0xffff88007bacf068:  68 1b b1 01 00 e2 ff ff                         h.261..342377377        
 Padding 0xffff88007bacf0a8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff88007bacf0b8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Pid: 815, comm: udevd Tainted: G        W  2.6.28-rc7-mm1_64 #490
Call Trace:
 <IRQ>  [<ffffffff802b6ed6>] print_trailer+0x106/0x160
 [<ffffffff802b7145>] check_bytes_and_report+0x125/0x180
 [<ffffffff802b83d6>] check_object+0x66/0x280
 [<ffffffff802b9e65>] __slab_free+0x225/0x370
 [<ffffffff8028f5d2>] ? mempool_free_slab+0x12/0x20
 [<ffffffff802bb7f2>] kmem_cache_free+0x72/0xa0
 [<ffffffff8028f5d2>] mempool_free_slab+0x12/0x20
 [<ffffffff8028f66a>] mempool_free+0x8a/0xa0
 [<ffffffff802ea03d>] bio_free+0x4d/0x60
 [<ffffffff8049981d>] dm_bio_destructor+0xd/0x10
 [<ffffffff802e848b>] bio_put+0x2b/0x40
 [<ffffffff8049ae39>] clone_endio+0x89/0xd0
 [<ffffffff802e851c>] bio_endio+0x1c/0x40
 [<ffffffff8034f42b>] req_bio_endio+0x8b/0xe0
 [<ffffffff8034f527>] __end_that_request_first+0xa7/0x2b0
 [<ffffffff8034f75c>] end_that_request_data+0x2c/0x70
 [<ffffffff8034f80d>] blk_end_io+0x2d/0xb0
 [<ffffffff8034f8be>] blk_end_request+0xe/0x10
 [<ffffffff80418edb>] scsi_io_completion+0x13b/0x490
 [<ffffffff8041250c>] scsi_finish_command+0xac/0xe0
 [<ffffffff80418d1a>] scsi_softirq_done+0xba/0x140
 [<ffffffff8043df0c>] ? ahci_interrupt+0x9c/0x5c0
 [<ffffffff80353a85>] blk_done_softirq+0x75/0x90
 [<ffffffff8025ab83>] ? sched_clock_cpu+0x143/0x190
 [<ffffffff80244052>] __do_softirq+0xc2/0x190
 [<ffffffff8020d6bc>] call_softirq+0x1c/0x30
 [<ffffffff8020ea15>] do_softirq+0x45/0x90
 [<ffffffff80243d9d>] irq_exit+0x8d/0xa0
 [<ffffffff8020ecc5>] do_IRQ+0xc5/0x110
 [<ffffffff8020cf93>] ret_from_intr+0x0/0xa
 <EOI> <3>FIX bio-1: Restoring 0xffff88007bacf068-0xffff88007bacf06f=0xcc

=============================================================================
BUG bio-1: Redzone overwritten
-----------------------------------------------------------------------------

ffffffff8049981d is in dm_bio_destructor from drivers/md/dm.c.

Inlined vecs doesn't fit to the allocated slab portion in my eyes, doesn't
the patch below make sense?

--

Enlarge bio slabs to include inlined vecs

---
 fs/bio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 40b6488..cd1a439 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -68,7 +68,8 @@ static unsigned int bio_slab_nr, bio_slab_max;
 
 static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_size)
 {
-	unsigned int sz = sizeof(struct bio) + extra_size;
+	unsigned int sz = sizeof(struct bio) +
+		sizeof(struct bio_vec) * BIO_INLINE_VECS + extra_size;
 	struct kmem_cache *slab = NULL;
 	struct bio_slab *bslab;
 	unsigned int i, entry = -1;
-- 
1.6.0.5

