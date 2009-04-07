Return-Path: <linux-kernel-owner+w=401wt.eu-S1761792AbZDGVlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761792AbZDGVlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761635AbZDGVlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:41:04 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50051 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761641AbZDGVlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=WBVdXSe/NzC//n8b7GigMAeMguGAQYhiUdaEFJg0PtqFSw0W6s4jTWfg8fP56boiVu
         bcpdc4yTS6pfR5f1a7HA/9HJ/lWeWmaRwp6iuMiwmnon8cL/3VF7EJDhWAxdCQ95YLjv
         mnqudKgHnrIiGLsLBeAMgt9h/0VqnWnRuwRgk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
Date: Tue, 7 Apr 2009 23:38:59 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-10247-g8e2c4f2-dirty; KDE/4.2.1; i686; ; )
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@redhat.com,
       David Woodhouse <David.Woodhouse@intel.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <20090402165117.GQ2661@linux.intel.com> <200904022137.35671.bzolnier@gmail.com>
In-Reply-To: <200904022137.35671.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904072339.00224.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 April 2009 21:37:35 Bartlomiej Zolnierkiewicz wrote:
> On Thursday 02 April 2009, Matthew Wilcox wrote:
> > On Thu, Apr 02, 2009 at 08:38:03PM +0400, Sergei Shtylyov wrote:
> > > Hello.
> > >>>> +	task->tf_flags   = IDE_TFLAG_LBA48 | IDE_TFLAG_OUT_HOB |
> > >>>> +			   IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
> > >
> > >>>   The last 3 flags are going to be obsoleted too...
> > >
> > >> So if I remove them today, the command will still work?
> > >
> > >     s/obsoleted/renamed and moved to another other field/ -- I'm going to 
> > > submit a patchset refactoring 'struct ide_cmd and 'struct ide-taskfile' 
> > > at last...
> > 
> > Since I'm coding to today's kernel, not to a patch which doesn't exist
> > yet, taking them out won't work very well.
> > 
> > I've not been paying much attention to drivers/ide, so I've no idea
> > whether the following patch works.  It does at least compile:
> > 
> > +++ b/drivers/ide/ide-disk.c
> > @@ -407,7 +407,7 @@ static void idedisk_prepare_flush(struct request_queue *q, s
> >  static int idedisk_prepare_discard(struct request_queue *q, struct request *rq,
> >                                                         struct bio *bio)
> >  {
> > -       ide_task_t *task;
> > +       struct ide_cmd *task;
> >         unsigned size;
> >         struct page *page = alloc_page(GFP_KERNEL);
> >         if (!page)
> > @@ -432,8 +432,8 @@ static int idedisk_prepare_discard(struct request_queue *q, 
> >  
> >         task->tf_flags   = IDE_TFLAG_LBA48 | IDE_TFLAG_OUT_HOB |
> >                            IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
> > -                          IDE_TFLAG_DYN;
> > -       task->data_phase = TASKFILE_OUT_DMA;
> > +                          IDE_TFLAG_DYN | IDE_TFLAG_WRITE;
> > +       task->protocol = ATA_PROT_DMA;
> >  
> >         rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
> >         rq->special = task;
> > 
> > If I've understood 0dfb991c6943c810175376b58d1c29cfe532541b correctly,
> > this should be equivalent.  Bart?
> 
> Yep.  The final patch looks fine overall (thanks for adding TRIM support
> also to drivers/ide), with the small exception for this chunk:
> 
> @@ -521,6 +567,9 @@ static int set_wcache(ide_drive_t *drive, int arg)
>  
>         update_ordered(drive);
>  
> +       if (ata_id_has_trim(drive->id))
> +               blk_queue_set_discard(drive->queue, idedisk_prepare_discard);
> +
>         return err;
>  }
> 
> as it would fit better somewhere in ide_disk_setup() ISO set_wcache()...
> 
> [ When it comes to CodingStyle issues I don't care that much though I think
>   that applying Sergei's suggestions will make the patch more consistent with
>   the rest of drivers/ide code... ]

I would like to see this merged for -rc1 so I tried to put it altogether
and then integrate it over recent IDE and block changes...

I ended up with the patch below which I'll push to Linus in a few minutes.

Once it hits Linus' tree please test that it still works. :)

Thanks.

From: David Woodhouse <David.Woodhouse@intel.com>
Subject: [PATCH 4/5] ide: Add support for TRIM

Bart: Since this is a new feature and hasn't seen much testing with
production devices it is not enabled by default yet (requires use of
"ide_core.trim=1" kernel parameter).

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
[modified to reduce amount of special casing needed for discard]
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
[bart: apply follow-up changes from Matthew]
[bart: apply CodingStyle fixups per Sergei's suggestion]
[bart: move blk_queue_set_discard() call to ide_disk_setup()]
[bart: port over recent IDE changes]
[bart: remove "bio" argument from idedisk_prepare_discard()]
[bart: s/PAGE_SIZE/PAGE_SIZE + 8/ + set ATA_LBA bit in tf.device]
[bart: add "ide_core.trim=" kernel parameter]
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide.c      |    6 +++++
 2 files changed, 59 insertions(+)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -415,6 +415,54 @@ static void idedisk_prepare_flush(struct
 	rq->special = cmd;
 }
 
+static int idedisk_prepare_discard(struct request_queue *q, struct request *rq)
+{
+	struct ide_cmd *cmd;
+	struct page *page;
+	struct bio *bio = rq->bio;
+	unsigned int size;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		goto error;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		goto free_page;
+
+	size = ata_set_lba_range_entries(page_address(page), PAGE_SIZE / 8,
+					 bio->bi_sector, bio_sectors(bio));
+	bio->bi_size = 0;
+
+	if (bio_add_pc_page(q, bio, page, size, 0) < size)
+		goto free_task;
+
+	cmd->tf.command = ATA_CMD_DSM;
+	cmd->tf.feature = ATA_DSM_TRIM;
+	cmd->tf.nsect   = size / 512;
+	cmd->hob.nsect  = (size / 512) >> 8;
+	cmd->tf.device  = ATA_LBA;
+
+	cmd->valid.out.tf  = IDE_VALID_OUT_TF | IDE_VALID_DEVICE;
+	cmd->valid.out.hob = IDE_VALID_OUT_HOB;
+
+	cmd->tf_flags = IDE_TFLAG_LBA48 | IDE_TFLAG_WRITE | IDE_TFLAG_DYN;
+	cmd->protocol = ATA_PROT_DMA;
+
+	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
+	rq->special = cmd;
+	rq->nr_sectors = size / 512;
+
+	return 0;
+
+ free_task:
+	kfree(cmd);
+ free_page:
+	__free_page(page);
+ error:
+	return -ENOMEM;
+}
+
 ide_devset_get(multcount, mult_count);
 
 /*
@@ -606,6 +654,8 @@ static int ide_disk_check(ide_drive_t *d
 	return 1;
 }
 
+extern int ide_trim;
+
 static void ide_disk_setup(ide_drive_t *drive)
 {
 	struct ide_disk_obj *idkp = drive->driver_data;
@@ -693,6 +743,9 @@ static void ide_disk_setup(ide_drive_t *
 
 	set_wcache(drive, 1);
 
+	if (ata_id_has_trim(id) && ide_trim)
+		blk_queue_set_discard(q, idedisk_prepare_discard);
+
 	if ((drive->dev_flags & IDE_DFLAG_LBA) == 0 &&
 	    (drive->head == 0 || drive->head > 16)) {
 		printk(KERN_ERR "%s: invalid geometry: %d physical heads?\n",
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -178,6 +178,12 @@ EXPORT_SYMBOL_GPL(ide_pci_clk);
 module_param_named(pci_clock, ide_pci_clk, int, 0);
 MODULE_PARM_DESC(pci_clock, "PCI bus clock frequency (in MHz)");
 
+int ide_trim = 0;
+EXPORT_SYMBOL_GPL(ide_trim);
+
+module_param_named(trim, ide_trim, int, 0);
+MODULE_PARM_DESC(trim, "TRIM support (0=off, 1=on)");
+
 static int ide_set_dev_param_mask(const char *s, struct kernel_param *kp)
 {
 	int a, b, i, j = 1;


