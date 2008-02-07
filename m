Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbYBGKt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbYBGKt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbYBGKts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:49:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60073 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbYBGKtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:49:46 -0500
Date: Thu, 7 Feb 2008 11:49:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alan.Brunelle@hp.com, arjan@linux.intel.com,
       dgc@sgi.com, npiggin@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@gmail.com>
Subject: [patch] block layer: kmemcheck fixes
Message-ID: <20080207104901.GF16735@elte.hu>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <1202375945-29525-5-git-send-email-jens.axboe@oracle.com> <20080207100738.GB7716@elte.hu> <20080207101727.GE15220@kernel.dk> <20080207102534.GB16735@elte.hu> <20080207103136.GG15220@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207103136.GG15220@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> [...] but may not post anything until after my vacation.

oh, you going on a vacation. I am sitting on a few block layer patches 
you might be interested in :-)

i am playing with Vegard Nossum's kmemcheck on x86 (with much help from 
Pekka Enberg for the SLUB details) and it's getting quite promising. 
Kmemcheck is in essence Valgrind for the native kernel - it is "Da Bomb" 
in terms of kernel object lifetime and access validation debugging 
helpers.

it promptly triggered a few uninitialized accesses in the block layer 
(amongst others), resulting in the following 4 fixes (find them below):

  block: restructure rq_init() to make it safer
  block: fix access to uninitialized field
  block: initialize rq->tag
  block: rq->cmd* initialization

i _think_ the actual uninitialized memory accesses are only latent bugs 
not actual runtime bugs because they relate to SCSI init sequences that 
do not truly need the elevator's attention - but rq_init() sure looked a 
bit dangerous in this regard and the elv_next_request() access to those 
uninitialized fields is not nice.

Do these fixes look good to you? I had them in testing for a few days 
already.

	Ingo

--------------------->
Subject: block: restructure rq_init() to make it safer
From: Ingo Molnar <mingo@elte.hu>

reorder the initializations done in rq_init() to both align them
to memory order, and to document them better. They now match
the field ordering of "struct request" in blkdev.h.

