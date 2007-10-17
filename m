Return-Path: <linux-kernel-owner+w=401wt.eu-S933918AbXJQUPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918AbXJQUPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757300AbXJQUPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:15:38 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:5818 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbXJQUPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:15:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bGFUIzRWK/bAZp4q46dT8v7R7nLsmRncOKx6FZMSYL22zRRuJZdcavsM8kSN8WOmSStrqYPYlgKstJY4TjV3n4+aV+7lQTbGzuo76tgM4i1Khz6GmDtYnbK+tDKFSKZJ1Jz4v7fIsPFCfQIl9LmLFUcqKx8axocT3P7BUKhlziw=
Date: Wed, 17 Oct 2007 22:15:38 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017201538.GA12484@dreamland.darkstar.lan>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017172932.GI15552@kernel.dk>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Wed, Oct 17, 2007 at 07:29:32PM +0200, Jens Axboe ha scritto: 
> OK, it is fine, as long as the sglist is cleared initially. And I don't
> think there's anyway around that, clearly I didn't think long enough
> before including the memset() removal from Tomo.
> 
> Ingo, please try this rolled up version.
> 
> Linus, this should work. It would probably be best if you first did a
> git revert on f5c0dde4c66421a3a2d7d6fa604a712c9b0744e5 and then applied
> the ll_rw_blk.c bit alone. Do you want me to stuff that (revert + patch)
> into a branch for you to pull?
> 
> diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
> index 9e3f3cc..3935469 100644
> --- a/block/ll_rw_blk.c
> +++ b/block/ll_rw_blk.c
> @@ -1322,8 +1322,8 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
>  		  struct scatterlist *sglist)
>  {
>  	struct bio_vec *bvec, *bvprv;
> -	struct scatterlist *next_sg, *sg;
>  	struct req_iterator iter;
> +	struct scatterlist *sg;
>  	int nsegs, cluster;
>  
>  	nsegs = 0;
> @@ -1333,7 +1333,7 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
>  	 * for each bio in rq
>  	 */
>  	bvprv = NULL;
> -	sg = next_sg = &sglist[0];
> +	sg = NULL;
>  	rq_for_each_segment(bvec, rq, iter) {
>  		int nbytes = bvec->bv_len;
>  
> @@ -1349,8 +1349,10 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
>  			sg->length += nbytes;
>  		} else {
>  new_segment:
> -			sg = next_sg;
> -			next_sg = sg_next(sg);
> +			if (!sg)
> +				sg = sglist;
> +			else
> +				sg = sg_next(sg);
>  
>  			memset(sg, 0, sizeof(*sg));
>  			sg->page = bvec->bv_page;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 0c86be7..aac8a02 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -764,6 +764,8 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
>  		if (unlikely(!sgl))
>  			goto enomem;
>  
> +		memset(sgl, 0, sizeof(*sgl) * sgp->size);
> +
>  		/*
>  		 * first loop through, set initial index and return value
>  		 */
> 

Hi Jens,
I just hit what I believe is the same bug, though with a slightly
different OOPS (I see a NULL pointer dereference, see below). The
patches fixes the bug, and - as Linus suggested - the piece touching
scsi_lib.c is enough.

The OOPS:

scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
 sda1 sda2 sda3 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
ata5.00: ATAPI: MATSHITADVD-RAM UJ-850S, 1.22, max UDMA/33
Unable to handle kernel NULL pointer dereference at 0000000000000020 RIP: 
 [<ffffffff802d275e>] blk_rq_map_sg+0xf6/0x16a
PGD 4711067 PUD 508c067 PMD 0 
Oops: 0000 [1] PREEMPT SMP 
CPU 0 
Modules linked in: sd_mod ohci1394 ehci_hcd ata_piix ieee1394 ahci uhci_hcd libata scsi_mod usbcore thermal processor fan
Pid: 0, comm: swapper Not tainted 2.6.23-ge6d5a11d #3
RIP: 0010:[<ffffffff802d275e>]  [<ffffffff802d275e>] blk_rq_map_sg+0xf6/0x16a
RSP: 0018:ffffffff804eccd8  EFLAGS: 00010087
RAX: 0000000005331000 RBX: ffff810004740220 RCX: ffff810001000000
RDX: 0000000000000000 RSI: ffff8100052d4f50 RDI: 0000000005142c00
RBP: 0000000000001400 R08: 0000000000000000 R09: ffff8100052a3980
R10: 0000000005143000 R11: 0000000000000400 R12: ffff8100047a4000
R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff8049a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000020 CR3: 0000000005118000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff804ac000, task ffffffff8046c340)
Stack:  ffffffff88041834 000000010314ba00 ffff81000477fa80 ffff81000503dd80
 ffff81000503dd80 ffff81000517fc00 000000000000001e 0000000000001d4c
 ffffffff8804193c 0000000015925849 ffff81000473f800 ffff81000503dd80
Call Trace:
 <IRQ>  [<ffffffff88041834>] :scsi_mod:scsi_alloc_sgtable+0xad/0x13c
 [<ffffffff8804193c>] :scsi_mod:scsi_init_io+0x79/0xd9
 [<ffffffff880d1328>] :sd_mod:sd_prep_fn+0x59/0x367
 [<ffffffff802d07ff>] elv_next_request+0xc0/0x14a
 [<ffffffff88042367>] :scsi_mod:scsi_request_fn+0x88/0x356
 [<ffffffff802d46f7>] blk_run_queue+0x41/0x72
 [<ffffffff88041135>] :scsi_mod:scsi_next_command+0x2d/0x39
 [<ffffffff880412ae>] :scsi_mod:scsi_end_request+0xbb/0xc9
 [<ffffffff880415ac>] :scsi_mod:scsi_io_completion+0xf8/0x2d3
 [<ffffffff802d4a83>] blk_done_softirq+0x62/0x6f
 [<ffffffff80238f28>] __do_softirq+0x59/0xc3
 [<ffffffff8020d13c>] call_softirq+0x1c/0x28
 [<ffffffff8020ec26>] do_softirq+0x2c/0x7d
 [<ffffffff80238e30>] irq_exit+0x36/0x81
 [<ffffffff8020edb4>] do_IRQ+0x13d/0x161
 [<ffffffff8020c491>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff88005249>] :processor:acpi_processor_idle+0x2cb/0x496
 [<ffffffff88005245>] :processor:acpi_processor_idle+0x2c7/0x496
 [<ffffffff88004f7e>] :processor:acpi_processor_idle+0x0/0x496
 [<ffffffff8020ad00>] default_idle+0x0/0x3d
 [<ffffffff8020adcd>] cpu_idle+0x90/0xcc
 [<ffffffff804b4a60>] start_kernel+0x2ab/0x2b7
 [<ffffffff804b411b>] _sinittext+0x11b/0x122


Code: 49 8b 40 20 4d 8d 50 20 4c 89 c7 fc b9 08 00 00 00 4c 89 c3 
RIP  [<ffffffff802d275e>] blk_rq_map_sg+0xf6/0x16a
 RSP <ffffffff804eccd8>
CR2: 0000000000000020
Kernel panic - not syncing: Aiee, killing interrupt handler!

Luca
-- 
The trouble with computers is that they do what you tell them, 
not what you want.
D. Cohen
