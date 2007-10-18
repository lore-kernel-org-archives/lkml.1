Return-Path: <linux-kernel-owner+w=401wt.eu-S1762755AbXJRLDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762755AbXJRLDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764617AbXJRLDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:03:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40936 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764404AbXJRLDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:03:21 -0400
Date: Thu, 18 Oct 2007 13:03:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018110306.GA14472@elte.hu>
References: <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <20071018070706.GA7435@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018070706.GA7435@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > -#define SCSI_MAX_SG_SEGMENTS	128
> > +#define SCSI_MAX_SG_SEGMENTS	129
> 
> this one finally made the trick and it's booting fine now, without any 
> crashes!

hm, spoke too soon - i just got the ata_qc_issue() crash below. I've 
attached further below the current fixes/workarounds that i have applied 
at the moment. Any ideas?

	Ingo

------------->
[  155.259466] kjournald starting.  Commit interval 5 seconds
[  155.265103] EXT3 FS on sda5, internal journal
[  155.269319] EXT3-fs: mounted filesystem with ordered data mode.
[  156.458225] BUG: unable to handle kernel paging request at virtual address 7d5ac000
[  156.465723] printing eip: 784e9300 *pde = 00ddd027 *pte = 055ac000 
[  156.471964] Oops: 0000 [#1] DEBUG_PAGEALLOC
[  156.476123] 
[  156.477597] Pid: 0, comm: swapper Not tainted (2.6.23 #40)
[  156.483055] EIP: 0060:[<784e9300>] EFLAGS: 00010006 CPU: 0
[  156.488520] EIP is at ata_qc_issue+0xd0/0x340
[  156.492848] EAX: 3d328000 EBX: 7d5ac000 ECX: 00000020 EDX: 00000020
[  156.499087] ESI: 7d5ab480 EDI: 7d5abe00 EBP: 7b54007c ESP: 78a13e1c
[  156.505328]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  156.510700] Process swapper (pid: 0, ti=78a12000 task=789753e0 task.ti=78a12000)
[  156.517893] Stack: 7d5ac000 7b540000 7b540000 00000000 7d5abff0 7b54007c 7d5ab480 7b5417a4 
[  156.526213]        784c2330 784ef49e 784f1ff3 7b52de98 7d5ab480 7b540000 7b5417a4 7d5ab480 
[  156.534531]        7b540000 7b524004 784f20e0 784ef180 784c2330 7d5ab480 00000216 7b524004 
[  156.542851] Call Trace:
[  156.545452]  [<784c2330>] scsi_done+0x0/0x20
[  156.549698]  [<784ef49e>] ata_scsi_translate+0xbe/0x140
[  156.554897]  [<784f1ff3>] ata_scsi_queuecmd+0x33/0x200
[  156.560010]  [<784f20e0>] ata_scsi_queuecmd+0x120/0x200
[  156.565210]  [<784ef180>] ata_scsi_rw_xlat+0x0/0x220
[  156.570150]  [<784c2330>] scsi_done+0x0/0x20
[  156.574395]  [<784c2bb2>] scsi_dispatch_cmd+0x152/0x290
[  156.579596]  [<78135aa7>] trace_hardirqs_on+0x67/0xb0
[  156.584622]  [<784c8abe>] scsi_request_fn+0x1be/0x370
[  156.589649]  [<78407ef6>] blk_run_queue+0x36/0x80
[  156.594328]  [<784c73c0>] scsi_next_command+0x30/0x50
[  156.599354]  [<784c754b>] scsi_end_request+0xab/0xe0
[  156.604294]  [<784c8239>] scsi_io_completion+0xa9/0x3d0
[  156.609493]  [<78135aa7>] trace_hardirqs_on+0x67/0xb0
[  156.614520]  [<78404f85>] blk_done_softirq+0x45/0x80
[  156.619460]  [<78404fb3>] blk_done_softirq+0x73/0x80
[  156.624400]  [<7811d2f3>] __do_softirq+0x53/0xb0
[  156.628992]  [<7811d3b8>] do_softirq+0x68/0x70
[  156.633412]  [<78105351>] do_IRQ+0x51/0x90
[  156.637486]  [<7810290f>] restore_nocheck+0x12/0x15
[  156.642339]  [<7810388e>] common_interrupt+0x2e/0x40
[  156.647277]  [<7810f4c0>] pgd_dtor+0x0/0x50
[  156.651437]  [<7815f1d0>] quicklist_trim+0x0/0x90
[  156.656117]  [<7810f4bb>] check_pgt_cache+0x1b/0x20
[  156.660970]  [<78100c52>] cpu_idle+0x32/0x60
[  156.665217]  [<78a14b35>] start_kernel+0x265/0x300
[  156.669983]  [<78a14380>] unknown_bootoption+0x0/0x1e0
[  156.675096]  =======================
[  156.678649] Code: 84 d9 01 00 00 7e 32 31 d2 89 f6 8b 1c 24 83 c2 01 8b 03 2b 05 18 ed d7 78 c1 f8 05 c1 e0 0c 03 43 04 89 43 08 83 c3 10 89 1c 24 <8b> 03 a8 01 0f 85 58 02 00 00 39 ca 75 d2 f0 83 44 24 00 00 85 
[  156.697455] EIP: [<784e9300>] ata_qc_issue+0xd0/0x340 SS:ESP 0068:78a13e1c
[  156.704822] Kernel panic - not syncing: Fatal exception in interrupt

---
 block/ll_rw_blk.c         |    2 +-
 drivers/ata/libata-core.c |    2 +-
 drivers/scsi/scsi_lib.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/block/ll_rw_blk.c
===================================================================
--- linux.orig/block/ll_rw_blk.c
+++ linux/block/ll_rw_blk.c
@@ -631,7 +631,7 @@ void blk_queue_max_phys_segments(struct 
 		printk("%s: set to minimum %d\n", __FUNCTION__, max_segments);
 	}
 
-	q->max_phys_segments = max_segments;
+	q->max_phys_segments = max_segments - 1;
 }
 
 EXPORT_SYMBOL(blk_queue_max_phys_segments);
Index: linux/drivers/ata/libata-core.c
===================================================================
--- linux.orig/drivers/ata/libata-core.c
+++ linux/drivers/ata/libata-core.c
@@ -4664,7 +4664,7 @@ static int ata_sg_setup(struct ata_queue
 {
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg = qc->__sg;
-	struct scatterlist *lsg = sg_last(qc->__sg, qc->n_elem);
+	struct scatterlist *lsg = &qc->__sg[qc->n_elem - 1];
 	int n_elem, pre_n_elem, dir, trim_sg = 0;
 
 	VPRINTK("ENTER, ata%u\n", ap->print_id);
Index: linux/drivers/scsi/scsi_lib.c
===================================================================
--- linux.orig/drivers/scsi/scsi_lib.c
+++ linux/drivers/scsi/scsi_lib.c
@@ -39,7 +39,7 @@
  * (unless chaining is used). Should ideally fit inside a single page, to
  * avoid a higher order allocation.
  */
-#define SCSI_MAX_SG_SEGMENTS	128
+#define SCSI_MAX_SG_SEGMENTS	129
 
 struct scsi_host_sg_pool {
 	size_t		size;
