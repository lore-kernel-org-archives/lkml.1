Return-Path: <linux-kernel-owner+w=401wt.eu-S1765114AbXJRK4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765114AbXJRK4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbXJRKzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:55:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40189 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758311AbXJRKzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:55:50 -0400
Date: Thu, 18 Oct 2007 12:54:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tejun Heo <htejun@gmail.com>, Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018105438.GB9658@elte.hu>
References: <20071018070706.GA7435@elte.hu> <471717BF.4030108@pobox.com> <20071018083213.GN5063@kernel.dk> <471720FE.4090004@garzik.org> <20071018091706.GO5063@kernel.dk> <4717281B.6070301@garzik.org> <20071018094128.GP5063@kernel.dk> <47172FB1.5020704@garzik.org> <20071018100959.GQ5063@kernel.dk> <471738A6.2020201@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471738A6.2020201@garzik.org>
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


* Jeff Garzik <jeff@garzik.org> wrote:

> >Tomo and I agreed to kill sg_last() a few days ago anyways, so this 
> >is perfectly fine with me.
> 
> Yep, the [attached] patch that kills ata_sg_is_last() is working here 
> on both machines that were previously croaking.
> 
> It would be nice to get pdc_adma, sata_sil24 and ipr it-works test 
> done, but IMO the patch is pretty straightforward and should be OK.

just a quick question: i have Jens's workarounds applied right now (see 
patch below). Am i now crash/corruption-safe, or do i need your patch 
too? And once your patch [and the other sg_*() patches] are upstream i 
dont need the workaround anymore, correct?

	Ingo

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