No change in functionality:

      text    data     bss     dec     hex filename
      8426       0      20    8446    20fe blk-core.o.before
      8426       0      20    8446    20fe blk-core.o.after

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 block/blk-core.c |   51 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 16 deletions(-)

Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c
+++ linux/block/blk-core.c
@@ -106,24 +106,43 @@ void rq_init(struct request_queue *q, st
 {
 	INIT_LIST_HEAD(&rq->queuelist);
 	INIT_LIST_HEAD(&rq->donelist);
-
-	rq->errors = 0;
-	rq->bio = rq->biotail = NULL;
+	rq->q				= q;
+	/* rq->cmd_flags			*/
+	/* rq->cmd_type				*/
+	/* rq->sector				*/
+	/* rq->hard_sector			*/
+	/* rq->nr_sectors			*/
+	/* rq->hard_nr_sectors			*/
+	/* rq->current_nr_sectors		*/
+	/* rq->hard_cur_sectors			*/
+	rq->bio				= NULL;
+	rq->biotail			= NULL;
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
-	rq->ioprio = 0;
-	rq->buffer = NULL;
-	rq->ref_count = 1;
-	rq->q = q;
-	rq->special = NULL;
-	rq->data_len = 0;
-	rq->data = NULL;
-	rq->nr_phys_segments = 0;
-	rq->sense = NULL;
-	rq->end_io = NULL;
-	rq->end_io_data = NULL;
-	rq->completion_data = NULL;
-	rq->next_rq = NULL;
+	rq->completion_data		= NULL;
+	/* rq->elevator_private			*/
+	/* rq->elevator_private2		*/
+	/* rq->rq_disk				*/
+	/* rq->start_time			*/
+	rq->nr_phys_segments		= 0;
+	/* rq->nr_hw_segments			*/
+	rq->ioprio			= 0;
+	rq->special			= NULL;
+	rq->buffer			= NULL;
+	/* rq->tag				*/
+	rq->errors			= 0;
+	rq->ref_count			= 1;
+	/* rq->cmd_len				*/
+	/* rq->cmd[]				*/
+	rq->data_len			= 0;
+	/* rq->sense_len			*/
+	rq->data			= NULL;
+	rq->sense			= NULL;
+	/* rq->timeout				*/
+	/* rq->retries				*/
+	rq->end_io			= NULL;
+	rq->end_io_data			= NULL;
+	rq->next_rq			= NULL;
 }
 
 static void req_bio_endio(struct request *rq, struct bio *bio,
Subject: block: fix access to uninitialized field
From: Ingo Molnar <mingo@elte.hu>

kmemcheck caught the following uninitialized memory access in the
block layer:

kmemcheck: Caught uninitialized read:
 EIP = c020e596 (elv_next_request+0x63/0x154), address f74985dc, size 32

Pid: 1, comm: swapper Not tainted (2.6.24 #5)
EIP: 0060:[<c020e596>] EFLAGS: 00010046 CPU: 0
EIP is at elv_next_request+0x63/0x154
EAX: 00000000 EBX: f74b83b0 ECX: 00000002 EDX: 00000000
ESI: f74985c0 EDI: f7c5bbf0 EBP: f7c5bc00 ESP: f7c5bbf0
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
CR0: 8005003b CR2: f74985dc CR3: 0060c000 CR4: 000006c0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff4ff0 DR7: 00000400
 [<c02d27e8>] scsi_request_fn+0x74/0x28e
 [<c020fd2e>] __generic_unplug_device+0x1d/0x20
 [<c0211bb4>] blk_execute_rq_nowait+0x50/0x5c
 [<c0211c26>] blk_execute_rq+0x66/0x83
 [<c0211c43>] ? blk_end_sync_rq+0x0/0x29
 [<c01151fd>] ? hide_addr+0x32/0x72
 [<c0115275>] ? kmemcheck_hide+0x38/0x67
 [<c0431650>] ? do_debug+0x3d/0x105
 [<c04312cf>] ? debug_stack_correct+0x27/0x2c
 [<c02d1e51>] scsi_execute+0xc0/0xed
 [<c02d1ece>] scsi_execute_req+0x50/0x9d
 [<c02d33dd>] scsi_probe_and_add_lun+0x1a3/0x7d1
 [<c0431650>] ? do_debug+0x3d/0x105
 [<c0270024>] ? hwrng_register+0xc3/0x147
 [<c02d465a>] __scsi_add_device+0x8a/0xb7
 [<c031e52d>] ata_scsi_scan_host+0x9d/0x2c3
 [<c031b577>] ata_host_register+0x21b/0x239
 [<c03201b2>] ata_pci_activate_sff_host+0x17c/0x1a6
 [<c031c764>] ? ata_interrupt+0x0/0x214
 [<c032061c>] ata_pci_init_one+0x9b/0xef
 [<c032e3d7>] amd_init_one+0x171/0x179
 [<c0226e82>] pci_device_probe+0x39/0x63
 [<c027d966>] driver_probe_device+0xb8/0x14d
 [<c027dafe>] __driver_attach+0x59/0x88
 [<c027ce3b>] bus_for_each_dev+0x41/0x64
 [<c027d7f3>] driver_attach+0x17/0x19
 [<c027daa5>] ? __driver_attach+0x0/0x88
 [<c027d5db>] bus_add_driver+0xa8/0x1ed
 [<c027dcbb>] driver_register+0x55/0xc4
 [<c0227036>] __pci_register_driver+0x2e/0x5c
 [<c05e110d>] amd_init+0x17/0x19
 [<c05c66c8>] kernel_init+0xba/0x1fa
 [<c05c660e>] ? kernel_init+0x0/0x1fa
 [<c010578f>] kernel_thread_helper+0x7/0x10
 =======================
kmemcheck: Caught uninitialized read from EIP = c02d16aa (scsi_get_cmd_from_req+0x28/0x3c), address f7498630, size 32

which corresponds to:

0xc020e596 is in elv_next_request (block/elevator.c:746).
  741                             rq->cmd_flags |= REQ_STARTED;
  742                             blk_add_trace_rq(q, rq, BLK_TA_ISSUE);
  743                     }
  744
  745                     if (!q->boundary_rq || q->boundary_rq == rq) {
  746                             q->end_sector = rq_end_sector(rq);
  747                             q->boundary_rq = NULL;
  748                     }
  749
  750                     if (rq->cmd_flags & REQ_DONTPREP)

the problem is that during ATA probing, we pass in a half-initialized
request structure to the block layer, which processes it. While this is
probably harmless in itself (probe requests often have no real 'sector'
field), it could be more fatal in other cases.

so be defensive and initialize the sector fields. We use -10000LL,
because that's better than an accidental IO to sector 0 ...

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 block/blk-core.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c
+++ linux/block/blk-core.c
@@ -102,6 +102,8 @@ struct backing_dev_info *blk_get_backing
 }
 EXPORT_SYMBOL(blk_get_backing_dev_info);
 
+#define ILLEGAL_SECTOR -1000LL
+
 void rq_init(struct request_queue *q, struct request *rq)
 {
 	INIT_LIST_HEAD(&rq->queuelist);
@@ -109,12 +111,12 @@ void rq_init(struct request_queue *q, st
 	rq->q				= q;
 	/* rq->cmd_flags			*/
 	/* rq->cmd_type				*/
-	/* rq->sector				*/
-	/* rq->hard_sector			*/
-	/* rq->nr_sectors			*/
-	/* rq->hard_nr_sectors			*/
-	/* rq->current_nr_sectors		*/
-	/* rq->hard_cur_sectors			*/
+	rq->sector			= ILLEGAL_SECTOR;
+	rq->hard_sector			= ILLEGAL_SECTOR;
+	rq->nr_sectors			= 0;
+	rq->hard_nr_sectors		= 0;
+	rq->current_nr_sectors		= 0;
+	rq->hard_cur_sectors		= 0;
 	rq->bio				= NULL;
 	rq->biotail			= NULL;
 	INIT_HLIST_NODE(&rq->hash);
Subject: block: initialize rq->tag
From: Ingo Molnar <mingo@elte.hu>

kmemcheck (valgrind for the native Linux kernel) caught a 32-bit read
to an uninitialized piece of memory in the block/SCSI layer:

ata2.01: configured for UDMA/33
kmemcheck: Caught uninitialized 32-bit read:
=> from EIP = c02d3386 (scsi_get_cmd_from_req+0x28/0x3c), address f7dc0d38

Pid: 1, comm: swapper Not tainted (2.6.24 #6)
EIP: 0060:[<c02d3386>] EFLAGS: 00010086 CPU: 0
EIP is at scsi_get_cmd_from_req+0x28/0x3c
EAX: f749a800 EBX: f7dc0cc0 ECX: f74b801c EDX: f749a800
ESI: f74b8000 EDI: f7c5bbf0 EBP: f7c5bbbc ESP: f7c5bbb8
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
CR0: 8005003b CR2: f7dc0d38 CR3: 00610000 CR4: 000006c0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff4ff0 DR7: 00000400
 [<c02d36ca>] scsi_setup_blk_pc_cmnd+0x26/0x101
 [<c02d37c6>] scsi_prep_fn+0x21/0x30
 [<c020fc77>] elv_next_request+0xb3/0x15f
 [<c02d44d6>] scsi_request_fn+0x74/0x28e
 [<c0211541>] __generic_unplug_device+0x1d/0x20
 [<c02133d4>] blk_execute_rq_nowait+0x50/0x5c
 [<c0213449>] blk_execute_rq+0x69/0x86
 [<c0213466>] ? blk_end_sync_rq+0x0/0x2a
 [<c011520b>] ? hide_addr+0x32/0x72
 [<c0115283>] ? kmemcheck_hide+0x38/0x67
 [<c0433da0>] ? do_debug+0x3d/0x105
 [<c0433a1f>] ? debug_stack_correct+0x27/0x2c
 [<c02d3b33>] scsi_execute+0xc3/0xf3
 [<c02d3bb3>] scsi_execute_req+0x50/0x9d
 [<c02d50c9>] scsi_probe_and_add_lun+0x1a3/0x7d1
 [<c0433da0>] ? do_debug+0x3d/0x105
 [<c0270024>] ? rtc_do_ioctl+0x66d/0x7a2
 [<c02d6346>] __scsi_add_device+0x8a/0xb7
 [<c0320838>] ata_scsi_scan_host+0x9d/0x2c3
 [<c031d837>] ata_host_register+0x21b/0x239
 [<c03224be>] ata_pci_activate_sff_host+0x17c/0x1a6
 [<c031ea24>] ? ata_interrupt+0x0/0x214
 [<c0322928>] ata_pci_init_one+0x9b/0xef
 [<c03306e3>] amd_init_one+0x171/0x179
 [<c0228a42>] pci_device_probe+0x39/0x63
 [<c027f526>] driver_probe_device+0xb8/0x14d
 [<c027f6be>] __driver_attach+0x59/0x88
 [<c027e9fb>] bus_for_each_dev+0x41/0x64
 [<c027f3b3>] driver_attach+0x17/0x19
 [<c027f665>] ? __driver_attach+0x0/0x88
 [<c027f19b>] bus_add_driver+0xa8/0x1ed
 [<c027f87b>] driver_register+0x55/0xc4
 [<c0228bf6>] __pci_register_driver+0x2e/0x5c
 [<c05e4df2>] amd_init+0x17/0x19
 [<c05ca6cb>] kernel_init+0xba/0x1fa
 [<c05ca611>] ? kernel_init+0x0/0x1fa
 [<c010578f>] kernel_thread_helper+0x7/0x10
 =======================

while it's probably harmless for probing functions, be defensive and
initialize rq->tag to -1 explicitly.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 block/blk-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c
+++ linux/block/blk-core.c
@@ -131,7 +131,7 @@ void rq_init(struct request_queue *q, st
 	rq->ioprio			= 0;
 	rq->special			= NULL;
 	rq->buffer			= NULL;
-	/* rq->tag				*/
+	rq->tag				= -1;
 	rq->errors			= 0;
 	rq->ref_count			= 1;
 	/* rq->cmd_len				*/
Subject: block: rq->cmd* initialization
From: Ingo Molnar <mingo@elte.hu>

kmemcheck found the following uninitialized 32-bit read:

kmemcheck: Caught uninitialized 32-bit read:
=> from EIP = c02d3747 (scsi_setup_blk_pc_cmnd+0xa3/0x101), address f7dc0d4c

Pid: 1, comm: swapper Not tainted (2.6.24 #7)
EIP: 0060:[<c02d3747>] EFLAGS: 00010082 CPU: 0
EIP is at scsi_setup_blk_pc_cmnd+0xa3/0x101
EAX: 00000000 EBX: f7dc0cc0 ECX: f7fd0300 EDX: f7fd0300
ESI: f7dc0d4c EDI: f7496838 EBP: f7c5bbd8 ESP: f7c5bbc4
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
CR0: 8005003b CR2: f7dc0d4c CR3: 00610000 CR4: 000006c0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff4ff0 DR7: 00000400
 [<c02d37c6>] scsi_prep_fn+0x21/0x30
 [<c020fc77>] elv_next_request+0xb3/0x15f
 [<c02d44d6>] scsi_request_fn+0x74/0x28e
 [<c0211548>] __generic_unplug_device+0x1d/0x20
 [<c02133d8>] blk_execute_rq_nowait+0x50/0x5c
 [<c021344d>] blk_execute_rq+0x69/0x86
 [<c021346a>] ? blk_end_sync_rq+0x0/0x2a
 [<c011520b>] ? hide_addr+0x32/0x72
 [<c0115283>] ? kmemcheck_hide+0x38/0x67
 [<c0433da0>] ? do_debug+0x3d/0x105
 [<c0433a1f>] ? debug_stack_correct+0x27/0x2c
 [<c02d3b33>] scsi_execute+0xc3/0xf3
 [<c02d3bb3>] scsi_execute_req+0x50/0x9d
 [<c02d50c9>] scsi_probe_and_add_lun+0x1a3/0x7d1
 [<c0433da0>] ? do_debug+0x3d/0x105
 [<c0270024>] ? rtc_do_ioctl+0x66d/0x7a2
 [<c02d6346>] __scsi_add_device+0x8a/0xb7
 [<c0320838>] ata_scsi_scan_host+0x9d/0x2c3
 [<c031d837>] ata_host_register+0x21b/0x239
 [<c03224be>] ata_pci_activate_sff_host+0x17c/0x1a6
 [<c031ea24>] ? ata_interrupt+0x0/0x214
 [<c0322928>] ata_pci_init_one+0x9b/0xef
 [<c03306e3>] amd_init_one+0x171/0x179
 [<c0228a42>] pci_device_probe+0x39/0x63
 [<c027f526>] driver_probe_device+0xb8/0x14d
 [<c027f6be>] __driver_attach+0x59/0x88
 [<c027e9fb>] bus_for_each_dev+0x41/0x64
 [<c027f3b3>] driver_attach+0x17/0x19
 [<c027f665>] ? __driver_attach+0x0/0x88
 [<c027f19b>] bus_add_driver+0xa8/0x1ed
 [<c027f87b>] driver_register+0x55/0xc4
 [<c0228bf6>] __pci_register_driver+0x2e/0x5c
 [<c05e5136>] amd_init+0x17/0x19
 [<c05ca6c8>] kernel_init+0xba/0x1fa
 [<c05ca60e>] ? kernel_init+0x0/0x1fa
 [<c010578f>] kernel_thread_helper+0x7/0x10
 =======================

while it's harmless here, initialize rq->cmd* properly nevertheless.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 block/blk-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c
+++ linux/block/blk-core.c
@@ -134,8 +134,8 @@ void rq_init(struct request_queue *q, st
 	rq->tag				= -1;
 	rq->errors			= 0;
 	rq->ref_count			= 1;
-	/* rq->cmd_len				*/
-	/* rq->cmd[]				*/
+	rq->cmd_len			= 0;
+	memset(rq->cmd, 0, BLK_MAX_CDB);
 	rq->data_len			= 0;
 	/* rq->sense_len			*/
 	rq->data			= NULL;
